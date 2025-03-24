;screen
define screenWidth 640
define screenHeight 480

;seven Segment display
define sevenSegmentDisplayControlAddress 0x40000050      
define sevenSegmentDisplayDataAddress    0x40000054      
define sevenSegmentDisplayControl        0b00000000111101000010010000101100

;paddles
define paddleHeight 100
define paddleLeftStart_Y 190
define paddleRightStart_Y 190
define paddleLeft_Y R0
define paddleRight_y R1
define paddleMovementSpeed 4

;ball
define ballDiameter 8
define ballStart_X 316
define ballStart_Y 236
define ballStartVelocity_X 0xFFFFFFFD
define ballStartVelocity_Y 0
define ball_X R2
define ball_Y R3
define ballVelocity_X R4
define ballVelocity_Y R5

;game settings
define speedIncreaseDeltaTime 5

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
    ; Initialize 7 segment display
    MOV temp1, sevenSegmentDisplayControlAddress
    MOV temp2, sevenSegmentDisplayControl
    STORE temp2, [temp1]

    ; Initialize Timer 1 (16-bit) for random number generation
    ; Set prescaler to 0
    MOV temp1, 0x40000078       
    MOV temp2, 0x00000000       
    STORE temp2, [temp1]   

    ; Enable free running mode
    MOV temp1, 0x40000080       
    MOV temp2, 0b01       
    STORE temp2, [temp1]  
     
    ; Set up input pins for controller
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

    ; Initialize Score
    MOV temp1, sevenSegmentDisplayDataAddress  ; Load address of 7-Segment-Display Data
    MOV temp2, 0
    STORE temp2, [temp1] 

    JUMPL clearImageBuffer
    ; Initialize paddles
    MOV paddleLeft_Y, paddleLeftStart_Y
    MOV paddleRight_y, paddleRightStart_Y

    ; Initialize ball
    MOV ball_X, ballStart_X
    MOV ball_Y, ballStart_Y

    MOV ballVelocity_X, ballStartVelocity_X
    MOV ballVelocity_Y, ballStartVelocity_Y

    ; Initialize Timer 2 (16-bit) for counting seconds
    ; Set prescaler to 0
    MOV temp1, 0x40000088       
    MOV temp2, 50000000       
    STORE temp2, [temp1]   

    ; Enable periodic mode (to reset timer)
    MOV temp1, 0x40000090       
    MOV temp2, 0b11       
    STORE temp2, [temp1] 

    ; Enable free running mode
    MOV temp1, 0x40000090       
    MOV temp2, 0b01       
    STORE temp2, [temp1] 

    ; Initialize memory location that will be used for storing execution time
    MOV temp1, endOfProgram 
    MOV temp2, 0
    STORE temp2, [temp1]

    ;set up a hardware timer to execute the game tick function in regular time intervals using interrupts.
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

    ; configure hardware timer interrupt
    MOV temp1, IVT_addr_hardwareTimer3Interrupt
    MOV temp2, gameTick
    STORE temp2, [temp1]
    MOV temp1, IPR_addr_hardwareTimer3Interrupt
    MOV temp2, 1
    STORE temp2, [temp1]

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

randomInRange: ; x : temp4, y: temp5, seed: temp6, result: temp7
    mov temp1, 25173
    mov temp2, 13849

    UMUL temp1, temp1, temp6
    ADD temp1, temp1, temp2

    MOV temp2, 65536

    MOV temp7, 0
    MOV temp3, 0
    loop8:
        UMUL temp3, temp7, temp2
        SUB temp3, temp1, temp3
        ADD temp7, temp7, 1
        CMP temp3, temp2
        JUMPLS loop8

    SUB temp7, temp7, 1
    UMUL temp7, temp7, temp2
    SUB temp1, temp1, temp7 

    SUB temp2, temp5, temp4
    ADD temp2, temp2, 1 

    MOV temp7, 0
    MOV temp3, 0
    loop9:
        UMUL temp3, temp7, temp2
        SUB temp3, temp1, temp3
        ADD temp7, temp7, 1
        CMP temp3, temp2
        JUMPLS loop9

    SUB temp7, temp7, 1
    UMUL temp7, temp7, temp2
    SUB temp7, temp1, temp7 

    ADD temp7, temp7, temp4

    RETURN

