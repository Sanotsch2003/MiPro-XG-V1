import sys
import re
from constants import CONDITION_CODES, OPERATION_CODES

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
        
    def createMachineCode(self):
        #replace all definitions with the appropriate values first
        for i, line in enumerate(self.cleanedLines):
            if  len(line)>0:
                if line[0] == "DEFINE":
                    if len(line) == 3:
                        self.definitions[line[1]] = line[2]
                        print(f"Created Defintion for {line[1]}")
                    else:
                        print(f"Error parsing line {i+1}: DEFINE needs 2 parameters, found {len(line)-1}.")
                        sys.exit()

                else:
                    for i in range(len(line)):
                        if line[i] in self.definitions:
                            print(f"Replaced {line[i]} with {self.definitions[line[i]]}")
                            line[i] = self.definitions[line[i]]
                        


        for i, line in enumerate(self.cleanedLines):
            print(line)
            currentInstruction = 0x00000000 #default value
            if line == []: #continue on empty lines
                continue

            elif line[0] == "DEFINE":
                continue

            elif len(line) == 2 and line[1][0] == ":": 
                if line[0] in self.labels:
                    print(f"Error parsing line {i+1}: Label {line[0]} does already exist.")
                    sys.exit()
                else:
                    self.labels[line[0]] = self.PC
            

            elif len(line[0]) < 3:
                print(f"Error parsing line {i+1}: Command {line[0]} does not exist.")
                sys.exit()
            
            elif (line[0][-2:] in CONDITION_CODES and line[0][:-2] in OPERATION_CODES) or line[0] in OPERATION_CODES:
                if line[0][-2:] in CONDITION_CODES and line[0][:-2] in OPERATION_CODES:
                    conditionCode = CONDITION_CODES[line[0][-2:]]
                else:
                    conditionCode = 0b1111
                currentInstruction = currentInstruction | (conditionCode << 28)
                print(f"{currentInstruction:32b}")

        
            else:
                print(f"Error parsing line {i+1}: Command {line[0]} does not exist.")
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