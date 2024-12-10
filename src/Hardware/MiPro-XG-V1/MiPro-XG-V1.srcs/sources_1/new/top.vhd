library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    Generic(
        numSevenSementDisplays : integer := 4
    );
    Port ( 
        clk                 : in std_logic;
        reset               : in std_logic; --middle button
        enable              : in std_logic; --switch 15
        manualClocking      : in std_logic; --swtich 14
        debugMode           : in std_logic; --switch 13
        manualClk           : in std_logic; --down button

        loadData            : in std_logic;  --left button
        loadControl         : in std_logic;  --right button

        switches            : in std_logic_vector(12 downto 0); --switches 12-0

        sevenSegmentLEDs    : out std_logic_vector(6 downto 0);
        sevenSegmentAnodes  : out std_logic_vector(numSevenSementDisplays - 1 downto 0)

        
    );
end top;

architecture Behavioral of top is
    component IO_SevenSegmentDisplays is
        generic
        (
        --The number of 7-segment displays that are connected to the FPGA.
        numDisplays : integer := 4
        );
        Port 
        (
        enable                   : in std_logic;
        reset                    : in std_logic;
        clk                      : in std_logic;
        alteredClock             : in std_logic;

        --IO ports for the 7-segment display:
        seg                      : out std_logic_vector(6 downto 0);
        an                       : out std_logic_vector(numDisplays-1 downto 0);
        --controlReg signals:
        dataIn                   : in std_logic_vector(31 downto 0);
        loadDataReg              : in std_logic;
        loadControlReg           : in std_logic;
        
        --debug signal
        debug                    : out std_logic_vector(63 downto 0)
        );
    end component;

    --signal declarations
    signal alteredClock : std_logic := '1';
    signal dataIn : std_logic_vector(31 downto 0) := (others => '0');

    --seven segment display
    signal sevenSegmentDisplayDebug : std_logic_vector(63 downto 0);

begin
    SevenSegmentDisplay : IO_SevenSegmentDisplays
        generic map(
            numDisplays => numSevenSementDisplays
        )
        port map(
            enable          => enable,
            reset           => reset,
            clk             => clk,
            alteredClock    => alteredClock,
            seg             => sevenSegmentLEDs,
            an              => sevenSegmentAnodes,
            dataIn          => dataIn,
            loadDataReg     => loadData,
            loadControlReg  => loadControl,
            debug           => sevenSegmentDisplayDebug
        );

    dataIn(12 downto 0) <= switches;
end Behavioral;
