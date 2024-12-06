library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serialInterface is
  Port (
        clk   : in std_logic;
        reset : in std_logic;

        dataIn  : in std_logic_vector(31 downto 0);
        dataOut : out std_logic_vector(31 downto 0);

        writeToControlReg  : in std_logic;
        readFromControlReg : in std_logic;

        writeToStatusReg   : in std_logic;
        readFromStatusReg  : in std_logic;

        readFromFIFO       : in std_logic;
        writeToFIFO        : in std_logic;

        debugSignals         : in std_logic_vector(499 downto 0)
   );
end serialInterface;

architecture Behavioral of serialInterface is
    signal controlRegister     : std_logic_vector(31 downto 0);
    signal controlRegister_nxt : std_logic_vector(31 downto 0);

    signal statusRegister      : std_logic_vector(31 downto 0);
    signal statusRegister_nxt  : std_logic_vector(31 downto 0);

    signal dataOut_nxt               : std_logic_vector(31 downto 0);
    
    type FIFO is array (0 to 15) of std_logic_vector(7 downto 0);

    signal FIFOBufferReceive         : FIFO;
    signal FIFOBufferReceiveReadPtr  : unsigned(3 downto 0);
    signal FIFOBufferReceiveWritePtr : unsigned(3 downto 0);

    signal FIFOBufferSend            : FIFO;
    signal FIFOBufferSend_nxt        : FIFO;

    signal FIFOBufferSendReadPtr     : unsigned(3 downto 0);

    signal FIFOBufferSendWritePtr    : unsigned(3 downto 0);
    signal FIFOBufferSendWritePtr_nxt: unsigned(3 downto 0);
    
begin

    --handling writing and reading registers from outside
    seq: process(writeToControlReg, readFromControlReg, writeToStatusReg, readFromStatusReg, readFromFIFO,writeToFIFO)
    begin
        statusRegister_nxt <= statusRegister;
        controlRegister_nxt <= controlRegister;
        dataOut_nxt <= dataOut;
        FIFOBufferSend_nxt <= FIFOBufferSend; 
        FIFOBufferSendWritePtr_nxt <= FIFOBufferSendWritePtr;

        if writeToControlReg = '1' then
            controlRegister_nxt <= dataIn;
        end if;

        if writeToStatusReg = '1' then
            statusRegister_nxt <= dataIn;
        end if;

        if writeToFIFO = '1' then
            if (FIFOBufferSendWritePtr + 1) mod 16 /= FIFOBufferSendReadPtr then
                -- Write data to the FIFO
                FIFOBufferSend_nxt(to_integer(FIFOBufferSendWritePtr)) <= dataIn;
        
                -- Increment the write pointer
                FIFOBufferSendWritePtr_nxt <= (FIFOBufferSendWritePtr + 1) mod 16;
            end if;


        if readFromControlReg = '1' then
            dataOut_nxt <= controlRegister;
        elsif readFromStatusReg = '1' then
            dataOut_nxt <= statusRegister;
        end if;

    end process;



    --handling read and write operations regarding the controlRegister and the statusRegister
    process(clk, reset)
    begin
        if reset = '1' then
            controlRegister <= (others => '0');
            statusRegister <= (others => '0');
            FIFOBufferReceive <= (others => (others => '0'));
            FIFOBufferSend <= (others => (others => '0'));
        elsif rising_edge(clk) then
            statusRegister  <= statusRegister_nxt;
            controlRegister <= controlRegister_nxt;
            dataOut         <= dataOut_nxt;
            FIFOBufferSend  <= FIFOBufferSend_nxt;
        end if;
    end process;

end Behavioral;
