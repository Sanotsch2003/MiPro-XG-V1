# Custom Instruction Set Architecture (ISA)

## Table of Contents
1. [Overview](#overview)
2. [Architecture Details](#architecture-details)
   - [Registers](#registers)
   - [Instruction Format](#instruction-format)
3. [Instruction Classes](#instruction-classes)
   - [Data Movement](#data-movement)
   - [Data Processing](#data-processing)
   - [Branch](#branch)
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
Instructions consist of 32 bits. The first 3 bits of each instruction specify the instruction class. The remaining bits are used for the operation code and parameters 

| 31-29             |28-0                 |
|-------------------|---------------------|
| Instruction Class |Opcode and Parameters|

The following instruction classes exist:

| Instruction Class | Bit Value   |
|-------------------|-------------|
| Data Movement     | 00          |
| Data Processing   | 01          |
| Branch            | 10          |
| Special Instructions | 11       |

The bits indicating the instruction class are followed by the operation code and parameters which can have varying lengths and purposes depending on the instruction 
class. 

Some important notes:
- Invalid instructions trigger an interrupt which can be handled by an interrupt handler.


## Instruction Classes

### Data Movement

The data movement instructions have a 3 bit op-code:
|  31-30        |29-27|       26-0|
|---------------|-------------|--|
| Instruction Class     |Opcode|Parameters|

The following operation codes are available:

| Operation             | Assembly Name | Operation Code|
|-----------------------|---------------|---------------|
| Move to register      | move          |00             |
| Load from memory      | load          |01             |
| Store into memory     | store         |10             |


### Branch
The following conditions can be chosen for branching:

| Code  | Suffix | Flags                           | Meaning                   |
|-------|--------|---------------------------------|---------------------------|
| 0000  | EQ     | Z set                          | equal                     |
| 0001  | NE     | Z clear                        | not equal                 |
| 0010  | CS     | C set                          | unsigned higher or same   |
| 0011  | CC     | C clear                        | unsigned lower            |
| 0100  | MI     | N set                          | negative                  |
| 0101  | PL     | N clear                        | positive or zero          |
| 0110  | VS     | V set                          | overflow                  |
| 0111  | VC     | V clear                        | no overflow               |
| 1000  | HI     | C set and Z clear              | unsigned higher           |
| 1001  | LS     | C clear or Z set               | unsigned lower or same    |
| 1010  | GE     | N equals V                     | greater or equal          |
| 1011  | LT     | N not equal to V               | less than                 |
| 1100  | GT     | Z clear AND (N equals V)       | greater than              |
| 1101  | LE     | Z set OR (N not equal to V)    | less than or equal        |
| 1110  | AL     | (ignored)                      | always                    |






