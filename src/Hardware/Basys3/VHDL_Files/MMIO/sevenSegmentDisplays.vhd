library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.helperPackage.all;

--This is the 7-segment display module.
--The 7-segment display module is used to display dataIn on the 7-segment display.

-- dataIn is the input dataIn that is displayed on the 7-segment display.
-- the controlIn input can be used to configure the display like this:
-- controlIn(31 downto 6) : prescaler for refreshing the display
-- controlIn(5) : displayOn 
-- controlIn(4) : enable hex mode (0: decimal mode, 1: hex mode)
-- controlIn(3) : enable signed mode (in signed mode the display interprets the dataIn as 2's complement signed)
-- controlIn(2 downto 0) : number of displays that are currently turned on (up to 8 displays supported)

entity sevenSegmentDisplays is
    generic(
        --The number of 7-segment displays that are connected to the FPGA.
          numSevenSegmentDisplays     		    : integer;
		  individualSevenSegmentDisplayControll : boolean	  
    );
	 Port (
			enable                   : in std_logic;
			reset                    : in std_logic;
			clk                      : in std_logic;
			sevenSegmentLEDs         : out seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays)-1 downto 0);
			sevenSegmentAnodes       : out std_logic_vector(numSevenSegmentDisplays-1 downto 0);
			dataIn                   : in std_logic_vector(31 downto 0);
			controlIn                : in std_logic_vector(31 downto 0)
		 );
end sevenSegmentDisplays;

architecture Behavioral of sevenSegmentDisplays is

    type display_array is array (0 to numSevenSegmentDisplays-1) of std_logic_vector(6 downto 0);
    signal displays : display_array; --holds the led data for each of the 7-segment displays, each bit corresonds to one led
    
    type digit_array is array (0 to numSevenSegmentDisplays-1) of std_logic_vector(4 downto 0);
    signal digits : digit_array := (others=>(others => '0')); --each element corresponds to one digit of the 7-segment display, an element can also contain special characters like 'E' or 'H' or '-'

    signal anodesEnableReg : std_logic_vector(numSevenSegmentDisplays-1 downto 0) := (others=>'1'); --register for enabling the anodes

    --counter signals for refreshing the 7-segment display:
    signal countReg         : std_logic_vector(3 downto 0) := (others=>'0'); --counter for refreshing the display
    signal prescaleCountReg: std_logic_vector(25 downto 0) := (others=>'0'); --counter for prescaling the refresh rate

    --control and data signals for the 7-segment display:
    signal prescaler       : std_logic_vector(25 downto 0); --prescaler for refreshing the display
    signal displayOn       : std_logic; --enables the display
    signal hexMode         : std_logic; --enables the hex mode for the display
    signal signedMode      : std_logic; --enables the signed mode for the display
    signal numDisplaysOn   : unsigned(2 downto 0); --number of displays that are currently on
    
	 
	 --signals for the Double Dabble Algorithm
	 signal ddCount : unsigned(4 downto 0);
	 signal ddshiftReg : std_logic_vector(30 downto 0);
	 signal ddbcd : std_logic_vector(numSevenSegmentDisplays*4-1 downto 0); 
	 signal ddDecReg : std_logic_vector(numSevenSegmentDisplays*4-1 downto 0); 
	 constant ddbcdZeros : std_logic_vector(numSevenSegmentDisplays*4-2 downto 0) := (others => '0');
	 signal isNegative : std_logic;
	 signal absoluteValue : std_logic_vector(31 downto 0);


