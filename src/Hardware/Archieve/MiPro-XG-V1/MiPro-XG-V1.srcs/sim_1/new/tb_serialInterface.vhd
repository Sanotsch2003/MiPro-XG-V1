library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity serialInterface_tb is
end;

architecture bench of serialInterface_tb is

  component serialInterface
      generic(
          numInterrupts            :integer := 5;
          numCPU_CoreDebugSignals  : integer := 867;
          numExternalDebugSignals  : integer := 128
      );
      Port (
              clk                      : in std_logic;
              reset                    : in std_logic;
              enable                   : in std_logic;
              debugMode                : in std_logic;
              rx                       : in std_logic;
              tx                       : out std_logic;
              status                   : out std_logic_vector(7 downto 0);
              dataReceived             : out std_logic_vector(8 downto 0);
              dataToTransmit           : in std_logic_vector(7 downto 0);
              loadTransmitFIFO_reg     : in std_logic;
              readFromReceiveFIFO_reg  : in std_logic;          
              prescaler                : in std_logic_vector(31 downto 0);
              debugSignals             : in std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts-1 downto 0);
              dataAvailableInterrupt   : out std_logic
              );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal enable: std_logic;
  signal debugMode: std_logic;
  signal rx: std_logic;
  signal tx: std_logic;
  signal status: std_logic_vector(7 downto 0);
  signal dataReceived: std_logic_vector(8 downto 0);
  signal dataToTransmit: std_logic_vector(7 downto 0);
  signal loadTransmitFIFO_reg: std_logic;
  signal readFromReceiveFIFO_reg: std_logic;
  signal prescaler: std_logic_vector(31 downto 0);
  signal debugSignals: std_logic_vector(960-1 downto 0);
  signal dataAvailableInterrupt: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: serialInterface generic map ( numInterrupts           => 5,
                                     numCPU_CoreDebugSignals => 827,
                                     numExternalDebugSignals => 128)
                          port map ( clk                     => clk,
                                     reset                   => reset,
                                     enable                  => enable,
                                     debugMode               => debugMode,
                                     rx                      => rx,
                                     tx                      => tx,
                                     status                  => status,
                                     dataReceived            => dataReceived,
                                     dataToTransmit          => dataToTransmit,
                                     loadTransmitFIFO_reg    => loadTransmitFIFO_reg,
                                     readFromReceiveFIFO_reg => readFromReceiveFIFO_reg,
                                     prescaler               => prescaler,
                                     debugSignals            => debugSignals,
                                     dataAvailableInterrupt  => dataAvailableInterrupt );

  stimulus: process
  begin
  
    -- Put initialisation code here
    prescaler <= std_logic_vector(to_unsigned(10, prescaler'length));
    enable <= '1';
    debugMode <= '0';
    rx <= '1';
    debugSignals <= (others => '1');
    dataToTransmit <= (others => '0');
    loadTransmitFIFO_reg <= '0';
    readFromReceiveFIFO_reg <= '0';

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
        rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
        rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
        rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
    readFromReceiveFIFO_reg <= '1';
    wait for 10ns;
    readFromReceiveFIFO_reg <= '0';
    wait for 10ns;
    
            rx <= '0';
    wait for 100ns;
    rx <= '0';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
                rx <= '0';
    wait for 100ns;
    rx <= '0';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
                rx <= '0';
    wait for 100ns;
    rx <= '0';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
                rx <= '0';
    wait for 100ns;
    rx <= '0';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
                rx <= '0';
    wait for 100ns;
    rx <= '0';
    wait for 900ns;
    rx <= '0';
    wait for 100ns;
    rx <= '1';
    wait for 20ns;
    
    wait for 4000ns;
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