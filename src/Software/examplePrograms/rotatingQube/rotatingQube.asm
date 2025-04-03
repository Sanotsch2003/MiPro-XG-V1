;screen
define screenWidth 640
define screenHeight 480

;image buffer
define imageBuffer0StartingAddress 0x80000000
define imageBuffer1StartingAddress 0x80009600
define activeBufferAddress         0x80012C00
define VSyncAddress                0x80012C04

;temporary registers
define temp1 R1
define temp2 R2
define temp3 R3
define temp4 R4
define temp5 R5
define temp6 R6
define temp7 SP
define temp8 R7
define temp9 R8
define temp10 R11
define temp11 R10
define temp12 R9
define temp13 R0

;seven segment display
define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000100100
define displayData           5678

; constants
define scale 500

define sinTheta 0x00000009
define cosTheta 0x00000100

define tickSpeed 1666666

; interrupts
define IVT_addr_hardwareTimer3Interrupt       0x3FFFFE38
define IPR_addr_hardwareTimer3Interrupt       0x3FFFFE3C

setup:
    ;set up 7 segment display
    MOV temp1, displayControlAddress
    MOV temp2, displayControl
    STORE temp2, [temp1]
    
    MOV temp1, data
    MOV temp2, 160
    ADD temp1, temp1, temp2

    ; P0 (-0.5, -0.5, -0.5)
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P1 (+0.5, -0.5, -0.5)
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P2 (+0.5, +0.5, -0.5)
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P3 (-0.5, +0.5, -0.5)
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P4 (-0.5, -0.5, +0.5)
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P5 (+0.5, -0.5, +0.5)
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P6 (+0.5, +0.5, +0.5)
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; P7 (-0.5, +0.5, +0.5)
    MOV temp2, 0xFFFFFF80
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    MOV temp2, 0x00000080
    STORE temp2, [temp1]
    ADD temp1, temp1, 4

    ; set up sin lookup table
    MOV temp1, data
    MOV temp2, 296
    ADD temp1, temp1, temp2

    ; sin(0)
    MOV temp2, 0x000000
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(4)
    MOV temp2, 0x00000012
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(8)
    MOV temp2, 0x00000024
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(12)
    MOV temp2, 0x00000035
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(16)
    MOV temp2, 0x00000047
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(20)
    MOV temp2, 0x00000058
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(24)
    MOV temp2, 0x00000068
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(28)
    MOV temp2, 0x00000078
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(32)
    MOV temp2, 0x00000088
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(36)
    MOV temp2, 0x00000096
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(40)
    MOV temp2, 0x000000A5
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(44)
    MOV temp2, 0x000000B2
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(48)
    MOV temp2, 0x000000BE
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(52)
    MOV temp2, 0x000000CA
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(56)
    MOV temp2, 0x000000D4
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(60)
    MOV temp2, 0x000000DE
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(64)
    MOV temp2, 0x000000E6
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(68)
    MOV temp2, 0x000000ED
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(72)
    MOV temp2, 0x000000F3
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(76)
    MOV temp2, 0x000000F8
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(80)
    MOV temp2, 0x000000FC
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(84)
    MOV temp2, 0x000000FF
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(88)
    MOV temp2, 0x00000100
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(92)
    MOV temp2, 0x00000100
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(96)
    MOV temp2, 0x000000FF
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(100)
    MOV temp2, 0x000000FC
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(104)
    MOV temp2, 0x000000F8
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(108)
    MOV temp2, 0x000000F3
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(112)
    MOV temp2, 0x000000ED
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(116)
    MOV temp2, 0x000000E6
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(120)
    MOV temp2, 0x000000DE
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(124)
    MOV temp2, 0x000000D4
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(128)
    MOV temp2, 0x000000CA
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(132)
    MOV temp2, 0x000000BE
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(136)
    MOV temp2, 0x000000B2
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(140)
    MOV temp2, 0x000000A5
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(144)
    MOV temp2, 0x00000096
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(148)
    MOV temp2, 0x00000088
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(152)
    MOV temp2, 0x00000078
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(156)
    MOV temp2, 0x00000068
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(160)
    MOV temp2, 0x00000058
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(164)
    MOV temp2, 0x00000047
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(168)
    MOV temp2, 0x00000035
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(172)
    MOV temp2, 0x00000024
    STORE temp2, [temp1]
    ADD temp1, temp1, 4
    ; sin(176)
    MOV temp2, 0x00000012
    STORE temp2, [temp1]

    ; set up rotation
    MOV temp1, data
    MOV temp2, 288
    ADD temp1, temp1, temp2
    MOV temp2, 0
    STORE temp2, [temp1]

    ;set up a hardware timer to count milliseconds
    ;Set prescaler so that the counter counts every millisecond 
    MOV temp1, 0x40000088        
    MOV temp2, 50000       
    STORE temp2, [temp1]        
       
    ; Enable free running mode
    MOV temp1, 0x40000090       
    MOV temp2, 0b01         
    STORE temp2, [temp1] 

    ;set up a hardware timer to execute the rotate function in regular time intervals using interrupts.
    ; Disable prescaling
    MOV temp1, 0x40000098        
    MOV temp2, 0      
    STORE temp2, [temp1]        

    ; Set max count value
    MOV temp1, 0x4000009C       
    MOV temp2, tickSpeed   
    STORE temp2, [temp1]        

    ; Enable periodic mode
    MOV temp1, 0x400000A0       
    MOV temp2, 0b11         
    STORE temp2, [temp1]   

    ; configure hardware timer interrupt
    MOV temp1, IVT_addr_hardwareTimer3Interrupt
    MOV temp2, tick
    STORE temp2, [temp1]
    MOV temp1, IPR_addr_hardwareTimer3Interrupt
    MOV temp2, 1
    STORE temp2, [temp1]

