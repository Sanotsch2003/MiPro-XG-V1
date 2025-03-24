LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY busManagement IS
    PORT (
        dataFromRegisters          : IN STD_LOGIC_VECTOR(16 * 32 - 1 DOWNTO 0);
        dataFromCU                 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataFromALU                : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataFromMem                : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        bitManipulationValueFromCU : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        operand1              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        operand2              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataToMem             : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bitManipulationValOut : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

        operand1Sel           : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        operand2Sel           : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        dataToMemSel          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        bitManipulationValSel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        dataToRegisters       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataToRegistersSel    : IN STD_LOGIC
    );
END busManagement;

ARCHITECTURE Behavioral OF busManagement IS

BEGIN
    --multiplexer for managing operand signals
    PROCESS (dataFromRegisters, dataFromCU, operand1Sel, operand2Sel, dataToMemSel)
        VARIABLE i : INTEGER;
    BEGIN
        --operand 1
        IF operand1Sel(4) = '0' THEN--check if signal is in range 0-15
            i := to_integer(unsigned(operand1Sel(3 DOWNTO 0)));
            operand1 <= dataFromRegisters((i + 1) * 32 - 1 DOWNTO i * 32);
        ELSIF operand1Sel = "10000" THEN --sel signal for loading dataFromCU
            operand1 <= dataFromCU;
        ELSE
            operand1 <= (OTHERS => '0');
        END IF;

        --operand 2
        IF operand2Sel(4) = '0' THEN--check if signal is in range 0-15
            i := to_integer(unsigned(operand2Sel(3 DOWNTO 0)));
            operand2 <= dataFromRegisters((i + 1) * 32 - 1 DOWNTO i * 32);
        ELSIF operand2Sel = "10000" THEN --sel signal for loading dataFromCU
            operand2 <= dataFromCU;
        ELSE
            operand2 <= (OTHERS => '0');
        END IF;

        --dataToMem
        i := to_integer(unsigned(dataToMemSel(3 DOWNTO 0)));
        dataToMem <= dataFromRegisters((i + 1) * 32 - 1 DOWNTO i * 32);

    END PROCESS;

    --multiplexer for managing the data flowing to the register file
    PROCESS (dataFromALU, dataFromMem, dataToRegistersSel)
    BEGIN
        IF dataToRegistersSel = '0' THEN
            dataToRegisters <= dataFromALU;
        ELSIF dataToRegistersSel = '1' THEN
            dataToRegisters <= dataFromMem;
        ELSE
            dataToRegisters <= (OTHERS => '0');
        END IF;
    END PROCESS;

    --multiplexer for managing bit manipulation value
    PROCESS (dataFromRegisters, bitManipulationValueFromCU, bitManipulationValSel)
        VARIABLE i : INTEGER;
    BEGIN
        IF bitManipulationValSel(4) = '0' THEN
            i := to_integer(unsigned(bitManipulationValSel(3 DOWNTO 0)));
            bitManipulationValOut <= dataFromRegisters((i + 1) * 32 - 28 DOWNTO i * 32);
        ELSIF bitManipulationValSel = "10000" THEN
            bitManipulationValOut <= bitManipulationValueFromCU;
        ELSE
            bitManipulationValOut <= (OTHERS => '0');
        END IF;

    END PROCESS;

END Behavioral;