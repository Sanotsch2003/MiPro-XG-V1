library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.helperPackage.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      Generic(
          numDigitalIO_Pins                        : integer := 16;
          numSevenSegmentDisplays     		     : integer := 4;
  		individualSevenSegmentDisplayControll    : boolean := false;
          memSize                     			 : integer := 1024;
          invertResetBtn                           : boolean := false;
          FPGA_Platform                            : string := "amd";
          CLKFBOUT_MULT_F                          : real := 10.0;
          CLKOUT0_DIVIDE_F                         : real := 20.0;
          CLKIN1_PERIOD                            : real := 10.0;
          defaultSerialInterfacePrescaler          : integer := 5208;
          numCPU_CoreDebugSignals     			 : integer := 868;
          numExternalDebugSignals     			 : integer := 152;
          numMMIO_Interrupts                       : integer := 5;
          numCPU_Interrupts                        : integer := 2;
          numOther_Interrupts                      : integer := 1
      );
      Port ( 
          externalClk         : in std_logic;
          resetBtn            : in std_logic;
          enableSw            : in std_logic;
          manualClocking      : in std_logic;
          debugMode           : in std_logic;
          programmingMode     : in std_logic;
          manualClk           : in std_logic;
          tx                  : out std_logic; 
          rx                  : in std_logic;
          sevenSegmentLEDs    : out seven_segment_array(0 downto 0);
          sevenSegmentAnodes  : out std_logic_vector(3 downto 0);
          digitalIO_pins      : inout std_logic_vector(15 downto 0)
      );
  end component;

  signal externalClk: std_logic;
  signal resetBtn: std_logic;
  signal enableSw: std_logic;
  signal manualClocking: std_logic;
  signal debugMode: std_logic;
  signal programmingMode: std_logic;
  signal manualClk: std_logic;
  signal tx: std_logic;
  signal rx: std_logic;
  signal sevenSegmentLEDs: seven_segment_array(0 downto 0);
  signal sevenSegmentAnodes: std_logic_vector(3 downto 0);
  signal digitalIO_pins: std_logic_vector(15 downto 0) ;
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: top generic map ( numDigitalIO_Pins                     => 16,
                         numSevenSegmentDisplays               => 4,
                         individualSevenSegmentDisplayControll => false,
                         memSize                               => 1024,
                         invertResetBtn                        => false,
                         FPGA_Platform                         => "amd",
                         CLKFBOUT_MULT_F                       => 10.0,
                         CLKOUT0_DIVIDE_F                      => 20.0,
                         CLKIN1_PERIOD                         => 10.0,
                         defaultSerialInterfacePrescaler       => 5208,
                         numCPU_CoreDebugSignals               => 868,
                         numExternalDebugSignals               => 152,
                         numMMIO_Interrupts                    =>  5,
                         numCPU_Interrupts                     => 2,
                         numOther_Interrupts                   => 1)
              port map ( externalClk                           => externalClk,
                         resetBtn                              => resetBtn,
                         enableSw                              => enableSw,
                         manualClocking                        => manualClocking,
                         debugMode                             => debugMode,
                         programmingMode                       => programmingMode,
                         manualClk                             => manualClk,
                         tx                                    => tx,
                         rx                                    => rx,
                         sevenSegmentLEDs                      => sevenSegmentLEDs,
                         sevenSegmentAnodes                    => sevenSegmentAnodes,
                         digitalIO_pins                        => digitalIO_pins );

  stimulus: process
  begin

    -- Put initialisation code here

    resetBtn <= '1';
    wait for 5 ns;
    resetBtn <= '0';
    wait for 5 ns;
    
    enableSw <= '1';
    manualClocking <= '0';
    debugMode <= '0';
    programmingMode <= '0';
    wait for 1000ns;
    programmingMode <= '1';
    resetBtn <= '0';
    wait for 100ns;
    programmingMode <= '1';
    resetBtn <= '0';
    wait for 10000000 ns;

    stop_the_clock <= true;
    
    
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      externalClk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;


end;