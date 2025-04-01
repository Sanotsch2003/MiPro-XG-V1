LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY IO_PinDigital IS
    PORT (
        clk       : IN STD_LOGIC;
        enable    : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        pin       : INOUT STD_LOGIC;
        dutyCycle : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        mode      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        dataIn    : IN STD_LOGIC;
        dataOut   : OUT STD_LOGIC;
        count     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        debug     : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
    );
END IO_PinDigital;

ARCHITECTURE Behavioral OF IO_PinDigital IS
    SIGNAL pinMode : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL pinData : STD_LOGIC;

    -- debug signals
    SIGNAL pinModeDebug      : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL pinDataDebug      : STD_LOGIC;
    SIGNAL pinDutyCycleDebug : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    pinMode <= mode;
    dataOut <= pinData;

    -- connect debug signals
    pinModeDebug      <= mode;
    pinDutyCycleDebug <= dutyCycle;

    --Setting output PIN.
    PROCESS (pinMode, pin, dataIn, count, dutyCycle)
    BEGIN
        pinData      <= '0';
        pinDataDebug <= '0';
        CASE pinMode IS
            WHEN "00" => -- Output mode
                pin          <= dataIn;
                pinDataDebug <= dataIn;

            WHEN "01" => -- Input mode
                pin          <= 'Z';
                pinData      <= pin;
                pinDataDebug <= pin;

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

    -- update debug signals
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            debug <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                debug <= pinModeDebug & pinDataDebug & pinDutyCycleDebug;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;