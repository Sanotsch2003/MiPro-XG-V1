library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--interrupts:
--0: invalidAddressInterrupt
--1: addressAlignmentInterrupt

entity top is
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
        resetBtn            : in std_logic; --middle button
        enable              : in std_logic; --switch 15
        manualClocking      : in std_logic; --swtich 14
        debugMode           : in std_logic; --switch 13
        programmingMode     : in std_logic; --switch 12
        manualClk           : in std_logic; --down button

        tx                  : out std_logic; 
        rx                  : in std_logic;

        sevenSegmentLEDs    : out std_logic_vector(6 downto 0);
        sevenSegmentAnodes  : out std_logic_vector(numSevenSegmentDisplays - 1 downto 0)

        
    );
end top;

architecture Behavioral of top is
    component CPU_Core is
        Generic(
            numInterrupts            : integer := 10;
            numCPU_CoreDebugSignals  : integer := 867
        );
    
        Port (
            enable                  : in std_logic;
            hardwareReset           : in std_logic;
            clk                     : in std_logic;
            alteredClk            : in std_logic;
    
            programmingMode         : in std_logic;
    
            dataIn                  : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
            addressOut              : out std_logic_vector(31 downto 0);
            
            memWriteReq             : out std_logic;
            memReadReq              : out std_logic;
            softwareReset           : out std_logic;
            memOpFinished           : in std_logic;
    
            --interupt vector table and interrupt priority register
            IVT                     : in std_logic_vector(numInterrupts*32-1 downto 0);
            PR                      : in std_logic_vector(numInterrupts*3-1 downto 0);
    
            externalInterrupts      : in std_logic_vector(numInterrupts-1 downto 0); --there are no internal interrupts so far
            clearExternalInterrupts : out std_logic_vector(numInterrupts-1 downto 0); 
    
            --debugging
            debug                   : out std_logic_vector(numCPU_CoreDebugSignals+numInterrupts-1 downto 0)
        );
    end component;

    component memoryMapping is
        generic(
            numInterrupts            : integer := 10;
            numSevenSegmentDisplays  : integer := 4;
            numCPU_CoreDebugSignals  : integer := 867;
            numExternalDebugSignals  : integer := 128
        );
        Port (
            enable                  : in std_logic;
            reset                   : in std_logic;
            clk                     : in std_logic;
    
            writeEn                 : in std_logic;
            readEn                  : in std_logic;
            address                 : in std_logic_vector(31 downto 0);
            dataIn                  : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
            memOpFinished           : out std_logic;
    
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
            CPU_CoreDebugSignals    : in std_logic_vector(numCPU_CoreDebugSignals+numInterrupts-1 downto 0)
    
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
            dataIn                     : in std_logic_vector(31 downto 0);
            dataOut                    : out std_logic_vector(31 downto 0);
            writeEn                    : in std_logic;
            readEn                     : in std_logic;
            memOpFinished              : out std_logic
        );
    end component;

    component addressDecoder is
        generic(
            memSize                     : integer := 2048;
            memoryMappedAddressesStart  : integer := 1073741824;
            memoryMappedAddressesEnd    : integer := 1073741916
        );
        Port (
            enable                           : in std_logic;
            clk                              : in std_logic;
            alteredClk                       : in std_logic;
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
            invalidAddressInterrupt          : out std_logic;
    
            addressAlignmentInterruptReset   : in std_logic;
            invalidAddressInterruptReset     : in std_logic
        );
    end component;
    
    --internal signals
    --Address Decoder
    signal dataFromAddressDecoder           : std_logic_vector(31 downto 0);
    signal memOpFinishedFromAddressDecoder  : std_logic;
    signal addressAlignmentInterrupt        : std_logic;
    signal invalidAddressInterrupt          : std_logic;
    signal RAM_writeEn                      : std_logic;
    signal RAM_readEn                       : std_logic;
    signal MemoryMappingWriteEn             : std_logic;
    signal MemoryMappingReadEn              : std_logic;

    --Memory Mapping
    signal IVT                                  : std_logic_vector(32 * numInterrupts - 1 downto 0);
    signal PR                                   : std_logic_vector(3 * numInterrupts -1 downto 0);
    signal memOpFinishedFromMemoryMapping       : std_logic;
    signal dataFromMemoryMapping                : std_logic_vector(31 downto 0);
    signal alteredClk                           : std_logic;

    --CPU Core
    signal clearInterrupts     : std_logic_vector(numInterrupts-1 downto 0);
    signal debugFromCPU_Core   : std_logic_vector(numCPU_CoreDebugSignals+numInterrupts-1 downto 0);
    signal dataFromCPU_Core    : std_logic_vector(31 downto 0);
    signal addressFromCPU_Core : std_logic_vector(31 downto 0);
    signal memReadReqFromCPU_Core  : std_logic;
    signal memWriteReqFromCPU_Core : std_logic;
    signal softwareReset       : std_logic;

    --RAM
    signal dataFromRam          : std_logic_vector(31 downto 0);
    signal memOpFinishedFromRAM : std_logic;

    --others
    signal interrupts : std_logic_vector(numInterrupts-1 downto 0);
    signal reset      : std_logic;

