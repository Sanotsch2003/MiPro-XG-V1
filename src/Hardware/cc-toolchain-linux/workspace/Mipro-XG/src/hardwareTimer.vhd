library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hardwareTimer is
    Port (
        enable                   : in std_logic;
        reset                    : in std_logic;
        clk                      : in std_logic;
        alteredClock             : in std_logic
     );
end hardwareTimer;

architecture Behavioral of hardwareTimer is

begin


end Behavioral;
