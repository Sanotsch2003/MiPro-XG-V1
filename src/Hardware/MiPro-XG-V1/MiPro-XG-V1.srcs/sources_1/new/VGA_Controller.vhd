library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Resolution: 640 x 480 px

entity VGA_Controller is
  Port (
        reset           : in std_logic;
        externalClk     : in std_logic;
        vgaRed          : out std_logic_vector(3 downto 0);
        vgaBlue         : out std_logic_vector(3 downto 0);
        vgaGreen        : out std_logic_vector(3 downto 0);
        Hsync           : out std_logic;
        Vsync           : out std_logic
        );
end VGA_Controller;

architecture Behavioral of VGA_Controller is
    
    
    signal horizontalCountFast      : unsigned(11 downto 0);
    signal horizontalCount          : unsigned(9 downto 0);
    signal verticalCount            : unsigned(9 downto 0);

begin
    counting : process(externalClk, reset)
    begin
        if reset = '1' then
            horizontalCountFast <= (others => '0');
            verticalCount <= (others => '0');
        elsif rising_edge(externalClk) then
            horizontalCountFast <= horizontalCountFast + 1;
            if horizontalCountFast = 3199 then
                horizontalCountFast <= (others => '0');
                verticalCount <= verticalCount + 1;
            end if;
            if verticalCount = 524 then
                verticalCount <= (others => '0');
            end if;
        end if;
    end process;
    horizontalCount <= horizontalCountFast(11 downto 2);
    
    setting_signals : process(horizontalCount, verticalCount)
    begin
        --Sync signals are HIGH by default
        Hsync <= '1';
        Vsync <= '1';
        
        if horizontalCount >= 656 and horizontalCount < 752 then
            Hsync <= '0';
        end if; 
        if verticalCount >= 490 and verticalCount < 492 then
            Vsync <= '0';
        end if;
        
        --Setting color signals
        vgaRed <= "0000";
        vgaBlue <= "0000";
        vgaGreen <= "0000";
        
        if horizontalCount >= 0 and horizontalCount < 640 and verticalCount >= 0 and verticalCount < 480 then
            vgaRed <= std_logic_vector(horizontalCount(3 downto 0));
            vgaBlue <= std_logic_vector(horizontalCount(7 downto 4));
            vgaGreen <= std_logic_vector(verticalCount(5 downto 2));
        end if; 
    
    end process;
    
end Behavioral;
