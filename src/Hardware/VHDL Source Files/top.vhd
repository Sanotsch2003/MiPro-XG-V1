library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.helperPackage.all;

--interrupts:
--0: invalidAddressInterrupt
--1: addressAlignmentInterrupt

entity top is
    Generic(
        --You might need to change the following generics in order for the code to work on your specific hardware:
        numDigitalIO_Pins                        : integer := 16;
        numSevenSegmentDisplays     		       : integer := 6;
		  individualSevenSegmentDisplayControll    : boolean := true;
        memSize                     			 	 : integer := 1024;
        invertResetBtn                           : boolean := true;
        FPGA_Platform                            : string := "intel";
        CLKFBOUT_MULT_F                          : real := 1.0;    -- Feedback multiplier
        CLKOUT0_DIVIDE_F                         : real := 1.0;    -- Divide factor
        CLKIN1_PERIOD                            : real := 20.0;    -- Input clock period (nano seconds)
        defaultSerialInterfacePrescaler          : integer := 5208; --9600 baud @25mHz 
        
        --Changing these values will break the code:
        numCPU_CoreDebugSignals     			 : integer := 868;
        numExternalDebugSignals     			 : integer := 152;
        
        --You might want to change the numMMIO_Interrupts value when adding a new MMIO device that should support interrupts. 
        numMMIO_Interrupts                       : integer := 5;
        numCPU_Interrupts                        : integer := 2;
        numOther_Interrupts                      : integer := 1
        
        
    );
    Port ( 
        externalClk         : in std_logic;
        resetBtn            : in std_logic; --middle button
        enableSw            : in std_logic; --switch 15
        manualClocking      : in std_logic; --swtich 14
        debugMode           : in std_logic; --switch 13
        programmingMode     : in std_logic; --switch 12
        manualClk           : in std_logic; --down button

        tx                  : out std_logic; 
        rx                  : in std_logic;

        sevenSegmentLEDs    : out seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays)-1 downto 0);
        sevenSegmentAnodes  : out std_logic_vector(numSevenSegmentDisplays - 1 downto 0);
        
        digitalIO_pins      : inout std_logic_vector(numDigitalIO_Pins-1 downto 0)
    );
end top;

