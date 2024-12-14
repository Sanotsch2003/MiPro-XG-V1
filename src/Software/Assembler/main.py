from assemblerClass import Assembler
import os

currentDir = os.path.dirname(os.path.abspath(__file__))
asmFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.asm")
binFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.bin")
vhdFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.vhd")

assembler = Assembler()

assembler.readFile(filePath=asmFilePath)
#print(assembler.cleanedLines)
assembler.createMachineCode()
instructions = assembler.machineInstructions
for instruction in instructions:
    print(f"{instruction:032b}")
print("done")

assembler.createBinFile(filePath=binFilePath)
assembler.createVHDL_MemoryInitCode(filePath=vhdFilePath)






