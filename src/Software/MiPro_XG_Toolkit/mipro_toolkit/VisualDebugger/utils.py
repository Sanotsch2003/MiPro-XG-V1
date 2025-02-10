from serial.tools import list_ports

def listUSBSerialPorts():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    usb_ports = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
    return usb_ports