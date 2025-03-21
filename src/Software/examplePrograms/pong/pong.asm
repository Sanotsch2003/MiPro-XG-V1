;screen
define screenWidth 640
define screenHeight 480

;seven Segment display
define sevenSegmentDisplayControlAddress 0x40000050      
define sevenSegmentDisplayDataAddress    0x40000054      
define sevenSegmentDisplayControl        0b00000000111101000010010000100100

;paddles
define paddleHeight 100
define paddleLeftStart_Y 190
define paddleRightStart_Y 190
define paddleLeft_Y R0
define paddleRight_y R1
define paddleMovementSpeed 4

;ball
define ballDiameter 8
define ballStart_X 320
define ballStart_Y 240
define ballStartVelocity_X 5
define ballStartVelocity_Y 7
define ball_X R2
define ball_Y R3
define ballVelocity_X R4
define ballVelocity_Y R5

;temporary registers
define temp1 R9
define temp2 R10
define temp3 R11
define temp4 R8
define temp5 R7
define temp6 R6
define temp7 SP

define gameTickSpeed 833333 ; 833333: 60FPS

;image buffer
define imageBufferStartingAddress 0x80000000
define imageBufferEndingAddress 0x80009600

;interrupts
define IVT_addr_hardwareTimer3Interrupt       0x3FFFFE38
define IPR_addr_hardwareTimer3Interrupt       0x3FFFFE3C


;Setting up the game environment
setup:
    ;initialize 7 segment display
    MOV temp1, sevenSegmentDisplayControlAddress
    MOV temp2, sevenSegmentDisplayControl
    STORE temp2, [temp1]

    ;setting up a hardware timer to execute the game tick function in regular time intervals using interrupts.
    
    ; Initialize Timer 3 (32-bit)
    ; Disable prescaling
    MOV temp1, 0x40000098        
    MOV temp2, 0      
    STORE temp2, [temp1]        

    ; Set max count value
    MOV temp1, 0x4000009C       
    MOV temp2, gameTickSpeed   
    STORE temp2, [temp1]        

    ; Enable periodic mode
    MOV temp1, 0x400000A0       
    MOV temp2, 0b11         
    STORE temp2, [temp1]        

    ; configuring hardware timer interrupt
    MOV temp1, IVT_addr_hardwareTimer3Interrupt
    MOV temp2, gameTick
    STORE temp2, [temp1]
    MOV temp1, IPR_addr_hardwareTimer3Interrupt
    MOV temp2, 1
    STORE temp2, [temp1]

    ; setting up input pins for controller
    ; Initialize digital IO Pin 0 as input:
    MOV temp1, 0x400000A8      
    MOV temp2, 0b01                  
    STORE temp2, [temp1] 

    ; Initialize digital IO Pin 1 as input:
    MOV temp1, 0x400000B8      
    MOV temp2, 0b01                  
    STORE temp2, [temp1] 

    ; Initialize digital IO Pin 2 as input:
    MOV temp1, 0x400000C8      
    MOV temp2, 0b01                  
    STORE temp2, [temp1] 

    ; Initialize digital IO Pin 3 as input:
    MOV temp1, 0x400000D8      
    MOV temp2, 0b01                  
    STORE temp2, [temp1] 

    ;clear screen
    JUMPL clearImageBuffer

    ; init game state
    JUMPL resetGame

main:
JUMP main

;This deletes all data inside the image buffer
clearImageBuffer:
    MOV temp1, imageBufferStartingAddress
    MOV temp2, 0x00000000
    MOV temp3, 38400
    ADD temp3, temp3, temp1
    loop1:
       STORE temp2, [temp1] 
       ADD temp1, temp1, 4
       CMP temp1, temp3
       JUMPNE loop1

    RETURN

resetGame:
    ;Initialize paddles
    MOV paddleLeft_Y, paddleLeftStart_Y
    MOV paddleRight_y, paddleRightStart_Y

    ;Initialize ball
    MOV ball_X, ballStart_X
    MOV ball_Y, ballStart_Y
    MOV ballVelocity_X, ballStartVelocity_X
    MOV ballVelocity_Y, ballStartVelocity_Y

    ;Initialize Score
    MOV temp1, sevenSegmentDisplayDataAddress  ; Load address of 7-Segment-Display Data
    MOV temp2, 0
    STORE temp2, [temp1] 

    RETURN 


