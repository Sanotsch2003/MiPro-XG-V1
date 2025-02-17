# MiPro-XG-V1 Hardware Architecture

This document provides an overview of the hardware architecture of the MiPro-XG-V1 processor, including detailed information about its components and functionality. The full source code can be found [here](https://github.com/Sanotsch2003/MiPro-XG-V1/tree/main/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new).

## Processor Overview

- **Data Width**: 32-bit
- **Instruction Width**: 32-bit
- **Clock Frequency**: 50 MHz

The processor architecture is designed for flexibility and expandability, as shown in the high-level diagram below:

![Processor Components](/docs/imgs/HighLevelHardwareArchitecture.drawio.svg)
*Figure 1: Processor Components*

---

## Register File

The processor uses 16 general-purpose registers, detailed below:

![Registers](/docs/imgs/GPRs.drawio.svg)
*Figure 2: General Purpose Registers*

- **R0 - R12**: General-purpose registers.
- **PC (Program Counter)**: Holds the address of the next instruction.
- **LR (Link Register)**: Stores the return address during function calls.
- **SP (Stack Pointer)**: Used for stack operations.

The registers are designed to operate uniformly, with distinct purposes assigned as outlined above. Data can be loaded into the registers either from the ALU or via the memory controller, which interfaces with main memory and MMIO devices.

---

## Arithmetic Logic Unit (ALU)

The ALU performs arithmetic and logical operations. It has two operand inputs that can either be connected to the outputs of the register file or set directly by the control unit.


![ALU](/docs/imgs/ALU.drawio.svg)
*Figure 3: Arithmetic Logic Unit*

- **Preprocessing**:
  - Logical shift left and right by up to 32 bits
  - Arithmetic shift right by up to 32 bits
  - Rotation left by up to 32 bits
    
- **Operations**:
  - Addition (with or without carry).
  - Subtraction Operand1 - Operand2 (with or without borrow)
  - Reverse Subtraction Operand2 - Operand2 (with or without borrow)
  - Multiplication (select upper or lower 32 bits of the result)
  - Logical Operations (op1 AND op2, op1 XOR op2, op1 OR op2, op1 AND NOT op2, NOT op2)
  - No Operation (Used to move values between registers or to send an unmodified value as an address to the memory controller)
                
The ALU output can be written back to a register or used as an address for memory access, which increases flexibility.
Whenever an operation is performed by the ALU, the flags are set according to the result. The Control Unit has internal flag registers and can update them using the ALU flag outputs. 

---

## Control Unit

The control unit manages the operation of all components using a finite state machine with the following states:

1. **Fetch**: Load the instruction from memory (address specified by the program counter).
2. **Decode**: Configure control signals based on the current instruction.
3. **Execute**: Perform the operation in the ALU.
4. **Memory Access**: Handle memory or MMIO operations.
5. **Write Back**: Write results to the specified register.

After completing a cycle, the control unit returns to the Fetch state.

---

## Bus-Structure
For simplicity, Figure 1 does not display the bus structure. The internal data and address signals that connect the individual components are mostly managed by multiplexers, which the control unit can control. For a more detailed overview, consult the [VHDL source code](/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/busManagement.vhd) or open an Issue in the GitHub repository.

## Memory Controller

The memory controller handles data transfers between the processor and both the main memory and MMIO devices:

- Differentiates between main memory and MMIO address ranges.
- Redirects access to the appropriate device or memory block.
- Ensures proper synchronization during read and write operations.

## Memory-Mapped I/O (MMIO)

All peripherals and additional components are integrated via the MMIO mechanism to ensure modularity. MMIO allows the processor to control devices using memory operations by mapping each device to a unique address outside the main memory range. The memory controller redirects access to these addresses to the appropriate MMIO device.

### Current MMIO Devices

1. **UART Interface**
   The UART interface supports direct communication with external devices, program uploads, and debug signal transmission.
   
   - **Address Range**: `0x4000005C - 0x40000064`
   - **Bit Assignments**:
     - `0x4000005C`: 32-bit Baud-Rate-Prescaler Register (Use an integer value of 5208 at a clock frequency of 50mHz for a baud-rate of 9600).
     - `0x40000060`: 32-bit Status Register (rad-only, will trigger interrupt if trying to write to this address).
     - `0x40000064`: 8-Bit Read and Write Register.

   
   The UART interface supports direct communication with external devices, program uploads, and debug signal transmission.

2. **7-Segment Display Controller**
   This controller manages the onboard 7-segment displays for numerical output. Currently, it supports displaying signed and unsigned integer values in decimal and hexadecimal format.
   - **Address Range**: `0x40000050 - 0x40000054`
   - **Bit Assignments**:
     - `0x40000050`: 32-bit control signals
       - bits 31 to 6: Prescaler for display refresh
       - bit 5: Display on/off
       - bit 4: enable hexadecimal mode (if this bit is 0, number will be displayed in decimal format)
       - bit 3: enable signed mode (In signed mode the display interprets the data as 2's complement signed)
       - bits 2 to 0: Sets the number of displays currently turned on.
       - Example: Setting the control bits to 0b00000000111101000010010000100100 will refresh the display at a reasonable rate, turn it on, enable unsigned decimal mode and set the number of active displays to 4. 
     - `0x40000054`: 32-bit input data (Signed or unsigned integer value to display)
---

