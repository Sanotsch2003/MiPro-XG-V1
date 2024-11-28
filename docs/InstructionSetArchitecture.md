# Custom Instruction Set Architecture (ISA)

## Table of Contents
1. [Overview](#overview)
2. [Architecture Details](#architecture-details)
   - [Registers](#registers)
   - [Instruction Format](#instruction-format)
3. [Instruction Set](#instruction-set)
   - [Data Movement](#data-movement)
   - [Arithmetic Operations](#arithmetic-operations)
   - [Logical Operations](#logical-operations)
   - [Control Flow](#control-flow)
4. [Memory Model](#memory-model)
5. [Examples](#examples)
6. [References](#references)

---

## Overview
TODO

---

## Architecture Details

### Registers
The following Registers can be used:

| Register Name | Size (bits) | Purpose                 |
|---------------|-------------|-------------------------|
| `R0-R13`      | 32          | General-purpose         |
| `PC`          | 32          | Program Counter         |
| `SP`          | 32          | Stack Pointer           |

It is important to note that all registers have the same hardware architecture and can
theoreticalle be used as General-Purpose-Registers. That means that all instructions 
acting on registers work for all registers in the same way.

### Instruction Format
Instructions consist of 16 or 32 bits. The first 3 bits of each instruction specify the instruction class. The following instruction classes exist:

| Instruction Class | Bit Value   |
|-------------------|-------------|
|  Data Movement    | 32          |
|  Arithmetic Operations     | 32          |
| Logical Operations| 32          |

