library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity serialInterface is
    generic(
        numInterrupts            :integer := 5;
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
            debugSignals             : in std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts-1 downto 0);

            dataAvailableInterrupt   : out std_logic

            );
end serialInterface;

architecture Behavioral of serialInterface is
    --signal prescaler : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(217, 32)); --9600 baud @100mHz: std_logic_vector(to_unsigned(10416, 32))
    --signal debugSignals : std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts-1 downto 0) := (others => '1');
    
    -- Function to compute the next highest integer divisible by 7
    function next_multiple_of_7(a : integer; b : integer; c : integer) return integer is
        variable total   : integer;
        variable remainder : integer;
    begin
        -- Add the three integers
        total := a + b + c;
    
        -- Compute the remainder when divided by 7
        remainder := total mod 7;
    
        -- If remainder is 0, it's already divisible by 7
        if remainder = 0 then
            return total;
        else
            -- Add (7 - remainder) to get the next multiple of 7
            return total + (7 - remainder);
        end if;
    end function;

    --General

    --Transmitting
    type transmitFIFO_regType is array (0 to 15) of std_logic_vector(7 downto 0);
    signal transmitFIFO_reg, transmitFIFO_reg_nxt : transmitFIFO_regType;
    signal transmitFIFO_regWritePtr, transmitFIFO_regWritePtr_nxt : unsigned(3 downto 0);
    signal transmitFIFO_regReadPtr : unsigned(3 downto 0);
    signal transmitFIFO_regNumBytesEmpty : std_logic_vector(3 downto 0);

    signal countTransmitCycles          : unsigned(31 downto 0);
    signal countBitsTransmitted         : unsigned(3 downto 0);
    constant BITS_PER_FRAME_TRANSMITTED : integer := 11;
    signal loadTransmitFIFO_regShiftReg    : std_logic_vector(1 downto 0);

    --Receiving
    type receiveFIFO_regType is array (0 to 15) of std_logic_vector(8 downto 0);
    signal receiveFIFO_reg                          : receiveFIFO_regType;
    signal receiveFIFO_reg_writePtr                 : unsigned(3 downto 0);
    signal receiveFIFO_regReadPtr                   : unsigned(3 downto 0);
    signal receiveFIFO_regNumBytesReceived          : std_logic_vector(3 downto 0);

    signal countReceiveCycles                       : unsigned(19 downto 0);
    signal countBitsReceived                        : unsigned(3 downto 0);
    signal currentlyReceiving                       : std_logic;
    signal receiveRegister                          : std_logic_vector(7 downto 0);
    signal parityBitRegister                        : std_logic;
    signal readFromReceiveFIFO_regShiftReg          : std_logic_vector(1 downto 0);

    constant BITS_PER_FRAME_RECEIVED                : integer := 10;

    --Debugging
    signal currentlyDebugging           : std_logic;
    signal debugPtr                     : unsigned(12 downto 0);
    constant NUM_DEBUG_FRAMES           : integer := 144; --Formula for Calculating the number of frames: roundUP(size(debugSignals)/7)+1 (+1, because of DELIMITER at the beginning of transmission)
    constant DEBUG_DELIMITER            : std_logic_vector(7 downto 0) := "11111111";
    constant DEBUG_DATA_SIZE            : integer := next_multiple_of_7(numExternalDebugSignals, numCPU_CoreDebugSignals, numInterrupts);
    signal debugData                    : std_logic_vector(DEBUG_DATA_SIZE-1 downto 0) := (others => '0');
    
