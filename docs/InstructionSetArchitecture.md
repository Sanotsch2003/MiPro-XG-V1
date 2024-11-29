# Custom Instruction Set Architecture (ISA)

## Table of Contents
1. [Overview](#overview)
2. [Architecture Details](#architecture-details)
   - [Registers](#registers)
   - [Instruction Format](#instruction-format)
3. [Instruction Classes](#instruction-classes)
   - [Data Movement](#data-movement)
   - [Data Processing](#data-processing)
   - [Controll Flow](#controll-flow)
   - [Special Instructions](#special-instructions)
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
Instructions consist of 32 bits. Each Instruction is only executed if the condition is met. Instructions are devided into instruction classes. Operation codes lengths differ between instruction classes. 

|31-28| 27-26                 |25-0                 |
|-----|-----------------------|---------------------|
|Condition| Instruction Class |Opcode and Parameters|

The following conditions can be chosen (Arm v4 Instruction Set):

| Code  | Suffix | Flags                           | Meaning                   |
|-------|--------|---------------------------------|---------------------------|
| 0000  | EQ     | Z set                           | equal                     |
| 0001  | NE     | Z clear                         | not equal                 |
| 0010  | CS     | C set                           | unsigned higher or same   |
| 0011  | CC     | C clear                         | unsigned lower            |
| 0100  | MI     | N set                           | negative                  |
| 0101  | PL     | N clear                         | positive or zero          |
| 0110  | VS     | V set                           | overflow                  |
| 0111  | VC     | V clear                         | no overflow               |
| 1000  | HI     | C set and Z clear               | unsigned higher           |
| 1001  | LS     | C clear or Z set                | unsigned lower or same    |
| 1010  | GE     | N equals V                      | greater or equal          |
| 1011  | LT     | N not equal to V                | less than                 |
| 1100  | GT     | Z clear AND (N equals V)        | greater than              |
| 1101  | LE     | Z set OR (N not equal to V)     | less than or equal        |
| 1110  | AL     | (ignored)                       | always                    |

The following instruction classes exist:

| Instruction Class | Bit Value   |
|-------------------|-------------|
| Data Movement     | 00          |
| Data Processing   | 01          |
| Branch            | 10          |
| Special Instructions | 11       |

Some important notes:
- Invalid instructions trigger an interrupt which can be handled by an interrupt handler.

Assembly Syntax:

Each Assembly instruction consists of a the instruction name folleded by the condition suffix and parameters separated by commmas:
`<Instruction Name><Condition Suffix><space><param1, param2, ...>`



## Instruction Classes

### Data Movement

The data movement instructions have a 3 bit op-code:
|31-28| 27-26                 |24-22                |21-0|
|-----|-----------------------|---------------------|------|
|Condition| 00                |Op-Code               |Parameters|

The following operation codes are available:

| Operation             | Instruction Name | Op-Code|
|-----------------------|---------------|---------------|
| Move to register      | move          |000            |
| Load from memory      | load          |001            |
| Store into memory     | store         |010            |
| push to stack         | push          |011            |
| pop from stack        | pop           |100            |

#### The `move` Instruction:

#### The `load` Instruction:

#### The `store` Instruction:

#### The `push` Instruction:

#### The `pop` Instruction:

### Data Processing

### Controll Flow
The controll flow instructions have a 2 bit op-code and a condition:
|  31-30        |29-28        |27-24      |23-0     |
|---------------|-------------|----------|----------|
| 00            |Opcode       |condition |Parameters|

The following operation codes are available
| Operation             | Assembly Name | Operation Code|
|-----------------------|---------------|---------------|
| relative branch       | move          |000            |
| register branch       | load          |001            |
| return                | store         |010            |
| push to stack         | push          |011            |



The branch instruction looks like this

|  31-30        |29-26        |25-0      |
|---------------|-------------|----------|
| 10            |condition    |Offset    |

where the Offset is a signed integer between −33,554,432 and 33,554,431 which is added to the current value of the program counter.



### Special Instructions

