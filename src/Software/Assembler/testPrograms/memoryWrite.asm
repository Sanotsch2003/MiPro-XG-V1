define displayControlAddress 48      ;actual address: 0x40000050
define displayDataAddress    52      ;actuall address: 0x40000054

define displayControl        0x0F0F0F0F
define displayData           123

start: 
    MOV CPSR, 0b1010
    MOV R0, CPSR, ROL 30
    MOV R7, R0, ASR 23
    MOV R12, 0xFFFF
    ;MOV R0, displayControlAddress
    ;MOV R1, displayControl
    ;STORE R1, [R0]

    ;MOV R0, displayDataAddress
    ;MOV R1, displayData
    ;STORE R1, [R0]

    