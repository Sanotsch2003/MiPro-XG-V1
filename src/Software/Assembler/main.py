from assemblerClass import Assembler
import os

currentDir = os.path.dirname(os.path.abspath(__file__))
filePath = os.path.join(currentDir, "testPrograms", "memoryWrite.asm")

assembler = Assembler()

assembler.readFile(filePath=filePath)
#print(assembler.cleanedLines)
assembler.createMachineCode()
print("done")




