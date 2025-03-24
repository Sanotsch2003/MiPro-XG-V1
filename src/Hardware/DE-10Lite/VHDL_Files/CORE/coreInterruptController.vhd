LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY coreInterruptController IS
    GENERIC (
        numInterrupts : INTEGER := 10
    );
    PORT (
        clk        : IN STD_LOGIC;
        interrupts : IN STD_LOGIC_VECTOR(numInterrupts - 1 DOWNTO 0);

        IVT_in : IN STD_LOGIC_VECTOR(32 * numInterrupts - 1 DOWNTO 0);
        IPR_in : IN STD_LOGIC_VECTOR(3 * numInterrupts - 1 DOWNTO 0);

        interruptIndex          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        interruptHandlerAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END coreInterruptController;

ARCHITECTURE Behavioral OF coreInterruptController IS

BEGIN

    --Getting the right interrupt handler address based on current interrupt signals.
    PROCESS (clk)
        VARIABLE currentMaxPriorityLevel : INTEGER := 0;
    BEGIN
        IF rising_edge(clk) THEN
            --By default the output will be 0 which signals the control unit that no interrupt has occurred.
            interruptHandlerAddress <= (OTHERS => '0');
            interruptIndex          <= (OTHERS => '0');

            currentMaxPriorityLevel := 0;
            FOR i IN 0 TO numInterrupts - 1 LOOP
                --check if interrupt signals are set
                IF interrupts(i) = '1' THEN
                    --check if this interrupt has the highest priority level so far and set the output if true
                    IF unsigned(IPR_in((i + 1) * 3 - 1 DOWNTO i * 3)) > currentMaxPriorityLevel THEN
                        interruptHandlerAddress <= IVT_in((i + 1) * 32 - 1 DOWNTO i * 32);
                        interruptIndex          <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
                        currentMaxPriorityLevel := to_integer(unsigned(IPR_in((i + 1) * 3 - 1 DOWNTO i * 3)));
                    END IF;
                END IF;
            END LOOP;
        END IF;
    END PROCESS;

END Behavioral;