architecture Behavioral of top is
    constant numInterrupts : integer := numMMIO_Interrupts + numCPU_Interrupts + numOther_Interrupts;
    constant numExternalInterrupts : integer := numMMIO_Interrupts + numOther_Interrupts;
    
   component pllClockGenerator is
       generic (
            CLKFBOUT_MULT_F : real := 5.0;  -- Feedback multiplier
            CLKOUT0_DIVIDE_F : real := 10.0; -- Divide factor
            CLKIN1_PERIOD : real := 10.0    -- Input clock period (100 MHz)
        );
        port (
            clk_in    : in  std_logic;  -- 100 MHz input clock
            reset     : in  std_logic;  -- Reset signal
            clk_out   : out std_logic;  -- 50 MHz output clock
            locked    : out std_logic   -- Locked signal
        );
    end component;
    
    component CPU_Core is
        Generic(
            numExternalInterrupts    : integer;
            numInterrupts            : integer;
            numCPU_CoreDebugSignals  : integer
        );
    
        Port (
            enable                  : in std_logic;
            hardwareReset           : in std_logic;
            clk                     : in std_logic;
            alteredClk              : in std_logic;
    
            programmingMode         : in std_logic;
    
            dataFromMem             : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
            addressOut              : out std_logic_vector(31 downto 0);
            
            memWriteReq             : out std_logic;
            memReadReq              : out std_logic;
            softwareReset           : out std_logic;
            memOpFinished           : in std_logic;
    
            --interupt vector table and interrupt priority register
            IVT                     : in std_logic_vector(numInterrupts*32-1 downto 0);
            IPR                     : in std_logic_vector(numInterrupts*3-1 downto 0);
    
            externalInterrupts      : in std_logic_vector(numExternalInterrupts-1 downto 0); --there are no internal interrupts so far
            externalInterruptsClr : out std_logic_vector(numExternalInterrupts-1 downto 0); 
    
            --debugging
            debug                   : out std_logic_vector(numCPU_CoreDebugSignals-1 downto 0)
        );
    end component;

    component memoryMapping is
        generic(
            defaultSerialInterfacePrescaler         : integer;
            numDigitalIO_Pins                       : integer;
            numSevenSegmentDisplays                 : integer;
            numCPU_CoreDebugSignals                 : integer;
            individualSevenSegmentDisplayControll   : boolean;
            numExternalDebugSignals                 : integer;
            numInterrupts                           : integer;
            numMMIO_Interrupts                      : integer 
        );
        port (
              enable                       : in std_logic;
              reset                        : in std_logic;
              clk                          : in std_logic;
        
              writeEn                      : in std_logic;
              readEn                       : in std_logic;
              address                      : in std_logic_vector(31 downto 0);
              dataIn                       : in std_logic_vector(31 downto 0);
              dataOut                      : out std_logic_vector(31 downto 0);
              memOpFinished                : out std_logic;
        
        
              --Interrupt handling
              IVT_out                      : out std_logic_vector(32 * numInterrupts - 1 downto 0);
              IPR_out                       : out std_logic_vector(3 * numInterrupts -1 downto 0);
              interrupts                   : out std_logic_vector(numMMIO_Interrupts-1 downto 0);
              interruptsClr                : in std_logic_vector(numMMIO_Interrupts-1 downto 0);
        
              --seven segment display
              sevenSegmentLEDs    		   : out seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays)-1 downto 0);
              sevenSegmentAnodes           : out std_logic_vector(numSevenSegmentDisplays-1 downto 0);
        
              --clock controller
              alteredClkOut                : out std_logic;
              manualClk                    : in std_logic;
              manualClocking               : in std_logic;
              programmingMode              : in std_logic;
        
              --Serial interface      
              tx                           : out std_logic;
              rx                           : in std_logic;
              debugMode                    : in std_logic;
              
              --IO pins
              digitalIO_pins               : inout std_logic_vector(numDigitalIO_Pins-1 downto 0);
        
              --debugging
              CPU_CoreDebugSignals         : in std_logic_vector(numCPU_CoreDebugSignals-1 downto 0)

    );
    end component;

    component RAM is
        generic(
            ramSize : integer
        );
        port (
            enable                     : in std_logic;
            clk                        : in std_logic;
            reset                      : in std_logic;
            alteredClk                 : in std_logic;
            address                    : in std_logic_vector(31 downto 0);
            dataIn                     : in std_logic_vector(31 downto 0);
            dataOut                    : out std_logic_vector(31 downto 0);
            writeEn                    : in std_logic;
            readEn                     : in std_logic;
            memOpFinished              : out std_logic
        );
    end component;

    component addressDecoder is
        generic(
            memSize                     : integer
        );
        Port (
            enable                           : in std_logic;
            clk                              : in std_logic;
            reset                            : in std_logic;
    
            address                          : in std_logic_vector(31 downto 0);
            memReadReq                       : in std_logic;
            memWriteReq                      : in std_logic;
    
            ramMemOpFinished                 : in std_logic;
            MemoryMappedDevicesMemOpFinished : in std_logic;
            memOpFinished                    : out std_logic;
    
            ramWriteEn                       : out std_logic;
            ramReadEn                        : out std_logic;
    
            memoryMappedDevicesWriteEn       : out std_logic;
            memoryMappedDevicesReadEn        : out std_logic;
    
            dataFromMem                      : in std_logic_vector(31 downto 0);
            dataFromMemoryMappedDevices      : in std_logic_vector(31 downto 0);
            dataOut                          : out std_logic_vector(31 downto 0);
    
            --interrupts
            addressAlignmentInterrupt        : out std_logic;
            addressAlignmentInterruptClr     : in std_logic
        );
    end component;
    
    --internal signals
    --Address Decoder
    signal dataFromAddressDecoder           : std_logic_vector(31 downto 0);
    signal memOpFinishedFromAddressDecoder  : std_logic;
    signal RAM_writeEn                      : std_logic;
    signal RAM_readEn                       : std_logic;
    signal MemoryMappingWriteEn             : std_logic;
    signal MemoryMappingReadEn              : std_logic;

    --Memory Mapping
    signal IVT                                  : std_logic_vector(32 * numInterrupts - 1 downto 0);
    signal IPR                                  : std_logic_vector(3 * numInterrupts -1 downto 0);
    signal memOpFinishedFromMemoryMapping       : std_logic;
    signal dataFromMemoryMapping                : std_logic_vector(31 downto 0);
    signal alteredClk                           : std_logic;
    signal addressDevidedByFour                 : std_logic_vector(31 downto 0);

    --CPU Core
    signal InterruptsClr            : std_logic_vector(numExternalInterrupts-1 downto 0);
    signal interrupts               : std_logic_vector(numExternalInterrupts-1 downto 0);
    signal debugFromCPU_Core        : std_logic_vector(numCPU_CoreDebugSignals-1 downto 0);
    signal dataFromCPU_Core         : std_logic_vector(31 downto 0);
    signal addressFromCPU_Core      : std_logic_vector(31 downto 0);
    signal memReadReqFromCPU_Core   : std_logic;
    signal memWriteReqFromCPU_Core  : std_logic;
    signal softwareReset            : std_logic;

    --RAM
    signal dataFromRam          : std_logic_vector(31 downto 0);
    signal memOpFinishedFromRAM : std_logic;

    --others
    signal reset      : std_logic;
    signal internalClk : std_logic;
    signal clkLocked : std_logic;
    signal enable : std_logic;
    
    signal resetBtnWire : std_logic;


