library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addressDecoder is
    generic(
        memSize                     : integer
    );
    Port (
        enable                           : in std_logic;
        clk                              : in std_logic;
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
        addressAlignmentInterruptClr     : in std_logic
    );
end addressDecoder;

architecture Behavioral of addressDecoder is
signal addressAlignmentInterruptReg     : std_logic;
signal addressAlignmentInterruptReg_nxt : std_logic;

begin
    addressAlignmentInterrupt <= addressAlignmentInterruptReg;

    process(addressAlignmentInterruptReg, address, memReadReq, memWriteReq, ramMemOpFinished, MemoryMappedDevicesMemOpFinished, dataFromMem, dataFromMemoryMappedDevices, addressAlignmentInterruptClr)
    begin
        --default values
        addressAlignmentInterruptReg_nxt <= addressAlignmentInterruptReg;
        ramWriteEn                       <= '0';
        ramReadEn                        <= '0';
        memoryMappedDevicesWriteEn       <= '0';
        memoryMappedDevicesReadEn        <= '0';
        memOpFinished                    <= '0';
        dataOut                          <= (others => '0');

        --reset interrupt signals if the reset signal is send
        if addressAlignmentInterruptClr = '1' then
            addressAlignmentInterruptReg_nxt <= '0';
        end if;
        
        --check if a the processor currently tries to read from or write to memory (cannot do both at the same time)
        if memReadReq = '1' xor memWriteReq = '1' then

            --check if address is devisible by 4
            if address(1 downto 0) /= "00" then
                addressAlignmentInterruptReg_nxt <= '1';
                memOpFinished <= '1';

            --check if address is in ram range
            elsif unsigned(address)  < memSize then
                ramWriteEn           <= memWriteReq;                 
                ramReadEn            <= memReadReq;  
                dataOut              <= dataFromMem;
                memOpFinished        <= ramMemOpFinished;
            
            --send request to memory mapping otherwise
            else
                memoryMappedDevicesWriteEn  <= memWriteReq;   
                memoryMappedDevicesReadEn   <= memReadReq;
                dataOut                     <= dataFromMemoryMappedDevices;
                memOpFinished               <= MemoryMappedDevicesMemOpFinished;
            end if;
        end if;

        
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            addressAlignmentInterruptReg <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                addressAlignmentInterruptReg <= addressAlignmentInterruptReg_nxt;
            end if;
        end if;
    end process;


end Behavioral;
