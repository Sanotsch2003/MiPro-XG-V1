from serial.tools import list_ports

def listUsbSerialPorts():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    usbPorts = [port.device for port in ports if 'USB' in str(port.device)]
    if not usbPorts:
            print("No USB serial ports found.")
    else:
        for i, port in enumerate(usbPorts):
            print(f"{i}: {port}")