# MiPro-XG-V1

- Big Endian
- 32-Bit
- 16 General Purpose Registers (GPR)
  - 0-13: "real" GPR
  - 14: Stack Pointer (SP)
  - 15: Program Counter (PC)
- Flags Register (FR)
  - 0: Negative (N)
  - 1: Zero (Z)
  - 2: Carry (C)
  - 3: Overflow (O)
 
- Interrupt Controller and Interrupt Handling(Idea):
    - General Assumptions:
        - Each interrupt is assigned a priority. If multiple Interrupts happen at the same time, the One with the highes priority will be handled first. 
        - Interrupts cannot interrupt running interrupt handlers even if they have a higher priority (No nested Interrupts possible) .
        - Interrupts that occur while another Interrupt handler is running will be added to a queue, so that they are not dropped but handled later.
    - Input: all Hardware Interrupt Signals
    - Contains One register for Interrupt Priorities, which can also be used to ignore interrupts (Can be written to and read from like A GPR, size might not be 32 bits. Should be initialized at system startup)
    - Each Interrupt is assigned a unique Identifier ID (starting from 1)
    - Output:
        - 0 if no interrupt occured
        - Identifier ID if interrupt occured (if multiple interrupts occured, the ID with highest Priority will be set as output. The other interrupts will be saved for later handling)
        - Output will be connected to Controll Unit (CU).
          - CU contains internal flag bit called "Currently handling Interrupt flag". 
          - Before each Instruction fetch, the CU checks whether the output of the Interrupt controller is not zero
          - If it's zero it will continue fetching as usual
          - If it's not zero, it will set an internal Flag ("Currently handling Interrupt flag")  

- [Custom Instruction Set Architecture](docs/InstructionSetArchitecture.md)
