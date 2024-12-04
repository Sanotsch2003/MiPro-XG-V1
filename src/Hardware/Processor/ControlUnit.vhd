--Each component's output is connected to the data bus. Selecting which component writes to the data bus is done by setting the 
--write_to_data_bus_component_sel signal to the component's uniqe identifier address as shown below. The same can be done with the
--write_to_address_bus_component_sel signal to select which component can write to the address bus. Keep in mind that RAM cannot write to 
--the address bus directly (18 is an invalid address when trying to put data on the address bus). Providing an invalid address sets the bus to zeros. 
--The decimal numbers refer to the value of write_to_data_bus_component_sel and write_to_address_bus_component_sel:
--0 to 12: general purpose registers R0 to R12
--     13: R13 (SP: Stack pointer)
--     14: R14 (LR: link register)
--     15: R15 (PC: program counter)
--     16: ALU
--     18: RAM (used as the RAM read enable signal. The output will be the content of the data at the address specified by the current value of the address bus.
--              RAM output cannot be connected back to the address bus. Therefore, when write_to_address_bus_component_sel is set to 18, it is treated 
--              as an invalid address and the address bus is set to zeros)
--     19: Control Unit (allowing the control unit to put values onto the bus)

--each component's input is connected to the data bus, the address bus is only connected to the address input of the RAM.
--As more than one component at a time can read the data from the bus (different from writing to the bus) the components_read_from_data_bus_en_mask is a mask
--where each bit corresponds to one component or register that can read from the bus.
--The numbers refer to the n-th bit of the components_read_from_data_bus_en_mask signal (starting with the least significant bit):
--0 to 12: general purpose registers R0 to R12
--     13: R13 (SP: Stack pointer)
--     14: R14 (LR: link register)
--     15: R15 (PC: program counter) 
--     16: ALU (Register A)
--     17: ALU (Register B)
--     18: RAM (used as the RAM write enable signal)
--     19: Control Unit not used as the control unit data in is directly managed within this component


--Component can be enabled individually using the components_en signal. Each bit corresponds to one component/group of components.
--The numbers refer to the n-th bit of the components_en signal (starting with the least significant bit):
--0: GPRs
--1: ALU
--2: RAM

