define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000100001

setup:
    ; Initialize digital IO Pin 0 as input:
    MOV R0, 0x400000A8      
    MOV R1, 0b01                  
    STORE R1, [R0] 

    ; Initialize 7 Segment Display 
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

main:
    MOV R0, 0x400000B4
    LOAD R1, [R0]
    MOV R0, displayDataAddress  ; Load address of 7-Segment-Display Data
    STORE R1, [R0]              ; Send Current IO-Pin value to Display
    jump main                   ; Loop back

