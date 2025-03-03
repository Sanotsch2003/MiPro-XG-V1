define IVT_addr_softwareInterrupt             0x3FFFFE08
define IPR_addr_softwareInterrupt             0x3FFFFE0C

define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000110100

MOV R0, IVT_addr_softwareInterrupt
MOV R1, softwareInterruptHandler
STORE R1, [R0]
MOV R0, IPR_addr_softwareInterrupt
MOV R1, 1 ; Set Priority
STORE R1, [R0]

JUMP setup

softwareInterruptHandler:
    ; Write control data to 7-Segment Display
    ADD R0, R0, 1
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Write Software Interrupt Code to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R1, 0xEE01 ; Code for Software Interrupt
    STORE R1, [R0]
    IRET ; return from interrupt


setup:
    MOV R2, 7
    MOV R3, 7
    CMP R2, R3
    SIR
    JUMPLEQ display
    HALT


display:
    MOV R0, displayDataAddress
    MOV R1, 0xAAAA ; Code for Software Interrupt
    STORE R1, [R0]
    Return

