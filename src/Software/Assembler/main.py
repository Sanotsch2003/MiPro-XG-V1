from assemblerClass import Assembler
import os
#this is a comment

currentDir = os.path.dirname(os.path.abspath(__file__))
asmFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.asm")
binFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.bin")
vhdFilePath = os.path.join(currentDir, "testPrograms", "memoryWrite.vhd")

assembler = Assembler()

assembler.readFile(filePath=asmFilePath)
assembler.createMachineCode()
for instruction in assembler.machineInstructions:
    print(f"{instruction:032b}")
assembler.createBinFile(filePath=binFilePath)
assembler.createVHDL_MemoryInitFile(filePath=vhdFilePath)






