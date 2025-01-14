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

### Step 2.1: Download or Clone the Project
1. Ensure you have the project files for your Basys 3 board.
2. If hosted on GitHub, use the following command to clone the repository:

   ```bash
   git clone <repository_url>
   ```
3. Alternatively, download the project as a ZIP file and extract it.

### Step 2.2: Launch Vivado and Open the Project
1. Open Vivado and click **Open Project** from the start menu.
2. Navigate to the project folder and select the `.xpr` (Xilinx Project) file.
3. Once the project loads, review the design sources and constraints.

---

## Part 3: Connect the Basys 3 Board

### Step 3.1: Install Digilent Drivers (if needed)
1. Download and install the Digilent Adept drivers from the [Digilent Website](https://digilent.com).
2. Verify that your Basys 3 board is recognized by your operating system.

### Step 3.2: Connect the Board
1. Plug in the Basys 3 board using a micro-USB cable.
2. Turn on the board using the power switch.

---

## Part 4: Upload the Project to the Basys 3 Board

### Step 4.1: Synthesize the Design
1. In Vivado, click **Run Synthesis** from the toolbar.
2. Wait for the synthesis process to complete.

### Step 4.2: Implement the Design
1. After synthesis, click **Run Implementation**.
2. Ensure that no errors are reported.

### Step 4.3: Generate the Bitstream
1. Click **Generate Bitstream** in the toolbar.
2. Vivado will create a `.bit` file for programming the FPGA.

### Step 4.4: Program the FPGA
1. Click **Open Hardware Manager** from the Vivado toolbar.
2. Click **Open Target** > **Auto Connect** to detect the Basys 3 board.
3. Select **Program Device** and choose the generated `.bit` file.
4. Click **Program** to upload the design to the board.

---

## Part 5: Get Started with Your First Assembly Program Using the MiPro Toolkit

The MiPro Toolkit allows you to write, assemble, and upload assembly programs to the MiPro-XG processor.

### Step 5.1: Install the MiPro Toolkit
Install the MiPro toolkit referring to [Installation Guide](/src/Software/MiPro_XG_Toolkit/README.md)

### Step 5.3: Assemble your first Program
1. Open a terminal. Inside the GitHub repository, navigate to `src/Software/examplePrograms/count`
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
   This should list the USB-Devices available for serial communication.
   
5. Use the MiPro Toolkit to upload the binary file. If you do not provide any additional parameters, the file will be uploaded to the device with index 0:
   ```
   mipro upload count.bin
   ```
   If you `list-ports` shows multiple devices and the FPGA is not the first one, you can upload the file like this using a specific device index:
   ```
   mipro upload count.bin --port <index>
   ```
6. You should now see a counter displayed on the 7-Segment display.
   
---

### Need Help?
For more support, refer to the official [Vivado Documentation](https://www.xilinx.com/support/documentation.html) or the MiPro Toolkit repository’s README file.

---