begin
    process(resetBtn)
    begin
    if invertResetBtn then
        resetBtnWire <= not resetBtn;
    else 
        resetBtnWire <= resetBtn;
    end if;
    end process;

    --connecting all interrupts to the interrupts signal
    reset      <= resetBtnWire or softwareReset;
    enable     <= enableSw and clkLocked;
    
    addressDevidedByFour <= "00" & addressFromCPU_Core(31 downto 2);
    
   ClockGenerator : pllClockGenerator 
    generic map(
        CLKFBOUT_MULT_F  => CLKFBOUT_MULT_F,
        CLKOUT0_DIVIDE_F => CLKOUT0_DIVIDE_F,
        CLKIN1_PERIOD    => CLKIN1_PERIOD
    )
    port map (
        clk_in              => externalClk,
        reset               => reset,
        clk_out             => internalClk,
        locked              => clkLocked
    );

    CPU_Core_inst : CPU_Core
    generic map(
        numInterrupts => numInterrupts,
        numExternalInterrupts => numExternalInterrupts,
        numCPU_CoreDebugSignals => numCPU_CoreDebugSignals
    )
    port map(
        --inputs
        enable                  => enable,
        hardwareReset           => resetBtnWire,
        clk                     => internalClk,
        alteredClk              => alteredClk,
        programmingMode         => programmingMode,
        dataFromMem             => dataFromAddressDecoder,
        memOpFinished           => memOpFinishedFromAddressDecoder,
        IVT                     => IVT,
        IPR                     => IPR,
        externalInterrupts      => interrupts,
        --outputs
        externalInterruptsClr   => interruptsClr,
        debug                   => debugFromCPU_Core,
        dataOut                 => dataFromCPU_Core,
        addressOut              => addressFromCPU_Core,
        
        memReadReq              => memReadReqFromCPU_Core,
        memWriteReq             => memWriteReqFromCPU_Core,
        softwareReset           => softwareReset
    );

    memoryMapping_inst : memoryMapping
    generic map(
        defaultSerialInterfacePrescaler         => defaultSerialInterfacePrescaler,
        numDigitalIO_Pins                       => numDigitalIO_Pins,
        numSevenSegmentDisplays                 => numSevenSegmentDisplays,
        numCPU_CoreDebugSignals                 => numCPU_CoreDebugSignals,
        numExternalDebugSignals                 => numExternalDebugSignals,
        individualSevenSegmentDisplayControll   => individualSevenSegmentDisplayControll,
        numInterrupts                           => numInterrupts,
        numMMIO_Interrupts                      => numMMIO_Interrupts
    )
    port map(
        --inputs
        enable                       => enable,
        reset                        => reset,
        clk                          => internalClk,
        writeEn                      => MemoryMappingWriteEn,
        readEn                       => MemoryMappingReadEn,
        address                      => addressFromCPU_Core,
        dataIn                       => dataFromCPU_Core,
        manualClk                    => manualClk,
        manualClocking               => manualClocking,
        programmingMode              => programmingMode,
        rx                           => rx,
        debugMode                    => debugMode,
        CPU_CoreDebugSignals         => debugFromCPU_Core,
        interruptsClr                => interruptsClr(numExternalInterrupts-1 downto numOther_Interrupts),     

        --outputs
        interrupts                   => interrupts(numExternalInterrupts-1 downto numOther_Interrupts),
        tx                           => tx,
        dataOut                      => dataFromMemoryMapping,
        memOpFinished                => memOpFinishedFromMemoryMapping,
        IVT_out                      => IVT,
        IPR_out                      => IPR,
        sevenSegmentLEDs             => sevenSegmentLEDs,
        sevenSegmentAnodes           => sevenSegmentAnodes,
        digitalIO_pins               => digitalIO_pins,
        alteredClkOut                => alteredClk
    );

    ram_inst : ram
    generic map(
        ramSize => memSize
    )
    port map(
        enable                     => enable,
        clk                        => internalClk,
        reset                      => reset,
        address                    => addressDevidedByFour, --address divided by four
        dataIn                     => dataFromCPU_Core,
        dataOut                    => dataFromRam,
        writeEn                    => RAM_writeEn,
        alteredClk                 => alteredClk,
        readEn                     => RAM_readEn,
        memOpFinished              => memOpFinishedFromRAM
    );

    addressDecoder_inst : addressDecoder
    generic map(
        memSize                          => memSize
    )
    port map(
        --inputs
        enable                           => enable,
        clk                              => internalClk,
        reset                            => reset,
        address                          => addressFromCPU_Core,
        memReadReq                       => memReadReqFromCPU_Core,
        memWriteReq                      => memWriteReqFromCPU_Core,
        ramMemOpFinished                 => memOpFinishedFromRAM,
        MemoryMappedDevicesMemOpFinished => memOpFinishedFromMemoryMapping,
        dataFromMemoryMappedDevices      => dataFromMemoryMapping,
        dataFromMem                      => dataFromRam,
        addressAlignmentInterruptClr     => interruptsClr(0),
        --outputs
        memOpFinished                    => memOpFinishedFromAddressDecoder,
        ramWriteEn                       => RAM_writeEn,
        ramReadEn                        => RAM_readEn,
        memoryMappedDevicesWriteEn       => MemoryMappingWriteEn,
        memoryMappedDevicesReadEn        => MemoryMappingReadEn,
        dataOut                          => dataFromAddressDecoder,
        addressAlignmentInterrupt        => interrupts(0)
    );

end Behavioral;