drawPaddles:
    MOV temp1, imageBufferStartingAddress  
    MOV R12, 80
    UMUL temp2, paddleLeft_Y, R12
    ADD temp2, temp2, temp1 ; starting address of left paddle

    MOV temp1, paddleHeight
    MOV R12, 80
    UMUL temp3, temp1, R12    
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
    UMUL temp2, paddleRight_Y, R12
    ADD temp2, temp2, temp1 ; starting address of left paddle

    MOV temp1, paddleHeight
    MOV R12, 80
    UMUL temp3, temp1, R12    
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
    UMUL temp5, temp5, R12
    ADD temp4, temp4, temp5

    ; get number of pixel inside the word
    AND temp5, temp4, 0xFFFFFFFF, LSR 27 
    MOV R12, 31
    SUB temp5, R12, temp5

    ; calculate image buffer address of word that contains the pixel
    MOV temp4, temp4, LSR 5 ; divide by 32 to get word number
    MOV temp4, temp4, LSL 2 ; UMULtiply by 4 to get address 
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
    UMUL temp5, temp5, R12
    ADD temp4, temp4, temp5

    ; get number of pixel inside the word
    AND temp5, temp4, 0xFFFFFFFF, LSR 27 
    MOV R12, 31
    SUB temp5, R12, temp5

    ; calculate image buffer address of word that contains the pixel
    MOV temp4, temp4, LSR 5 ; divide by 32 to get word number
    MOV temp4, temp4, LSL 2 ; UMULtiply by 4 to get address 
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
    ; check for collisions with paddles

    ;Left paddle
    MOV temp3, 32
    CMP ball_X, temp3 ; If ball_X is greater than right edge of paddle then continue
    JUMPGT continue21 

    ADD temp3, temp3, ballVelocity_X
    CMP ball_X, temp3 ; If ball_X is less than or equal to right edge of paddle + ballVelocity_X then continue
    JUMPLT continue21 

    MOV temp4, ballDiameter
    ADD temp3, ball_Y, temp4
    CMP temp3, paddleLeft_Y
    JUMPLT continue21 ; If lower edge of ball is less than upper edge of left paddle then continue

    MOV temp4, paddleHeight
    ADD temp4, temp4, paddleLeft_Y
    CMP ball_Y, temp4
    JUMPGT continue21 ; If upper edge of ball is less then lower edge of left paddle then continue

    ;set position and new velocity
    ; set position so that the ball will not intersect with the paddle
    MOV ball_X, 32

    ;Check where the ball has hit the paddle
    MOV temp4, paddleHeight
    ADD temp4, paddleLeft_Y, temp4, LSR 1
    MOV temp3, ballDiameter
    ADD temp3, ball_Y, temp3, LSR 1
    SUB temp4, temp3, temp4

    ; set ballVelocity_Y based on hit position
    ADD ballVelocity_Y, ballVelocity_Y, temp4, ASR 4

    ; invert ballVelocity_X
    BUS ballVelocity_X, ballVelocity_X, 0

    ;Increase magnitude of ballVelocity_X if a certain number of sends has passed
    MOV temp3, endOfProgram ; address that holds last update time
    LOAD temp4, [temp3]
    MOV temp7, 0x40000094 ; address of seconds counter
    LOAD temp6, [temp7]
    SUB temp4, temp6, temp4

    MOV temp6, speedIncreaseDeltaTime
    CMP temp6, temp4 ; update if 1 second has passed
    JUMPCC continue21

    ADD ballVelocity_X, ballVelocity_X, 1
    ;Save current execution time in memory
    LOAD temp4, [temp7] ; Load current count value
    STORE temp4, [temp3] ; Store current Count value in memory

    continue21:

    ;Right paddle
    MOV temp3, screenWidth
    MOV temp4, 33
    SUB temp3, temp3, temp4 ; left edge of paddle

    MOV temp4, ballDiameter
    ADD temp4, ball_X, temp4
    SUB temp4, temp4, 1 ;right edge of ball

    CMP temp4, temp3 ; If right edge of ball less then left edge of paddle then continue
    JUMPLT continue22

    ADD temp3, temp3, ballVelocity_X 
    CMP temp4, temp3
    JUMPGT continue22;needs to be tested

    MOV temp4, ballDiameter
    ADD temp3, ball_Y, temp4
    CMP temp3, paddleRight_Y
    JUMPLT continue22 ; If lower edge of ball is less than upper edge of left paddle then continue

    MOV temp4, paddleHeight
    ADD temp4, temp4, paddleRight_Y
    CMP ball_Y, temp4
    JUMPGT continue22 ; If upper edge of ball is less then lower edge of left paddle then continue

    ; set position so that the ball will not intersect with the paddle
    MOV temp3, screenWidth
    MOV temp4, 32
    SUB temp3, temp3, temp4
    MOV temp4, ballDiameter
    SUB temp3, temp3, temp4
    MOV ball_X, temp3

    ;Check where the ball has hit the paddle
    MOV temp4, paddleHeight
    ADD temp4, paddleRight_Y, temp4, LSR 1
    MOV temp3, ballDiameter
    ADD temp3, ball_Y, temp3, LSR 1
    SUB temp4, temp3, temp4

    ; set new ballVelocity_Y based on hit location
    ADD ballVelocity_Y, ballVelocity_Y, temp4, ASR 4
    
    ; invert ballVelocyty_X
    BUS ballVelocity_X, ballVelocity_X, 0

    ;Increase magnitude of ballVelocity_X if a certain number of sends has passed
    MOV temp3, endOfProgram ; address that holds last update time
    LOAD temp4, [temp3]
    MOV temp7, 0x40000094 ; address of seconds counter
    LOAD temp6, [temp7]
    SUB temp4, temp6, temp4

    MOV temp6, speedIncreaseDeltaTime
    CMP temp6, temp4 ; update if 1 second has passed
    JUMPCC continue22

    SUB ballVelocity_X, ballVelocity_X, 1
    ;Save current execution time in memory
    LOAD temp4, [temp7] ; Load current count value
    STORE temp4, [temp3] ; Store current Count value in memory

    continue22:

    MOV temp5, 0 ; Initialize return value to 0
    ;check left edge collision (Point for player right)
    CMP ball_X, 0
    JUMPGE continue17

    ;set return value to 1
    MOV temp5, 1
    continue17:

    ; check right edge collision (Point for player left)
    MOV temp3, ballDiameter
    MOV temp4, screenWidth
    SUB temp4, temp4, temp3
    CMP temp4, ball_X
    JUMPGE continue18

    ;set return value to 100
    MOV temp5, 100
    continue18:

    ;Add the previous ball position to the registers
    ORR ball_X, ball_X, temp1
    ORR ball_Y, ball_Y, temp2

    RETURN