main:
    JUMP main

tick:
    ; save current execution time to calculate frame timer after rendering
    MOV temp1, data
    MOV temp2, 284
    ADD temp1, temp1, temp2

    MOV temp2, 0x40000094
    LOAD temp2, [temp2]
    STORE temp2, [temp1]


    ; apply transformation to the qube
    JUMPL rotatePoints

    ; project the 3D coordinates to the screen
    JUMPL projectPoints

    ; clear screen
    JUMPL clearImageBuffer

    ; draw lines between all vertices
    MOV temp1, data
    MOV temp2, 96
    ADD temp5, temp1, temp2 ; starting address of projected coordinates

    ; ===== Front face =====
    ; Edge 0-1
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 0
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 8
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 1-2
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 8
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 16
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 2-3
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 16
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 24
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 3-0
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 24
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 0
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; ===== Back face =====
    ; Edge 4-5
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 32
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 40
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 5-6
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 40
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 48
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 6-7
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 48
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 56
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 7-4
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 56
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 32
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; ===== Side edges =====
    ; Edge 0-4
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 0
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 32
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 1-5
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 8
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 40
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 2-6
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 16
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 48
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; Edge 3-7
    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 24
    ADD temp7, temp7, temp6
    LOAD temp1, [temp7]
    ADD temp7, temp7, 4
    LOAD temp2, [temp7]

    MOV temp7, data
    MOV temp6, 96
    ADD temp7, temp7, temp6
    MOV temp6, 56
    ADD temp7, temp7, temp6
    LOAD temp3, [temp7]
    ADD temp7, temp7, 4
    LOAD temp4, [temp7]
    JUMPL drawLine

    ; display frame time on 7 segment display
    JUMPL displayFrameTime

    JUMPL flipBuffer

    IRET

displayFrameTime:
    MOV temp1, 0x40000094
    LOAD temp1, [temp1] ;current execution time

    MOV temp2, data
    MOV temp3, 284
    ADD temp2, temp2, temp3 
    LOAD temp2, [temp2] ; previous execution time

    SUB temp1, temp1, temp2 ; time passed

    MOV temp2, displayDataAddress
    STORE temp1, [temp2]

    RETURN

