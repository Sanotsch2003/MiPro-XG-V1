LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--this is a comment
ENTITY ALU IS
    PORT (
        clk        : IN STD_LOGIC;
        reset      : IN STD_LOGIC;
        enable     : IN STD_LOGIC;
        alteredClk : IN STD_LOGIC;
        operand1   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        operand2   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        bitManipulationCode  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        bitManipulationValue : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        opCode  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        carryIn : IN STD_LOGIC;

        upperSel : IN STD_LOGIC;

        --outputs
        result    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        flagsCPSR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        debug     : OUT STD_LOGIC_VECTOR(67 DOWNTO 0)
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    --Constants
    -- Logical Operations
    CONSTANT AND_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- AND
    CONSTANT EOR_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- EOR
    CONSTANT ORR_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010"; -- ORR
    CONSTANT BIC_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011"; -- BIC
    CONSTANT NOT_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100"; -- NOT

    -- Arithmetic Operations
    CONSTANT SUB_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101"; -- SUB
    CONSTANT BUS_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; -- BUS
    CONSTANT ADD_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111"; -- ADD
    CONSTANT ADC_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000"; -- ADC
    CONSTANT SBC_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001"; -- SBC
    CONSTANT BSC_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010"; -- BSC
    CONSTANT MOV_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011"; -- MOV

    -- Multiplication Operations
    CONSTANT MUL_OP  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100"; -- MUL (signed)
    CONSTANT UMUL_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101"; -- UMUL (unsigned)

    -- Bit Manipulation Operations
    CONSTANT ROL_MAN : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; -- ROL
    CONSTANT LSL_MAN : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01"; -- LSL
    CONSTANT LSR_MAN : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10"; -- LSR
    CONSTANT ASR_MAN : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11"; -- ASR
    -- Values of comparison 
    CONSTANT ZEROS32 : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    CONSTANT ZEROS31 : STD_LOGIC_VECTOR(30 DOWNTO 0) := "0000000000000000000000000000000";

    --internal signals
    SIGNAL shifterOut       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL operationUnitOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --signal multiplexerOut    : std_logic_vector(31 downto 0);

    SIGNAL zeroFlag     : STD_LOGIC;
    SIGNAL negativeFlag : STD_LOGIC;
    SIGNAL overflowFlag : STD_LOGIC;
    SIGNAL CarryFlag    : STD_LOGIC;
    SIGNAL flagsReg     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL resultReg    : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    --implementing the shift/rotate operation on operand 2.
    PROCESS (bitManipulationCode, bitManipulationValue, operand2)
    BEGIN
        CASE bitManipulationCode IS
            WHEN ROL_MAN =>
                shifterOut <= STD_LOGIC_VECTOR(rotate_left(unsigned(operand2), to_integer(unsigned(bitManipulationValue))));
            WHEN LSL_MAN =>
                shifterOut <= STD_LOGIC_VECTOR(shift_left(unsigned(operand2), to_integer(unsigned(bitManipulationValue))));
            WHEN LSR_MAN =>
                shifterOut <= STD_LOGIC_VECTOR(shift_right(unsigned(operand2), to_integer(unsigned(bitManipulationValue))));
            WHEN ASR_MAN =>
                shifterOut <= STD_LOGIC_VECTOR(shift_right(signed(operand2), to_integer(unsigned(bitManipulationValue))));
            WHEN OTHERS =>
                shifterOut <= operand2;
        END CASE;
    END PROCESS;
    --implementing the actual operation unit   
    PROCESS (operand1, shifterOut, carryIn, opCode)
        VARIABLE operationResult : STD_LOGIC_VECTOR(32 DOWNTO 0);
        VARIABLE multiplicationResult : std_logic_vector(63 downto 0);
    BEGIN
        carryFlag    <= '0';
        overflowFlag <= '0';
        CASE opCode IS
            WHEN AND_OP =>
                operationResult := '0' & (operand1 AND shifterOut);

            WHEN EOR_OP =>
                operationResult := '0' & (operand1 XOR shifterOut);

            WHEN ORR_OP =>
                operationResult := '0' & (operand1 OR shifterOut);

            WHEN BIC_OP =>
                operationResult := '0' & (operand1 AND NOT(shifterOut));

            WHEN NOT_OP =>
                operationResult := '0' & NOT shifterOut;

            WHEN SUB_OP =>
                operationResult := '0' & STD_LOGIC_VECTOR(unsigned(operand1) - unsigned(shifterOut));
                IF unsigned(operand1) <= unsigned(shifterOut) THEN
                    carryFlag             <= '1';
                END IF;
                IF (operand1(31) /= shifterOut(31)) AND (operand1(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;

            WHEN BUS_OP =>
                operationResult := '0' & STD_LOGIC_VECTOR(unsigned(shifterOut) - unsigned(operand1));
                IF unsigned(shifterOut) <= unsigned(operand1) THEN
                    carryFlag               <= '1';
                END IF;
                IF (shifterOut(31) /= operand1(31)) AND (shifterOut(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;

            WHEN ADD_OP =>
                operationResult := STD_LOGIC_VECTOR(unsigned('0' & operand1) + unsigned('0' & shifterOut));
                carryFlag <= operationResult(32);
                IF (operand1(31) = shifterOut(31)) AND (operand1(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;

            WHEN ADC_OP =>
                operationResult := STD_LOGIC_VECTOR(unsigned('0' & operand1) + unsigned('0' & shifterOut) + unsigned(ZEROS32 & carryIN));
                carryFlag <= operationResult(32);
                IF (operand1(31) = shifterOut(31)) AND (operand1(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;

            WHEN SBC_OP =>
                operationResult := '0' & STD_LOGIC_VECTOR(unsigned(operand1) - unsigned(shifterOut) - (to_unsigned(1, 32) - unsigned(ZEROS31 & carryIN)));
                IF unsigned(operand1) >= (unsigned(shifterOut) + (to_unsigned(1, 33) - unsigned(ZEROS32 & carryIN))) THEN
                    carryFlag <= '1';
                END IF;
                IF (operand1(31) /= shifterOut(31)) AND (operand1(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;

            WHEN BSC_OP =>
                operationResult := '0' & STD_LOGIC_VECTOR(unsigned(shifterOut) - unsigned(operand1) - (to_unsigned(1, 32) - unsigned(ZEROS31 & carryIN)));
                IF unsigned(shifterOut) >= (unsigned(operand1) + (to_unsigned(1, 33) - unsigned(ZEROS32 & carryIN))) THEN
                    carryFlag <= '1';
                END IF;
                IF (shifterOut(31) /= operand1(31)) AND (shifterOut(31) /= operationResult(31)) THEN
                    overflowFlag <= '1';
                END IF;
            WHEN MOV_OP =>
                operationResult := '0' & shifterOut;

            when MUL_OP =>
                operationResult := '0' & std_logic_vector(unsigned(operand1(15 downto 0))*unsigned(shifterOut(15 downto 0)));
--            when MUL_OP =>
--                multiplicationResult := std_logic_vector(signed(operand1)*signed(shifterOut));
--                operationResult := multiplicationResult(32 downto 0);
--            when UMUL_OP =>
--                multiplicationResult := std_logic_vector(unsigned(operand1)*unsigned(shifterOut));
--                operationResult := multiplicationResult(32 downto 0);

            WHEN OTHERS                =>
                operationResult := (OTHERS => '0');
        END CASE;
        operationUnitOut <= operationResult(31 DOWNTO 0);

        --setting the zero flag
        CASE operationResult(31 DOWNTO 0) IS
            WHEN ZEROS32 =>
                zeroFlag <= '1';
            WHEN OTHERS =>
                zeroFlag <= '0';
        END CASE;

        --setting the negative flag
        negativeFlag <= operationResult(31);
    END PROCESS;

    --Updating the result register and the status flag register.
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            resultReg <= (OTHERS => '0');
            flagsReg  <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                IF alteredClk = '1' THEN
                    resultReg <= operationUnitOut;
                    flagsReg  <= zeroFlag & negativeFlag & overflowFlag & carryFlag;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    --Connecting registers to outputs.
    result    <= resultReg;
    flagsCPSR <= flagsReg;

    --Concatenating all relevant signals and connecting them to the debug signal (1+1+1+1+32+32=68 bit).
    debug <= zeroFlag & negativeFlag & overflowFlag & carryFlag & shifterOut & operationUnitOut;

END Behavioral;