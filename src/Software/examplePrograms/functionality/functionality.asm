define x R0
define y R1
define seed R7
define result R2
define temp1 R3
define temp2 R4
define temp3 R5
define temp4 R6


test:
    MOV x, 1
    MOV y, 6
    MOV seed, 95


    ;JUMPL divide
    ;JUMPL modulo
    JUMPL randomInRange
    JUMPL displayResult
    HALT

;Division with positive integers (division by zero results in endless loop)
divide: ;x/y  => result
    MOV result, 0
    MOV temp1, 0
    loop1:
        UMUL temp1, result, y
        SUB temp1, x, temp1
        ADD result, result, 1
        CMP temp1, y
        JUMPLS loop1

    SUB result, result, 1

    RETURN

;Modulo with positive integers
modulo: ; x mod y => result
    MOV result, 0
    MOV temp1, 0
    loop2:
        UMUL temp1, result, y
        SUB temp1, x, temp1
        ADD result, result, 1
        CMP temp1, y
        JUMPLS loop2

    SUB result, result, 1
    UMUL result, result, y 
    SUB result, x, result

    RETURN   

;Returns a random number within the closed interval [x, y]
randomInRange: ; random(x, y), seed => result
    mov temp1, 25173
    mov temp2, 13849

    UMUL temp1, temp1, seed
    ADD temp1, temp1, temp2

    MOV temp2, 65536

    MOV result, 0
    MOV temp3, 0
    loop3:
        UMUL temp3, result, temp2
        SUB temp3, temp1, temp3
        ADD result, result, 1
        CMP temp3, temp2
        JUMPLS loop3

    SUB result, result, 1
    UMUL result, result, temp2
    SUB temp1, temp1, result 

    SUB temp2, y, x
    ADD temp2, temp2, 1 

    MOV result, 0
    MOV temp3, 0
    loop4:
        UMUL temp3, result, temp2
        SUB temp3, temp1, temp3
        ADD result, result, 1
        CMP temp3, temp2
        JUMPLS loop4

    SUB result, result, 1
    UMUL result, result, temp2
    SUB result, temp1, result 

    ADD result, result, x

    RETURN





define displayControlAddress 0x40000050      
define displayDataAddress    0x40000054      
define displayControl        0b00000000111101000010010000101100
displayResult: 
    ;write control data to 7-Segment Display
    MOV temp1, displayControlAddress
    MOV temp2, displayControl
    STORE temp2, [temp1]

    ;write display data to 7-Segment Display
    MOV temp1, displayDataAddress
    STORE result, [temp1]
    
    RETURN


