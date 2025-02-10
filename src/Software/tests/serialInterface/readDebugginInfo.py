import serial
from serial.tools import list_ports
import threading
import time
import os
import sys

class SerialReader:
    DEBUG_DELIMITER = "11111111"
    def __init__(self):
        self.serial_port = None
        self.read_thread = None
        self.stop_event = threading.Event()
        self.is_connected = False

    def connect(self, port, sharedDict, baudrate=9600):
        """Connect to the serial port and start the reader thread."""
        if self.read_thread and self.read_thread.is_alive():
            print("Already connected. Ignoring duplicate connection request.")
            return  # Prevent duplicate threads

        try:
            self.serial_port = serial.Serial(port, baudrate, timeout=1)
            self.is_connected = True
            print(f"Connected to {port}")

            # Pass the shared dictionary to the thread
            self.stop_event.clear()
            self.read_thread = threading.Thread(
                target=self.read_serial, args=(sharedDict,), daemon=True
            )
            self.read_thread.start()

        except serial.SerialException as e:
            print(f"Error connecting to serial port: {e}")
            self.is_connected = False

    def disconnect(self):
        """Stop the reader thread and close the serial connection."""
        if self.is_connected:
            print("Disconnecting...")
            self.stop_event.set()
            if self.read_thread:
                self.read_thread.join()
            if self.serial_port:
                self.serial_port.close()
                self.serial_port = None
            self.is_connected = False
            print("Disconnected successfully.")

    def read_serial(self, sharedDict):
        byteSinceReset = 0
        dictLen = len(sharedDict)
        while not self.stop_event.is_set():
            try:
               if self.serial_port.in_waiting > 0:
                # Read exactly one byte
                byte = self.serial_port.read(1)  # Reads 1 byte
                if byte:  # Ensure the byte is not empty
                    binary_string = format(ord(byte), '08b')  # Decode the byte to a string
                    #print(binary_string)
                    # Check for the DEBUG_DELIMITER
                    if binary_string == self.DEBUG_DELIMITER:
                        byteSinceReset = 0
                    else:
                        # Insert data into the shared dictionary
                        for i in range(7):
                            index = byteSinceReset*7+i
                            if index < dictLen:
                                sharedDict[index] = binary_string[6-i]
                                #sharedDict[index] = index
                        byteSinceReset += 1  # Increment byte counter

                else:
                    print("Serial port buffer is empty. Waiting...")
                
            except (serial.SerialException, OSError):
                print("Connection lost. Attempting to reconnect...")
                self.is_connected = False
                self.reconnect()

    def reconnect(self):
        """Attempt to reconnect to the serial port."""
        while not self.is_connected and not self.stop_event.is_set():
            try:
                print("Reconnecting...")
                self.serial_port.open()
                self.is_connected = True
                print("Reconnected successfully.")
            except Exception:
                print("Reconnect failed. Retrying in 2 seconds...")
                time.sleep(2)

    def getSerialPorts(self):
        ports = list_ports.comports()
        usb_ports = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
        return usb_ports

# Simulate usage
if __name__ == "__main__":
    sr = SerialReader()
    print(os.name)
    # Shared dictionary to hold serial data

    ports = sr.getSerialPorts()
    if not ports:
        print("No USB-to-serial devices found.")
        sys.exit()

    # Display the ports and let the user select one
    while True:
        print("Available USB-to-Serial Ports:")
        for i, port in enumerate(ports):
            print(f"{i}: {port}")
        
        try:
            selection = int(input("Select a port by number: "))
            if selection < 0 or selection >= len(ports):
                print("Invalid selection.")
            else:
                break
        except ValueError:
            print("Invalid input. Please enter a number.")
            break

    port = ports[selection]
<<<<<<< HEAD
    sharedData = [0 for i in range(14)]
=======
    sharedData = [0 for i in range(800)]
>>>>>>> master
    sr.connect(port, sharedData)

    # Simulate the main program reading the shared dictionary
    while True:
        string = ""
        for i in range(len(sharedData)):
            string = string + str(sharedData[i])

        os.system('cls' if os.name == 'nt' else 'clear')
        print(sharedData)
        time.sleep(0.01)


