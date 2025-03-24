library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tb_SdramController is
end tb_SdramController;

architecture bench of tb_SdramController is
    -- Declare signals for the SDRAM controller interface
    signal memClk         : std_logic := '0';
    signal sysClk         : std_logic := '0';
    signal reset          : std_logic := '1';
    signal enable         : std_logic := '1';
    
    signal SDRAM_ADDR     : std_logic_vector(12 downto 0);
    signal SDRAM_DATA     : std_logic_vector(15 downto 0);
    signal SDRAM_BANK_ADDR: std_logic_vector(1 downto 0);
    signal SDRAM_BYTE_MASK: std_logic_vector(1 downto 0);
    signal SDRAM_RAS      : std_logic;
    signal SDRAM_CAS      : std_logic;
    signal SDRAM_CLK_EN   : std_logic;
    signal SDRAM_CLK      : std_logic;
    signal SDRAM_WRITE_EN : std_logic;
    signal SDRAM_CHIP_SEL : std_logic;

    
    signal stop_the_clock: boolean;
    constant memClkPeriod : time := 7 ns;
    constant sysClkPeriod : time := 20 ns;

    -- Declare the component for the SDRAM controller
component sdramTOP is
    generic (
        numConnectedDevices : integer := 1
    );
    port (
        -- System Signals
        memClk   : in std_logic;
        sysClk   : in std_logic;
        reset    : in std_logic;
        enable   : in std_logic;

        -- SDRAM Interface
        SDRAM_ADDR      : out std_logic_vector(12 downto 0);
        SDRAM_DATA      : inout std_logic_vector(15 downto 0);
        SDRAM_BANK_ADDR : out std_logic_vector(1 downto 0);
        SDRAM_BYTE_MASK : out std_logic_vector(1 downto 0);
        SDRAM_RAS       : out std_logic;
        SDRAM_CAS       : out std_logic;
        SDRAM_CLK_EN    : out std_logic;
        SDRAM_CLK       : out std_logic;
        SDRAM_WRITE_EN  : out std_logic;
        SDRAM_CHIP_SEL  : out std_logic
    );
end component;

begin
    -- Instantiate the SDRAM Controller
    UUT: sdramTOP
        generic map(
            numConnectedDevices => 1
        )
        port map (
            memClk        => memClk,
            sysClk        => sysClk,
            reset         => reset,
            enable        => enable,
            SDRAM_ADDR    => SDRAM_ADDR,
            SDRAM_DATA    => SDRAM_DATA,
            SDRAM_BANK_ADDR=> SDRAM_BANK_ADDR,
            SDRAM_BYTE_MASK=> SDRAM_BYTE_MASK,
            SDRAM_RAS     => SDRAM_RAS,
            SDRAM_CAS     => SDRAM_CAS,
            SDRAM_CLK_EN  => SDRAM_CLK_EN,
            SDRAM_CLK     => SDRAM_CLK,
            SDRAM_WRITE_EN=> SDRAM_WRITE_EN,
            SDRAM_CHIP_SEL=> SDRAM_CHIP_SEL
        );
    
  stimulus: process
  begin

    -- Put initialisation code here
    enable <= '1';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;
    
    wait for 100000000ns;
 

    stop_the_clock <= true;
    
    
    wait;
  end process;

  mem_clocking: process
  begin
    while not stop_the_clock loop
      memClk <= '0', '1' after memClkPeriod / 2;
      wait for memClkPeriod;
    end loop;
    wait;
  end process;
  
  sys_clocking: process
  begin
    while not stop_the_clock loop
      sysClk <= '0', '1' after sysClkPeriod / 2;
      wait for sysClkPeriod;
    end loop;
    wait;
  end process;

end;