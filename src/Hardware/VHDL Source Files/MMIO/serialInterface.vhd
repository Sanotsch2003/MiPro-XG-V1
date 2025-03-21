LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY serialInterface IS
    GENERIC (
        numCPU_CoreDebugSignals : INTEGER;
        numExternalDebugSignals : INTEGER
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
END serialInterface;

ARCHITECTURE Behavioral OF serialInterface IS
    -- Function to compute the next highest integer divisible by 7
    FUNCTION next_multiple_of_7(a : INTEGER) RETURN INTEGER IS
        VARIABLE total                : INTEGER;
        VARIABLE remainder            : INTEGER;
    BEGIN
        -- Add the three integers
        total := a;

        -- Compute the remainder when divided by 7
        remainder := total MOD 7;

        -- If remainder is 0, it's already divisible by 7
        IF remainder = 0 THEN
            RETURN total;
        ELSE
            -- Add (7 - remainder) to get the next multiple of 7
            RETURN total + (7 - remainder);
        END IF;
    END FUNCTION;

    -- Function to compute the number of frames that need to be sent
    FUNCTION get_num_of_debug_frames(a : INTEGER) RETURN INTEGER IS
        VARIABLE result                    : INTEGER;
    BEGIN
        -- Perform the calculation: roundup((a + b) / 7) + 1
        result := (a + 6) / 7; -- Adding 6 ensures rounding up
        RETURN result;
    END FUNCTION;

    --General

    --Transmitting
    TYPE transmitFIFO_regType IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL transmitFIFO_reg, transmitFIFO_reg_nxt                 : transmitFIFO_regType;
    SIGNAL transmitFIFO_regWritePtr, transmitFIFO_regWritePtr_nxt : unsigned(3 DOWNTO 0);
    SIGNAL transmitFIFO_regReadPtr                                : unsigned(3 DOWNTO 0);
    SIGNAL transmitFIFO_regNumBytesEmpty                          : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL countTransmitCycles          : unsigned(31 DOWNTO 0);
    SIGNAL countBitsTransmitted         : unsigned(3 DOWNTO 0);
    CONSTANT BITS_PER_FRAME_TRANSMITTED : INTEGER := 11;
    SIGNAL loadTransmitFIFO_regShiftReg : STD_LOGIC_VECTOR(1 DOWNTO 0);

    --Receiving
    TYPE receiveStateType IS (RECEIVE_IDLE, RECEIVE_START_BIT, RECEIVE_DATA, RECEIVE_PARITY_BIT, RECEIVE_STOP_BIT);
    SIGNAL receiveState : receiveStateType;

    TYPE receiveFIFO_regType IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL receiveFIFO_reg                 : receiveFIFO_regType;
    SIGNAL receiveFIFO_reg_writePtr        : unsigned(3 DOWNTO 0);
    SIGNAL receiveFIFO_regReadPtr          : unsigned(3 DOWNTO 0);
    SIGNAL receiveFIFO_regNumBytesReceived : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL countReceiveCycles              : INTEGER RANGE 0 TO 2147483647; --32 bit
    SIGNAL countBitsReceived               : INTEGER RANGE 0 TO 15 := 0;
    SIGNAL receiveRegister                 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL parityBitRegister               : STD_LOGIC;
    SIGNAL readFromReceiveFIFO_regShiftReg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL rxStable                        : STD_LOGIC                    := '1';
    SIGNAL rxShiftReg                      : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '1');

    --Debugging
    SIGNAL currentlyDebugging : STD_LOGIC;
    SIGNAL debugPtr           : unsigned(12 DOWNTO 0);
    CONSTANT NUM_DEBUG_FRAMES : INTEGER                                        := get_num_of_debug_frames(numExternalDebugSignals + numCPU_CoreDebugSignals);
    CONSTANT DEBUG_DELIMITER  : STD_LOGIC_VECTOR(7 DOWNTO 0)                   := "11111111";
    CONSTANT DEBUG_DATA_SIZE  : INTEGER                                        := next_multiple_of_7(numExternalDebugSignals + numCPU_CoreDebugSignals);
    SIGNAL debugData          : STD_LOGIC_VECTOR(DEBUG_DATA_SIZE - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    debugData(DEBUG_DATA_SIZE - 1 DOWNTO DEBUG_DATA_SIZE - (numExternalDebugSignals + numCPU_CoreDebugSignals)) <= debugSignals;

    --Managing counters and register updates for transmitting data.
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            countTransmitCycles          <= (OTHERS => '0');
            countBitsTransmitted         <= (OTHERS => '0');
            currentlyDebugging           <= '0';
            debugPtr                     <= (OTHERS => '0');
            transmitFIFO_regReadPtr      <= (OTHERS => '0');
            transmitFIFO_regWritePtr     <= (OTHERS => '0');
            transmitFIFO_reg             <= (OTHERS => (OTHERS => '0'));
            loadTransmitFIFO_regShiftReg <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                --updating registers
                transmitFIFO_regWritePtr <= transmitFIFO_regWritePtr_nxt;
                transmitFIFO_reg         <= transmitFIFO_reg_nxt;

                --Shifting register to detect rising edge of 'loadTransmitFIFO_reg' signal.
                loadTransmitFIFO_regShiftReg <= loadTransmitFIFO_regShiftReg(0) & loadTransmitFIFO_reg;

                IF currentlyDebugging = '1' OR (transmitFIFO_regNumBytesEmpty /= "1111") THEN
                    countTransmitCycles <= countTransmitCycles + 1;
                END IF;
                IF countTransmitCycles = unsigned(prescaler) - 1 THEN
                    countTransmitCycles  <= (OTHERS => '0');
                    countBitsTransmitted <= countBitsTransmitted + 1;
                    IF countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED - 1 THEN
                        countBitsTransmitted <= (OTHERS => '0');
                        IF currentlyDebugging = '1' THEN
                            debugPtr <= debugPtr + 1;
                            IF debugPtr = NUM_DEBUG_FRAMES THEN
                                debugPtr <= (OTHERS => '0');
                            END IF;
                        ELSE
                            transmitFIFO_regReadPtr <= transmitFIFO_regReadPtr + 1;
                        END IF;
                    END IF;

                END IF;

                -- Switching on and off debugging mode.
                IF currentlyDebugging = '0' AND debugMode = '1' THEN
                    currentlyDebugging   <= '1';
                    countTransmitCycles  <= (OTHERS => '0');
                    countBitsTransmitted <= (OTHERS => '0');
                    debugPtr             <= (OTHERS => '0');
                ELSIF currentlyDebugging = '1' AND debugMode = '0' THEN
                    countTransmitCycles  <= (OTHERS => '0');
                    countBitsTransmitted <= (OTHERS => '0');
                    debugPtr             <= (OTHERS => '0');
                    currentlyDebugging   <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    --Setting the tx signal based on counters.
    PROCESS (countBitsTransmitted, currentlyDebugging, debugData, debugPtr, transmitFIFO_regNumBytesEmpty, transmitFIFO_reg, transmitFIFO_regReadPtr)
    BEGIN
        IF currentlyDebugging = '1' OR (transmitFIFO_regNumBytesEmpty /= "1111") THEN
            IF countBitsTransmitted = 0 OR countBitsTransmitted = BITS_PER_FRAME_TRANSMITTED - 1 THEN
                tx <= '1';
            ELSIF countBitsTransmitted = 1 THEN
                tx <= '0';
            ELSE
                IF currentlyDebugging = '1' THEN
                    IF debugPtr = 0 THEN
                        tx <= DEBUG_DELIMITER(to_integer(countBitsTransmitted) - 2);
                    ELSE
                        IF countBitsTransmitted = 2 THEN
                            tx <= '0';
                        ELSE
                            tx <= debugData((to_integer(debugPtr) - 1) * 7 + (to_integer(countBitsTransmitted) - 3));
                        END IF;
                    END IF;
                ELSE
                    tx <= transmitFIFO_reg(to_integer(transmitFIFO_regReadPtr))(to_integer(countBitsTransmitted - 2));
                END IF;
            END IF;
        ELSE
            tx <= '1';
        END IF;
    END PROCESS;

    --Managing writing to transmitFIFO_reg.
    PROCESS (loadTransmitFIFO_regShiftReg, transmitFIFO_regNumBytesEmpty, transmitFIFO_regWritePtr, dataToTransmit, transmitFIFO_reg)
    BEGIN
        --default assignments
        transmitFIFO_regWritePtr_nxt <= transmitFIFO_regWritePtr;
        transmitFIFO_reg_nxt         <= transmitFIFO_reg;

        IF loadTransmitFIFO_regShiftReg = "01" THEN     --Detecting rising edge of 'readFromReceiveFIFO_reg' signal.
            IF transmitFIFO_regNumBytesEmpty /= "0000" THEN --Check if there is still space inside the Transmit FIFO Register.
                transmitFIFO_reg_nxt(to_integer(transmitFIFO_regWritePtr)) <= dataToTransmit;
                transmitFIFO_regWritePtr_nxt                               <= transmitFIFO_regWritePtr + 1;
            END IF;
        END IF;

    END PROCESS;

    --process for removing noise from the rx signal
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            rxShiftReg <= (OTHERS => '1');
            rxStable   <= '1';
        ELSIF rising_edge(clk) THEN
            -- Shift the current rx value into the shift register
            rxShiftReg <= rxShiftReg(3 DOWNTO 0) & rx;
            -- Check if all bits in the shift register are the same
            IF rxShiftReg = "00000" THEN
                rxStable <= '0'; -- Glitch-free low
            ELSIF rxShiftReg = "11111" THEN
                rxStable <= '1'; -- Glitch-free high
            END IF;
        END IF;
    END PROCESS;

    --process for receiving data
    PROCESS (clk, reset)
        VARIABLE onesCount      : INTEGER RANGE 0 TO 8;
        VARIABLE expectedParity : STD_LOGIC;
        VARIABLE error          : STD_LOGIC;
    BEGIN
        IF reset = '1' THEN
            receiveState             <= RECEIVE_IDLE;
            countReceiveCycles       <= 0;
            countBitsReceived        <= 0;
            receiveRegister          <= (OTHERS => '0');
            parityBitRegister        <= '0';
            receiveFIFO_reg_writePtr <= (OTHERS => '0');
            receiveFIFO_reg          <= (OTHERS => (OTHERS => '0'));

        ELSIF rising_edge(clk) THEN
            CASE receiveState IS

                WHEN RECEIVE_IDLE =>
                    IF rxStable = '1' THEN
                        receiveState <= RECEIVE_IDLE;
                    ELSE
                        receiveState       <= RECEIVE_START_BIT;
                        countReceiveCycles <= 0;
                    END IF;

                WHEN RECEIVE_START_BIT =>
                    countReceiveCycles <= countReceiveCycles + 1;
                    IF countReceiveCycles = to_integer(unsigned(prescaler)) THEN
                        receiveState       <= RECEIVE_DATA;
                        countReceiveCycles <= 0;
                        countBitsReceived  <= 0;
                    ELSE
                        receiveState <= RECEIVE_START_BIT;
                    END IF;

                WHEN RECEIVE_DATA =>
                    receiveState       <= RECEIVE_DATA;
                    countReceiveCycles <= countReceiveCycles + 1;
                    IF countReceiveCycles = to_integer(unsigned(prescaler))/2 THEN --Check if we are in the middle of a bit.
                        receiveRegister(countBitsReceived) <= rxStable;
                    ELSIF countReceiveCycles = to_integer(unsigned(prescaler)) THEN
                        countBitsReceived  <= countBitsReceived + 1;
                        countReceiveCycles <= 0;
                    END IF;
                    IF countBitsReceived >= 8 THEN
                        receiveState       <= RECEIVE_PARITY_BIT;
                        countReceiveCycles <= 0;
                    END IF;

                WHEN RECEIVE_PARITY_BIT =>
                    countReceiveCycles <= countReceiveCycles + 1;
                    IF countReceiveCycles = to_integer(unsigned(prescaler))/2 THEN --Check if we are in the middle of a bit.
                        parityBitRegister <= rxStable;
                    ELSIF countReceiveCycles = to_integer(unsigned(prescaler)) THEN
                        receiveState       <= RECEIVE_STOP_BIT;
                        countReceiveCycles <= 0;
                    END IF;
                WHEN RECEIVE_STOP_BIT => --one stop bit
                    --sample stop bit
                    countReceiveCycles <= countReceiveCycles + 1;
                    IF countReceiveCycles = to_integer(unsigned(prescaler))/2 THEN --Check if we are in the middle of a bit.
                        --check if stop bit is actually 1
                        IF rxStable = '1' THEN --no error occuredy
                            --calculate expected parity.
                            onesCount := 0;
                            FOR i IN 0 TO 7 LOOP
                                IF receiveRegister(i) = '1' THEN
                                    onesCount := onesCount + 1;
                                END IF;
                            END LOOP;

                            -- Calculate parity.
                            IF onesCount MOD 2 = 0 THEN
                                expectedParity := '0'; -- Even parity
                            ELSE
                                expectedParity := '1'; -- Odd parity 
                            END IF;

                            error := NOT (expectedParity XOR parityBitRegister); --checks if the parity is the same as the expected parity.

                        ELSE --error occured
                            error := '1';
                        END IF;

                        --Add received bit and error to the receive FIFO register.
                        IF receiveFIFO_regNumBytesReceived /= "1111" THEN --Make sure FIFO is not full.
                            receiveFIFO_reg(to_integer(receiveFIFO_reg_writePtr)) <= error & receiveRegister;
                            receiveFIFO_reg_writePtr                              <= receiveFIFO_reg_writePtr + 1;
                        END IF;
                        receiveState <= RECEIVE_IDLE; --Go back to the IDLE state.
                    END IF;

                WHEN OTHERS =>
                    receiveState <= RECEIVE_IDLE;

            END CASE;
        END IF;

    END PROCESS;

    --process for increasing write read receiveFIFO_regReadPtr
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            receiveFIFO_regReadPtr          <= (OTHERS => '0');
            readFromReceiveFIFO_regShiftReg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            readFromReceiveFIFO_regShiftReg <= readFromReceiveFIFO_regShiftReg(0) & readFromReceiveFIFO_reg;
            IF readFromReceiveFIFO_regShiftReg = "01" THEN
                receiveFIFO_regReadPtr <= receiveFIFO_regReadPtr + 1; --Increment the pointer @ rising edge of the readFromReceiveFIFO_reg signal.
            END IF;
        END IF;
    END PROCESS;

    --component outputs
    PROCESS (receiveFIFO_reg, receiveFIFO_regReadPtr, receiveFIFO_regNumBytesReceived)
    BEGIN
        IF receiveFIFO_regNumBytesReceived /= "0000" THEN
            dataReceived <= receiveFIFO_reg(to_integer(receiveFIFO_regReadPtr));
        ELSE
            dataReceived <= (OTHERS => '0');
        END IF;
    END PROCESS;

    receiveFIFO_regNumBytesReceived <= STD_LOGIC_VECTOR(receiveFIFO_reg_writePtr - receiveFIFO_regReadPtr);
    transmitFIFO_regNumBytesEmpty   <= STD_LOGIC_VECTOR(15 - (transmitFIFO_regWritePtr - transmitFIFO_regReadPtr));

    dataAvailableInterrupt <= receiveFIFO_regNumBytesReceived(3) OR receiveFIFO_regNumBytesReceived(2) OR receiveFIFO_regNumBytesReceived(1) OR receiveFIFO_regNumBytesReceived(0);
    status                 <= receiveFIFO_regNumBytesReceived & transmitFIFO_regNumBytesEmpty;
    --status <= "00110101";

END Behavioral;