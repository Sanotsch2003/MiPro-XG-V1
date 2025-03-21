LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY RAM IS
	GENERIC (
		ramSize : INTEGER
	);
	PORT (
		enable        : IN STD_LOGIC;
		reset         : IN STD_LOGIC := '0';
		address       : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clk           : IN STD_LOGIC := '1';
		dataIn        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		readEn        : IN STD_LOGIC := '1';
		writeEn       : IN STD_LOGIC;
		dataOut       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		memOpFinished : OUT STD_LOGIC;
		alteredClk    : IN STD_LOGIC
	);
END RAM;
ARCHITECTURE SYN OF RAM IS

	SIGNAL sub_wire0      : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL cutDownAddress : STD_LOGIC_VECTOR(9 DOWNTO 0);

	SIGNAL count : unsigned(2 DOWNTO 0);
BEGIN
	dataOut        <= sub_wire0(31 DOWNTO 0);
	cutDownAddress <= address(9 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP(
		clock_enable_input_a          => "BYPASS",
		clock_enable_output_a         => "BYPASS",
		intended_device_family        => "MAX 10",
		lpm_hint                      => "ENABLE_RUNTIME_MOD=NO",
		lpm_type                      => "altsyncram",
		numwords_a                    => ramSize,
		operation_mode                => "SINGLE_PORT",
		outdata_aclr_a                => "CLEAR0",
		outdata_reg_a                 => "CLOCK0",
		power_up_uninitialized        => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a                     => 10,
		width_a                       => 32,
		width_byteena_a               => 1
	)
	PORT MAP(
		aclr0     => reset,
		address_a => cutDownAddress,
		clock0    => clk,
		data_a    => dataIn,
		rden_a    => readEn,
		wren_a    => writeEn,
		q_a       => sub_wire0
	);

	--Setting the memOpFinished signal.
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			count <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			IF enable = '1' THEN
				IF writeEn = '1' OR readEn = '1' THEN
					IF count >= 1 THEN
						memOpFinished <= '1';
					ELSE
						memOpFinished <= '0';
						count         <= count + 1;
					END IF;
				ELSE
					memOpFinished <= '0';
					count         <= (OTHERS => '0');
				END IF;
			END IF;
		END IF;
	END PROCESS;
END SYN;