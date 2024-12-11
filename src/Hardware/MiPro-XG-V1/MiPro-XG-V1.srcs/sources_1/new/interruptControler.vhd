library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity interruptControler is
  Generic(
    numInterrupts : integer := 5
  );
  Port (
    enable           : in std_logic;
    reset            : in std_logic;
    clk              : in std_logic;
    alteredClock     : in std_logic;

    interruptSignals : in std_logic_vector(0 to numInterrupts-1);

    writeEn          : in std_logic;
    address          : in std_logic_vector(5 downto 0);
    dataIn           : in std_logic_vector(31 downto 0);

    vectorOut        : out std_logic_vector(31 downto 0)

   );
end interruptControler;

architecture Behavioral of interruptControler is
    --creating the interrupt vector table (IVT)
    type vector_array is array (0 to numInterrupts-1) of std_logic_vector(31 downto 0);
    --initiliazing default addresses
    signal IVT : vector_array := (
    0 => x"DEADBEEF",  
    1 => x"12345678",  
    2 => x"FEDCBA98",  
    3 => x"CAFEBABE",  
    4 => x"87654321",  
    others => (others => '0'));  

    --creating the priority register (There are 8 different priority levels, priority 0 means the interrupt signal will be ignored). 
    type priority_arary is array (0 to numInterrupts-1) of std_logic_vector(2 downto 0);
    --initializing default priorities
    signal PR : priority_arary := (
        0 => "000",  
        1 => "011",  
        2 => "010",  
        3 => "011",  
        4 => "111",  
    others => (others => '0'));

begin
    --updating the IVT and PR
    process(clk, reset)
    begin
        if reset = '1' then
            --IVT and PR will not be overwritten on reset
            --IVT <= (others=>(others => '0'));
            --PR <= (others=>(others => '0'));
            null;
        elsif rising_edge(clk) then
            if enable = '1' then
                if alteredClock = '1' then
                    if writeEn = '1' then
                        --write to vector array if address < numInterrupts
                        if to_integer(unsigned(address)) < numInterrupts then
                            IVT(to_integer(unsigned(address))) <= dataIn;
                        --write to priority register if address < 2*numInterrupts
                        elsif to_integer(unsigned(address)) < numInterrupts*2 then
                            PR(to_integer(unsigned(address))-numInterrupts) <= dataIn(2 downto 0);
                        else
                            null;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    --sequential process for dealing with interrupts
    process(interruptSignals, IVT, PR)
    variable currentMaxPriorityLevel : integer := 0;
    begin
        --by default the output will be 0 which signals the controll unit that no interrupt has occured
        vectorOut <= (others => '0');
        currentMaxPriorityLevel := 0;
        for i in 0 to numInterrupts - 1 loop
            --check if interrupt signals are set
            if interruptSignals(i) = '1' then
                --check if this interrupt has the highest priority level so far and set the output if true
                if unsigned(PR(i)) > currentMaxPriorityLevel then
                    vectorOut <= IVT(i);
                    currentMaxPriorityLevel := to_integer(unsigned(PR(i)));
                end if;
            end if;
        end loop;
    end process;

end Behavioral;