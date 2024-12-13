library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity busManagement is
  Port ( 
        dataFromRegisters   : in std_logic_vector(16 * 32-1 downto 0);
        dataFromCU          : in std_logic_vector(31 downto 0);
        dataFromALU         : in std_logic_vector(31 downto 0);
        dataFromMem         : in std_logic_vector(31 downto 0);

        operand1            : out std_logic_vector(31 downto 0);
        operand2            : out std_logic_vector(31 downto 0);
        dataToMem           : out std_logic_vector(31 downto 0);

        operand1Sel         : in std_logic_vector(4 downto 0);
        operand2Sel         : in std_logic_vector(4 downto 0); 
        dataToMemSel        : in std_logic_vector(3 downto 0);

        dataToRegisters     : out std_logic_vector(31 downto 0);

        dataToRegistersSel  : in std_logic
  );
end busManagement;

architecture Behavioral of busManagement is

begin
    --multiplexer for managing operand signals
    process(dataFromRegisters, dataFromCU, operand1Sel, operand2Sel)
    variable i : integer;
    begin
        --operand 1
        if operand1Sel(4) = '0' then--check if signal is in range 0-15
            i := to_integer(unsigned(operand1Sel(3 downto 0)));
            operand1 <= dataFromRegisters((i+1)*32-1 downto i*32);
        elsif operand1Sel = "10000" then --sel signal for loading dataFromCU
            operand1 <= dataFromCU;
        else
            operand1 <= (others => '0');
        end if;

        --operand 2
        if operand2Sel(4) = '0' then--check if signal is in range 0-15
            i := to_integer(unsigned(operand2Sel(3 downto 0)));
            operand2 <= dataFromRegisters((i+1)*32-1 downto i*32);
        elsif operand2Sel = "10000" then --sel signal for loading dataFromCU
            operand2 <= dataFromCU;
        else
            operand2 <= (others => '0');
        end if;

        --dataToMem
        i := to_integer(unsigned(dataToMemSel(3 downto 0)));
        dataToMem <= dataFromRegisters((i+1)*32-1 downto i*32);

    end process;

    --multiplexer for managing the data flowing to the register file
    process(dataFromALU, dataFromMem, dataToRegistersSel)
    begin
        if dataToRegistersSel = '0' then
            dataToRegisters <= dataFromALU;
        elsif dataToRegistersSel = '1' then
            dataToRegisters <= dataFromMem;
        else
            dataToRegisters <= (others => '0');
        end if;
    end process;
    
end Behavioral;