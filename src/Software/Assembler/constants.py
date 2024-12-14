CONDITION_CODES = {
    "EQ": 0b0000,
    "NE": 0b0001,
    "CS": 0b0010,
    "CC": 0b0011,
    "MI": 0b0100,
    "PL": 0b0101,
    "VS": 0b0110,
    "VC": 0b0111,
    "HI": 0b1000,
    "LS": 0b1001,
    "GE": 0b1010,
    "LT": 0b1011,
    "GT": 0b1100,
    "LE": 0b1101,
    "AL": 0b1110
}

OPERATION_CODES = {
    "LOAD": 0b000,
    "LOADW": 0b000,
    "STORE": 0b001,
    "STOREW": 0b001
}

INSTRUCTION_CLASSES = {
    "LOAD": "Data Movement",
    "LOADW": "Data Movement",
    "STORE": "Data Movement",
    "STOREW": "Data Movement"
}

REGISTER_CODES = {
    "R0":  0b00000,
    "R1":  0b00001,
    "R2":  0b00010,
    "R3":  0b00011,
    "R4":  0b00100,
    "R5":  0b00101,
    "R6":  0b00110,
    "R7":  0b00111,
    "R8":  0b01000,
    "R9":  0b01001,
    "R10": 0b01010,
    "R11": 0b01011,
    "R12": 0b01100,
    "LR":  0b01101,   # Link Register
    "SP":  0b01110,   # Stack Pointer
    "PC":  0b01111,   # Program Counter
    "CPSR": 0b10000   # Status register
}

BIT_MANIPULATION_METHODS = {
    "ROL" : 0b00,
    "LSL" : 0b01,
    "LSR" : 0b10,
    "ASR" : 0b11
}
