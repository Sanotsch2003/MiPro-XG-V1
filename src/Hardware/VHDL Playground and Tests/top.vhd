library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Generic(
        number_of_seven_segment_displays : integer := 4
    );
    Port (
        clk                  : in std_logic;
        reset                : in std_logic;

        seven_segment_leds   : out std_logic_vector(6 downto 0);
        seven_segment_anodes : out std_logic_vector(number_of_seven_segment_displays-1 downto 0)

     );
end top;

architecture Behavioral of top is


component ControlUnit is
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
end component;

component BusConnections is
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
end component;

component GeneralPurposeRegisters is
    port(
        enable           : in std_logic;
        reset            : in std_logic;
        clk              : in std_logic;
        data_in          : in std_logic_vector(32-1 downto 0);
        data_out         : out std_logic_vector(16 * 32-1 downto 0);
        load_reg_en      : in std_logic_vector(16-1 downto 0);
        increment_PC_en  : in std_logic; --Register 15 is used as the program counter
        Increment_PC_val : in std_logic_vector(31 downto 0)
    );
end component;

component ALU is
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
end component;

component RAM is
    Port (
        --ram control signals:
        enable                     : in std_logic;
        clk                        : in std_logic;
        reset                      : in std_logic;
        data_in                    : in std_logic_vector(31 downto 0);
        address                    : in std_logic_vector(31 downto 0);
        data_out                   : out std_logic_vector(31 downto 0);
        write_enable               : in std_logic;
        read_enable                : in std_logic;
        process_byte               : in std_logic;
        address_alignment_interrupt: out std_logic;
        read_only_interrupt        : out std_logic;
        invalid_address_interrupt  : out std_logic;

        --IO signals:

        --7-segment display:
        seven_segment_data         : out std_logic_vector(31 downto 0);
        seven_segment_control      : out std_logic_vector(31 downto 0)

        --UART:
        --UART_RX_data               : in std_logic_vector(7 downto 0);
        --UART_TX_data               : out std_logic_vector(7 downto 0);
        --UART_control               : in std_logic_vector(7 downto 0);
        --UART_status                : out std_logic_vector(7 downto 0)
    );

end component;

component IO_SevenSegmentDisplay is
    generic(
        --The number of 7-segment displays that are connected to the FPGA.
        num_displays : integer := 4
    );
    Port (
        clk                   : in std_logic;
        --IO ports for the 7-segment display:
        seg                   : out std_logic_vector(6 downto 0);
        an                    : out std_logic_vector(num_displays-1 downto 0);
        --control signals:
        reset                 : in std_logic;
        data                  : in std_logic_vector(31 downto 0);
        control               : in std_logic_vector(31 downto 0)

      );
end component;

constant segment_data    : std_logic_vector(31 downto 0) := "00000000000000000000000011111111";
constant segment_control : std_logic_vector(31 downto 0) := "00000001000000000000000000100100";

-------------------------------------------------------------------------------------
--Control signals

--read from bus enable signals
signal load_GPRs_en     : std_logic_vector(15 downto 0);
signal load_ALU_regs_en : std_logic_vector(1 downto 0);
signal RAM_write_en     : std_logic;

--combined read from bus enable signals 
signal components_read_from_data_bus_en_mask : std_logic_vector(31 downto 0);

--signals for selcting the component that can write to the data/address bus
signal write_to_data_bus_component_sel    : std_logic_vector(5 downto 0);
signal write_to_address_bus_component_sel : std_logic_vector(5 downto 0);

--component enable signals
signal GPRs_en: std_logic;
signal ALU_en : std_logic;
signal RAM_en : std_logic;

--combined enable signal
signal components_en: std_logic_vector(11 downto 0);

--ALU controll signals
signal ALU_op_code : std_logic_vector(3 downto 0);

--RAM controll signals
signal RAM_process_byte : std_logic;

--------------------------------------------------------------------------------------
--Interrupt signals
signal address_alignment_interrupt : std_logic;
signal read_only_interrupt         : std_logic;
signal invalid_address_interrupt   : std_logic;

--------------------------------------------------------------------------------------
--Memory mapped IO signals
signal seven_segment_data    : std_logic_vector(31 downto 0);
signal seven_segment_controll : std_logic_vector(31 downto 0);

---------------------------------------------------------------------------------------

--component data_out signals
signal GPRs_data_out   : std_logic_vector(16 * 32-1 downto 0);
signal ALU_data_out    : std_logic_vector(31 downto 0);
signal ALU_flags_out   : std_logic_vector(3 downto 0);
signal RAM_data_out    : std_logic_vector(31 downto 0);
signal CU_data_out     : std_logic_vector(31 downto 0);