drawLine: ;x0: temp1, y0: temp2, x1: temp3, y1: temp4
    ;dx = abs(x1 - x0)
    SUB temp5, temp3, temp1
    CMP temp5, 0
    BUSLT temp5, temp5, 0 

    ;dy = abs(y1 - y0)
    SUB temp6, temp4, temp2
    CMP temp6, 0
    BUSLT temp6, temp6, 0 
    
    ;sx = x0 < x1 ? 1 : -1
    MOV temp7, 0xFFFFFFFF
    CMP temp1, temp3
    MOVLT temp7, 1

    ;sy = y0 < y1 ? 1 : -1
    MOV temp8, 0xFFFFFFFF
    CMP temp2, temp4
    MOVLT temp8, 1

    ;err = dx - dy
    SUB temp9, temp5, temp6

    ;dy = -dy
    BUS temp6, temp6, 0

    whileTrue1:
        ;set_pixel(x0, y0)
        JUMP setPixel
        continue1:
        
        ;if (x0 == x1 && y0 == y1): break
        CMP temp1, temp3
        JUMPNE continue2

            CMP temp2, temp4
            RETURNEQ

        continue2:

        ;e2 = 2 * err
        MUL temp13, temp9, 2

        ; if (e2 > dy):
        CMP temp13, temp6
        JUMPLE continue3

            ;err += dy
            ADD temp9, temp9, temp6

            ;x0 += sx
            ADD temp1, temp1, temp7

        continue3:

        ;if (e2 < dx):
        CMP temp13, temp5
        JUMPGE continue4

            ;err += dx  
            ADD temp9, temp9, temp5   

            ;y0 += sy
            ADD temp2, temp2, temp8

        continue4:
        JUMP whileTrue1


setPixel: ;x: temp1, y: temp2, imageBufferStartingAddress : temp13
    MOV temp10, temp1
    MOV temp11, temp2
    ;convert to 1D address
    MOV R12, screenWidth
    UMUL temp11, temp11, R12
    ADD temp10, temp10, temp11

    ; get number of pixel inside the word
    AND temp11, temp10, 0xFFFFFFFF, LSR 27 
    MOV R12, 31
    SUB temp11, R12, temp11

    ; calculate image buffer address of word that contains the pixel
    MOV temp10, temp10, LSR 5 ; divide by 32 to get word number
    MOV temp10, temp10, LSL 2 ; multiply by 4 to get address 
    
    ;write to buffer that is not currently being display
    MOV temp13, imageBuffer0StartingAddress
    MOV temp12, activeBufferAddress
    LOAD temp12, [temp12]
    CMP temp12, 0
    MOVEQ temp13, imageBuffer1StartingAddress

    ADD temp10, temp10, temp13

    ; load word from image buffer into register
    LOAD temp12, [temp10]

    ; set the right bit 
    ORR temp12, temp12, 1, LSL temp11

    ; write the changed word back to the image buffer
    STORE temp12, [temp10]

    JUMP continue1

;This deletes all data inside the image buffer
clearImageBuffer:
    ; write to buffer that is not currently being display
    MOV temp1, imageBuffer0StartingAddress
    MOV temp3, activeBufferAddress
    LOAD temp2, [temp3]
    CMP temp2, 0
    MOVEQ temp1, imageBuffer1StartingAddress

    MOV temp2, 0x00000000
    MOV temp3, 38400
    ADD temp3, temp3, temp1
    loop1:
       STORE temp2, [temp1] 
       ADD temp1, temp1, 4
       CMP temp1, temp3
       JUMPNE loop1

    RETURN

flipBuffer:
    ;wait until v-sync signal has been triggered (VGA controller is idle)
    MOV temp1, VSyncAddress
    LOAD temp2, [temp1]
    CMP temp2, 0
    JUMPNE flipBuffer

    ;flip buffer
    MOV temp1, activeBufferAddress
    LOAD temp2, [temp1]
    EOR temp2, temp2, 1 ;flip bit
    STORE temp2, [temp1]

    RETURN

