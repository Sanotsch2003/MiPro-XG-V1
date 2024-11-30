library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This is the 7-segment display module.
--The 7-segment display module is used to display data on the 7-segment display.

-- data is the input data that is displayed on the 7-segment display.
-- the control input can be used to confire the display like this:
-- control(31 downto 6) : prescaler for refreshing the display
-- control(5) : enable the display
-- control(4) : enable hex mode (0: decimal mode, 1: hex mode)
-- control(3) : enable signed mode (in signed mode the display interprets the data as 2's complement signed)
-- control(2 downto 0) : number of displays that are currently turned on (up to 8 displays supported)

entity IO_SevenSegmentDisplay is
    generic(
        --The number of 7-segment displays that are connected to the FPGA.
        num_displays : integer := 4
    );
    Port (
        clk                   : in std_logic;
        --IO ports for the 7-segment display:
        seg                   : out std_logic_vector(6 downto 0);
        an                    : out std_logic_vector(num_displays-1 downto 0);
        --control signals:
        reset                 : in std_logic;
        data                  : in std_logic_vector(31 downto 0);
        control               : in std_logic_vector(31 downto 0)

      );
end IO_SevenSegmentDisplay;

architecture Behavioral of IO_SevenSegmentDisplay is

    type display_array is array (0 to num_displays-1) of std_logic_vector(6 downto 0);
    signal displays : display_array; --holds the led data for each of the 7-segment displays, each bit corresonds to one led
    
    type digit_array is array (0 to num_displays-1) of std_logic_vector(4 downto 0);
    signal digits : digit_array := (others=>(others => '0')); --each element corresponds to one digit of the 7-segment display, an element can also contain special characters like 'E' or 'H' or '-'

    signal anodes_enable_reg : std_logic_vector(num_displays-1 downto 0) := (others=>'1'); --register for enabling the anodes

    --counter signals for refreshing the 7-segment display:
    signal count_reg         : std_logic_vector(3 downto 0) := (others=>'0'); --counter for refreshing the display
    signal prescale_count_reg: std_logic_vector(25 downto 0) := (others=>'0'); --counter for prescaling the refresh rate

    --control signals for the 7-segment display:
    signal prescaler         : std_logic_vector(25 downto 0); --prescaler for refreshing the display
    signal enable            : std_logic; --enables the display
    signal hex_mode          : std_logic; --enables the hex mode for the display
    signal signed_mode       : std_logic; --enables the signed mode for the display
    signal num_displays_on   : unsigned(2 downto 0); --number of displays that are currently on


begin
    --mapping control_input to the control signals:
    prescaler       <= control(31 downto 6);
    enable          <= control(5);
    hex_mode        <= control(4);
    signed_mode     <= control(3);
    num_displays_on <= unsigned(control(2 downto 0));

    --set led data for the 7-segment display that is currently being refreshed (based on the count_reg):
    seg    <= displays(to_integer(unsigned(count_reg)));
    an     <= anodes_enable_reg;

    count: process(clk, reset)
    variable count : integer := 0;
    begin
        if reset = '1' then
            count_reg <= (others=>'0');
            prescale_count_reg <= (others=>'0');
            count := 0;
            anodes_enable_reg <= (others=>'1');
        elsif rising_edge(clk) then
            anodes_enable_reg <= (others=>'1'); 
            if enable = '1' then
                if prescale_count_reg = prescaler then
                    count := count + 1;
                    prescale_count_reg <= (others=>'0');
                else
                    prescale_count_reg <= std_logic_vector(unsigned(prescale_count_reg)+1);
                end if;
                if count = to_integer(num_displays_on) or count = num_displays then
                    count := 0;
                end if;
                count_reg <= std_logic_vector(to_unsigned(count, count_reg'length));
                anodes_enable_reg(count) <= '0'; --enables the anode for the display that is currently being refreshed
            end if;
        end if;
    end process;

    --process for converting the input data to individual digits:
    data_to_leds: process(data, hex_mode, signed_mode, num_displays_on)
    variable temp : std_logic_vector(31 downto 0);
    variable temp2 : integer;
    begin
        digits <= (others => (others => '0'));
        if hex_mode = '1' then --hex mode

            if signed_mode = '0'  or (signed_mode = '1' and data(31) = '0') then --unsigned mode or positive signed mode
                for i in 0 to num_displays-1 loop
                    digits(i) <= '0' & data(i*4+3 downto i*4);
                end loop;

            else --negative signed mode
                temp := std_logic_vector(unsigned(not data) + 1);
                for i in 0 to num_displays-1 loop
                    digits(i) <= '0' & temp(i*4+3 downto i*4);
                end loop;
                if (to_integer(num_displays_on)-1) >= 1 then
                    digits(to_integer(num_displays_on)-1) <= "11001"; --negative sign
                end if;
            end if;


        else --decimal mode 

            if signed_mode = '0'  or (signed_mode = '1' and data(31) = '0') then --unsigned mode or positive signed mode
                temp2 := to_integer(unsigned(data));
                for i in 0 to num_displays-1 loop
                    digits(i) <= std_logic_vector(to_unsigned((temp2 mod 10), 5));
                    temp2 := temp2 / 10;
                end loop;

            else --negative signed mode
                temp2 := to_integer(unsigned(not data) + 1);
                for i in 0 to num_displays-1 loop
                    digits(i) <= std_logic_vector(to_unsigned((temp2 mod 10), 5));
                    temp2 := temp2 / 10;
                end loop;
                if (to_integer(num_displays_on)-1) >= 1 then
                    digits(to_integer(num_displays_on)-1) <= "11001"; --negative sign
                end if;
            end if;
            
        end if;

    end process;

    --process for converting the individual digits to led data:
    digits_to_leds: process(digits)
    begin
        for i in 0 to num_displays-1 loop
            case digits(i) is
                when "00000" => displays(i) <= "1000000"; --0
                when "00001" => displays(i) <= "1111001"; --1
                when "00010" => displays(i) <= "0100100"; --2
                when "00011" => displays(i) <= "0110000"; --3
                when "00100" => displays(i) <= "0011001"; --4
                when "00101" => displays(i) <= "0010010"; --5
                when "00110" => displays(i) <= "0000010"; --6
                when "00111" => displays(i) <= "1111000"; --7
                when "01000" => displays(i) <= "0000000"; --8
                when "01001" => displays(i) <= "0011000"; --9
                when "01010" => displays(i) <= "0001000"; --A
                when "01011" => displays(i) <= "0000011"; --B
                when "01100" => displays(i) <= "1000110"; --C
                when "01101" => displays(i) <= "0100001"; --D
                when "01110" => displays(i) <= "0000110"; --E
                when "01111" => displays(i) <= "0001110"; --F
                when "11001" => displays(i) <= "0111111"; --negative sign
                when others  => displays(i) <= "0000000"; --default off
            end case;
        end loop;
        
    end process;

end Behavioral;