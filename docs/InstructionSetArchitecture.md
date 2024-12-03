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

## Architecture Details

### Registers
The following Registers can be used:

| Register Name |Bit Representation of Name| Size (bits) | Purpose                         |
|---------------|--------------------------|-------------|---------------------------------|
| `R0`-`R12`    |00000-01100               | 32          | General-Purpose-Registers (GPRs) |
| `LR`          |01101                     | 32          | Link Register                   |
| `SP`          |01110                     | 32          | Stack Pointer                   |
| `PC`          |01111                     | 32          | Program counter                 |
| `CPSR`        |10000                     | 8           | Current Program Status Register |

**Important Notes**: 
- Not all instructions support the `CPSR`.
- If it is supported, data access works like this: 
   - **Writing to the register**: Only the least significant bits of the data bus are written into the register, and the remaining bits are ignored.
   - **Reading from the register**: The value is placed on the least significant bits of the data bus, while all remaining bits on the bus are cleared to zero.

### Instruction Format

#### Instruction classes:
Instructions consist of 32 bits. Each Instruction is only executed if the condition is met. Instructions are devided into instruction classes. Operation-code lengths differ between instruction classes: 

| Bits                                          |31-28    | 27                    |26-23                | 22-0       |
|-----------------------------------------------|---------|-----------------------|---------------------|------------|
| [Data Processing](#data-processing)           |Condition| 1                     |Opcode               | Parameters |


| Bits                                          |31-28    | 27-26                 |25-23                | 22-0       |
|-----------------------------------------------|---------|-----------------------|---------------------|------------|
| [Data Movement](#data-movement)               |Condition| 00                    |Opcode               | Parameters |


| Bits                                          |31-28    | 27-26                 |25-22                | 21-0       |
|-----------------------------------------------|---------|-----------------------|---------------------|------------|
| [Special Instructions](#special-instructions) |Condition| 010                   |Opcode               | Parameters |

| Bits                                          |31-28    | 27-26                 |25-24                | 23-0       |
|-----------------------------------------------|---------|-----------------------|---------------------|------------|
| [Controll Flow](#controll-flow)               |Condition| 011                   |Opcode               | Parameters |

**Important Note**: Some instructions support using immidiate values. Immidiates are written as numbers in decimal, hexadecial, or binary format.
Assembly Syntax Examples: 
```
#Comments are written like this.

MOV R4, 5 #moves the immidiate value 5 into R4.
MOV R4, 0b111 #moves the immidiate value 5 into R4.
MOV R4, 0x5 #moves the immidiate value 5 into R4.

#All instructions do the exact same thing.
```

#### Conditions:
The following conditions can be chosen (Arm v4 Instruction Set):

| Code  | Suffix | Flags                           | Meaning                   |
|-------|--------|---------------------------------|---------------------------|
| 0000  | `EQ`   | Z set                           | equal                     |
| 0001  | `NE`   | Z clear                         | not equal                 |
| 0010  | `CS`   | C set                           | unsigned higher or same   |
| 0011  | `CC`   | C clear                         | unsigned lower            |
| 0100  | `MI`   | N set                           | negative                  |
| 0101  | `PL`   | N clear                         | positive or zero          |
| 0110  | `VS`   | V set                           | overflow                  |
| 0111  | `VC`   | V clear                         | no overflow               |
| 1000  | `HI`   | C set and Z clear               | unsigned higher           |
| 1001  | `LS`   | C clear or Z set                | unsigned lower or same    |
| 1010  | `GE`   | N equals V                      | greater or equal          |
| 1011  | `LT`   | N not equal to V                | less than                 |
| 1100  | `GT`   | Z clear AND (N equals V)        | greater than              |
| 1101  | `LE`   | Z set OR (N not equal to V)     | less than or equal        |
| 1110  | `AL`   | (ignored)                       | always                    |

A condition Suffix can be added to each assembly instruction in order to execute it under a certain condition.

Assembly Syntax Example: 
```
MOVEQ R4, R3 #The MOV instruction is only executed if the Z-flag is set.
```

**Important Note**: Instead of adding the suffix `AL`, no suffix can be added to avoid checking for any conditions.

#### Applying shifts and rotations within instructions:

Some instruction allow you to alter the value of a register within in the instruction by shifting or ratating the bits by a certain amount. For these rotate/shift operations, 9 bit will be reserved within the instruction:

|31-28                           | 27-x                         |(x-1) downto (x-9)   |(x-10) downto 0 |
|--------------------------------|------------------------------|---------------------|----------------|
|[Condition](#instruction-format)| some bits                    |Bit manipulation     |some bits       |

If an instruction allows you to use use shifts and rotations on certain bits, the corresponding section within the instruction will be labeled with [Bit Manipulation](#applying-shifts-and-rotations-within-instructions).
It works like this:

|8-7                      | 6                            |5-0                  |
|-------------------------|------------------------------|---------------------|
|Bit Manipulation Method  | Immidiate Enable Bit         |Operand              |

The following Bit Manipulation Methods are available:

| Manipulation Method  | Assembly Command              | Bit Code |
|----------------------|-------------------------------|----------|
|rotate left           | [`ROL`](#rol) or [`ROR`](#ror)| 00       |
|logical shift left    | [`LSL`](#lsl)                 | 01       |
|logical shift right   | [`LSR`](#lsr)                 | 10       |
|arithmetic shift right| [`ASR`](#asr)                 | 11       |

The assembler will understand the `ROR` command; however it will effectifely translate it into a `ROL` command (e.g. rotating right by 4 is the same as rotating left by 28).

If The "Immidiate Enable Bit" is set, the Operand will be interpreted as Integer and will be used to specify the shift/rotate amount. 

|8-7                      | 6                            |5-0                  |
|-------------------------|------------------------------|---------------------|
|Bit Manipulation Method  | 1                            |Integer value        |

Assembly Syntax Example: 
```
MOV R4, R3, LSR 3 #This command takes the value in R3, shifts it to the right by 3 bits and writes it into R4.
```
**Important Notes**:
- If one of the shift/rotate comammands is used, it will always be the last parameter of an assembly instruction.
- The specific register/immidiate which the shift/rotate command acts upon, will be explained for each instruction.


The operand can also be interpreted as a register. In this case the shift amount will be specified by the 6 least significant bits of the register:

|8-7                      | 6                            |5-4     |3-0                  |
|-------------------------|------------------------------|--------|---------------------|
|Bit Manipulation Method  | 0                            |Ignored |Register             |

Assembly Syntax Example: 
```
MOV R4, R3, LSR R7 #This command takes the value in R3, shifts it to the right by the amount specified by the unsigned integer value of the 6 least significant bits in R7 and writes it into R4.
```

## Instruction Classes

### Data Processing
The data processing instructions have a 4 bit op-code:
|31-28                           | 27                 |26-23               |22-0      |  
|--------------------------------|--------------------|--------------------|----------|
|[Condition](#instruction-format)| 1                  |Op-Code             |Parameters|

The following op-codes are available:

| Action                               | Assembly Command             |OP-Code |
|--------------------------------------|------------------------------|--------|
| operand1 AND operand2                | [`AND`](#and-eor-tst-teq-orr-bic)                | 0000   |!
| operand1 EOR operand2                | [`EOR`](#eor)                | 0001   |!
| operand1 - operand2                  | [`SUB`](#sub)                | 0010   |
| operand2 - operand1                  | [`BUS`](#bus)                | 0011   |
| operand1 + operand2                  | [`ADD`](#add)                | 0100   |
| operand1 + operand2 + carry          | [`ADC`](#adc)                | 0101   |
| operand1 - operand2 + carry - 1      | [`SBC`](#sbc)                | 0110   |
| operand2 - operand1 + carry - 1      | [`BSC`](#bsc)                | 0111   |
| as AND, but result is not written    | [`TST`](#tst)                | 1000   |!
| as EOR, but result is not written    | [`TEQ`](#teq)                | 1001   |!
| as SUB, but result is not written    | [`CMP`](#cmp)                | 1010   |
| as ADD, but result is not written    | [`CMN`](#cmn)                | 1011   |
| operand1 OR operand2                 | [`ORR`](#orr)                | 1100   |!
| operand2 (operand 1 is ignored)      | [`MOV`](#mov)                | 1101   |
| operand1 AND NOT operand2 (Bit clear)| [`BIC`](#bic)                | 1110   |!
| NOT operand2 (operand 1 is ignored)  | [`NOT`](#not)                | 1111   |

#### `AND`, `EOR`, `TST`, `TEQ`, `ORR`, `BIC`

|31-28                           | 27-26                 |25-22               | 21                   | 20-19                                                          | 18-13                | 12-8      | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------|----------------------------------------------------------------|----------------------|-----------|--------------------|---------------------|
|[Condition](#instruction-format)| 01                    |Op-Code             | Immidiate Enable Bit | [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value   | Operand 1 | 1                  | Destination Register|

For the instructions that do not write the result back to a register, bits 3-0 are ignored. The [MVN](#mvn) instruction ignores the operand 1.
The ["Bit Manipulation Method"](#available-bit-manipulation-methods) specifies one of four shift (rotate) operations that can be applied to the result, before it is written to the destination register.
The bits 19-14 specify the shift (rotate) amount.

- If the "Immidiate Enable Bit" is set, Operand 1 is interpreted as an unsigned integer. This can be used for incrementing counters, etc.
- If the "Immidiate Enable Bit" is not set, Operand 1 is treated like a register and bit 12 is ignored.

**Important Note**: The `CPSR` **cannot** be used as an operand or as the destination register.

#### `MOV`
This instruction can be used to move an immidiate value into a register or to move values between register:
|31-28                           | 27-26                 |25-22               | 21                  | 20-0               |  
|--------------------------------|-----------------------|--------------------|---------------------|--------------------|
|[Condition](#instruction-format)| 01                    |1101                |Immidiate Enable Bit | Parameters         |

If the "Immidiate Enable Bit" is set,1  the instruction is decoded like this:

|31-28                           | 27-26                 |25-22               | 21                  | 20                           | 19-4              |3-0                 |  
|--------------------------------|-----------------------|--------------------|---------------------|------------------------------|-------------------|--------------------|
|[Condition](#instruction-format)| 01                    |1101                | 1                   | Load Higher Bytes Enable Bit | Immidiate Value   |Destination Register|

Depending on whether the "Load Higher Bytes Enable Bit" is set or not, the immidiate value will be loaded into the lower 2 or higher 
2 bytes of the destination register, while the remaining bits stay unchanged.

**Important Note**: The `CPSR` **cannot** be used as the source or destination register when loading immidiates.

If the "Immidiate Enable Bit" is not set, the instruction is decoded like this:

|31-28                           | 27-26                 |25-22               | 21                  | 20-19                                                          | 18-13             | 9-5             |4-0                 |  
|--------------------------------|-----------------------|--------------------|---------------------|----------------------------------------------------------------|-------------------|-----------------|--------------------|
|[Condition](#instruction-format)| 01                    |1101                | 0                   | [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value| Source Register |Destination Register|

**Important Note**: The `CPSR` **can** be used as the source or destination register when moving values between register.

### Data Movement

The data movement instructions have a 3 bit op-code:
|31-28                           | 27-26                 |25-24                |23-0      |
|--------------------------------|-----------------------|---------------------|----------|
|[Condition](#instruction-format)| 00                    |Op-Code              |Parameters|

The following operation codes are available (More data movement instructions might be added in the future):

| Action                | Assembly Command | Op-Code|
|-----------------------|------------------|--------|
| load from memory      | [`LOAD`](#LOAD)  | 00     |
| store into memory     | [`STORE`](#STORE)| 01     |
(16 and 8 Bit load and Store might be added in the future)

#### `LOAD` 
This instruction can be used to load a 32 bit value from memory into a register. 

|31-28                           | 27-26                 |25-24                |23                 | 22             |21-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|----------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    | 00                  | Offset Enable Bit | Write Back Bit |Address Manipulation Bits                                |Address Register|Destination Register |

Here, the 32 bit value in memory at the address specified by the address register will be loaded into the destination register. Optionally, the address can be 
altered by using the adress manipulation bits. If the "Write Back Bit" is set the altered address will be written back to the address register, otherwise the value in the address register will stay unchanged even 
when the address has been altered.

**Important Notes**: 
- The **`CPSR`** cannot be used as source and destination register.
- The **`CPSR`** cannot be used as address register.

If the "Offset Enable Bit" Is set, the bits 21-9 are interpreted as a 13 bit signed integer, which is added to the address specified by the address register.:

|23               | 22             |21-9        |
|-----------------|----------------|------------|
|1                | Write Back Bit |Offset      |

Assembly Syntax Example: 
```
load R4, [R0+127] #This copies the value at the memoriy address specified by R0+127 into R4.
```

If the "Offset Enable Bit" is not set one of four rotating/shifting methods can be used to alter the address:

|23               | 22             |21-14 | 16-15                                                          | 14-9                 |
|-----------------|----------------|------|----------------------------------------------------------------|----------------------|
|0                | Write Back Bit |000000| [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value   |

#### Available Bit Manipulation Methods

| Manipulation Method  | Assembly Command          | Bit Code |
|----------------------|---------------------------|----------|
|rotate left           | [ROL](#rol) or [ROR](#ror)| 00       |
|logical shift left    | [LSL](#lsl)               | 01       |
|logical shift right   | [LSR](#lsr)               | 10       |
|arithmetic shift right| [ASR](#asr)               | 11       |

Some Assembly Syntax examples:

```
load R4, [R0 ROL 31] #This copies the value at the memory address specified by R0 (rotated to the left by 31 bits) into R4.
load R4, [R0 ROR 1] #This copies the value at the memory address specified by R0 (rotated to the right by 1 bits) into R4.
#Both commands are translated to the same machine code instructions.
```

```
load R4, [R0 LSL 4] #This copies the value at the memoriy address specified by R0 shifted to the left by 4 bits into R4.
```

```
load R4, [R0 LSR 20] #This copies the value at the memoriy address specified by R0 shifted to the right by 20 bits into R4.
```

```
load R6, [R3 ASR 20] #This copies the value at the memoriy address specified by R3 arithmetically shifted to the right by 20 bits into R6.
```

The assembler allows you to use commands that specify an immidiate address in memory like this:

```
load R6, [0xabcd1234] #This copies the value at the memoriy address 0xabcd1234 into R6.
```

This behavior is achieved by using bit manipulation methods or multiple machine instructions.

#### `STORE`
This instruction can be used to copy a 32 bit value from a register into memory

|31-28                           | 27-26                 |25-24                |23                 | 22             |21-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|----------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    | 02                  | Offset Enable Bit | Write Back Bit | Address Manipulation Bits                               |Address Register|Source Register      |

Here, the 32 bit value in the Source register will be loaded into memory at the address specified by the address register. Optionally, the address can be 
altered by using the address manipulation bits mentioned [above](#load).

**Important Notes**: 
- All registers **can** be used as source and destination registers including the `CPSR`.
- The `CPSR` **cannot** be used as address register.

Some Assembly Syntax examples:

```
store R4, [R0 ROL 31] #This copies the value in R4 into memory at the address specified by R0 (rotated to the left by 31 bits).
store R4, [R0 ROR 1] #This copies the value in R4 into memory at the address specified by R0 (rotated to the right by 1 bits).
#Both commands are translated to the same machine code instructions.
```

```
store R4, [R0 LSL 4] #This copies the value in R4 into memory at the address specified by R0 shifted to the left by 4 bits.
```

### Controll Flow
The controll flow instructions have a 2 bit op-code:
|  31-28                          |27-26|25-24     |23 downto 0|       
|---------------------------------|-----|----------|-----------|
| [Condition](#instruction-format)|10   |Op-Code   |Parameters |

The following op-codes are available
| Action                       | Assembly Command   | Op-Code       |
|------------------------------|--------------------|---------------|
| Jump to Instruction          | [`JUMP`](#JUMP)    |00             |
| Jump to Instruction with Link| [`JUMPL`](#JUMP)  |01             |
| Return to address in LR      | [`RETURN`](#RETURN)|10             |


#### `JUMP`
This instruction can be used to make absolute or relative jumps to different parts in the program. It will not save the current value of the program counter to the link register.
|31-28                           |27-26| 25-24                 |23                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|10   | 00                    |Immidiate Offset Enable Bit|Parameters|

If the "Immidiate Offset Enable Bit" is set, the instruction is decoded as follows:
|31-28                           |27-26| 25-24                 |23|22-0      |
|--------------------------------|-----|-----------------------|--|----------|
|[Condition](#instruction-format)|10   | 00                    |1 |Offset    |

The offset is a 23 bit signed integer, which is added to the PC. 

Assembly Syntax Example: 
```
jump 100 #Adds 100 to the PC.
```

If the "Immidiate Offset Enable Bit" is not set, the instruction is decoded as follows:
|31-28                           |27-26| 25-24                 |23|22                           |21-4      |3-0            |
|--------------------------------|-----|-----------------------|--|-----------------------------|----------|---------------|
|[Condition](#instruction-format)|10   | 00                    |0 |Register as Offset Enable Bit|000...000 |Source Register|

If the "Register as Offset Enable Bit" is set, the value inside the source register will be treated as a signed integer and added to the PC to execute the jump.

Assembly Syntax Example: 
```
jump R0 #Adds the signed integer value located in R0 to the PC.
```
If the Register as Offset Enable Bit' is not set, the value inside the PC will be replaced with the value inside the Source Register. In this case 
the source register acts as the jump address.

Assembly Syntax Example: 
```
jump [R6] #Sets the PC to the unsigned integer value located in R6.
```

#### `JUMPL`
This instruction works just like the [`jump`](#jump) instruction. However, it also saves the current value of the PC to the link register.
|31-28                           |27-26| 25-24                 |23                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|10   | 01                    |Immidiate Offset Enable Bit|Parameters|

Assembly Syntax Example: 
```
jumpl 100 #Saves current value of PC to link register and adds 100 to the PC.
```

#### `RETURN`
This instruction moves the value located inside the link register back to the PC.
|31-28                           |27-26| 25-24                 |23-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|10   | 10                    |000...000|

Assembly Syntax Example: 
```
return #restores the PC from the link register.
```

### Special Instructions
The special instructions have a 4 bit op-code:
|  31-28                          |27-26|25-22     |21 downto 0|       
|---------------------------------|-----|----------|-----------|
| [Condition](#instruction-format)|11   |Op-Code   |Parameters |

The following op-codes are available:
| Action                       | Assembly Command   | OP-Code         |
|------------------------------|--------------------|-----------------|
| do nothing                   | [`PASS`](#PASS)    |0000             |
| wait for interrupt           | [`HALT`](#HALT)    |0001             |
| operand1 * operand2 (32Bit)  | [`MUL`](#MUL)      |0010             |
| operand1 * operand2 (64Bit)  | [`MULL`](#MUL)     |0011             |

#### `PASS`
This instruction does nothing and skips . All undefined instructions will be ignored by the processor and effectively achieve the same behavior. 
However, since new instructions might be defined in the future, it is important to to use this specific instruction as its behavior will
not change in the future. The condition has no effect on this instruction as it will do nothing regardless if the condition is met or not.

|31-28                           |27-26| 25-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|11   | 0000                  |000...000|

Assembly Syntax Example: 
```
PASS #does nothing
```

#### `HALT`
This instruction pauses the execution of instructions. The processor will keep listening to interrupt signals and execute given interrupt handlers. 

|31-28                           |27-26| 25-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|11   | 0001                  |000...000|

Assembly Syntax Example: 
```
HALT #pauses the execution of instructions.
```

#### `MUL`
This instruction can be used to multiply two registers and copy the 32 least significant bits of the result into a destination register.

|31-28                           | 27-26                 |25-22               | 21                   | 20-19                                                          | 18-13                | 12-8      | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------|----------------------------------------------------------------|----------------------|-----------|--------------------|---------------------|
|[Condition](#instruction-format)| 11                    |0010                | Immidiate Enable Bit | [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value   | Operand 1 | Operand 2 Register | Destination Register|

**Important Note**: The `CPSR` **cannot** be used as an operand or as the destination register.

#### `MULL`
This instruction can be used to multiply two registers and copy the 64 bit result into two destination registers.

|31-28                           | 27-26                 |25-22               | 21                   | 20-19                                                          | 15-12                | 11-8               | 7-4                    | 3-0                   |   
|--------------------------------|-----------------------|--------------------|----------------------|----------------------------------------------------------------|----------------------|--------------------|------------------------|-----------------------|
|[Condition](#instruction-format)| 11                    |0010                | Immidiate Enable Bit | [Bit Manipulation Method](#available-bit-manipulation-methods) | Operand 1 Register   | Operand 2 Register | Destination 1 Register | Destination 2 Register|
TODO TODO
**Important Note**: The `CPSR` **cannot** be used as an operand or as one of the destination registers.


