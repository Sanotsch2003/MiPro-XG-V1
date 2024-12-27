define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000110100

define serialInterfaceStatusAddress 0x40000060
define serialInterfaceInteractionAddress 0x40000064

setup:
    ;Initialize 7 segment display.
    MOV R11, displayControlAddress
    MOV R10, displayControl
    STORE R10, [R11]
    MOV R0, 0 ;instruction counter
main:
    JUMPL display ;Display the current instruction counter.
    loop1:
        MOV R10, serialInterfaceStatusAddress
        LOAD R9, [R10] ;Read the status of the serial interface.
        MOV R9, R9, LSR 4 ;Shift the value to the right by 4 to remove unnecessary status data.
        CMP R9, 4 ;Check if 4 bytes have been received.
        JUMPNE loop1 ;Check again if 4 bytes have not yet been received.

    ;Once 4 bytes have arrived, they must be checked for errors and written into the same register one by one.
    MOV R1, 0 ;byte counter
    MOV R2, 0 ;instruction register
    loop2:
        MOV R10, serialInterfaceInteractionAddress ;Move the address of the data into R8.
        LOAD R9, [R10] ;Load the received byte into R9
        MOV R10, 0b00000000000000000000000100000000
        TST R9, R10 ;check if the 8th bit is set (error bit).
        JUMPLNE handleError ;Execute handle error routine
        ;else:
        MOV R8, 0b11111111 ;Acknowledge message
        STORE R8, [R10] ;Send acknowledge message.

        ;Wait for message to finish sending.
        MOV R10, serialInterfaceStatusAddress
        loop4: 
            LOAD R9, [R10] ;Read the status of the serial interface.
            MOV R9, R9, LSL 28 ;Shift the value to the left by 28 to remove unnecessary status data.
            JUMPNE loop4 ;Exiting loop once byte has been sent by checking if R9 is 0.
        
        ;calculate shift amount
        BUS R3, R1, 3 ; Load 3 - byte counter into R3
        MOV R3, R3, LSR 3 ;multiply by 8 
        ORR R2, R2, R9, LSL R3 ;Move the shifted R9 register (based on byte counter) into R2 (instruction register). 
        
        ADD R1, R1, 1 ;increment byte counter
        CMP R1, 4
        JUMPNE loop2 ;Loop if less than 4 bytes have been processed.
        ;else:
        STORE R2, [R0] ;store instruction in memory.
        ADD R0, R0, 1 ;Incrment instruction counter.
        JUMP main ;Go back to main.

        handleError:
            MOV R8, 0b00010000 ;Error message
            STORE R8, [R10] ;Send Error message.
            ;Wait for message to finish sending.
            MOV R10, serialInterfaceStatusAddress
            loop3: 
                LOAD R8, [R10] ;Read the status of the serial interface.
                MOV R8, R8, LSL 28 ;Shift the value to the left by 28 to remove unnecessary status data.
                JUMPNE loop3 ;Exiting loop once byte has been sent by checking if R9 is 0.

            JUMP main ;Discard the current instruction and wait for new one

display:
    ;write the value in R0 to the seven segment display
    MOV R6, displayDataAddress
    STORE R0, [R6]
    RETURN