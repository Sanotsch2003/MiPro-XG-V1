--This module generates a pulsing enable signal based on a prescaler. 
--The pulsing enable signal can be used to simulate a slower clock, if it is used as an enable signal in clocked processes.
--This module lets you also switch between an automatic and a manual clock mode.
--When the manual mode is active, you can use a button to generate clock pulses. This can be helpful for debugging purposes.
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clockController IS
    PORT (
        reset           : IN STD_LOGIC;
        clk             : IN STD_LOGIC;
        enable          : IN STD_LOGIC;
        manualClk       : IN STD_LOGIC;
        manualClocking  : IN STD_LOGIC;
        alteredClk      : OUT STD_LOGIC;
        programmingMode : IN STD_LOGIC;
        prescalerIn     : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END clockController;

ARCHITECTURE Behavioral OF clockController IS
    --siginals for automatic clocking
    SIGNAL alteredClkRegister  : STD_LOGIC;
    SIGNAL countCyclesRegister : unsigned(31 DOWNTO 0) := (OTHERS => '0');

    --signals for button edge detection, debouncing the button, and manual clocking
    CONSTANT debounceTime : INTEGER := 1000000; --10ms
    SIGNAL buttonDown     : STD_LOGIC;
    SIGNAL debounceCount  : unsigned(25 DOWNTO 0);
    SIGNAL buttonStable   : STD_LOGIC;

BEGIN

    --set custom clock signal
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            alteredClkRegister  <= '0';
            countCyclesRegister <= (OTHERS => '0');
            buttonDown          <= '0';
            buttonStable        <= '0';
            debounceCount       <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                alteredClkRegister <= '0';

                --While the processor is programmed, the clock frequency should not be altered.
                IF programmingMode = '1' THEN
                    alteredClkRegister <= '1';

                    --setting the alteredClkRegister to high when countCyclesRegister = prescalerIn-1
                ELSIF manualClocking = '0' THEN
                    countCyclesRegister <= countCyclesRegister + 1;
                    IF to_integer(countCyclesRegister) = to_integer(unsigned(prescalerIn)) THEN
                        alteredClkRegister  <= '1';
                        countCyclesRegister <= (OTHERS => '0');
                    END IF;
                ELSE
                    --setting the altered clock to high for one clock cycle when the manualClk button is pressed (debouncing the button is necessary)
                    IF manualClk = '1' AND buttonDown = '0' AND buttonStable = '1' THEN
                        alteredClkRegister <= '1'; --sending pulse
                        buttonDown         <= '1';
                        buttonStable       <= '0';
                    END IF;

                    IF buttonDown = '1' AND buttonStable = '0' THEN
                        IF debounceCount < debounceTime THEN
                            debounceCount <= debounceCount + 1;
                        ELSE
                            buttonStable  <= '1';
                            debounceCount <= (OTHERS => '0');
                        END IF;
                    END IF;

                    IF buttonDown = '1' AND buttonStable = '1' THEN
                        IF manualClk = '0' THEN
                            IF debounceCount < debounceTime THEN
                                debounceCount <= debounceCount + 1;
                            ELSE
                                buttonDown    <= '0';
                                debounceCount <= (OTHERS => '0');
                            END IF;
                        END IF;
                    END IF;

                    --last case: when buttonDown='0' and buttonStable='0' then buttonStable <= '1'
                    IF buttonDown = '0' AND buttonStable = '0' THEN
                        debounceCount <= (OTHERS => '0');
                        buttonStable  <= '1';
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    alteredClk <= alteredClkRegister;

END Behavioral;