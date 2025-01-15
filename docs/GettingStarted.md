# Getting Started Guide: Vivado, Basys 3, and MiPro Toolkit

This comprehensive guide explains how to install Vivado, open a project, upload it to the Basys 3 FPGA board, and get started with your first assembly program using the MiPro Toolkit.

---

## Part 1: Install Vivado

### Step 1.1: Download Vivado
1. Visit the [Xilinx Download Center](https://www.xilinx.com/support/download.html).
2. Select the Vivado Design Suite version appropriate for your operating system.
3. Register for a Xilinx account if you don’t already have one.

### Step 1.2: Install Vivado
1. Run the installer:
   - On Linux: Open a terminal and execute the `.bin` installer.
   - On Windows: Double-click the `.exe` file.
2. Follow the on-screen instructions:
   - Select WebPACK during the installation process.
   - Install the USB drivers for FPGA programming.
3. Once installed, launch Vivado.

---

## Part 2: Open a Project in Vivado

### Step 2.1: Download or Clone the Project.
1. Open a terminal and run the following command to clone the repository (You might need to install git first):

   ```bash
   git clone https://github.com/Sanotsch2003/MiPro-XG-V1.git
   ```
2. Alternatively, download the project as a ZIP file from this reposiry's [project page](https://github.com/Sanotsch2003/MiPro-XG-V1) and extract it.

### Step 2.2: Launch Vivado and Open the Project
1. Open Vivado and click **Open Project** from the start menu.
2. Navigate to `MiPro-XG-V1/src/Hardware/MiPro-XG-V1` inside the GitHub repository and select the `MiPro-XG-V1.xpr` file.
   ![Generate Bitsream](/docs/imgs/ChoosingVivadoProjectFile.jpg)

---

## Part 3: Connect the Basys 3 Board

### Step 3.1: Connect the Board
1. Plug in the Basys 3 board using a micro-USB cable.
2. Turn on the board using the power switch.

---

## Part 4: Upload the Project to the Basys 3 Board

### Step 4.1: Synthesize and Implement the Design and Generate the Bitstream
1. Click **Generate Bitstream** in the toolbar.
   ![Generate Bitsream](/docs/imgs/GeneratingBitstream.jpg)
2. Vivado will run the synthesis and implementation of the design and create a `.bit` file for programming the FPGA.


### Step 4.2: Program the FPGA
1. Click **Open Hardware Manager** from the Vivado toolbar.
   ![Open Target](/docs/imgs/OpenHardwareManager.jpg)
3. Click **Open Target** > **Auto Connect** to detect the Basys 3 board.
   ![Open Target](/docs/imgs/OpenTarget.jpg)
4. Select **Program Device** and choose the generated `.bit` file.
5. Click **Program** to upload the design to the board.
   ![Program](/docs/imgs/ProgramDevice.jpg)
---

## Part 5: Get Started with Your First Assembly Program Using the MiPro Toolkit

The MiPro Toolkit allows you to write, assemble, and upload assembly programs to the MiPro-XG processor.

### Step 5.1: Install the MiPro Toolkit
Install the MiPro toolkit referring to [Installation Guide](/src/Software/MiPro_XG_Toolkit/README.md)

### Step 5.3: Assemble your first Program
1. Open a terminal. Inside the GitHub repository, navigate to `MiPro-XG-V1/src/Software/examplePrograms/count`
2. Use the MiPro Toolkit to assemble your program into a binary:
   ```
   mipro assemble count.asm 
   ```
   This should create a count.bin file inside the same directory.

### Step 5.4: Upload the Program to the Processor
1. Connect your Basys 3 board to your computer.
2. Ensure you have uploaded the processor architecture to the FPGA as described in 4.4.
3. (Optional): You can search for available USB-Devices using the following command:
   ```
   mipro list-ports
   ```
   This should list the USB devices available for serial communication.
5. Turn On the the processor (switch 15) and enable the programming mode (switch 12):
   ![Programming](/docs/imgs/FPGAProgrammingMode.jpg)
6. Use the MiPro Toolkit to upload the binary file. If you do not provide any additional parameters, the file will be uploaded to the device with index 0:
   ```
   mipro upload count.bin
   ```
   If  `list-ports` shows multiple devices and the FPGA is not the first one, you can upload the file like this using a specific device index:
   ```
   mipro upload count.bin --port <index>
   ```
   
7. When the program has finished uploading and no erros have occured, disable the programming mode by flipping switch 12 back into the lower position. You should now see the 7-segment-display counting up.
   ![Programming](/docs/imgs/FPGAProgrammingModeOff.jpg)
---

### Need Help?
- For issues regarding Vivado:
   - Refer to the official [Vivado Documentation](https://www.xilinx.com/support/documentation.html).
   - For Arch-Linux-based Systems, also refer to the [Arch Wiki](https://wiki.archlinux.org/title/Xilinx_Vivado) (.
- For issues related to the MiPro Toolkit:
   - MiPro Toolkit's [README.md](/src/Software/MiPro_XG_Toolkit/README.md) file
   - Open an Issue in the GitHub repository.

---



