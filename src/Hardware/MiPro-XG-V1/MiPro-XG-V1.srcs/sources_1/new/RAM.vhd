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
        dataIn                     : in std_logic_vector(31 downto 0);
        dataOut                    : out std_logic_vector(31 downto 0);
        writeEn                    : in std_logic;
        readEn                     : in std_logic;
        memOpFinished              : out std_logic
    );
end RAM;

architecture Behavioral of RAM is
    
    type ram_type is array (0 to ramSize-1) of std_logic_vector(7 downto 0);
    signal ram : ram_type :=(
        0 => "11111101",
        1 => "11000000",
        2 => "00000001",
        3 => "01010000",
        4 => "11111101",
        5 => "10000111",
        6 => "11000010",
        7 => "00000000",
        8 => "11111101",
        9 => "10011110",
        10 => "11100000",
        11 => "00000111",
        12 => "11111101",
        13 => "11011111",
        14 => "11111111",
        15 => "11101100",
        others => (others => '0')
    );

    
begin

    process(clk, reset) 
    begin 
        if rising_edge(clk) then 
            dataOut <= (others => '0');
            memOpFinished <= '0';
            if enable = '1' then
                if alteredClk = '1' then

                    if readEn = '1' then
                        for i in 0 to 3 loop
                            dataOut((i+1)*8-1 downto i*8) <= ram(to_integer(unsigned(address))+3-i);
                            memOpFinished <= '1';
                        end loop;

                    elsif writeEn = '1' then
                        for i in 0 to 3 loop
                            ram(to_integer(unsigned(address))+i) <= dataIn((4-i)*8-1 downto (3-i)*8);
                            memOpFinished <= '1';
                        end loop;
                    end if;
                end if;
            end if;

        end if;

    end process;

end Behavioral;