begin
    --connecting all interrupts to the interrupts signal
    interrupts <= "00000000" & addressAlignmentInterrupt & invalidAddressInterrupt;
    reset      <= resetBtn or softwareReset;

    CPU_Core_inst : CPU_Core
    generic map(
        numInterrupts => numInterrupts
    )
    port map(
        --inputs
        enable                  => enable,
        hardwareReset           => resetBtn,
        clk                     => clk,
        alteredClk              => alteredClk,
        programmingMode         => programmingMode,
        dataIn                  => dataFromAddressDecoder,
        memOpFinished           => memOpFinishedFromAddressDecoder,
        IVT                     => IVT,
        PR                      => PR,
        externalInterrupts      => interrupts,
        --outputs
        clearExternalInterrupts => clearInterrupts,
        debug                   => debugFromCPU_Core,
        dataOut                 => dataFromCPU_Core,
        addressOut              => addressFromCPU_Core,
        
        memReadReq              => memReadReqFromCPU_Core,
        memWriteReq             => memWriteReqFromCPU_Core,
        softwareReset           => softwareReset
    );

    memoryMapping_inst : memoryMapping
    generic map(
        numInterrupts           => numInterrupts,
        numSevenSegmentDisplays => numSevenSegmentDisplays,
        numCPU_CoreDebugSignals => numCPU_CoreDebugSignals,
        numExternalDebugSignals => numExternalDebugSignals
    )
    port map(
        --inputs
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        writeEn                 => MemoryMappingWriteEn,
        readEn                  => MemoryMappingReadEn,
        address                 => addressFromCPU_Core,
        dataIn                  => dataFromCPU_Core,
        manualClk               => manualClk,
        manualClocking          => manualClocking,
        rx                      => rx,
        debugMode               => debugMode,
        CPU_CoreDebugSignals    => debugFromCPU_Core,
        --outputs
        tx                      => tx,
        dataOut                 => dataFromMemoryMapping,
        memOpFinished           => memOpFinishedFromMemoryMapping,
        IVT_out                 => IVT,
        PR_out                  => PR,
        seg                     => sevenSegmentLEDs,
        an                      => sevenSegmentAnodes,
        alteredClkOut           => alteredClk
    );

    ram_inst : ram
    generic map(
        ramSize => memSize
    )
    port map(
        enable                     => enable,
        clk                        => clk,
        alteredClk                 => alteredClk,
        reset                      => reset,
        address                    => addressFromCPU_Core,
        dataIn                     => dataFromCPU_Core,
        dataOut                    => dataFromRam,
        writeEn                    => RAM_writeEn,
        readEn                     => RAM_readEn,
        memOpFinished              => memOpFinishedFromRAM
    );

    addressDecoder_inst : addressDecoder
    generic map(
        memSize                          => memSize,
        memoryMappedAddressesStart       => memoryMappedAddressesStart,
        memoryMappedAddressesEnd         => memoryMappedAddressesEnd
    )
    port map(
        --inputs
        enable                           => enable,
        clk                              => clk,
        alteredClk                       => alteredClk,
        reset                            => reset,
        address                          => addressFromCPU_Core,
        memReadReq                       => memReadReqFromCPU_Core,
        memWriteReq                      => memWriteReqFromCPU_Core,
        ramMemOpFinished                 => memOpFinishedFromRAM,
        MemoryMappedDevicesMemOpFinished => memOpFinishedFromMemoryMapping,
        dataFromMemoryMappedDevices      => dataFromMemoryMapping,
        dataFromMem                      => dataFromRam,
        addressAlignmentInterruptReset   => clearInterrupts(1),
        invalidAddressInterruptReset     => clearInterrupts(0),
        --outputs
        memOpFinished                    => memOpFinishedFromAddressDecoder,
        ramWriteEn                       => RAM_writeEn,
        ramReadEn                        => RAM_readEn,
        memoryMappedDevicesWriteEn       => MemoryMappingWriteEn,
        memoryMappedDevicesReadEn        => MemoryMappingReadEn,
        dataOut                          => dataFromAddressDecoder,
        addressAlignmentInterrupt        => addressAlignmentInterrupt,
        invalidAddressInterrupt          => invalidAddressInterrupt

    );

end Behavioral;