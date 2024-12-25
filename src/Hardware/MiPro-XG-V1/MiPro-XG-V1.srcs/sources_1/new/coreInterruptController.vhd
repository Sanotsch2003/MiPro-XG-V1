library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity coreInterruptController is
  Generic(
    numInterrupts : integer := 10
  );
  Port (
    interruptSignals : in std_logic_vector(numInterrupts-1 downto 0);

    IVT_in           : in std_logic_vector(32 * numInterrupts - 1 downto 0);
    PR_in            : in std_logic_vector(3 * numInterrupts - 1 downto 0);

    vectorOut        : out std_logic_vector(31 downto 0)
   );
end coreInterruptController;

architecture Behavioral of coreInterruptController is

begin
    
    --Sequential process for dealing with interrupts.
    process(interruptSignals, IVT_in, PR_in)
    variable currentMaxPriorityLevel : integer := 0;
    begin
        --By default the output will be 0 which signals the control unit that no interrupt has occurred.
        vectorOut <= (others => '0');
        currentMaxPriorityLevel := 0;
        for i in 0 to numInterrupts - 1 loop
            --check if interrupt signals are set
            if interruptSignals(i) = '1' then
                --check if this interrupt has the highest priority level so far and set the output if true
                if unsigned(PR_in((i+1)*3-1 downto i*3)) > currentMaxPriorityLevel then
                    vectorOut <= IVT_in((i+1)*32-1 downto i*32);
                    currentMaxPriorityLevel := to_integer(unsigned(PR_in((i+1)*3-1 downto i*3)));
                end if;
            end if;
        end loop;
    end process;

end Behavioral;