--Dies ist ein Test-Kommentarrrrr

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    Port ( 
        clk                                   : in std_logic;
        reset                                 : in std_logic;

        --bus access 
        data_in                               : in std_logic_vector(31 downto 0);
        data_out                              : out std_logic_vector(31 downto 0);
        
        --Flags used for conditional execution of instructions
        ALU_flags_in                          : in std_logic_vector(3 downto 0);

        --control signals:
        --bus 
        write_to_data_bus_component_sel       : out std_logic_vector(5 downto 0);
        write_to_address_bus_component_sel    : out std_logic_vector(5 downto 0);
        components_read_from_data_bus_en_mask : out std_logic_vector(31 downto 0);
        data_bus_shift                        : out std_logic_vector(7 downto 0);
        address_bus_shift                     : out std_logic_vector(7 downto 0);                       
        bus_carry_out                         : in std_logic;

        --enable signals
        components_en                         : out std_logic_vector(11 downto 0);

        --ALU control
        ALU_op_code                           : out std_logic_vector(3 downto 0);

        --RAM control
        RAM_process_byte                      : out std_logic;

        --additional controll signals
        increment_PC_en                       : out std_logic;
        increment_PC_val                      : out std_logic_vector(31 downto 0);
        carry_in                              : out std_logic
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    type state_type is (SETUP, FETCH_1, FETCH_2, DECODE_EXECUTE);
    signal state     : state_type;
    signal state_nxt : state_type;

    type execute_state_type is (Execute_1, Execute_2, Execute_3, Execute_4, Execute_5);
    signal execute_state : execute_state_type;
    signal execute_state_nxt : execute_state_type;

    --registers and flags
    signal instruction_reg : std_logic_vector(31 downto 0);

    signal thumb_mode_reg  : std_logic := '0';
    signal thumb_mode_reg_nxt : std_logic;

    signal Z_flag_reg : std_logic := '0';
    signal Z_flag_reg_nxt : std_logic;

    signal N_flag_reg : std_logic := '0';
    signal N_flag_reg_nxt : std_logic;

    signal C_flag_reg : std_logic := '0';
    signal C_flag_reg_nxt : std_logic;

    signal V_flag_reg : std_logic := '0';
    signal V_flag_reg_nxt : std_logic;

begin

    process(state, execute_state)
    variable condition              : std_logic_vector(3 downto 0);
    variable skip_instruction       : boolean;

    --Data Processing
    variable immidiate_operand      : std_logic;
    variable op_code                : std_logic_vector(3 downto 0);
    variable set_condition_codes    : std_logic;
    variable first_operand_register : std_logic_vector(3 downto 0);
    variable destination_register   : std_logic_vector(3 downto 0);
    variable operand_2              : std_logic_vector(11 downto 0);

    --Single Data Transfer (LDR, STR)
    variable immediate_offset           : std_logic;
    variable pre_post_indexing_bit      : std_logic;
    variable up_down_bit                : std_logic;
    variable byte_word_bit              : std_logic;
    variable write_back_bit             : std_logic;
    variable load_store_bit             : std_logic;
    variable base_register              : std_logic_vector(3 downto 0);
    variable source_destination_register: std_logic_vector(3 downto 0);
    variable offset                     : std_logic_vector(11 downto 0);
    variable address                    : std_logic_vector(31 downto 0);


    begin
        state_nxt <= state;
        execute_state_nxt  <= execute_state;
        thumb_mode_reg_nxt <= thumb_mode_reg;
        Z_flag_reg_nxt     <= Z_flag_reg;
        N_flag_reg_nxt     <= N_flag_reg;
        C_flag_reg_nxt     <= C_flag_reg;
        V_flag_reg_nxt     <= V_flag_reg;

        RAM_process_byte <= '0'; --by default, the RAM processes entire words
        write_to_data_bus_component_sel <= (others=>'1'); --by default, nothing writes to the data bus
        write_to_address_bus_component_sel <= (others => '1'); --by default, nothing writes to the address bus
        components_read_from_data_bus_en_mask <= (others => '0'); --by default, nothing reads from the data bus
        components_en <= (others => '0'); --by default, all components are disabled to save power
        ALU_op_code <= (others => '0');
        carry_in <= '0';
        increment_pc_en <= '0';
        increment_pc_val <= (others => '0');
        data_bus_shift <= (others => '0');
        address_bus_shift <= (others => '0');
        data_out <= (others => '0');

        case state is

            --Setup state is setting up the control signals for the first instruction fetch
            when SETUP => 
                components_en <= "000000000101"; --enableing RAM and GPRs
                write_to_address_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length)); --set address bus to value of program counter
                write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_address_bus_component_sel'length)); --read data from RAM at address of program counter
                state_nxt <= FETCH_1;
            
            --fetching instruction and incrementing program counter
            when FETCH_1 =>
                execute_state_nxt <= Execute_1; 
                components_en <= "000000000101"; --enableing RAM and GPRs
                write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_address_bus_component_sel'length)); --read data from RAM at address of program counter
                state_nxt <= FETCH_2;
                increment_pc_en <= '1';
                increment_pc_val <= std_logic_vector(to_signed(4, increment_PC_val'length));

            --might be able to delete this state without breaking anything!
            when FETCH_2 =>  
                state_nxt <= DECODE_EXECUTE;    
            
            when DECODE_EXECUTE =>
                --jumping to next instruction if condition is not met
                condition := instruction_reg(31 downto 28);
                skip_instruction := TRUE;
                case condition is
                    when "0000" => 
                        if Z_flag_reg = '1' then
                            skip_instruction := FALSE;
                        end if;
                    when "0001" =>
                        if Z_flag_reg = '0' then
                            skip_instruction := FALSE;
                        end if;
                    when "0010" =>
                        if C_flag_reg = '1' then
                            skip_instruction := FALSE;
                        end if;
                    when "0011" =>
                        if C_flag_reg = '0' then
                            skip_instruction := FALSE;
                        end if;
                    when "0100" =>
                        if N_flag_reg = '1' then
                            skip_instruction := FALSE;
                        end if;
                    when "0101" =>
                        if N_flag_reg = '0' then
                            skip_instruction := FALSE;
                        end if;
                    when "0110" =>
                        if V_flag_reg = '1' then
                            skip_instruction := FALSE;
                        end if;
                    when "0111" =>
                        if V_flag_reg = '0' then
                            skip_instruction := FALSE;
                        end if;
                    when "1000" =>
                        if C_flag_reg = '1' and Z_flag_reg = '0' then
                            skip_instruction := FALSE;
                        end if;
                    when "1001" =>
                        if C_flag_reg = '0' and Z_flag_reg = '1' then
                            skip_instruction := FALSE;
                        end if;
                    when "1010" =>
                        if N_flag_reg = V_flag_reg then
                            skip_instruction := FALSE;
                        end if;
                    when "1011" =>
                        if N_flag_reg /= V_flag_reg then
                            skip_instruction := FALSE;
                        end if;
                    when "1100" =>
                        if Z_flag_reg = '0' and (N_flag_reg = V_flag_reg) then
                            skip_instruction := FALSE;
                        end if;
                    when "1101" =>
                        if Z_flag_reg = '1' or (N_flag_reg /= V_flag_reg) then
                            skip_instruction := FALSE;
                        end if;
                    when others =>
                        skip_instruction := FALSE;
                end case;

                if skip_instruction = True then
                    --skipping instruction and go to next instruction
                    components_en <= "000000000101"; --enableing RAM and GPRs
                    write_to_address_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length)); --set address bus to value of program counter
                    write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_address_bus_component_sel'length)); --read data from RAM at address of program counter
                    state_nxt <= FETCH_1;  
                else
                    
                    --Branch and Exchange
                    if instruction_reg(27 downto 4) = "000100101111111111110001" then
                        if execute_state = Execute_1 then
                            components_en <= "000000000001"; 
                            write_to_data_bus_component_sel <= std_logic_vector("000" & instruction_reg(3 downto 1));
                            components_read_from_data_bus_en_mask <= "00000000000000001000000000000000";
                            thumb_mode_reg_nxt <= instruction_reg(0);
                            execute_state_nxt <= Execute_2;
                        
                        else 
                            components_en <= "000000000101"; --enableing RAM and GPRs
                            write_to_address_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length)); --set address bus to value of program counter
                            write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_address_bus_component_sel'length)); --read data from RAM at address of program counter
                            state_nxt <= FETCH_1; 
                        end if;
                    
                    --Branch and Branch with Link
                    elsif instruction_reg(27 downto 25) = "101" then
                        components_en <= "000000000001"; 

                        if Execute_state = Execute_1 then
                            --create link
                            if instruction_reg(24) = '1' then
                                write_to_data_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length));
                                components_read_from_data_bus_en_mask <= "00000000000000000100000000000000"; --link register R14
                            end if;
                            increment_pc_en <= '1';
                            increment_pc_val <= std_logic_vector(resize(signed(instruction_reg(23 downto 0) & "00"), increment_pc_val'length) + to_signed(-4, increment_pc_val'length));
                            execute_state_nxt <= Execute_2;
                        else
                            components_en <= "000000000101"; --enableing RAM and GPRs
                            write_to_address_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length)); --set address bus to value of program counter
                            write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_data_bus_component_sel'length)); --read data from RAM at address of program counter
                            state_nxt <= FETCH_1; 
                        end if;
                    
                    --Data Processing
                    elsif instruction_reg(27 downto 26) = "00" then
                        immidiate_operand      := instruction_reg(25);
                        op_code                := instruction_reg(24 downto 21);
                        set_condition_codes    := instruction_reg(20);
                        first_operand_register := instruction_reg(19 downto 16);
                        destination_register   := instruction_reg(15 downto 12);
                        operand_2              := instruction_reg(11 downto 0);

                        if Execute_state = Execute_1 then 
                            components_en <= "000000000011"; --enableing GPRs and ALU
                            write_to_data_bus_component_sel <= std_logic_vector("00" & first_operand_register);
                            components_read_from_data_bus_en_mask <= "00000000000000010000000000000000"; --ALU (Register A)
                            ALU_op_code <= op_code;
                            execute_state_nxt <= Execute_2;
                        elsif Execute_state = Execute_2 then 
                            components_en <= "000000000011"; --enableing GPRs and ALU
                            execute_state_nxt <= Execute_3;
                            components_read_from_data_bus_en_mask <= "00000000000000100000000000000000"; --ALU (Register B)
                            if immidiate_operand = '0' then --operand 2 is register
                                write_to_data_bus_component_sel <= std_logic_vector("00" & operand_2(3 downto 0));
                                data_bus_shift <= operand_2(11 downto 4);
                            else --operand 2 is an immediate value
                                write_to_data_bus_component_sel <= std_logic_vector(to_unsigned(19, write_to_data_bus_component_sel'length));
                                data_out <= std_logic_vector(unsigned("000000000000000000000000" & operand_2(7 downto 0)) ROR to_integer(unsigned(operand_2(11 downto 8)))*2);

                            end if;

                        elsif Execute_state = Execute_3 then
                            components_en <= "000000000011"; --enableing GPRs and ALU

                        else 
                            null;
                        end if;
                    
                    --Single Data Transfer (LDR, STR)
                    elsif instruction_reg(27 downto 26) = "01" then
                        immediate_offset           := instruction_reg(25);
                        pre_post_indexing_bit      := instruction_reg(24);
                        up_down_bit                := instruction_reg(23);
                        byte_word_bit              := instruction_reg(22);
                        write_back_bit             := instruction_reg(21);
                        load_store_bit             := instruction_reg(20);
                        base_register              := instruction_reg(19 downto 16);
                        source_destination_register:= instruction_reg(15 downto 12);
                        offset                     := instruction_reg(11 downto 0);

                        components_en <= "000000000101"; --enableing RAM and GPRs
                        RAM_process_byte <= byte_word_bit;

                        if Execute_state = Execute_1 then
                            write_to_data_bus_component_sel <= std_logic_vector("00" & base_register);
                            execute_state_nxt <= Execute_2;
                        
                        elsif Execute_state = Execute_2 then
                            
                            if pre_post_indexing_bit = '1' then --add offset before transfer
                                null;
                            else
                                address := data_in;
                            end if;



                        end if;

                    else
                        components_en <= "000000000101"; --enableing RAM and GPRs
                        write_to_address_bus_component_sel <= std_logic_vector(to_unsigned(15, write_to_address_bus_component_sel'length)); --set address bus to value of program counter
                        write_to_data_bus_component_sel    <= std_logic_vector(to_unsigned(18, write_to_address_bus_component_sel'length)); --read data from RAM at address of program counter
                        state_nxt <= FETCH_1;  
                    end if;
                    
                end if;


            when others =>
                null;
        end case;
    end process;
    
    process(clk, reset)
    begin
        if reset = '1' then
            state <= SETUP;
            execute_state <= Execute_1;
            thumb_mode_reg <= '0';
            instruction_reg <= (others => '0');
            thumb_mode_reg <= '0';
            Z_flag_reg     <= '0';
            N_flag_reg     <= '0';
            C_flag_reg     <= '0';
            V_flag_reg     <= '0';

        elsif rising_edge(clk) then
            execute_state <= execute_state_nxt;
            state <= state_nxt;
            thumb_mode_reg <= thumb_mode_reg_nxt;
            Z_flag_reg     <= Z_flag_reg_nxt;
            N_flag_reg     <= N_flag_reg_nxt;
            C_flag_reg     <= C_flag_reg_nxt;
            V_flag_reg     <= V_flag_reg_nxt;

            if state = FETCH_1 then
                instruction_reg <= data_in;
            end if;
        end if;

    end process;

end Behavioral;
