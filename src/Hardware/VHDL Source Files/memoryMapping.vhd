library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.helperPackage.all;

--TODO Default Prescaler value as generic for serial interface

entity memoryMapping is
        generic(
            defaultSerialInterfacePrescaler         : integer;
            numDigitalIO_Pins                       : integer;
            numInterrupts                           : integer;
            numSevenSegmentDisplays                 : integer;
            numCPU_CoreDebugSignals                 : integer;
            individualSevenSegmentDisplayControll   : boolean;
            numExternalDebugSignals                 : integer
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
			  readOnlyInterrupt            : out std_logic;
			  readOnlyInterruptClear       : in std_logic;

			  --interrupt vector table and priority register
			  IVT_out                      : out std_logic_vector(32 * numInterrupts - 1 downto 0);
			  PR_out                       : out std_logic_vector(3 * numInterrupts -1 downto 0);

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
			  serialDataAvailableInterrupt : out std_logic;
			  
			  --IO pins
			  digitalIO_pins               : inout std_logic_vector(numDigitalIO_Pins-1 downto 0);

			  --debugging
			  CPU_CoreDebugSignals         : in std_logic_vector(numCPU_CoreDebugSignals-1 downto 0)

    );
end memoryMapping;

architecture Behavioral of memoryMapping is
    --memory mapped addresses (read and write)
    constant IVT_0 : std_logic_vector(31 downto 0) := x"40000000";
    constant IVT_1 : std_logic_vector(31 downto 0) := x"40000004";
    constant IVT_2 : std_logic_vector(31 downto 0) := x"40000008";
    constant IVT_3 : std_logic_vector(31 downto 0) := x"4000000C";
    constant IVT_4 : std_logic_vector(31 downto 0) := x"40000010";
    constant IVT_5 : std_logic_vector(31 downto 0) := x"40000014";
    constant IVT_6 : std_logic_vector(31 downto 0) := x"40000018";
    constant IVT_7 : std_logic_vector(31 downto 0) := x"4000001C";
    constant IVT_8 : std_logic_vector(31 downto 0) := x"40000020";
    constant IVT_9 : std_logic_vector(31 downto 0) := x"40000024";

    constant PR_0  : std_logic_vector(31 downto 0) := x"40000028";
    constant PR_1  : std_logic_vector(31 downto 0) := x"4000002C";
    constant PR_2  : std_logic_vector(31 downto 0) := x"40000030";
    constant PR_3  : std_logic_vector(31 downto 0) := x"40000034";
    constant PR_4  : std_logic_vector(31 downto 0) := x"40000038";
    constant PR_5  : std_logic_vector(31 downto 0) := x"4000003C";
    constant PR_6  : std_logic_vector(31 downto 0) := x"40000040";
    constant PR_7  : std_logic_vector(31 downto 0) := x"40000044";
    constant PR_8  : std_logic_vector(31 downto 0) := x"40000048";
    constant PR_9  : std_logic_vector(31 downto 0) := x"4000004C";

    constant SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR : std_logic_vector(31 downto 0) := x"40000050";
    constant SEVEN_SEGMENT_DISPLAY_DATA_ADDR    : std_logic_vector(31 downto 0) := x"40000054";

    constant CLOCK_CONTROLLER_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"40000058";

    constant SERIAL_INTERFACE_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"4000005C";
    constant SERIAL_INTERFACE_STATUS_ADDR      : std_logic_vector(31 downto 0) := x"40000060";
    constant SERIAL_INTERFACE_FIFOS_ADDR       : std_logic_vector(31 downto 0) := x"40000064";
    
        -- Hardware Timer 0
    constant HARDWARE_TIMER_0_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"40000068";
    constant HARDWARE_TIMER_0_MAX_COUNT_ADDR   : std_logic_vector(31 downto 0) := x"4000006C";
    constant HARDWARE_TIMER_0_MODE_ADDR        : std_logic_vector(31 downto 0) := x"40000070";
    constant HARDWARE_TIMER_0_COUNT_ADDR       : std_logic_vector(31 downto 0) := x"40000074"; -- Added for Timer 0

    -- Hardware Timer 1
    constant HARDWARE_TIMER_1_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"40000078";
    constant HARDWARE_TIMER_1_MAX_COUNT_ADDR   : std_logic_vector(31 downto 0) := x"4000007C";
    constant HARDWARE_TIMER_1_MODE_ADDR        : std_logic_vector(31 downto 0) := x"40000080";
    constant HARDWARE_TIMER_1_COUNT_ADDR       : std_logic_vector(31 downto 0) := x"40000084"; -- Added for Timer 1

    -- Hardware Timer 2
    constant HARDWARE_TIMER_2_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"40000088";
    constant HARDWARE_TIMER_2_MAX_COUNT_ADDR   : std_logic_vector(31 downto 0) := x"4000008C";
    constant HARDWARE_TIMER_2_MODE_ADDR        : std_logic_vector(31 downto 0) := x"40000090";
    constant HARDWARE_TIMER_2_COUNT_ADDR       : std_logic_vector(31 downto 0) := x"40000094"; -- Added for Timer 2

    -- Hardware Timer 3
    constant HARDWARE_TIMER_3_PRESCALER_ADDR   : std_logic_vector(31 downto 0) := x"40000098";
    constant HARDWARE_TIMER_3_MAX_COUNT_ADDR   : std_logic_vector(31 downto 0) := x"4000009C";
    constant HARDWARE_TIMER_3_MODE_ADDR        : std_logic_vector(31 downto 0) := x"400000A0";
    constant HARDWARE_TIMER_3_COUNT_ADDR       : std_logic_vector(31 downto 0) := x"400000A4"; -- Added for Timer 3

    
    -- Digital IO Pins
    constant DIGITAL_IO_PIN_MODE_ADDR          : unsigned(31 downto 0) := x"400000A8";      
    constant DIGITAL_IO_PIN_DATA_IN_ADDR       : unsigned(31 downto 0) := x"400000AC";
    constant DIGITAL_IO_PIN_DUTY_CYCLE_ADDR    : unsigned(31 downto 0) := x"400000B0";
    constant DIGITAL_IO_PIN_DATA_OUT_ADDR      : unsigned(31 downto 0) := x"400000B4";
    
    constant ADDRESS_AFTER_DIGITAL_IO_PIN_ADDR : unsigned(31 downto 0) := unsigned(HARDWARE_TIMER_3_MODE_ADDR) + 16 * numDigitalIO_Pins + 4;
    
    --signals
    signal readOnlyInterruptReg : std_logic;

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
    5 => x"DEADBEEF",  
    6 => x"12345678",  
    7 => x"FEDCBA98",  
    8 => x"CAFEBABE",  
    9 => x"87654321",    
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
        5 => "000",  
        6 => "011",  
        7 => "010",  
        8 => "011",  
        9 => "111",   
    others => (others => '0'));

    --seven segement display
    --Registers
    signal SevenSegmentDisplayDataReg         : std_logic_vector(31 downto 0);
    signal SevenSegmentDisplayControlReg      : std_logic_vector(31 downto 0);
    component IO_SevenSegmentDisplays is
        generic(
			  numSevenSegmentDisplays     		    : integer := 4;
			  individualSevenSegmentDisplayControll : boolean := true
        );
        Port (
            enable                   : in std_logic;
            reset                    : in std_logic;
            clk                      : in std_logic;
			sevenSegmentLEDs    		 : out seven_segment_array(getSevenSegmentArraySize(individualSevenSegmentDisplayControll, numSevenSegmentDisplays)-1 downto 0);
            sevenSegmentAnodes       : out std_logic_vector(numSevenSegmentDisplays-1 downto 0);
            dataIn                   : in std_logic_vector(31 downto 0);
            controlIn                : in std_logic_vector(31 downto 0)
          );
    end component;

    --clock Controller
    --Registers
    signal clockControllerPrescalerReg : std_logic_vector(31 downto 0);
    --signals
    signal alteredClk : std_logic := '1';
    component clockController is
        Port ( 
            reset            : in std_logic;
            clk              : in std_logic;
            enable           : in std_logic;
            manualClk        : in std_logic;
            manualClocking   : in std_logic;
            alteredClk       : out std_logic;
            programmingMode  : in std_logic;
            prescalerIn      : in std_logic_vector(31 downto 0)
        );
    end component;

    --serialInterface
    --Registers
    signal serialInterfacePrescalerReg : std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(defaultSerialInterfacePrescaler, 32));
    
    --Signals
    signal serialInterfaceStatus : std_logic_vector(7 downto 0);
    signal serialDataToTransmit : std_logic_vector(7 downto 0);
    signal serialDataReceived : std_logic_vector(8 downto 0);
    signal loadSerialTransmitFIFO_reg : std_logic;
    signal readFromSerialReceiveFIFO_reg : std_logic;


    component serialInterface is
        generic(
            numCPU_CoreDebugSignals  : integer := 867;
            numExternalDebugSignals  : integer := 128
        );
        Port (  --final design
            clk                      : in std_logic;
            reset                    : in std_logic;
            enable                   : in std_logic;
            debugMode                : in std_logic;
            rx                       : in std_logic;
            tx                       : out std_logic;

            status                   : out std_logic_vector(7 downto 0);
            dataReceived             : out std_logic_vector(8 downto 0);
            dataToTransmit           : in std_logic_vector(7 downto 0);

            loadTransmitFIFO_reg     : in std_logic;
            readFromReceiveFIFO_reg  : in std_logic;          


            prescaler                : in std_logic_vector(31 downto 0);
            debugSignals             : in std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals-1 downto 0);

            dataAvailableInterrupt   : out std_logic

            );
    end component;

    --Hardware Timers
    --registers:
    signal hardwareTimer0PrescalerReg : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer0ModeReg      : std_logic_vector(1 downto 0) := "00";
    signal hardwareTimer0MaxCountReg  : std_logic_vector(7 downto 0) := (others => '0');
    signal hardwaretimer0interruptEn  : std_logic := '0';
    
    signal hardwareTimer1PrescalerReg : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer1ModeReg      : std_logic_vector(1 downto 0) := "00";
    signal hardwareTimer1MaxCountReg  : std_logic_vector(15 downto 0) := (others => '0');
    signal hardwaretimer1interruptEn  : std_logic := '0';
    
    signal hardwareTimer2PrescalerReg : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer2ModeReg      : std_logic_vector(1 downto 0) := "00";
    signal hardwareTimer2MaxCountReg  : std_logic_vector(15 downto 0) := (others => '0');
    signal hardwaretimer2interruptEn  : std_logic := '0';
    
    signal hardwareTimer3PrescalerReg : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer3ModeReg      : std_logic_vector(1 downto 0) := "00";
    signal hardwareTimer3MaxCountReg  : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwaretimer3interruptEn  : std_logic := '0';
    
    

    --signals:
    signal hardwareTimer0Count   : std_logic_vector(7 downto 0);
    signal hardwareTimer1Count   : std_logic_vector(15 downto 0); 
    signal hardwareTimer2Count   : std_logic_vector(15 downto 0);
    signal hardwareTimer3Count   : std_logic_vector(31 downto 0);
    
    signal hardwareTimer0Interrupt : std_logic;
    signal hardwareTimer1Interrupt : std_logic;
    signal hardwareTimer2Interrupt : std_logic;
    signal hardwareTimer3Interrupt : std_logic;

    component hardwareTimer is
        Generic (
            countWidth : integer
            );
        Port (
            enable                   : in std_logic;
            reset                    : in std_logic;
            clk                      : in std_logic;
            
            prescaler                : in std_logic_vector(31 downto 0);
            mode                     : in std_logic_vector(1 downto 0);
            interruptEn              : in std_logic;
            maxCount                 : in std_logic_vector(countWidth-1 downto 0);
            
            interruptClr             : in std_logic;
            
            --outputs 
            count                    : out std_logic_vector(countWidth-1 downto 0);
            interrupt                : out std_logic
         );
    end component;
    
    --Digital IO-Pins
    --Registers
    signal IO_PinsDigitalModeReg : std_logic_vector(numDigitalIO_Pins*2-1 downto 0);
    signal IO_PinsDigitalDataInReg : std_logic_vector(numDigitalIO_Pins-1 downto 0);
    signal IO_PinsDigitalDutyCycleReg : std_logic_vector(numDigitalIO_pins*8-1 downto 0);
    
    --signals
    signal IO_PinsDigitalDataOut : std_logic_vector(numDigitalIO_pins-1 downto 0);
    
    component IO_PinDigital is
    Port (
        pin        : inout std_logic;           
        dutyCycle  : in std_logic_vector(7 downto 0); 
        mode       : in std_logic_vector(1 downto 0); 
        dataIn     : in std_logic;               
        dataOut    : out std_logic;               
        count      : in std_logic_vector(7 downto 0)
    );
    end component;
    
    --internal signals
    signal debugSignalsReg : std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals-1 downto 0);
