# Getting Started Guide: Vivado, Basys3, and MiPro Toolkit

Clone this repository running

```bash
git clone https://github.com/Sanotsch2003/MiPro-XG-V1.git
cd MiPro-XG-V1
```

First, the FPGA-Board needs to be configured to emulate the processor architecture. This is done by uploading a special binary file to the Basys3 Board. This so-called bitstream file can be obtained by compiling the corresponding VHDL Code, which can be found in this repository. However, to compile the code, you will need to install Vivado which is an IDE that can be used to write, compile, and simulate VHDL-Code and upload the bitstream file to the FPGA-Board. Vivado has a size of about 20GB and I would only recommend installing it if you are planning on making changes to the VHDL code or if you want to use a different FPGA-Board. Depending on your specific FPGA-Model, you might have to use a different IDE. If you are not planning to make any changes to the code, you can directly use a precompiled bitstream file and a terminal program to upload it to your Board. Both processes, as well as an explanation of how to get started with your first assembly program using the MiPro toolkit will be provided in this guide:

- [Upload a Precompiled Bitsream File to the Basys3 Board](#uploading-a-precompiled-bitstream-file-to-the-basys3-board)
- [Install Vivado and Compile the Bitstream File Yourself](#install-vivado-and-compile-the-bitstream-file-yourself)
- [Get Started with Your First Assembly Program Using the MiPro Toolkit](#get-started-with-your-first-assembly-program-using-the-mipro-toolkit)

---

## Uploading a precompiled bitstream file to the Basys3 Board

### Step 1: Download openFPGALoader

On Debian based systems, run

```
sudo apt update
sudo apt install openfpgaloader
```

On Arch based systems, run

```
sudo pacman -S openfpgaloader
```

On Windows, follow the steps below:

1. Download the latest Windows binary from the official [GitHub releases](https://github.com/trabucayre/openFPGALoader/releases)
2. Extract the ZIP file.
3. Run the openFPGALoader.exe file.

### Step 2: Upload the bitstream file.

1. Make sure you have cloned this repository. Inside a terminal, navigate to
   ```
   MiPro-XG-V1/src/Hardware/BitstreamFiles
   ```
2. Connect the Basys3 Board to your computer using a micro USB cable.
3. You can check if the board is being detected by running
   ```
   openFPGALoader --scan-usb
   ```
   The output should look something like this:
   ```
   Bus device vid:pid       probe type      manufacturer serial               product
   001 010    0x0403:0x6010 FTDI2232        Digilent   210183B5ABBF         Digilent USB Device
   ```
4. Upload the bitstream by running
   ```
   openFPGALoader -b basys3 Basys3.bit
   ```
   The command above will not save the configuration to flash. Therefore, it will be lost as soon as the board is turned off. If you want to keep the configuration by saving it to flash, you can instead run
   ```
   openFPGALoader -b basys3 -f Basys3.bit
   ```

## Install Vivado and Compile the Bitstream File Yourself

### Step 1: Download Vivado

1. Visit the [Xilinx Download Center](https://www.xilinx.com/support/download.html).
2. Select the Vivado Design Suite version appropriate for your operating system (Make sure you install Vivado v2024.2 as the project will not be loaded correctly otherwise. If you need to use another version of Vivado or have a different version installed already, you will have to import the VHDL- and constraint-files manually into a new project).
3. Register for a Xilinx account if you don’t already have one.

### Step 2: Install Vivado

1. Run the installer:
   - On Linux: Open a terminal and execute the `.bin` installer.
   - On Windows: Double-click the `.exe` file.
2. Follow the on-screen instructions:
   - Select WebPACK during the installation process.
   - Install the USB drivers for FPGA programming.
3. Once installed, launch Vivado.

### Step 3: Launch Vivado and Open the VHDL-Project

1. Open Vivado and click **Open Project** from the start menu.
2. Navigate to `MiPro-XG-V1/src/Hardware/MiPro-XG-V1` inside the GitHub repository and select the `MiPro-XG-V1.xpr` file.
   ![Generate Bitsream](/docs/imgs/ChoosingVivadoProjectFile.jpg)
3. If you want to make any changes to the VHDL-Code, you can do it now.

### Step 4: Connect the Board

1. Plug in the Basys3 board using a micro-USB cable.
2. Turn on the board using the power switch.

### Step 5: Synthesize and Implement the Design and Generate the Bitstream

1. Click **Generate Bitstream** in the toolbar.
   ![Generate Bitsream](/docs/imgs/GeneratingBitstream.jpg)
2. Vivado will run the synthesis and implementation of the design and create a `.bit` file for programming the FPGA.

### Step 6: Program the FPGA

1. Click **Open Hardware Manager** from the Vivado toolbar.
   ![Open Target](/docs/imgs/OpenHardwareManager.jpg)
2. Click **Open Target** > **Auto Connect** to detect the Basys3 board.
   ![Open Target](/docs/imgs/OpenTarget.jpg)
3. Select **Program Device** and choose the generated `.bit` file.
4. Click **Program** to upload the design to the board.
   ![Program](/docs/imgs/ProgramDevice.jpg)

---

## Get Started with Your First Assembly Program Using the MiPro Toolkit

The MiPro Toolkit allows you to write, assemble, and upload assembly programs to the MiPro-XG processor and debug running programs.

### Step 1: Install the MiPro Toolkit

Install the MiPro toolkit referring to the [Installation Guide](/src/Software/MiPro_XG_Toolkit/README.md).

### Step 2: Assemble your first Program

1. Open a terminal. Inside the GitHub repository, navigate to `MiPro-XG-V1/src/Software/examplePrograms/count`
2. Use the MiPro Toolkit to assemble your program into a binary:
   ```
   mipro assemble count.asm
   ```
   This should create a count.bin file inside the same directory.

### Step 3: Upload the Program to the Processor

![FPGA Hardware Explained](/docs/imgs/FPGAHardwareExplained.jpeg)

1. Connect your Basys3 board to your computer.
2. Ensure you have uploaded the processor architecture to the FPGA as described in 4.4.
3. (Optional): You can search for available USB-Devices using the following command:
   ```
   mipro list-ports
   ```
   This should list the USB devices available for serial communication.
4. Turn on the processor (SW15) and enable the programming mode (SW12). The upper position of the switches is the ON-position.
5. Use the MiPro Toolkit to upload the binary file. If you do not provide any additional parameters, the file will be uploaded to the device with index 0:
   ```
   mipro upload count.bin
   ```
   If `list-ports` shows multiple devices and the FPGA is not the first one, you can upload the file using a specific device index like this:
   ```
   mipro upload count.bin --port <index>
   ```
6. When the program has finished uploading and no errors have occured, disable the programming mode by flipping switch 12 (SW12) back into the lower position. You should now see the 7-segment-display counting up.

### Step 4: Start Debugging the Program

1. You can start sending debug signals to the connected computer by flipping switch 13 (SW13) into the upper position.

2. To visualize the signals, run
   ```
   mipro debug
   ```
   You should now see the following GUI:
   ![FPGA Hardware Explained](/docs/imgs/RunningDebugger.png)
   Connect to the FPGA-board and change settings using the buttons at the top of the window.
3. To halt the program while debugging, flip switch 14 (SW14) into the upper position and use the lower push button to trigger clock edges manually. You can use the reset button to restart the execution of the program.

---

### Important Note

The serial interface is used for debugging as well as programming.
Therefore, I recommend closing the debugging software while uploading a new program to the processor to avoid interference and potential errors.

---

### Need Help?

- For issues regarding Vivado:
  - Refer to the official [Vivado Documentation](https://www.xilinx.com/support/documentation.html).
  - For Arch-Linux-based Systems, also refer to the [Arch Wiki](https://wiki.archlinux.org/title/Xilinx_Vivado).
- For issues related to the MiPro Toolkit:
  - MiPro Toolkit's [README.md](/src/Software/MiPro_XG_Toolkit/README.md) file
  - Open an Issue in the GitHub repository.

---
