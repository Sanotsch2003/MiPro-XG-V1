LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.helperPackage.ALL;

--TODO Default Prescaler value as generic for serial interface

ENTITY memoryMapping IS
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
END memoryMapping;

ARCHITECTURE Behavioral OF memoryMapping IS
    --memory mapped addresses (read and write)

    CONSTANT IVT_START_ADDR                     : unsigned(31 DOWNTO 0)         := x"3FFFFE00"; --First interrupt vector table address.
    CONSTANT IPR_START_ADDR                     : unsigned(31 DOWNTO 0)         := x"3FFFFE04"; --First interrupt priority register address.
    CONSTANT SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000050";
    CONSTANT SEVEN_SEGMENT_DISPLAY_DATA_ADDR    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000054";

    CONSTANT CLOCK_CONTROLLER_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000058";

    CONSTANT SERIAL_INTERFACE_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"4000005C";
    CONSTANT SERIAL_INTERFACE_STATUS_ADDR    : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000060";
    CONSTANT SERIAL_INTERFACE_FIFOS_ADDR     : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000064";

    -- Hardware Timer 0
    CONSTANT HARDWARE_TIMER_0_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000068";
    CONSTANT HARDWARE_TIMER_0_MAX_COUNT_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"4000006C";
    CONSTANT HARDWARE_TIMER_0_MODE_ADDR      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000070";
    CONSTANT HARDWARE_TIMER_0_COUNT_ADDR     : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000074"; -- Added for Timer 0

    -- Hardware Timer 1
    CONSTANT HARDWARE_TIMER_1_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000078";
    CONSTANT HARDWARE_TIMER_1_MAX_COUNT_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"4000007C";
    CONSTANT HARDWARE_TIMER_1_MODE_ADDR      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000080";
    CONSTANT HARDWARE_TIMER_1_COUNT_ADDR     : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000084"; -- Added for Timer 1

    -- Hardware Timer 2
    CONSTANT HARDWARE_TIMER_2_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000088";
    CONSTANT HARDWARE_TIMER_2_MAX_COUNT_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"4000008C";
    CONSTANT HARDWARE_TIMER_2_MODE_ADDR      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000090";
    CONSTANT HARDWARE_TIMER_2_COUNT_ADDR     : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000094"; -- Added for Timer 2

    -- Hardware Timer 3
    CONSTANT HARDWARE_TIMER_3_PRESCALER_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"40000098";
    CONSTANT HARDWARE_TIMER_3_MAX_COUNT_ADDR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"4000009C";
    CONSTANT HARDWARE_TIMER_3_MODE_ADDR      : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"400000A0";
    CONSTANT HARDWARE_TIMER_3_COUNT_ADDR     : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"400000A4"; -- Added for Timer 3
    -- Digital IO Pins
    CONSTANT DIGITAL_IO_PIN_MODE_ADDR       : unsigned(31 DOWNTO 0) := x"400000A8";
    CONSTANT DIGITAL_IO_PIN_DATA_IN_ADDR    : unsigned(31 DOWNTO 0) := x"400000AC";
    CONSTANT DIGITAL_IO_PIN_DUTY_CYCLE_ADDR : unsigned(31 DOWNTO 0) := x"400000B0";
    CONSTANT DIGITAL_IO_PIN_DATA_OUT_ADDR   : unsigned(31 DOWNTO 0) := x"400000B4";

    CONSTANT ADDRESS_AFTER_DIGITAL_IO_PIN_ADDR : unsigned(31 DOWNTO 0) := unsigned(HARDWARE_TIMER_3_MODE_ADDR) + 16 * numDigitalIO_Pins + 4;

    --signals
    SIGNAL readOnlyInterruptReg : STD_LOGIC;

    --memory mapped devices

    --interrupt vector table
    TYPE vector_array IS ARRAY (0 TO numInterrupts - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    --initiliazing default addresses
    SIGNAL IVT : vector_array;

    --interrupt priority register
    TYPE priority_arary IS ARRAY (0 TO numInterrupts - 1) OF STD_LOGIC_VECTOR(2 DOWNTO 0);
    --initializing default priorities
    SIGNAL IPR : priority_arary;

    --seven segement display
    --Registers
    SIGNAL SevenSegmentDisplayDataReg    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SevenSegmentDisplayControlReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    COMPONENT sevenSegmentDisplays IS
        GENERIC (
            numSevenSegmentDisplays               : INTEGER := 4;
            individualSevenSegmentDisplayControll : BOOLEAN := true
        );
        PORT (
            enable             : IN STD_LOGIC;
            reset              : IN STD_LOGIC;
            clk                : IN STD_LOGIC;
            sevenSegmentLEDs   : OUT seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays) - 1 DOWNTO 0);
            sevenSegmentAnodes : OUT STD_LOGIC_VECTOR(numSevenSegmentDisplays - 1 DOWNTO 0);
            dataIn             : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            controlIn          : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    --clock Controller
    --Registers
    SIGNAL clockControllerPrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --signals
    SIGNAL alteredClk : STD_LOGIC := '1';
    COMPONENT clockController IS
        PORT (
            reset           : IN STD_LOGIC;
            clk             : IN STD_LOGIC;
            enable          : IN STD_LOGIC;
            manualClk       : IN STD_LOGIC;
            manualClocking  : IN STD_LOGIC;
            alteredClk      : OUT STD_LOGIC;
            programmingMode : IN STD_LOGIC;
            prescalerIn     : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    --serialInterface
    --Registers
    SIGNAL serialInterfacePrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(defaultSerialInterfacePrescaler, 32));

    --Signals
    SIGNAL serialInterfaceStatus         : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL serialDataToTransmit          : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL serialDataReceived            : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL loadSerialTransmitFIFO_reg    : STD_LOGIC;
    SIGNAL readFromSerialReceiveFIFO_reg : STD_LOGIC;
    SIGNAL serialDataAvailableInterrupt  : STD_LOGIC;
    COMPONENT serialInterface IS
        GENERIC (
            numCPU_CoreDebugSignals : INTEGER := 867;
            numExternalDebugSignals : INTEGER := 128
        );
        PORT (--final design
            clk       : IN STD_LOGIC;
            reset     : IN STD_LOGIC;
            enable    : IN STD_LOGIC;
            debugMode : IN STD_LOGIC;
            rx        : IN STD_LOGIC;
            tx        : OUT STD_LOGIC;

            status         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            dataReceived   : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            dataToTransmit : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

            loadTransmitFIFO_reg    : IN STD_LOGIC;
            readFromReceiveFIFO_reg : IN STD_LOGIC;
            prescaler               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            debugSignals            : IN STD_LOGIC_VECTOR(numExternalDebugSignals + numCPU_CoreDebugSignals - 1 DOWNTO 0);

            dataAvailableInterrupt : OUT STD_LOGIC

        );
    END COMPONENT;

    --Hardware Timers
    --registers:
    SIGNAL hardwareTimer0PrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hardwareTimer0ModeReg      : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
    SIGNAL hardwareTimer0MaxCountReg  : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '0');

    SIGNAL hardwareTimer1PrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hardwareTimer1ModeReg      : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
    SIGNAL hardwareTimer1MaxCountReg  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL hardwareTimer2PrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hardwareTimer2ModeReg      : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
    SIGNAL hardwareTimer2MaxCountReg  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL hardwareTimer3PrescalerReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hardwareTimer3ModeReg      : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
    SIGNAL hardwareTimer3MaxCountReg  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    --signals:
    SIGNAL hardwareTimer0Count : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hardwareTimer1Count : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL hardwareTimer2Count : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL hardwareTimer3Count : STD_LOGIC_VECTOR(31 DOWNTO 0);
    COMPONENT hardwareTimer IS
        GENERIC (
            countWidth : INTEGER
        );
        PORT (
            enable : IN STD_LOGIC;
            reset  : IN STD_LOGIC;
            clk    : IN STD_LOGIC;

            prescaler : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            mode      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            maxCount  : IN STD_LOGIC_VECTOR(countWidth - 1 DOWNTO 0);

            interruptClr : IN STD_LOGIC;

            --outputs 
            count     : OUT STD_LOGIC_VECTOR(countWidth - 1 DOWNTO 0);
            interrupt : OUT STD_LOGIC
        );
    END COMPONENT;

    --Digital IO-Pins
    --Registers
    SIGNAL IO_PinsDigitalModeReg      : STD_LOGIC_VECTOR(numDigitalIO_Pins * 2 - 1 DOWNTO 0);
    SIGNAL IO_PinsDigitalDataInReg    : STD_LOGIC_VECTOR(numDigitalIO_Pins - 1 DOWNTO 0);
    SIGNAL IO_PinsDigitalDutyCycleReg : STD_LOGIC_VECTOR(numDigitalIO_pins * 8 - 1 DOWNTO 0);

    --signals
    SIGNAL IO_PinsDigitalDataOut : STD_LOGIC_VECTOR(numDigitalIO_pins - 1 DOWNTO 0);

    COMPONENT IO_PinDigital IS
        PORT (
            pin       : INOUT STD_LOGIC;
            dutyCycle : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            mode      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            dataIn    : IN STD_LOGIC;
            dataOut   : OUT STD_LOGIC;
            count     : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    --internal signals
    SIGNAL debugSignalsReg : STD_LOGIC_VECTOR(numExternalDebugSignals + numCPU_CoreDebugSignals - 1 DOWNTO 0);
BEGIN
    --assigning signals
    interrupts(0)        <= readOnlyInterruptReg;
    serialDataToTransmit <= dataIn(7 DOWNTO 0);

    --sequential write logic
    PROCESS (writeEn, address)
    BEGIN
        --default assignemnts
        loadSerialTransmitFIFO_reg <= '0';
        CASE address IS
            WHEN SERIAL_INTERFACE_FIFOS_ADDR =>
                IF writeEn = '1' THEN
                    loadSerialTransmitFIFO_reg <= '1';
                END IF;
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;

    --clocked read and write logic
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            debugSignalsReg <= (OTHERS => '0');

            --Seven Segmement Displays
            SevenSegmentDisplayDataReg    <= (OTHERS => '0');
            SevenSegmentDisplayControlReg <= (OTHERS => '0');

            --Serial Interface
            serialInterfacePrescalerReg   <= STD_LOGIC_VECTOR(to_unsigned(defaultSerialInterfacePrescaler, 32));
            clockControllerPrescalerReg   <= STD_LOGIC_VECTOR(to_unsigned(0, 32));
            readFromSerialReceiveFIFO_reg <= '0';

            --Hardware Timers
            hardwareTimer0PrescalerReg <= (OTHERS => '0');
            hardwareTimer0ModeReg      <= "00";
            hardwareTimer0MaxCountReg  <= (OTHERS => '0');

            hardwareTimer1PrescalerReg <= (OTHERS => '0');
            hardwareTimer1ModeReg      <= "00";
            hardwareTimer1MaxCountReg  <= (OTHERS => '0');

            hardwareTimer2PrescalerReg <= (OTHERS => '0');
            hardwareTimer2ModeReg      <= "00";
            hardwareTimer2MaxCountReg  <= (OTHERS => '0');

            hardwareTimer3PrescalerReg <= (OTHERS => '0');
            hardwareTimer3ModeReg      <= "00";
            hardwareTimer3MaxCountReg  <= (OTHERS => '0');

            --Digital IO Pins
            IO_PinsDigitalModeReg      <= (OTHERS => '0');
            IO_PinsDigitalDataInReg    <= (OTHERS => '0');
            IO_PinsDigitalDutyCycleReg <= (OTHERS => '0');

            --Internat Registers
            memOpFinished        <= '0';
            dataOut              <= (OTHERS => '0');
            readOnlyInterruptReg <= '0';

            IVT <= (OTHERS => (OTHERS => '0'));
            IPR <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            memOpFinished                 <= '0';
            dataOut                       <= (OTHERS => '0');
            readFromSerialReceiveFIFO_reg <= '0';
            IF enable = '1' THEN
                --debug signals are updated on every clock edge
                debugSignalsReg <= SevenSegmentDisplayDataReg & SevenSegmentDisplayControlReg & clockControllerPrescalerReg & serialInterfacePrescalerReg & CPU_CoreDebugSignals & "00000000" & "00000000" & "00000000";
                --debugSignalsReg <= (others => '1');
                IF interruptsClr(0) = '1' THEN
                    readOnlyInterruptReg <= '0';
                END IF;

                --if alteredClk = '1' then
                IF writeEn = '1' THEN
                    memOpFinished <= '1';
                    CASE address IS

                            --Seven Segment Displays
                        WHEN SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => SevenSegmentDisplayControlReg <= dataIn;
                        WHEN SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => SevenSegmentDisplayDataReg       <= dataIn;

                            --Clk Controller
                        WHEN CLOCK_CONTROLLER_PRESCALER_ADDR => clockControllerPrescalerReg <= dataIn;

                            --Serial Interface
                        WHEN SERIAL_INTERFACE_PRESCALER_ADDR => serialInterfacePrescalerReg <= dataIn;
                        WHEN SERIAL_INTERFACE_STATUS_ADDR    => readOnlyInterruptReg           <= '1';
                            --Hardware Timers
                            --Hardware Timer 0
                        WHEN HARDWARE_TIMER_0_PRESCALER_ADDR => hardwareTimer0PrescalerReg <= dataIn;
                        WHEN HARDWARE_TIMER_0_MODE_ADDR      => hardwareTimer0ModeReg           <= dataIn(1 DOWNTO 0); -- Mode bits (bits 0-1)   
                        WHEN HARDWARE_TIMER_0_MAX_COUNT_ADDR => hardwareTimer0MaxCountReg  <= dataIn(7 DOWNTO 0);
                        WHEN HARDWARE_TIMER_0_COUNT_ADDR     => readOnlyInterruptReg           <= '1';

                            --Hardware Timer 1
                        WHEN HARDWARE_TIMER_1_PRESCALER_ADDR => hardwareTimer1PrescalerReg <= dataIn;
                        WHEN HARDWARE_TIMER_1_MODE_ADDR      => hardwareTimer1ModeReg           <= dataIn(1 DOWNTO 0);
                        WHEN HARDWARE_TIMER_1_MAX_COUNT_ADDR => hardwareTimer1MaxCountReg  <= dataIn(15 DOWNTO 0);
                        WHEN HARDWARE_TIMER_1_COUNT_ADDR     => readOnlyInterruptReg           <= '1';

                            --Hardware Timer 2
                        WHEN HARDWARE_TIMER_2_PRESCALER_ADDR => hardwareTimer2PrescalerReg <= dataIn;
                        WHEN HARDWARE_TIMER_2_MODE_ADDR      => hardwareTimer2ModeReg           <= dataIn(1 DOWNTO 0);
                        WHEN HARDWARE_TIMER_2_MAX_COUNT_ADDR => hardwareTimer2MaxCountReg  <= dataIn(15 DOWNTO 0);
                        WHEN HARDWARE_TIMER_2_COUNT_ADDR     => readOnlyInterruptReg           <= '1';

                            --Hardware Timer 3
                        WHEN HARDWARE_TIMER_3_PRESCALER_ADDR => hardwareTimer3PrescalerReg <= dataIn;
                        WHEN HARDWARE_TIMER_3_MODE_ADDR      => hardwareTimer3ModeReg           <= dataIn(1 DOWNTO 0);
                        WHEN HARDWARE_TIMER_3_MAX_COUNT_ADDR => hardwareTimer3MaxCountReg  <= dataIn(31 DOWNTO 0);
                        WHEN HARDWARE_TIMER_3_COUNT_ADDR     => readOnlyInterruptReg           <= '1';

                        WHEN OTHERS =>

                            --Digital IO Pins
                            FOR i IN 0 TO numDigitalIO_Pins - 1 LOOP
                                IF unsigned(address) = DIGITAL_IO_PIN_MODE_ADDR + i * 16 THEN
                                    IO_PinsDigitalModeReg(i * 2 + 1 DOWNTO i * 2) <= dataIn(1 DOWNTO 0);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DATA_IN_ADDR + i * 16 THEN
                                    IO_PinsDigitalDataInReg(i) <= dataIn(0);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DUTY_CYCLE_ADDR + i * 16 THEN
                                    IO_PinsDigitalDutyCycleReg(i * 8 + 7 DOWNTO i * 8) <= dataIn(7 DOWNTO 0);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DATA_OUT_ADDR + i * 16 THEN
                                    readOnlyInterruptReg <= '1';
                                END IF;
                            END LOOP;

                            --Interrupt Vector tables and interrupt priority registers.
                            FOR i IN 0 TO numInterrupts - 1 LOOP
                                IF unsigned(address) = IVT_START_ADDR + 8 * i THEN
                                    IVT(i) <= dataIn;
                                ELSIF unsigned(address) = IPR_START_ADDR + 8 * i THEN
                                    IPR(i) <= dataIn(2 DOWNTO 0);
                                END IF;
                            END LOOP;

                    END CASE;

                ELSIF readEn = '1' THEN
                    memOpFinished <= '1';
                    dataOut       <= (OTHERS => '0'); --default assignemnt
                    CASE address IS

                            --Seven Segment Display
                        WHEN SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => dataOut <= SevenSegmentDisplayControlReg;
                        WHEN SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => dataOut    <= SevenSegmentDisplayDataReg;

                            --Clk Controller
                        WHEN CLOCK_CONTROLLER_PRESCALER_ADDR => dataOut <= clockControllerPrescalerReg;
                            --Serial Interface
                        WHEN SERIAL_INTERFACE_PRESCALER_ADDR => dataOut          <= serialInterfacePrescalerReg;
                        WHEN SERIAL_INTERFACE_STATUS_ADDR    => dataOut(7 DOWNTO 0) <= serialInterfaceStatus;
                        WHEN SERIAL_INTERFACE_FIFOS_ADDR     =>
                            dataOut(8 DOWNTO 0)           <= serialDataReceived;
                            readFromSerialReceiveFIFO_reg <= '1';

                            --Hardware Timers
                            --Hardware Timer 0
                        WHEN HARDWARE_TIMER_0_PRESCALER_ADDR => dataOut             <= hardwareTimer0PrescalerReg;
                        WHEN HARDWARE_TIMER_0_MODE_ADDR      => dataOut(1 DOWNTO 0)      <= hardwareTimer0ModeReg;
                        WHEN HARDWARE_TIMER_0_MAX_COUNT_ADDR => dataOut(7 DOWNTO 0) <= hardwareTimer0MaxCountReg;
                        WHEN HARDWARE_TIMER_0_COUNT_ADDR     => dataOut(7 DOWNTO 0)     <= hardwareTimer0Count;

                            --Hardware Timer 1
                        WHEN HARDWARE_TIMER_1_PRESCALER_ADDR => dataOut              <= hardwareTimer1PrescalerReg;
                        WHEN HARDWARE_TIMER_1_MODE_ADDR      => dataOut(1 DOWNTO 0)       <= hardwareTimer1ModeReg;
                        WHEN HARDWARE_TIMER_1_MAX_COUNT_ADDR => dataOut(15 DOWNTO 0) <= hardwareTimer1MaxCountReg;
                        WHEN HARDWARE_TIMER_1_COUNT_ADDR     => dataOut(15 DOWNTO 0)     <= hardwareTimer1Count;

                            --Hardware Timer 2
                        WHEN HARDWARE_TIMER_2_PRESCALER_ADDR => dataOut              <= hardwareTimer2PrescalerReg;
                        WHEN HARDWARE_TIMER_2_MODE_ADDR      => dataOut(1 DOWNTO 0)       <= hardwareTimer2ModeReg;
                        WHEN HARDWARE_TIMER_2_MAX_COUNT_ADDR => dataOut(15 DOWNTO 0) <= hardwareTimer2MaxCountReg;
                        WHEN HARDWARE_TIMER_2_COUNT_ADDR     => dataOut(15 DOWNTO 0)     <= hardwareTimer2Count;

                            --Hardware Timer 3
                        WHEN HARDWARE_TIMER_3_PRESCALER_ADDR => dataOut              <= hardwareTimer3PrescalerReg;
                        WHEN HARDWARE_TIMER_3_MODE_ADDR      => dataOut(1 DOWNTO 0)       <= hardwareTimer3ModeReg;
                        WHEN HARDWARE_TIMER_3_MAX_COUNT_ADDR => dataOut(31 DOWNTO 0) <= hardwareTimer3MaxCountReg;
                        WHEN HARDWARE_TIMER_3_COUNT_ADDR     => dataOut(31 DOWNTO 0)     <= hardwareTimer3Count;
                        WHEN OTHERS                          =>
                            -- Digital IO Pins Read
                            FOR i IN 0 TO numDigitalIO_Pins - 1 LOOP
                                IF unsigned(address) = DIGITAL_IO_PIN_MODE_ADDR + i * 16 THEN
                                    dataOut(1 DOWNTO 0) <= IO_PinsDigitalModeReg(i * 2 + 1 DOWNTO i * 2);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DATA_IN_ADDR + i * 16 THEN
                                    dataOut(0) <= IO_PinsDigitalDataInReg(i);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DUTY_CYCLE_ADDR + i * 16 THEN
                                    dataOut(7 DOWNTO 0) <= IO_PinsDigitalDutyCycleReg(i * 8 + 7 DOWNTO i * 8);
                                ELSIF unsigned(address) = DIGITAL_IO_PIN_DATA_OUT_ADDR + i * 16 THEN
                                    dataOut(0) <= IO_PinsDigitalDataOut(i);
                                END IF;
                            END LOOP;

                            --Interrupt Vector tables and interrupt priority registers.
                            FOR i IN 0 TO numInterrupts - 1 LOOP
                                IF unsigned(address) = IVT_START_ADDR + 8 * i THEN
                                    dataOut <= IVT(i);
                                ELSIF unsigned(address) = IPR_START_ADDR + 8 * i THEN
                                    dataOut(2 DOWNTO 0) <= IPR(i);
                                END IF;
                            END LOOP;

                    END CASE;
                END IF;
                --end if;
            END IF;
        END IF;
    END PROCESS;
    --connecting the IVT and IPR to output so the interrupt controller can use them directly
    PROCESS (IVT, IPR)
    BEGIN
        FOR i IN 0 TO numInterrupts - 1 LOOP
            IVT_out((i + 1) * 32 - 1 DOWNTO i * 32) <= IVT(i);
            IPR_out((i + 1) * 3 - 1 DOWNTO i * 3)   <= IPR(i);
        END LOOP;
    END PROCESS;

    --connecting components to their signals
    IO_SevenSegmentDisplay_inst : sevenSegmentDisplays
    GENERIC MAP(
        numSevenSegmentDisplays               => numSevenSegmentDisplays,
        individualSevenSegmentDisplayControll => individualSevenSegmentDisplayControll

    )
    PORT MAP(
        enable             => enable,
        reset              => reset,
        clk                => clk,
        sevenSegmentLEDs   => sevenSegmentLEDs,
        sevenSegmentAnodes => sevenSegmentAnodes,
        dataIn             => SevenSegmentDisplayDataReg,
        controlIn          => SevenSegmentDisplayControlReg
    );

    clockController_inst : clockController
    PORT MAP(
        reset           => reset,
        clk             => clk,
        enable          => enable,
        manualClk       => manualClk,
        manualClocking  => manualClocking,
        alteredClk      => alteredClk,
        prescalerIn     => clockControllerPrescalerReg,
        programmingMode => programmingMode
    );
    alteredClkOut <= alteredClk;
    --alteredClkOut <= '1';

    serialInterface_inst : serialInterface
    GENERIC MAP(
        numCPU_CoreDebugSignals => numCPU_CoreDebugSignals,
        numExternalDebugSignals => numExternalDebugSignals
    )
    PORT MAP(
        --inputs
        clk                     => clk,
        reset                   => reset,
        enable                  => enable,
        debugMode               => debugMode,
        rx                      => rx,
        debugSignals            => debugSignalsReg,
        prescaler               => serialInterfacePrescalerReg,
        dataToTransmit          => serialDataToTransmit,
        loadTransmitFIFO_reg    => loadSerialTransmitFIFO_reg,
        readFromReceiveFIFO_reg => readFromSerialReceiveFIFO_reg,

        --outputs
        tx                     => tx,
        status                 => serialInterfaceStatus,
        dataReceived           => serialDataReceived,
        dataAvailableInterrupt => serialDataAvailableInterrupt
    );

    hardwareTimer0_inst : hardwareTimer
    GENERIC MAP(
        countWidth => 8
    )
    PORT MAP(
        enable       => enable,
        reset        => reset,
        clk          => clk,
        prescaler    => hardwareTimer0PrescalerReg,
        mode         => hardwareTimer0ModeReg,
        interruptClr => interruptsClr(1),
        maxCount     => hardwareTimer0MaxCountReg,

        -- Outputs 
        count     => hardwareTimer0Count,
        interrupt => interrupts(1)
    );

    hardwareTimer1_inst : hardwareTimer
    GENERIC MAP(
        countWidth => 16
    )
    PORT MAP(
        enable       => enable,
        reset        => reset,
        clk          => clk,
        prescaler    => hardwareTimer1PrescalerReg,
        mode         => hardwareTimer1ModeReg,
        interruptClr => interruptsClr(2),
        maxCount     => hardwareTimer1MaxCountReg,

        -- Outputs 
        count     => hardwareTimer1Count,
        interrupt => interrupts(2)
    );

    hardwareTimer2_inst : hardwareTimer
    GENERIC MAP(
        countWidth => 16
    )
    PORT MAP(
        enable       => enable,
        reset        => reset,
        clk          => clk,
        prescaler    => hardwareTimer2PrescalerReg,
        mode         => hardwareTimer2ModeReg,
        interruptClr => interruptsClr(3),
        maxCount     => hardwareTimer2MaxCountReg,

        -- Outputs 
        count     => hardwareTimer2Count,
        interrupt => interrupts(3)
    );

    hardwareTimer3_inst : hardwareTimer
    GENERIC MAP(
        countWidth => 32
    )
    PORT MAP(
        enable       => enable,
        reset        => reset,
        clk          => clk,
        prescaler    => hardwareTimer3PrescalerReg,
        mode         => hardwareTimer3ModeReg,
        interruptClr => interruptsClr(4),
        maxCount     => hardwareTimer3MaxCountReg,

        -- Outputs 
        count     => hardwareTimer3Count,
        interrupt => interrupts(4)
    );
    GEN_IO_PINS : FOR i IN 0 TO numDigitalIO_Pins - 1 GENERATE
    BEGIN
        IO_PinDigital_inst : IO_PinDigital
        PORT MAP(
            pin       => digitalIO_pins(i),
            dutyCycle => IO_PinsDigitalDutyCycleReg(i * 8 + 7 DOWNTO i * 8),
            mode      => IO_PinsDigitalModeReg(i * 2 + 1 DOWNTO i * 2),
            dataIn    => IO_PinsDigitalDataInReg(i),
            dataOut   => IO_PinsDigitalDataOut(i),
            count     => hardwareTimer0Count
        );
    END GENERATE GEN_IO_PINS;
END Behavioral;