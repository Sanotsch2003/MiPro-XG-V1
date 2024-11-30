library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BusConnections is
    Port (
        --component output signals
        GPR_outputs                         : in std_logic_vector(16 * 32 - 1 downto 0); 
        ALU_output                          : in std_logic_vector(31 downto 0);
        RAM_output                          : in std_logic_vector(31 downto 0);
        CU_output                           : in std_logic_vector(31 downto 0);

        --control signals for the multiplexer that decides which component writes to the data/address bus
        write_to_data_bus_component_sel     : in std_logic_vector(5 downto 0);
        write_to_address_bus_component_sel  : in std_logic_vector(5 downto 0);

        --RAM read enable signal            
        RAM_read_en                         : out std_logic;
        
        --bus output
        data_bus_out                        : out std_logic_vector(31 downto 0);
        address_bus_out                     : out std_logic_vector(31 downto 0);

        data_bus_shift                      : in std_logic_vector(7 downto 0);
        address_bus_shift                   : in std_logic_vector(7 downto 0);
        carry_in                            : in std_logic;
        carry_out                           : out std_logic
    );
end BusConnections;

architecture Behavioral of BusConnections is
signal data_bus_out_tmp    : std_logic_vector(31 downto 0);
signal address_bus_out_tmp : std_logic_vector(31 downto 0);

begin


    data_shifting : process(data_bus_shift, data_bus_out_tmp, carry_in)
        variable shift_amount   : integer;
        variable shift_type     : std_logic_vector(1 downto 0);
        variable shift_register : integer;
        variable tmp_result     : std_logic_vector(32 downto 0);
        begin
            shift_type := data_bus_shift(2 downto 1);
            if data_bus_shift(0) = '0' then
                shift_amount := to_integer(signed("000" & data_bus_shift(7 downto 3)));
            else 
                shift_register := to_integer(unsigned(data_bus_shift(7 downto 4)));
                shift_amount := to_integer(signed(GPR_outputs(shift_register * 32 + 7 downto shift_register * 32)));
            end if;

            if data_bus_shift(0) = '1' and shift_amount = 0 then
                data_bus_out <= data_bus_out_tmp;
                carry_out <= carry_in;
            
            else
                case shift_type is
                    when "00" => 
                        tmp_result := std_logic_vector(shift_left(unsigned('0' & data_bus_out_tmp), shift_amount));
                        data_bus_out <= tmp_result(31 downto 0);
                        carry_out <= tmp_result(32);
                        if shift_amount = 0 then
                            carry_out <= carry_in;
                        end if;

                    when "01" =>
                        if shift_amount = 0 then
                            data_bus_out <= (others => '0');
                            carry_out <= data_bus_out_tmp(31);
                        else
                            tmp_result := std_logic_vector(shift_right(unsigned(data_bus_out_tmp & '0'), shift_amount));
                            data_bus_out <= tmp_result(32 downto 1);
                            carry_out <= tmp_result(0);
                        end if;

                    when "10" => 
                        if shift_amount = 0 then
                            for i in 31 downto 0 loop
                                data_bus_out(i) <= data_bus_out_tmp(31);
                            end loop;
                            carry_out <= data_bus_out_tmp(31);
                        else
                            tmp_result := std_logic_vector(shift_right(signed(data_bus_out_tmp & '0'), shift_amount));
                            data_bus_out <= tmp_result(32 downto 1);
                            carry_out <= tmp_result(0);
                        end if;
                    when "11" => 
                        if shift_amount = 0 then
                            data_bus_out <= carry_in & data_bus_out_tmp(31 downto 1);
                            carry_out <= data_bus_out_tmp(0);

                        else 
                            tmp_result := '0' & std_logic_vector(rotate_right(unsigned(data_bus_out_tmp), shift_amount));
                            data_bus_out <= tmp_result(31 downto 0);
                            carry_out <= tmp_result(31);
                        end if;
                    when others =>
                        null;
                end case;
            end if;

        end process;

    address_shifting : process(address_bus_shift, address_bus_out_tmp)
        begin
            address_bus_out <= address_bus_out_tmp;
        end process;

    data_bus : process(write_to_data_bus_component_sel, GPR_outputs, ALU_output, RAM_output)
    begin
        --default assignments
        data_bus_out_tmp <= (others => '0');
        RAM_read_en  <= '0';
        
        for i in 0 to 16-1 loop
            if to_integer(unsigned(write_to_data_bus_component_sel)) = i then
                data_bus_out_tmp <= GPR_outputs((i+1) * 32 - 1 downto 32*i);
            end if;
        end loop;
        
        if to_integer(unsigned(write_to_data_bus_component_sel)) = 16 then
            data_bus_out_tmp <= ALU_output;
        end if;
        
        if to_integer(unsigned(write_to_data_bus_component_sel)) = 18 then
            RAM_read_en  <= '1';
            data_bus_out_tmp <= RAM_output;
        end if;

        if to_integer(unsigned(write_to_data_bus_component_sel)) = 19 then
            data_bus_out_tmp <= CU_output;
        end if;
        

    end process;

    address_bus : process(write_to_address_bus_component_sel, GPR_outputs, ALU_output)
    begin
        address_bus_out_tmp <= (others => '0'); --default assignment
        for i in 0 to 16-1 loop
            if to_integer(unsigned(write_to_address_bus_component_sel)) = i then
                address_bus_out_tmp <= GPR_outputs((i+1) * 32 - 1 downto 32*i);
            end if;
        end loop;
        
        if to_integer(unsigned(write_to_address_bus_component_sel)) = 16 then
            address_bus_out_tmp <= ALU_output;
        end if;
        
        --if to_integer(unsigned(write_to_address_bus_component_sel)) = 18 then
            --address_bus_out_tmp <= (others => '0'); --RAM output cannot directly be used to set the address bus
        --end if;

        if to_integer(unsigned(write_to_address_bus_component_sel)) = 16 then
            address_bus_out_tmp <= CU_output;
        end if;

    end process;


end Behavioral;
