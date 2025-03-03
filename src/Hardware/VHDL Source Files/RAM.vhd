library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    generic(
        ramSize : integer
    );
    port (
        enable                     : in std_logic;
        clk                        : in std_logic;
        reset                      : in std_logic;
        alteredClk                 : in std_logic;
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
    
    --deafult count program
     signal ram : ram_type :=(
         0 => "11111101110000000001001100000000",
         1 => "11111101111010000000000000001100",
         2 => "11111001000000000000110000000000",
         3 => "11111101110111100001000000000001",
         4 => "11111101111000000101111101001100",
         5 => "11111001000000000000110000010001",
         6 => "11110000100000000000000000000001",
         7 => "11111101110000000001010000000000",
         8 => "11111101111010000000000000001100",
         9 => "11111001000000000000110000000000",
         10 => "11111101110000000000000000100001",
         11 => "11110000100000000000000000000001",
         12 => "11111101110000000000101000000000",
         13 => "11111101111010000000000000001100",
         14 => "11111001000000000000110000000000",
         15 => "11111101110001001000010010000001",
         16 => "11111101111000000001111010001100",
         17 => "11111001000000000000110000010001",
         18 => "11110000100000000000000000000001",
         19 => "11111101110000000001010010000000",
         20 => "11111101111010000000000000001100",
         21 => "11111001000000000000110000000000",
         22 => "11110000000000000000000000000001",
         23 => "11111101110000000000101010000000",
         24 => "11111101111010000000000000001100",
         25 => "11111001000000000000110000000000",
         26 => "11110000100000000000000000000001",
         27 => "11110110011000000000000000001001",
         others => (others => '0')
     );





























































































































































































































































































































begin
    process(clk, reset) 
    begin 
        if rising_edge(clk) then 
            --if alteredClk = '1' then
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
            --end if;
        end if;

    end process;
    
    --Setting the memOpFinished signal.
    process(clk)
    begin
        if rising_edge(clk) then
            --if alteredClk = '1' then
                if writeEn = '1' or readEn = '1' then
                    memOpFinished <= '1';
                else
                    memOpFinished <= '0';
                end if;
            --end if;
        end if;
    end process;

end Behavioral;
