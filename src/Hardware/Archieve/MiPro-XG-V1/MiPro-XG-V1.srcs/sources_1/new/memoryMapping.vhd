library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoryMapping is
    generic(
        numInterrupts            : integer;
        numSevenSegmentDisplays  : integer;
        numCPU_CoreDebugSignals  : integer;
        numExternalDebugSignals  : integer
    );
    Port (
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
        seg                          : out std_logic_vector(6 downto 0);
        an                           : out std_logic_vector(numSevenSegmentDisplays-1 downto 0);

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
        pwm                          : out std_logic_vector(7 downto 0);

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
    
    constant HARDWARE_TIMER_0_PWM_VALUE_ADDR   : std_logic_vector(31 downto 0) := x"40000068";
    
    constant HARDWARE_TIMER_1_PWM_VALUE_ADDR   : std_logic_vector(31 downto 0) := x"4000006C";
    
    constant HARDWARE_TIMER_2_PWM_VALUE_ADDR   : std_logic_vector(31 downto 0) := x"40000070";
    
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
    signal serialInterfacePrescalerReg : std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(5208, 32)); --9600 baud @50mHz
    
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
    signal hardwareTimer0PrescalerReg : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(200, 32));
    signal hardwareTimer0ModeReg      : std_logic_vector(3 downto 0) := "0100";
    signal hardwareTimer0MaxCountReg  : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer0pwmValueReg  : std_logic_vector(7 downto 0);
    
    signal hardwareTimer1PrescalerReg : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(200, 32));
    signal hardwareTimer1ModeReg      : std_logic_vector(3 downto 0) := "0100";
    signal hardwareTimer1MaxCountReg  : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer1pwmValueReg  : std_logic_vector(7 downto 0);
    
    signal hardwareTimer2PrescalerReg : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(200, 32));
    signal hardwareTimer2ModeReg      : std_logic_vector(3 downto 0) := "0100";
    signal hardwareTimer2MaxCountReg  : std_logic_vector(31 downto 0) := (others => '0');
    signal hardwareTimer2pwmValueReg  : std_logic_vector(7 downto 0);
    

    --signals:
    signal hardwareTimer0CountValue   : std_logic_vector(31 downto 0);
    
    signal hardwareTimer1CountValue   : std_logic_vector(31 downto 0);
    
    signal hardwareTimer2CountValue   : std_logic_vector(31 downto 0);

    component hardwareTimer is
        Port (
            enable                   : in std_logic;
            reset                    : in std_logic;
            clk                      : in std_logic;
            pwmValue                 : in std_logic_vector(7 downto 0);
            prescaler                : in std_logic_vector(31 downto 0);
            mode                     : in std_logic_vector(3 downto 0);
            maxCount                 : in std_logic_vector(31 downto 0);
            
            --outputs 
            PWMPin                   : out std_logic;
            countValue               : out std_logic_vector(31 downto 0)
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
            SevenSegmentDisplayDataReg <= (others => '0');
            SevenSegmentDisplayControlReg <= (others => '0');
            serialInterfacePrescalerReg <= std_logic_vector(to_unsigned(5208, 32)); --9600 baud @ 50 mHz default
            clockControllerPrescalerReg <= std_logic_vector(to_unsigned(0, 32)); --max clk frequency
            memOpFinished <= '0';
            dataOut <= (others => '0');
            readOnlyInterruptReg <= '0';
            readFromSerialReceiveFIFO_reg <= '0';
            
            hardwareTimer0pwmValueReg  <= (others => '0');
            
            hardwareTimer1pwmValueReg  <= (others => '0');
            
            hardwareTimer2pwmValueReg  <= (others => '0');
            
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
                debugSignalsReg <= SevenSegmentDisplayDataReg & SevenSegmentDisplayControlReg & clockControllerPrescalerReg & serialInterfacePrescalerReg & CPU_CoreDebugSignals & hardwareTimer0pwmValueReg & hardwareTimer1pwmValueReg & hardwareTimer2pwmValueReg;
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

                            when SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => SevenSegmentDisplayControlReg <= dataIn;
                            when SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => SevenSegmentDisplayDataReg    <= dataIn;

                            when CLOCK_CONTROLLER_PRESCALER_ADDR => clockControllerPrescalerReg <= dataIn;
                            
                            when SERIAL_INTERFACE_PRESCALER_ADDR => serialInterfacePrescalerReg <= dataIn;
                            when SERIAL_INTERFACE_STATUS_ADDR => readOnlyInterruptReg <= '1';
                            
                            when HARDWARE_TIMER_0_PWM_VALUE_ADDR => hardwareTimer0pwmValueReg <= dataIn(7 downto 0);
                            
                            when HARDWARE_TIMER_1_PWM_VALUE_ADDR => hardwareTimer1pwmValueReg <= dataIn(7 downto 0);
                            
                            when HARDWARE_TIMER_2_PWM_VALUE_ADDR => hardwareTimer2pwmValueReg <= dataIn(7 downto 0);

                            when others => null;

                        end case;
                    elsif readEn = '1' then
                        memOpFinished <= '1';
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

                            when SEVEN_SEGMENT_DISPLAY_CONTROL_ADDR => dataOut <= SevenSegmentDisplayControlReg;
                            when SEVEN_SEGMENT_DISPLAY_DATA_ADDR    => dataOut <= SevenSegmentDisplayDataReg;

                            when CLOCK_CONTROLLER_PRESCALER_ADDR => dataOut <= clockControllerPrescalerReg;

                            when SERIAL_INTERFACE_PRESCALER_ADDR => dataOut <= serialInterfacePrescalerReg;
                            when SERIAL_INTERFACE_STATUS_ADDR => dataOut(7 downto 0) <= serialInterfaceStatus;
                            when SERIAL_INTERFACE_FIFOS_ADDR => 
                                dataOut(8 downto 0) <= serialDataReceived;
                                readFromSerialReceiveFIFO_reg <= '1';
                                
                            when HARDWARE_TIMER_0_PWM_VALUE_ADDR => dataOut(7 downto 0) <= hardwareTimer0pwmValueReg;
                            
                            when HARDWARE_TIMER_1_PWM_VALUE_ADDR => dataOut(7 downto 0) <= hardwareTimer1pwmValueReg;
                            
                            when HARDWARE_TIMER_2_PWM_VALUE_ADDR => dataOut(7 downto 0) <= hardwareTimer2pwmValueReg;
                            
                            when others => dataOut <= (others => '0');
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
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        pwmValue                => hardwareTimer0pwmValueReg,
        prescaler               => hardwareTimer0PrescalerReg,
        mode                    => hardwareTimer0ModeReg,
        maxCount                => hardwareTimer0MaxCountReg,
        
        --outputs 
        PWMPin                  => pwm(0),
        countValue              => hardwareTimer0CountValue
    );
    
    hardwareTimer1_inst : hardwareTimer
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        pwmValue                => hardwareTimer1pwmValueReg,
        prescaler               => hardwareTimer1PrescalerReg,
        mode                    => hardwareTimer1ModeReg,
        maxCount                => hardwareTimer1MaxCountReg,
        
        --outputs 
        PWMPin                  => pwm(1),
        countValue              => hardwareTimer1CountValue
    );
    
    hardwareTimer2_inst : hardwareTimer
    port map(
        enable                  => enable,
        reset                   => reset,
        clk                     => clk,
        pwmValue                => hardwareTimer2pwmValueReg,
        prescaler               => hardwareTimer2PrescalerReg,
        mode                    => hardwareTimer2ModeReg,
        maxCount                => hardwareTimer2MaxCountReg,
        
        --outputs 
        PWMPin                  => pwm(2),
        countValue              => hardwareTimer2CountValue
    );

    pwm(7 downto 3) <= "00000";

end Behavioral;
