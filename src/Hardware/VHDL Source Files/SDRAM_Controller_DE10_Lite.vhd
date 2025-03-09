library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

--Ram clock period : Max 143 Mhz
--CasLatency for this Controller : 3 cycles
--max Burst Length : 64 32-Bit words

entity SdramController is
	 generic(
			numConnectedDevices : integer := 1; --max: 8
			
			--unit: nanoseconds
			memClkPeriod : integer := 7; 
			sysClkPeriod : integer := 10;
			
			--unit: cycles
			t_cac			: integer:=3;
			t_rcd			: integer:=3;
			t_rac			: integer:=6;
			t_rc			: integer:=9;
			t_ras			: integer:=6;
			t_rp			: integer:=3;
			t_rdd			: integer:=2;
			t_ccd			: integer:=1;
			t_dpl			: integer:=2;
			t_dal			: integer:=5;
			t_rbd			: integer:=3;
			t_wbd			: integer:=0;
			t_rql			: integer:=3;
			t_wdl			: integer:=0;
			t_mrd			: integer:=2
			);
    port (
        --System Signals
		  memClk 				: in std_logic;
		  sysClk				: in std_logic;
		  reset					: in std_logic;
		  enable				: in std_logic;
		  
		  --SDRAM Signal
		  SDRAM_ADDR			: out std_logic_vector(12 downto 0);
		  SDRAM_DATA			: inout std_logic_vector(15 downto 0);
		  SDRAM_BANK_ADDR		: out std_logic_vector(1 downto 0);
		  SDRAM_BYTE_MASK		: out std_logic_vector(1 downto 0);
		  SDRAM_RAS				: out std_logic;
		  SDRAM_CAS				: out std_logic;
		  SDRAM_CLK_EN			: out std_logic;
		  SDRAM_CLK				: out std_logic;
		  SDRAM_WRITE_EN		: out std_logic;
		  SDRAM_CHIP_SEL		: out std_logic;
		  
		  --Controller Signals
		  burstLength			: in std_logic_vector(numConnectedDevices*6-1 downto 0);
		  readReq				: in std_logic_vector(numConnectedDevices-1 downto 0);
		  writeReq				: in std_logic_vector(numConnectedDevices-1 downto 0);
		  address				: in std_logic_vector(numConnectedDevices*25-1 downto 0);
		  dataIn				: in std_logic_vector(numConnectedDevices*32-1 downto 0);
		  dataOut				: out std_logic_vector(31 downto 0);
		  byteMask				: in std_logic_vector(numConnectedDevices*4-1 downto 0);
		  rdyToReceive          : out std_logic_vector(numConnectedDevices-1 downto 0);
		  transmissionFinished  : out std_logic_vector(numConnectedDevices-1 downto 0)
    );
end SdramController;

