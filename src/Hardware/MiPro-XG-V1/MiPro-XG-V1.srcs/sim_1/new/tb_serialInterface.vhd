library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity serialInterface_tb is
end;

architecture bench of serialInterface_tb is

  component serialInterface
    Port (
          clk   : in std_logic;
          reset : in std_logic;
          rx    : in std_logic;
          tx    : out std_logic;
          debugMode          : in std_logic;
          debugSignals       : in std_logic_vector(6 downto 0);
          leds               : out std_logic_vector(7 downto 0)
     );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal rx: std_logic;
  signal tx: std_logic;
  signal debugMode: std_logic;
  signal debugSignals: std_logic_vector(6 downto 0);
  signal leds: std_logic_vector(7 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: serialInterface port map ( clk          => clk,
                                  reset        => reset,
                                  rx           => rx,
                                  tx           => tx,
                                  debugMode    => debugMode,
                                  debugSignals => debugSignals,
                                  leds         => leds );

  stimulus: process
  begin
  
    -- Put initialisation code here
    rx <= '1';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;
    debugMode <= '1';
    debugSignals <= (others => '0');
    rx <= '0';
    wait for 20ns;
    rx <= '1';
    wait for 400ns;
    rx <= '0';
    wait for 450ns;
    rx <= '1';
    wait for 100ns;
    rx <= '0';
    wait for 10ns;
    rx <= '1';
    wait for 10000ns;
  

    -- Put test bench stimulus code here

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