projectPoints:
    MOV temp1, data ;3D coordinates start address
    MOV temp2, 96
    ADD temp2, temp1, temp2 ;3D coordinates end address

    MOV temp3, temp2 ;2D coordinates start address

    loop2:
        ;if 3D coordinates start address == 3 coordinates end address : break
        CMP temp1, temp2
        RETURNEQ

        ;get x coordinate
        LOAD temp4, [temp1]
        ADD temp1, temp1, 4

        ;get y coordinate
        LOAD temp5, [temp1]
        ADD temp1, temp1, 4

        ;get z coordinate
        LOAD temp6, [temp1]
        ADD temp1, temp1, 4
        MOV R12, 0x000001F0
        ADD temp6, temp6, R12 ;create a camera offset

        ; scale points
        MOV R12, scale
        ; temp4 = x * scale
        MUL temp4, temp4, R12

        ; temp5 = y * scale
        MUL temp5, temp5, R12

        ; divide by x by z coordinate to scale in 3d space
        MOV temp7, temp4
        MOV temp8, temp6
        MOV temp12, continue5
        JUMP divide
        continue5:
        MOV temp4, temp7

        MOV temp7, temp5
        MOV temp8, temp6
        MOV temp12, continue6
        JUMP divide
        continue6:
        MOV temp5, temp7

        ; center on screen
        MOV R12, 320
        ADD temp4, temp4, R12, LSL 8

        MOV R12, 240
        ADD temp5, temp5, R12, LSL 8

        ;Convert to integer
        MOV temp4, temp4, ASR 8
        MOV temp5, temp5, ASR 8

        ;Save to memory
        STORE temp4, [temp3]
        ADD temp3, temp3, 4

        STORE temp5, [temp3]
        ADD temp3, temp3, 4

        JUMP loop2

rotatePoints:
    MOV temp10, data ; current qube coordinates start address
    MOV temp2, 160
    ADD temp1, temp10, temp2 ;Initial coordinates start address
    MOV temp2, 96
    ADD temp2, temp1, temp2 ;Initial coordinates end address

    ; load rotation value from memory
    MOV temp3, data
    MOV temp4, 288
    ADD temp4, temp3, temp4
    LOAD temp3, [temp4]

    ; update rotation
    ADD temp5, temp3, 4
    MOV temp6, 360
    CMP temp5, temp6
    SUBGE temp5, temp5, temp6
    STORE temp5, [temp4]

    ;cos(theta)
    MOV temp12, continue50
    MOV temp7, temp3
    MOV temp6, 90 ; change to get a nice animation
    ADD temp7, temp7, temp6
    MOV temp6, 360
    CMP temp7, temp6
    SUBGE temp7, temp7, temp6
    JUMP sine
    continue50:
    MOV temp8, temp7

    ;sin(theta)
    MOV temp12, loop3
    MOV temp7, temp3
    JUMP sine

    loop3:
        ; if 3D coordinates start address == 3 coordinates end address : break
        CMP temp1, temp2
        RETURNEQ

        ; get x coordinate
        LOAD temp4, [temp1]
        ADD temp1, temp1, 4

        ; get y coordinate
        LOAD temp5, [temp1]
        ADD temp1, temp1, 4

        ; get z coordinate
        LOAD temp6, [temp1]
        ADD temp1, temp1, 4

        ;x' =  cosθ * x + sinθ * z
        MUL temp11, temp4, temp7
        MOV temp11, temp11, ASR 8

        MUL temp9, temp6, temp8
        MOV temp9, temp9, ASR 8

        ADD temp11, temp11, temp9
        STORE temp11, [temp10]
        ADD temp10, temp10, 4

        ;y' = y
        STORE temp5, [temp10]
        ADD temp10, temp10, 4

        ;z' = -sinθ * x + cosθ * z  
        MUL temp6, temp6, temp7
        MOV temp6, temp6, ASR 8

        MUL temp4, temp4, temp8 
        MOV temp4, temp4, ASR 8

        SUB temp6, temp6, temp4
        STORE temp6, [temp10]
        ADD temp10, temp10, 4    

        JUMP loop3


divide: ; dividend: temp7, divisor: temp8, result: temp7, remainder: temp10, return address : temp12
    ;check if divisor is 0
    CMP temp8, 0
    JUMPNE continue75

    MOV temp7, 0
    JUMP [temp12] 

    continue75:
    
    ;copy operands to temporary registers
    MOV temp9, 0              ; temp9 flag (0 = positive)

    checkA:
    CMP temp7, 0
    JUMPGT checkB
    BUS temp7, temp7, 0       ; temp7 = abs(temp7)
    EOR temp9, temp9, 1               ; flip temp9 flag

    checkB:
    CMP temp8, 0
    JUMPGT init1
    BUS temp8, temp8, 0 ; temp8 = abs(temp8)
    EOR temp9, temp9, 1       ; flip temp9 flag

    init1:
    ; init
    MOV temp7, temp7, LSL 8 ; shift depending on fixed point format
    MOV temp10, 0           ; temp10 = 0
    MOV temp11, 31          ; loop counter = 31

    ; division Loop (long division)
    divLoop:
        MOV temp10, temp10, LSL 1
        MOV temp13, temp7, LSR 31
        ORR temp10, temp10, temp13
        MOV temp7, temp7, LSL 1

        SUB temp10, temp10, temp8

        CMP temp10, 0
        JUMPGE else1
        undoSubstract:

            MOV temp13, 0xFFFFFFFF
            AND temp7, temp7, temp13, LSL 1
            ADD temp10, temp10, temp8
            JUMP continue31

        else1:

            MOV temp13, 1
            ORR temp7, temp7, temp13

        continue31:
        SUB temp11, temp11, 1
        CMP temp11, 0
        JUMPGE divLoop

        ; apply temp9 if needed
        CMP temp9, 0
        BUSNE temp7, temp7, 0 
        JUMP [temp12]     

    
