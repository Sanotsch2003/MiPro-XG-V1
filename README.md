# MiPro-XG-V1

In this hobby project, I am developing my own 32 bit processor with a [Custom Instruction Set Architecture](docs/InstructionSetArchitecture.md) including Assembler.

I am planning to implement the following features:

## Hardware

- Big Endian
- 16 General Purpose Registers (GPR)
  - 0-12: "real" GPR
  - 13: Link Register (LR)
  - 14: Stack Pointer (SP)
  - 15: Program Counter (PC)
- Flags Register (FR)
  - 0: Negative (N)
  - 1: Zero (Z)
  - 2: Carry (C)
  - 3: Overflow (O)
- ALU including addition, subtraction, multiplication, bit manipulation
- Interrupt Controller and Interrupt Handling
- Memory controller supporting MMIO
- MMIO devices
  -Hardware Timers
  -Simple Rendering Unit with VGA-Output
  -Serial Interface
  -7 Segment Displays


## Software (ideas)

- Assembler that can translate my Assembly language to machine instructions
- A few simple assembly programs that can be run on the processor
  - Fibonacci sequence
  - Calculating Prime numbers
  - Pong Game
- In the future
  - simple operating system with command line interface 
