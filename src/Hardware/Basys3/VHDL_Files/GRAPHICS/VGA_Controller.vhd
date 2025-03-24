LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY VGA_Controller IS
    PORT (
        enable  : IN STD_LOGIC;
        reset   : IN STD_LOGIC;
        VGA_Clk : IN STD_LOGIC;

        --Signals for interacting with image buffer
        readAddress : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
        dataIn      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        --VGA ports
        VGA_Blue  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        VGA_GREEN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        VGA_RED   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        H_Sync    : OUT STD_LOGIC;
        V_Sync    : OUT STD_LOGIC
    );
END VGA_Controller;

ARCHITECTURE Behavioral OF VGA_Controller IS
    --counters
    SIGNAL verticalCount1, verticalCount2, verticalCount3   : unsigned(9 DOWNTO 0);
    SIGNAL horizontalCount1, horizontalCount2, horizontalCount3  : unsigned(9 DOWNTO 0);
    signal pixelReg, pixelReg_nxt : std_logic;

BEGIN
    --signal assignments
    seq : PROCESS (verticalCount3, horizontalCount3, pixelReg)
    BEGIN
        --default VGA signal assignments
        VGA_Blue    <= (OTHERS => '0');
        VGA_GREEN   <= (OTHERS => '0');
        VGA_RED     <= (OTHERS => '0');
        H_Sync      <= '1';
        V_Sync      <= '1';
        
        --Drawing the image
        IF to_integer(horizontalCount3) < 640 AND to_integer(verticalCount3) < 480 THEN
            IF pixelReg = '1' THEN
                VGA_Blue  <= "1111";
                VGA_RED   <= "0000";
                VGA_GREEN <= "1111";
            END IF;
--            VGA_Blue <= std_logic_vector(horizontalCount3(3 downto 0));
--            VGA_Red <= std_logic_vector(verticalCount3(3 downto 0));
--            VGA_GREEN <= std_logic_vector(verticalCount3(7 downto 4));
        
        END IF;

        --Sending horizontal sync pulse
        IF to_integer(horizontalCount3) >= 656 AND to_integer(horizontalCount3) <= 751 THEN
            H_Sync                                                                <= '0';
        END IF;

        --Sending vertical sync pulse
        IF to_integer(verticalCount3) >= 490 AND to_integer(verticalCount3) <= 491 THEN
            V_Sync                                                            <= '0';
        END IF;
    END PROCESS;
    
    
    --latching pixel data
    latchPixel : process(verticalCount2, horizontalCount2, dataIn)
        variable pixelCount : unsigned(19 downto 0);
        variable bitCount : unsigned(4 downto 0);
    begin
        IF to_integer(horizontalCount2) < 640 AND to_integer(verticalCount2) < 480 THEN
            pixelCount := horizontalCount2 + (verticalCount2 * 640);
        else
            pixelCount := (others => '0');
        end if;
        bitCount := pixelCount(4 downto 0);
        pixelReg_nxt <= dataIn(31-to_integer(bitCount));
    end process;
     
    --setting addresses
    setAddresses : process(verticalCount1, horizontalCount1)
        variable pixelCount : unsigned(19 downto 0);
        variable wordCount : unsigned(13 downto 0);
    begin
        IF to_integer(horizontalCount1) < 640 AND to_integer(verticalCount1) < 480 THEN
            pixelCount := horizontalCount1 + (verticalCount1 * 640);
        else
            pixelCount := (others => '0');
        end if;
        wordCount := pixelCount(18 downto 5);
        readAddress <= std_logic_vector(wordCount);
    end process;
    
    --counters for horizontal sync and vertical sync:
    counters : PROCESS (VGA_Clk, reset)
    BEGIN
        IF reset = '1' THEN
            verticalCount1   <= (OTHERS => '0');
            horizontalCount1 <= (OTHERS => '0');
            verticalCount2   <= (OTHERS => '0');
            horizontalCount2 <= (OTHERS => '0');
            verticalCount3   <= (OTHERS => '0');
            horizontalCount3 <= (OTHERS => '0');
            pixelReg <= '0';
        ELSIF rising_edge(VGA_Clk) THEN
            IF enable = '1' THEN
                pixelReg <= pixelReg_nxt;
                
                --horizontal and vertical count
                horizontalCount1 <= horizontalCount1 + 1;
                IF to_integer(horizontalCount1) >= 799 THEN
                    horizontalCount1 <= (OTHERS => '0');
                    verticalCount1   <= verticalCount1 + 1;
                    IF to_integer(verticalCount1) >= 524 THEN
                        verticalCount1 <= (OTHERS => '0');
                    END IF;
                END IF;     
            END IF;
            
            verticalCount2 <= verticalCount1;
            verticalCount3 <= verticalCount2;
            
            horizontalCount2 <= horizontalCount1;
            horizontalCount3 <= horizontalCount2;
        END IF;
    END PROCESS;
    
END Behavioral;