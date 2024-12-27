from serial.tools import list_ports
import serial
import os
import sys

def program(filepath, portNumber, baudrate):
    # Ensure the file exists
    if not os.path.isfile(filepath):
        raise FileNotFoundError(f"The file '{filepath}' does not exist.")
    
    ports = list_ports.comports()
    usbPorts = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
    port = usbPorts[portNumber]
    # Open the serial port
    with serial.Serial(port, baudrate, timeout=1, parity=serial.PARITY_ODD) as ser:
        print(f"Opened serial port: {port} at {baudrate} baud")

        # Open the binary file for reading
        with open(filepath, "rb") as f:
            while True:
                # Read 4 bytes from the file
                data = f.read(4)

                if not data:
                    # End of file
                    print("Transmission complete.")
                    break

                # Ensure the data is exactly 4 bytes (pad with zeros if necessary)
                while len(data) < 4:
                    data += b'\x00'

                # Keep sending the data until acknowledged
                while True:
                    # Send the 4 bytes over the serial port
                    ser.write(data)
                    print(f"Sent: {data.hex()}")

                    # Wait for a response
                    retries = 0
                    max_retries = 5
                    while retries < max_retries:
                        response = ser.read(1)
                        if response:
                            break
                        print("No response received, retrying...")
                        retries += 1
                    if retries == max_retries:
                        print("Maximum retries reached. Aborting transmission.")
                        sys.exit()
                    print(response)
                    # Count the number of ones in the response byte
                    onesCount = bin(response[0]).count('1')

                    if onesCount >= 4:
                        print(f"Acknowledged (ones count = {onesCount}). Proceeding to next 4 bytes.")
                        break  # Break the resend loop
                    else:
                        print(f"NACK (ones count = {onesCount}). Resending...")

