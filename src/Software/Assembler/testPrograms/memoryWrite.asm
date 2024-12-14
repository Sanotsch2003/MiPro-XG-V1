define address 123 ; this is a commend aksdjföalskdf
define offset  0x1123
define test3   0b0010110 


start: 
    LOADAL R1, R2, address

    STORE R1 [R2+offset]


end: