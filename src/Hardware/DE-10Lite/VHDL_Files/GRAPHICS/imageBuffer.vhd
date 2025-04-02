LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Frame Buffer 0 local address range : 0x0000 - 0x257F
-- Frame Buffer 1 local address range : 0x2580 - 0x4AFF
-- Active Buffer address              : 0x4B00
-- V-Sync address                     : 0x4B01

ENTITY imageBuffer IS
    PORT (
        -- reset 
        reset : IN STD_LOGIC;
        -- System interface
        sysClk     : IN STD_LOGIC;
        writeEn    : IN STD_LOGIC;
        sysAddress : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        sysDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        sysDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- VGA Controller Interface (Read-Only)
        VGA_Clk       : IN STD_LOGIC;
        VGA_Address   : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        VGA_DataOut   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        V_Sync        : IN STD_LOGIC;
        currentBuffer : OUT STD_LOGIC
    );
END imageBuffer;

ARCHITECTURE Behavioral OF imageBuffer IS

    -- Declare a RAM array (Dual-Port Memory)
    TYPE ramType IS ARRAY (0 TO 32767) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL framebuffer : ramType;

    SIGNAL sysDataFromBuffer : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL currentBufferReg : STD_LOGIC;
BEGIN

    PROCESS (sysClk)
    BEGIN
        IF rising_edge(sysClk) THEN
            IF writeEn = '1' THEN
                framebuffer(to_integer(unsigned(sysAddress))) <= sysDataIn;
            END IF;
            sysDataFromBuffer <= framebuffer(to_integer(unsigned(sysAddress)));
        END IF;
    END PROCESS;

    PROCESS (VGA_Clk)
    BEGIN
        IF rising_edge(VGA_Clk) THEN
            VGA_DataOut <= framebuffer(to_integer(unsigned(VGA_Address)));
        END IF;
    END PROCESS;

    -- manage V-Sync signal
    PROCESS (sysDataFromBuffer, V_Sync, sysAddress, currentBufferReg)
    BEGIN
        sysDataOut <= (OTHERS => '0');
        IF to_integer(unsigned(sysAddress)) = 19200 THEN
            sysDataOut(0) <= currentBufferReg;
        ELSIF to_integer(unsigned(sysAddress)) = 19201 THEN
            sysDataOut(0) <= V_Sync;

        ELSE
            sysDataOut <= sysDataFromBuffer;
        END IF;
    END PROCESS;

    currentBuffer <= currentBufferReg;

    -- update currentBufferReg
    PROCESS (sysClk, reset)
    BEGIN
        IF reset = '1' THEN
            currentBufferReg <= '0';
        ELSIF rising_edge(sysClk) THEN
            IF writeEn = '1' AND to_integer(unsigned(sysAddress)) = 19200 THEN
                currentBufferReg <= sysDataIn(0);
            END IF;
        END IF;

    END PROCESS;

END Behavioral;