#MiPro-XG Toolkit

This toolkit allows you to assemble code that can run on the MiPro-XG Processor. Moreover, it includes a programmer, which can be used to upload assembled binary files to the processor. 
 
## How to Install the Toolkit
Installing this toolkit use the commands from anywhere on the system. Make sure you have installed on your system. You might also want to create a virtual environment before the installation.
Open a terminal and navigate to the parent directory `MiPro_XG_Toolkit`. Run the following commands from here.

### Step 1: Clean Up Old Build Artifacts

Before building your package, it's important to clean up old build artifacts to ensure a fresh start. Use the following command:

```bash
rm -rf dist build *.egg-info
```

### Step 2: Build the Package

To build your package into distributable formats like `.tar.gz` and `.whl`, use:

```bash
python setup.py sdist bdist_wheel
```

### Step 3: Install or Upgrade the Package

To install or upgrade your package locally, use the following command:

```bash
pip install --upgrade dist/mipro_toolkit-0.1.0.tar.gz
```

### All Commands Ready to Copy
```bash
rm -rf dist build *.egg-info
python setup.py sdist bdist_wheel
pip install --upgrade dist/mipro_toolkit-0.1.0.tar.gz
```


## Using the Toolkit
Run `mipro --help` to get a short description of available commands. 