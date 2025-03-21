LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY addressDecoder IS
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
        imageBufferWriteEn         : OUT STD_LOGIC;

        dataFromMem                 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataFromMemoryMappedDevices : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataFromImageBuffer         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataOut                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        --interrupts
        addressAlignmentInterrupt    : OUT STD_LOGIC;
        addressAlignmentInterruptClr : IN STD_LOGIC
    );
END addressDecoder;

ARCHITECTURE Behavioral OF addressDecoder IS
    SIGNAL addressAlignmentInterruptReg     : STD_LOGIC;
    SIGNAL addressAlignmentInterruptReg_nxt : STD_LOGIC;

    CONSTANT IMAGE_BUFFER_STARTING_ADDRESS : unsigned(31 DOWNTO 0) := x"80000000";
    CONSTANT IMAGE_BUFFER_ENDING_ADDRESS   : unsigned(31 DOWNTO 0) := x"80009600";

BEGIN
    addressAlignmentInterrupt <= addressAlignmentInterruptReg;

    PROCESS (addressAlignmentInterruptReg, address, dataFromImageBuffer, memReadReq, memWriteReq, ramMemOpFinished, MemoryMappedDevicesMemOpFinished, dataFromMem, dataFromMemoryMappedDevices, addressAlignmentInterruptClr)
    BEGIN
        --default values
        addressAlignmentInterruptReg_nxt <= addressAlignmentInterruptReg;
        ramWriteEn                       <= '0';
        ramReadEn                        <= '0';
        memoryMappedDevicesWriteEn       <= '0';
        memoryMappedDevicesReadEn        <= '0';
        imageBufferWriteEn               <= '0';
        memOpFinished                    <= '0';
        dataOut                          <= (OTHERS => '0');

        --reset interrupt signals if the reset signal is send
        IF addressAlignmentInterruptClr = '1' THEN
            addressAlignmentInterruptReg_nxt <= '0';
        END IF;

        --check if a the processor currently tries to read from or write to memory (cannot do both at the same time)
        IF memReadReq = '1' XOR memWriteReq = '1' THEN

            --check if address is divisible by 4
            IF address(1 DOWNTO 0) /= "00" THEN
                addressAlignmentInterruptReg_nxt <= '1';
                memOpFinished                    <= '1';

                --check if address is in ram range
            ELSIF unsigned(address) < memSize THEN
                ramWriteEn    <= memWriteReq;
                ramReadEn     <= memReadReq;
                dataOut       <= dataFromMem;
                memOpFinished <= ramMemOpFinished;

                --check if address is in image buffer range
            ELSIF (unsigned(address) >= IMAGE_BUFFER_STARTING_ADDRESS) AND (unsigned(address) < IMAGE_BUFFER_ENDING_ADDRESS) THEN
                imageBufferWriteEn <= memWriteReq;
                dataOut            <= dataFromImageBuffer;
                memOpFinished      <= '1';

                --send request to memory mapping otherwise
            ELSE
                memoryMappedDevicesWriteEn <= memWriteReq;
                memoryMappedDevicesReadEn  <= memReadReq;
                dataOut                    <= dataFromMemoryMappedDevices;
                memOpFinished              <= MemoryMappedDevicesMemOpFinished;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            addressAlignmentInterruptReg <= '0';
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                addressAlignmentInterruptReg <= addressAlignmentInterruptReg_nxt;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;