architecture Behavioral of SdramController is
	
	--State machine signals
	type controllerStateType is (SDRAM_POWER_UP, SDRAM_INIT, SDRAM_IDLE, SDRAM_AUTO_REFRESH, SDRAM_READ, SDRAM_WRITE);
	signal controllerState, controllerState_nxt : controllerStateType;
	
	type readBufferStateType is (READ_BUFFER_IDLE);
	signal readBufferState, readBufferState_nxt : readBufferStateType;
	
	type writeBufferStateType is (WRITE_BUFFER_IDLE, WRITE_BUFFER_RECEIVING);
	signal writeBufferState, writeBufferState_nxt : writeBufferStateType;
	
	
	--row and column address signals
	signal s_rowAddress 		: std_logic_vector(12 downto 0);
	signal s_columnAddress 	: std_logic_vector(9 downto 0);
	signal s_bankAddress		: std_logic_vector(1 downto 0);	
	
	signal s_dataOut : std_logic_vector(31 downto 0);
	signal s_command : std_logic_vector(18 downto 0);
	
	--SDRAM COMMANDS:
	constant COMMAND_DEVICE_DESELECT 	       : std_logic_vector(18 downto 0) := "1000000000000000000";
	constant COMMAND_NO_OPERATION			   : std_logic_vector(18 downto 0) := "0111000000000000000";
	constant COMMAND_BURST_STOP			       : std_logic_vector(18 downto 0) := "0110000000000000000";
	constant COMMAND_READ					   : std_logic_vector(4 downto 0) := "01010";
	constant COMMAND_READ_WITH_AP			   : std_logic_vector(4 downto 0) := "01011";
	constant COMMAND_WRITE					   : std_logic_vector(4 downto 0) := "01000";
	constant COMMAND_WRITE_WITH_AP		       : std_logic_vector(4 downto 0) := "01001";
	constant COMMAND_BANK_ACTIVATE		       : std_logic_vector(3 downto 0) := "0011";
	constant COMMAND_PRECHARGE_SEL_BANK        : std_logic_vector(4 downto 0) := "00100";
	constant COMMAND_PRECHARGE_ALL_BANKS       : std_logic_vector(18 downto 0) := "0010100000000000000";
	constant COMMAND_REFRESH				   : std_logic_vector(18 downto 0) := "0001000000000000000";
	constant COMMAND_SET_MODE_REGISTER	       : std_logic_vector(8 downto 0) := "000000000";
	
	--MODE REGISTER constants
	constant MODE_REGISTER_SINGLE_LOCATION_ACCESS  : std_logic_vector(9 downto 0) := "1000110000";
	constant MODE_REGISTER_BURST_2                 : std_logic_vector(9 downto 0) := "0000110001";
	constant MODE_REGISTER_BURST_4                 : std_logic_vector(9 downto 0) := "0000110010";
	constant MODE_REGISTER_BURST_8                 : std_logic_vector(9 downto 0) := "0000110011";
	constant MODE_REGISTER_BURST_FULL              : std_logic_vector(9 downto 0) := "0000110111";
	
	--Timing
	
	--Final Design
	--constant POWER_ON_CYCLES : integer := (100_000 + memClkPeriod - 1) / memClkPeriod; --divide the time needed to power on the SDRAM by the SDRAM-Clk-Frequency and round up the result.
    
    --Testbench
    constant POWER_ON_CYCLES : integer := (100 + memClkPeriod - 1) / memClkPeriod; --divide the time needed to power on the SDRAM by the SDRAM-Clk-Frequency and round up the result.

	
	--Count Signals
	signal stateCycleCount: unsigned(16 downto 0);
	signal stateCycleCountReset : std_logic;
	
	--Refresh Signals
	signal refreshCount            : unsigned(31 downto 0);
	constant refreshWindowCycles   : integer := 7_800 / memClkPeriod;
	signal refreshPending          : boolean;
	signal refreshDone             : std_logic;
	
	
	type std_logic_vector_array is array (natural range <>) of std_logic_vector(15 downto 0);
	
	--Control Registers for Reading
--	signal readBuffer, readBuffer_nxt                  : std_logic_vector_array(63 downto 0);
--	signal readAddressReg, readAddressReg_nxt          : std_logic_vector(24 downto 0);
--	signal readBurstLengthReg, readBurstLengthReg_nxt  : unsigned(5 downto 0);
--	signal readByteMaskReg, readByteMaskReg_nxt        : std_logic_vector(3 downto 0);
	signal readTurnReg, readturnReg_nxt                : unsigned(2 downto 0);
	
	--Control Registers for Writing
	signal writeBuffer, writeBuffer_nxt                : std_logic_vector_array(127 downto 0);
	signal writeAddressReg, writeAddressReg_nxt        : std_logic_vector(24 downto 0);
	signal writeTurnReg, writeTurnReg_nxt              : unsigned(2 downto 0);
	signal writeBurstLengthReg, writeBurstLengthReg_nxt: unsigned(5 downto 0);
	signal writeByteMaskReg, writeByteMaskReg_nxt      : std_logic_vector(3 downto 0);
	signal writeBufferEmpty, writeBufferEmpty_nxt      : boolean := True;
	signal writeBufferWriteCount                       : unsigned(5 downto 0);
	signal writeBufferWriteCountReset                  : std_logic;
	signal writeDeviceIndexReg, writeDeviceIndexReg_nxt: unsigned(2 downto 0);
	
	--Control Registers for Writing AND Reading
	signal addressReg, addressReg_nxt                  : std_logic_vector(24 downto 0);
	signal burstLengthReg, burstLengthReg_nxt          : unsigned(5 downto 0);
	signal byteMaskReg, byteMaskReg_nxt                : std_logic_vector(3 downto 0);
    
