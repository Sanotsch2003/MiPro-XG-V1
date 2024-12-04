library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
    port (
        --inputs
        enable               : in std_logic;
        reset                : in std_logic;
        clk                  : in std_logic;
        
        operand1             : in std_logic_vector(31 downto 0);
        operand2             : in std_logic_vector(31 downto 0);

        bitManipulationCode  : in std_logic_vector(1 downto 0);
        bitManipulationValue : in std_logic_vector(5 downto 0);

        opCode               : in std_logic_vector(3 downto 0);
        carryIn              : in std_logic;
        
        UpperSel             : in std_logic;

        --outputs
        result               : out std_logic_vector(31 downto 0);
        flagsCPSR            : out std_logic_vector(3 downto 0);
        interrupt            : out std_logic;
        
     );
end ALU;

architecture Behavioral of ALU is
    --Constants
    -- Logical Operations
    constant AND_OP  : std_logic_vector(3 downto 0) := "0000"; -- AND
    constant EOR_OP  : std_logic_vector(3 downto 0) := "0001"; -- EOR
    constant ORR_OP  : std_logic_vector(3 downto 0) := "0010"; -- ORR
    constant BIC_OP  : std_logic_vector(3 downto 0) := "0011"; -- BIC
    constant NOT_OP  : std_logic_vector(3 downto 0) := "0100"; -- NOT

    -- Arithmetic Operations
    constant SUB_OP  : std_logic_vector(3 downto 0) := "0101"; -- SUB
    constant BUS_OP  : std_logic_vector(3 downto 0) := "0110"; -- BUS
    constant ADD_OP  : std_logic_vector(3 downto 0) := "0111"; -- ADD
    constant ADC_OP  : std_logic_vector(3 downto 0) := "1000"; -- ADC
    constant SBC_OP  : std_logic_vector(3 downto 0) := "1001"; -- SBC
    constant BSC_OP  : std_logic_vector(3 downto 0) := "1010"; -- BSC
    constant MOV_OP  : std_logic_vector(3 downto 0) := "1011"; -- MOV

    -- Multiplication Operations
    constant MUL_OP  : std_logic_vector(3 downto 0) := "1100"; -- MUL (signed)
    constant UMUL_OP : std_logic_vector(3 downto 0) := "1101"; -- UMUL (unsigned)

    -- Bit Manipulation Operations
    constant ROL_MAN : std_logic_vector(1 downto 0) := "00"; -- ROL
    constant LSL_MAN : std_logic_vector(1 downto 0) := "01"; -- LSL
    constant LSR_MAN : std_logic_vector(1 downto 0) := "10"; -- LSR
    constant ASR_MAN : std_logic_vector(1 downto 0) := "10"; -- ASR


    -- Values of comparison 

    constant ZEROS32   : std_logic_vector(31 downto 0) := x"00000000";
    constant ZEROS31   : std_logic_vector(30 downto 0) := "0000000000000000000000000000000";

    --internal signals

    signal shifterOut        : std_logic_vector(31 downto 0);
    signal operationUnitOut  : std_logic_vector(63 downto 0);
    signal multiplexerOut    : std_logic_vector(31 downto 0);

    signal zeroFlag          : std_logic;
    signal negativeFlag      : std_logic;
    signal overflowFlag      : std_logic;
    signal CarryFlag         : std_logic;

begin
    --implementing the shift/rotate operation on operand 2.
    process(bitManipulationCode, bitManipulationValue, operand2)
    begin
        case bitManipulationCode is
            when ROL_MAN =>
                shifterOut <= std_logic_vector(rotate_left(unsigned(operand2), to_integer(unsigned(bitManipulationValue))))
            when LSL_MAN =>
                shifterOut <= std_logic_vector(shift_left(unsigned(operand2), to_integer(unsigned(bitManipulationValue))))
            when LSR_MAN =>
                shifterOut <= std_logic_vector(shift_right(unsigned(operand2), to_integer(unsigned(bitManipulationValue))))
            when ASR_MAN =>
                shifterOut <= std_logic_vector(shift_right(signed(operand2), to_integer(unsigned(bitManipulationValue)))) 
            when others =>
                shifterOut <= (others => '0');               
        end case;
    end process;


    --implementing the actual operation unit   
    process(operand1, shifterOut, carryIn, opCode) 
        variable operationResult : std_logic_vector(31 downto 0):
    begin
        carryFlag <= '0';
        overflowFlag <= '0';
        case opCode is
            when AND_OP =>
                operationResult := ZEROS32 & (operand1 and shifterOut);
            when EOR_OP =>
                operationResult := ZEROS32 & (operand1 xor shifterOut);
            when ORR_OP =>
                operationResult := ZEROS32 & (operand1 or shifterOut);
            when BIC_OP =>
                operationResult := ZEROS32 & (operand1 and not(shifterOut));
            when NOT_OP =>
                operationResult := ZEROS32 & not shifterOut;
            when SUB_OP =>
                operationResult := ZEROS32 & std_logic_vector(unsigned(operand1) - unsigned(shifterOut));
                carryFlag <= '1' when unsigned(operand1) >= unsigned(shifterOut) else '0';
                overflowFlag <= '1' when (operand1(31) /= shifterOut(31)) and (operand1(31) /= operationResult(31)) else '0';
            when BUS_OP =>
                operationResult := ZEROS32 & std_logic_vector(unsigned(shifterOut) - unsigned(operand1));
                carryFlag <= '1' when unsigned(shifterOut) >= unsigned(operand1) else '0';
                overflowFlag <= '1' when (shifterOut(31) /= operand1(31)) and (shifterOut(31) /= operationResult(31)) else '0';

            when ADD_OP =>
                operationResult := ZEROS31 & std_logic_vector(unsigned('0' & operand1) + unsigned('0' & shifterOut));
                carryFlag <= operationResult(32);
                overflowFlag <= '1' when (operand1(31) = shifterOut(31)) and (operand1(31) /= operationResult(31)) else '0';
            when ADC_OP =>

            when SBC_OP =>

            when BSC_OP =>

            when MOV_OP =>
                operationResult <= ZEROS32 & shifterOut;

            when MUL_OP =>

            when UMUL_OP =>

            when others =>
                operationUnitOut <= (others => '0');
        end case;
            operationUnit_out <= operationResult;
    end process;


    --implementing the multiplexer that decides whether the lower or upper 32 bits of the operationUnitOut will be the result
    process(operationUnitOut, UpperSel)
    begin 
        case UpperSel is
            when '0' =>
                multiplexerOut <= operationUnitOut(31 downto 0);
            when '1' =>
                multiplexerOut <= operationUnitOut(63 downto 32);
            when others =>
                multiplexerOut <= (others => '0');
        end case;
    end process;

    --updating zero and negative flag
    process(multiplexerOut)
    begin
        case multiplexerOut is
            when ZEROS32 =>
                zeroFlag <= '1';
            when others =>
                zeroFlag <= '0';
        end case;
        negativeFlag <= multiplexerOut(31);
    end process;
    
    --connecting flags to CPSR outputs
    flagsCPSR <= zeroFlag & negativeFlag & overflowFlag & carryFlag;

    --connecting the multiplexer output to the actual output of the ALU
    result <= multiplexerOut;

end Behavioral;