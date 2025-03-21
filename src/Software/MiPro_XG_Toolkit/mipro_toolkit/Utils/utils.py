from serial.tools import list_ports
import json
import os
import sys

def listUsbSerialPorts():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    for port in ports:
        print(str(port.device))
    usbPorts = [port.device for port in ports if 'USB' in str(port.device)]
    if not usbPorts:
            print("No USB serial ports found.")
    else:
        for i, port in enumerate(usbPorts):
            print(f"{i}: {port}")

def setBaudrate(baudrate):
    """Makes changes to the configuration file."""
    configPath = os.path.join(os.path.dirname(__file__), "..", "config.json")

    if os.path.exists(configPath):
        with open(configPath, "r") as file:
            config = json.load(file)
    else:
        config = {} 

    config["baudrate"] = baudrate

    with open(configPath, "w") as file:
        json.dump(config, file, indent=4)

    print(f"Baudrate updated to {baudrate} in {configPath}")

def getBaudrate():
    configPath = os.path.join(os.path.dirname(__file__), "..", "config.json")

    if os.path.exists(configPath):
        with open(configPath, "r") as file:
            config = json.load(file)
            try:
                return config["baudrate"]
            except:
                print("Config file seems to be corrupted. Could not find the 'baudrate' attribute.")
                sys.exit()
    else:
        print("Config file does not exist")
        sys.exit()