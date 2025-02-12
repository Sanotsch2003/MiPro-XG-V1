from mipro_toolkit.Assembler.assemblerClass import Assembler
import sys

def assemble(filePath, createVHDL_memoryFile = False):
    if not filePath.endswith(".asm"):
        print("Specified file does not end in '.asm'")
        sys.exit()
    strippedPath = filePath[:-4] 
    asmFilePath = f"{strippedPath}.asm"
    binFilePath = f"{strippedPath}.bin"
    vhdFilePath = f"{strippedPath}.vhd"
    assembler = Assembler()
    assembler.readFile(filePath=asmFilePath)
    assembler.createMachineCode()
    assembler.resolveLabels()
    assembler.createBinFile(filePath=binFilePath)

    if createVHDL_memoryFile:
        assembler.createVHDL_MemoryInitFile(filePath=vhdFilePath)
