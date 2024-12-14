import sys
import re
import struct
from constants import CONDITION_CODES, OPERATION_CODES, INSTRUCTION_CLASSES, REGISTER_CODES, BIT_MANIPULATION_METHODS

class Assembler:
    def __init__(self):
        self.cleanedLines = []
        self.machineInstructions = []
        self.definitions = {}
        self.labels = {}
        self.PC = 0

    def readFile(self, filePath):
        cleanedLines = []  # List to store cleaned lines
        try:
            with open(filePath, "r") as asmFile:
                for line in asmFile:
                    # Strip leading/trailing whitespace
                    cleanLine = line.strip()
                    
                    # Remove comments (assuming ';' indicates a comment)
                    if ';' in cleanLine:
                        cleanLine = cleanLine.split(';', 1)[0].strip()
                    
                    # Add to list only if the line is not empty
                    cleanedLines.append(self._splitString(cleanLine.upper()))


            self.cleanedLines = cleanedLines
            
        except FileNotFoundError:
            print(f"Error: File '{filePath}' not found.")
            return []
        except Exception as e:
            print(f"An error occurred: {e}")
            return []
        
    def createBinFile(self, filePath):
        if len(self.machineInstructions) == 0:
            print("Nothing to write. Assembly file does not contain any commands.")
            return
        try:
            with open(filePath, "wb") as f:
                for number in self.machineInstructions:
                    # Pack the integer as a 32-bit signed value ('i' format)
                    binaryData = struct.pack("I", number)
                    f.write(binaryData)
            print(f"Successfully saved {len(self.machineInstructions)} instructions to {filePath}")
        except Exception as e:
            print(f"Error: {e}")
            return
        
    def createVHDL_MemoryInitCode(self, filePath):
        if len(self.machineInstructions) == 0:
            print("Nothing to write. Assembly file does not contain any commands.")
            return
        try:
            vhdlString = "    signal ram : ram_type :=(\n"
            memAddress = 0
            for instruction in self.machineInstructions:
                instructionString = f"{instruction:032b}"
                for i in range(4):
                    byteNum = memAddress%4
                    byte = instructionString[byteNum*8:(byteNum+1)*8]
                    vhdlString = vhdlString + f"        {byteNum} => \"{byte}\",\n"
                    memAddress = memAddress + 1
            vhdlString = vhdlString + "        others => (others => '0')\n    );"
            with open(filePath, "w") as file:
                file.write(vhdlString)
        except Exception as e:
            print(f"Error: {e}")
            return
         
    def createMachineCode(self):
        #replace all definitions with the appropriate values first
        for i, line in enumerate(self.cleanedLines):
            if  len(line)>0:
                if line[0] == "DEFINE":
                    if len(line) == 3:
                        self.definitions[line[1]] = line[2]
                        print(f"Created Defintion for '{line[1]}'")
                    else:
                        print(f"Error parsing line {i+1}: DEFINE needs 2 parameters, found {len(line)-1}.")
                        sys.exit()

                else:
                    for i in range(len(line)):
                        if line[i] in self.definitions:
                            print(f"Replaced {line[i]} with {self.definitions[line[i]]}")
                            line[i] = self.definitions[line[i]]
                        


        for i, line in enumerate(self.cleanedLines):
            currentInstruction = 0x00000000 #default value
            if line == []: #continue on empty lines
                continue

            elif line[0] == "DEFINE":
                continue

            elif len(line) == 2 and line[1][0] == ":": 
                if line[0] in self.labels:
                    print(f"Error parsing line {i+1}: Label '{line[0]}' does already exist.")
                    sys.exit()
                else:
                    self.labels[line[0]] = self.PC
            

            elif len(line[0]) < 3:
                print(f"Error parsing line {i+1}: Command '{line[0]}' does not exist.")
                sys.exit()
            
            elif (line[0][-2:] in CONDITION_CODES and line[0][:-2] in OPERATION_CODES) or line[0] in OPERATION_CODES:
                if line[0][-2:] in CONDITION_CODES and line[0][:-2] in OPERATION_CODES:
                    conditionCode = CONDITION_CODES[line[0][-2:]]
                    command = line[0][:-2]
                else:
                    conditionCode = 0b1111
                    command = line[0]
                currentInstruction = currentInstruction | (conditionCode << 28)
                instructionClass = INSTRUCTION_CLASSES[command]
                currentTokenIndex = 1
                numTokens = len(line)

                if instructionClass == "Data Processing":
                    pass

                elif instructionClass == "Data Movement":
                    #add instruction class code to current instruction
                    currentInstruction = currentInstruction | (0b00 << 26) #does nothing, added for understanding

                    opCode = OPERATION_CODES[command]
                    #add opCode to current instruction
                    currentInstruction = currentInstruction | (opCode << 23)

                    #check if result should be written back and set write back bit
                    if command[-1] == "W":
                        currentInstruction = currentInstruction | (0b1 << 22)

                    #add source/destination register to instruction
                    if numTokens < currentTokenIndex + 1:
                        print(f"Error parsing line {i+1}: Too few parameters")
                        sys.exit()
                    elif line[currentTokenIndex] in REGISTER_CODES :
                        currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]])
                        currentTokenIndex = currentTokenIndex + 1
                    else:
                        print(f"Error parsing line {i+1}: '{line[currentTokenIndex]}' is not a valid register.")
                        sys.exit()

                    #check if next token is a comma
                    if numTokens < currentTokenIndex + 1:
                        print(f"Error parsing line {i+1}: Too few parameters")
                        sys.exit()
                    elif line[currentTokenIndex] == ",":
                        currentTokenIndex = currentTokenIndex + 1
                    else:
                        print(f"Error parsing line {i+1}: Expected ',' instead of '{line[currentTokenIndex]}'.")
                        sys.exit()

                    #check if next token is a [
                    if numTokens < currentTokenIndex + 1:
                        print(f"Error parsing line {i+1}: Too few parameters")
                        sys.exit()
                    elif line[currentTokenIndex] == "[":
                        currentTokenIndex = currentTokenIndex + 1
                    else:
                        print(f"Error parsing line {i+1}: Expected '[' instead of '{line[currentTokenIndex]}'.")
                        sys.exit()

                    #add address register to instruction
                    if numTokens < currentTokenIndex + 1:
                        print(f"Error parsing line {i+1}: Too few parameters")
                        sys.exit()
                    elif line[currentTokenIndex] in REGISTER_CODES and not line[currentTokenIndex] == "CPSR":
                        currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 5)
                        currentTokenIndex = currentTokenIndex + 1
                    elif line[currentTokenIndex] == "CPSR":
                        print(f"Error parsing line {i+1}: 'CPSR' cannot be used as address register.")
                        sys.exit()
                    else:
                        print(f"Error parsing line {i+1}: '{line[currentTokenIndex]}' is not a valid register.")
                        sys.exit()


                    if numTokens < currentTokenIndex + 1:
                        print(f"Error parsing line {i+1}: Too few parameters")
                        sys.exit()

                    #continue with offset 
                    elif line[currentTokenIndex] in ["+", "-"]:
                        #set offset enable bit
                        currentInstruction = currentInstruction | (0b1 << 21)
                        #set subtract bit if token is '-'
                        if line[currentTokenIndex] == "-":
                            currentInstruction = currentInstruction | (0b1 << 20)
                        currentTokenIndex = currentTokenIndex + 1
                        
                        #add offset to address
                        if numTokens < currentTokenIndex + 1:
                            print(f"Error parsing line {i+1}: Too few parameters")
                            sys.exit()
                        else:
                            offset, error = self._createBinaryNumber(length = 11, numberString=line[currentTokenIndex])
                            if not error == None:
                                print(f"Error parsing line {i+1}: {error}")
                                sys.exit()
                            else:
                                currentInstruction = currentInstruction | (offset << 9)
                                currentTokenIndex = currentTokenIndex + 1

                        #check if last token is a ']'
                        if numTokens < currentTokenIndex + 1:
                            print(f"Error parsing line {i+1}: Too few parameters")
                            sys.exit()
                        elif line[currentTokenIndex] == "]":
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            print(f"Error parsing line {i+1}: Expected ']' instead of '{line[currentTokenIndex]}'.")
                            sys.exit()

                        #make sure there are no additional tokens left and add instruction to the list of instructions
                        if not numTokens == currentTokenIndex:
                            print(f"Error parsing line {i+1}: Too many parameters")
                            sys.exit()
                        else:
                            self.machineInstructions.append(currentInstruction)
                            continue


                    #continue without offset
                    elif line[currentTokenIndex] == "]":
                        currentTokenIndex = currentTokenIndex + 1

                        #if end of line is reached, add instruction the list of instructions and continue to next instruction
                        if numTokens == currentTokenIndex:
                            self.machineInstructions.append(currentInstruction)
                            continue
                        elif line[currentTokenIndex] == ",":
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            print(f"Error parsing line {i+1}: Expected ',' instead of '{line[currentTokenIndex]}'.")
                            sys.exit()

                        #check if there are at least 2 tokens left and add bit manipulation codes to current instruction
                        if numTokens < currentTokenIndex + 2:
                            print(f"Error parsing line {i+1}: Too few parameters")
                            sys.exit()
                        else:
                            manipulationMethod = line[currentTokenIndex]
                            manipulationValue  = line[currentTokenIndex+1]

                            bitManipulationBits, error = self._createBitManipulationMethodBits(manipulationMethod=manipulationMethod, value=manipulationValue)
                            if not error == None:
                                print(f"Error parsing line {i+1}: {error}")
                                sys.exit()
                            else:
                                currentInstruction = currentInstruction | (bitManipulationBits << 9)
                                currentTokenIndex = currentTokenIndex + 2

                            #make sure there are no additional tokens left and add instruction to the list of instructions
                            if not numTokens == currentTokenIndex:
                                print(f"Error parsing line {i+1}: Too many parameters")
                                sys.exit()
                            else:
                                self.machineInstructions.append(currentInstruction)
                                continue

                    else:
                        print(f"Error parsing line {i+1}: Expected ']' or '+/-' instead of '{line[currentTokenIndex]}'.")
                        sys.exit()



                elif instructionClass == "Special Instructions":
                    pass

                elif instructionClass == "Control Flow":
                    pass

                else:
                    print(f"Instruction class '{instructionClass}' does not exist")
                    sys.exit()

        
            else:
                print(f"Error parsing line {i+1}: Command '{line[0]}' does not exist.")
                sys.exit()
            


        print("Parsed file successfully, no errors detected.")


    def _replaceBits(self, value, replacement, start, end):
        # Step 1: Calculate the length of the bit range
        length = (end - start + 1)
        
        # Step 2: Create a mask to clear the target bit range
        mask = ((1 << length) - 1) << start  # Mask for the target range
        valueCreated = value & ~mask        # Clear bits in the target range

        # Step 3: Insert the replacement bits into the cleared range
        replacementShifted = (replacement & ((1 << length) - 1)) << start
        result = valueCreated | replacementShifted  # Combine the values

        return result
    
    def _splitString(self, s):
        # Regular expression to match words or special characters
        tokens = re.findall(r'\w+|[^\w\s]', s)
        return tokens
    
    def _createBinaryNumber(self, length, numberString):
        try:
            # Determine the base of the number
            if numberString.startswith(("0x", "0X")):  # Hexadecimal
                value = int(numberString, 16)
            elif numberString.startswith(("0b", "0B")):  # Binary
                value = int(numberString, 2)
            else:  # Assume decimal
                value = int(numberString)
            
            # Check if the value fits in the specified bit width
            maxValue = (1 << length) - 1  # Max unsigned value for given length
            minValue = 0  # Min unsigned value is always 0
            
            if not (minValue <= value <= maxValue):
                return None, f"Value '{numberString}' out of range (max value: '{maxValue}')."

            return value, None  # No errors occurred

        except ValueError:
            return None, f"'{numberString}' is not a valid number"
        
    def _createBitManipulationMethodBits(self, manipulationMethod, value):
        bitManipulationBits = 0
        if not manipulationMethod in BIT_MANIPULATION_METHODS:
            error = f"'{manipulationMethod}' is not a valid manipulation method."
            return None, error
        
        immediateEnable = 0
        if value in REGISTER_CODES and not value == "CPSR":
            value = REGISTER_CODES[value]
        elif value == "CPSR":
            error = f"'CPSR' cannot be used as an operand for bit manipulation."
            return None, error
        else:
            value, error = self._createBinaryNumber(length=5, numberString=value)
            if not error == None:
                return None, error
            immediateEnable = 1
            
        bitManipulationBits = bitManipulationBits | (BIT_MANIPULATION_METHODS[manipulationMethod]<<6)
        bitManipulationBits = bitManipulationBits | immediateEnable << 5
        bitManipulationBits = bitManipulationBits | value

        return bitManipulationBits, None
