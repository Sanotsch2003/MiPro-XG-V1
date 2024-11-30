--Arithmetic-Logic-Unit 
--OPCODES
--0000: SIGNED ADDITION
--0001: SIGNED SUBTRACTION
--0010: SIGNED MUL
--0011: UNSIGNED ADDITION
--0100: UNSIGNED SUBTRACTION
--0101: UNSIGNED MUL
--0110: AND
--0111: OR
--1000: XOR
--1001: NOT
--1010: LOGICAL SHIFT RIGHT
--1011: LOGICAL SHIFT LEFT
--1100: ARITHMETIC SHIFT RIGHT


--LOAD REGISTERS
--10: LOAD A
--01: LOAD B
--00: LOAD A and B

--FLAGS (4-bit output)
--2: Zero
--1: Negative
--0: Overflow

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    generic (
        bit_width : integer := 32
    );
    port (
        enable         : in std_logic;
        reset          : in std_logic;
        clk            : in std_logic;
        data_in        : in std_logic_vector(bit_width-1 downto 0);
        data_out       : out std_logic_vector(bit_width-1 downto 0);
        load_regs_en   : in std_logic_vector(1 downto 0);
        op_code        : in std_logic_vector(3 downto 0);
        flags          : out std_logic_vector(3 downto 0);
        carry_in       : in std_logic
     );
end ALU;

architecture Behavioral of ALU is
    signal data_in_reg_A     : std_logic_vector(bit_width-1 downto 0);
    signal data_in_reg_B     : std_logic_vector(bit_width-1 downto 0);
    signal data_in_reg_A_nxt : std_logic_vector(bit_width-1 downto 0);
    signal data_in_reg_B_nxt : std_logic_vector(bit_width-1 downto 0);

    signal zero_flag         : std_logic;
    signal negative_flag     : std_logic;
    signal overflow_flag     : std_logic;
    signal carry_flag        : std_logic;

    signal load_A            : std_logic;
    signal load_B            : std_logic;

    constant zero_result     : std_logic_vector(bit_width-1 downto 0) := (others => '0');

    constant max_signed      : signed(bit_width-1 downto 0) := signed("0" & std_logic_vector(to_signed(-1, bit_width-1)));
    constant min_signed      : signed(bit_width-1 downto 0) := signed("1" & std_logic_vector(to_signed( 0, bit_width-1)));

