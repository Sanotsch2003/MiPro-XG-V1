import sys
import re
import struct
from mipro_toolkit.Assembler.constants import *

class Assembler:
    def __init__(self):
        self.cleanedLines = []
        self.machineInstructions = []
        self.definitions = {}
        self.labels = {}
        self.labelsToResolve = []
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
            sys.exit()
        except Exception as e:
            print(f"An error occurred: {e}")
            sys.exit()
        
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
        
    def createVHDL_MemoryInitFile(self, filePath):
        if len(self.machineInstructions) == 0:
            print("Nothing to write. Assembly file does not contain any commands.")
            return
        try:
            vhdlString = "    signal ram : ram_type :=(\n"
            memAddress = 0
            for instruction in self.machineInstructions:
                instructionString = f"{instruction:032b}"
                vhdlString = vhdlString + f"        {memAddress} => \"{instructionString}\",\n"
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
                self.PC = self.PC + 1

                if instructionClass == "Data Processing":
                    #add instruction class code to current instruction
                    currentInstruction = currentInstruction | (0b1 << 27)

                    opCode = OPERATION_CODES[command]
                    #add opCode to current instruction
                    currentInstruction = currentInstruction | (opCode << 23)
                    
                    #handle move command seperately because it works differently from the other data processing commands
                    if command == "MOV":

                        #add source register to instruction
                        if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="register", quitOnError=True):
                            sourceRegister = REGISTER_CODES[line[currentTokenIndex]]
                            currentInstruction = currentInstruction | sourceRegister
                            currentTokenIndex = currentTokenIndex + 1

                        #check if next token is a comma
                        if self._checkToken([','], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                            currentTokenIndex = currentTokenIndex + 1

                        #check if next token is a register
                        if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="register", quitOnError=False):
                            currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 5)
                            currentTokenIndex = currentTokenIndex + 1

                            #check if end of line has been reached
                            if numTokens == currentTokenIndex:
                                self.machineInstructions.append(currentInstruction)
                                continue

                            #check if next token is a comma
                            if self._checkToken([','], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                                currentTokenIndex = currentTokenIndex + 1

                            #check for valid bit manipulation method 
                            bitManipulationBits, error = self._createBitManipulationMethodBits(numTokens, currentTokenIndex, line)
                            if not error == None:
                                print(f"Error parsing line {i+1}: {error}")
                                sys.exit()
                            else:
                                currentInstruction = currentInstruction | (bitManipulationBits << 13)
                                currentTokenIndex = currentTokenIndex + 2

                            #making sure there are no additional tokens left and add instruction to the list of instructions
                            if not numTokens == currentTokenIndex:
                                print(f"Error parsing line {i+1}: Too many parameters")
                                sys.exit()
                            else:
                                self.machineInstructions.append(currentInstruction)
                                continue
                        else:
                            #set immediate enable bit
                            currentInstruction = currentInstruction | (0b1 << 22)
                            #check if token is a valid 16 bit number
                            if numTokens < currentTokenIndex + 1:
                                print(f"Error parsing line {i+1}: Too few parameters")
                                sys.exit()
                            value, error = self._createBinaryNumber(16, line[currentTokenIndex])
                            isSixteenBit = True
                            if not error == None:
                                #check if token is a valid 32 bit number
                                value, error = self._createBinaryNumber(32, line[currentTokenIndex])
                                isSixteenBit = False
                                if not error == None:
                                    print(f"Error parsing line {i+1}: {error}")
                                    sys.exit()

                            lowerBits = value & 0x0000FFFF
                            upperBits = (value & 0xFFFF0000) >> 16

                            secondLoadInstruction = currentInstruction #create second MOV instructions that will be used if the immediate value is greater than 16 bit

                            #add immediate value to instruction and add instruction to program
                            currentInstruction = currentInstruction | (lowerBits << 5)
                            self.machineInstructions.append(currentInstruction)

                            #load the reset of the value into the register if necessary
                            if not isSixteenBit:
                                secondLoadInstruction = 0b11111101111000000000000000001100 | (upperBits << 5) #helper instruction "MOV R12 upperBits<<16" (R12 is generally used as a temporary register by the assembler
                                combineInstruction    = (0b11111001000000000000110000000000 | (sourceRegister << 4)) | sourceRegister #helper instruction "ORR RX R12 RX" where RX is the source register
                                self.machineInstructions.append(secondLoadInstruction)
                                self.machineInstructions.append(combineInstruction)
                                self.PC = self.PC + 2
                            currentTokenIndex = currentTokenIndex + 1

                            #making sure this is the end of the line
                            if not numTokens == currentTokenIndex:
                                print(f"Error parsing line {i+1}: Too many parameters")
                                sys.exit()
                            else:
                                continue
                    else:
                        #add source register to instruction
                        if not command in ["TST","TEQ","CMP","CMN"]: #These commands do not support write back. 
                            
                            #check if the next token is a register
                            if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="CPSR", quitOnError=True):
                                sourceRegister = REGISTER_CODES[line[currentTokenIndex]]
                                currentInstruction = currentInstruction | sourceRegister
                                currentTokenIndex = currentTokenIndex + 1

                            #check if next token is a comma
                            if self._checkToken([','], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                                currentTokenIndex = currentTokenIndex + 1

                        else:
                            currentInstruction = currentInstruction | (0b1 << 21)#set "Write Back Disable Bit"

                        if not command == "NOT": #The not command only has one input parameter
                            #check if next token is a register
                            if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="CPSR", quitOnError=True):
                                currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 8)
                                currentTokenIndex = currentTokenIndex + 1

                            #check if next token is a comma
                            if self._checkToken([','], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                                currentTokenIndex = currentTokenIndex + 1

                        #check if next token is a register
                        if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="CPSR", quitOnError=False):
                            currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 4)
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            #If the next token is not a register it will be interpreted as an immediate value.

                            #Make sure there is a token left
                            if numTokens < currentTokenIndex + 1:
                                print(f"Error parsing line {i+1}: Too few parameters")
                                sys.exit()

                            #set immediate enable bit
                            currentInstruction = currentInstruction | (0b1 << 22)
                            if command in ["AND","TST","EOR","TEQ","ORR","BIC","NOT"]: #These commands only support some specific bit masks as immediate values 
                                value, error = self._createBinaryNumber(32, line[currentTokenIndex])
                                if not error == None:
                                    print(f"Error parsing line {i+1}: The '{command}' command only suports the following bit masks as immediate values: {list(BIT_MASKS.keys())}")
                                    sys.exit()
                                if value in BIT_MASKS:
                                        value = BIT_MASKS[value]
                                else:
                                    print(f"Error parsing line {i+1}: The '{command}' command only suports the following bit masks as immediate values: {list(BIT_MASKS.keys())}")
                                    sys.exit()
                            else:
                                value, error = self._createBinaryNumber(4, line[currentTokenIndex]) 
                                if not error == None:
                                    print(f"Error parsing line {i+1}: {error}")
                                    sys.exit()   
            
                            currentInstruction = currentInstruction | (value << 4)
                            currentTokenIndex = currentTokenIndex + 1

                        #check if multiply instruction should write the upper or lower 32 bits
                        if command in ["MULL", "UMULL"]:
                            currentInstruction = currentInstruction | (0b1 << 21)

                        #check if end of line has been reached
                        if numTokens == currentTokenIndex:
                            self.machineInstructions.append(currentInstruction)
                            continue

                        #check if next token is a comma
                        if self._checkToken([','], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                            currentTokenIndex = currentTokenIndex + 1

                        #check for valid bit manipulation method 
                        bitManipulationBits, error = self._createBitManipulationMethodBits(numTokens, currentTokenIndex, line)
                        if not error == None:
                            print(f"Error parsing line {i+1}: {error}")
                            sys.exit()
                        else:
                            currentInstruction = currentInstruction | (bitManipulationBits << 13)
                            currentTokenIndex = currentTokenIndex + 2


                        #making sure there are no additional tokens left and add instruction to the list of instructions
                        if not numTokens == currentTokenIndex:
                            print(f"Error parsing line {i+1}: Too many parameters")
                            sys.exit()
                        else:
                            self.machineInstructions.append(currentInstruction)
                            continue

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
                    elif line[currentTokenIndex] in REGISTER_CODES and not line[currentTokenIndex] == "CPSR":
                        currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]])
                        currentTokenIndex = currentTokenIndex + 1
                    elif line[currentTokenIndex] == "CPSR":
                        print(f"Error parsing line {i+1}: 'CPSR' cannot be used as address register.")
                        sys.exit()
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
                        currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 4)
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
                            offset, error = self._createBinaryNumber(length = 12, numberString=line[currentTokenIndex])
                            if not error == None:
                                print(f"Error parsing line {i+1}: {error}")
                                sys.exit()
                            else:
                                currentInstruction = currentInstruction | (offset << 8)
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

                        #if end of line is reached, add instruction to the list of instructions and continue to next instruction
                        if numTokens == currentTokenIndex:
                            self.machineInstructions.append(currentInstruction)
                            continue
                        elif line[currentTokenIndex] == ",":
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            print(f"Error parsing line {i+1}: Expected ',' instead of '{line[currentTokenIndex]}'.")
                            sys.exit()

                        #check if there are at least 2 tokens left and add bit manipulation codes to current instruction
                        bitManipulationBits, error = self._createBitManipulationMethodBits(numTokens, currentTokenIndex, line)
                        if not error == None:
                            print(f"Error parsing line {i+1}: {error}")
                            sys.exit()
                        else:
                            currentInstruction = currentInstruction | (bitManipulationBits << 13)
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
                    #add instruction class code to current instruction
                    currentInstruction = currentInstruction | (0b010 << 25) 

                    opCode = OPERATION_CODES[command]
                    #add opCode to current instruction
                    currentInstruction = currentInstruction | (opCode << 21)

                    if command in ["PASS", "HALT", "SIR", "RES"]: #These instruction do not require any parameters
                        #make sure there are no additional tokens left and add instruction to the list of instructions
                        if not numTokens == currentTokenIndex:
                            print(f"Error parsing line {i+1}: Too many parameters")
                            sys.exit()
                        else:
                            self.machineInstructions.append(currentInstruction)
                            continue
                    else:
                        pass

                elif instructionClass == "Control Flow":
                    #Add instruction class code to current instruction.
                    currentInstruction = currentInstruction | (0b011 << 25) 

                    opCode = OPERATION_CODES[command]
                    #Add opCode to current instruction.
                    currentInstruction = currentInstruction | (opCode << 23)

                    #The next token can be an immediate value, a register or a label.

                    #Check if the next token is a '-' or '+'.
                    if self._checkToken(["-", "+"], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=False):
                        if line[currentTokenIndex] == '-':
                            #Set the "Subtract Enable Bit".
                            currentInstruction = currentInstruction | (0b1 << 21)
                        currentTokenIndex = currentTokenIndex + 1

                        value, error =  self._createBinaryNumber(21, line[currentTokenIndex])

                        if not error == None:
                            print(f"Error parsing line {i+1}: {error}")
                            sys.exit()
                        
                        #Set the "Immediate Offset Enable Bit":
                        currentInstruction = currentInstruction | (0b1 << 22)
                        
                        #Add immediate value to instruction.
                        currentInstruction = currentInstruction | (value << 0)

                        currentTokenIndex = currentTokenIndex + 1
                        

                    #Check if token is register except the CPSR.
                    elif self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="CPSR", quitOnError=False):        
                        currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 0)
                        currentTokenIndex = currentTokenIndex + 1

                        #Set the "Register as Offset Enable Bit".
                        currentInstruction = currentInstruction | (0b1 << 21)

                        #Check if end of line has been reached.
                        if numTokens == currentTokenIndex:
                            self.machineInstructions.append(currentInstruction)
                            continue
                        elif line[currentTokenIndex] == ",":
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            print(f"Error parsing line {i+1}: Expected ',' instead of '{line[currentTokenIndex]}'.")
                            sys.exit()

                        #check if there are at least 2 tokens left and add bit manipulation codes to current instruction
                        bitManipulationBits, error = self._createBitManipulationMethodBits(numTokens, currentTokenIndex, line)
                        if not error == None:
                            print(f"Error parsing line {i+1}: {error}")
                            sys.exit()
                        else:
                            currentInstruction = currentInstruction | (bitManipulationBits << 13)
                            currentTokenIndex = currentTokenIndex + 2

                    elif line[currentTokenIndex] == "CPSR":
                        print(f"Error parsing line {i+1}: 'CPSR' cannot be used as parameter here.")
                        sys.exit()  

                    #Check if token is a '['.
                    elif self._checkToken(['['], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=False):
                        currentTokenIndex = currentTokenIndex + 1
                        #Check if token is register except the CPSR.
                        if self._checkToken(REGISTER_CODES, numTokens, currentTokenIndex, line, i, errorType="CPSR", quitOnError=True): 
                            currentInstruction = currentInstruction | (REGISTER_CODES[line[currentTokenIndex]] << 0)
                            currentTokenIndex = currentTokenIndex + 1
                        
                        #Check if next token is a ']'.
                        if self._checkToken([']'], numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=True):
                            currentTokenIndex = currentTokenIndex + 1

                        #Check if end of line has been reached.
                        if numTokens == currentTokenIndex:
                            self.machineInstructions.append(currentInstruction)
                            continue
                        elif line[currentTokenIndex] == ",":
                            currentTokenIndex = currentTokenIndex + 1
                        else:
                            print(f"Error parsing line {i+1}: Expected ',' instead of '{line[currentTokenIndex]}'.")
                            sys.exit()

                        #check if there are at least 2 tokens left and add bit manipulation codes to current instruction
                        bitManipulationBits, error = self._createBitManipulationMethodBits(numTokens, currentTokenIndex, line)
                        if not error == None:
                            print(f"Error parsing line {i+1}: {error}")
                            sys.exit()
                        else:
                            currentInstruction = currentInstruction | (bitManipulationBits << 13)
                            currentTokenIndex = currentTokenIndex + 2

                    #Add token to labels that need to be resolved in the end.
                    else:
                        #Set 'Immediate Offset Enable Bit'.
                        currentInstruction = currentInstruction | (0b1 << 22)

                        self.labelsToResolve.append({"label": line[currentTokenIndex], "kind": "jump", "instructionIndex": len(self.machineInstructions), "lineNum": i})
                        currentTokenIndex = currentTokenIndex + 1

                    #Make sure there are no additional tokens left and add instruction to the list of instructions.
                    if not numTokens == currentTokenIndex:
                        print(f"Error parsing line {i+1}: Too many parameters")
                        sys.exit()
                    else:
                        self.machineInstructions.append(currentInstruction)
                        continue

                    

                else:
                    print(f"Instruction class '{instructionClass}' does not exist")
                    sys.exit()

        
            else:
                print(f"Error parsing line {i+1}: Command '{line[0]}' does not exist.")
                sys.exit()
            


        print("Parsed file successfully, no errors detected.")

    def resolveLabels(self):
        for label in self.labelsToResolve:
            labelToResolve = label["label"]
            kind = label["kind"]
            instructionIndex = label["instructionIndex"]
            lineNum = label["lineNum"]
            try:
                instruction = self.machineInstructions[instructionIndex]
            except:
                print(f"Error Resolving labels in line {lineNum}: Index {instructionIndex} does not exist.")
                sys.exit()

            if kind == "jump":
                if not labelToResolve in self.labels:
                    print(f"Error resolving label in line {lineNum}: Label {labelToResolve} does not exist.")
                    sys.exit()
                else:
                    jumpAddress = self.labels[labelToResolve]
                    offset = jumpAddress - instructionIndex - 1

                    offsetIsNegative = offset < 0
                    stringOffset = str(abs(offset))

                    value, error = self._createBinaryNumber(21, stringOffset)
                    if not error == None:
                        print(f"Error resolving label in line {lineNum}: {error}")
                        print(f"If the function call is too far away in memory, you can do an absolute jump by loading the function address into a register first, and than calling 'JUMP [RX]'.")
                        sys.exit()

                    #Set the "Subtract Bit".
                    if offsetIsNegative:
                        instruction = instruction | (0b1 << 21)

                    #Adding the offset to the instruction.
                    instruction = instruction | (value << 0)

                    self.machineInstructions[instructionIndex] = instruction
                    
            else:
                print(f"Error resolving labels. '{kind}' is not a valid label kind.")
                sys.exit()

        print("Resolved labels successfully, no errors detected.")


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
            return None, f"'{numberString}' is not a valid integer value."
        
    def _createBitManipulationMethodBits(self, numTokens, currentTokenIndex, line):

        if numTokens < currentTokenIndex + 2:
            error = f"Bit Manipulation needs exactly two parameters."
            return None, error

        manipulationMethod = line[currentTokenIndex]
        value  = line[currentTokenIndex+1]

        bitManipulationBits = 0
        if not manipulationMethod in BIT_MANIPULATION_METHODS:
            error = f"'{manipulationMethod}' is not a valid manipulation method. Valid manipulation methods are {list(BIT_MANIPULATION_METHODS.keys())}."
            return None, error
        
        useRegisterEnable = 1
        if value in REGISTER_CODES and not value == "CPSR":
            value = REGISTER_CODES[value]
        elif value == "CPSR":
            error = f"'CPSR' cannot be used as an operand for bit manipulation."
            return None, error
        else:
            value, error = self._createBinaryNumber(length=5, numberString=value)
            if not error == None:
                return None, error
            useRegisterEnable = 0
        
        bitManipulationBits = bitManipulationBits | (BIT_MANIPULATION_METHODS[manipulationMethod]<<6)
        bitManipulationBits = bitManipulationBits | useRegisterEnable << 5
        bitManipulationBits = bitManipulationBits | value

        return bitManipulationBits, None
    
    def _checkToken(self, StringList, numTokens, currentTokenIndex, line, i, errorType="default", quitOnError=False):
        if numTokens < currentTokenIndex + 1:
            if quitOnError:
                print(f"Error parsing line {i+1}: Too few parameters")
                sys.exit()
            return False
        elif line[currentTokenIndex] in StringList and not (errorType == "CPSR" and line[currentTokenIndex] == "CPSR"):
            return True
        else:
            if quitOnError:
                if errorType == "CPSR" and line[currentTokenIndex] == "CPSR":
                    print(f"Error parsing line {i+1}: '{line[currentTokenIndex]}' is an invalid register in this case.")
                elif errorType == "register" or errorType == "CPSR":
                    print(f"Error parsing line {i+1}: '{line[currentTokenIndex]}' is not a valid register.")
                else:
                    print(f"Error parsing line {i+1}: Expected '{StringList[0]}' instead of '{line[currentTokenIndex]}'.")
                sys.exit()
            else:
                return False