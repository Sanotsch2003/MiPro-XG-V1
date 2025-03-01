library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

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
    component MMCME2_BASE
        generic (
            CLKFBOUT_MULT_F : real := 5.0;  -- Feedback multiplier
            CLKOUT0_DIVIDE_F : real := 10.0; -- Divide factor
            CLKIN1_PERIOD : real := 10.0 ;   -- Input clock period (100 MHz)
            DIVCLK_DIVIDE : integer := 1 -- Ensure no unexpected scaling

        );
        port (
            CLKIN1    : in  std_logic;
            CLKFBIN   : in  std_logic;
            CLKFBOUT  : out std_logic;
            CLKOUT0   : out std_logic;
            LOCKED    : out std_logic;
            PWRDWN    : in  std_logic := '0';
            RST       : in  std_logic
        );
    end component;

    signal clkfb : std_logic;

begin
    -- Instantiate MMCM
    mmcm_inst : MMCME2_BASE
        generic map (
            CLKFBOUT_MULT_F => CLKFBOUT_MULT_F,
            CLKOUT0_DIVIDE_F => CLKOUT0_DIVIDE_F,
            CLKIN1_PERIOD => CLKIN1_PERIOD,
            DIVCLK_DIVIDE => 1
        )
        port map (
            CLKIN1 => clk_in,
            CLKFBIN => clkfb,
            CLKFBOUT => clkfb,
            CLKOUT0 => clk_out,
            LOCKED => locked,
            RST => reset
        );
end Behavioral;
