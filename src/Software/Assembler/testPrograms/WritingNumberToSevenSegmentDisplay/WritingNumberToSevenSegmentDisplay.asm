define displayControlAddress 0x40000050      ;actual address: 0x40000050
define displayDataAddress    0x40000054      ;actual address: 0x40000054

define displayControl        0b00000000111101000010010000100011
define displayData           123

start: 

    ;write data to 7-Segment Display
    MOV R0, displayControlAddress
    MOV R7, displayControl
    STOREW R7, [R0]

    ;write actual data to 7-Segment Display
    MOV R0, displayDataAddress
    MOV R7, displayData
    STOREW R7, [R0]

