define serialInterfaceStatusAddress 0x40000060
define serialInterfaceInteractionAddress 0x40000064

define H 0x68
define E 0x65
define L 0x6C
define O 0x6F
define SPACE 0x20
define W 0x77
define R 0x72
define D 0x64


main:
    MOV R8, H
    JUMPL transmit
    MOV R8, E
    JUMPL transmit
    MOV R8, L
    JUMPL transmit
    MOV R8, L
    JUMPL transmit
    MOV R8, O
    JUMPL transmit
    MOV R8, SPACE
    JUMPL transmit
    MOV R8, W
    JUMPL transmit
    MOV R8, O
    JUMPL transmit
    MOV R8, R
    JUMPL transmit
    MOV R8, L
    JUMPL transmit
    MOV R8, D
    JUMPL transmit
    HALT



transmit: ;transmit the first 8 bytes of R8 over UART
    MOV R6, serialInterfaceInteractionAddress
    STORE R8, [R6]
    RETURN