begin
    --mapping controlIn_input to the controlIn signals:
    prescaler      <= controlIn(31 downto 6);
    displayOn      <= controlIn(5);
    hexMode        <= controlIn(4);
    signedMode     <= controlIn(3);
    numDisplaysOn  <= unsigned(controlIn(2 downto 0));
    isNegative     <= dataIn(31);
    absoluteValue  <= std_logic_vector(unsigned(not dataIn) + 1) when isNegative = '1' else dataIn;

    --set led dataIn for the 7-segment display that is currently being refreshed (based on the countReg):
	 process(displays, anodesEnableReg, countReg)
	 begin
			if individualSevenSegmentDisplayControll then
				sevenSegmentAnodes     <= (others => '0');
				for i in 0 to numSevenSegmentDisplays-1 loop
					sevenSegmentLEDs(i)    <= displays(i);
				end loop;
			else
			    sevenSegmentLEDs(0)    <= displays(to_integer(unsigned(countReg)));
				 sevenSegmentAnodes     <= anodesEnableReg;
			end if;
	end process;

    process(clk, reset)
    variable count : integer := 0;
    begin
		  if individualSevenSegmentDisplayControll = false then
			  if reset = '1' then
					countReg <= (others=>'0');
					prescaleCountReg <= (others=>'0');
					count := 0;
					anodesEnableReg <= (others=>'1');
			  elsif rising_edge(clk) then
					anodesEnableReg <= (others=>'1'); 
					if displayOn = '1' then
						 if enable = '1' then
							  if prescaleCountReg = prescaler then
									count := count + 1;
									prescaleCountReg <= (others=>'0');
							  else
									prescaleCountReg <= std_logic_vector(unsigned(prescaleCountReg)+1);
							  end if;
							  if count = to_integer(numDisplaysOn) or count = numSevenSegmentDisplays then
									count := 0;
							  end if;
							  countReg <= std_logic_vector(to_unsigned(count, countReg'length));
							  anodesEnableReg(count) <= '0'; --enables the anode for the display that is currently being refreshed
						 end if;
					end if;
			  end if;
		 end if;
    end process;

    --process for converting the input dataIn to individual digits:
    dataIn_to_leds: process(dataIn, hexMode, signedMode, numDisplaysOn, ddDecReg, isNegative, absoluteValue)
    begin
        digits <= (others => (others => '0'));
        if hexMode = '1' then --hex mode
            if signedMode = '0'  or isNegative = '0' then --unsigned mode or positive signed mode
                for i in 0 to numSevenSegmentDisplays-1 loop
                    digits(i) <= '0' & dataIn(i*4+3 downto i*4);
                end loop;

            else --negative signed mode
                for i in 0 to numSevenSegmentDisplays-1 loop
                    digits(i) <= '0' & absoluteValue(i*4+3 downto i*4);
                end loop;
                if (to_integer(numDisplaysOn)-1) >= 1 then
                    digits(to_integer(numDisplaysOn)-1) <= "11001"; --negative sign
                end if;
            end if;


        else --decimal mode 	
            for j in 0 to numSevenSegmentDisplays-1 loop
                digits(j) <= '0' & ddDecReg(j*4 + 3 downto j*4);
            end loop;
            
            if not (signedMode = '0'  or isNegative = '0') then --not (unsigned mode or positive signed mode)
                if (to_integer(numDisplaysOn)-1) >= 1 then
                digits(to_integer(numDisplaysOn)-1) <= "11001"; --negative sign
           end if;
            end if;
				
        end if;

    end process;
	 
	 doubleDabble : process(clk, reset)
		variable ddbcdTemp : std_logic_vector(numSevenSegmentDisplays*4-1 downto 0);
		variable data : std_logic_vector(31 downto 0); 
	 begin
		if reset = '1' then 
			ddCount <= (others => '0');
			ddshiftReg <= (others => '0'); 
			ddbcd <= (others => '0');
			ddDecReg <= (others => '0');
			
		elsif rising_edge(clk) then
			if not hexMode = '1' then
			    if signedMode = '1' then
			         data := absoluteValue;
			    else
			         data := dataIn;
			    end if;
				ddCount <= ddCount + 1;
				if ddCount = 0 then 
					ddDecReg <= ddbcd;
					ddshiftReg <= data(30 downto 0);
					ddbcd <= ddbcdZeros & data(31);
					
				else
					ddbcdTemp := ddbcd(numSevenSegmentDisplays*4-2 downto 0) & ddshiftReg(30);
					if ddCount /= 31 then
						for i in 0 to numSevenSegmentDisplays-1 loop
							 if unsigned(ddbcdTemp(i*4+3 downto i*4)) > 4 then
								  ddbcdTemp(i*4+3 downto i*4) := std_logic_vector(unsigned(ddbcdTemp(i*4+3 downto i*4)) + 3);
							 end if;
						end loop;
					end if;
					ddbcd <= ddbcdTemp;
					ddShiftReg <= ddshiftReg(29 downto 0) & '0';
				end if;
			
			end if;
		end if;
	 
	 end process;

    --process for converting the individual digits to led dataIn:
    digits_to_leds: process(digits)
    begin
        for i in 0 to numSevenSegmentDisplays-1 loop
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