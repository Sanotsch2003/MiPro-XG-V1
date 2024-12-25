def main():
    import sys
    from mipro_toolkit.Assembler.assembler import assemble
    from mipro_toolkit.Programmer.programmer import program

    if len(sys.argv) < 2:
        print("Usage: mipro <command> [options]")
        print("Commands:")
        print("  assemble <filename>  Assemble the given file.")
        print("  program <filename>   Program the given file.")
        sys.exit(1)

    command = sys.argv[1]
    if command == "assemble":
        if len(sys.argv) < 3:
            print("Error: Missing filename for assemble command.")
            sys.exit(1)
        assemble(sys.argv[2])
    elif command == "program":
        if len(sys.argv) < 3:
            print("Error: Missing filename for program command.")
            sys.exit(1)
        program(sys.argv[2])
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
