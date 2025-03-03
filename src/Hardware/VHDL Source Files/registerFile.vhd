--16 General Purpose Registers
--each bit of loadRegistersSel corresponds to a register.
--if loadRegistersSel(i) = '1' then dataIn is loaded into register i
--dataOut is the concatenation of all registers and is managed by BusConnections
--registers are reset to 0 when reset is high
--registers are updated on the rising edge of the clock if enable is high

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
    port(
        enable           : in std_logic;
        reset            : in std_logic;
        clk              : in std_logic;
        alteredClk       : in std_logic;

        dataIn           : in std_logic_vector(31 downto 0);
        loadRegistersSel : in std_logic_vector(15 downto 0);
        dataOut          : out std_logic_vector(16 * 32-1 downto 0);
        
        createLink       : in std_logic
    );
end registerFile;

architecture Behavioral of registerFile is
    type register_array is array (0 to 16-1) of std_logic_vector(32-1 downto 0);
    signal registers        : register_array := 
    (   --15 => "00000000000000000000000000000100",
        others=>(others=>'0'));
    signal registerOutputs : std_logic_vector(16 * 32-1 downto 0);
begin
    --concatenating the registers to dataOut
    process(registers)
    begin
        for i in 0 to 16-1 loop
            registerOutputs((i+1)*32-1 downto i*32) <= registers(i);
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
                if alteredClk = '1' then
                    for i in 0 to 16-1 loop
                        if loadRegistersSel(i) = '1' then
                            registers(i) <= dataIn;
                        end if;
                    end loop;
                    if createLink = '1' then
                        --save PC in Link Register
                        registers(13) <= std_logic_vector(unsigned(registers(15)) + 4);
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    dataOut <= registerOutputs;

end Behavioral;
