--This register holds contitional flags and other flags that hold information about the processors state
--CPSR(0) : N (Negative Flag)
--CPSR(1) : Z (Zero Flag)
--CPSR(2) : C (Carry Flag)
--CPSR(3) : V (Overflow Flag)
--CPSR(4) : T (Thumb State Flag)
--CPSR(5) : I (Interrup Request Disable Flag)
--CPSR(6) : F (Fast Interrupt Request Disable Flag)
--CPSR(7-11) : M (Mode bits, not used in mircroprocessor)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CurrentProgramStatusRegister is
  Port (
    clk                  : in std_logic;
    reset                : in std_logic;
    enable               : in std_logic;

    alu_flags_input      : in std_logic_vector(3 downto 0); --direct access for changing flags from ALU (priority over bus access)
    update_flags_from_alu: in std_logic; --enable to copy alu_flags_input into CPSR

    data_bus_input       : in std_logic_vector(11 downto 0); --for updating flags from data_bus (can be used to copy status from general purpose register or restore state from RAM)
    update_flags_from_bus: in std_logic; --enable to copy flags from data_bus to CPSR

    flags_output         : out std_logic_vector(31 downto 0)
    );

end CurrentProgramStatusRegister;

architecture Behavioral of CurrentProgramStatusRegister is
    signal   CPSR    : std_logic_vector(11 downto 0) := (others => '0');
    constant padding :  std_logic_vector (19 downto 0) := (others => '0');
begin
    flags_output <= padding & CPSR;

    process(clk, reset)
    begin
        if reset = '1' then
            CPSR <= (others=> '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                if update_flags_from_alu = '1' then
                    CPSR(3 downto 0) <= alu_flags_input;
                elsif update_flags_from_bus = '1' then
                    CPSR <= data_bus_input(11 downto 0);
                end if;
            end if;
        end if;
    end process;

end Behavioral;