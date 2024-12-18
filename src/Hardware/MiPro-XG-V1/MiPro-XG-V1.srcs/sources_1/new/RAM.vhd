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
        2 => "00001010",
        3 => "00000000",
        4 => "11111101",
        5 => "11101000",
        6 => "00000000",
        7 => "00001100",
        8 => "11111001",
        9 => "00000000",
        10 => "00001100",
        11 => "00000000",
        12 => "11111101",
        13 => "11000100",
        14 => "10000100",
        15 => "01100111",
        16 => "11111101",
        17 => "11100000",
        18 => "00011110",
        19 => "10001100",
        20 => "11111001",
        21 => "00000000",
        22 => "00001100",
        23 => "01110111",
        24 => "11110000",
        25 => "11000000",
        26 => "00000000",
        27 => "00000111",
        28 => "11111101",
        29 => "11000000",
        30 => "00001010",
        31 => "10000000",
        32 => "11111101",
        33 => "11101000",
        34 => "00000000",
        35 => "00001100",
        36 => "11111001",
        37 => "00000000",
        38 => "00001100",
        39 => "00000000",
        40 => "11111101",
        41 => "11000000",
        42 => "00001111",
        43 => "01100111",
        44 => "11110000",
        45 => "11000000",
        46 => "00000000",
        47 => "00000111",
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