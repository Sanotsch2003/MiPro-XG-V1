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
| 0000  | `EQ`      | Z set                           | equal                     |
| 0001  | `NE`      | Z clear                         | not equal                 |
| 0010  | `CS`     | C set                           | unsigned higher or same   |
| 0011  | `CC`      | C clear                         | unsigned lower            |
| 0100  | `MI`      | N set                           | negative                  |
| 0101  | `PL`      | N clear                         | positive or zero          |
| 0110  | `VS`      | V set                           | overflow                  |
| 0111  | `VC`      | V clear                         | no overflow               |
| 1000  | `HI`      | C set and Z clear               | unsigned higher           |
| 1001  | `LS`      | C clear or Z set                | unsigned lower or same    |
| 1010  | `GE`      | N equals V                      | greater or equal          |
| 1011  | `LT`      | N not equal to V                | less than                 |
| 1100  | `GT`      | Z clear AND (N equals V)        | greater than              |
| 1101  | `LE`      | Z set OR (N not equal to V)     | less than or equal        |
| 1110  | `AL`      | (ignored)                       | always                    |

The following instruction classes exist:

| Instruction Class | Bit Value   |
|-------------------|-------------|
| [Data Movement](#data-movement)     | 00          |
| [Data Processing](#data-processing)   | 01          |
| [Controll Flow](#controll-flow)            | 10          |
| [Special Instructions](#special-instructions) | 11       |

Some important notes:
- Invalid instructions trigger an interrupt which can be handled by an interrupt handler.

#### Assembly Syntax:

Each Assembly instruction consists of a the instruction name folleded by the condition suffix and parameters separated by commmas:
```
<Instruction Name><Condition Suffix><space><param1, param2, ...>; #comment
```
Instead of adding the suffix `AL` no suffix can be added to avoid checking for any conditions. Immidiates are written as numbers in decimal, hexadecial, or binary format. 
For example, the immidiate value 10 can be written as `10`, `0xA`, or `0b1010`. 


## Instruction Classes

### Data Movement

The data movement instructions have a 3 bit op-code:
|31-28| 27-26                 |24-22                |21-0|
|-----|-----------------------|---------------------|------|
|[Condition](#instruction-format)| 00                |Op-Code               |Parameters|

The following operation codes are available:

| Operation             | Assembly command| Op-Code|
|-----------------------|---------------|---------------|
| Regular move          | [`move`](#move)         |000            |
| Load from memory      | [`load`](#load)          |001            |
| Store into memory     | [`store`](#store)         |010            |
| Push to stack         | [`push`](#push)          |011            |
| Pop from stack        | [`pop`](#pop)           |100            |

#### `move`
This instruction can be used to move values between registers or to move an immidiate value into a register.
|31-28| 27-26                 |24-22                |21|20-0
|-----|-----------------------|---------------------|------|---|
|[Condition](#instruction-format)| 00                |000               |Immidiate Enable Bit|Params|

If the immidiate enable bit is set, the instruction is decoded as follows:
|31-28| 27-26                 |24-22                |21    |20-5     |4-0          |  
|-----|-----------------------|---------------------|------|---------|-------------|
|[Condition](#instruction-format)| 00                |000                  |1     |Immidiate (16 downto 0)|Destination Register|

The immidiate value consists of 16 bits which are extended to 32 bits so that the upper 16 bits are zero. The zero-extended 32 bit value is loaded into the specified register.

Assembly Syntax Example: 
```
move R0, 42 #Moves the value 42 into the Register R0.
```
If the immidiate is larger than 16 bits, the assembler will  split the `move` instruction into multiple machine code instructions. 
It will load the upper 16 bits first into the lower 16 bits of the register, then shift them to the left by 16 bits 
and OR the result with the zero extended lower 16 bits.

If the immidiate enable bit is not set, the instruction is decoded like this:
|31-28| 27-26                 |24-22                |21    |20-10      |9-5            |4-0                  |  
|-----|-----------------------|---------------------|------|-----------|---------------|---------------------|
|[Condition](#instruction-format)| 00                |000                  |0     |00000000000|Source Register|Destination Register |

Assembly Syntax Example: 
```
move R0, R1 #This copies the value of R1 into R0.
```

#### `load` 

#### `store`

#### `push`

#### `pop`

### Data Processing

### Controll Flow
The controll flow instructions have a 2 bit op-code and a condition:
|  31-28                          |27-26     |25 downto 0|       
|---------------------------------|----------|-----------|
| [Condition](#instruction-format)|Op-Code   |Parameters |

The following operation codes are available
| Operation                    | Assembly Command   | Operation Code|
|------------------------------|--------------------|---------------|
| Jump to Instruction          | [`jump`](#jump)    |00             |
| Jump to Instruction with Link| [`jumpl`](#jumpl)  |01             |
| Return to address in LR      | [`return`](#return)|10             |


#### `jump`
This instruction can be used to make absolute or relative jumps to different parts in the program. It will not save the current value of the program counter in the link register.
|31-28                           | 27-26                 |25                  |24-0      |
|--------------------------------|-----------------------|--------------------|----------|
|[Condition](#instruction-format)| 00                    |Immidiate Offset Enable Bit|Parameters|

If the immidiate offset enable bit is set, the instruction is decoded as follows:
|31-28                           | 27-26                 |25|24-0      |
|--------------------------------|-----------------------|--|----------|
|[Condition](#instruction-format)| 00                    |1 |Offset    |

The offset is a 25 bit signed integer which is added to the PC. 

Assembly Syntax Example: 
```
jump 100 #Adds 100 to the PC.
```

If the immidiate offset enable bit is not set, the instruction is decoded as follows:
|31-28                           | 27-26                 |25|24               |23-5      |4-0            |
|--------------------------------|-----------------------|--|-----------------|----------|---------------|
|[Condition](#instruction-format)| 00                    |0 |Offset Enable Bit|000...000 |Source Register|

If the offset enable bit is set, the value inside the source register will be treated as a signed integer and added to the PC to execute the jump.

Assembly Syntax Example: 
```
jump R0 #Adds the signed integer value located in R0 to the PC.
```
If the offset enable bit is not set, the value inside the PC will be replaced with the value inside the Source Register.

Assembly Syntax Example: 
```
jump [R6] #Sets the PC to the unsigned integer value located in R6.
```

#### `jumpl`
This instruction works just like the [`jump`](#jump) instruction. However, it also saves the current value of the PC to the link register.
|31-28                           | 27-26                 |25                  |24-0      |
|--------------------------------|-----------------------|--------------------|----------|
|[Condition](#instruction-format)| 01                    |Immidiate Offset Enable Bit|Parameters|

Assembly Syntax Example: 
```
jumpl 100 #Saves current value of PC to link register and adds 100 to the PC.
```

#### `return`
This instruction moves the value located inside the link register back to the PC.
|31-28                           | 27-26                 |25-0     |
|--------------------------------|-----------------------|---------|
|[Condition](#instruction-format)| 10                    |000...000|

Assembly Syntax Example: 
```
return #restores the PC from the link register.
```

### Special Instructions

