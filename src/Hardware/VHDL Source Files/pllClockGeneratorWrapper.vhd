library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pllClockGenerator is
   generic (
        CLKFBOUT_MULT_F : real := 5.0;  -- Feedback multiplier
        CLKOUT0_DIVIDE_F : real := 10.0; -- Divide factor
        CLKIN1_PERIOD : real := 10.0    -- Input clock period (100 MHz)
    );
    port (
        clk_in    : in  std_logic;  -- 100 MHz input clock
        reset     : in  std_logic;  -- Reset signal
        clk_out   : out std_logic;  -- 50 MHz output clock
        locked    : out std_logic   -- Locked signal
    );
end pllClockGenerator;

architecture Behavioral of pllClockGenerator is

begin
    clk_out <= clk_in;
    locked <= '1';
end Behavioral;