drawPaddles:
    MOV temp1, imageBufferStartingAddress  
    MOV R12, 80
    MUL temp2, paddleLeft_Y, R12
    ADD temp2, temp2, temp1 ; starting address of left paddle

    MOV temp1, paddleHeight
    MOV R12, 80
    MUL temp3, temp1, R12    
    ADD temp3, temp2, temp3 ; ending address of left paddle

    MOV temp4, imageBufferEndingAddress 
    MOV temp1, imageBufferStartingAddress  
    MOV R12, 80
    MOV temp5, 0x00000000
    loop2:
        CMP temp2, temp1
        JUMPNE continue3

        MOV temp5, 0x000000FF

        continue3:
        CMP temp3, temp1
        JUMPNE continue4

        MOV temp5, 0x00000000

        continue4:
        STORE temp5, [temp1]

        ADD temp1, temp1, R12
        CMP temp1, temp4
        JUMPNE loop2

    MOV temp1, imageBufferStartingAddress  
    MOV R12, 76
    ADD temp1, R12, temp1
    MOV R12, 80
    MUL temp2, paddleRight_Y, R12
    ADD temp2, temp2, temp1 ; starting address of left paddle

    MOV temp1, paddleHeight
    MOV R12, 80
    MUL temp3, temp1, R12    
    ADD temp3, temp2, temp3 ; ending address of left paddle

    MOV temp4, imageBufferEndingAddress 
    MOV R12, 76
    ADD temp4, R12, temp4
    MOV temp1, imageBufferStartingAddress 
    MOV R12, 76
    ADD temp1, R12, temp1 
    MOV R12, 80
    MOV temp5, 0x00000000
    loop3:
        CMP temp2, temp1
        JUMPNE continue5

        ORR temp5, temp5, 0xFFFFFFFF, LSL 24

        continue5:
        CMP temp3, temp1
        JUMPNE continue6

        MOV temp5, 0x00000000

        continue6:
        STORE temp5, [temp1]

        ADD temp1, temp1, R12
        CMP temp1, temp4
        JUMPNE loop3

    RETURN

drawBall:
    ; unset the pixels at the previous ball position
    MOV temp2, ball_Y, LSR 16
    MOV temp6, ballDiameter
    ADD temp6, temp6, temp2
    loop4:
        MOV temp1, ball_X, LSR 16
        MOV temp7, ballDiameter
        ADD temp7, temp7, temp1
        loop5:
            JUMP unsetPixel 
            continue15:
            ADD temp1, temp1, 1
            CMP temp1, temp7
            JUMPNE loop5

        ADD temp2, temp2, 1
        CMP temp2, temp6
        JUMPNE loop4


    ; set the pixels at the current ball position
    MOV temp2, ball_Y
    AND temp2, temp2, 0xFFFFFFFF, LSR 16
    MOV temp6, ballDiameter
    ADD temp6, temp6, temp2
    loop6:
        MOV temp1, ball_X
        AND temp1, temp1, 0xFFFFFFFF, LSR 16
        MOV temp7, ballDiameter
        ADD temp7, temp7, temp1
        loop7:
            JUMP setPixel 
            continue16:
            ADD temp1, temp1, 1
            CMP temp1, temp7
            JUMPNE loop7

        ADD temp2, temp2, 1
        CMP temp2, temp6
        JUMPNE loop6

    RETURN

setPixel: ;x: temp1, y: temp2
    MOV temp4, temp1
    MOV temp5, temp2
    ;convert to 1D address
    MOV R12, screenWidth
    MUL temp5, temp5, R12
    ADD temp4, temp4, temp5

    ; get number of pixel inside the word
    AND temp5, temp4, 0xFFFFFFFF, LSR 27 
    MOV R12, 31
    SUB temp5, R12, temp5

    ; calculate image buffer address of word that contains the pixel
    MOV temp4, temp4, LSR 5 ; divide by 32 to get word number
    MOV temp4, temp4, LSL 2 ; multiply by 4 to get address 
    MOV R12, imageBufferStartingAddress
    ADD temp4, temp4, R12

    ; load word from image buffer into register
    LOAD temp3, [temp4]

    ; set the right bit 
    ORR temp3, temp3, 1, LSL temp5

    ; write the changed word back to the image buffer
    STORE temp3, [temp4]

    JUMP continue16


