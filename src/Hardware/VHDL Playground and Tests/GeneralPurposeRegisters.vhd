--16 General Purpose Registers
--each bit of load_reg_en corresponds to a register.
--if load_reg_en(i) = '1' then data_in is loaded into register i
--data_out is the concatenation of all registers and is managed by BusConnections
--registers are reset to 0 when reset is high
--registers are updated on the rising edge of the clock if enable is high

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GeneralPurposeRegisters is
    port(
        enable           : in std_logic;
        reset            : in std_logic;
        clk              : in std_logic;
        data_in          : in std_logic_vector(32-1 downto 0);
        data_out         : out std_logic_vector(16 * 32-1 downto 0);
        load_reg_en      : in std_logic_vector(16-1 downto 0);
        increment_PC_en  : in std_logic; --Register 15 is used as the program counter
        Increment_PC_val : in std_logic_vector(31 downto 0)
    );
end GeneralPurposeRegisters;

architecture Behavioral of GeneralPurposeRegisters is
    type register_array is array (0 to 16-1) of std_logic_vector(32-1 downto 0);
    signal registers     : register_array := (1 => "00000000000000000000000000010000",
                                              15 => "00000000000000000000000000000001",
                                              others=>(others=>'0'));
begin
    --concatenating the registers to data_out
    process(registers)
    begin
        for i in 0 to 16-1 loop
            data_out((i+1)*32-1 downto i*32) <= registers(i);
        end loop;
    end process;
    
    --sequential logic for the registers (loading and resetting)
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 0 to 16-1 loop
                registers(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if enable = '1' then
                for i in 0 to 16-1 loop
                    if load_reg_en(i) = '1' then
                        registers(i) <= data_in;
                    end if;
                end loop;
                if increment_PC_en = '1' then
                    registers(15) <= std_logic_vector(signed(registers(15)) + signed(Increment_PC_val));
                end if;
            end if;
        end if;
    end process;
        
end Behavioral;
