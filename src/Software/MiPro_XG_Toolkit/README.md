# MiPro-XG Toolkit

The **MiPro-XG Toolkit** allows you to assemble code that can run on the MiPro-XG Processor. Additionally, it includes a programmer for uploading assembled binary files to the processor.

---

## Installation Guide

Installing this toolkit enables you to use its commands system-wide. It is recommended to use a virtual environment before proceeding with the installation. Follow these steps to install the toolkit:

### Step 1: Clean Up Old Build Artifacts

Before building the package, ensure no old build artifacts are present. Run the following command:

```bash
rm -rf dist build *.egg-info
```

### Step 2: Build the Package

To create distributable formats for the package, execute:

```bash
python setup.py sdist bdist_wheel
```

### Step 3: Install or Upgrade the Package

Finally, install or upgrade the package locally using:

```bash
pip install --upgrade dist/mipro_toolkit-0.1.0.tar.gz
```

### All Commands in One Block

Here is a single block of commands for convenience:

```bash
rm -rf dist build *.egg-info
python setup.py sdist bdist_wheel
pip install --upgrade dist/mipro_toolkit-0.1.0.tar.gz
```

---

## Using the Toolkit

After installation, you can access the toolkit's commands. Run the following to see a list of available commands and their descriptions:

```bash
mipro --help
```

---

## Troubleshooting Serial Port Issues on Linux

If you encounter permission issues when accessing the serial port, follow these steps:

### Step 1: Check Available USB Devices

Run the following command to list all available USB devices:

```bash
ls -l /dev/ttyUSB*
```

You will see output similar to this:

```bash
crw-rw---- 1 root dialout 188, 0 Dec 6 10:00 /dev/ttyUSB0
```

In this example, the device is owned by the `root` user and the `dialout` group.

### Step 2: Grant User Permissions

To grant yourself access to the serial port, run one of the following commands:

#### Option 1: Add User to the `dialout` Group

```bash
sudo usermod -a -G dialout $USER
```

#### Option 2: Add User to the `uucp` Group

```bash
sudo usermod -a -G uucp $USER
```

### Step 3: Reboot Your System

Reboot your system for the changes to take effect.

---

### Need Help?

If you need further assistance, please open an issue on the GitHub repository.

