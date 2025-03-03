define delayIterations       1000000
define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000100100

setup:
    ;initialize 7 segment display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

;main program loop
main:
    MOV R2, 3 
    loop3:
        JUMPL checkIfPrime
        CMP R6, 1
        JUMPEQ display;display the number only if it is prime
        return1:
        ;JUMP delay;delay only if the number is prime
        return2:
        ADD R2, R2, 2;increment counter
        JUMP loop3; loop back
        
;works only for numbers >= 3:
checkIfPrime:;(toCheck = R2), uses R3, R4, R5, RESULT in R6
    MOV R6, 0;default return value is FALSE
    MOV R3, R2, LSR 1;divide by 2
    MOV R4, 2

    loop1:
        MOV R5, R2 ;copy parameter into R5
        loop2:
            SUB R5, R5, R4 ;subtract R4 from R5 until R5 is zero or less than R4
            RETURNEQ ;return witFalseh value FALSE if result is zero

            ;loop back if the result is larger than the parameter
            CMP R5, R4
            JUMPLS loop2

        ;increment R4
        ADD R4, R4, 1
        CMP R3, R4
        ;loop back only if R4 is less than or equal to R3
        JUMPLS loop1

    MOV R6, 1;set return value to 1
    RETURN

display:;(toDisplay = R2)
    ;write the value in R2 to the seven segment display
    MOV R11, displayDataAddress
    STORE R2, [R11]
    JUMP return1  

delay: 
    ;do nothing until delay count is reached
    MOV R10, 0
    MOV R11, delayIterations
    loop:
        CMP R11, R10
        JUMPEQ return2
        ADD R10, R10, 1
        JUMP loop