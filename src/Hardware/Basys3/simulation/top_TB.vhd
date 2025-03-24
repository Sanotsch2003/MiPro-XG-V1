library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.helperPackage.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      Generic(
        --General settings:
        numDigitalIO_Pins                     : INTEGER := 16;
        numSevenSegmentDisplays               : INTEGER := 4;     --Basys 3 : 4, DE10-Lite : 6
        individualSevenSegmentDisplayControll : BOOLEAN := false; --Basys 3 : false, DE10-Lite : true
        memSize                               : INTEGER := 1024;
        invertResetBtn                        : BOOLEAN := false; --Basys 3 : false, DE10-Lite : true
        FPGA_Platform                         : STRING  := "amd"; --Basys 3 : "amd", DE10-Lite : "intel"

        --System clock settings:
        sysClkMultiplier  : real := 10.0;
        sysClkDivider     : real := 20.0; --Basys 3 : 20.0, DE10-Lite : 10.0
        externalClkPeriod : real := 10.0; --Basys 3 : 10.0, DE10-Lite : 20.0

        --Baud rate settings (The prescaler is applied to the internal clock):
        defaultSerialInterfacePrescaler : INTEGER := 434; -- 434: 115200 baud (@50mHz),  5208: 9600 baud (@50mHz)

        --VGA clock settings (The VGA clock is created using the external clock and must have a frequency of 25mHz):
        VGA_ClkMultiplier : real := 10.0;
        VGA_ClkDivider    : real := 40.0; --Basys 3 : 40.0, DE10-Lite : 20.0

        --Changing these values should only be done when changes inside the code require it:
        numCPU_CoreDebugSignals : INTEGER := 868;
        numExternalDebugSignals : INTEGER := 152;
        numMMIO_Interrupts      : INTEGER := 5;
        numCPU_Interrupts       : INTEGER := 2;
        numOther_Interrupts     : INTEGER := 1
      );
      Port ( 
        externalClk     : IN STD_LOGIC;
        resetBtn        : IN STD_LOGIC; --middle button
        enableSw        : IN STD_LOGIC; --switch 15
        manualClocking  : IN STD_LOGIC; --swtich 14
        debugMode       : IN STD_LOGIC; --switch 13
        programmingMode : IN STD_LOGIC; --switch 12
        manualClk       : IN STD_LOGIC; --down button

        --UART
        tx : OUT STD_LOGIC;
        rx : IN STD_LOGIC;

        --Seven Segment Displays
        sevenSegmentLEDs   : OUT seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays) - 1 DOWNTO 0);
        sevenSegmentAnodes : OUT STD_LOGIC_VECTOR(numSevenSegmentDisplays - 1 DOWNTO 0);

        --IO Pins
        digitalIO_pins : INOUT STD_LOGIC_VECTOR(numDigitalIO_Pins - 1 DOWNTO 0);

        --VGA interface
        VGA_Blue  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        VGA_Green : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        VGA_Red   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        H_Sync    : OUT STD_LOGIC;
        V_Sync    : OUT STD_LOGIC
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
  signal VGA_Blue  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  signal VGA_Green : STD_LOGIC_VECTOR(3 DOWNTO 0);
  signal VGA_Red   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  signal H_Sync    : STD_LOGIC;
  signal V_Sync    : STD_LOGIC;
  
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
                         sysClkMultiplier                       => 10.0,
                         sysClkDivider                      => 20.0,
                         externalClkPeriod                         => 10.0,
                         VGA_ClkMultiplier                  => 10.0, 
                         VGA_ClkDivider                     => 40.0,
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
                         digitalIO_pins                        => digitalIO_pins,
                         VGA_Blue                              => VGA_Blue,
                         VGA_Red                                => VGA_Red,
                         VGA_Green                               => VGA_Green,
                         H_Sync                                  => H_Sync,
                         V_Sync                                 => V_Sync);
                    

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