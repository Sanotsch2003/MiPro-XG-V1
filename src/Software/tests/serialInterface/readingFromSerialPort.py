import serial
from serial.tools import list_ports

def list_usb_serial_ports():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    usb_ports = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
    return usb_ports

def main():
    # List available USB-to-serial ports
    ports = list_usb_serial_ports()
    if not ports:
        print("No USB-to-serial devices found.")
        return

    # Display the ports and let the user select one
    print("Available USB-to-Serial Ports:")
    for i, port in enumerate(ports):
        print(f"{i}: {port}")
    
    try:
        selection = int(input("Select a port by number: "))
        if selection < 0 or selection >= len(ports):
            print("Invalid selection.")
            return
    except ValueError:
        print("Invalid input. Please enter a number.")
        return

    selected_port = ports[selection]
    print(f"Listening on {selected_port}...")

    # Open the selected serial port
    try:
        with serial.Serial(port=selected_port, baudrate=9600, timeout=1) as ser:
            print("Listening for incoming bytes (press Ctrl+C to stop):")
            while True:
                data = ser.read()  # Read one byte
                if data:
                    byte_value = int.from_bytes(data, byteorder='big')
                    print(f"Hex: {data.hex().upper()}, Binary: {bin(byte_value)[2:].zfill(8)}")
    except serial.SerialException as e:
        print(f"Error opening the serial port: {e}")
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()
