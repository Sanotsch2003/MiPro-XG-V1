# MiPro-XG-V1

In this hobby project, I am developing my own 32 bit processor with a [Custom Instruction Set Architecture](docs/InstructionSetArchitecture.md) including Assembler.

I started writing some VHDL code and got a [half working processor](src/Hardware/VHDL%20Playground%20and%20Tests) to get basic knowledge about what I actually want to implement.
Based on my experience and additional research I decided to start from zero and use parts of my already existing design.

I am planning to implement the following features:

## Hardware 

- [Von-Neumann-Architecture](docs/HighLevelHardwareArchitecture.drawio.svg)
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
- [ALU](docs/ALU.drawio.svg) including addition, subtraction, multiplication, bit manipulation
- Interrupt Controller and [Interrupt Handling](docs/InterruptHandling.md)
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
  - simple operating system with command line interface..
