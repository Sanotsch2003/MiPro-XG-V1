library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity serialInterface is
    generic(
        numCPU_CoreDebugSignals  : integer;
        numExternalDebugSignals  : integer
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
end serialInterface;

architecture Behavioral of serialInterface is  
    -- Function to compute the next highest integer divisible by 7
    function next_multiple_of_7(a : integer) return integer is
        variable total   : integer;
        variable remainder : integer;
    begin
        -- Add the three integers
        total := a;
    
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
    
    -- Function to compute the number of frames that need to be sent
    function get_num_of_debug_frames(a : integer) return integer is
    variable result : integer;
    begin
        -- Perform the calculation: roundup((a + b) / 7) + 1
        result := (a + 6) / 7;  -- Adding 6 ensures rounding up
        return result;
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
    type receiveStateType is (RECEIVE_IDLE, RECEIVE_START_BIT, RECEIVE_DATA, RECEIVE_PARITY_BIT, RECEIVE_STOP_BIT);
    signal receiveState : receiveStateType;

    type receiveFIFO_regType is array (0 to 15) of std_logic_vector(8 downto 0);
    signal receiveFIFO_reg                          : receiveFIFO_regType;
    signal receiveFIFO_reg_writePtr                 : unsigned(3 downto 0);
    signal receiveFIFO_regReadPtr                   : unsigned(3 downto 0);
    signal receiveFIFO_regNumBytesReceived          : std_logic_vector(3 downto 0);

    signal countReceiveCycles                       : integer range 0 to 2147483647; --32 bit
    signal countBitsReceived                        : integer range 0 to 15 := 0;
    signal receiveRegister                          : std_logic_vector(7 downto 0);
    signal parityBitRegister                        : std_logic;
    signal readFromReceiveFIFO_regShiftReg          : std_logic_vector(1 downto 0);
    signal rxStable : std_logic := '1';
    signal rxShiftReg : std_logic_vector(4 downto 0) := (others => '1');

    --Debugging
    signal currentlyDebugging           : std_logic;
    signal debugPtr                     : unsigned(12 downto 0);
    constant NUM_DEBUG_FRAMES           : integer := get_num_of_debug_frames(numExternalDebugSignals + numCPU_CoreDebugSignals);
    constant DEBUG_DELIMITER            : std_logic_vector(7 downto 0) := "11111111";
    constant DEBUG_DATA_SIZE            : integer := next_multiple_of_7(numExternalDebugSignals + numCPU_CoreDebugSignals);
    signal debugData                    : std_logic_vector(DEBUG_DATA_SIZE-1 downto 0) := (others => '0');
    
begin
    debugData(DEBUG_DATA_SIZE-1 downto DEBUG_DATA_SIZE-(numExternalDebugSignals+numCPU_CoreDebugSignals)) <= debugSignals;

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
                        if debugPtr = NUM_DEBUG_FRAMES then
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

    --process for removing noise from the rx signal
    process(clk, reset)
    begin
        if reset = '1' then
            rxShiftReg <= (others => '1');
            rxStable <= '1';
        elsif rising_edge(clk) then
            -- Shift the current rx value into the shift register
            rxShiftReg <= rxShiftReg(3 downto 0) & rx;
            -- Check if all bits in the shift register are the same
            if rxShiftReg = "00000" then
                rxStable <= '0'; -- Glitch-free low
            elsif rxShiftReg = "11111" then
                rxStable <= '1'; -- Glitch-free high
            end if;
        end if;
    end process;

    --process for receiving data
    process(clk, reset)
    variable onesCount : integer range 0 to 8;
    variable expectedParity : std_logic;
    variable error : std_logic;
    begin
        if reset = '1' then
            receiveState <= RECEIVE_IDLE;
            countReceiveCycles <= 0;
            countBitsReceived <= 0;
            receiveRegister <= (others => '0');
            parityBitRegister <= '0';
            receiveFIFO_reg_writePtr <= (others => '0');
            receiveFIFO_reg <= (others => (others => '0'));
        
        elsif rising_edge(clk) then
            case receiveState is 

            when RECEIVE_IDLE =>
                if rxStable = '1' then
                    receiveState <= RECEIVE_IDLE;
                else
                    receiveState <= RECEIVE_START_BIT;
                    countReceiveCycles <= 0;
                end if;

            when RECEIVE_START_BIT =>
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = to_integer(unsigned(prescaler)) then
                    receiveState <= RECEIVE_DATA;
                    countReceiveCycles <= 0;
                    countBitsReceived <= 0;
                else
                    receiveState <= RECEIVE_START_BIT;
                end if;

            when RECEIVE_DATA =>
                receiveState <= RECEIVE_DATA;
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = to_integer(unsigned(prescaler))/2 then --Check if we are in the middle of a bit.
                    receiveRegister(countBitsReceived) <= rxStable;
                elsif countReceiveCycles = to_integer(unsigned(prescaler)) then
                    countBitsReceived <= countBitsReceived + 1;
                    countReceiveCycles <= 0;
                end if;
                if countBitsReceived >= 8 then
                    receiveState <= RECEIVE_PARITY_BIT;
                    countReceiveCycles <= 0;
                end if;

                

            when RECEIVE_PARITY_BIT =>
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = to_integer(unsigned(prescaler))/2 then --Check if we are in the middle of a bit.
                    parityBitRegister <= rxStable;
                elsif countReceiveCycles = to_integer(unsigned(prescaler)) then
                    receiveState <= RECEIVE_STOP_BIT;
                    countReceiveCycles <= 0;
                end if;
                

            when RECEIVE_STOP_BIT => --one stop bit
                --sample stop bit
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = to_integer(unsigned(prescaler))/2 then --Check if we are in the middle of a bit.
                    --check if stop bit is actually 1
                    if rxStable = '1' then --no error occuredy
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

                    else --error occured
                        error := '1';
                    end if;
                    
                    --Add received bit and error to the receive FIFO register.
                    if receiveFIFO_regNumBytesReceived /= "1111" then --Make sure FIFO is not full.
                        receiveFIFO_reg(to_integer(receiveFIFO_reg_writePtr)) <= error & receiveRegister;
                        receiveFIFO_reg_writePtr <= receiveFIFO_reg_writePtr + 1;
                    end if;
                    receiveState <= RECEIVE_IDLE; --Go back to the IDLE state.
                end if;

            when others =>
                receiveState <= RECEIVE_IDLE;

            end case;
        end if;
    
    end process;

    --process for increasing write read receiveFIFO_regReadPtr
    process(clk, reset)
    begin
        if reset = '1' then
            receiveFIFO_regReadPtr <= (others => '0');
            readFromReceiveFIFO_regShiftReg <= (others => '0');
        elsif rising_edge(clk) then
            readFromReceiveFIFO_regShiftReg <= readFromReceiveFIFO_regShiftReg(0) & readFromReceiveFIFO_reg;
            if readFromReceiveFIFO_regShiftReg = "01" then
                receiveFIFO_regReadPtr <= receiveFIFO_regReadPtr + 1; --Increment the pointer @ rising edge of the readFromReceiveFIFO_reg signal.
            end if;
        end if;
    end process;

    --component outputs
    process(receiveFIFO_reg, receiveFIFO_regReadPtr, receiveFIFO_regNumBytesReceived)
    begin
        if receiveFIFO_regNumBytesReceived /= "0000" then
            dataReceived <= receiveFIFO_reg(to_integer(receiveFIFO_regReadPtr));
        else
            dataReceived <= (others => '0');
        end if;
    end process;

    receiveFIFO_regNumBytesReceived <= std_logic_vector(receiveFIFO_reg_writePtr - receiveFIFO_regReadPtr);
    transmitFIFO_regNumBytesEmpty <= std_logic_vector(15-(transmitFIFO_regWritePtr - transmitFIFO_regReadPtr));
    
    dataAvailableInterrupt <= receiveFIFO_regNumBytesReceived(3) or receiveFIFO_regNumBytesReceived(2) or receiveFIFO_regNumBytesReceived(1) or receiveFIFO_regNumBytesReceived(0);
    status <= receiveFIFO_regNumBytesReceived & transmitFIFO_regNumBytesEmpty;
    --status <= "00110101";
 
end Behavioral;