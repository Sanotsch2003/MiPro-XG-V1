LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--Available Modes:

--0. Free-Running Mode (Continuous Counting)
--The timer continuously increments  without stopping.

--1. One-Shot Mode (Single-Shot)
--The timer counts to a specified value and then stops.

--2. Periodic Mode (Auto-Reload)
--The timer automatically resets and starts counting again after reaching the target value.
ENTITY hardwareTimer IS
    GENERIC (
        countWidth : INTEGER
    );
    PORT (
        enable : IN STD_LOGIC;
        reset  : IN STD_LOGIC;
        clk    : IN STD_LOGIC;

        prescaler : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mode      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        maxCount  : IN STD_LOGIC_VECTOR(countWidth - 1 DOWNTO 0);

        interruptClr : IN STD_LOGIC;

        --outputs 
        count     : OUT STD_LOGIC_VECTOR(countWidth - 1 DOWNTO 0);
        interrupt : OUT STD_LOGIC
    );
END hardwareTimer;

ARCHITECTURE Behavioral OF hardwareTimer IS
    SIGNAL countReg          : unsigned(countWidth - 1 DOWNTO 0);
    SIGNAL prescalerCountReg : unsigned(31 DOWNTO 0);
    SIGNAL interruptReg      : STD_LOGIC;

    SIGNAL previousModeReg  : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            countReg          <= (OTHERS => '0');
            interruptReg      <= '0';
            previousModeReg   <= (OTHERS => '0');
            prescalerCountReg <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN

                IF mode /= "00" THEN --Timer is disabled.      
                    prescalerCountReg <= prescalerCountReg + 1;
                    IF prescalerCountReg >= unsigned(prescaler) THEN
                        prescalerCountReg <= (OTHERS => '0');
                        CASE mode IS
                            WHEN "01" =>
                                countReg <= countReg + 1; --normal counting
                                IF countReg + 1 = 0 THEN  --check for overflow
                                    interruptReg <= '1';
                                END IF;
                            WHEN "10" =>
                                IF countReg < unsigned(maxCount) THEN
                                    countReg <= countReg + 1; --count unitl maxCount is reached
                                END IF;
                                IF countReg = unsigned(maxCount) - 1 THEN
                                    interruptReg <= '1';
                                END IF;
                            WHEN "11" =>
                                IF countReg < unsigned(maxCount) THEN
                                    countReg <= countReg + 1; --count unitl maxCount is reached
                                ELSE
                                    countReg     <= (OTHERS => '0');
                                    interruptReg <= '1';
                                END IF;
                            WHEN OTHERS =>
                                NULL;
                        END CASE;
                    END IF;
                END IF;
                --Reset count register when the count mode is updated.
                IF previousModeReg /= mode THEN
                    previousModeReg <= mode;
                    countReg        <= (OTHERS => '0');
                END IF;

                --Clear interrupt when the interrupt clr signal is high.
                IF interruptClr = '1' THEN
                    interruptReg <= '0';
                END IF;

            END IF;
        END IF;
    END PROCESS;

    count     <= STD_LOGIC_VECTOR(countReg);
    interrupt <= interruptReg;

END Behavioral;