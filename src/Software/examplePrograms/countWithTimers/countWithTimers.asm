define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000100100


setup:
    ; Initialize Timer 0 (8-bit)
    MOV R0, 0x40000098       ; Load address of Timer 3 Prescaler
    MOV R1, 50000000         ; Load value 50.000.000 (clock frequency of processor) into R1 to make the timer count every second.
    STORE R1, [R0]           ; Store value from R1 to Timer 3 Prescaler

    MOV R0, 0x400000A0       ; Load address of Timer 3 Mode in to R0.
    MOV R1, 0b01             ; Load 0b000 into R1: Free running mode.
    Store R1, [R0]           ; Store value from R1 to Timer 3 Mode.


    ; Initialize 7-Segment-Display
    MOV R0, displayControlAddress
    MOV R1, displayControl
    STORE R1, [R0]

    ; Display the current count value on the 7-Segment-Display
    loop:
        MOV R0, 0x400000A4          ; Load address of Timer 3 Count
        LOAD R1, [R0]               ; Load the current count value into R1

        MOV R0, displayDataAddress  ; Load address of 7-Segment-Display Data
        STORE R1, [R0]              ; Send Current Count value to Display
        jump loop                   ; Loop back
             
