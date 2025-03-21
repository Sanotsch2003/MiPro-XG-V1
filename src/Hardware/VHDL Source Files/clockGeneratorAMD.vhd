LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY clockGenerator IS
    GENERIC (
        CLKFBOUT_MULT_F  : real := 5.0;  -- Feedback multiplier
        CLKOUT0_DIVIDE_F : real := 10.0; -- Divide factor
        CLKIN1_PERIOD    : real := 10.0  -- Input clock period (100 MHz)
    );
    PORT (
        clk_in  : IN STD_LOGIC;  -- 100 MHz input clock
        reset   : IN STD_LOGIC;  -- Reset signal
        clk_out : OUT STD_LOGIC; -- 50 MHz output clock
        locked  : OUT STD_LOGIC  -- Locked signal
    );
END clockGenerator;

ARCHITECTURE Behavioral OF clockGenerator IS
    COMPONENT MMCME2_BASE
        GENERIC (
            CLKFBOUT_MULT_F  : real    := 5.0;  -- Feedback multiplier
            CLKOUT0_DIVIDE_F : real    := 10.0; -- Divide factor
            CLKIN1_PERIOD    : real    := 10.0; -- Input clock period (100 MHz)
            DIVCLK_DIVIDE    : INTEGER := 1     -- Ensure no unexpected scaling

        );
        PORT (
            CLKIN1   : IN STD_LOGIC;
            CLKFBIN  : IN STD_LOGIC;
            CLKFBOUT : OUT STD_LOGIC;
            CLKOUT0  : OUT STD_LOGIC;
            LOCKED   : OUT STD_LOGIC;
            PWRDWN   : IN STD_LOGIC := '0';
            RST      : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clkfb : STD_LOGIC;

BEGIN

    -- Instantiate MMCM
    mmcm_inst : MMCME2_BASE
    GENERIC MAP(
        CLKFBOUT_MULT_F  => CLKFBOUT_MULT_F,
        CLKOUT0_DIVIDE_F => CLKOUT0_DIVIDE_F,
        CLKIN1_PERIOD    => CLKIN1_PERIOD,
        DIVCLK_DIVIDE    => 1
    )
    PORT MAP(
        CLKIN1   => clk_in,
        CLKFBIN  => clkfb,
        CLKFBOUT => clkfb,
        CLKOUT0  => clk_out,
        LOCKED   => locked,
        RST      => reset
    );
END Behavioral;