unsetPixel: ;x: temp1, y: temp2
    MOV temp4, temp1
    MOV temp5, temp2
    ;convert to 1D address
    MOV R12, screenWidth
    MUL temp5, temp5, R12
    ADD temp4, temp4, temp5

    ; get number of pixel inside the word
    AND temp5, temp4, 0xFFFFFFFF, LSR 27 
    MOV R12, 31
    SUB temp5, R12, temp5

    ; calculate image buffer address of word that contains the pixel
    MOV temp4, temp4, LSR 5 ; divide by 32 to get word number
    MOV temp4, temp4, LSL 2 ; multiply by 4 to get address 
    MOV R12, imageBufferStartingAddress
    ADD temp4, temp4, R12

    ; load word from image buffer into register
    LOAD temp3, [temp4]

    ; set the right bit 
    BIC temp3, temp3, 1, LSL temp5

    ; write the changed word back to the image buffer
    STORE temp3, [temp4]

    JUMP continue15

movePaddles:
    ; move paddles by reading from io pins
    MOV temp1, 0x400000B4
    LOAD temp2, [temp1]

    CMP temp2, 1
    JUMPNE continue9

    ;move left paddle up
    SUB paddleLeft_Y, paddleLeft_Y, paddleMovementSpeed

    continue9:

    MOV temp1, 0x400000C4
    LOAD temp2, [temp1]

    CMP temp2, 1
    JUMPNE continue10

    ;move left paddle down
    ADD paddleLeft_Y, paddleLeft_Y, paddleMovementSpeed

    continue10:

    MOV temp1, 0x400000D4
    LOAD temp2, [temp1]

    CMP temp2, 1
    JUMPNE continue11

    ;move right paddle down
    SUB paddleRight_Y, paddleRight_Y, paddleMovementSpeed

    continue11:

    MOV temp1, 0x400000E4
    LOAD temp2, [temp1]

    CMP temp2, 1
    JUMPNE continue12

    ;move right paddle down
    ADD paddleRight_Y, paddleRight_Y, paddleMovementSpeed

    continue12:
    ;Make sure paddles do not move across screen edges
    
    ; check if paddles have reached the top screen edge
    MOV temp1, 0
    CMP paddleLeft_y, temp1
    JUMPGE continue1

    ;set left paddle position to 0
    MOV paddleLeft_Y, 0

    continue1:
    CMP paddleRight_y, temp1
    JUMPGE continue2

    ;set right paddle position to 0
    MOV paddleRight_Y, 0

    continue2:
    ; check if paddles have reached the bottom screen edge
    MOV temp1, screenHeight
    MOV temp2, paddleHeight
    SUB temp2, temp1, temp2
    ;SUB temp2, temp2, 1

    CMP temp2, paddleLeft_Y
    JUMPGE continue7

    MOV paddleLeft_y, temp2

    continue7:

    CMP temp2, paddleRight_Y
    RETURNGE 

    MOV paddleRight_y, temp2

    RETURN

moveBall:
    ;save previous ball position
    MOV temp1, ball_X, LSL 16
    MOV temp2, ball_Y, LSL 16

    AND ball_X, ball_X, 0xFFFFFFFF, LSR 16
    AND ball_Y, ball_Y, 0xFFFFFFFF, LSR 16
    
    ; calculate new X position
    ADD ball_X, ball_X, ballVelocity_X
    ADD ball_Y, ball_Y, ballVelocity_Y

    ; make sure ball is within top and bottom screen boundaries

    ; check top edge collision
    CMP ball_Y, 0
    JUMPGE continue13

    ;set position and invert velocity
    MOV ball_Y, 0
    BUS ballVelocity_Y, ballVelocity_Y, 0

    continue13:

    ; check bottom edge collision
    MOV temp3, ballDiameter
    MOV temp4, screenHeight
    SUB temp4, temp4, temp3
    CMP temp4, ball_Y
    JUMPGE continue14

    ;set position and invert velocity
    MOV ball_Y, temp4
    BUS ballVelocity_Y, ballVelocity_Y, 0

    continue14:

    ;check left edge collision
    CMP ball_X, 0
    JUMPGE continue17

    ;set position and invert velocity
    MOV ball_X, 0
    BUS ballVelocity_X, ballVelocity_X, 0

    continue17:

    ; check right edge collision
    MOV temp3, ballDiameter
    MOV temp4, screenWidth
    SUB temp4, temp4, temp3
    CMP temp4, ball_X
    JUMPGE continue18

    ;set position and invert velocity
    MOV ball_X, temp4
    BUS ballVelocity_X, ballVelocity_X, 0

    continue18:

    ;Add the previous ball position to the registers
    ORR ball_X, ball_X, temp1
    ORR ball_Y, ball_Y, temp2

    RETURN

gameTick:
    
    JUMPL movePaddles
    JUMPL moveBall


    ;drawing the image
    JUMPL drawPaddles
    JUMPL drawBall
    IRET
    






