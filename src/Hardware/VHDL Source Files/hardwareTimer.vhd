library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Available Modes:

--0. Free-Running Mode (Continuous Counting)
--The timer continuously increments  without stopping.

--1. One-Shot Mode (Single-Shot)
--The timer counts to a specified value and then stops.

--2. Periodic Mode (Auto-Reload)
--The timer automatically resets and starts counting again after reaching the target value.




entity hardwareTimer is
    Generic (
        countWidth : integer
        );
    Port (
        enable                   : in std_logic;
        reset                    : in std_logic;
        clk                      : in std_logic;
        
        prescaler                : in std_logic_vector(31 downto 0);
        mode                     : in std_logic_vector(1 downto 0);
        maxCount                 : in std_logic_vector(countWidth-1 downto 0);
        
        interruptClr             : in std_logic;
        
        --outputs 
        count                    : out std_logic_vector(countWidth-1 downto 0);
        interrupt                : out std_logic
     );
end hardwareTimer;

architecture Behavioral of hardwareTimer is
    signal countReg : unsigned(countWidth-1 downto 0);
    signal prescalerCountReg : unsigned(31 downto 0);
    signal interruptReg : std_logic;

    signal previousModeReg : std_logic_vector(1 downto 0);
    signal previousPWMValue : std_logic_vector(7 downto 0);
    signal previousMaxCount : std_logic_vector(31 downto 0);
   

begin
   process(clk, reset)
   begin
        if reset = '1' then
            countReg <= (others => '0');
            interruptReg <= '0';
            previousModeReg <= (others => '0');
            prescalerCountReg <= (others => '0');
        
        elsif rising_edge(clk) then
            if enable = '1' then
            
                if mode /= "00" then  --Timer is disabled.      
                    prescalerCountReg <= prescalerCountReg + 1;
                    if prescalerCountReg >= unsigned(prescaler) then
                        prescalerCountReg <= (others => '0');
                        case mode is 
                            when "01" =>
                                countReg <= countReg + 1; --normal counting
                                if countReg + 1 = 0 then --check for overflow
                                    interruptReg <= '1';
                                end if; 
                            when "10" =>
                                if countReg < unsigned(maxCount) then
                                    countReg <= countReg + 1; --count unitl maxCount is reached
                                end if;
                                if countReg = unsigned(maxCount) - 1 then
                                    interruptReg <= '1';
                                end if;
                            when "11" =>
                                if countReg < unsigned(maxCount) then
                                    countReg <= countReg + 1; --count unitl maxCount is reached
                                else
                                    countReg <= (others => '0');
                                    interruptReg <= '1';
                                end if;
                            when others =>
                                null;   
                        end case;
                    end if;
                end if;
                
                
                --Reset count register when the count mode is updated.
                if previousModeReg /= mode then
                    previousModeReg <= mode;
                    countReg <= (others => '0');
                end if;
                
                --Clear interrupt when the interrupt clr signal is high.
                if interruptClr = '1' then
                    interruptReg <= '0';
                end if;
                
            end if;   
        end if;
   end process;
   
   count <= std_logic_vector(countReg);
   interrupt <= interruptReg;

end Behavioral;
