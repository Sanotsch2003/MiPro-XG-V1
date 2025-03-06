define delayIterations       1500000
define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000100100
setup:
    ;initialize 7 segment display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]
start:
    JUMPL display
    ADD R7, R7, 1
    JUMPL delay
    JUMP start ; loop back
display:
    ;write the value in R7 to the seven segment display
    MOV R11, displayDataAddress
    STORE R7, [R11]
    RETURN  
delay: 
    ;do nothing until delay count is reached
    MOV R10, 0
    MOV R11, delayIterations
    loop:
        CMP R11, R10
        RETURNEQ
        ADD R10, R10, 1
        JUMP loop