begin
    flags <= '0' & zero_flag & negative_flag & overflow_flag;
    load_A <= load_regs_en(0);
    load_B <= load_regs_en(1);

    process(load_A, load_B, data_in)
    begin
        data_in_reg_A_nxt <= data_in_reg_A;
        data_in_reg_B_nxt <= data_in_reg_B;

        if load_A = '1' then
            data_in_reg_A_nxt <= data_in;
        end if;

        if load_B = '1' then
            data_in_reg_B_nxt <= data_in;
        end if;
    end process;


    process(op_code, data_in_reg_A, data_in_reg_B)
    begin
        null;
    end process;

    process(clk, reset)
    --variable mult_result : std_logic_vector(bit_width*2-1 downto 0);
    variable add_sub_result : std_logic_vector(bit_width downto 0);
    variable temp_result    : std_logic_vector(bit_width-1 downto 0);
    variable mult_result    : std_logic_vector(bit_width*2-1 downto 0);
    begin
        if reset = '1' then
            data_in_reg_A <= (others => '0');
            data_in_reg_B <= (others => '0');
            data_out      <= (others => '0');
            zero_flag     <= '0';
            negative_flag <= '0';
            overflow_flag <= '0';
            carry_flag    <= '0';

        elsif rising_edge(clk) then

            if enable = '1' then 
                data_in_reg_A <= data_in_reg_A_nxt;
                data_in_reg_B <= data_in_reg_B_nxt;
                overflow_flag <= '0';
                negative_flag <= '0';

                case op_code is
                    when "0000" =>
                        add_sub_result := std_logic_vector(resize(signed(data_in_reg_A), bit_width+1) + resize(signed(data_in_reg_B), bit_width+1));
                        temp_result := add_sub_result(bit_width-1 downto 0);

                        if signed(add_sub_result) > resize(max_signed, bit_width+1) or signed(add_sub_result) < resize(min_signed, bit_width+1) then
                            overflow_flag <= '1';
                        else
                            overflow_flag <= '0';
                        end if;
                        negative_flag <= temp_result(bit_width-1);
                    

                    when "0001" =>
                        add_sub_result := std_logic_vector(resize(signed(data_in_reg_A), bit_width+1) - resize(signed(data_in_reg_B), bit_width+1));
                        temp_result := add_sub_result(bit_width-1 downto 0);

                        if signed(add_sub_result) > resize(max_signed, bit_width+1) or signed(add_sub_result) < resize(min_signed, bit_width+1) then
                            overflow_flag <= '1';
                        else
                            overflow_flag <= '0';
                        end if;
                        negative_flag <= temp_result(bit_width-1);

                    when "0010" =>
                        mult_result := std_logic_vector(signed(data_in_reg_A) * signed(data_in_reg_B));
                        temp_result := mult_result(bit_width-1 downto 0);

                        if signed(mult_result) > resize(max_signed, 2*bit_width) or signed(mult_result) < resize(min_signed, 2*bit_width) then
                            overflow_flag <= '1';
                        else
                            overflow_flag <= '0';
                        end if;
                        negative_flag <= temp_result(bit_width-1);

                    --when "0011" =>
                        --add_sub_result := std_logic_vector(resize(unsigned(data_in_reg_A), bit_width+1) + resize(unsigned(data_in_reg_B), bit_width+1));
                        --temp_result := add_sub_result(bit_width-1 downto 0);

                        --if unsigned(add_sub_result) > to_unsigned(2**bit_width-1, bit_width+1) then
                            --overflow_flag <= '1';
                        --end if;
                    
                    --when "0100" =>
                        --add_sub_result := std_logic_vector(resize(unsigned(data_in_reg_A), bit_width+1) - resize(unsigned(data_in_reg_B), bit_width+1));
                        --temp_result := add_sub_result(bit_width-1 downto 0);

                        --if unsigned(data_in_reg_B) > unsigned(data_in_reg_A) then
                            --overflow_flag <= '1';
                        --end if; 
                    
                    --when "0101" =>
                        --mult_result := std_logic_vector(unsigned(data_in_reg_A) * unsigned(data_in_reg_B));
                        --temp_result := mult_result(bit_width-1 downto 0);

                        --if unsigned(mult_result) > to_unsigned(2**bit_width-1, bit_width+1) then
                            overflow_flag <= '1';
                        --end if;
                            
                    when "0110" =>
                        temp_result := data_in_reg_A and data_in_reg_B;
                    when "0111" =>
                        temp_result  := data_in_reg_A or data_in_reg_B;
                    when "1000" =>
                        temp_result  := data_in_reg_A xor data_in_reg_B;
                    when "1001" =>
                        temp_result  := not data_in_reg_A;
                    when "1010" =>
                        temp_result  := std_logic_vector(shift_right(unsigned(data_in_reg_A), to_integer(unsigned(data_in_reg_B))));
                    when "1011" =>
                        temp_result  := std_logic_vector(shift_left(unsigned(data_in_reg_A), to_integer(unsigned(data_in_reg_B))));
                    when "1100" =>
                        temp_result  := std_logic_vector(shift_right(signed(data_in_reg_A), to_integer(unsigned(data_in_reg_B))));
                    when others =>
                        temp_result  := (others => '0');

                end case;
                data_out <= temp_result;
                if temp_result = zero_result then
                    zero_flag <= '1';
                else
                    zero_flag <= '0';
                end if;

                else
                    data_in_reg_A <= (others => '0');
                    data_in_reg_B <= (others => '0');
                    data_out      <= (others => '0');
                    zero_flag     <= '0';
                    negative_flag <= '0';
                    overflow_flag <= '0';
            end if;

        end if;

    end process;


end Behavioral;