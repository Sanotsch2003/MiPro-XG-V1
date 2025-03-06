import argparse
import os
from mipro_toolkit.Assembler.assembler import assemble
from mipro_toolkit.Programmer.programmer import program
from mipro_toolkit.Utils.utils import listUsbSerialPorts, setBaudrate, getBaudrate
from mipro_toolkit.VisualDebugger.debugger import debug
import json

scriptDir = os.path.dirname(os.path.abspath(__file__))
configPath = os.path.join(scriptDir, "config.json")


def main():
    # Create the main parser
    parser = argparse.ArgumentParser(
        description="MiPro Toolkit: Assemble and Program your files."
    )

    # Add subparsers for commands
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Subparser for 'assemble'
    assembleParser = subparsers.add_parser(
        "assemble", help="Assemble the given file."
    )
    assembleParser.add_argument(
        "filename", type=str, help="Path to the file to assemble."
    )
    assembleParser.add_argument(
        "-c", "--createVHDL_memoryFile",
        action="store_true",
        help="Flag to create VHDL code for a pre-initialized memory containing the assembled machine instructions."
    )

    # Subparser for 'program'
    programParser = subparsers.add_parser(
        "program", help="Upload given program to processor."
    )
    programParser.add_argument(
        "filename", type=str, help="Path to the file to program."
    )
    programParser.add_argument(
        "-p", "--port",
        type=int,
        default = 0,
        help="Specify port for data transmission. Use 'list-ports' to show a list of available serial ports."
    )

    # Subparser for 'list-ports'
    listPortsParser = subparsers.add_parser(
        "list-ports", help="List available USB serial ports."
    )

    # Subparser for 'debug'
    debugParser = subparsers.add_parser(
        "debug", help="Opens the visual debugger."
    )

    # Subparser for 'set-baudrate'
    baudrate_parser = subparsers.add_parser(
    "set-baudrate", help="Sets the baud rate for the system."
    )

    # Add an argument to 'set-baudrate' for specifying the baud rate
    baudrate_parser.add_argument(
        "baudrate", type=int, help="The baud rate value to set."
    )

    # Subparser for 'show-config'
    debugParser = subparsers.add_parser(
        "show-config", help="Shows configuration Details."
    )

    # Parse the arguments
    args = parser.parse_args()

    # Handle subcommands
    if args.command == "assemble":
        absolute_path = os.path.abspath(args.filename)
        assemble(absolute_path, args.createVHDL_memoryFile)
    elif args.command == "program":
        absolute_path = os.path.abspath(args.filename)
        program(absolute_path, args.port, getBaudrate())
    elif args.command == "list-ports":
        listUsbSerialPorts()
    elif args.command == "debug":
        debug(getBaudrate())
    elif args.command == "set-baudrate":
        setBaudrate(args.baudrate)
    elif args.command == "show-config":
        print(f"Configured Baudrate: {getBaudrate()}.")


if __name__ == "__main__":
    main()