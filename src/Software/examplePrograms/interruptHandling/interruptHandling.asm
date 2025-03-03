define IVT_addr_invalidInstructionInterrupt   0x3FFFFE00
define IPR_addr_invalidInstructionInterrupt   0x3FFFFE04

define IVT_addr_softwareInterrupt             0x3FFFFE08
define IPR_addr_softwareInterrupt             0x3FFFFE0C

define IVT_addr_addressAlignmentInterrupt     0x3FFFFE10
define IPR_addr_addressAlignmentInterrupt     0x3FFFFE14

define IVT_addr_readOnlyInterrupt             0x3FFFFE18
define IPR_addr_readOnlyInterrupt             0x3FFFFE1C

define IVT_addr_hardwareTimer0Interrupt       0x3FFFFE20
define IPR_addr_hardwareTimer0Interrupt       0x3FFFFE24

define IVT_addr_hardwareTimer1Interrupt       0x3FFFFE28
define IPR_addr_hardwareTimer1Interrupt       0x3FFFFE2C

define IVT_addr_hardwareTimer2Interrupt       0x3FFFFE30
define IPR_addr_hardwareTimer2Interrupt       0x3FFFFE34

define IVT_addr_hardwareTimer3Interrupt       0x3FFFFE38
define IPR_addr_hardwareTimer3Interrupt       0x3FFFFE3C

define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000110100

; Writing interrupt handler addresses to IVTs and setting interrupt priorities.
MOV R0, IVT_addr_invalidInstructionInterrupt
MOV R1, invalidInstructionInterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_invalidInstructionInterrupt
MOV R1, 1 ; Set Priority
STORE R1, [R0]

MOV R0, IVT_addr_softwareInterrupt
MOV R1, softwareInterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_softwareInterrupt
MOV R1, 1 ; Set Priority
STORE R1, [R0]

MOV R0, IVT_addr_addressAlignmentInterrupt
MOV R1, addressAlignmentInterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_addressAlignmentInterrupt
MOV R1, 1 ; Set Priority
STORE R1, [R0]

MOV R0, IVT_addr_readOnlyInterrupt
MOV R1, readOnlyInterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_readOnlyInterrupt
MOV R1, 1 ; Set Priority
STORE R1, [R0]

MOV R0, IVT_addr_hardwareTimer3Interrupt
MOV R1, hardwareTimer3InterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_hardwareTimer3Interrupt
MOV R1, 1 ; Set Priority 
STORE R1, [R0]

JUMP setup

; Interrupt Handlers
invalidInstructionInterruptHandler:
    ; Write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Write Error Code to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R1, 0xEE00 ; Error Code
    STORE R1, [R0]
    HALT ; Halt the program

softwareInterruptHandler:
    ; Write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Write Software Interrupt Code to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R1, 0xEE01 ; Code for Software Interrupt
    STORE R1, [R0]
    HALT ; Halt the program

addressAlignmentInterruptHandler:
    ; Write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Write Address Alignment Error Code to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R1, 0xEE02 ; Address Alignment Error Code
    STORE R1, [R0]
    HALT ; Halt the program

readOnlyInterruptHandler:
    ; Write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Write Read-Only Error Code to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R1, 0xEE03 ; Read-Only Error Code
    STORE R1, [R0]
    HALT ; Return from interrupt

hardwareTimer3InterruptHandler:
    ADD R6, R6, 1 ; Increment R6
    ; Display R6 on Seven segment Display
    MOV R7, displayDataAddress
    STORE R6, [R7]
    IRET ; Return From Interrupt


define delayIterations        30000
define PWM0Address            0x400000B0
define PWM1Address            0x400000C0
define PWM2Address            0x400000D0

define RED R3
define GREEN R4
define BLUE R5

setup:
    ;Initialize 7 Segment Display
    ; Write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R1, 0b00000000111101000010010000100100
    STORE R1, [R0]

    ; Set maxCount of Timer 3 to 50.000.000 so that it will reset every second
    MOV R0, 0x4000009C       ; Load address of Timer 3 Max Count in to R0.
    MOV R1, 50000000              ; Load 0b11 into R1: Periodic Mode
    Store R1, [R0]           ; Store value from R1 to Timer 3 Mode.

    ; Turn on Timer 3 in Periodic Mode
    MOV R0, 0x400000A0       ; Load address of Timer 3 Mode in to R0.
    MOV R1, 0b11             ; Load 0b11 into R1: Periodic Mode
    Store R1, [R0]           ; Store value from R1 to Timer 3 Mode.

    ; Turn on Timer 0
    MOV R0, 0x40000070       ; Load address of Timer 0 Mode in to R0.
    MOV R1, 0b01             ; Load 0b01 into R1: Free running mode
    Store R1, [R0]           ; Store value from R1 to Timer 3 Mode.

    ; Initialize digital IO Pin 0 with PWM Mode
    MOV R0, 0x400000A8      
    MOV R1, 0b10                  
    STORE R1, [R0]  

    ; Initialize digital IO Pin 0 with PWM Mode
    MOV R0, 0x400000B8      
    MOV R1, 0b10                  
    STORE R1, [R0]  

    ; Initialize digital IO Pin 0 with PWM Mode
    MOV R0, 0x400000C8      
    MOV R1, 0b10                  
    STORE R1, [R0]  

    MOV R0, PWM0Address
    MOV R1, PWM1Address
    MOV R2, PWM2Address

    MOV RED, 255
    MOV GREEN, 0
    MOV BLUE, 0 
    JUMPL updateLED

main:
    loop1:
        JUMPL delay
        JUMPL updateLED
        SUB RED, RED, 1
        ADD GREEN, GREEN, 1
        CMP RED, 0
        JUMPNE loop1

    loop2:
        JUMPL delay
        JUMPL updateLED
        SUB GREEN, GREEN, 1
        ADD BLUE, BLUE, 1
        CMP GREEN, 0
        JUMPNE loop2

    loop3:
        JUMPL delay
        JUMPL updateLED
        SUB BLUE, BLUE, 1
        ADD RED, RED, 1
        CMP BLUE, 0
        JUMPNE loop3

    JUMP main


delay: 
    ;do nothing until delay count is reached
    MOV R10, 0
    MOV R11, delayIterations
    loop:
        CMP R11, R10
        RETURNEQ
        ADD R10, R10, 1
        JUMP loop


updateLED:
    STORE RED, [R0]
    STORE GREEN, [R1]
    STORE BLUE, [R2]
    RETURN
