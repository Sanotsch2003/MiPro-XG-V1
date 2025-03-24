library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ALU_tb is
end;

architecture bench of ALU_tb is

  component ALU
      port (
          operand1             : in std_logic_vector(31 downto 0);
          operand2             : in std_logic_vector(31 downto 0);
          bitManipulationCode  : in std_logic_vector(1 downto 0);
          bitManipulationValue : in std_logic_vector(5 downto 0);
          opCode               : in std_logic_vector(3 downto 0);
          carryIn              : in std_logic;
          UpperSel             : in std_logic;
          result               : out std_logic_vector(31 downto 0);
          flagsCPSR            : out std_logic_vector(3 downto 0);
          interrupt            : out std_logic
       );
  end component;

  signal operand1: std_logic_vector(31 downto 0);
  signal operand2: std_logic_vector(31 downto 0);
  signal bitManipulationCode: std_logic_vector(1 downto 0);
  signal bitManipulationValue: std_logic_vector(5 downto 0);
  signal opCode: std_logic_vector(3 downto 0);
  signal carryIn: std_logic;
  signal UpperSel: std_logic;
  signal result: std_logic_vector(31 downto 0);
  signal flagsCPSR: std_logic_vector(3 downto 0);
  signal interrupt: std_logic ;

begin

  uut: ALU port map ( operand1             => operand1,
                      operand2             => operand2,
                      bitManipulationCode  => bitManipulationCode,
                      bitManipulationValue => bitManipulationValue,
                      opCode               => opCode,
                      carryIn              => carryIn,
                      UpperSel             => UpperSel,
                      result               => result,
                      flagsCPSR            => flagsCPSR,
                      interrupt            => interrupt );

  stimulus: process
  begin
    operand1 <= (others => '0');
    operand2 <= (others => '0');
    bitManipulationCode <= (others => '0');
    bitManipulationValue <= (others => '0');
    opCode <= (others => '0');
    carryIn <= '1';
    UpperSel <= '0';

    -- Wait 10 ns for initialization
    wait for 10 ns;

    -- Assign random values to operands
    operand1 <= std_logic_vector(to_unsigned(3456756, 32));
    operand2 <= std_logic_vector(to_unsigned(3456756, 32));

    -- Wait for some time to observe the results
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(1, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(2, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(3, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(4, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(5, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(6, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(7, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(8, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(9, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(10, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(11, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(12, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(13, 4));
    wait for 10 ns;
    opCode <= std_logic_vector(to_unsigned(14, 4));
    wait for 10 ns; 
    opCode <= std_logic_vector(to_unsigned(15, 4));
    wait for 10 ns;

    -- Repeat randomization for multiple test cases

    wait;
  end process;


end;