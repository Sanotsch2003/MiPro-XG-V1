library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--one dataFrame consists of 12 bits:
--|0         |1           |2-10|11         |
--|----------|------------|----|-----------|
--|default: 1|start bit: 0|data|stop bit: 1|

entity serialInterface is
    generic(
        numInterrupts            :integer := 5;
        numCPU_CoreDebugSignals  : integer := 867;
        numExternalDebugSignals  : integer := 128
    );
    Port (
            clk                : in std_logic;
            reset              : in std_logic;
            enable             : in std_logic;
            debugMode          : in std_logic;
            rx                 : in std_logic;
            tx                 : out std_logic;
            prescaler          : in std_logic_vector(31 downto 0);
            debugSignals       : in std_logic_vector(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts-1 downto 0)
    );
end serialInterface;

architecture Behavioral of serialInterface is
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
    
    type FIFO is array (0 to 15) of std_logic_vector(7 downto 0);

    --General
    --signal prescaler                    : unsigned(31 downto 0) := to_unsigned(10416, 20); --10416 : 9600 Baud

    --Receiving
    signal countReceiveCycles           : unsigned(19 downto 0);
    signal countBitsReceived            : unsigned(3 downto 0);
    signal currentlyReceiving           : std_logic;
    constant BITS_PER_FRAME_RECEIVED    : integer := 10;
    signal receiveRegister              : std_logic_vector(7 downto 0);
    signal stopBitReceived              : std_logic;

    --Transmitting
    signal countTransmitCycles          : unsigned(19 downto 0);
    signal countBitsTransmitted         : unsigned(3 downto 0);
    constant BITS_PER_FRAME_TRANSMITTED : integer := 11;

    --Debugging
    signal currentlyDebugging           : std_logic;
    signal debugPtr                     : unsigned(12 downto 0);
    constant NUM_DEBUG_FRAMES           : integer := 144; --Formula for Calculating the number of frames: roundUP(size(debugSignals)/7)+1 (+1, because of DELIMITER at the beginning of transmission)
    constant DEBUG_DELIMITER            : std_logic_vector(7 downto 0) := "11111111";
    constant DEBUG_DATA_SIZE            : integer := next_multiple_of_7(numExternalDebugSignals, numCPU_CoreDebugSignals, numInterrupts);
    signal debugData                    : std_logic_vector(DEBUG_DATA_SIZE-1 downto 0) := (others => '0');
    
begin

    --Transmitting DATA:

    debugData(DEBUG_DATA_SIZE-1 downto DEBUG_DATA_SIZE-(numExternalDebugSignals+numCPU_CoreDebugSignals+numInterrupts)) <= debugSignals;

    --managing counters for transmitting data
    process(clk, reset)
    begin
    if reset = '1' then
        countTransmitCycles <= (others => '0');
        countBitsTransmitted <= (others => '0');
        currentlyDebugging <= '0';
        debugPtr <= (others => '0');
    elsif rising_edge(clk) then
        if enable = '1' then
            if currentlyDebugging = '1' then
                --incrementing counters for debugging
                countTransmitCycles <= countTransmitCycles + 1;
                if countTransmitCycles = unsigned(prescaler)-1 then
                    countTransmitCycles <= (others => '0');
                    countBitsTransmitted <= countBitsTransmitted + 1;
                    if countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED-1 then
                        debugPtr <= debugPtr + 1;
                        countBitsTransmitted <= (others => '0');
                        if debugPtr = NUM_DEBUG_FRAMES-1 then
                            debugPtr <= (others => '0');
                        end if;
                    end if;
        
                end if;
            end if;

            -- Switching on and off debugging mode
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

    --setting the tx signal based on counters
    process(countBitsTransmitted, currentlyDebugging)
    begin
        if currentlyDebugging = '1' then
            if countBitsTransmitted = 0 or countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED - 1 then
                tx <= '1';
            elsif countBitsTransmitted = 1 then
                tx <= '0';
            else
                if debugPtr = 0 then
                    tx <= DEBUG_DELIMITER(to_integer(countBitsTransmitted)-2);
                else
                    if countBitsTransmitted = 2 then
                        tx <= '0';
                    else
                        tx <= debugData((to_integer(debugPtr)-1)*7 + (to_integer(countBitsTransmitted)-3)); 
                    end if;
                end if;
            end if;
        
        else
            tx <= '1';
        end if;
    end process;

    --Receiving Data:
    process(clk, reset)
    begin
    if reset = '1' then
        countReceiveCycles <= (others => '0');
        countBitsReceived <= (others => '0');
        currentlyReceiving <= '0';
    elsif rising_edge(clk) then
        if enable = '1' then
            --check if transmission has started
            if currentlyReceiving = '0' and rx = '0' then
                currentlyReceiving <= '1';
                countReceiveCycles <= (others => '0');
                countBitsReceived <= (others => '0');
            end if;

            if currentlyReceiving = '1' then
                countReceiveCycles <= countReceiveCycles + 1;
                if countReceiveCycles = unsigned(prescaler)-1 then
                    countReceiveCycles <= (others => '0');
                    countBitsReceived <= countBitsReceived + 1;
                end if;
            end if;

            if stopBitReceived = '1' then
                currentlyReceiving <= '0';
                countReceiveCycles <= (others => '0');
                countBitsReceived <= (others => '0');
            end if;
        end if;
    end if;
    end process;

    --latching received data into register
    process(clk, reset)
    begin
        if reset = '1' then
            receiveRegister <= (others => '0');
            stopBitReceived <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                stopBitReceived <= '0';
                if currentlyReceiving = '1' then
                    if countBitsReceived >= 1 and countBitsReceived <= 8 then
                        if countReceiveCycles = to_integer(shift_right(unsigned(prescaler), 1))-1 then --check if we are in the middle of a frame
                            receiveRegister (to_integer(countBitsReceived)-1) <= rx;
                        end if;
                    elsif countBitsReceived > 8 and rx = '1' then
                        stopBitReceived <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    
    --connect receive register to leds for visualization:
    
    --LED <= receiveRegister;
    
end Behavioral;


