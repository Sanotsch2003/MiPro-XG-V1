LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY BRAM IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		           memOpFinished              : out std_logic
	);
END BRAM;


ARCHITECTURE SYN OF bram IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
	q    <= sub_wire0(31 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		intended_device_family => "MAX 10",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 1024,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "CLEAR0",
		outdata_reg_a => "CLOCK0",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 10,
		width_a => 32,
		width_byteena_a => 1
	)
	PORT MAP (
		aclr0 => aclr,
		address_a => address,
		clock0 => clock,
		data_a => data,
		rden_a => rden,
		wren_a => wren,
		q_a => sub_wire0
	);



END SYN;

