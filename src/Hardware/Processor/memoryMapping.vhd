library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoryMapping is
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
end memoryMapping;

architecture Behavioral of memoryMapping is
    --memory mapped addresses (read and write)
    constant IVT_0 : std_logic_vector(31 downto 0) := x"40000000";
    constant IVT_1 : std_logic_vector(31 downto 0) := x"40000004";
    constant IVT_2 : std_logic_vector(31 downto 0) := x"40000008";
    constant IVT_3 : std_logic_vector(31 downto 0) := x"4000000C";
    constant IVT_4 : std_logic_vector(31 downto 0) := x"40000010";

    constant PR_0  : std_logic_vector(31 downto 0) := x"40000014";
    constant PR_1  : std_logic_vector(31 downto 0) := x"40000018";
    constant PR_2  : std_logic_vector(31 downto 0) := x"4000001C";
    constant PR_3  : std_logic_vector(31 downto 0) := x"40000020";
    constant PR_4  : std_logic_vector(31 downto 0) := x"40000024";

    constant sevenSegmentDisplayControl : std_logic_vector(31 downto 0) := x"40000028";
    constant sevenSegmentDisplayData    : std_logic_vector(31 downto 0) := x"4000002C";

    constant clockControllerPrescaler   : std_logic_vector(31 downto 0) := x"40000030";

    constant serialInterfacePrescaler   : std_logic_vector(31 downto 0) := x"40000034";
    

    --memory mapped devices

    --interrupt vector table
    type vector_array is array (0 to numInterrupts-1) of std_logic_vector(31 downto 0);
    --initiliazing default addresses
    signal IVT : vector_array := (
    0 => x"DEADBEEF",  
    1 => x"12345678",  
    2 => x"FEDCBA98",  
    3 => x"CAFEBABE",  
    4 => x"87654321",  
    others => (others => '0'));  

    --interrupt priority register
    type priority_arary is array (0 to numInterrupts-1) of std_logic_vector(2 downto 0);
    --initializing default priorities
    signal PR : priority_arary := (
        0 => "000",  
        1 => "011",  
        2 => "010",  
        3 => "011",  
        4 => "111",  
    others => (others => '0'));

    --seven segement display
    --Registers
    signal SevenSegmentDisplayDataReg         : std_logic_vector(31 downto 0);
    signal SevenSegmentDisplayControlReg      : std_logic_vector(31 downto 0);
    component IO_SevenSegmentDisplays is
        generic(
            numDisplays : integer := 4
        );
        Port (
            enable                   : in std_logic;
            reset                    : in std_logic;
            clk                      : in std_logic;
            seg                      : out std_logic_vector(6 downto 0);
            an                       : out std_logic_vector(numDisplays-1 downto 0);
            dataIn                   : in std_logic_vector(31 downto 0);
            controlIn                : in std_logic_vector(31 downto 0)
          );
    end component;

    --clock Controller
    --Registers
    signal clockControllerPrescalerReg : std_logic_vector(31 downto 0);
    --signals
    signal alteredClk : std_logic;
    component clockController is
        Port ( 
            reset            : in std_logic;
            clk              : in std_logic;
            enable           : in std_logic;
            manualClk        : in std_logic;
            manualClocking   : in std_logic;
            alteredClk       : out std_logic;
            prescalerIn      : in std_logic_vector(31 downto 0)
        );
    end component;

    --serialInterface
    --Registers
    signal serialInterfacePrescalerReg : std_logic_vector(31 downto 0);
    component serialInterface is
        generic(
            numInterrupts :integer := 5
        );
        Port (
                clk                : in std_logic;
                reset              : in std_logic;
                enable             : in std_logic;
                debugMode          : in std_logic;
    
                rx                 : in std_logic;
                tx                 : out std_logic;
    
                prescaler          : in std_logic_vector(31 downto 0);
                debugSignals       : in std_logic_vector(994+numInterrupts-1 downto 0)
        );
    end component;
    
    --internal signals
    signal debug : std_logic_vector(994+numInterrupts-1 downto 0);
