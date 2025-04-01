LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.helperPackage.ALL;

--interrupts:
--0: invalidAddressInterrupt
--1: addressAlignmentInterrupt

ENTITY top IS
    GENERIC (
        --General settings:
        numDigitalIO_Pins                     : INTEGER := 16;
        numSevenSegmentDisplays               : INTEGER := 4;     --Basys 3 : 4, DE10-Lite : 6
        individualSevenSegmentDisplayControll : BOOLEAN := false; --Basys 3 : false, DE10-Lite : true
        memSize                               : INTEGER := 4096;
        invertResetBtn                        : BOOLEAN := false; --Basys 3 : false, DE10-Lite : true
        FPGA_Platform                         : STRING  := "amd"; --Basys 3 : "amd", DE10-Lite : "intel"

        --System clock settings:
        sysClkMultiplier  : real := 10.0; --Basys 3 : 20.0, DE10-Lite : 1.0
        sysClkDivider     : real := 20.0; --Basys 3 : 20.0, DE10-Lite : 1.0
        externalClkPeriod : real := 10.0; --Basys 3 : 10.0, DE10-Lite : 20.0

        --Baud rate settings (The prescaler is applied to the internal clock):
        defaultSerialInterfacePrescaler : INTEGER := 434; -- 434: 115200 baud (@50mHz),  5208: 9600 baud (@50mHz)

        --VGA clock settings (The VGA clock is created using the external clock and must have a frequency of 25mHz):
        VGA_ClkMultiplier : real := 10.0; --Basys 3 : 10.0, DE10-Lite : 1.0
        VGA_ClkDivider    : real := 40.0; --Basys 3 : 40.0, DE10-Lite : 2.0

        --Changing these values should only be done when changes inside the code require it:
        numCPU_CoreDebugSignals : INTEGER := 868;
        numExternalDebugSignals : INTEGER := 432;
        numMMIO_Interrupts      : INTEGER := 5;
        numCPU_Interrupts       : INTEGER := 2;
        numOther_Interrupts     : INTEGER := 1
    );
    PORT (
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
END top;

ARCHITECTURE Behavioral OF top IS
    CONSTANT numInterrupts         : INTEGER := numMMIO_Interrupts + numCPU_Interrupts + numOther_Interrupts;
    CONSTANT numExternalInterrupts : INTEGER := numMMIO_Interrupts + numOther_Interrupts;

    COMPONENT clockGenerator IS
        GENERIC (
            CLKFBOUT_MULT_F  : real := 5.0;  -- Feedback multiplier
            CLKOUT0_DIVIDE_F : real := 10.0; -- Divide factor
            CLKIN1_PERIOD    : real := 10.0  -- Input clock period (100 MHz)
        );
        PORT (
            clk_in  : IN STD_LOGIC;  -- 100 MHz input clock
            reset   : IN STD_LOGIC;  -- Reset signal
            clk_out : OUT STD_LOGIC; -- 50 MHz output clock
            locked  : OUT STD_LOGIC  -- Locked signal
        );
    END COMPONENT;

    COMPONENT CPU_Core IS
        GENERIC (
            numExternalInterrupts   : INTEGER;
            numInterrupts           : INTEGER;
            numCPU_CoreDebugSignals : INTEGER
        );

        PORT (
            enable     : IN STD_LOGIC;
            reset      : IN STD_LOGIC;
            clk        : IN STD_LOGIC;
            alteredClk : IN STD_LOGIC;

            programmingMode : IN STD_LOGIC;

            dataFromMem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataOut     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            addressOut  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            memWriteReq   : OUT STD_LOGIC;
            memReadReq    : OUT STD_LOGIC;
            softwareReset : OUT STD_LOGIC;
            memOpFinished : IN STD_LOGIC;

            --interupt vector table and interrupt priority register
            IVT : IN STD_LOGIC_VECTOR(numInterrupts * 32 - 1 DOWNTO 0);
            IPR : IN STD_LOGIC_VECTOR(numInterrupts * 3 - 1 DOWNTO 0);

            externalInterrupts    : IN STD_LOGIC_VECTOR(numExternalInterrupts - 1 DOWNTO 0); --there are no internal interrupts so far
            externalInterruptsClr : OUT STD_LOGIC_VECTOR(numExternalInterrupts - 1 DOWNTO 0);

            --debugging
            debug : OUT STD_LOGIC_VECTOR(numCPU_CoreDebugSignals - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT memoryMapping IS
        GENERIC (
            defaultSerialInterfacePrescaler       : INTEGER;
            numDigitalIO_Pins                     : INTEGER;
            numSevenSegmentDisplays               : INTEGER;
            numCPU_CoreDebugSignals               : INTEGER;
            individualSevenSegmentDisplayControll : BOOLEAN;
            numExternalDebugSignals               : INTEGER;
            numInterrupts                         : INTEGER;
            numMMIO_Interrupts                    : INTEGER
        );
        PORT (
            enable : IN STD_LOGIC;
            reset  : IN STD_LOGIC;
            clk    : IN STD_LOGIC;

            writeEn       : IN STD_LOGIC;
            readEn        : IN STD_LOGIC;
            address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataIn        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataOut       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            memOpFinished : OUT STD_LOGIC;
            --Interrupt handling
            IVT_out       : OUT STD_LOGIC_VECTOR(32 * numInterrupts - 1 DOWNTO 0);
            IPR_out       : OUT STD_LOGIC_VECTOR(3 * numInterrupts - 1 DOWNTO 0);
            interrupts    : OUT STD_LOGIC_VECTOR(numMMIO_Interrupts - 1 DOWNTO 0);
            interruptsClr : IN STD_LOGIC_VECTOR(numMMIO_Interrupts - 1 DOWNTO 0);

            --seven segment display
            sevenSegmentLEDs   : OUT seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays) - 1 DOWNTO 0);
            sevenSegmentAnodes : OUT STD_LOGIC_VECTOR(numSevenSegmentDisplays - 1 DOWNTO 0);

            --clock controller
            alteredClkOut   : OUT STD_LOGIC;
            manualClk       : IN STD_LOGIC;
            manualClocking  : IN STD_LOGIC;
            programmingMode : IN STD_LOGIC;

            --Serial interface      
            tx        : OUT STD_LOGIC;
            rx        : IN STD_LOGIC;
            debugMode : IN STD_LOGIC;

            --IO pins
            digitalIO_pins : INOUT STD_LOGIC_VECTOR(numDigitalIO_Pins - 1 DOWNTO 0);

            --debugging
            CPU_CoreDebugSignals : IN STD_LOGIC_VECTOR(numCPU_CoreDebugSignals - 1 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT RAM IS
        GENERIC (
            ramSize : INTEGER
        );
        PORT (
            clk           : IN STD_LOGIC;
            reset         : IN STD_LOGIC;
            address       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataIn        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataOut       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            writeEn       : IN STD_LOGIC;
            readEn        : IN STD_LOGIC;
            memOpFinished : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT addressDecoder IS
        GENERIC (
            memSize : INTEGER
        );
        PORT (
            enable : IN STD_LOGIC;
            clk    : IN STD_LOGIC;
            reset  : IN STD_LOGIC;

            address     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            memReadReq  : IN STD_LOGIC;
            memWriteReq : IN STD_LOGIC;

            ramMemOpFinished                 : IN STD_LOGIC;
            MemoryMappedDevicesMemOpFinished : IN STD_LOGIC;
            memOpFinished                    : OUT STD_LOGIC;

            ramWriteEn : OUT STD_LOGIC;
            ramReadEn  : OUT STD_LOGIC;

            memoryMappedDevicesWriteEn : OUT STD_LOGIC;
            memoryMappedDevicesReadEn  : OUT STD_LOGIC;

            imageBufferWriteEn : OUT STD_LOGIC;

            dataFromMem                 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataFromMemoryMappedDevices : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataFromImageBuffer         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataOut                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            --interrupts
            addressAlignmentInterrupt    : OUT STD_LOGIC;
            addressAlignmentInterruptClr : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT VGA_Controller IS
        PORT (
            enable  : IN STD_LOGIC;
            reset   : IN STD_LOGIC;
            VGA_clk : IN STD_LOGIC;

            --Signals for interacting with image buffer
            readAddress : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
            dataIn      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            --VGA ports
            VGA_Blue  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            VGA_GREEN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            VGA_RED   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            H_Sync    : OUT STD_LOGIC;
            V_Sync    : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT VGA_ImageBuffer IS
        PORT (
            -- System interface
            sysClk     : IN STD_LOGIC;
            writeEn    : IN STD_LOGIC;
            sysAddress : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            sysDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sysDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            -- VGA Controller Interface (Read-Only)
            VGA_Clk     : IN STD_LOGIC;
            VGA_Address : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            VGA_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

    --internal signals
    --Address Decoder
    SIGNAL dataFromAddressDecoder          : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memOpFinishedFromAddressDecoder : STD_LOGIC;
    SIGNAL RAM_writeEn                     : STD_LOGIC;
    SIGNAL RAM_readEn                      : STD_LOGIC;
    SIGNAL MemoryMappingWriteEn            : STD_LOGIC;
    SIGNAL MemoryMappingReadEn             : STD_LOGIC;

    --Memory Mapping
    SIGNAL IVT                            : STD_LOGIC_VECTOR(32 * numInterrupts - 1 DOWNTO 0);
    SIGNAL IPR                            : STD_LOGIC_VECTOR(3 * numInterrupts - 1 DOWNTO 0);
    SIGNAL memOpFinishedFromMemoryMapping : STD_LOGIC;
    SIGNAL dataFromMemoryMapping          : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alteredClk                     : STD_LOGIC;
    SIGNAL addressDevidedByFour           : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --CPU Core
    SIGNAL InterruptsClr           : STD_LOGIC_VECTOR(numExternalInterrupts - 1 DOWNTO 0);
    SIGNAL interrupts              : STD_LOGIC_VECTOR(numExternalInterrupts - 1 DOWNTO 0);
    SIGNAL debugFromCPU_Core       : STD_LOGIC_VECTOR(numCPU_CoreDebugSignals - 1 DOWNTO 0);
    SIGNAL dataFromCPU_Core        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL addressFromCPU_Core     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memReadReqFromCPU_Core  : STD_LOGIC;
    SIGNAL memWriteReqFromCPU_Core : STD_LOGIC;
    SIGNAL softwareReset           : STD_LOGIC;

    --RAM
    SIGNAL dataFromRam          : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memOpFinishedFromRAM : STD_LOGIC;

    --Graphics
    SIGNAL VGA_clk             : STD_LOGIC;
    SIGNAL VGA_enable          : STD_LOGIC;
    SIGNAL VGA_clkLocked       : STD_LOGIC;
    SIGNAL VGA_readAddress     : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL VGA_data            : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dataFromImageBuffer : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL imageBufferWriteEn  : STD_LOGIC;

    --others
    SIGNAL reset        : STD_LOGIC := '0';
    SIGNAL sysClk       : STD_LOGIC;
    SIGNAL sysClkLocked : STD_LOGIC;
    SIGNAL sysEnable    : STD_LOGIC;

    SIGNAL programmingModeReg  : STD_LOGIC;
    SIGNAL programmingModePrev : STD_LOGIC;

    CONSTANT debounceTime : INTEGER := 500000; --5ms
    SIGNAL debounceCount  : unsigned(25 DOWNTO 0);

BEGIN
    -- Debounce Process
    PROCESS (externalClk)
    BEGIN
        IF rising_edge(externalClk) THEN
            IF programmingMode /= programmingModeReg THEN
                debounceCount <= debounceCount + 1;
                IF debounceCount >= debounceTime THEN
                    programmingModeReg <= programmingMode;
                    debounceCount      <= (OTHERS => '0'); -- Reset counter
                END IF;
            ELSE
                debounceCount <= (OTHERS => '0'); -- Reset counter if no change
            END IF;
        END IF;
    END PROCESS;

    --reset logic
    PROCESS (externalClk)
    BEGIN
        IF rising_edge(externalClk) THEN
            programmingModePrev <= programmingModeReg;
            IF programmingModeReg /= programmingModePrev THEN
                reset <= '1';
            ELSIF softwareReset = '1' THEN
                reset <= '1';
            ELSIF invertResetBtn THEN
                reset <= NOT resetBtn;
            ELSE
                reset <= resetBtn;
            END IF;
        END IF;
    END PROCESS;
    sysEnable            <= enableSw AND sysClkLocked;
    VGA_enable           <= enableSw AND VGA_clkLocked;
    addressDevidedByFour <= "00" & addressFromCPU_Core(31 DOWNTO 2);

    internalClockGenerator_inst : clockGenerator
    GENERIC MAP(
        CLKFBOUT_MULT_F  => sysClkMultiplier,
        CLKOUT0_DIVIDE_F => sysClkDivider,
        CLKIN1_PERIOD    => externalClkPeriod
    )
    PORT MAP(
        clk_in  => externalClk,
        reset   => reset,
        clk_out => sysClk,
        locked  => sysClkLocked
    );

    --Generate the VGA clock using the clock generator component
    VGA_ClkGenerator_inst : clockGenerator
    GENERIC MAP(
        CLKFBOUT_MULT_F  => VGA_ClkMultiplier,
        CLKOUT0_DIVIDE_F => VGA_ClkDivider,
        CLKIN1_PERIOD    => externalClkPeriod
    )
    PORT MAP(
        clk_in  => externalClk,
        reset   => reset,
        clk_out => VGA_clk,
        locked  => VGA_clkLocked
    );

    CPU_Core_inst : CPU_Core
    GENERIC MAP(
        numInterrupts           => numInterrupts,
        numExternalInterrupts   => numExternalInterrupts,
        numCPU_CoreDebugSignals => numCPU_CoreDebugSignals
    )
    PORT MAP(
        --inputs
        enable             => sysEnable,
        reset              => reset,
        clk                => sysClk,
        alteredClk         => alteredClk,
        programmingMode    => programmingModeReg,
        dataFromMem        => dataFromAddressDecoder,
        memOpFinished      => memOpFinishedFromAddressDecoder,
        IVT                => IVT,
        IPR                => IPR,
        externalInterrupts => interrupts,
        --outputs
        externalInterruptsClr => interruptsClr,
        debug                 => debugFromCPU_Core,
        dataOut               => dataFromCPU_Core,
        addressOut            => addressFromCPU_Core,

        memReadReq    => memReadReqFromCPU_Core,
        memWriteReq   => memWriteReqFromCPU_Core,
        softwareReset => softwareReset
    );

    memoryMapping_inst : memoryMapping
    GENERIC MAP(
        defaultSerialInterfacePrescaler       => defaultSerialInterfacePrescaler,
        numDigitalIO_Pins                     => numDigitalIO_Pins,
        numSevenSegmentDisplays               => numSevenSegmentDisplays,
        numCPU_CoreDebugSignals               => numCPU_CoreDebugSignals,
        numExternalDebugSignals               => numExternalDebugSignals,
        individualSevenSegmentDisplayControll => individualSevenSegmentDisplayControll,
        numInterrupts                         => numInterrupts,
        numMMIO_Interrupts                    => numMMIO_Interrupts
    )
    PORT MAP(
        --inputs
        enable               => sysEnable,
        reset                => reset,
        clk                  => sysClk,
        writeEn              => MemoryMappingWriteEn,
        readEn               => MemoryMappingReadEn,
        address              => addressFromCPU_Core,
        dataIn               => dataFromCPU_Core,
        manualClk            => manualClk,
        manualClocking       => manualClocking,
        programmingMode      => programmingModeReg,
        rx                   => rx,
        debugMode            => debugMode,
        CPU_CoreDebugSignals => debugFromCPU_Core,
        interruptsClr        => interruptsClr(numExternalInterrupts - 1 DOWNTO numOther_Interrupts),

        --outputs
        interrupts         => interrupts(numExternalInterrupts - 1 DOWNTO numOther_Interrupts),
        tx                 => tx,
        dataOut            => dataFromMemoryMapping,
        memOpFinished      => memOpFinishedFromMemoryMapping,
        IVT_out            => IVT,
        IPR_out            => IPR,
        sevenSegmentLEDs   => sevenSegmentLEDs,
        sevenSegmentAnodes => sevenSegmentAnodes,
        digitalIO_pins     => digitalIO_pins,
        alteredClkOut      => alteredClk
    );

    ram_inst : ram
    GENERIC MAP(
        ramSize => memSize
    )
    PORT MAP(
        clk           => sysClk,
        reset         => reset,
        address       => addressDevidedByFour, 
        dataIn        => dataFromCPU_Core,
        dataOut       => dataFromRam,
        writeEn       => RAM_writeEn,
        readEn        => RAM_readEn,
        memOpFinished => memOpFinishedFromRAM
    );

    addressDecoder_inst : addressDecoder
    GENERIC MAP(
        memSize => memSize
    )
    PORT MAP(
        --inputs
        enable                           => sysEnable,
        clk                              => sysClk,
        reset                            => reset,
        address                          => addressFromCPU_Core,
        memReadReq                       => memReadReqFromCPU_Core,
        memWriteReq                      => memWriteReqFromCPU_Core,
        ramMemOpFinished                 => memOpFinishedFromRAM,
        MemoryMappedDevicesMemOpFinished => memOpFinishedFromMemoryMapping,
        dataFromMemoryMappedDevices      => dataFromMemoryMapping,
        dataFromMem                      => dataFromRam,
        dataFromImageBuffer              => dataFromImageBuffer,
        addressAlignmentInterruptClr     => interruptsClr(0),
        --outputs
        memOpFinished              => memOpFinishedFromAddressDecoder,
        ramWriteEn                 => RAM_writeEn,
        ramReadEn                  => RAM_readEn,
        memoryMappedDevicesWriteEn => MemoryMappingWriteEn,
        memoryMappedDevicesReadEn  => MemoryMappingReadEn,
        imageBufferWriteEn         => imageBufferWriteEn,
        dataOut                    => dataFromAddressDecoder,
        addressAlignmentInterrupt  => interrupts(0)
    );

    VGA_Controller_inst : VGA_Controller
    PORT MAP(
        enable      => VGA_enable,
        reset       => reset,
        VGA_clk     => VGA_clk,
        readAddress => VGA_readAddress,
        dataIn      => VGA_data,
        VGA_Blue    => VGA_Blue,
        VGA_GREEN   => VGA_Green,
        VGA_RED     => VGA_Red,
        H_Sync      => H_Sync,
        V_Sync      => V_Sync
    );

    VAG_ImageBuffer_inst : VGA_ImageBuffer
    PORT MAP(
        sysClk      => sysClk,
        writeEn     => imageBufferWriteEn,
        sysAddress  => addressDevidedByFour(13 DOWNTO 0),
        sysDataIn   => dataFromCPU_Core,
        sysDataOut  => dataFromImageBuffer,
        VGA_clk     => VGA_clk,
        VGA_Address => VGA_readAddress,
        VGA_DataOut => VGA_data
    );

END Behavioral;