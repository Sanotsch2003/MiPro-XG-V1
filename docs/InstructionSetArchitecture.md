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
<h1 style="color:red;">My Red Title</h1>
---

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

The following instruction classes exist:

| Instruction Class                             | Bit Value   |
|-----------------------------------------------|-------------|
| [Data Movement](#data-movement)               | 00          |
| [Data Processing](#data-processing)           | 01          |
| [Controll Flow](#controll-flow)               | 10          |
| [Special Instructions](#special-instructions) | 11          |

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
|31-28                           | 27-26                 |25-23                |22-0      |
|--------------------------------|-----------------------|---------------------|----------|
|[Condition](#instruction-format)| 00                    |Op-Code              |Parameters|

The following operation codes are available (More data movement instructions might be added in the future):

| Action                | Assembly command | Op-Code|
|-----------------------|------------------|--------|
| Regular move          | [`move`](#move)  |000     |
| Load from memory      | [`load`](#load)  |001     |
| Store into memory     | [`store`](#store)|010     |

#### `move`
This instruction can be used to move values between registers or to move an immidiate value into a register.
|31-28                           | 27-26                 |25-23                |22                  |21-0       |
|--------------------------------|-----------------------|---------------------|--------------------|-----------|
|[Condition](#instruction-format)| 00                    |000                  |Immidiate Enable Bit|Parameters |

If the immidiate enable bit is set, the instruction is decoded as follows:

|31-28                           | 27-26                 |25-23                |22    |21|20-5                   |4-0                 |  
|--------------------------------|-----------------------|---------------------|------|--|-----------------------|--------------------|
|[Condition](#instruction-format)| 00                    |000                  |1     |0 |Immidiate              |Destination Register|

The immidiate value consists of 16 bits which are extended to 32 bits so that the upper 16 bits are zero. The zero-extended 32 bit value is loaded into the specified register.

Assembly Syntax Example: 
```
move R0, 42 #Moves the value 42 into the Register R0.
```
If the immidiate is larger than 16 bits, the assembler will  split the `move` instruction into multiple machine code instructions. 
It will load the upper 16 bits first into the lower 16 bits of the register, then shift them to the left by 16 bits 
and OR the result with the zero extended lower 16 bits.

If the immidiate enable bit is not set, the instruction is decoded like this:
|31-28                           | 27-26                 |25-23                |22    |21-10       |9-5            |4-0                  |  
|--------------------------------|-----------------------|---------------------|------|------------|---------------|---------------------|
|[Condition](#instruction-format)| 00                    |000                  |0     |000000000000|Source Register|Destination Register |

This moves the copies the 32 bit value the source register to the destination register

Assembly Syntax Example: 
```
move R0, R1 #This copies the value of R1 into R0.
```

#### `load` 
This instruction can be used to load a 32 bit value from memory into a register. 

|31-28                           | 27-26                 |25-23                |22-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    |001                  |Address Manipulation Bits                                |Address Register|Destination Register |

Here, the 32 bit value in memory at the address specified by the address register will be loaded into the destination register. Optionally, the address can be 
altered by using the adress manipulation bits. For address manipulation, the following methods are available (only the address is altered, not the value inside the address register):


Adding an offset:

|22               |21-9        |
|-----------------|------------|
|1                |Offset      |

The 12 bit offset is interpreted as a signed integer which is added to the address specified by the source register.

Assembly Syntax Example: 
```
load R4, [R0+127] #This copies the value at the memoriy address specified by R0+127 into R4.
```

Rotating address:

|22               |21-15  |14- 9      |
|-----------------|-------|-----------|
|0                |0000000|Rotation   |

The rotation bits can be used to rotate the address to the left by a maximum amount of 32 bits (This is the same as not rotating the address at all)
In assembly language you can specify if you want to rotate left or right, but the assembler will always translate the assembly instruction into a rotate left instruction.

Assembly Syntax Example: 
```
load R4, [R0, ROL 31] #This copies the value at the memoriy address specified by R0 (rotated to the left by 31 bits) into R4.
load R4, [R0, ROR 1] #This copies the value at the memoriy address specified by R0 (rotated to the right by 1 bits) into R4.
#Both commands are translated to the same machine code instructions.
```

Logically shifting the address to the left:

|22               |21-15  |14-9                 |
|-----------------|-------|---------------------|
|0                |0000001|Logical shift left   |

The shift bits can be used to shift the address to the left by a maximum amount of 32 bits. The least significant bits are filled with zeros.

Assembly Syntax Example: 
```
load R4, [R0, LSL 4] #This copies the value at the memoriy address specified by R0 shifted to the left by 4 bits into R4.
```

Logically shifting the address to the right:

|22               |21-15|14- 9                |
|-----------------|-------|---------------------|
|0                |0000010|Logical shift right  |

The shift bits can be used to shift the address to the right by a maximum amount of 32 bits. The most significant bits are filled with zeros.

Assembly Syntax Example: 
```
load R4, [R0, LSR 20] #This copies the value at the memoriy address specified by R0 shifted to the right by 20 bits into R4.
```

Arithmetic shift to the right:

|22               |21-15  |14- 9                 |
|-----------------|-------|----------------------|
|0                |0000011|arithmetic shift right|

This performs an arithmetic shift of the address to the right. The most significant bits are signed extended. 

Assembly Syntax Example: 
```
load R6, [R3, ASR 20] #This copies the value at the memoriy address specified by R3 arithmetically shifted to the right by 20 bits into R6.
```

The assembler allows you to use commands that specify an immidiate address in memory like this:

```
load R6, [0xabcd1234] #This copies the value at the memoriy address 0xabcd1234 into R6.
```
The assembler will use one or more machine instructions from above to achieve this behavior.

#### `store`
This instruction can be used to copy a 32 bit value from a register into memory. 

|31-28                           | 27-26                 |25-23                |22-9                                                     |8-5             |4-0                  |  
|--------------------------------|-----------------------|---------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    |001                  |Address Manipulation Bits                                |Address Register|Source Register      |

Here, the 32 bit value in the Source register will be loaded into memory at the address specified by the address register. Optionally, the address can be 
altered by using the adress manipulation bits (refer to the [load](#load) instruction).

### Data Processing
The data processing instructions have a 4 bit op-code:
|31-28                           | 27-26                 |25-22               |21-0      |  
|--------------------------------|-----------------------|--------------------|----------|
|[Condition](#instruction-format)| 01                    |Op-Code             |Parameters|

The following op-codes are available:

| Action                               | Assembler Mnemonic         |op-code |
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
| operand2 (operand1 is ignored)       | [MOV](#mov)                | 1101   |
| operand1 AND NOT operand2 (Bit clear)| [BIC](#bic)                | 1110   |
| NOT operand2 (operand1 is ignored)   | [MVN](#mvn)                | 1111   |


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
|31-28                           |27-26| 25-24                 |23|22                           |21-5      |4-0            |
|--------------------------------|-----|-----------------------|--|-----------------------------|----------|---------------|
|[Condition](#instruction-format)|11   | 00                    |0 |Register as Offset Enable Bit|000...000 |Source Register|

If the 'Register as Offset Enable Bit' is set, the value inside the source register will be treated as a signed integer and added to the PC to execute the jump.

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

