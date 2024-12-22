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
    "STOREW": 0b001,
    "AND" : 0b0000,
    "TST" : 0b0000,
    "EOR" : 0b0001,
    "TEQ" : 0b0001,
    "ORR" : 0b0010,
    "BIC" : 0b0011,
    "NOT" : 0b0100,
    "SUB" : 0b0101,
    "CMP" : 0b0101,
    "BUS" : 0b0110,
    "ADD" : 0b0111,
    "CMN" : 0b0111,
    "ADC" : 0b1000,
    "SBC" : 0b1001,
    "BSC" : 0b1010,
    "MOV" : 0b1011,
    "MUL" : 0b1100,
    "MULL" : 0b1100,
    "UMUL" : 0b1101,
    "UMULL" : 0b1101,
    "PASS" : 0b0000,
    "HALT" : 0b0001,
    "SIR" : 0b0010,
    "JUMP" : 0b00,
    "JUMPL" : 0b01,
}

INSTRUCTION_CLASSES = {
    "LOAD": "Data Movement",
    "LOADW": "Data Movement",
    "STORE": "Data Movement",
    "STOREW": "Data Movement",
    "AND" : "Data Processing",
    "TST" : "Data Processing",
    "EOR" : "Data Processing",
    "TEQ" : "Data Processing",
    "ORR" : "Data Processing",
    "BIC" : "Data Processing",
    "NOT" : "Data Processing",
    "SUB" : "Data Processing",
    "CMP" : "Data Processing",
    "BUS" : "Data Processing",
    "ADD" : "Data Processing",
    "CMN" : "Data Processing",
    "ADC" : "Data Processing",
    "SBC" : "Data Processing",
    "BSC" : "Data Processing",
    "MOV" : "Data Processing",
    "MUL" : "Data Processing",
    "MULL" : "Data Processing",
    "UMUL" : "Data Processing",
    "UMULL" : "Data Processing",
    "PASS" : "Special Instructions",
    "HALT" : "Special Instructions",
    "SIR" : "Special Instructions",
    "JUMP" : "Control Flow",
    "JUMPL" : "Control Flow",
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


BIT_MASKS = {
    0x00000000 : 0b0000,
    0x00000001 : 0b0001,
    0x00000003 : 0b0010,
    0x0000000F : 0b0011,
    0x000000FF : 0b0100,
    0x0000FF00 : 0b0101,
    0x0F0F0F0F : 0b0110,
    0xF0F0F0F0 : 0b0111,
    0x55555555 : 0b1000,
    0xAAAAAAAA : 0b1001,
    0xFFFFFFFF : 0b1010
}