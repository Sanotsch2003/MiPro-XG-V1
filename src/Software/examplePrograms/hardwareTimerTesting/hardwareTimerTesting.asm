    ; Initialize Timer 0 (8-bit)
    MOV R0, 0x40000068       ; Load address of Timer 0 Prescaler
    MOV R1, 0x00000010       ; Load value 0x10 into R1 (Prescaler value)
    STORE R1, [R0]           ; Store value from R1 to Timer 0 Prescaler

    MOV R0, 0x4000006C       ; Load address of Timer 0 Max Count
    MOV R1, 0x000000FA       ; Load value 0xFA into R1 (Max count value)
    STORE R1, [R0]           ; Store value from R1 to Timer 0 Max Count

    MOV R0, 0x40000070       ; Load address of Timer 0 Mode & Interrupt
    MOV R1, 0b011            ; Load value 0b011 into R1 (Mode and interrupt)
    STORE R1, [R0]           ; Store value from R1 to Timer 0 Mode & Interrupt

    ; Initialize Timer 1 (16-bit)
    MOV R0, 0x40000074       ; Load address of Timer 1 Prescaler
    MOV R1, 0x00000020       ; Load value 0x20 into R1 (Prescaler value)
    STORE R1, [R0]           ; Store value from R1 to Timer 1 Prescaler

    MOV R0, 0x40000078       ; Load address of Timer 1 Max Count
    MOV R1, 0x0000FF00       ; Load value 0xFF00 into R1 (Max count value)
    STORE R1, [R0]           ; Store value from R1 to Timer 1 Max Count

    MOV R0, 0x4000007C       ; Load address of Timer 1 Mode & Interrupt
    MOV R1, 0b011            ; Load value 0b011 into R1 (Mode and interrupt)
    STORE R1, [R0]           ; Store value from R1 to Timer 1 Mode & Interrupt

    ; Initialize Timer 2 (16-bit)
    MOV R0, 0x40000080       ; Load address of Timer 2 Prescaler
    MOV R1, 0x00000040       ; Load value 0x40 into R1 (Prescaler value)
    STORE R1, [R0]           ; Store value from R1 to Timer 2 Prescaler

    MOV R0, 0x40000084       ; Load address of Timer 2 Max Count
    MOV R1, 0x0000AAAA       ; Load value 0xAAAA into R1 (Max count value)
    STORE R1, [R0]           ; Store value from R1 to Timer 2 Max Count

    MOV R0, 0x40000088       ; Load address of Timer 2 Mode & Interrupt
    MOV R1, 0b011            ; Load value 0b011 into R1 (Mode and interrupt)
    STORE R1, [R0]           ; Store value from R1 to Timer 2 Mode & Interrupt

    ; Initialize Timer 3 (32-bit)
    MOV R0, 0x4000008C       ; Load address of Timer 3 Prescaler
    MOV R1, 0x00000100       ; Load value 0x100 into R1 (Prescaler value)
    STORE R1, [R0]           ; Store value from R1 to Timer 3 Prescaler

    MOV R0, 0x40000090       ; Load address of Timer 3 Max Count
    MOV R1, 0xF              ; Load value 0xF into R1 (Max count value)
    STORE R1, [R0]           ; Store value from R1 to Timer 3 Max Count

    MOV R0, 0x40000094       ; Load address of Timer 3 Mode & Interrupt
    MOV R1, 0b011            ; Load value 0b011 into R1 (Mode and interrupt)
    STORE R1, [R0]           ; Store value from R1 to Timer 3 Mode & Interrupt
