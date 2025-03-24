LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
    GENERIC (
        ramSize : INTEGER
    );
    PORT (
        clk           : IN STD_LOGIC;
        reset         : IN STD_LOGIC;
        address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataIn        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataOut       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeEn       : IN STD_LOGIC;
        readEn        : IN STD_LOGIC;
        memOpFinished : OUT STD_LOGIC
    );
END RAM;

ARCHITECTURE Behavioral OF RAM IS
    SIGNAL count : unsigned(5 DOWNTO 0);
    TYPE ram_type IS ARRAY (0 TO ramSize - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	 signal ram : ram_type;
--    signal ram : ram_type :=(
--        0 => "11110110110000000000000000001000",
--        1 => "11111101110000000000000000000000",
--        2 => "11111101111100000000000000001100",
--        3 => "11111001000000000000110000000000",
--        4 => "11111101110111111111111111100001",
--        5 => "11111101111111111111111111101100",
--        6 => "11111001000000000000110000010001",
--        7 => "11110000100000000000000000000001",
--        8 => "11110100001000000000000000000000",
--        9 => "11111101110000000000000000000000",
--        10 => "11111101111100000000000000001100",
--        11 => "11111001000000000000110000000000",
--        12 => "11111101110111111111111111100001",
--        13 => "11111101110100101100000000000010",
--        14 => "11111011100000000000001000000010",
--        15 => "11110000100000000000000000000001",
--        16 => "11111011110000000000000001000000",
--        17 => "11111010101000000000000000100000",
--        18 => "00010110011000000000000000000100",
--        19 => "11111101100000000000000110101111",
--        others => (others => '0')
--    );

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF rising_edge(clk) THEN
            --if alteredClk = '1' then
            IF writeEn = '1' THEN
                -- Write data to RAM
                RAM(to_integer(unsigned(address))) <= dataIn;
            END IF;	
				dataOut <= RAM(to_integer(unsigned(address)));
        END IF;

    END PROCESS;

    --Setting the memOpFinished signal.
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            count         <= (OTHERS => '0');
            memOpFinished <= '0';
        ELSIF rising_edge(clk) THEN
            IF writeEn = '1' OR readEn = '1' THEN
                count <= count + 1;
                IF count >= 1 THEN
                    memOpFinished <= '1';
                END IF;
            ELSE
                memOpFinished <= '0';
                count         <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

END Behavioral;