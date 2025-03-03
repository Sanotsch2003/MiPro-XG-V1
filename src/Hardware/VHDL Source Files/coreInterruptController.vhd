library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity coreInterruptController is
  Generic(
    numInterrupts : integer := 10
  );
  Port (
    clk                     : in std_logic;
    interrupts              : in std_logic_vector(numInterrupts-1 downto 0);

    IVT_in                  : in std_logic_vector(32 * numInterrupts - 1 downto 0);
    IPR_in                  : in std_logic_vector(3 * numInterrupts - 1 downto 0);
    
    interruptIndex          : out std_logic_vector(7 downto 0);
    interruptHandlerAddress : out std_logic_vector(31 downto 0)
   );
end coreInterruptController;

architecture Behavioral of coreInterruptController is

begin

    --Getting the right interrupt handler address based on current interrupt signals.
    process(clk)
    variable currentMaxPriorityLevel : integer := 0;
    begin
        if rising_edge(clk) then
            --By default the output will be 0 which signals the control unit that no interrupt has occurred.
            interruptHandlerAddress <= (others => '0');
            interruptIndex <= (others => '0');
            
            currentMaxPriorityLevel := 0;
            for i in 0 to numInterrupts - 1 loop
                --check if interrupt signals are set
                if interrupts(i) = '1' then
                    --check if this interrupt has the highest priority level so far and set the output if true
                    if unsigned(IPR_in((i+1)*3-1 downto i*3)) > currentMaxPriorityLevel then
                        interruptHandlerAddress <= IVT_in((i+1)*32-1 downto i*32);
                        interruptIndex <= std_logic_vector(to_unsigned(i, 8));
                        currentMaxPriorityLevel := to_integer(unsigned(IPR_in((i+1)*3-1 downto i*3)));
                    end if;
                end if;
            end loop;
        end if;
    end process;

end Behavioral;