library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addressDecoder is
    generic(
        memSize                     : integer;
        memoryMappedAddressesStart  : integer;
        memoryMappedAddressesEnd    : integer
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
end addressDecoder;

architecture Behavioral of addressDecoder is
signal addressAlignmentInterruptReg     : std_logic;
signal addressAlignmentInterruptReg_nxt : std_logic;

signal invalidAddressInterruptReg       : std_logic;
signal invalidAddressInterruptReg_nxt   : std_logic;

begin
    addressAlignmentInterrupt <= addressAlignmentInterruptReg;
    invalidAddressInterrupt   <= invalidAddressInterruptReg;

    process(invalidAddressInterruptReg, addressAlignmentInterruptReg, address, memReadReq, memWriteReq, ramMemOpFinished, MemoryMappedDevicesMemOpFinished, dataFromMem, dataFromMemoryMappedDevices, addressAlignmentInterruptReset, invalidAddressInterruptReset)
    begin
        --default values
        addressAlignmentInterruptReg_nxt <= addressAlignmentInterruptReg;
        invalidAddressInterruptReg_nxt   <= invalidAddressInterruptReg;
        ramWriteEn                       <= '0';
        ramReadEn                        <= '0';
        memoryMappedDevicesWriteEn       <= '0';
        memoryMappedDevicesReadEn        <= '0';
        memOpFinished                    <= '0';
        dataOut                          <= (others => '0');

        --reset interrupt signals if the reset signal is send
        if addressAlignmentInterruptReset = '1' then
            addressAlignmentInterruptReg_nxt <= '0';
        end if;
        if invalidAddressInterruptReset = '1' then
            invalidAddressInterruptReg_nxt <= '0';
        end if;
        
        --check if a the processor currently tries to read from or write to memory (cannot do both at the same time)
        if memReadReq = '1' xor memWriteReq = '1' then

            --check if address is devisible by 4
            if not address(1 downto 0) = "00" then
                addressAlignmentInterruptReg_nxt <= '1';

            --check if address is in ram range
            elsif unsigned(address)  < memSize then
                ramWriteEn           <= memWriteReq;                 
                ramReadEn            <= memReadReq;  
                dataOut              <= dataFromMem;
                memOpFinished        <= ramMemOpFinished;

            --check if address is in memory mapped range
            elsif unsigned(address) >= memoryMappedAddressesStart and unsigned(address) <= memoryMappedAddressesEnd then
                memoryMappedDevicesWriteEn  <= memWriteReq;   
                memoryMappedDevicesReadEn   <= memReadReq;
                dataOut                     <= dataFromMemoryMappedDevices;
                memOpFinished               <= MemoryMappedDevicesMemOpFinished;
            --trigger invalid address interrupt if no of the conditions is met and the address is therefore invalid.
            else
                invalidAddressInterruptReg_nxt <= '1';
                memOpFinished                  <= '1'; --this needs to be triggered, otherwise the cpu gets stuck in the middle of the read/write instruction and will never start handling the interrupt signal
            end if;
        end if;

        
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            addressAlignmentInterruptReg <= '0';
            invalidAddressInterruptReg <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                --if alteredClk = '1' then
                    addressAlignmentInterruptReg <= addressAlignmentInterruptReg_nxt;
                    invalidAddressInterruptReg   <= invalidAddressInterruptReg_nxt;
                --end if;
            end if;
        end if;
    end process;


end Behavioral;
