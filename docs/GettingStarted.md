# Getting Started Guide: Vivado, Basys 3, and MiPro Toolkit

This comprehensive guide explains how to install Vivado, open a project, upload it to the Basys 3 FPGA board, and get started with your first assembly program using the MiPro Toolkit.

---

## Part 1: Install Vivado

### Step 1.1: Download Vivado
1. Visit the [Xilinx Download Center](https://www.xilinx.com/support/download.html).
2. Select the Vivado Design Suite version appropriate for your operating system.
3. Register for a Xilinx account if you don’t already have one.
4. Download the WebPACK edition (sufficient for Basys 3 projects and free).

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
1. Clone the MiPro Toolkit repository or download it as a ZIP file:
   ```bash
   git clone <mipro_toolkit_repository_url>
   ```
2. Navigate to the toolkit directory:
   ```bash
   cd MiPro_XG_Toolkit
   ```
3. Clean up old build artifacts:
   ```bash
   rm -rf dist build *.egg-info
   ```
4. Build and install the toolkit:
   ```bash
   python setup.py sdist bdist_wheel
   pip install --upgrade dist/mipro_toolkit-0.1.0.tar.gz
   ```

### Step 5.2: Write Your First Assembly Program
1. Create a new `.asm` file in a text editor of your choice (e.g., `program.asm`).
2. Write a simple assembly program, such as:
   ```asm
   MOV R1, #5    ; Load the value 5 into register R1
   ADD R2, R1, #10 ; Add 10 to R1 and store the result in R2
   HALT           ; Stop execution
   ```
3. Save the file in the project directory.

### Step 5.3: Assemble the Program
1. Use the MiPro Toolkit to assemble your program into a binary:
   ```bash
   mipro assemble program.asm -o program.bin
   ```

### Step 5.4: Upload the Program to the Processor
1. Connect your Basys 3 board to your computer.
2. Use the MiPro Toolkit to upload the binary file:
   ```bash
   mipro upload program.bin
   ```
3. Verify that the program runs correctly on the processor.

---

## Troubleshooting

### Common Issues
- **Board Not Detected**: Ensure the Digilent drivers are installed, and the board is powered on.
- **Synthesis Errors**: Double-check your HDL code and constraints file for errors.
- **MiPro Toolkit Errors**: Ensure you’ve correctly installed the toolkit and provided the correct paths to files.

---

### Need Help?
For more support, refer to the official [Vivado Documentation](https://www.xilinx.com/support/documentation.html) or the MiPro Toolkit repository’s README file.

---

Congratulations! You’ve successfully set up Vivado, programmed the Basys 3 board, and executed your first assembly program using the MiPro Toolkit. Enjoy exploring and developing with your FPGA!