begin
    debugData(DEBUG_DATA_SIZE-1 downto DEBUG_DATA_SIZE-(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts)) <= debugSignals;

    --Managing counters and register updates for transmitting data.
    process(clk, reset)
    begin
    if reset = '1' then
        countTransmitCycles <= (others => '0');
        countBitsTransmitted <= (others => '0');
        currentlyDebugging <= '0';
        debugPtr <= (others => '0');
        transmitFIFO_regReadPtr <= (others => '0');
        transmitFIFO_regWritePtr <= (others => '0');
        transmitFIFO_reg <= (others => (others => '0'));
        loadTransmitFIFO_regShiftReg <= (others => '0');

    elsif rising_edge(clk) then
        if enable = '1' then
            --updating registers
            transmitFIFO_regWritePtr <= transmitFIFO_regWritePtr_nxt;
            transmitFIFO_reg <= transmitFIFO_reg_nxt;

            --Shifting register to detect rising edge of 'loadTransmitFIFO_reg' signal.
            loadTransmitFIFO_regShiftReg <= loadTransmitFIFO_regShiftReg(0) & loadTransmitFIFO_reg;

            if currentlyDebugging = '1' or (transmitFIFO_regNumBytesEmpty /= "1111") then
                countTransmitCycles <= countTransmitCycles + 1;
            end if;
            if countTransmitCycles = unsigned(prescaler)-1 then
                countTransmitCycles <= (others => '0');
                countBitsTransmitted <= countBitsTransmitted + 1;
                if countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED-1 then
                    countBitsTransmitted <= (others => '0');
                    if currentlyDebugging = '1' then
                        debugPtr <= debugPtr + 1;
                        if debugPtr = NUM_DEBUG_FRAMES-1 then
                            debugPtr <= (others => '0');
                        end if;
                    else
                        transmitFIFO_regReadPtr <= transmitFIFO_regReadPtr + 1;
                    end if;
                end if;
                
            end if;

            -- Switching on and off debugging mode.
            if currentlyDebugging = '0' and debugMode = '1' then
                currentlyDebugging <= '1';
                countTransmitCycles <= (others => '0');
                countBitsTransmitted <= (others => '0');
                debugPtr <= (others => '0');
            elsif currentlyDebugging = '1' and debugMode = '0' then
                countTransmitCycles <= (others => '0');
                countBitsTransmitted <= (others => '0');
                debugPtr <= (others => '0');
                currentlyDebugging <= '0';
            end if;
        end if;
    end if;
    end process;

    --Setting the tx signal based on counters.
    process(countBitsTransmitted, currentlyDebugging, debugData, debugPtr, transmitFIFO_regNumBytesEmpty, transmitFIFO_reg, transmitFIFO_regReadPtr)
    begin
        if currentlyDebugging = '1' or (transmitFIFO_regNumBytesEmpty /= "1111") then
            if countBitsTransmitted = 0 or countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED - 1 then
                tx <= '1';
            elsif countBitsTransmitted = 1 then
                tx <= '0';
            else
                if currentlyDebugging = '1' then
                    if debugPtr = 0 then
                        tx <= DEBUG_DELIMITER(to_integer(countBitsTransmitted)-2);
                    else
                        if countBitsTransmitted = 2 then
                            tx <= '0';
                        else
                            tx <= debugData((to_integer(debugPtr)-1)*7 + (to_integer(countBitsTransmitted)-3)); 
                        end if;
                    end if;
                else
                    tx <= transmitFIFO_reg(to_integer(transmitFIFO_regReadPtr))(to_integer(countBitsTransmitted-2));
                end if;
            end if;
        else
            tx <= '1';
        end if;
    end process;

    --Managing writing to transmitFIFO_reg.
    process(loadTransmitFIFO_regShiftReg, transmitFIFO_regNumBytesEmpty, transmitFIFO_regWritePtr, dataToTransmit, transmitFIFO_reg)
    begin
        --default assignments
        transmitFIFO_regWritePtr_nxt <= transmitFIFO_regWritePtr;
        transmitFIFO_reg_nxt <= transmitFIFO_reg;

        if loadTransmitFIFO_regShiftReg = "01" then --Detecting rising edge of 'readFromReceiveFIFO_reg' signal.
            if transmitFIFO_regNumBytesEmpty /= "0000" then --Check if there is still space inside the Transmit FIFO Register.
                transmitFIFO_reg_nxt(to_integer(transmitFIFO_regWritePtr)) <= dataToTransmit;
                transmitFIFO_regWritePtr_nxt <= transmitFIFO_regWritePtr + 1;
            end if;
        end if;
        
    end process;

    
    --Receiving.
    process(clk, reset)
    variable error : std_logic;
    variable onesCount : integer;
    variable expectedParity : std_logic;
    begin
    if reset = '1' then
        countReceiveCycles <= (others => '0');
        countBitsReceived <= (others => '0');
        currentlyReceiving <= '0';
        receiveRegister <= (others => '0');
        parityBitRegister <= '0';
        receiveFIFO_reg_writePtr <= (others => '0');
        receiveFIFO_regReadPtr <= (others => '0');
        readFromReceiveFIFO_regShiftReg <= (others => '0');
        receiveFIFO_reg <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if enable = '1' then
            --Shifting register to detect rising edge of 'readFromReceiveFIFO_reg' signal.
            readFromReceiveFIFO_regShiftReg <= readFromReceiveFIFO_regShiftReg(0) & readFromReceiveFIFO_reg;

            --check if transmission has started
            if currentlyReceiving = '0' and rx = '0' then
                currentlyReceiving <= '1';
                countReceiveCycles <= (others => '0');
                countBitsReceived <= (others => '0');
            end if;
            
            --counting
            if currentlyReceiving = '1' then
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = unsigned(prescaler)-1 then
                    countReceiveCycles <= (others => '0');
                    countBitsReceived <= countBitsReceived + 1;
                end if;
            end if;


            --writing data from rx signal to receive register based on counters.
            --Receiving the data.
            if countBitsReceived >= 1 and countBitsReceived <= 9 then
                if countReceiveCycles = to_integer(shift_right(unsigned(prescaler), 1))-1 then --Check if we are in the middle of a bit.
                    if countBitsReceived <= 8 then --data bits
                        receiveRegister(to_integer(countBitsReceived)-1) <= rx;
                    else
                        parityBitRegister <= rx; --Last bit of data transmission is parity bit.
                    end if;
                end if;

            elsif countBitsReceived > 8 and rx = '1' then
                --calculate expected parity.
                onesCount := 0;
                for i in 0 to 7 loop
                    if receiveRegister(i) = '1' then
                        onesCount := onesCount + 1;
                    end if;
                end loop;

                -- Calculate parity.
                if onesCount mod 2 = 0 then
                    expectedParity := '0';  -- Even parity
                else
                    expectedParity := '1';  -- Odd parity 
                end if;

                error := not (expectedParity xor parityBitRegister); --checks if the parity is the same as the expected parity.
                if receiveFIFO_regNumBytesReceived /= "1110" then --make sure FIFO is not full
                    receiveFIFO_reg(to_integer(receiveFIFO_reg_writePtr)) <= error & receiveRegister;
                    receiveFIFO_reg_writePtr <= receiveFIFO_reg_writePtr + 1;
                end if;
                --Reset counters and temporary signals.
                currentlyReceiving <= '0';
                countReceiveCycles <= (others => '0');
                countBitsReceived <= (others => '0');

            end if;
            
            --update the read Pointer
            if readFromReceiveFIFO_regShiftReg = "01" then --Detecting rising edge of 'readFromReceiveFIFO_reg' signal.
                if receiveFIFO_regNumBytesReceived /= "0000" then --Check if there is still space inside the Receive FIFO Register.
                    receiveFIFO_regReadPtr <= receiveFIFO_regReadPtr + 1;
                end if;
            end if;

        end if;
    end if;
    end process;



    receiveFIFO_regNumBytesReceived <= std_logic_vector(receiveFIFO_reg_writePtr - receiveFIFO_regReadPtr);
    transmitFIFO_regNumBytesEmpty <= std_logic_vector(15-(transmitFIFO_regWritePtr - transmitFIFO_regReadPtr));
    
    --component outputs
    process(receiveFIFO_reg, receiveFIFO_regReadPtr)
    begin
        if receiveFIFO_regNumBytesReceived /= "0000" then
            dataReceived <= receiveFIFO_reg(to_integer(receiveFIFO_regReadPtr));
        else
            dataReceived <= (others => '0');
        end if;
    end process;
    dataAvailableInterrupt <= receiveFIFO_regNumBytesReceived(3) or receiveFIFO_regNumBytesReceived(2) or receiveFIFO_regNumBytesReceived(1) or receiveFIFO_regNumBytesReceived(0);
    status <= receiveFIFO_regNumBytesReceived & transmitFIFO_regNumBytesEmpty;
    --test
    --LED(7 downto 0) <= receiveRegister;
    --LED(15) <= parityBitRegister;
    
end Behavioral;