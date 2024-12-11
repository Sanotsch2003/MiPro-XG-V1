library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    generic(
        ramSize : integer := 2048
    );
    port (
        enable                     : in std_logic;
        clk                        : in std_logic;
        alteredClk                 : in std_logic;
        reset                      : in std_logic;
        address                    : in std_logic_vector(31 downto 0);
        data_in                    : in std_logic_vector(31 downto 0);
        data_out                   : out std_logic_vector(31 downto 0);
        write_enable               : in std_logic;
        read_enable                : in std_logic

    );
end RAM;

architecture Behavioral of RAM is
    
    type ram_type is array (0 to ramSize-1) of std_logic_vector(7 downto 0);
    signal ram : ram_type :=(
        others => (others => '0')
    );

    
begin

    process(clk, reset) 
    begin 
        if rising_edge(clk) then 
            data_out <= (others => '0');
            if enable = '1' then
                if alteredClk = '1' then

                    if read_enable = '1' then
                        for i in 0 to 3 loop
                            data_out((i+1)*8-1 downto i*8) <= ram(to_integer(unsigned(address))+i);
                        end loop;

                    elsif write_enable = '1' then
                        for i in 0 to 3 loop
                            ram(to_integer(unsigned(address))+i) <= data_in((4-i)*8-1 downto (3-i)*8);
                        end loop;
                    end if;
                end if;
            end if;

        end if;

    end process;

end Behavioral;