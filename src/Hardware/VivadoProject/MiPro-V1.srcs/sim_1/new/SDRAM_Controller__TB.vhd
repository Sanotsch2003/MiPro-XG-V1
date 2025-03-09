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

    signal burstLength    : std_logic_vector(5 downto 0);
    signal readReq        : std_logic_vector(0 downto 0);
    signal writeReq       : std_logic_vector(0 downto 0);
    signal address        : std_logic_vector(24 downto 0);
    signal dataIn         : std_logic_vector(31 downto 0);
    signal dataOut        : std_logic_vector(31 downto 0);
    signal byteMask       : std_logic_vector(3 downto 0);
    
    signal stop_the_clock: boolean;
    constant memClkPeriod : time := 7 ns;
    constant sysClkPeriod : time := 10 ns;

    -- Declare the component for the SDRAM controller
    component SdramController
        generic(
            numConnectedDevices : integer;
            memClkPeriod        : integer;
            sysClkPeriod        : integer;
            t_cac               : integer;
            t_rcd               : integer;
            t_rac               : integer;
            t_rc                : integer;
            t_ras               : integer;
            t_rp                : integer;
            t_rdd               : integer;
            t_ccd               : integer;
            t_dpl               : integer;
            t_dal               : integer;
            t_rbd               : integer;
            t_wbd               : integer;
            t_rql               : integer;
            t_wdl               : integer;
            t_mrd               : integer
        );
        port (
            memClk        : in  std_logic;
            sysClk        : in  std_logic;
            reset         : in  std_logic;
            enable        : in  std_logic;
            SDRAM_ADDR    : out std_logic_vector(12 downto 0);
            SDRAM_DATA    : inout std_logic_vector(15 downto 0);
            SDRAM_BANK_ADDR: out std_logic_vector(1 downto 0);
            SDRAM_BYTE_MASK: out std_logic_vector(1 downto 0);
            SDRAM_RAS     : out std_logic;
            SDRAM_CAS     : out std_logic;
            SDRAM_CLK_EN  : out std_logic;
            SDRAM_CLK     : out std_logic;
            SDRAM_WRITE_EN: out std_logic;
            SDRAM_CHIP_SEL: out std_logic;
            burstLength   : in  std_logic_vector(5 downto 0);
            readReq       : in  std_logic_vector(0 downto 0);
            writeReq      : in  std_logic_vector(0 downto 0);
            address       : in  std_logic_vector(24 downto 0);
            dataIn        : in  std_logic_vector(31 downto 0);
            dataOut       : out std_logic_vector(31 downto 0);
            byteMask      : in  std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- Instantiate the SDRAM Controller
    UUT: SdramController
        generic map(
            numConnectedDevices => 1,
            memClkPeriod        => 7,  -- Example value for the SDRAM clock period (in ns)
            sysClkPeriod        => 10, -- Example value for the system clock period (in ns)
            t_cac               => 3,
            t_rcd               => 3,
            t_rac               => 6,
            t_rc                => 9,
            t_ras               => 6,
            t_rp                => 3,
            t_rdd               => 2,
            t_ccd               => 1,
            t_dpl               => 2,
            t_dal               => 5,
            t_rbd               => 3,
            t_wbd               => 0,
            t_rql               => 3,
            t_wdl               => 0,
            t_mrd               => 2
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
            SDRAM_CHIP_SEL=> SDRAM_CHIP_SEL,
            burstLength   => burstLength,
            readReq       => readReq,
            writeReq      => writeReq,
            address       => address,
            dataIn        => dataIn,
            dataOut       => dataOut,
            byteMask      => byteMask
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