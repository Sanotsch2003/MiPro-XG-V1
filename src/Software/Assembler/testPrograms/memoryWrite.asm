define displayControlAddress 0x40000050
define displayDataAddress    0x40000054

define displayControl        0x00000000
define displayData           123

start: 
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    MOV R0, displayDataAddress
    MOV R1, displayData
    STORE R1, [R0]

    