begin
    --assigning signals
    readOnlyInterrupt <= readOnlyInterruptReg;
    serialDataToTransmit <= dataIn(7 downto 0);
    
    --sequential write logic
    process(writeEn, address)
    begin
        --default assignemnts
        loadSerialTransmitFIFO_reg <= '0';
        case address is
        when SERIAL_INTERFACE_FIFOS_ADDR =>
            if writeEn = '1' then
                loadSerialTransmitFIFO_reg <= '1';
            end if;
        when others =>
            null;
        end case;
    end process;
    
    --clocked read and write logic
    process(clk, reset)
    begin
        if reset = '1' then
            debugSignalsReg <= (others => '0');
            
            --Seven Segmement Displays
            SevenSegmentDisplayDataReg <= (others => '0');
            SevenSegmentDisplayControlReg <= (others => '0');
            
            --Serial Interface
            serialInterfacePrescalerReg <= std_logic_vector(to_unsigned(defaultSerialInterfacePrescaler, 32));
            clockControllerPrescalerReg <= std_logic_vector(to_unsigned(0, 32)); 
            readFromSerialReceiveFIFO_reg <= '0';
            
            --Hardware Timers
            hardwareTimer0PrescalerReg <= (others => '0');
            hardwareTimer0ModeReg      <= "00";
            hardwareTimer0MaxCountReg  <= (others => '0');
            hardwareTimer0InterruptEn  <= '0';
        
            hardwareTimer1PrescalerReg <= (others => '0');
            hardwareTimer1ModeReg      <= "00";
            hardwareTimer1MaxCountReg  <= (others => '0');
            hardwareTimer1InterruptEn  <= '0';
        
            hardwareTimer2PrescalerReg <= (others => '0');
            hardwareTimer2ModeReg      <= "00";
            hardwareTimer2MaxCountReg  <= (others => '0');
            hardwareTimer2InterruptEn  <= '0';
        
            hardwareTimer3PrescalerReg <= (others => '0');
            hardwareTimer3ModeReg      <= "00";
            hardwareTimer3MaxCountReg  <= (others => '0');
            hardwareTimer3InterruptEn  <= '0';
            
            --Digital IO Pins
            IO_PinsDigitalModeReg      <= (others => '0');
            IO_PinsDigitalDataInReg    <= (others => '0');
            IO_PinsDigitalDutyCycleReg <= (others => '0');

            --Internat Registers
            memOpFinished <= '0';
            dataOut <= (others => '0');
            readOnlyInterruptReg <= '0';


            IVT <= (
                0 => x"DEADBEEF",  
                1 => x"12345678",  
                2 => x"FEDCBA98",  
                3 => x"CAFEBABE",  
                4 => x"87654321",
                5 => x"DEADBEEF",  
                6 => x"12345678",  
                7 => x"FEDCBA98",  
                8 => x"CAFEBABE",  
                9 => x"87654321",    
                others => (others => '0'));

            PR <= (
                0 => "000",  
                1 => "011",  
                2 => "010",  
                3 => "011",  
                4 => "111",
                5 => "000",  
                6 => "011",  
                7 => "010",  
                8 => "011",  
                9 => "111",   
                others => (others => '0'));


        elsif rising_edge(clk) then
            memOpFinished <= '0';
            dataOut <= (others => '0');
            readFromSerialReceiveFIFO_reg <= '0';
            if enable = '1' then
                --debug signals are updated on every clock edge
                debugSignalsReg <= SevenSegmentDisplayDataReg & SevenSegmentDisplayControlReg & clockControllerPrescalerReg & serialInterfacePrescalerReg & CPU_CoreDebugSignals & "00000000" & "00000000" & "00000000";
                --debugSignalsReg <= (others => '1');
                if readOnlyInterruptClear = '1' then
                    readOnlyInterruptReg <= '0';
                else
                    readOnlyInterruptReg <= readOnlyInterruptReg;
                end if;

                --if alteredClk = '1' then
                    if writeEn = '1' then
                        memOpFinished <= '1';
                        case address is
                            when IVT_0 => IVT(0) <= dataIn;
                            when IVT_1 => IVT(1) <= dataIn;
                            when IVT_2 => IVT(2) <= dataIn;
                            when IVT_3 => IVT(3) <= dataIn;
                            when IVT_4 => IVT(4) <= dataIn;
                            when IVT_5 => IVT(5) <= dataIn;
                            when IVT_6 => IVT(6) <= dataIn;
                            when IVT_7 => IVT(7) <= dataIn;
                            when IVT_8 => IVT(8) <= dataIn;
                            when IVT_9 => IVT(9) <= dataIn;

                            when PR_0  => PR(0) <= dataIn(2 downto 0);
                            when PR_1  => PR(1) <= dataIn(2 downto 0);
                            when PR_2  => PR(2) <= dataIn(2 downto 0);
                            when PR_3  => PR(3) <= dataIn(2 downto 0);
                            when PR_4  => PR(4) <= dataIn(2 downto 0);
                            when PR_5  => PR(5) <= dataIn(2 downto 0);
                            when PR_6  => PR(6) <= dataIn(2 downto 0);
                            when PR_7  => PR(7) <= dataIn(2 downto 0);
                            when PR_8  => PR(8) <= dataIn(2 downto 0);
                            when PR_9  => PR(9) <= dataIn(2 downto 0);
                            
                            --Seven Segment Displays
                            when SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => SevenSegmentDisplayControlReg <= dataIn;
                            when SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => SevenSegmentDisplayDataReg    <= dataIn;
                            
                            --Clk Controller
                            when CLOCK_CONTROLLER_PRESCALER_ADDR => clockControllerPrescalerReg <= dataIn;
                            
                            --Serial Interface
                            when SERIAL_INTERFACE_PRESCALER_ADDR => serialInterfacePrescalerReg <= dataIn;
                            when SERIAL_INTERFACE_STATUS_ADDR => readOnlyInterruptReg <= '1';
                            
                            
                            --Hardware Timers
                            --Hardware Timer 0
                            when HARDWARE_TIMER_0_PRESCALER_ADDR => hardwareTimer0PrescalerReg <= dataIn;
                            when HARDWARE_TIMER_0_MODE_ADDR      => 
                                hardwareTimer0ModeReg      <= dataIn(1 downto 0);  -- Mode bits (bits 0-1)
                                hardwareTimer0InterruptEn  <= dataIn(2);           -- Interrupt enable bit (bit 2)
                            when HARDWARE_TIMER_0_MAX_COUNT_ADDR => hardwareTimer0MaxCountReg  <= dataIn(7 downto 0);
                            when HARDWARE_TIMER_0_COUNT_ADDR => readOnlyInterruptReg <= '1';
                            
                            --Hardware Timer 1
                            when HARDWARE_TIMER_1_PRESCALER_ADDR => hardwareTimer1PrescalerReg <= dataIn;
                            when HARDWARE_TIMER_1_MODE_ADDR      => 
                                hardwareTimer1ModeReg      <= dataIn(1 downto 0);
                                hardwareTimer1InterruptEn  <= dataIn(2);
                            when HARDWARE_TIMER_1_MAX_COUNT_ADDR => hardwareTimer1MaxCountReg  <= dataIn(15 downto 0);
                            when HARDWARE_TIMER_1_COUNT_ADDR => readOnlyInterruptReg <= '1';
                            
                            --Hardware Timer 2
                            when HARDWARE_TIMER_2_PRESCALER_ADDR => hardwareTimer2PrescalerReg <= dataIn;
                            when HARDWARE_TIMER_2_MODE_ADDR      => 
                                hardwareTimer2ModeReg      <= dataIn(1 downto 0);
                                hardwareTimer2InterruptEn  <= dataIn(2);
                            when HARDWARE_TIMER_2_MAX_COUNT_ADDR => hardwareTimer2MaxCountReg  <= dataIn(15 downto 0);
                            when HARDWARE_TIMER_2_COUNT_ADDR => readOnlyInterruptReg <= '1';
                            
                            --Hardware Timer 3
                            when HARDWARE_TIMER_3_PRESCALER_ADDR => hardwareTimer3PrescalerReg <= dataIn;
                            when HARDWARE_TIMER_3_MODE_ADDR      => 
                                hardwareTimer3ModeReg      <= dataIn(1 downto 0);
                                hardwareTimer3InterruptEn  <= dataIn(2);
                            when HARDWARE_TIMER_3_MAX_COUNT_ADDR => hardwareTimer3MaxCountReg  <= dataIn(31 downto 0);
                            when HARDWARE_TIMER_3_COUNT_ADDR => readOnlyInterruptReg <= '1';
                            
                            when others => 
                            
                                --Digital IO Pins
                                for i in 0 to numDigitalIO_Pins-1 loop
                                    if unsigned(address) = DIGITAL_IO_PIN_MODE_ADDR + i * 16 then
                                        IO_PinsDigitalModeReg(i*2 + 1 downto i*2) <= dataIn(1 downto 0);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DATA_IN_ADDR + i * 16 then
                                        IO_PinsDigitalDataInReg(i) <= dataIn(0);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DUTY_CYCLE_ADDR + i * 16 then
                                        IO_PinsDigitalDutyCycleReg(i*8 + 7 downto i*8) <= dataIn(7 downto 0);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DATA_OUT_ADDR + i * 16 then
                                        readOnlyInterruptReg <= '1';
                                    end if; 
                                end loop;
                                
                        end case;
                        
                    elsif readEn = '1' then
                        memOpFinished <= '1';
                        dataOut <= (others => '0'); --default assignemnt
                        case address is 
                            when IVT_0 => dataOut <= IVT(0);
                            when IVT_1 => dataOut <= IVT(1);
                            when IVT_2 => dataOut <= IVT(2);
                            when IVT_3 => dataOut <= IVT(3);
                            when IVT_4 => dataOut <= IVT(4);
                            when IVT_5 => dataOut <= IVT(5);
                            when IVT_6 => dataOut <= IVT(6);
                            when IVT_7 => dataOut <= IVT(7);
                            when IVT_8 => dataOut <= IVT(8);
                            when IVT_9 => dataOut <= IVT(9);

                            when PR_0 => dataOut(2 downto 0) <= PR(0);
                            when PR_1 => dataOut(2 downto 0) <= PR(1);
                            when PR_2 => dataOut(2 downto 0) <= PR(2);
                            when PR_3 => dataOut(2 downto 0) <= PR(3);
                            when PR_4 => dataOut(2 downto 0) <= PR(4);
                            when PR_5 => dataOut(2 downto 0) <= PR(5);
                            when PR_6 => dataOut(2 downto 0) <= PR(6);
                            when PR_7 => dataOut(2 downto 0) <= PR(7);
                            when PR_8 => dataOut(2 downto 0) <= PR(8);
                            when PR_9 => dataOut(2 downto 0) <= PR(9);
                            
                            --Seven Segment Display
                            when SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => dataOut <= SevenSegmentDisplayControlReg;
                            when SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => dataOut <= SevenSegmentDisplayDataReg;
                            
                            --Clk Controller
                            when CLOCK_CONTROLLER_PRESCALER_ADDR => dataOut <= clockControllerPrescalerReg;
                            
                            
                            --Serial Interface
                            when SERIAL_INTERFACE_PRESCALER_ADDR => dataOut <= serialInterfacePrescalerReg;
                            when SERIAL_INTERFACE_STATUS_ADDR => dataOut(7 downto 0) <= serialInterfaceStatus;
                            when SERIAL_INTERFACE_FIFOS_ADDR => 
                                dataOut(8 downto 0) <= serialDataReceived;
                                readFromSerialReceiveFIFO_reg <= '1';
                            
                            --Hardware Timers
                            --Hardware Timer 0
                            when HARDWARE_TIMER_0_PRESCALER_ADDR => dataOut <= hardwareTimer0PrescalerReg;
                            when HARDWARE_TIMER_0_MODE_ADDR      => dataOut(1 downto 0) <= hardwareTimer0ModeReg;  
                                                                     dataOut(2)          <= hardwareTimer0InterruptEn; 
                            when HARDWARE_TIMER_0_MAX_COUNT_ADDR => dataOut(7 downto 0)  <= hardwareTimer0MaxCountReg;
                            when HARDWARE_TIMER_0_COUNT_ADDR => dataOut(7 downto 0) <= hardwareTimer0Count;
                        
                            --Hardware Timer 1
                            when HARDWARE_TIMER_1_PRESCALER_ADDR => dataOut <= hardwareTimer1PrescalerReg;
                            when HARDWARE_TIMER_1_MODE_ADDR      => dataOut(1 downto 0) <= hardwareTimer1ModeReg;
                                                                     dataOut(2)          <= hardwareTimer1InterruptEn;
                            when HARDWARE_TIMER_1_MAX_COUNT_ADDR => dataOut(15 downto 0) <= hardwareTimer1MaxCountReg;
                            when HARDWARE_TIMER_1_COUNT_ADDR => dataOut(15 downto 0) <= hardwareTimer1Count;
                            
                            --Hardware Timer 2
                            when HARDWARE_TIMER_2_PRESCALER_ADDR => dataOut <= hardwareTimer2PrescalerReg;
                            when HARDWARE_TIMER_2_MODE_ADDR      => dataOut(1 downto 0) <= hardwareTimer2ModeReg;
                                                                     dataOut(2)          <= hardwareTimer2InterruptEn;
                            when HARDWARE_TIMER_2_MAX_COUNT_ADDR => dataOut(15 downto 0) <= hardwareTimer2MaxCountReg;
                            when HARDWARE_TIMER_2_COUNT_ADDR => dataOut(15 downto 0) <= hardwareTimer2Count;
                            
                            --Hardware Timer 3
                            when HARDWARE_TIMER_3_PRESCALER_ADDR => dataOut <= hardwareTimer3PrescalerReg;
                            when HARDWARE_TIMER_3_MODE_ADDR      => dataOut(1 downto 0) <= hardwareTimer3ModeReg;
                                                                     dataOut(2)          <= hardwareTimer3InterruptEn;
                            when HARDWARE_TIMER_3_MAX_COUNT_ADDR => dataOut(31 downto 0) <= hardwareTimer3MaxCountReg;
                            when HARDWARE_TIMER_3_COUNT_ADDR => dataOut(31 downto 0) <= hardwareTimer3Count;

                            
                            when others => 
                                -- Digital IO Pins Read
                                for i in 0 to numDigitalIO_Pins-1 loop
                                    if unsigned(address) = DIGITAL_IO_PIN_MODE_ADDR + i * 16 then
                                        dataOut(1 downto 0) <= IO_PinsDigitalModeReg(i*2 + 1 downto i*2);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DATA_IN_ADDR + i * 16 then
                                        dataOut(0) <= IO_PinsDigitalDataInReg(i);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DUTY_CYCLE_ADDR + i * 16 then
                                        dataOut(7 downto 0) <= IO_PinsDigitalDutyCycleReg(i*8 + 7 downto i*8);
                                    elsif unsigned(address) = DIGITAL_IO_PIN_DATA_OUT_ADDR + i * 16 then
                                        dataOut(0) <= IO_PinsDigitalDataOut(i);
                                    end if;
                                end loop;
                        end case;
                    end if;
                --end if;
            end if;
        end if;
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
          numSevenSegmentDisplays 			    => numSevenSegmentDisplays,
		  individualSevenSegmentDisplayControll => individualSevenSegmentDisplayControll
		  
    )
    port map(
        enable      					=> enable,               
        reset       					=> reset,   
        clk         					=> clk,          
        sevenSegmentLEDs        	=> sevenSegmentLEDs,         
        sevenSegmentAnodes       => sevenSegmentAnodes,         
        dataIn      					=> SevenSegmentDisplayDataReg,    
        controlIn   					=> SevenSegmentDisplayControlReg         
    );

    clockController_inst : clockController
    port map(
        reset               => reset,
        clk                 => clk,
        enable              => enable,
        manualClk           => manualClk,
        manualClocking      => manualClocking,
        alteredClk          => alteredClk,
        prescalerIn         => clockControllerPrescalerReg,
        programmingMode     => programmingMode
    );
    alteredClkOut <= alteredClk;
    --alteredClkOut <= '1';

    serialInterface_inst : serialInterface
    generic map(
        numCPU_CoreDebugSignals  => numCPU_CoreDebugSignals,
        numExternalDebugSignals  => numExternalDebugSignals
    )
    port map(
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
        tx                      => tx,
        status                  => serialInterfaceStatus,
        dataReceived            => serialDataReceived,
        dataAvailableInterrupt  => serialDataAvailableInterrupt
    );
    
    hardwareTimer0_inst : hardwareTimer
    generic map(
        countWidth              => 8
    )
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        prescaler               => hardwareTimer0PrescalerReg,
        mode                    => hardwareTimer0ModeReg,
        interruptClr            => '0',
        maxCount                => hardwareTimer0MaxCountReg,
        
        interruptEn             => hardwareTimer0InterruptEn,
        
        -- Outputs 
        count                   => hardwareTimer0Count,
        interrupt               => hardwareTimer0Interrupt
    );

    hardwareTimer1_inst : hardwareTimer
    generic map(
        countWidth              => 16
    )
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        prescaler               => hardwareTimer1PrescalerReg,
        mode                    => hardwareTimer1ModeReg,
        interruptClr            => '0',
        maxCount                => hardwareTimer1MaxCountReg,
        
        interruptEn             => hardwareTimer1InterruptEn,
        
        -- Outputs 
        count                   => hardwareTimer1Count,
        interrupt               => hardwareTimer1Interrupt
    );

    hardwareTimer2_inst : hardwareTimer
    generic map(
        countWidth              => 16
    )
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        prescaler               => hardwareTimer2PrescalerReg,
        mode                    => hardwareTimer2ModeReg,
        interruptClr            => '0',
        maxCount                => hardwareTimer2MaxCountReg,
        
        interruptEn             => hardwareTimer2InterruptEn,
        
        -- Outputs 
        count                   => hardwareTimer2Count,
        interrupt               => hardwareTimer2Interrupt
    );

    hardwareTimer3_inst : hardwareTimer
    generic map(
        countWidth              => 32
    )
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        prescaler               => hardwareTimer3PrescalerReg,
        mode                    => hardwareTimer3ModeReg,
        interruptClr            => '0',
        maxCount                => hardwareTimer3MaxCountReg,
        
        interruptEn             => hardwareTimer3InterruptEn,
        
        -- Outputs 
        count                   => hardwareTimer3Count,
        interrupt               => hardwareTimer3Interrupt
    );
    
    
    GEN_IO_PINS : for i in 0 to numDigitalIO_Pins-1 generate
    begin
        IO_PinDigital_inst : IO_PinDigital
        port map (
            pin       => digitalIO_pins(i),
            dutyCycle => IO_PinsDigitalDutyCycleReg(i*8+7 downto i*8),  
            mode      => IO_PinsDigitalModeReg(i*2+1 downto i*2),       
            dataIn    => IO_PinsDigitalDataInReg(i),                     
            dataOut   => IO_PinsDigitalDataOut(i),                      
            count     => hardwareTimer0Count
        );
    end generate GEN_IO_PINS;

    
end Behavioral;
