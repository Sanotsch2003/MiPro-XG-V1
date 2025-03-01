--This module generates a pulsing enable signal based on a prescaler. 
--The pulsing enable signal can be used to simulate a slower clock, if it is used as an enable signal in clocked processes.
--This module lets you also switch between an automatic and a manual clock mode.
--When the manual mode is active, you can use a button to generate clock pulses. This can be helpful for debugging purposes.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockController is
    Port ( 
        reset            : in std_logic;
        clk              : in std_logic;
        enable           : in std_logic;
        manualClk        : in std_logic;
        manualClocking   : in std_logic;
        alteredClk       : out std_logic;
        programmingMode  : in std_logic;
        prescalerIn      : in std_logic_vector(31 downto 0)
        
        --for test purposes:
        --LED            : out std_logic_vector(7 downto 0)

    );
end clockController;

architecture Behavioral of clockController is
    --siginals for automatic clocking
    signal alteredClkRegister : std_logic;
    signal countCyclesRegister : unsigned(31 downto 0) := (others => '0');

    --signals for button edge detection, debouncing the button, and manual clocking
    constant debounceTime : integer := 1000000; --10ms
    signal buttonDown : std_logic;
    signal debounceCount : unsigned(25 downto 0);
    signal buttonStable : std_logic;
    
    --singnals for testing
--    signal testCounter            : unsigned(7 downto 0);
--    signal dataIn                 : std_logic_vector(31 downto 0) := (others => '1');
--    signal loadPrescalerReg       : std_logic := '0';
    
begin

    --set custom clock signal
    process(clk, reset)
    begin
        if reset = '1' then
            alteredClkRegister  <= '0';
            countCyclesRegister <= (others => '0');
            buttonDown <= '0';
            buttonStable <= '0';
            debounceCount <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                alteredClkRegister <= '0';
                
                --While the processor is programmed, the clock frequency should not be altered.
                if programmingMode = '1' then
                    alteredClkRegister <= '1';
                    
                --setting the alteredClkRegister to high when countCyclesRegister = prescalerIn-1
                elsif manualClocking = '0' then
                    countCyclesRegister <= countCyclesRegister + 1;
                    if to_integer(countCyclesRegister) = to_integer(unsigned(prescalerIn)) then
                        alteredClkRegister <= '1';
                        countCyclesRegister <= (others => '0');
                    end if;
                else
                    --setting the altered clock to high for one clock cycle when the manualClk button is pressed (debouncing the button is necessary)
                    if manualClk = '1' and buttonDown = '0' and buttonStable = '1' then
                        alteredClkRegister <= '1'; --sending pulse
                        buttonDown   <= '1';
                        buttonStable <= '0';
                    end if;

                    if buttonDown = '1' and buttonStable = '0' then
                        if debounceCount < debounceTime then
                            debounceCount <= debounceCount + 1;
                        else
                            buttonStable <= '1';
                            debounceCount <= (others => '0');
                        end if;
                    end if;

                    if buttonDown = '1' and buttonStable = '1' then
                        if manualClk = '0' then
                            if debounceCount < debounceTime then
                                debounceCount <= debounceCount + 1;
                            else
                                buttonDown   <= '0';
                                debounceCount <= (others => '0');
                            end if;
                        end if; 
                    end if;

                    --last case: when buttonDown='0' and buttonStable='0' then buttonStable <= '1'
                    if buttonDown = '0' and buttonStable = '0' then
                        debounceCount <= (others => '0');
                        buttonStable <= '1';
                    end if;


                end if;
            end if;
        end if;
    end process;

    alteredClk <= alteredClkRegister;
    
end Behavioral;