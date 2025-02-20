# **MiPro-XG-V1: A RISC-Based 32-Bit Microprocessor**


## **Overview**

Welcome to the repository for **MiPro-XG-V1**, a RISC-based 32-bit microprocessor designed and emulated using **VHDL** on the **Basys 3 FPGA**. This project demonstrates the creation of a custom processor from scratch, including a custom instruction set, a software toolkit, and hardware-level interfaces.

---

### **Key Features**

- **Custom RISC-based 32-bit Microprocessor**
  - Implements a **Von-Neumann architecture**.
  - Includes Register, Control, and Arithmetic Logic Units (ALU).
- **Peripheral Support**
  - UART communication for general use and program uploads via a bootloader.
  - Built-in support for 7-segment display interfaces.
  - PWM Output pins.
- **[Software Toolkit](/src/Software/MiPro_XG_Toolkit/)**
  - A custom **Assembler** for compiling programs.
  - Tools for uploading binary files directly to the processor.
  - Software to monitor internal registers, signals, etc. enabling **Real-Time Debugging**. 
- **MMIO Expandability**
  - Simple integration of memory-mapped I/O devices for additional functionality.
- **Additional Features**
  - Enhanced debugging with the ability to pause the clock during program execution and step through it manually using a button.

---

## **Documentation**

Explore detailed documentation to understand the architecture, codebase, and hardware setup. Click on the links below for more information:

- **[Instruction Set Architecture Documentation and Assembly Language Guide](docs/InstructionSetArchitecture.md)**
- **[Hardware Architecture](docs/HardwareArchitecure.md)** <!-- TODO: - **[VHDL Codebase Walkthrough](#)**-->
- **[Getting Started Guide](docs/GettingStarted.md)**  
- **[Project Overview Presentation](#)**  

---

## **Project Highlights**

### **Architecture Diagram**
![Hardware Architektur](/docs/imgs/HighLevelHardwareArchitecture.drawio.svg)

### **FPGA in Action**
![FPGA Basys 3 Board](/docs/imgs/FPGARunning.jpeg)  

### **Debugger to monitor internal Signals**
![Visual Debugger](/docs/imgs/RunningDebugger.png)

---

## **Quick Start**

1. Clone this repository:  
   ```bash
   git clone https://github.com/Sanotsch2003/MiPro-XG-V1.git
   cd MiPro-XG-V1
   ```
2. Follow the [Getting Started Guide](docs/GettingStarted.md) to set up the project on your Basys 3 FPGA.
3. Compile and upload your first program using the [Software Toolkit](/src/Software/MiPro_XG_Toolkit/).

---

## **Future Work**

- Implement support for **hardware timers** and a **VGA controller**.  
- Fully integrate hardware/software interrupts.  

---

## **Contributing**

Contributions are welcome! If you have ideas for new features, bug fixes, or enhancements, please open an issue or submit a pull request.

---

## **License**

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE.md) file for details.
