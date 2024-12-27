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
    MOV R0, 0 ;address counter
main:
    JUMPL display ;Display the current instruction counter.
    loop1:
        MOV R10, serialInterfaceStatusAddress
        LOAD R9, [R10] ;Read the status of the serial interface.
        MOV R9, R9, LSR 4 ;Shift the value to the right by 4 to remove unnecessary status data.
        CMP R9, 4 ;Check if 4 bytes have been received.
        JUMPNE loop1 ;Loop back if that is not the case.

    ;Once 4 bytes have arrived, they must be checked for errors and written into the same register one by one.
    MOV R1, 0 ;byte counter
    MOV R2, 0 ;instruction register
    loop2:
        MOV R10, serialInterfaceInteractionAddress ;Move the address of the data into R10.
        LOAD R9, [R10] ;Load the received byte into R9
        MOV R10, 0b00000000000000000000000100000000
        TST R9, R10 ;check if the 8th bit is set (error bit).
        JUMPNE handleError ;Execute handle error routine if the 8th bit is set (Result of is not 0).
        
        ;else:
        MOV R3, R1, LSL 3 ;Multiply byte counter by 8 and load it into R3.
        ORR R2, R2, R9, LSL R3 ;Move the shifted (based on byte counter) received Byte into R2 (instruction register). 

        ADD R1, R1, 1 ;Increment byte counter.
        CMP R1, 4
        JUMPNE loop2 ;Loop if less than 4 bytes have been processed (Byte counter is not equal to 4.).
        

    STORE R2, [R0] ;Store instruction in memory at the address of the address counter.
    ADD R0, R0, 4 ;Increment instruction counter.

    MOV R8, 0b11111111 ;'Acknowledge' message
    JUMPL transmit ;Send 'Acknowledge' message.
    JUMP main ;Go back to main.

display:
    ;write the value in R0 to the seven segment display
    MOV R6, displayDataAddress
    STORE R0, [R6]
    RETURN

transmit:
    ;transmit the first 8 bytes of R8 over UART
    MOV R6, serialInterfaceInteractionAddress
    STORE R8, [R6]
    RETURN

handleError:
    MOV R8, 0b10000000 ;'Not Acknowledge' message
    JUMPL transmit ;Send 'Not Acknowledge' message.
    JUMP main
