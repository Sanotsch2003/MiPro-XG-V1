library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Available Modes:

--0. Disabled

--1. One-Shot Mode (Single-Shot)
--The timer counts to a specified value and then stops.

--2. Periodic Mode (Auto-Reload)
--The timer automatically resets and starts counting again after reaching the target value.

--3. Free-Running Mode (Continuous Counting)
--The timer continuously increments  without stopping.

--4. PWM Mode (Pulse Width Modulation)
--The timer toggles an output pin to generate a signal with a specific duty cycle.
--Used for motor control, LED brightness control, or generating analog-like signals.


entity hardwareTimer is
    Port (
        enable                   : in std_logic;
        reset                    : in std_logic;
        clk                      : in std_logic;
        pwmValue                 : in std_logic_vector(7 downto 0);
        prescaler                : in std_logic_vector(31 downto 0);
        mode                     : in std_logic_vector(3 downto 0);
        maxCount                 : in std_logic_vector(31 downto 0);
        
        --outputs 
        PWMPin                   : out std_logic;
        countValue               : out std_logic_vector(31 downto 0)
     );
end hardwareTimer;

architecture Behavioral of hardwareTimer is
    signal countReg : unsigned(31 downto 0);
    signal prescalerReg : unsigned(31 downto 0);

    signal previousMode : std_logic_vector(3 downto 0);
    signal previousPWMValue : std_logic_vector(7 downto 0);
    signal previousMaxCount : std_logic_vector(31 downto 0);
    

    --constants to identify modes
    constant DISABLED : std_logic_vector(3 downto 0) := "0000";
    constant ONE_SHOT : std_logic_vector(3 downto 0) := "0001";
    constant PERIODIC: std_logic_vector(3 downto 0) := "0010";
    constant FREE_RUNNING : std_logic_vector(3 downto 0) := "0011";
    constant PWM : std_logic_vector(3 downto 0) := "0100";

begin

    signals : process(mode, countReg, pwmValue)
    begin
        PWMPin <= '0';
        case mode is
            when PWM => 
                if countReg < unsigned(pwmValue) then
                    PWMPin <= '1';
                end if;
            when others => 
                null;
        end case;

    end process;

    count : process(clk, reset, previousMode, mode, previousPWMValue, PWMValue, previousMaxCount, maxCount)
    begin
        --reset condition
        if reset = '1' or (previousMode /= mode) or (previousPWMValue /= PWMValue) or (previousMaxCount /= maxCount) then
            countReg <= (others => '0');
            prescalerReg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' and mode /= DISABLED then
                prescalerReg <= prescalerReg + 1;
                if prescalerReg = unsigned(prescaler) then
                    prescalerReg <= (others => '0');
                    case mode is
                        when ONE_SHOT =>
                            if countReg < unsigned(maxCount) then
                                countReg <= countReg + 1;
                            end if;
                        when PERIODIC =>
                            countReg <= countReg + 1;
                            if countReg = unsigned(maxCount) then
                                countReg <= (others => '0');
                            end if;
                        when FREE_RUNNING =>
                            countReg <= countReg + 1;

                        when PWM =>
                            countReg <= countReg + 1;
                            if countReg = to_unsigned(255, 8) then
                                countReg <= (others => '0');
                            end if;
                        when others => 
                            null;
                    end case;
                end if; 
                
            end if;
        end if;
    end process;

    clocking : process(clk, reset)
    begin
        if reset = '1'  then   
            null;
        elsif rising_edge(clk) then
            if enable = '1' and mode /= DISABLED then
                previousMode <= mode;
                previousPWMValue <= PWMValue;
                previousMaxCount <= maxCount;

            end if;
        end if;
    end process;

    countValue <= std_logic_vector(countReg);

end Behavioral;
