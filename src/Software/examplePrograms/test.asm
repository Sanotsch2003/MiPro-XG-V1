define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000100100

setup:
    ;initialize 7 segment display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

start:
	MOV R0, 234
    MOV R1, 17
    STORE R0, [R1]
    LOAD R7, [R1]
    JUMPL display
    HALT

display:
    ;write the value in R7 to the seven segment display
    MOV R11, displayDataAddress
    STORE R7, [R11]
    RETURN