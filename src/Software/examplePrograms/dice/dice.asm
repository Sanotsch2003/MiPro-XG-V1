define result R2
define temp1 R3
define temp2 R4
define temp3 R5
define seed R8
define x R9
define y R10
define previousIOStatus R6
define currentIOStatus R7

define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000101100

setup:
    ; Initialize Timer 1 (16-bit)
    ; Set prescaler to 0
    MOV R0, 0x40000078       
    MOV R1, 0x00000000       
    STORE R1, [R0]   

    ; Enable free running mode
    MOV R0, 0x40000080       
    MOV R1, 0b01       
    STORE R1, [R0]   

    ; Initialize IO Pin 1
    ; Set PinMode to input
    MOV R0, 0x400000A8       
    MOV R1, 0b01       
    STORE R1, [R0]   

    ; Initialize 7 Segment Displays
    ;write control data to 7-Segment Display
    MOV temp1, displayControlAddress
    MOV temp2, displayControl
    STORE temp2, [temp1]

    ; Initialize random number range
    MOV x, 1
    MOV y, 6

main:
    ; Read from IO pin
    MOV R0, 0x400000B4
    LOAD currentIOStatus, [R0]

    CMP currentIOStatus, previousIOStatus
    JUMPEQ main
    ; if currentIOStatus != previousIOStatus:
    MOV previousIOStatus, currentIOStatus
    ; use current timer count as seed for random number generator
    MOV R0, 0x40000084
    LOAD seed, [R0]
    JUMPL randomInRange
    ; Display result on 7 Segment Display
    MOV R0, 0x40000054
    STORE result, [R0]
    JUMP main

;Returns a random number within the closed interval [x, y]
randomInRange: ; random(x, y), seed => result
    mov temp1, 25173
    mov temp2, 13849

    UMUL temp1, temp1, seed
    ADD temp1, temp1, temp2

    MOV temp2, 65536

    MOV result, 0
    MOV temp3, 0
    loop3:
        UMUL temp3, result, temp2
        SUB temp3, temp1, temp3
        ADD result, result, 1
        CMP temp3, temp2
        JUMPLS loop3

    SUB result, result, 1
    UMUL result, result, temp2
    SUB temp1, temp1, result 

    SUB temp2, y, x
    ADD temp2, temp2, 1 

    MOV result, 0
    MOV temp3, 0
    loop4:
        UMUL temp3, result, temp2
        SUB temp3, temp1, temp3
        ADD result, result, 1
        CMP temp3, temp2
        JUMPLS loop4

    SUB result, result, 1
    UMUL result, result, temp2
    SUB result, temp1, result 

    ADD result, result, x

    RETURN