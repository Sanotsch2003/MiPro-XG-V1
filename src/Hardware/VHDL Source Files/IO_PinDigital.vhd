library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity IO_PinDigital is
    Port (
        pin        : inout std_logic;           
        dutyCycle  : in std_logic_vector(7 downto 0); 
        mode       : in std_logic_vector(1 downto 0); 
        dataIn     : in std_logic;               
        dataOut    : out std_logic;               
        count      : in std_logic_vector(7 downto 0)
    );
end IO_PinDigital;

architecture Behavioral of IO_PinDigital is
begin
    process(mode, pin, dataIn, count, dutyCycle) 
    begin
        dataOut <= '0';
        case mode is
            when "00" => -- Output mode
                pin <= dataIn;  
            
            when "01" => -- Input mode
                pin <= 'Z';  
                dataOut <= pin;  
            
            when "10" => -- PWM mode
                if unsigned(count) < unsigned(dutyCycle) then
                    pin <= '1';
                else
                    pin <= '0';
                end if;

            when others =>
                pin <= 'Z';  
        end case;
    end process;
end Behavioral;
