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
    
    type ram_type is array (0 to ramSize-1) of std_logic_vector(31 downto 0);
    signal ram : ram_type :=(
        0 => "11111101110000000000101000000000",
        1 => "11111101111010000000000000001100",
        2 => "11111001000000000000110000000000",
        3 => "11111101110001001000010001100111",
        4 => "11111101111000000001111010001100",
        5 => "11111001000000000000110001110111",
        6 => "11110000110000000000000000000111",
        7 => "11111101110000000000101010000000",
        8 => "11111101111010000000000000001100",
        9 => "11111001000000000000110000000000",
        10 => "11111101110000000000111101100111",
        11 => "11110000110000000000000000000111",
        others => (others => '0')
    );
  
begin
    process(clk, reset) 
    begin 
        if reset = '1' then
            dataOut <= (others => '0');
            memOpFinished <= '0';
        elsif rising_edge(clk) then 
            dataOut <= (others => '0');
            memOpFinished <= '0';
            if enable = '1' then
                if readEn = '1' then
                    dataOut <= ram(to_integer(unsigned(address)));
                    memOpFinished <= '1';

                elsif writeEn = '1' then
                    ram(to_integer(unsigned(address))) <= dataIn;
                    memOpFinished <= '1';
                end if;
            end if;

        end if;

    end process;

end Behavioral;