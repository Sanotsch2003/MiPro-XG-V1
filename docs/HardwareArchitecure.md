# MiPro-XG-V1 Hardware Architecture

This document provides an overview of the hardware architecture of the MiPro-XG-V1 processor, including detailed information about its components and functionality. The full source code is available on GitHub: [MiPro-XG-V1 Hardware](https://github.com/Sanotsch2003/MiPro-XG-V1/tree/main/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new).

## Processor Overview

- **Data Width**: 32-bit
- **Instruction Width**: 32-bit
- **Clock Frequency**: 50 MHz

The processor architecture is designed for flexibility and expandability, as shown in the high-level diagram below:

![Processor Components](Images/HighLevelHardwareArchitecture.drawio.png)
*Figure 1: Processor Components*

---

## Memory-Mapped I/O (MMIO)

To ensure modularity, all peripherals and additional components are integrated via the MMIO mechanism. MMIO allows the processor to control devices using memory operations by mapping each device to a unique address outside the main memory range. The memory controller redirects access to these addresses to the appropriate MMIO device.

### Current MMIO Devices

1. **UART Interface**
   - **Address Range**: `0x1000_0000 - 0x1000_0003`
   - **Bit Assignments**:
     - `0x1000_0000`: Transmit Data Register (Write-only)
     - `0x1000_0001`: Receive Data Register (Read-only)
     - `0x1000_0002`: Status Register
       - Bit 0: Transmit Ready (1 = Ready)
       - Bit 1: Receive Data Available (1 = Data Available)
     - `0x1000_0003`: Control Register
       - Bit 0: Enable UART
       - Bit 1: Interrupt Enable
   
   The UART interface supports direct communication with external devices, program uploads, and debug signal transmission.

2. **7-Segment Display Controller**
   - **Address Range**: `0x1000_0010 - 0x1000_0013`
   - **Bit Assignments**:
     - `0x1000_0010`: Segment Control for Display 1
     - `0x1000_0011`: Segment Control for Display 2
     - `0x1000_0012`: Segment Control for Display 3
     - `0x1000_0013`: Segment Control for Display 4
   - Each byte controls the state of the 7 segments and the decimal point.
   
   This controller manages the onboard 7-segment displays for numerical and symbolic output.

3. **Interrupt Vector Table (IVT)**
   - **Address Range**: `0x2000_0000 - 0x2000_00FF`
   - Stores addresses for interrupt handler routines.
   - Includes read-only interrupts for MMIO devices.

---

## Register File

The processor features 16 general-purpose registers, detailed below:

![Registers](Images/GPRs.png)
*Figure 2: General Purpose Registers*

- **R0 - R12**: General-purpose registers.
- **PC (Program Counter)**: Holds the address of the next instruction.
- **LR (Link Register)**: Stores the return address during function calls.
- **SP (Stack Pointer)**: Used for stack operations.

The registers are designed to operate uniformly, with distinct purposes assigned as outlined above. Data can be loaded into the registers either from the ALU or via the memory controller, which interfaces with main memory and MMIO devices.

---

## Arithmetic Logic Unit (ALU)

The ALU performs arithmetic and logical operations. It has two inputs:

![ALU](Images/ALU.png)
*Figure 3: Arithmetic Logic Unit*

- **Preprocessing**: Supports bit shifts and rotations on the second input.
- **Operations**:
  - Addition and subtraction (with or without carry).
  - Multiplication (select upper or lower 32 bits of the result).

The ALU output can be written back to a register or used as an address for memory access. This flexibility is crucial for efficient execution of instructions involving both data computation and memory interactions.

---

## Control Unit

The control unit manages the operation of all components using a finite state machine with the following states:

1. **Fetch**: Load the instruction from memory (address specified by the program counter).
2. **Decode**: Configure control signals based on the current instruction.
3. **Execute**: Perform the operation in the ALU.
4. **Memory Access**: Handle memory or MMIO operations.
5. **Write Back**: Write results to the specified register.

After completing a cycle, the control unit returns to the Fetch state. The state machine ensures synchronized operation of all components, contributing to the processor's overall stability and performance.

---

## Memory Controller

The memory controller handles data transfers between the processor and both the main memory and MMIO devices. It:

- Differentiates between main memory and MMIO address ranges.
- Redirects access to the appropriate device or memory block.
- Ensures proper synchronization during read and write operations.