begin
    --SDRAM Clock assigment
    SDRAM_CLK <= memClk;

	--command assignments
	SDRAM_CHIP_SEL 				<= s_command(18);
	SDRAM_RAS					<= s_command(17);
	SDRAM_CAS					<= s_command(16);
	SDRAM_WRITE_EN				<= s_command(15);
	SDRAM_ADDR(10) 				<= s_command(14);
	SDRAM_BANK_ADDR				<= s_command(13 downto 12);
	SDRAM_ADDR(12 downto 11)	<= s_command(11 downto 10);
	SDRAM_ADDR(9 downto 0)		<= s_command(9 downto 0);
	
	--address assignments
	s_bankAddress		<= addressReg(24 downto 23);
	s_rowAddress 		<= addressReg(22 downto 10);
	s_columnAddress 	<= addressReg(9 downto 0);

	--Memory State machine
	process(controllerState, stateCycleCount, addressReg, burstLengthReg, byteMaskReg, writeAddressReg, readTurnReg, refreshPending)
	variable deviceIndex : integer;
	variable readTurn_nxt : integer;
	begin
		--Default Assignments
		controllerState_nxt		    <= controllerState;
		addressReg_nxt				<= addressReg;
		burstLengthReg_nxt          <= burstLengthReg;
		byteMaskReg_nxt             <= byteMaskReg;
		readTurnReg_nxt             <= readTurnReg;
		stateCycleCountReset 	    <= '0';
		refreshDone       			<= '0';
		
		
		case controllerState is
		
		when SDRAM_POWER_UP =>
			if to_integer(stateCycleCount) >= POWER_ON_CYCLES-1 then
				stateCycleCountReset <= '1';
				controllerState_nxt <= SDRAM_INIT;
			end if;
			
		when SDRAM_INIT => 
			if to_integer(stateCycleCount) >= (t_rp + t_rc * 8 + t_mrd)-1 then
				stateCycleCountReset <= '1';
				controllerState_nxt <= SDRAM_IDLE;
			end if;
			
		when SDRAM_IDLE =>
		    --Check if Memory needs to be refreshed.
		    if refreshPending = True then
		          controllerState_nxt <= SDRAM_AUTO_REFRESH;
		          refreshDone <= '1';
		          stateCycleCountReset <= '1';
		    
		    --Check if A Write Operation Is needed. 
		    elsif writeBufferEmpty = False then
		          --Setting up Controll Registers
		          addressReg_nxt			<= writeAddressReg;
		          burstLengthReg_nxt        <= writeBurstLengthReg;
		          byteMaskReg_nxt           <= writeByteMaskReg;
		          
		          --Advancing to next State
		          controllerState_nxt <= SDRAM_WRITE;
		          stateCycleCountReset <= '1';
		          
		    --Check if a device want to Read from memory and determine, which device is allowed to based on a round robin mechanism
		    else  

		        for i in 0 to numConnectedDevices-1 loop
		            deviceIndex := to_integer(readTurnReg) + i;
		            if deviceIndex >= numConnectedDevices then
		                  deviceIndex := to_integer(readTurnReg) + i - numConnectedDevices;
		            end if;
		            
		            if readReq(deviceIndex) = '1' then  
                    	--Setting up Controll Registers
                        addressReg_nxt			  <= address(deviceIndex*25+24 downto deviceIndex*25);
                        burstLengthReg_nxt        <= unsigned(burstLength(deviceIndex*6+5 downto deviceIndex*6));
                        byteMaskReg_nxt           <= byteMask(deviceIndex*4+3 downto deviceIndex*4);
                         
                        readTurn_nxt := deviceIndex + 1;
                        if readTurn_nxt >= numConnectedDevices then
                            readTurn_nxt := 0;
                        end if;
                        readTurnReg_nxt           <= to_unsigned(readTurn_nxt, 3);
                        
                        --Advancing to next State
                        controllerState_nxt <= SDRAM_READ;
                        stateCycleCountReset <= '1';  
                        exit;
		            end if;  
		        end loop;
		    end if;
		
		when SDRAM_AUTO_REFRESH =>
		      if to_integer(stateCycleCount) = t_rp + 2*t_rc - 1 then
				    stateCycleCountReset <= '1';
				    controllerState_nxt <= SDRAM_IDLE;	      
		      end if;
		
		
		when SDRAM_WRITE =>
		
		
		when SDRAM_READ => 
			
		
		when others =>
			controllerState_nxt <= SDRAM_INIT;
			
		end case;
	
	end process;
	
	--Memory signal assignments
	process(controllerState, stateCycleCount)
	begin
		--default assignments
		SDRAM_CLK_EN <= '1';
		
		case controllerState is
		
		when SDRAM_POWER_UP =>
				s_command <= COMMAND_NO_OPERATION;
		
		when SDRAM_INIT =>
			if to_integer(stateCycleCount) < t_rp then
				s_command <= COMMAND_PRECHARGE_ALL_BANKS;
			elsif (to_integer(stateCycleCount) = t_rp + t_rc * 0) or (to_integer(stateCycleCount) = t_rp + t_rc * 1) or (to_integer(stateCycleCount) = t_rp + t_rc * 2) or (to_integer(stateCycleCount) = t_rp + t_rc * 3) or (to_integer(stateCycleCount) = t_rp + t_rc * 4) or (to_integer(stateCycleCount) = t_rp + t_rc * 5) or (to_integer(stateCycleCount) = t_rp + t_rc * 6) or (to_integer(stateCycleCount) = t_rp + t_rc * 7) then
				s_command <= COMMAND_REFRESH;
			elsif (to_integer(stateCycleCount) = t_rp + t_rc * 8) then
				s_command <= COMMAND_SET_MODE_REGISTER & MODE_REGISTER_BURST_FULL;
			else 
				s_command <= COMMAND_NO_OPERATION;
			end if;
			
	    when SDRAM_IDLE => 
	       s_command <= COMMAND_NO_OPERATION;
	       
	    when SDRAM_AUTO_REFRESH => 
	       if to_integer(stateCycleCount) = 0 then
	           s_command <= COMMAND_PRECHARGE_ALL_BANKS;
	       elsif to_integer(stateCycleCount) = t_rp or to_integer(stateCycleCount) = t_rp + t_rc then
	           s_command <= COMMAND_REFRESH;
	       else
	           s_command <= COMMAND_NO_OPERATION; 
	       end if;
		
		when others => 
			s_command <= COMMAND_NO_OPERATION;
			
		end case;
	
	end process;
	
	
	--Memory Counters
	process(memClk, reset)
	begin
		if reset = '1' then
			stateCycleCount  <= (others => '0');
			refreshCount     <= (others => '0');
			refreshPending   <= True;
		elsif falling_edge(memClk) then
			--State Cycle Counter
			if stateCycleCountReset = '1' then
				stateCycleCount <= (others => '0');
			else
				stateCycleCount <= stateCycleCount + 1;
			end if;
			
			--Refresh Counter
			if to_integer(refreshCount) = refreshWindowCycles-1 then
				refreshCount <= (others => '0');
				refreshPending <= True;
			else
				refreshCount <= refreshCount + 1;
			end if;	
			
			if refreshDone = '1' then
			     refreshPending <= False;
			end if;
			
		end if;
	end process;
	
	
	--System counters
	process(sysClk, reset)
	begin
	   if reset = '1' then
	       writeBufferWriteCount <= (others => '0');
	   
	   elsif rising_edge(sysClk) then 
	       if enable = '1' then
	           if writeBufferWriteCountReset = '1' then
	               writeBufferWriteCount <= (others => '0');
	           else
	               writeBufferWriteCount <= writeBufferWriteCount + 1;
	           end if;
	       end if;
	   
	   end if;
	end process;
	
	
	--System State Machines
	process(readBufferState, writeBufferState, writeBufferEmpty, writeTurnReg, writeReq, writeBufferWriteCount)
	variable deviceIndex : integer;
	variable nextTurn : integer;
	begin
	   --default assignments
	   readBufferState_nxt         <= readBufferState;
	   writeBufferState_nxt        <= writeBufferState;
	   writeBuffer_nxt             <= writeBuffer;
	   writeTurnReg_nxt            <= writeTurnReg;
	   writeAddressReg_nxt         <= writeAddressReg;
	   writeBurstLengthReg_nxt     <= writeBurstLengthReg;
	   writeByteMaskReg_nxt        <= writeByteMaskReg_nxt;
	   writeDeviceIndexReg_nxt     <= writeDeviceIndexReg;
	   rdyToReceive                <= (others => '0');
	   writeBufferWriteCountReset  <= '0';
	   
	   
	   case writeBufferState is 
	       when WRITE_BUFFER_IDLE =>
	           if writeBufferEmpty = true then
	               --Calculate, which device is allowed to write to the buffer based on a round robin mechanism
	                for i in 0 to numConnectedDevices-1 loop
                        deviceIndex := to_integer(writeTurnReg) + i;
                        if deviceIndex >= numConnectedDevices then
                              deviceIndex := to_integer(writeTurnReg) + i - numConnectedDevices;
                        end if; 
                        
                        if writeReq(deviceIndex) = '1' then
                            --Load registers to perform write operation
                            nextTurn := deviceIndex + 1;
                            if nextTurn >= numConnectedDevices then
                                nextTurn := 0;
                            end if;
                            writeTurnReg_nxt        <= to_unsigned(nextTurn, 3);
                            writeAddressReg_nxt     <= address(deviceIndex*25+24 downto deviceIndex*25);
                            writeBurstLengthReg_nxt <= unsigned(burstLength(deviceIndex*6+5 downto deviceIndex*6));
                            writeByteMaskReg_nxt    <= byteMask(deviceIndex*4+3 downto deviceIndex*4);
                            writeDeviceIndexReg_nxt <= to_unsigned(deviceIndex, 3);
                            
                            --Tell device to start sending data
                            rdyToReceive(deviceIndex) <= '1';
                            
                            --Tell the other state machine to start writing the data to memory. 
                            writeBufferEmpty_nxt <= False;
                            
                            --Go to next state and start counter
                            writeBufferWriteCountReset <= '1';
                            writeBufferState_nxt <= WRITE_BUFFER_RECEIVING;
                            exit;
                        end if;
                        
		            end loop;
	           end if;
	       
	       when WRITE_BUFFER_RECEIVING =>
	           --Receiving Data
	           deviceIndex := to_integer(writeDeviceIndexReg);
	           writeBuffer_nxt(to_integer(writeBufferWriteCount)*2)    <= dataIn(deviceIndex*32+31 downto deviceIndex*32+16);
	           writeBuffer_nxt(to_integer(writeBufferWriteCount)*2+1)  <= dataIn(deviceIndex*32+15 downto deviceIndex*32);
	           
	           if writeBufferWriteCount >= writeBurstLengthReg then 
	               writeBufferState_nxt <= WRITE_BUFFER_IDLE;
	           end if;
	         
	       when others =>
	   end case;
	   
	   case readBufferState is 
	       when READ_BUFFER_IDLE => 
	       
	       when others =>
	       
	   end case;
	
	end process;
	
	
	--Update registers that are managed by the system clock
	process(sysClk, reset)
	begin
	   if reset = '1' then
	       readBufferState              <= READ_BUFFER_IDLE;
	       writeBufferState             <= WRITE_BUFFER_IDLE;
	       writeBuffer                  <= (others => (others => '0'));
	       writeAddressReg              <= (others => '0');
           writeTurnReg                 <= (others => '0');
           writeBurstLengthReg          <= (others => '0');
           writeByteMaskReg             <= (others => '0');
           writeDeviceIndexReg          <= (others => '0');
	   
	   elsif rising_edge(sysClk) then
            if enable = '1' then
                readBufferState     <= readBufferState_nxt;
                writeBufferState    <= writeBufferState_nxt;
                writeBuffer         <= writeBuffer_nxt;
                writeAddressReg     <= writeAddressReg_nxt;
                writeTurnReg        <= writeTurnReg_nxt;
                writeBurstLengthReg <= writeBurstLengthReg_nxt;
                writeByteMaskReg    <= writeByteMaskReg_nxt;
                writeDeviceIndexReg <= writeDeviceIndexReg_nxt;
                
             
            end if;
	   end if;
	end process;
	
	
	
	--Update registers that are managed by the memory clock
	process(memClk, reset)
	begin
	if reset = '1' then
		controllerState 				<= SDRAM_POWER_UP;
		addressReg						<= (others => '0');
		burstLengthReg                  <= (others => '0');
		byteMaskReg                     <= (others => '0');
		readTurnReg                     <= (others => '0');
		
	elsif falling_edge(memClk) then
	   if enable = '1' then
            controllerState 				<= controllerState_nxt;
            addressReg						<= addressReg_nxt;
            burstLengthReg                  <= burstLengthReg_nxt;
            byteMaskReg                     <= byteMaskReg_nxt;
            readTurnReg                     <= readTurnReg_nxt;
		end if;
	end if;
	
	end process;
	
	--Sequential process to mask the output.
--	process(s_dataOut, byteMask)
--	begin
--		for i in 0 to 3 loop
--			if byteMask(i) = '1' then
--				dataOut(8*i+7 downto 8*i) <= s_dataOut(8*i+7 downto 8*i)
--			else
--				dataOut(8*i+7 downto 8*i) <= "0x00";
--			end if;
--		end loop;
--	end process;

end Behavioral;
