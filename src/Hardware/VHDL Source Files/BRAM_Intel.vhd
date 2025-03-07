library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY RAM IS
	generic(
		ramSize : integer
	);
	PORT
	(
		enable				: in std_logic;
		reset					: IN STD_LOGIC  := '0';
		address				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clk					: IN STD_LOGIC  := '1';
		dataIn				: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		readEn				: IN STD_LOGIC  := '1';
		writeEn				: IN STD_LOGIC ;
		dataOut				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		memOpFinished     : out std_logic;
		alteredClk        : in std_logic
	);
END RAM;


ARCHITECTURE SYN OF RAM IS

	signal sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal cutDownAddress : std_logic_vector(9 downto 0);
	
	signal count : unsigned(2 downto 0);
	

BEGIN
	dataOut    <= sub_wire0(31 DOWNTO 0); 
	cutDownAddress <= address(9 downto 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		intended_device_family => "MAX 10",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => ramSize,
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
		aclr0 => reset,
		address_a => cutDownAddress,
		clock0 => clk,
		data_a => dataIn,
		rden_a => readEn,
		wren_a => writeEn,
		q_a => sub_wire0
	);
	
	--Setting the memOpFinished signal.
	 process(clk, reset)
	 begin
		  if reset = '1' then
				count <= (others => '0');
		  elsif rising_edge(clk) then
				if enable = '1' then 
					if writeEn = '1' or readEn = '1' then
						 if count >= 1 then
							  memOpFinished <= '1';
						 else
							  memOpFinished <= '0';
							  count <= count + 1;
						 end if;
					else
						 memOpFinished <= '0';
						 count <= (others => '0');
					end if;
				end if;
			end if;
	 end process;


END SYN;

