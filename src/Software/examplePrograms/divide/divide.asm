;temporary registers
define tempB SP
define tempA R7
define sign R8
define temp10 R11
define i R10
define remainder R9
define temp13 R0
define quotient R6
define divisor R1

;seven segment display
define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      

define displayControl        0b00000000111101000010010000100100




setup:
    ;write control data to 7-Segment Display
    MOV sign, displayControlAddress
    MOV temp10, displayControl
    STORE temp10, [sign]

main:
    MOV tempA, 336
    MOV tempB, 112
    JUMP divide
    continue30:
    MOV temp13, displayDataAddress
    STORE quotient, [temp13]
    HALT

divide: ; dividend: tempA, divisor: tempB, result: quotient, remainder: remainder
    ;copy operands to temporary registers
    MOV quotient, tempA 
    MOV divisor, tempB

    MOV sign, 0              ; sign flag (0 = positive)

    checkA:
    CMP quotient, 0
    JUMPGT checkB
    BUS quotient, quotient, 0       ; tempA = abs(tempA)
    EOR sign, sign, 1               ; flip sign flag

    checkB:
    CMP divisor, 0
    JUMPGT init1
    BUS divisor, divisor, 0 ; divisor = abs(divisor)
    EOR sign, sign, 1       ; flip sign flag

    init1:
    ; init
    MOV quotient, quotient, LSL 6 ; shift depending on fixed point format
    MOV remainder, 0        ; remainder = 0
    MOV i, 31               ; loop counter = 31

        ; division Loop (long division)
    divLoop:
        MOV remainder, remainder, LSL 1
        MOV temp13, quotient, LSR 31
        ORR remainder, remainder, temp13
        MOV quotient, quotient, LSL 1

        SUB remainder, remainder, divisor

        CMP remainder, 0
        JUMPGE else1
        undoSubstract:

            MOV temp13, 0xFFFFFFFF
            AND quotient, quotient, temp13, LSL 1
            ADD remainder, remainder, divisor
            JUMP continue31

        else1:

            MOV temp13, 1
            ORR quotient, quotient, temp13

        continue31:
        SUB i, i, 1
        CMP i, 0
        JUMPGE divLoop

        ; apply sign if needed
        CMP sign, 0
        BUSNE quotient, quotient, 0 
        JUMP continue30

