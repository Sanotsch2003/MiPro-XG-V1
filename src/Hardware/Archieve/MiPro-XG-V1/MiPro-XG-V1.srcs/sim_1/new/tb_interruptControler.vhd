library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity interruptControler_tb is
end;

architecture bench of interruptControler_tb is

  component interruptControler
    Generic(
      numInterrupts : integer := 5
    );
    Port (
      enable           : in std_logic;
      reset            : in std_logic;
      clk              : in std_logic;
      alteredClock     : in std_logic;
      interruptSignals : in std_logic_vector(0 to numInterrupts-1);
      writeEn          : in std_logic;
      adress           : in std_logic_vector(5 downto 0);
      dataIn           : in std_logic_vector(31 downto 0);
      vectorOut        : out std_logic_vector(31 downto 0)
     );
  end component;

  signal enable: std_logic;
  signal reset: std_logic;
  signal clk: std_logic;
  signal alteredClock: std_logic;
  signal interruptSignals: std_logic_vector(0 to 5-1);
  signal writeEn: std_logic;
  signal adress: std_logic_vector(5 downto 0);
  signal dataIn: std_logic_vector(31 downto 0);
  signal vectorOut: std_logic_vector(31 downto 0) ;

  constant clock_period: time := 10 ns;
  constant altered_clock_period: time := 50ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: interruptControler generic map ( numInterrupts    =>  5)
                             port map ( enable           => enable,
                                        reset            => reset,
                                        clk              => clk,
                                        alteredClock     => alteredClock,
                                        interruptSignals => interruptSignals,
                                        writeEn          => writeEn,
                                        adress           => adress,
                                        dataIn           => dataIn,
                                        vectorOut        => vectorOut );

  stimulus: process
  begin
  
    -- Put initialisation code here
    --alteredClock <= '1';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;
    enable <= '1';
    writeEn <= '0';
    wait for 10 ns;
    for i in 0 to 31 loop
        interruptSignals <= std_logic_vector(to_unsigned(i, interruptSignals'length));
        wait for 10ns;
    end loop;
    
    writeEn <= '1';
    dataIn <= x"00000007";
    adress <= "000101";
    
    wait for 100 ns;
    dataIn <= x"0000FFFF";
    adress <= "000100";
    wait for 100ns;
    
    writeEn <= '0';
    wait for 10 ns;
    for i in 0 to 31 loop
        interruptSignals <= std_logic_vector(to_unsigned(i, interruptSignals'length));
        wait for 10ns;
    end loop;

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
  
  alteredClocking: process
  begin
    while not stop_the_clock loop
      alteredClock <= '0', '1' after altered_clock_period / 2;
      wait for altered_clock_period;
    end loop;
    wait;
  end process;
  

end;