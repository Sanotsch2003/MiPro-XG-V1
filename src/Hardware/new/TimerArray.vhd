--the signals down below are used to control the timers. For the signals below there exists vectors
--that hold the signals for each timer. For example, the signal start_count is a vector that holds the 
--start_count signal for each timer. The same goes for stop_count and clear_count

--control signals:
--control(7 downto 6) : mode(00: free running, 01: single shot, 10: auto reload)
--control(5) : count_enable
--control(4) : software_reset

--prescaler: number of clock cycles before incrementing counter. prescaler = 0 means count every clock cycle, 
--prescaler = 1 means count every other clock cycle, etc. n_clock_cycles = prescaler + 1

--compare: when count = compare, interrupt is set, depending on mode, count may stop, reset, or continue

--example: with A clock frequency of 10Hz, a prescaler of 9 would mean that the count would increment every 10 clock cycles (1 second)
--a compare value of 5 would mean that the interrupt would be set after 5 seconds

--count: the current count value

--status signals:
--status(7) : count_finished

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TimerArray is
    generic(
        bit_width : integer := 8;
        num_timers : integer := 3
    );
    port(
        reset            : in std_logic;
        clk              : in std_logic;

        control          : in std_logic_vector(num_timers*8-1 downto 0);
        status           : out std_logic_vector(num_timers*8-1 downto 0);
        compare          : in std_logic_vector(num_timers*bit_width-1 downto 0);
        prescaler        : in std_logic_vector(num_timers*bit_width-1 downto 0);
        count            : out std_logic_vector(num_timers*bit_width-1 downto 0);
        interrupt        : out std_logic_vector(num_timers-1 downto 0)
    );
end TimerArray;

architecture Behavioral of TimerArray is
    component Timer is
        generic(
        bit_width : integer := 31
    );
    port(
        reset            : in std_logic;
        clk              : in std_logic;
        
        control          : in std_logic_vector(7 downto 0);
        status           : out std_logic_vector(7 downto 0);
        compare          : in std_logic_vector(bit_width-1 downto 0);
        prescaler        : in std_logic_vector(bit_width-1 downto 0);
        count            : out std_logic_vector(bit_width-1 downto 0);
        interrupt        : out std_logic
    );
    end component;
    
begin
    -- generate num_timers instances of Timer
    gen_timers: for i in 0 to num_timers-1 generate
        timer_inst: Timer
            generic map(
                bit_width => bit_width
                )
            port map(
                reset     => reset,     
                clk       => clk,
                
                control   => control(i*8+7 downto i*8),
                status    => status(i*8+7 downto i*8),    
                compare   => compare(i*bit_width+bit_width-1 downto i*bit_width),     
                prescaler => prescaler(i*bit_width+bit_width-1 downto i*bit_width),      
                count     => count(i*bit_width+bit_width-1 downto i*bit_width),     
                interrupt => interrupt(i)     
            );
    end generate gen_timers;

end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Timer is
    generic(
        bit_width : integer := 31
    );
    port(
        reset            : in std_logic;
        clk              : in std_logic;
        
        control          : in std_logic_vector(7 downto 0);
        status           : out std_logic_vector(7 downto 0);
        compare          : in std_logic_vector(bit_width-1 downto 0);
        prescaler        : in std_logic_vector(bit_width-1 downto 0);
        count            : out std_logic_vector(bit_width-1 downto 0);
        interrupt        : out std_logic
    );
end Timer;

architecture Behavioral of Timer is
    --control signals:
    signal mode                : std_logic_vector(1 downto 0); 
    signal count_enable        : std_logic;
    signal software_reset      : std_logic;

    --output registers
    signal count_reg           : std_logic_vector(bit_width-1 downto 0);
    signal count_finished_reg  : std_logic;

    --internal registers
    signal prescaler_count_reg : std_logic_vector(bit_width-1 downto 0);


begin
    --mapping control input to the control signals:
    mode           <= control(7 downto 6);
    count_enable   <= control(5);
    software_reset <= control(4);


    --output registers
    status <= count_finished_reg & "0000000";
    count  <= count_reg;


    seq: process(clk, reset, software_reset)
    variable var_count : std_logic_vector(bit_width-1 downto 0);
    begin    
        interrupt <= '0';
        if reset = '1' or software_reset = '1' then
            count_reg          <= (others => '0');
            prescaler_count_reg <= (others => '0');
            count_finished_reg <= '0';
            
        elsif rising_edge(clk) then
            var_count := (others => '0');
            if count_enable = '1' and count_finished_reg = '0' then
                --counting
                prescaler_count_reg <= std_logic_vector(unsigned(prescaler_count_reg) + 1);
                if unsigned(prescaler_count_reg) >= unsigned(prescaler) then
                    count_reg          <= std_logic_vector(unsigned(count_reg) + 1);
                    var_count          := std_logic_vector(unsigned(count_reg) + 1);
                    prescaler_count_reg <= (others => '0');
                end if;  

                --check whether compare condition is met and do the necessary actions
                if var_count = compare then 
                    case mode is
                        when "00" => --free running
                            interrupt <= '1';
                        when "01" => --single shot
                            interrupt <= '1';
                            count_finished_reg <= '1';
                        when "10" => --auto reload
                            count_reg <= (others => '0');
                            prescaler_count_reg <= (others => '0');
                            interrupt <= '1';
                        when others =>
                            null;
                    end case;
               end if;
               
          end if;
        end if;

    end process;

end Behavioral;