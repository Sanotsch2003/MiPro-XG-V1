library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    Generic(
        numSevenSementDisplays : integer := 4;
        numInterrupts          : integer := 5
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
    component CPU_Core is
        Generic(
            numInterrupts : integer := 5
        );
    
        Port (
            enable                  : in std_logic;
            hardwareReset           : in std_logic;
            clk                     : in std_logic;
            alteredClock            : in std_logic;
    
            programmingMode         : in std_logic;
    
            dataIn                  : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
            addressOut              : out std_logic_vector(31 downto 0);
            
            readEn                  : out std_logic;
            writeEn                 : out std_logic;
            softwareReset           : out std_logic;
            memOpFinished           : in std_logic;
    
            --interupt vector table and interrupt priority register
            IVT                     : in std_logic_vector(numInterrupts*32-1 downto 0);
            PR                      : in std_logic_vector(numInterrupts*3-1 downto 0);
    
            externalInterrupts      : in std_logic_vector(numInterrupts-1 downto 0); --there are no internal interrupts so far
            clearExternalInterrupts : out std_logic_vector(numInterrupts-1 downto 0); 
    
            --debugging
            debug                   : out std_logic_vector(866+numInterrupts-1 downto 0)
        );
    end component;

    component memoryMapping is
        generic(
            numInterrupts : integer := 5;
            numSevenSegmentDisplays : integer := 4
        );
        Port (
            enable                  : in std_logic;
            reset                   : in std_logic;
            clk                     : in std_logic;
    
            address                 : in std_logic_vector(31 downto 0);
            dataIn                  : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
    
            --interrupt vector table and priority register
            IVT_out                 : out std_logic_vector(32 * numInterrupts - 1 downto 0);
            PR_out                  : out std_logic_vector(3 * numInterrupts -1 downto 0);
    
            --seven segment display
            seg                     : out std_logic_vector(6 downto 0);
            an                      : out std_logic_vector(numSevenSegmentDisplays-1 downto 0);
    
            --clock controller
            alteredClkOut           : out std_logic;
            manualClk               : in std_logic;
            manualClocking          : in std_logic;
    
            --Serial interface      
            tx                      : out std_logic;
            rx                      : in std_logic;
            debugMode               : in std_logic;
    
            --debugging
            debugSignals            : in std_logic_vector(866+numInterrupts-1 downto 0)
    
        );
    end component;

    component RAM is
        generic(
            ramSize : integer := 2048
        );
        port (
            enable                     : in std_logic;
            clk                        : in std_logic;
            alteredClk                 : in std_logic;
            reset                      : in std_logic;
            address                    : in std_logic_vector(31 downto 0);
            data_in                    : in std_logic_vector(31 downto 0);
            data_out                   : out std_logic_vector(31 downto 0);
            write_enable               : in std_logic;
            read_enable                : in std_logic
    
        );
    end component;

begin

end Behavioral;
