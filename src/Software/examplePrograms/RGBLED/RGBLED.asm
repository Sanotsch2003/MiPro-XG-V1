define delayIterations        30000
define PWM0Address            0x400000B0
define PWM1Address            0x400000C0
define PWM2Address            0x400000D0

define RED R3
define GREEN R4
define BLUE R5

setup:
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