define delay 5

define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054     
define displayControl        0b00000000111101000010010000100100

setup: 
    ;initializing 7 segment display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ;save address for writing to 7 segment display in register
    MOV R0, displayDataAddress

    ;initializing registers
    MOV R1, delay ;reference register for counting instructions
    MOV R2, 0  ;register for counting numbers


main: 
    ;sending count data to 7 segment display
    STORE R2, [R0]

    MOV R3, 0 ;register for counting instructions
    loop:
        ADD R3, R3, 1
        CMP R3, R1
        JUMPNE loop ;jump if not equal

    ADD R2, R2, 1
    JUMP main