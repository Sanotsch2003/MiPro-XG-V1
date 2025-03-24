library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.helperPackage.all;

entity IO_SevenSegmentDisplays_tb is
end;

architecture bench of IO_SevenSegmentDisplays_tb is

  component IO_SevenSegmentDisplays
      generic(
            numSevenSegmentDisplays     	    : integer;
  		  individualSevenSegmentDisplayControll : boolean	  
      );
  	 Port (
  			enable                   : in std_logic;
  			reset                    : in std_logic;
  			clk                      : in std_logic;
  			sevenSegmentLEDs         : out seven_segment_array(3 downto 0);
  			sevenSegmentAnodes       : out std_logic_vector(3 downto 0);
  			dataIn                   : in std_logic_vector(31 downto 0);
  			controlIn                : in std_logic_vector(31 downto 0)
  		 );
  end component;

  signal enable: std_logic;
  signal reset: std_logic;
  signal clk: std_logic;
  signal sevenSegmentLEDs: seven_segment_array(3 downto 0);
  signal sevenSegmentAnodes: std_logic_vector(3 downto 0);
  signal dataIn: std_logic_vector(31 downto 0);
  signal controlIn: std_logic_vector(31 downto 0) ;
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: IO_SevenSegmentDisplays generic map ( numSevenSegmentDisplays               => 4,
                                             individualSevenSegmentDisplayControll => true)
                                  port map ( enable                                => enable,
                                             reset                                 => reset,
                                             clk                                   => clk,
                                             sevenSegmentLEDs                      => sevenSegmentLEDs,
                                             sevenSegmentAnodes                    => sevenSegmentAnodes,
                                             dataIn                                => dataIn,
                                             controlIn                             => controlIn );
    
  stimulus: process
  begin

    -- Put initialisation code here

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    enable <= '1';
    reset <= '0';
    controlIn <= "00000000111101000010010000100100";
    dataIn <= std_logic_vector(to_unsigned(456, 32));
    
    wait for 500 ns;

    stop_the_clock <= true;
    
    
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;



end;