--bus signals
signal data_bus          : std_logic_vector(31 downto 0);
signal address_bus       : std_logic_vector(31 downto 0);

signal data_bus_shift    : std_logic_vector(7 downto 0);
signal address_bus_shift : std_logic_vector(7 downto 0);

signal bus_carry_out     : std_logic;

--connections between components
signal RAM_read_en : std_logic;

--additional controll signals
signal increment_PC_en  : std_logic;
signal increment_PC_val : std_logic_vector(31 downto 0);
signal carry_in         : std_logic;

begin
    --combining the individual read from_data_bus signals to one large signal
    load_GPRs_en     <= components_read_from_data_bus_en_mask(15 downto 0);
    load_ALU_regs_en <= components_read_from_data_bus_en_mask(17 downto 16);
    RAM_write_en     <= components_read_from_data_bus_en_mask(18);

    --combining enable signals to one large signal
    GPRs_en <= components_en(0);
    ALU_en  <= components_en(1);
    RAM_en  <= components_en(2);

    BusConnections_inst: BusConnections
        port map(
            GPR_outputs                         => GPRs_data_out,
            ALU_output                          => ALU_data_out,
            RAM_output                          => RAM_data_out,
            CU_output                           => CU_data_out,
            write_to_data_bus_component_sel     => write_to_data_bus_component_sel,
            write_to_address_bus_component_sel  => write_to_address_bus_component_sel,
            RAM_read_en                         => RAM_read_en,
            data_bus_out                        => data_bus,
            address_bus_out                     => address_bus,
            data_bus_shift                      => data_bus_shift,
            address_bus_shift                   => address_bus_shift,
            carry_in                            => carry_in,
            carry_out                           => bus_carry_out
        );

    ControlUnit_inst : ControlUnit
        port map(
            clk                                     => clk,
            reset                                   => reset,
            data_in                                 => data_bus,
            data_out                                => CU_data_out,
            ALU_flags_in                            => ALU_flags_out,
            write_to_data_bus_component_sel         => write_to_data_bus_component_sel,
            write_to_address_bus_component_sel      => write_to_address_bus_component_sel,
            components_read_from_data_bus_en_mask   => components_read_from_data_bus_en_mask,
            data_bus_shift                          => data_bus_shift,
            address_bus_shift                       => address_bus_shift,
            components_en                           => components_en,
            ALU_op_code                             => ALU_op_code,
            carry_in                                => carry_in,
            RAM_process_byte                        => RAM_process_byte,
            increment_PC_en                         => increment_PC_en,
            Increment_PC_val                        => Increment_PC_val,
            bus_carry_out                           => bus_carry_out
        );

    GPRs_inst : GeneralPurposeRegisters
        port map(
            clk              => clk,
            reset            => reset,
            enable           => GPRs_en,
            data_in          => data_bus,
            data_out         => GPRs_data_out,
            load_reg_en      => load_GPRs_en,
            increment_PC_en  => increment_PC_en,
            increment_PC_val => increment_PC_val
        );

    ALU_inst : ALU
        port map(
            enable         => ALU_en,
            reset          => reset,
            clk            => clk,
            data_in        => data_bus,
            data_out       => ALU_data_out,
            load_regs_en   => load_ALU_regs_en,
            op_code        => ALU_op_code,
            flags          => ALU_flags_out,
            carry_in       => carry_in
        );

    RAM_inst : RAM
        port map(
            clk                        => clk,
            enable                     => RAM_en,
            reset                      => reset,
            data_in                    => data_bus,
            address                    => address_bus,
            data_out                   => RAM_data_out,
            write_enable               => RAM_write_en,
            read_enable                => RAM_read_en,
            process_byte               => RAM_process_byte,
            address_alignment_interrupt=> address_alignment_interrupt,
            read_only_interrupt        => read_only_interrupt,
            invalid_address_interrupt  => invalid_address_interrupt,
            seven_segment_data         => seven_segment_data,
            seven_segment_control      => seven_segment_controll
        );


    IO_SevenSegmentDisplay_inst : IO_SevenSegmentDisplay
        generic map(
            num_displays => number_of_seven_segment_displays
        )
        port map(
            clk     => clk,
            reset   => reset,
            seg     => seven_segment_leds,
            an      => seven_segment_anodes,
            data    => seven_segment_data,
            control => seven_segment_controll
        );


end Behavioral;