gameTick:
    JUMPL movePaddles
    JUMPL moveBall

    CMP temp5, 0 ; Check if player has scored point
    JUMPEQ continue19

    ;Save current execution time in memory
    MOV temp1, endOfProgram ; address that can be used for storing the execution time
    MOV temp2, 0x40000094 ; address of seconds counter
    LOAD temp3, [temp2] ; Load current count value
    STORE temp3, [temp1] ; Store current Count value in memory

    ;Reset game
    ;Reset paddles
    MOV paddleLeft_Y, paddleLeftStart_Y
    MOV paddleRight_y, paddleRightStart_Y

    ;Reset ball
    MOV ball_X, ballStart_X
    MOV ball_Y, ballStart_Y

    ;Update Score
    MOV temp1, sevenSegmentDisplayDataAddress
    LOAD temp2, [temp1]
    ADD temp2, temp2, temp5
    STORE temp2, [temp1]

    ;Generate random ball starting velocity
    ; use current timer count as seed for random number generator
    MOV temp1, 0x40000084
    LOAD temp6, [temp1]
    MOV temp4, 2
    MOV temp5, 3
    JUMPL randomInRange
    MOV ballVelocity_X, temp7

    MOV temp1, 0x40000084
    LOAD temp6, [temp1]
    MOV temp4, 2
    MOV temp5, 3
    JUMPL randomInRange
    MOV ballVelocity_Y, temp7

    MOV temp1, 0x40000084
    LOAD temp6, [temp1]
    MOV temp1, 0b10000
    AND temp6, temp6, temp1
    CMP temp6, temp1
    JUMPNE continue20

    BUS ballVelocity_Y, ballVelocity_Y, 0

    continue20:

    MOV temp1, 0x40000084
    LOAD temp6, [temp1]
    MOV temp1, 0b01000
    AND temp6, temp6, temp1
    CMP temp6, temp1
    JUMPNE continue19

    BUS ballVelocity_X, ballVelocity_X, 0
    
    continue19:

    ;drawing the image
    JUMPL drawPaddles
    JUMPL drawBall
    IRET

endOfProgram:
