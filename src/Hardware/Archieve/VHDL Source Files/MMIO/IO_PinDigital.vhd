LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY IO_PinDigital IS
    PORT (
        --clk          : IN STD_LOGIC;
        pin          : INOUT STD_LOGIC;
        dutyCycle    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        mode         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        dataIn       : IN STD_LOGIC;
        dataOut      : OUT STD_LOGIC;
        count        : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        --interrupt    : OUT STD_LOGIC;
        --interruptClr : IN STD_LOGIC;
    );
END IO_PinDigital;

ARCHITECTURE Behavioral OF IO_PinDigital IS
    SIGNAL pinMode       : STD_LOGIC_VECTOR(1 DOWNTO 0);
    --SIGNAL interruptMode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL pinData       : STD_LOGIC;
    --SIGNAL prevPinData   : STD_LOGIC;
BEGIN

    --interruptMode <= mode(4 DOWNTO 2);
    pinMode       <= mode(1 DOWNTO 0);
    dataOut       <= pinData;
    --Setting output PIN.
    PROCESS (pinMode, pin, dataIn, count, dutyCycle)
    BEGIN
        pinData <= '0';
        CASE pinMode IS
            WHEN "00" => -- Output mode
                pin <= dataIn;

            WHEN "01" => -- Input mode
                pin     <= 'Z';
                pinData <= pin;

            WHEN "10" => -- PWM mode
                IF unsigned(count) < unsigned(dutyCycle) THEN
                    pin <= '1';
                ELSE
                    pin <= '0';
                END IF;

            WHEN OTHERS =>
                pin <= 'Z';
        END CASE;
    END PROCESS;

--    --Triggering interrupts
--    PROCESS (clk)
--    BEGIN
--        IF rising_edge(clk) THEN
--            IF pinMode = "01" THEN --interrupts can only be triggered in input mode
--                prevPinData <= pinData;
--                CASE interruptMode IS

--                    WHEN 

--                    WHEN

--                END CASE;
--            END IF;
--        END IF;
--    END PROCESS;
END Behavioral;