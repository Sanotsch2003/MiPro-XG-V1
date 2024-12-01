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

| Register Name |Bit Representation of Name| Size (bits) | Purpose                 |
|---------------|--------------------------|-------------|-------------------------|
| `R0-R13`      |00000-01101               | 32          | General-purpose         |
| `PC`          |01110                     | 32          | Program Counter         |
| `SP`          |01111                     | 32          | Stack Pointer           |

All registers can be addressed using instructions that involve registers. For registers that have whos bit size is less then 32 bits, 
only the least significant bits of the data bus are used.

### Instruction Format
Instructions consist of 32 bits. Each Instruction is only executed if the condition is met. Instructions are devided into instruction classes. Operation code lengths differ between instruction classes. 

|31-28    | 27-26                 |25-0                 |
|---------|-----------------------|---------------------|
|Condition| Instruction Class     |Opcode and Parameters|

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

The following instruction classes exist:

| Instruction Class                             | Bit Value   |
|-----------------------------------------------|-------------|
| [Data Movement](#data-movement)               | 00          |
| [Data Processing](#data-processing)           | 01          |
| [Controll Flow](#controll-flow)               | 10          |
| [Special Instructions](#special-instructions) | 11          |

Some important notes:
- Invalid instructions trigger an interrupt which can be handled by an interrupt handler.
- Instead of adding the suffix `AL`, no suffix can be added to avoid checking for any conditions.
- Immidiates are written as numbers in decimal, hexadecial, or binary format. 
For example, the immidiate value 10 can be written as `10`, `0xA`, or `0b1010`.

## Instruction Classes

### Data Movement

The data movement instructions have a 3 bit op-code:
|31-28                           | 27-26                 |25-23                |22-0      |
|--------------------------------|-----------------------|---------------------|----------|
|[Condition](#instruction-format)| 00                    |Op-Code              |Parameters|

The following operation codes are available (More data movement instructions might be added in the future):

| Action                | Assembly Command | Op-Code|
|-----------------------|------------------|--------|
| Load from memory      | [`load`](#load)  |001     |
| Store into memory     | [`store`](#store)|010     |

#### `load` 
This instruction can be used to load a 32 bit value from memory into a register. 

|31-28                           | 27-26                 |25-23                |22                 |21-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    |001                  | Offset Enable Bit |Address Manipulation Bits                                |Address Register|Destination Register |

Here, the 32 bit value in memory at the address specified by the address register will be loaded into the destination register. Optionally, the address can be 
altered by using the adress manipulation bits. For address manipulation, the following methods are available (only the address is altered, not the value inside the address register):

If the "Offset Enable Bit" Is set:

|22               |21-9        |
|-----------------|------------|
|1                |Offset      |

The 14 bit offset is interpreted as a signed integer which is added to the address specified by the source register.

Assembly Syntax Example: 
```
load R4, [R0+127] #This copies the value at the memoriy address specified by R0+127 into R4.
```

If the "Offset Enable Bit" is not set:

|22               |21-14 | 16-15                                                          | 14 - 9               |
|-----------------|------|----------------------------------------------------------------|----------------------|
|0                |000000| [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value   |

#### Available Bit Manipulation Methods

| Manipulation Method  | Assembly Command          | Bit Code |
|----------------------|---------------------------|----------|
|rotate left           | [ROL](#rol) or [ROR](#ror)| 00       |
|logical shift left    | [LSL](#lsl)               | 01       |
|logical shift right   | [LSR](#lsr)               | 10       |
|arithmetic shift right| [ASR](#asr)               | 11       |

Some Assembly Syntax examples:

```
load R4, [R0, ROL 31] #This copies the value at the memoriy address specified by R0 (rotated to the left by 31 bits) into R4.
load R4, [R0, ROR 1] #This copies the value at the memoriy address specified by R0 (rotated to the right by 1 bits) into R4.
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

The assembler allow you to use commands that specify an immidiate address in memory like this:

```
load R6, [0xabcd1234] #This copies the value at the memoriy address 0xabcd1234 into R6.
```

It will use achieve this behavior by using bit manipulation methods or multiple machine instructions.

#### `store`
This instruction can be used to copy a 32 bit value from a register into memory. 

|31-28                           | 27-26                 |25-23                |22                 |21-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    |010                  | Offset Enable Bit |Address Manipulation Bits                                |Address Register|Source Register      |

Here, the 32 bit value in the Source register will be loaded into memory at the address specified by the address register. Optionally, the address can be 
altered by using the adress manipulation bits (refer to the [load](#load) instruction).

### Data Processing
The data processing instructions have a 4 bit op-code:
|31-28                           | 27-26                 |25-22               |21-0      |  
|--------------------------------|-----------------------|--------------------|----------|
|[Condition](#instruction-format)| 01                    |Op-Code             |Parameters|

The data processing instructions can have one or two operands and 

| Action                               | Assembly Command           |op-code |
|--------------------------------------|----------------------------|--------|
| operand1 AND operand2                | [AND](#and)                | 0000   |
| operand1 EOR operand2                | [EOR](#eor)                | 0001   |
| operand1 - operand2                  | [SUB](#sub)                | 0010   |
| operand2 - operand1                  | [RSB](#rsb)                | 0011   |
| operand1 + operand2                  | [ADD](#add)                | 0100   |
| operand1 + operand2 + carry          | [ADC](#adc)                | 0101   |
| operand1 - operand2 + carry - 1      | [SBC](#sbc)                | 0110   |
| operand2 - operand1 + carry - 1      | [RSC](#rsc)                | 0111   |
| as AND, but result is not written    | [TST](#tst)                | 1000   |
| as EOR, but result is not written    | [TEQ](#teq)                | 1001   |
| as SUB, but result is not written    | [CMP](#cmp)                | 1010   |
| as ADD, but result is not written    | [CMN](#cmn)                | 1011   |
| operand1 OR operand2                 | [ORR](#orr)                | 1100   |
| operand2 (operand 1 is ignored)       | [MOV](#mov)                | 1101   |
| operand1 AND NOT operand2 (Bit clear)| [BIC](#bic)                | 1110   |
| NOT operand2 (operand 1 is ignored)   | [MVN](#mvn)                | 1111   |

All instructions except the [MOV](#mov) instruction follow the same scheme:

|31-28                           | 27-26                 |25-22               | 21 - 20                                                        | 19-14              | 13                   | 12-8      | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------------------------------------------------|--------------------|----------------------|-----------|--------------------|---------------------|
|[Condition](#instruction-format)| 01                    |Op-Code             | [Bit Manipulation Method](#available-bit-manipulation-methods) | Manipulation Value | Immidiate Enable Bit | Operand 1 | Operand 2 Register | Destination Register|

For the instructions that do not write the result back to a register, bits 3-0 are ignored. The [MVN](#mvn) instruction ignores the operand 1.
The ["Bit Manipulation Method"](#available-bit-manipulation-methods) specifies one of four operations that can be applied to the result, before it is written to the destination register.
The bits 19-14 specify the shift (rotate) amount.

If the "Immidiate Enable Bit" is set, Operand 1 is interpreted as an unsigned integer. This can be used for incrementing counters, etc.
If the "Immidiate Enable Bit" is not set, Operand 1 is treated like a register, bit 12 is discarded.

#### `MOV`
This instruction can be used to move an immidiate value into a register or to move values between register:
|31-28                           | 27-26                 |25-22               | 21                  | 20-0               |  
|--------------------------------|-----------------------|--------------------|---------------------|--------------------|
|[Condition](#instruction-format)| 01                    |1101                |Immidiate Enable Bit | Parameters         |

If the "Immidiate Enable Bit" is set the instruction is decoded like this:
|31-28                           | 27-26                 |25-22               | 21                  | 20-0               |  
|--------------------------------|-----------------------|--------------------|---------------------|--------------------|
|[Condition](#instruction-format)| 01                    |1101                |Immidiate Enable Bit | Parameters         |



### Controll Flow
The controll flow instructions have a 2 bit op-code:
|  31-28                          |27-26|25-24     |23 downto 0|       
|---------------------------------|-----|----------|-----------|
| [Condition](#instruction-format)|11   |Op-Code   |Parameters |

The following operation codes are available
| Action                       | Assembly Command   | Operation Code|
|------------------------------|--------------------|---------------|
| Jump to Instruction          | [`jump`](#jump)    |00             |
| Jump to Instruction with Link| [`jumpl`](#jumpl)  |01             |
| Return to address in LR      | [`return`](#return)|10             |


#### `jump`
This instruction can be used to make absolute or relative jumps to different parts in the program. It will not save the current value of the program counter to the link register.
|31-28                           |27-26| 25-24                 |23                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|11   | 00                    |Immidiate Offset Enable Bit|Parameters|

If the immidiate offset enable bit is set, the instruction is decoded as follows:
|31-28                           |27-26| 25-24                 |23|22-0      |
|--------------------------------|-----|-----------------------|--|----------|
|[Condition](#instruction-format)|11   | 00                    |1 |Offset    |

The offset is a 23 bit signed integer, which is added to the PC. 

Assembly Syntax Example: 
```
jump 100 #Adds 100 to the PC.
```

If the immidiate offset enable bit is not set, the instruction is decoded as follows:
|31-28                           |27-26| 25-24                 |23|22                           |21-4      |3-0            |
|--------------------------------|-----|-----------------------|--|-----------------------------|----------|---------------|
|[Condition](#instruction-format)|11   | 00                    |0 |Register as Offset Enable Bit|000...000 |Source Register|

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

#### `jumpl`
This instruction works just like the [`jump`](#jump) instruction. However, it also saves the current value of the PC to the link register.
|31-28                           |27-26| 25-24                 |23                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|11   | 01                    |Immidiate Offset Enable Bit|Parameters|

Assembly Syntax Example: 
```
jumpl 100 #Saves current value of PC to link register and adds 100 to the PC.
```

#### `return`
This instruction moves the value located inside the link register back to the PC.
|31-28                           |27-26| 25-24                 |23-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|11   | 10                    |000...000|

Assembly Syntax Example: 
```
return #restores the PC from the link register.
```

### Special Instructions

halt
multiply