begin
    --connecting relevant signals to debug signals
    debug <= SevenSegmentDisplayDataReg & SevenSegmentDisplayControlReg & clockControllerPrescalerReg & serialInterfacePrescalerReg & debugSignals;
    --writing to memory mapped registers
    process(clk, reset)
    begin
        if reset = '1' then
            null;

        elsif rising_edge(clk) then
            if enable = '1' then
                if alteredClk = '1' then
                    case address is
                        when IVT_0 => IVT(0) <= dataIn;
                        when IVT_1 => IVT(1) <= dataIn;
                        when IVT_2 => IVT(2) <= dataIn;
                        when IVT_3 => IVT(3) <= dataIn;
                        when IVT_4 => IVT(4) <= dataIn;
                        when PR_0  => PR(0) <= dataIn;
                        when PR_1  => PR(1) <= dataIn;
                        when PR_2  => PR(2) <= dataIn;
                        when PR_3  => PR(3) <= dataIn;
                        when PR_4  => PR(4) <= dataIn;

                        when sevenSegmentDisplayControl => SevenSegmentDisplayControlReg <= dataIn;
                        when sevenSegmentDisplayData    => SevenSegmentDisplayDataReg    <= dataIn;

                        when clockControllerPrescaler => clockControllerPrescalerReg <= dataIn;
                        
                        when serialInterfacePrescaler => serialInterfacePrescalerReg <= dataIn;

                        when others => null;

                    end case;
                end if;
            end if;
        end if;
    end process;

    --reading from memory mapped registers
    process(address, IVT, PR, SevenSegmentDisplayDataReg, SevenSegmentDisplayControlReg)
    begin
        case address is 
            when IVT_0 => dataOut <= IVT(0);
            when IVT_1 => dataOut <= IVT(1);
            when IVT_2 => dataOut <= IVT(2);
            when IVT_3 => dataOut <= IVT(3);
            when IVT_4 => dataOut <= IVT(4);
            when PR_0 => dataOut <= PR(0);
            when PR_1 => dataOut <= PR(1);
            when PR_2 => dataOut <= PR(2);
            when PR_3 => dataOut <= PR(3);
            when PR_4 => dataOut <= PR(4);

            when sevenSegmentDisplayControl => dataOut <= SevenSegmentDisplayControlReg;
            when sevenSegmentDisplayData    => dataOut <= SevenSegmentDisplayDataReg;

            when clockControllerPrescaler => dataOut <= clockControllerPrescalerReg;

            when serialInterfacePrescaler => dataOut <= serialInterfacePrescalerReg;
        end case;
    end process;
    
    --connecting the IVT and PR to output so the interrupt controller can use them directly
    process(IVT, PR)
    begin
        for i in 0 to numInterrupts-1 loop
            IVT_out((i+1)*32-1 downto i*32) <= IVT(numInterrupts-1-i);
            PR_out((i+1)*3-1 downto i*3) <= PR(numInterrupts-1-i);
        end loop;
    end process;

    --connecting components to their signals
    IO_SevenSegmentDisplay_inst : IO_SevenSegmentDisplays
    generic map(
        numDisplays => numSevenSegmentDisplays
    )
    port map(
        enable      => enable,               
        reset       => reset,   
        clk         => clk,          
        seg         => seg,         
        an          => an,         
        dataIn      => SevenSegmentDisplayDataReg,    
        controlIn   => SevenSegmentDisplayControlReg         
    );


    clockController_inst : clockController
    port map(
        reset               => reset,
        clk                 => clk,
        enable              => enable,
        manualClk           => manualClk,
        manualClocking      => manualClocking,
        alteredClk          => alteredClk,
        prescalerIn         => clockControllerPrescalerReg
    );
    alteredClkOut <= alteredClk;

    serialInterface_inst : serialInterface
    generic map(
        numInterrupts => numInterrupts
    )
    port map(
        reset               => reset,
        clk                 => clk,
        enable              => enable,
        debugMode           => debugMode,
        rx                  => rx,
        tx                  => tx,
        debugSignals        => debug,
        prescaler           => serialInterfacePrescalerReg
    );
    
end Behavioral;
