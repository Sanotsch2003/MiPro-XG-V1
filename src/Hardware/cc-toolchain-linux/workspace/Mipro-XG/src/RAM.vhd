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
        3 => "11111101110001001000010010000001",
        4 => "11111101111000000001111010001100",
        5 => "11111001000000000000110000010001",
        6 => "11110000100000000000000000000001",
        7 => "11111011110000000000111101001101",
        8 => "11110110110000000000000000000100",
        9 => "11111011110000000000011100010111",
        10 => "11111011110000000000111101001101",
        11 => "11110110110000000000000000000110",
        12 => "11110110011000000000000000000110",
        13 => "11111101110000000000101010001011",
        14 => "11111101111010000000000000001100",
        15 => "11111001000000000000110010111011",
        16 => "11110000100000000000000010110111",
        17 => "11111101100000000000000110101111",
        18 => "11111101110000000000000000001010",
        19 => "11111101110111000110110000001011",
        20 => "11111101111000000000001011001100",
        21 => "11111001000000000000110010111011",
        22 => "11111010101000000000101110100000",
        23 => "00001101100000000000000110101111",
        24 => "11111011110000000000101000011010",
        25 => "11110110011000000000000000000100",
        others => (others => '0')
    );
  
begin
    process(clk, reset) 
    begin 
        if rising_edge(clk) then 
            if writeEn = '1' then
                -- Write data to RAM
                ram(to_integer(unsigned(address))) <= dataIn;
            end if;
    
            if readEn = '1' then
                -- Read data from RAM
                dataOut <= ram(to_integer(unsigned(address)));
            else
                dataOut <= (others => '0');
                
            end if;

        end if;

    end process;
    
    --Setting the memOpFinished signal.
    process(clk)
    begin
        if rising_edge(clk) then

            if writeEn = '1' or readEn = '1' then
                memOpFinished <= '1';
            else
                memOpFinished <= '0';
            end if;
            
        end if;
    end process;

end Behavioral;
