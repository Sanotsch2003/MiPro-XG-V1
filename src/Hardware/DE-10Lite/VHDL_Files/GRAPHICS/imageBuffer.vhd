LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY VGA_ImageBuffer IS
    PORT (
        -- System interface
        sysClk     : IN STD_LOGIC;
        writeEn    : IN STD_LOGIC;
        sysAddress : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        sysDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sysDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- VGA Controller Interface (Read-Only)
        VGA_Clk     : IN STD_LOGIC;
        VGA_Address : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        VGA_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END VGA_ImageBuffer;

ARCHITECTURE Behavioral OF VGA_ImageBuffer IS

    -- Declare a RAM array (Dual-Port Memory)
    TYPE ramType IS ARRAY (0 TO 16383) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL framebuffer : ramType;

BEGIN

    PROCESS (sysClk)
    BEGIN
        IF rising_edge(sysClk) THEN
            IF writeEn = '1' THEN
                framebuffer(to_integer(unsigned(sysAddress))) <= sysDataIn;
            END IF;
            sysDataOut <= framebuffer(to_integer(unsigned(sysAddress)));
        END IF;
    END PROCESS;

    PROCESS (VGA_Clk)
    BEGIN
        IF rising_edge(VGA_Clk) THEN
            VGA_DataOut <= framebuffer(to_integer(unsigned(VGA_Address)));
        END IF;
    END PROCESS;

END Behavioral;