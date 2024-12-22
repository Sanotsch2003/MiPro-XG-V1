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
        0 => "11111101110000000000000101000111",
        1 => "11111011110000000000000000010000",
        2 => "11111010101000000000000001110000",
        3 => "11111011110000000000000000010000",
        4 => "11111010101000000000000001110000",
        5 => "11111011110000000000000000010000",
        6 => "11111010101000000000000001110000",
        7 => "11111011110000000000000000010000",
        8 => "11111010101000000000000001110000",
        9 => "11111011110000000000000000010000",
        10 => "11111010101000000000000001110000",
        11 => "11111011110000000000000000010000",
        12 => "11111010101000000000000001110000",
        13 => "11111011110000000000000000010000",
        14 => "11111010101000000000000001110000",
        15 => "11111011110000000000000000010000",
        16 => "11111010101000000000000001110000",
        17 => "11111011110000000000000000010000",
        18 => "11111010101000000000000001110000",
        19 => "11111011110000000000000000010000",
        20 => "11111010101000000000000001110000",
        21 => "11111011110000000000000000010000",
        22 => "11111010101000000000000001110000",
        23 => "11111011110000000000000000010000",
        24 => "11111010101000000000000001110000",
        25 => "11111011110000000000000000010000",
        26 => "11111010101000000000000001110000",
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