from serial.tools import list_ports
import serial
import time


def listen(portNumber, baudrate):
    ports = list_ports.comports()
    usbPorts = [port.device for port in ports if 'USB' in str(port.device)]
    if len(usbPorts) == 0:
        print("No Devices found.")
        sys.exit()
    try:
        port = usbPorts[portNumber]
    except:
        print("Please provide a valid port index.")
        sys.exit()
    try:
        with serial.Serial(port, baudrate, timeout=1) as ser:
            print(f"Listening on {port} at {baudrate} baud...\nPress Ctrl+C to stop.")
            while True:
                if ser.in_waiting > 0:
                    line = ser.readline().decode('utf-8', errors='ignore').strip()
                    if line:
                        print(f"> {line}")
                time.sleep(0.05)  # Slight delay to avoid CPU overuse
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except KeyboardInterrupt:
        print("\nStopped by user.")
    except Exception as e:
        print(f"Unexpected error: {e}")

