library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This is the RAM module.
--Use the constant RAM_SIZE to specify the size of the RAM in bytes.
--Each address holds one byte of data.
--There is regular address space for the for storing data and address space specified for IO-devices and Hardware Timers.
--When trying to access an invalid address, an invalid_address_interrupt is generated.


--Regular address space (0 to RAM_SIZE-1):
--Only addresses divisible by 4 can be written to or read from. Any other address will cause an address_alignment_interrupt
--The bytes input determines which bytes within the 32 bit word are written to or read from

--IO-address space (RAM_SIZE to last IO-device address):
--All the IO-devices and Hardware Timers are memory mapped to the RAM module. In order to access the IO-devices and Hardware Timers, 
--the user must write to or read from the corresponding address. 
--Some of the addresses are read only for the CPU. When trying to write to these addresses, a read_only_interrupt is generated.
--addresses don't need to be divisible by 4, every control register has its unique address.
--some control registers are not 32 bits. When writing to these registers, only the least significant bits of data in are written to the register.
--When reading from these registers, the most significant bits of data_out are set to 0. 


--Memory access uses little endian offset addressing by default. Big endian is not implemented yet

entity RAM is
  Port (
    enable                     : in std_logic;
    clk                        : in std_logic;
    reset                      : in std_logic;
    data_in                    : in std_logic_vector(31 downto 0);
    address                    : in std_logic_vector(31 downto 0);
    data_out                   : out std_logic_vector(31 downto 0);
    write_enable               : in std_logic;
    read_enable                : in std_logic;
    process_byte               : in std_logic;
    address_alignment_interrupt: out std_logic;
    read_only_interrupt        : out std_logic;
    invalid_address_interrupt  : out std_logic;

    --IO signals:

    --7-segment display:
    seven_segment_data         : out std_logic_vector(31 downto 0);
    seven_segment_control      : out std_logic_vector(31 downto 0)

    --UART:
    --UART_RX_data               : in std_logic_vector(7 downto 0);
    --UART_TX_data               : out std_logic_vector(7 downto 0);
    --UART_control               : in std_logic_vector(7 downto 0);
    --UART_status                : out std_logic_vector(7 downto 0)
  );
end RAM;

architecture Behavioral of RAM is
    constant RAM_SIZE : integer := 2048;
    
    type ram_type is array (0 to RAM_SIZE-1) of std_logic_vector(7 downto 0);
    signal ram : ram_type :=(
        0 => "11110010",
        1 => "00010001",
        2 => "00100001",
        3 => "00000010",
        --Branch and Exchange
        --0 => "11110001",
        --1 => "00101111",
        --2 => "11111111",
        --3 => "00010011",
        
        --Branch and Branch with link
        16 => "11111011",
        17 => "00000000",
        18 => "00000000",
        19 => "00100000",
        others => (others => '0')
    );

    
begin
    
    --Connecting the io-device outputs to the corresponding registers:
    --7-segment:
    seven_segment_data    <= ram(RAM_SIZE-4) & ram(RAM_SIZE-3) & ram(RAM_SIZE-2) & ram(RAM_SIZE-1);
    seven_segment_control <= ram(RAM_SIZE-8) & ram(RAM_SIZE-7) & ram(RAM_SIZE-6) & ram(RAM_SIZE-5);

    process(clk, reset) 
    variable remaining : integer;
    variable tmp_data_out : std_logic_vector(31 downto 0);
    begin 
        if rising_edge(clk) then 
            address_alignment_interrupt <= '0';
            read_only_interrupt <= '0';
            invalid_address_interrupt <= '0';
            data_out <= (others => '0');
            if enable = '1' then

                if read_enable = '1' then
                    remaining := to_integer(unsigned(address(1 downto 0)));
                    for i in 0 to 3 loop
                        tmp_data_out((i+1)*8-1 downto i*8) := ram(to_integer(unsigned(address)+(3-i+remaining) mod 4));
                    end loop;

                    if process_byte = '0' then
                        data_out <= tmp_data_out;
                    else
                        for i in 0 to 3 loop
                            if i = remaining then
                                data_out((i+1)*8-1 downto i*8) <= tmp_data_out((i+1)*8-1 downto i*8);
                            else     
                                data_out((i+1)*8-1 downto i*8) <= (others => '0');
                            end if;
                        end loop;
                    end if;
                end if;

                if write_enable = '1' then
                    if process_byte = '1' then
                        ram(to_integer(unsigned(address))) <= data_in(7 downto 0);
                    else 
                        for i in 0 to 3 loop
                            ram(to_integer(unsigned(address))+i) <= data_in((4-i)*8-1 downto (3-i)*8);
                        end loop;
                    end if;
                end if;

            end if;

        end if;

    end process;

end Behavioral;
