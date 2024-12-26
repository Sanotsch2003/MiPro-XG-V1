;ADD LR, PC, 4
JUMPL display
setupt:
    MOV R11, 1234

start:
		MOV R0, 3
        JUMPL display
        JUMP start

display:
    MOV R1, 3
    CMP R1, R0
    RETURNEQ