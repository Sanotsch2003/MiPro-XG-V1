# Custom Instruction Set Architecture (ISA)

## Table of Contents
1. [Overview](#overview)
2. [Architecture Details](#architecture-details)
   - [Registers](#registers)
   - [Instruction Format](#instruction-format)
3. [Instruction Classes](#instruction-classes)
   - [Data Movement](#data-movement)
   - [Arithmetic Operations](#arithmetic-operations)
   - [Logical Operations](#logical-operations)
   - [Control Flow](#control-flow)
4. [Memory Model](#memory-model)
5. [Examples](#examples)

---

## Overview
TODO

---

## Architecture Details

### Registers
The following Registers can be used:

| Register Name |Bit Representation of Name| Size (bits) | Purpose                 |
|--------------|-|-------------|-------------------------|
| `R0-R13`      |00000-01101| 32          | General-purpose         |
| `PC`          |01110| 32          | Program Counter         |
| `SP`          |01111| 32          | Stack Pointer           |

It is important to note that all registers have the same hardware architecture and can
theoreticalle be used as General-Purpose-Registers. That means that all instructions 
acting on registers work for all registers in the same way.

### Instruction Format
Instructions consist of 16 bits. The first 3 bits of each instruction specify the instruction class. The remaining bits are used for the operation code and parameters 

| 15-13         |12-0|
|---------------|-------------|
| Instruction Class     |Opcode and Parameters|

The following instruction classes exist:

| Instruction Class | Bit Value   |
|-------------------|-------------|
| Data Movement     | 000         |
| Arithmetic Operations | 001     |
| Logical Operations| 010         |
| Control Flow      |         011 |
| Special Instructions | 100      |

The bits indicating the instruction class are followed by the operation code and parameters which can have varying lengths and purposes depending on the instruction 
class. 

Some important notes:
- Invalid instructions trigger an interrupt which can be handled by an interrupt handler.


## Instruction Classes

### Data Movement

The data movement instructions have a 3 bit op-code:
| 15-13         |12-0||11-0|
|---------------|-------------|--|
| Instruction Class     |Opcode|Parameters|

The following operation codes are available:

| Operation             | Assembly Name | Operation Code|
|-----------------------|---------------|---------------|
| Move between registers| move          |00             |
| Load from memory      | load          |01             |
| Store into memory     | store         |10             |








