--16 General Purpose Registers
--each bit of loadRegistersSel corresponds to a register.
--if loadRegistersSel(i) = '1' then dataIn is loaded into register i
--dataOut is the concatenation of all registers and is managed by BusConnections
--registers are reset to 0 when reset is high
--registers are updated on the rising edge of the clock if enable is high

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY registerFile IS
    PORT (
        enable     : IN STD_LOGIC;
        reset      : IN STD_LOGIC;
        clk        : IN STD_LOGIC;
        alteredClk : IN STD_LOGIC;

        dataIn           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        loadRegistersSel : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataOut          : OUT STD_LOGIC_VECTOR(16 * 32 - 1 DOWNTO 0);

        createLink : IN STD_LOGIC
    );
END registerFile;

ARCHITECTURE Behavioral OF registerFile IS
    TYPE register_array IS ARRAY (0 TO 16 - 1) OF STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
    SIGNAL registers : register_array :=
    (--15 => "00000000000000000000000000000100",
    OTHERS => (OTHERS => '0'));
    SIGNAL registerOutputs : STD_LOGIC_VECTOR(16 * 32 - 1 DOWNTO 0);
BEGIN
    --concatenating the registers to dataOut
    PROCESS (registers)
    BEGIN
        FOR i IN 0 TO 16 - 1 LOOP
            registerOutputs((i + 1) * 32 - 1 DOWNTO i * 32) <= registers(i);
        END LOOP;
    END PROCESS;

    --sequential logic for the registers (loading and resetting)
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            FOR i IN 0 TO 16 - 1 LOOP
                registers(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                IF alteredClk = '1' THEN
                    FOR i IN 0 TO 16 - 1 LOOP
                        IF loadRegistersSel(i) = '1' THEN
                            registers(i) <= dataIn;
                        END IF;
                    END LOOP;
                    IF createLink = '1' THEN
                        --save PC in Link Register
                        registers(13) <= STD_LOGIC_VECTOR(unsigned(registers(15)) + 4);
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    dataOut <= registerOutputs;

END Behavioral;