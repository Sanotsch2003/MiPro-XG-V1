import serial
from serial.tools import list_ports

BAUD_RATE = 9600

def list_usb_serial_ports():
    """Lists available USB-to-serial ports."""
    ports = list_ports.comports()
    usb_ports = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
    return usb_ports

def get_byte_input():
    """Prompts the user to enter a single byte in hex, binary, or decimal format."""
    while True:
        byte_str = input("Enter a byte (hex: 0xFF, binary: 0b10101010, decimal: 255) or 'q' to quit: ").strip()
        if byte_str.lower() == 'q':
            return None
        
        try:
            if byte_str.startswith('0x'):  # Hex input
                return int(byte_str, 16)
            elif byte_str.startswith('0b'):  # Binary input
                return int(byte_str, 2)
            else:  # Decimal input
                return int(byte_str)
        except ValueError:
            print("Invalid format. Please enter a valid byte.")

def get_multiple_bytes_input():
    """Prompts the user to enter multiple bytes separated by spaces."""
    while True:
        byte_str = input("Enter multiple bytes (space-separated, e.g., 0xFF 255 0b10101010) or 'q' to quit: ").strip()
        if byte_str.lower() == 'q':
            return None
        
        byte_list = []
        try:
            for part in byte_str.split():
                if part.startswith('0x'):
                    byte_list.append(int(part, 16))
                elif part.startswith('0b'):
                    byte_list.append(int(part, 2))
                else:
                    byte_list.append(int(part))
            return byte_list
        except ValueError:
            print("Invalid format. Please enter valid bytes.")

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
    print(f"Connected to {selected_port}. Use Ctrl+C to exit.")

    # Open the selected serial port
    try:
        with serial.Serial(port=selected_port, baudrate=BAUD_RATE, timeout=1) as ser:
            while True:
                print("\nOptions:")
                print("1: Send a single byte")
                print("2: Send multiple bytes")
                print("q: Quit")
                option = input("Select an option: ").strip()

                if option == '1':
                    byte_value = get_byte_input()
                    if byte_value is None:
                        print("Exiting single-byte input...")
                        continue
                    if 0 <= byte_value <= 255:
                        ser.write(byte_value.to_bytes(1, 'big'))
                        print(f"Sent: Hex: {hex(byte_value).upper()}, Binary: {bin(byte_value)[2:].zfill(8)}")
                    else:
                        print("Value out of range. Please enter a value between 0-255.")
                
                elif option == '2':
                    byte_values = get_multiple_bytes_input()
                    if byte_values is None:
                        print("Exiting multi-byte input...")
                        continue
                    if all(0 <= val <= 255 for val in byte_values):
                        ser.write(bytes(byte_values))
                        print(f"Sent: {byte_values}")
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