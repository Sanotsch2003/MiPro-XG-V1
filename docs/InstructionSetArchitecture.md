# Custom Instruction Set Architecture (ISA)

## Table of Contents
1. [Overview](#overview)
2. [Architecture Details](#architecture-details)
   - [Registers](#registers)
   - [Instruction Format](#instruction-format)
3. [Instruction Classes](#instruction-classes)
   - [Data Processing](#data-processing)
   - [Data Movement](#data-movement)
   - [Special Instructions](#special-instructions)
   - [Control Flow](#control-flow)
4. [Writing Assembly](#writing-assembly)
    - [Aliases](#aliases)


## Overview
| **Instruction Class**                       | **Action**                                 | **Assembly Command**                                                                 | **Description**                                                                 |
|---------------------------------------------|--------------------------------------------|--------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| [Data Processing](#data-processing)         | Logical AND                                | [`AND`](#and-tst-eor-teq-orr-bic-not), [`TST`](#and-tst-eor-teq-orr-bic-not)         | Perform bitwise AND (`TST` sets CPSR flags but doesn't store the result).       |
|                                             | Logical Exclusive OR                       | [`EOR`](#and-tst-eor-teq-orr-bic-not), [`TEQ`](#and-tst-eor-teq-orr-bic-not)         | Perform bitwise XOR (`TEQ` sets CPSR flags but doesn't store the result).       |
|                                             | Logical OR                                 | [`ORR`](#and-tst-eor-teq-orr-bic-not)                                                | Perform bitwise OR.                                                             |
|                                             | Bit Clear (AND NOT)                        | [`BIC`](#and-tst-eor-teq-orr-bic-not)                                                | Perform bitwise AND with the complement of the second operand.                  |
|                                             | Bitwise NOT                                | [`NOT`](#and-tst-eor-teq-orr-bic-not)                                                | Perform bitwise NOT of the second operand.                                      |
|                                             | Subtraction                                | [`SUB`](#sub-cmp-bus-add-cmn-adc-sbc-bsc), [`CMP`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) | Subtract operands (`CMP` sets CPSR flags but doesn't store the result).         |
|                                             | Reverse Subtraction                        | [`BUS`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)                                            | Reverse subtraction (second operand minus first operand).                       |
|                                             | Addition                                   | [`ADD`](#sub-cmp-bus-add-cmn-adc-sbc-bsc), [`CMN`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) | Add operands (`CMN` sets CPSR flags but doesn't store the result).              |
|                                             | Addition with Carry                        | [`ADC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)                                            | Add operands and include the carry flag.                                        |
|                                             | Subtraction with Borrow                    | [`SBC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)                                            | Subtract operands with carry-in, adjust for borrow.                             |
|                                             | Reverse Subtraction with Borrow            | [`BSC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)                                            | Reverse subtraction with carry-in.                                              |
|                                             | Move                                       | [`MOV`](#mov)                                                                        | Move immediate or register value into the destination.                          |
|                                             | Multiply (Signed, Truncate)                | [`MUL`](#mul-mull-umul-umull)                                                        | Multiply signed operands, and store lower 32 bits of the result.                |
|                                             | Multiply (Signed, Full 64-bit)             | [`MULL`](#mul-mull-umul-umull)                                                       | Multiply signed operands, and store 64-bit result in two registers.             |
|                                             | Multiply (Unsigned, Truncate)              | [`UMUL`](#mul-mull-umul-umull)                                                       | Multiply unsigned operands, and store lower 32 bits of the result.              |
|                                             | Multiply (Unsigned, Full 64-bit)           | [`UMULL`](#mul-mull-umul-umull)                                                      | Multiply unsigned operands, and store 64-bit result in two registers.           |
|[Data Movement](#data-movement)              | Load from Memory                           | [`LOAD`](#load-and-loadw), [`LOADW`](#load-and-loadw)                                | Load 32-bit value from memory into a register (`LOADW` writes address back).    |
|                                             | Store to Memory                            | [`STORE`](#store-and-storew), [`STOREW`](#store-and-storew)                          | Store 32-bit value from a register into memory (`STOREW` writes address back).  |
|[Special Instructions](#special-instructions)| No Operation                               | [`PASS`](#pass)                                                                      | Do nothing.                                                                     |
|                                             | Halt Execution                             | [`HALT`](#halt)                                                                      | Pause execution, await interrupts.                                              |
|                                             | Software Interrupt                         | [`SIR`](#sir)                                                                        | Trigger a software interrupt.                                                   |
|                                             | Software Reset                             | [`RES`](#res)                                                                        | Reset the processor                                                             |
| [Control Flow](#control-flow)               | Jump                                       | [`JUMP`](#jump)                                                                      | Jump to a specific instruction (relative or absolute).                          |
|                                             | Jump with Link                             | [`JUMPL`](#jumpl)                                                                    | Jump and save the current PC in the link register.                              |


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
- If possible, `R12` and `R11` should only be used as temporary registers, as the assembler will sometimes create additional machine instructions that overwrite those two registers to load immediate values.
- The CPSR contains contains 8 bits:
  |Bit    |7      |6      |5      |4      |3            |2                |1                |0             |
  |-------|-------|-------|-------|-------|-------------|-----------------|-----------------|--------------|
  |Meaning|Ignored|Ignored|Ignored|Ignored|Zero Flag (Z)|Negative Flag (N)|Overflow Flag (O)|Carry Flag (C)|
  
- Not all instructions support the `CPSR`.
- If it is supported, data access works like this: 
   - **Writing to the register**: Only the least significant bits of the data bus are written into the register, and the remaining bits are ignored.
   - **Reading from the register**: The value is placed on the least significant bits of the data bus, while all remaining bits on the bus are cleared.

### Instruction Format

#### Instruction classes:
Instructions consist of 32 bits. Each Instruction is only executed if the condition is met. Instructions are divided into instruction classes: 

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
| [Control Flow](#control-flow)                 |Condition| 011                   |Opcode               | Parameters |

**Important Note**: Some instructions support using immediate values. Immediates are written as numbers in decimal, hexadecimal, or binary format.

Assembly Syntax Examples: 
```
;Comments are written like this.

MOV R4, 5 ;moves the immediate value 5 into R4.
MOV R4, 0b111 ;moves the immediate value 5 into R4.
MOV R4, 0x5 ;moves the immediate value 5 into R4.

;All instructions do the exact same thing.
```

#### Conditions:
The following conditions can be chosen:

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

A condition Suffix can be added to each assembly instruction to execute it under a certain condition.

Assembly Syntax Example: 
```
MOVEQ R4, R3 ;The MOV instruction is only executed if the Z-flag is set.
```

**Important Note**: Instead of adding the suffix `AL`, no suffix can be added to avoid checking for any conditions.

#### Applying shifts and rotations within instructions:

Some instructions allow you to alter the value of a register within the instruction by shifting or rotating the bits by a certain amount. For these rotate/shift operations, 8 bits will be reserved within the instruction:

|31-28                           | 27-x                         |(x-1) downto (x-8)   |(x-9) downto 0 |
|--------------------------------|------------------------------|---------------------|----------------|
|[Condition](#instruction-format)| Some Bits                    |Bit Manipulation     |Some Bits       |

If an instruction allows you to use shifts and rotations on certain bits, the corresponding section within the instruction will be labeled with [Bit Manipulation](#applying-shifts-and-rotations-within-instructions).
It works like this:

|7-6                      | 5                            |4-0                  |
|-------------------------|------------------------------|---------------------|
|Bit Manipulation Method  | Use Register Enable Bit      |Operand              |

The following Bit Manipulation Methods are available:

| Manipulation Method  | Assembly Command              | Bit Code |
|----------------------|-------------------------------|----------|
|rotate left           | [`ROL`](#rol)                 | 00       |
|logical shift left    | [`LSL`](#lsl)                 | 01       |
|logical shift right   | [`LSR`](#lsr)                 | 10       |
|arithmetic shift right| [`ASR`](#asr)                 | 11       |


If The "Use Register Enable Bit" is not set, the operand will be interpreted as an integer and will be used to specify the shift/rotate amount. 

|7-6                      | 5                            |4-0                  |
|-------------------------|------------------------------|---------------------|
|Bit Manipulation Method  | 0                            |Integer value        |

Assembly Syntax Example: 
```
MOV R4, R3, LSR 3 ;This command takes the value in R3, shifts it to the right by 3 bits, and writes it into R4.
```
**Important Notes**:
- If one of the shift/rotate commands is used, it will always be the last parameter of an assembly instruction.
- The specific register/immediate which the shift/rotate command acts upon will be explained for each instruction.


The operand can also be interpreted as a register if the "Use Register Enable Bit" is set. In this case, the shift amount will be specified by the 5 least significant bits of the register:

|7-6                      | 5                            |4       |3-0                  |
|-------------------------|------------------------------|--------|---------------------|
|Bit Manipulation Method  | 1                            |Ignored |Register             |

Assembly Syntax Example: 
```
MOV R4, R3, LSR R7 ;This command takes the value in R3, shifts it to the right by the amount specified by the unsigned integer value of the 6 least significant bits in R7 and writes it into R4.
```
**Important Note**: In the example above `R7` **cannot** be replaced with `CPSR`.

## Instruction Classes

### Data Processing
The data processing instructions have a 4-bit op-code:
|31-28                           | 27                 |26-23               |22-0      |  
|--------------------------------|--------------------|--------------------|----------|
|[Condition](#instruction-format)| 1                  |Op-Code             |Parameters|

The following op-codes are available:

| Action                                 | Assembly Command (Result is written)      | Assembly Command (Result is not written)            |OP-Code |
|----------------------------------------|-------------------------------------------|-----------------------------------------------------|--------|
| operand 1 AND operand 2                | [`AND`](#and-tst-eor-teq-orr-bic-not)     | [`TST`](#and-tst-eor-teq-orr-bic-not)               | 0000   |
| operand 1 EOR operand 2                | [`EOR`](#and-tst-eor-teq-orr-bic-not)     | [`TEQ`](#and-tst-eor-teq-orr-bic-not)               | 0001   |
| operand 1 OR operand2                  | [`ORR`](#and-tst-eor-teq-orr-bic-not)     |/                                                    | 0010   |
| operand 1 AND NOT operand2             | [`BIC`](#and-tst-eor-teq-orr-bic-not)     |/                                                    | 0011   |
| NOT operand 2 (operand 1 is ignored)   | [`NOT`](#and-tst-eor-teq-orr-bic-not)     |/                                                    | 0100   |
| operand 1 - operand 2                  | [`SUB`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) | [`CMP`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)           | 0101   |
| operand 2 - operand 1                  | [`BUS`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) |/                                                    | 0110   |
| operand 1 + operand 2                  | [`ADD`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) | [`CMN`](#sub-cmp-bus-add-cmn-adc-sbc-bsc)           | 0111   |
| operand 1 + operand 2 + carry          | [`ADC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) |/                                                    | 1000   |
| operand 1 - operand 2 + carry - 1      | [`SBC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) |/                                                    | 1001   |
| operand 2 - operand 1 + carry - 1      | [`BSC`](#sub-cmp-bus-add-cmn-adc-sbc-bsc) |/                                                    | 1010   |
| operand 2 (operand 1 is ignored)       | [`MOV`](#mov)                             |/                                                    | 1011   |

| Action                                 | Assembly Command (32 bit result is written)      | Assembly Command (64 bit result is written)         |OP-Code |
|----------------------------------------|--------------------------------------------------|-----------------------------------------------------|--------|
| opearnd 1 * operand 2 (32 bit)         | [`MUL`](#mul-mull-umul-umull)                    |[`MULL`](#mul-mull-umul-umull)                       | 1100   |
| opearnd 1 * operand 2 (64 bit)         | [`UMUL`](#mul-mull-umul-umull)                   |[`UMULL`](#mul-mull-umul-umull)                      | 1101   |


#### `AND`, `TST`, `EOR`, `TEQ`, `ORR`, `BIC`, `NOT`

All of these instructions follow the same scheme:

|31-28                           | 27                    |26-23               | 22                   | 21                      | 20-13                                                                  |12       | 11-8              | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------|-------------------------|------------------------------------------------------------------------|---------|-------------------|--------------------|---------------------|
|[Condition](#instruction-format)| 1                     |Op-Code             | Mask Enable Bit      | Disable Write Back Bit  | [Bit Manipulation](#applying-shifts-and-rotations-within-instructions) |Ignored  |Operand 1 Register | Operand 2          | Destination Register|

- The [Bit Manipulation](#applying-shifts-and-rotations-within-instructions) will be applied to operand 2.
- All instructions will set the CPSR flags.
- The `TST` and `TEQ` instruction will ignore the destination register.
- The `NOT` instruction will ignore operand 1.
- If the "Disable Write Back Bit" is set, the result will not be written back to the destination register (Only Assembly instructions for AND without write back (`TST`) and EOR without write back (`TEQ`) exist). 
- If the "Mask Enable Bit" is not set, operand 2 will be interpreted as a register.
- If the "Mask Enable Bit" is set, operand 2 will be interpreted as a 32-bit mask (More Masks can be generated through shifting).

Available Bit Masks:
|   Bits 11-8   | Mask           | Description                        |
|---------------|----------------|------------------------------------|
| 0000          | 0x00000000     | All bits cleared (zero mask)       |
| 0001          | 0x00000001     | Single bit mask (bit 0)            |
| 0010          | 0x00000003     | Lower 2 bits (bits 1 and 0)        |
| 0011          | 0x0000000F     | Lower nibble (bits 3-0)            |
| 0100          | 0x000000FF     | Lower byte (bits 7-0)              |
| 0101          | 0x0000FF00     | Lower two bytes (bits 15-8)        |
| 0110          | 0x0F0F0F0F     | Alternating nibbles                |
| 0111          | 0xF0F0F0F0     | Alternating nibbles (reversed)     |
| 1000          | 0x55555555     | Even bits (alternating 0 and 1)    |
| 1001          | 0xAAAAAAAA     | Odd bits (alternating 1 and 0)     |
| 1010          | 0xFFFFFFFF     | All bits set (full mask)           |
| 1011          | 0x00000000     |------------------------------------|
| 1100          | 0x00000000     |------------------------------------|
| 1101          | 0x00000000     |------------------------------------|
| 1110          | 0x00000000     |------------------------------------|
| 1111          | 0x00000000     |------------------------------------|

Assembly Syntax Examples: 
```
AND R4, R3, R2 ;This will AND R3 and R2, set write the result to R4.
AND R4, R3, R2, ROL R7 ;This will rotate the value R2 by the value in R7, AND it with R3 and copy it into R4.

NOT R4, R4 ;This will NOT the value in R4, and write it back to R4.

TST R5, 0x00000001 ;This will AND the value in R5 with 0x00000001 and set the CPSR flags. This is effectively checking if the first bit in R5 is set.

TST R5, 0x00000002 ;This is the same as above but it will check if the second bit in R5 is set. Even though this Mask is not available, the instruction will work, because the assembler will load 0x00000002 into a temporary register (R12) first (second machine instruction needed).

TST R5, 0x00000001, LSL 1 ;This achieves the same as the example above but will execute faster because 0x00000001 is an available mask that can be shifted right to obtain 0x00000002.

;Eventually the Assembler might be able to automatically translate TST R5, 0x00000002 into TST R5, 0x00000001, LSL 1. However, this will not be implemented at first.
```

**Important Note**: The `CPSR` **cannot** be used as an operand or the destination register.

#### `SUB`, `CMP`, `BUS`, `ADD`, `CMN`, `ADC`, `SBC`, `BSC`

All of these instructions follow the same scheme:

|31-28                           | 27                    |26-23               | 22                   | 21                      | 20-13                                                                  |12       | 11-8              | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------|-------------------------|------------------------------------------------------------------------|---------|-------------------|--------------------|---------------------|
|[Condition](#instruction-format)| 1                     |Op-Code             | Immediate Enable Bit | Disable Write Back Bit  | [Bit Manipulation](#applying-shifts-and-rotations-within-instructions) |ignored  |Operand 1 Register | Operand 2          | Destination Register|

- The [Bit Manipulation](#applying-shifts-and-rotations-within-instructions) will be applied to operand 2.
- The `CMP` and `CMN` instructions will ignore the destination register.
- If the "Disable Write Back Bit" is set, the result will not be written back to the destination register (Only Assembly instructions for SUBTRACT without write back (`CMP`) and ADD without write back (`CMN`) exist). 
- If the "Immediate Enable Bit" is not set, operand 2 will be interpreted as a register.
- If the "Immediate Enable Bit" is set, operand 2 will be interpreted as an immediate value.
- If the "Immediate Value is larger than `0b11111`, the assembler will load the Immediate into a temporary register (`R12`) first.

Assembly Syntax Examples: 
```
ADD R1, R2, R3 ;Computes R2+R3 and writes the result into R1.

BUS R2, R6, 0 ;Computes  0-R6 and writes the result into R2.

CMP PC, R4, ;Computes PC-R4 and sets the status flags.

ADD R1, R2, 1024 ;Computes R2+1024 and writes the result into R1. However, a second machine instruction is needed to load 1024 into a temporary register.
ADD R1, R2, 0b1, LSL 10 ;Does the same as the Assembly command above, but this one only needs one machine instruction. 
```

**Important Note**: The `CPSR` **cannot** be used as an operand or the destination register.

#### `MUL`, `MULL`, `UMUL`, `UMULL`

All of these instructions follow the same scheme:

|31-28                           | 27                    |26-23               | 22                   | 21                      | 20-13                                                                  |12       | 11-8              | 7-4                | 3-0                 |  
|--------------------------------|-----------------------|--------------------|----------------------|-------------------------|------------------------------------------------------------------------|---------|-------------------|--------------------|---------------------|
|[Condition](#instruction-format)| 1                     |Op-Code             | Immediate Enable Bit | Write Long Enable Bit   | [Bit Manipulation](#applying-shifts-and-rotations-within-instructions) |ignored  |Operand 1 Register | Operand 2          | Destination Register|

These instructions work exactly as the one [above](sub-cmp-bus-add-cmn-adc-sbc-bsc) with the slight difference that there is no "Disable Write Back Bit" but a "Write Long Enable Bit" instead. If this bit is set, the 
full 64-bit output of the multiplication will be written back. Since a 64-bit value does not fit within a single register, the lower 32 bits will be written into the destination register and the upper 32 bits will
be written into the register with the number of the destination register + 1. 

Assembly Syntax Examples: 
```
MUL R3, R1, R2 ;Computes the signed multiplication of R1 and R2 and writes the lower 32 bits of the result into R3 (truncation).

MULL R3, R1, R2 ;Computes the signed multiplication of R1 and R2 and writes the lower 32 bits of the result into R3 and the upper 32 bits of the result into R4.

UMUL R3, R1, R2, LSR L6 ;Computes the unsigned multiplication of R1 and R2 (shifted to the right by the value in L6) and writes the lower 32 bits of the result into R3 (truncation).

UMULL R3, R1, R2 ;Computes the unsigned multiplication of R1 and R2 and writes the lower 32 bits of the result into R3 and the upper 32 bits of the result into R4.
```

**Important Notes**: 
- The `CPSR` **cannot** be used as an operand or the destination register.

#### `MOV`
This instruction can be used to move an immediate value into a register or to move values between registers:

|31-28                           | 27                    |26-23               | 22                  | 21-0               |  
|--------------------------------|-----------------------|--------------------|---------------------|--------------------|
|[Condition](#instruction-format)| 1                     |1011                |Immediate Enable Bit | Parameters         |

If the "Immediate Enable Bit" is set, the instruction is decoded like this:

|31-28                           | 27                    |26-23               | 22                  | 21                           | 20-5              |4-0                 |  
|--------------------------------|-----------------------|--------------------|---------------------|------------------------------|-------------------|--------------------|
|[Condition](#instruction-format)| 1                     |1011                | 1                   | Load Higher Bytes Enable Bit | Immediate Value   |Destination Register|

- If the "Load Higher Bytes Enable Bit" is not set, the immediate value will be placed on the lower two bytes of the data bus while the remaining bits are set to zero. This value is then loaded into the destination register.
- If the "Load Higher Bytes Enable Bit" is set, the immediate value will be placed on the higher two bytes of the data bus while the remaining bits are set to zero. This value will then be ANDed with the destination register and written back to it.
This distinction is only made by the compiler to load 32-bit values into a register.

Assembly Syntax Example: 
```
MOV R1, 0xFFFF ;Copies 0xFFFF into R1.
```

**Important Notes**: 
- The `CPSR` **can** be used as the destination register.
- You **cannot** use this instruction to load 2 bytes into a register and leave the remaining 2 bytes unchanged. If you want to achieve this behavior, you will need to work with multiple instructions and bit masks.


If the "Immediate Enable Bit" is not set, the instruction is decoded like this:

|31-28                           | 27                    |26-23               | 22-21               | 20-13                                                                   | 12-10             | 9-5             |4-0                 |  
|--------------------------------|-----------------------|--------------------|---------------------|-------------------------------------------------------------------------|-------------------|-----------------|--------------------|
|[Condition](#instruction-format)| 1                     |1011                | 00                  | [Bit Manipulation](#applying-shifts-and-rotations-within-instructions)  | Ignore            | Source Register |Destination Register|

Assembly Syntax Examples: 
```
MOV R1, R2 ;Copies R2 into R1.

MOV R1, R1, ROL R2 ;Rotates the value in R1 to the left by an amount specified in R2 and writes it back to R1.
```

**Important Note**: The `CPSR` **can** be used as the source or destination register when moving values between registers.

### Data Movement

The data movement instructions have a 3-bit op-code:
|31-28                           | 27-26                 |25-23                |22-0      |
|--------------------------------|-----------------------|---------------------|----------|
|[Condition](#instruction-format)| 00                    |Op-Code              |Parameters|

The following operation codes are available (More data movement instructions might be added in the future):

| Action                | Assembly Command                         | Op-Code |
|-----------------------|------------------------------------------|---------|
| load from memory      | [`LOAD` and `LOADW`](#load-and-loadw)    | 000     |
| store into memory     | [`STORE` and `STOREW`](#store-and-storew)| 001     |
(16 and 8 Bit Load and Store might be added in the future)

#### `LOAD` and `LOADW` 
This instruction can be used to load a 32-bit value from memory into a register. 

|31-28                           | 27-26                 |25-23                |22                 | 21                | 20-8                                                    |7-4             |3-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|-------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    | 000                 | Write Back Bit    | Offset Enable Bit | Address Manipulation Bits                               |Address Register|Destination Register |

Here, the 32-bit value in memory at the address specified by the address register will be loaded into the destination register. Optionally, the address can be 
altered by using the address manipulation bits. If the "Write Back Bit" is set the altered address will be written back to the address register, otherwise the value in the address register will stay unchanged even 
when the address has been altered.

If the "Offset Enable Bit" Is set, the bits 19-8 are interpreted as a 12-bit unsigned integer, which is added or subtracted (depending on whether the "Subtract Bit" is set) to/from the address specified by the address register:

|21               | 20             | 19-8       |
|-----------------|----------------|------------|
|1                | Subtract Bit   | Offset     |

Assembly Syntax Example: 
```
LOAD R4, [R0] ;This copies the value at the memoriy address specified by R0 into R4.
LOAD R4, [R0+127] ;This copies the value at the memoriy address specified by R0+127 into R4.
```

If the "Offset Enable Bit" is not set, the address can be changed using [Bit Manipulation](#applying-shifts-and-rotations-within-instructions): 

|21               | 20-13                                                                  | 12-8         |
|-----------------|------------------------------------------------------------------------|--------------|
|0                |[Bit Manipulation](#applying-shifts-and-rotations-within-instructions)  | 00000        |

Assembly Syntax examples:

```
;The following two commands are translated to the same machine code instructions:

LOAD R4, [R0], ROL 31 ;This copies the value at the memory address specified by R0 (rotated to the left by 31 bits) into R4.
LOAD R4, [R0], LSL 1 ;This copies the value at the memory address specified by R0 (shifted to the left by 1 bit) into R4.

;The following two commands are the same as the ones above, but they will also write the altered address back to R0:

LOADW R4, [R0], ROL 31 
LOADW R4, [R0], ROL 1 

```

**Important Notes**: 
- This instruction **cannot** load values from memory directly into the  `CPSR`. If you want to load the `CPSR` from memory, you will have to load a temporary register first and then use the `MOV` command to copy the value to the CPSR.
- Shifting/Rotating **and** adding an offset **cannot** be combined in one instruction.

#### `STORE` and `STOREW`
This instruction can be used to copy a 32-bit value from a register into memory

|31-28                           | 27-26                 |25-23                |22                 | 21                | 20-8                                                    |7-4             |3-0                  |  
|--------------------------------|-----------------------|---------------------|-------------------|-------------------|---------------------------------------------------------|----------------|---------------------|
|[Condition](#instruction-format)| 00                    |001                  | Write Back Bit    | Offset Enable Bit | Address Manipulation Bits                               |Address Register|Source Register      |

Here, the 32 bit value in the Source register will be loaded into memory at the address specified by the address register. Optionally, the address can be 
altered by using the methods mentioned [above](#LOAD-and-LOADW).

Some Assembly Syntax examples:

```
;The following two commandss are translated to the same machine code instructions.

STORE R4, [R0], ROL 31 ;This copies the value in R4 into memory at the address specified by R0 (rotated to the left by 31 bits).
STORE R4, [R0], ASR 7 ;This copies the value in R4 into memory at the address specified by R0 (shited arithmetically to the right by 7).

;The following two commands are the same as the ones above, but they will also write the altered address back to R0:

STOREW R4, [R0], ROL 31
STOREW R4, [R0], ASR 1 

STORE R4, [R0-17] ;This copies the value in R4 into memory at the address specified by R0-17.
```

**Important Notes**: 
- This instruction **cannot** store the `CPSR` directly to memory. If you want to store the status flags, you will have to move them to a temporary register first using the `MOV` command and then store them in memory.
- Shifting/Rotating **and** adding an offset **cannot** be combined in one instruction.


### Special Instructions
The special instructions have a 4-bit op-code:
|  31-28                          |27-25 |24-21     |20 downto 0|       
|---------------------------------|------|----------|-----------|
| [Condition](#instruction-format)|010   |Op-Code   |Parameters |

The following op-codes are available:
| Action                       | Assembly Command   | OP-Code         |
|------------------------------|--------------------|-----------------|
| Do nothing                   | [`PASS`](#pass)    |0000             |
| Wait for Interrupt           | [`HALT`](#halt)    |0001             |
| Software Interrupt           | [`SIR`](#sir)      |0010             |
| Software Reset               | [`RES`](#res)      |0011             |

#### `PASS`
This instruction does nothing and skips. All undefined instructions will be ignored by the processor and effectively achieve the same behavior. 
However, since new instructions might be defined in the future, it is important to use this specific instruction as its behavior will
not change in the future. The condition has no effect on this instruction as it will do nothing regardless if the condition is met or not.

|31-28                           |27-25| 24-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|010  | 0000                  |000...000|

Assembly Syntax Example: 
```
PASS ;does nothing
```

#### `HALT`
This instruction pauses the execution of instructions. The processor will keep listening to interrupt signals and execute given interrupt handlers. 

|31-28                           |27-25| 25-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|010  | 0001                  |000...000|

Assembly Syntax Example: 
```
HALT ;pauses the execution of instructions.
```

#### `SIR`
This instruction will trigger a software interrupt. 

|31-28                           |27-25| 25-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|010  | 0010                  |000...000|

Assembly Syntax Example: 
```
SIR ;triggers a software interrupt.
```

#### `RES`
This instruction will reset the processor and effectively achieve the same as pressing the reset button. 

|31-28                           |27-25| 25-22                 |21-0     |
|--------------------------------|-----|-----------------------|---------|
|[Condition](#instruction-format)|010  | 0011                  |000...000|

Assembly Syntax Example: 
```
RES ;reset the processor to its default state.
```

### Control Flow

The control flow instructions have a 2 bit op-code:

|  31-28                          |27-25 |24-23     |22-0       |       
|---------------------------------|------|----------|-----------|
| [Condition](#instruction-format)|011   |Op-Code   |Parameters |

The following op-codes are available:

| Action                       | Assembly Command   | Op-Code       |
|------------------------------|--------------------|---------------|
| Jump to Instruction          | [`JUMP`](#jump)    |00             |
| Jump to Instruction with Link| [`JUMPL`](#jumpl)  |01             |


#### `JUMP`
This instruction can be used to make absolute or relative jumps to different parts of the program. It will not save the current value of the program counter to the link register.
|31-28                           |27-25| 24-23                 |22                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|011  | 00                    |Immediate Offset Enable Bit|Parameters|

If the "Immediate Offset Enable Bit" is set, the instruction is decoded as follows:

|31-28                           |27-25| 24-23                 |22|21          |20-0      |
|--------------------------------|-----|-----------------------|--|------------|----------|
|[Condition](#instruction-format)|011  | 00                    |1 |Subtract Bit|Offset    |

The offset is a 21-bit unsigned integer, which is added/subtracted (depending on whether the "Subtract Bit" is set) to/from the PC. 

Assembly Syntax Example: 
```
JUMP 100 ;Adds 100 to the PC.
JUMP -100 ;Subtracts 100 from the PC.
```

If the "Immediate Offset Enable Bit" is not set, the instruction is decoded as follows:

|31-28                           |27-25| 24-23                 |22|21                             |20-13                                                                  |12-4     |3-0            |
|--------------------------------|-----|-----------------------|--|-------------------------------|-----------------------------------------------------------------------|---------|---------------|
|[Condition](#instruction-format)|011  | 00                    |0 | Register as Offset Enable Bit |[Bit Manipulation](#applying-shifts-and-rotations-within-instructions) | Ignored |Source Register|

If the "Register as Offset Enable Bit" is set, the value inside the source register will be treated as a signed integer and added to the PC to execute the jump. (Before it is added,
a shift/rotate operation can be applied to the offset before it is added.)

Assembly Syntax Example: 
```
JUMP R0 ;Adds the signed integer value located in R0 to the PC.
JUMPEQ R0 ;Same as above but only performs the jump if the z-flag is set.
JUMP R1, ROL R2 ;Takes the value in R1, rotates it to the left by the value specified by R2, and adds it to the PC.
```

If the "Register as Offset Enable Bit" is not set, the value inside the PC will be replaced with the value inside the Source Register. In this case, 
the source register acts as the jump address. (Before the jump the new address is written to the PC, a shift/rotate operation can be performed.)

Assembly Syntax Example: 
```
JUMP [R6] ;Copies R6 into the PC.
JUMP [R7], ASR 1 ;performs an arithmetic shift to the right by 1 bit on R7 and copies the resulting value into the PC.
```

**Important Note**: The `CPSR` **cannot** be used as the source register.

#### `JUMPL`

This instruction works just like the [`JUMP`](#jump) instruction. However, it also saves the current value of the PC to the link register.

|31-28                           |27-25| 24-23                 |22                         |22-0      |
|--------------------------------|-----|-----------------------|---------------------------|----------|
|[Condition](#instruction-format)|011  | 01                    |Immediate Offset Enable Bit|Parameters|

Assembly Syntax Example: 
```
JUMPL 100 ;Saves current value of PC to link register and adds 100 to the PC.

JUMPL [R9], LSL 2 ;Saves current value of PC to link register, shifts R9 to the left by 2 bits, and copies the resulting value into the PC.
```
**Important Note**: The `CPSR` **cannot** be used as the source register.

## Writing Assembly
In the previous chapters, all machine instructions and their corresponding assembly commands were explained. This chapter will point out some other important features of this assembly language that will be necessary to start developing software.
Some code examples can be found [here](src/Software/examplePrograms). If you have any questions please open an Issue in the GitHub repository

### Aliases
When writing assembly code, some aliases for some frequently used commands can be used to simplify programming:

| **Alias**          | **Actual Instruction**                 | **Description**                                                  |
|--------------------|----------------------------------------|------------------------------------------------------------------|
| `RETURN`           | `MOV PC, LR`                           | Return from a subroutine by restoring the link register into the PC. |
| `CLEAR Rn`         | `MOV Rn, 0`                            | Clear register `Rn` (set to zero).                            |
| `SET Rn`           | `ORR Rn, 0xFFFFFFFF`                   | Set all bits in register `Rn` to 1.                              |

