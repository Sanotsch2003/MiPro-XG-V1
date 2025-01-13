;define constants
define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000100011

start: 

    ;write control data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R7, displayControl
    STOREW R7, [R0]

    ;write display data to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R7, 123
    STOREW R7, [R0]

    HALT ;halt execution

    ;write display data to 7-Segment Display. This should not be executed if the HALT instruction works
    MOV R0, displayDataAddress
    MOV R7, 345
    STOREW R7, [R0]
    

