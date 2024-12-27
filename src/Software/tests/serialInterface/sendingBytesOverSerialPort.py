import serial
from serial.tools import list_ports

BAUD_RATE = 9600
#BAUD_RATE = 4800
#BAUD_RATE = 460800

def listUsbSerialPorts():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    usbPorts = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
    return usbPorts

def getByteInput():
    """Prompts the user to enter a single byte in hex, binary, or decimal format."""
    while True:
        byteStr = input("Enter a byte (hex: 0xFF, binary: 0b10101010, decimal: 255) or 'q' to quit: ").strip()
        if byteStr.lower() == 'q':
            return None
        
        try:
            if byteStr.startswith('0x'):  # Hex input
                return int(byteStr, 16)
            elif byteStr.startswith('0b'):  # Binary input
                return int(byteStr, 2)
            else:  # Decimal input
                return int(byteStr)
        except ValueError:
            print("Invalid format. Please enter a valid byte.")

def getMultipleBytesInput():
    """Prompts the user to enter multiple bytes separated by spaces."""
    while True:
        byteStr = input("Enter multiple bytes (space-separated, e.g., 0xFF 255 0b10101010) or 'q' to quit: ").strip()
        if byteStr.lower() == 'q':
            return None
        
        byteList = []
        try:
            for part in byteStr.split():
                if part.startswith('0x'):
                    byteList.append(int(part, 16))
                elif part.startswith('0b'):
                    byteList.append(int(part, 2))
                else:
                    byteList.append(int(part))
            return byteList
        except ValueError:
            print("Invalid format. Please enter valid bytes.")

def main():
    # List available USB-to-serial ports
    ports = listUsbSerialPorts()
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

    selectedPort = ports[selection]
    print(f"Connected to {selectedPort}. Use Ctrl+C to exit.")

    # Open the selected serial port
    try:
        with serial.Serial(port=selectedPort, baudrate=BAUD_RATE, parity=serial.PARITY_ODD, timeout=1, stopbits=serial.STOPBITS_ONE_POINT_FIVE) as ser:
            while True:
                print("\nOptions:")
                print("1: Send a single byte")
                print("2: Send multiple bytes")
                print("q: Quit")
                option = input("Select an option: ").strip()

                if option == '1':
                    byteValue = getByteInput()
                    if byteValue is None:
                        print("Exiting single-byte input...")
                        continue
                    if 0 <= byteValue <= 255:
                        ser.write(byteValue.to_bytes(1, 'big'))
                        print(f"Sent: Hex: {hex(byteValue).upper()}, Binary: {bin(byteValue)[2:].zfill(8)}")
                    else:
                        print("Value out of range. Please enter a value between 0-255.")
                
                elif option == '2':
                    byteValues = getMultipleBytesInput()
                    if byteValues is None:
                        print("Exiting multi-byte input...")
                        continue
                    if all(0 <= val <= 255 for val in byteValues):
                        ser.write(bytes(byteValues))
                        print(f"Sent: {byteValues}")
                    else:
                        print("One or more values are out of range. Bytes must be between 0-255.")
                
                elif option.lower() == 'q':
                    print("Exiting...")
                    break
                else:
                    print("Invalid option. Please select 1, 2, or q.")

    except serial.SerialException as e:
        print(f"Error opening the serial port: {e}")
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()