library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      Generic(
          numSevenSegmentDisplays     : integer := 4;
          numInterrupts               : integer := 10;
          memSize                     : integer := 2048;
          memoryMappedAddressesStart  : integer := 1073741824;
          memoryMappedAddressesEnd    : integer := 1073741916;
          numCPU_CoreDebugSignals     : integer := 867;
          numExternalDebugSignals     : integer := 128
      );
      Port ( 
          clk                 : in std_logic;
          resetBtn            : in std_logic;
          enable              : in std_logic;
          manualClocking      : in std_logic;
          debugMode           : in std_logic;
          programmingMode     : in std_logic;
          manualClk           : in std_logic;
          tx                  : out std_logic; 
          rx                  : in std_logic;
          sevenSegmentLEDs    : out std_logic_vector(6 downto 0);
          sevenSegmentAnodes  : out std_logic_vector(numSevenSegmentDisplays - 1 downto 0)
      );
  end component;

  signal clk: std_logic;
  signal resetBtn: std_logic;
  signal enable: std_logic;
  signal manualClocking: std_logic;
  signal debugMode: std_logic;
  signal programmingMode: std_logic;
  signal manualClk: std_logic;
  signal tx: std_logic;
  signal rx: std_logic;
  signal sevenSegmentLEDs: std_logic_vector(6 downto 0);
  signal sevenSegmentAnodes: std_logic_vector(4 - 1 downto 0) ;
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: top generic map ( numSevenSegmentDisplays    => 4,
                         numInterrupts              => 10,
                         memSize                    => 2048,
                         memoryMappedAddressesStart => 1073741824,
                         memoryMappedAddressesEnd   => 1073741916,
                         numCPU_CoreDebugSignals    => 867,
                         numExternalDebugSignals    => 128)
              port map ( clk                        => clk,
                         resetBtn                   => resetBtn,
                         enable                     => enable,
                         manualClocking             => manualClocking,
                         debugMode                  => debugMode,
                         programmingMode            => programmingMode,
                         manualClk                  => manualClk,
                         tx                         => tx,
                         rx                         => rx,
                         sevenSegmentLEDs           => sevenSegmentLEDs,
                         sevenSegmentAnodes         => sevenSegmentAnodes );

  stimulus: process
  begin
    manualClocking <= '0';
    debugMode <= '0';
    programmingMode <= '0';
    manualClk <= '0';
    enable <= '1';
    resetBtn <= '1';
    wait for 5 ns;
    resetBtn <= '0';
    wait for 5000 ns;

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