sine: ;angle : temp7, returnReg : temp12, result: temp7
    MOV temp13, 0
    MOV temp5, 180
    CMP temp7, temp5
    JUMPLT continue100
    MOV temp13, 1
    SUB temp7, temp7, temp5
    continue100:

    MOV temp5, data
    MOV temp9, 296
    ADD temp5, temp5, temp9

    AND temp7, temp7, 0xFFFFFFFF, LSL 2
  
    ADD temp5, temp5, temp7
    LOAD temp7, [temp5]
    
    CMP temp13, 1
    BUSEQ temp7, temp7, 0

    JUMP [temp12]

data:
    ; current qube position
    ; Point 0
    ; 0  : point 0 x
    ; 4  : point 0 y
    ; 8  : point 0 z

    ; Point 1
    ; 12 : point 1 x
    ; 16 : point 1 y
    ; 20 : point 1 z

    ; Point 2
    ; 24 : point 2 x
    ; 28 : point 2 y
    ; 32 : point 2 z

    ; Point 3
    ; 36 : point 3 x
    ; 40 : point 3 y
    ; 44 : point 3 z

    ; Point 4
    ; 48 : point 4 x
    ; 52 : point 4 y
    ; 56 : point 4 z

    ; Point 5
    ; 60 : point 5 x
    ; 64 : point 5 y
    ; 68 : point 5 z

    ; Point 6
    ; 72 : point 6 x
    ; 76 : point 6 y
    ; 80 : point 6 z

    ; Point 7
    ; 84 : point 7 x
    ; 88 : point 7 y
    ; 92 : point 7 z


    ;Projected Points
    ; Point 0
    ; 0  : point 0 x
    ; 4  : point 0 y

    ; Point 1
    ; 8 : point 1 x
    ; 12 : point 1 y

    ; Point 2
    ; 16 : point 2 x
    ; 20 : point 2 y

    ; Point 3
    ; 24 : point 3 x
    ; 28 : point 3 y

    ; Point 4
    ; 32 : point 4 x
    ; 36 : point 4 y

    ; Point 5
    ; 40 : point 5 x
    ; 44 : point 5 y

    ; Point 6
    ; 48 : point 6 x
    ; 52 : point 6 y

    ; Point 7
    ; 56 : point 7 x
    ; 60 : point 7 y


    ; initial Qube vertices

    ; Point 0
    ; 0  : point 0 x
    ; 4  : point 0 y
    ; 8  : point 0 z

    ; Point 1
    ; 12 : point 1 x
    ; 16 : point 1 y
    ; 20 : point 1 z

    ; Point 2
    ; 24 : point 2 x
    ; 28 : point 2 y
    ; 32 : point 2 z

    ; Point 3
    ; 36 : point 3 x
    ; 40 : point 3 y
    ; 44 : point 3 z

    ; Point 4
    ; 48 : point 4 x
    ; 52 : point 4 y
    ; 56 : point 4 z

    ; Point 5
    ; 60 : point 5 x
    ; 64 : point 5 y
    ; 68 : point 5 z

    ; Point 6
    ; 72 : point 6 x
    ; 76 : point 6 y
    ; 80 : point 6 z

    ; Point 7
    ; 84 : point 7 x
    ; 88 : point 7 y
    ; 92 : point 7 z

    ;sine and cosine lookup table (starting at 296)
    ; 0: sin(0) = 
    ; 4; sin(1) = 





