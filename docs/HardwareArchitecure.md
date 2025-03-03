# MiPro-XG-V1 Hardware Architecture

This document provides an overview of the hardware architecture of the MiPro-XG-V1 processor, including detailed information about its components and functionality. The full source code can be found [here](https://github.com/Sanotsch2003/MiPro-XG-V1/tree/main/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new).

---

## Table of Contents

1. [Processor Overview](#processor-overview)
2. [Register File](#register-file)
3. [Arithmetic Logic Unit (ALU)](#arithmetic-logic-unit-alu)
4. [Control Unit](#control-unit)
5. [Bus Structure](#bus-structure)
6. [Memory Controller](#memory-controller)
7. [MMIO Devices](#mmio-devices)
   - [UART Interface](#1-uart-interface)
   - [7-Segment Display Controller](#2-7-segment-display-controller)
   - [Clock Controller](#3-clock-controller)
   - [Hardware Timers](#4-hardware-timers)
   - [Digital IO-Pins](#5-digital-io-pins)

---

## Processor Overview

- **Data Width**: 32-bit
- **Instruction Width**: 32-bit
- **Clock Frequency**: 50 MHz

The processor architecture is designed for flexibility and expandability, as shown in the high-level diagram below:

![Processor Components](/docs/imgs/HighLevelHardwareArchitecture.drawio.svg)

---

## Register File

The processor uses 16 general-purpose registers:

![Registers](/docs/imgs/GPRs.drawio.svg)

- **R0 - R12**: General-purpose registers.
- **PC (Program Counter)**: Holds the address of the next instruction.
- **LR (Link Register)**: Stores the return address during function calls.
- **SP (Stack Pointer)**: Used for stack operations.

---

## Arithmetic Logic Unit (ALU)

The ALU performs arithmetic and logical operations. It has two operand inputs that can either be connected to the outputs of the register file or set directly by the control unit.

![ALU](/docs/imgs/ALU.drawio.svg)

**Operations:**

- Arithmetic (Addition with and without carry, Subtraction with and without carry, Reverse Subtraction with and without carry, 32-bit and 64-bit Multiplication)
- Logical (AND, OR, XOR, AND NOT, NOT)
- Bitwise shifts and rotations

The ALU output can be written back to a register or used as an address for memory access.

---

## Control Unit

The control unit manages the operation of all components using a finite state machine with the following states:

1. Fetch
2. Decode
3. Execute
4. Memory Access
5. Write Back

After completing a cycle, the control unit returns to the Fetch state.

---

## Bus Structure

The internal data and address signals are mostly managed by multiplexers, controlled by the control unit.

For a more detailed overview, consult the [VHDL source code](/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/busManagement.vhd).

---

## Memory Controller

Handles data transfers between the processor and both the main memory and MMIO devices:

- Differentiates between main memory and MMIO address ranges.
- Redirects access to the appropriate device or memory block.
- Ensures proper synchronization during read and write operations.

---

## MMIO Devices

All peripherals and additional components are integrated via the MMIO mechanism, allowing the processor to control devices using memory operations.

### 1. UART Interface

The UART interface supports direct communication with external devices, program uploads, and debug signal transmission.

**Registers:**

- **Baud-Rate Prescaler Register** (`0x4000005C`): 32-bit
- **Status Register** (`0x40000060`): 32-bit (read-only)
- **Data Register** (`0x40000064`): 8-bit

### 2. 7-Segment Display Controller

This controller manages the onboard 7-segment displays for numerical output. Currently, it supports displaying signed and unsigned integer values in decimal and hexadecimal format.

**Registers:**

- **Control Register** (`0x40000050`): 32-bit
  - bits 31 to 6: Prescaler for display refresh
  - bit 5: Display on/off
  - bit 4: enable hexadecimal mode (if this bit is 0, number will be displayed in decimal format)
  - bit 3: enable signed mode (In signed mode the display interprets the data as 2's complement signed)
  - bits 2 to 0: Sets the number of displays currently turned on.
  - Example: Setting the control bits to 0b00000000111101000010010000100100 will refresh the display at a reasonable rate, turn it on, enable unsigned decimal mode and set the number of active
- **Input Data Register** (`0x40000054`): 32-bit

### 3. Clock Controller

This component manages manual clocking if the manual clocking mode is enabled. It can also slow down the execution of programs by setting a clock prescaler. The altered clock (whether from button presses or the prescaler) only affects the CPU core, not MMIO devices or memory.

**Register:**

- **Clock Prescaler Register** (`0x40000058`): 32-bit

### 4. Hardware Timers

Four independent timers supporting different modes:

- **Disabled Mode** (Mode bits: 0b00). The Timer is disabled and does not count/trigger interrupts.
- **Free-Running Mode** (Mode bits: 0b01). An interrupt is triggered when the timer overflows
- **One-Shot Mode** (Mode bits: 0b10). An interrupt is triggered when the maximal values has been reached.
- **Periodic Mode** (Mode bits: 0b11). An interrupt is triggered when the counter is reset.

**Registers:**

- **Prescaler Register**: Defines how many clock cycles elapse before the timer increments.
- **Max Count Register**: Determines when the timer resets or stops.
- **Mode Register**: Configures the operation mode.
- **Count Register (Read Only)**: Holds the current count value.

| Timer            | Prescaler Register | Max Count Register | Mode Register | Count Register |
| ---------------- | ------------------ | ------------------ | ------------- | -------------- |
| Timer 0 (8 Bit)  | `0x40000068`       | `0x4000006C`       | `0x40000070`  | `0x40000074`   |
| Timer 1 (16 Bit) | `0x40000078`       | `0x4000007C`       | `0x40000080`  | `0x40000084`   |
| Timer 2 (16 Bit) | `0x40000088`       | `0x4000008C`       | `0x40000090`  | `0x40000094`   |
| Timer 3 (32 Bit) | `0x40000098`       | `0x4000009C`       | `0x400000A0`  | `0x400000A4`   |

The timer resets when updating the mode. If you want to software reset the timer, you have to load a new mode (different from the current one). Then you can load the previous mode again.

### 5. Digital IO-Pins

Each digital I/O pin has four registers that contain the information below. In PWM mode the pins will use **Hardware Timer 0** to create the PWM signal. Therefore, that timer must be in free running mode (default) if you want to use PWM.

**Registers:**

- **Mode Register**: Configures the pin as input, output, or PWM.
  - **0b00:** Output Mode
  - **0b01:** Input Mode
  - **0b10:** PWM Output Mode
- **Data Out Register**: Writes data to the pin (if set as output).
- **Duty Cycle Register**: Defines the PWM duty cycle (if in PWM mode).
- **Data In Register (Read Only)**: Reads the current state of the pin (if set as input).

| Pin  | Mode Register | Data Out Register | Duty Cycle Register | Data In Register |
| ---- | ------------- | ----------------- | ------------------- | ---------------- |
| IO0  | `0x400000A8`  | `0x400000AC`      | `0x400000B0`        | `0x400000B4`     |
| IO1  | `0x400000B8`  | `0x400000BC`      | `0x400000C0`        | `0x400000C4`     |
| IO2  | `0x400000C8`  | `0x400000CC`      | `0x400000D0`        | `0x400000D4`     |
| IO3  | `0x400000D8`  | `0x400000DC`      | `0x400000E0`        | `0x400000E4`     |
| IO4  | `0x400000E8`  | `0x400000EC`      | `0x400000F0`        | `0x400000F4`     |
| IO5  | `0x400000F8`  | `0x400000FC`      | `0x40000100`        | `0x40000104`     |
| IO6  | `0x40000108`  | `0x4000010C`      | `0x40000110`        | `0x40000114`     |
| IO7  | `0x40000118`  | `0x4000011C`      | `0x40000120`        | `0x40000124`     |
| IO8  | `0x40000128`  | `0x4000012C`      | `0x40000130`        | `0x40000134`     |
| IO9  | `0x40000138`  | `0x4000013C`      | `0x40000140`        | `0x40000144`     |
| IO10 | `0x40000148`  | `0x4000014C`      | `0x40000150`        | `0x40000154`     |
| IO11 | `0x40000158`  | `0x4000015C`      | `0x40000160`        | `0x40000164`     |
| IO12 | `0x40000168`  | `0x4000016C`      | `0x40000170`        | `0x40000174`     |
| IO13 | `0x40000178`  | `0x4000017C`      | `0x40000180`        | `0x40000184`     |
| IO14 | `0x40000188`  | `0x4000018C`      | `0x40000190`        | `0x40000194`     |
| IO15 | `0x40000198`  | `0x4000019C`      | `0x400001A0`        | `0x400001A4`     |

### 5. Interrupt Handling

| Interrupt                     | Interrupt-Vector-Table Register | Interrupt Priority Register |
| ----------------------------- | ------------------------------- | --------------------------- |
| Invalid instruction interrupt | `0x3FFFFE00`                    | `0x3FFFFE04`                |
| Software interrupt            | `0x3FFFFE08`                    | `0x3FFFFE0C`                |
| Address alignment interrupt   | `0x3FFFFE10`                    | `0x3FFFFE14`                |
| Read only interrupt           | `0x3FFFFE18`                    | `0x3FFFFE1C`                |
| Hardware timer 0 interrupt    | `0x3FFFFE20`                    | `0x3FFFFE24`                |
| Hardware timer 1 interrupt    | `0x3FFFFE28`                    | `0x3FFFFE2C`                |
| Hardware timer 2 interrupt    | `0x3FFFFE30`                    | `0x3FFFFE34`                |
| Hardware timer 3 interrupt    | `0x3FFFFE38`                    | `0x3FFFFE3C`                |

---
