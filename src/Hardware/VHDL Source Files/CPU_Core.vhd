library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU_Core is
        Generic(
            numExternalInterrupts    : integer;
            numInterrupts            : integer;
            numCPU_CoreDebugSignals  : integer
        );
        Port (
            enable                  : in std_logic;
            hardwareReset           : in std_logic;
            clk                     : in std_logic;
            alteredClk              : in std_logic;
    
            programmingMode         : in std_logic;
    
            dataFromMem             : in std_logic_vector(31 downto 0);
            dataOut                 : out std_logic_vector(31 downto 0);
            addressOut              : out std_logic_vector(31 downto 0);
            
            memWriteReq             : out std_logic;
            memReadReq              : out std_logic;
            softwareReset           : out std_logic;
            memOpFinished           : in std_logic;
    
            --interupt vector table and interrupt priority register
            IVT                     : in std_logic_vector(numInterrupts*32-1 downto 0);
            IPR                     : in std_logic_vector(numInterrupts*3-1 downto 0);
    
            externalInterrupts      : in std_logic_vector(numExternalInterrupts-1 downto 0); --there are no internal interrupts so far
            externalInterruptsClr : out std_logic_vector(numExternalInterrupts-1 downto 0); 
    
            --debugging
            debug                   : out std_logic_vector(numCPU_CoreDebugSignals-1 downto 0)
        );
end CPU_Core;

architecture Behavioral of CPU_Core is
    component ALU is
        port (
            clk                  : in std_logic;
            reset                : in std_logic;
            enable               : in std_logic;
            alteredClk           : in std_logic;
            operand1             : in std_logic_vector(31 downto 0);
            operand2             : in std_logic_vector(31 downto 0);
    
            bitManipulationCode  : in std_logic_vector(1 downto 0);
            bitManipulationValue : in std_logic_vector(4 downto 0);
    
            opCode               : in std_logic_vector(3 downto 0);
            carryIn              : in std_logic;
            
            upperSel             : in std_logic;
    
            --outputs
            result               : out std_logic_vector(31 downto 0);
            flagsCPSR            : out std_logic_vector(3 downto 0);
            debug                : out std_logic_vector(67 downto 0)     
         );
    end component;

    component registerFile is
        port(
            enable           : in std_logic;
            reset            : in std_logic;
            clk              : in std_logic;
            alteredClk       : in std_logic;
    
            dataIn           : in std_logic_vector(31 downto 0);
            loadRegistersSel : in std_logic_vector(15 downto 0);
            dataOut          : out std_logic_vector(16 * 32-1 downto 0);
            createLink       : in std_logic
        );
    end component;

    component busManagement is
        Port ( 
            dataFromRegisters           : in std_logic_vector(16 * 32-1 downto 0);
            dataFromCU                  : in std_logic_vector(31 downto 0);
            dataFromALU                 : in std_logic_vector(31 downto 0);
            dataFromMem                 : in std_logic_vector(31 downto 0);
            bitManipulationValueFromCU  : in std_logic_vector(4 downto 0);
    
            operand1                    : out std_logic_vector(31 downto 0);
            operand2                    : out std_logic_vector(31 downto 0);
            dataToMem                   : out std_logic_vector(31 downto 0);
            bitManipulationValOut       : out std_logic_vector(4 downto 0);
    
            operand1Sel                 : in std_logic_vector(4 downto 0);
            operand2Sel                 : in std_logic_vector(4 downto 0); 
            dataToMemSel                : in std_logic_vector(3 downto 0);
            bitManipulationValSel       : in std_logic_vector(4 downto 0);
    
    
            dataToRegisters             : out std_logic_vector(31 downto 0);
            dataToRegistersSel          : in std_logic
        );
    end component;

    component coreInterruptController is
        Generic(
            numInterrupts : integer
          );
        Port (
            clk                     : in std_logic;
            interrupts              : in std_logic_vector(numInterrupts-1 downto 0);
        
            IVT_in                  : in std_logic_vector(32 * numInterrupts - 1 downto 0);
            IPR_in                  : in std_logic_vector(3 * numInterrupts - 1 downto 0);
            
            interruptIndex          : out std_logic_vector(7 downto 0);
            interruptHandlerAddress : out std_logic_vector(31 downto 0)
           );
    end component;

    component controlUnit is
    Generic(
        numInterrupts : integer := 10
    );

    Port(
        enable                  : in std_logic;
        hardwareReset           : in std_logic;
        softwareReset           : out std_logic;
        clk                     : in std_logic;
        alteredClk              : in std_logic;

        --control signals generated by CU
        operand1Sel             : out std_logic_vector(4 downto 0);
        operand2Sel             : out std_logic_vector(4 downto 0); 
        dataToMemSel            : out std_logic_vector(3 downto 0);

        dataToRegistersSel      : out std_logic;
        loadRegistersSel        : out std_logic_vector(15 downto 0);
        createLink              : out std_logic;
        bitManipulationValSel   : out std_logic_vector(4 downto 0);

        bitManipulationCode     : out std_logic_vector(1 downto 0);
        bitManipulationValue    : out std_logic_vector(4 downto 0);

        ALU_opCode              : out std_logic_vector(3 downto 0);
        carryIn                 : out std_logic;
        upperSel                : out std_logic;

        memWriteReq             : out std_logic;
        memReadReq              : out std_logic;

        interruptsClr           : out std_logic_vector(numInterrupts-3 downto 0);
        dataToALU               : out std_logic_vector(31 downto 0);

        ALU_En                  : out std_logic;
        
        --Interrupt signals
        interrupts              : out std_logic_vector(1 downto 0);
          
        --signals controlling the CU
        PC                      : in std_logic_vector(31 downto 0);
        programmingMode         : in std_logic;
        InterruptHandlerAddress : in std_logic_vector(31 downto 0);
        interruptIndex          : in std_logic_vector(7 downto 0);
        dataFromMem             : in std_logic_vector(31 downto 0);
        dataFromALU             : in std_logic_vector(31 downto 0);
        flagsFromALU            : in std_logic_vector(3 downto 0);
        memOpFinished           : in std_logic;
        --debug signals
        debug : out std_logic_vector(38 downto 0)
    );
    end component;

    --internal signals
    --ALU
    signal ALU_En   : std_logic;
    signal operand1 : std_logic_vector(31 downto 0);
    signal operand2 : std_logic_vector(31 downto 0);
    signal bitManipulationCode : std_logic_vector(1 downto 0);
    signal bitManipulationValue : std_logic_vector(4 downto 0);
    signal ALU_opCode : std_logic_vector(3 downto 0);
    signal carryIn : std_logic;
    signal upperSel : std_logic;
    
    --register file
    signal dataToRegisters  : std_logic_vector(31 downto 0);
    signal loadRegistersSel : std_logic_vector(15 downto 0);
    signal createLink       : std_logic;

    --bus management
    signal dataFromRegisters            : std_logic_vector(16 * 32-1 downto 0);
    signal dataFromCU                   : std_logic_vector(31 downto 0);
    signal dataFromALU                  : std_logic_vector(31 downto 0);
    signal operand1Sel                  : std_logic_vector(4 downto 0);
    signal operand2Sel                  : std_logic_vector(4 downto 0); 
    signal dataToMemSel                 : std_logic_vector(3 downto 0);
    signal dataToRegistersSel           : std_logic;
    signal bitManipulationValSel        : std_logic_vector(4 downto 0);
    signal bitManipulationValueFromCU   : std_logic_vector(4 downto 0);

    --interrupt controller
    --signal internalInterrupts  --should be uncommented if any internal interrupts are being used
    signal interrupts               : std_logic_vector(numInterrupts-1 downto 0);
    signal interruptHandlerAddress  : std_logic_vector(31 downto 0);
    signal interruptIndex           : std_logic_vector(7 downto 0);
    signal interruptsClr            : std_logic_vector(numInterrupts-3 downto 0); 

    --CU
    signal ALU_flags  : std_logic_vector(3 downto 0);
    signal ALU_EnFromCU : std_logic;
    signal CU_interrupts : std_logic_vector(1 downto 0);
        
    --debug signals
    signal ALU_debug : std_logic_vector(67 downto 0);
    signal CU_debug  : std_logic_vector(38 downto 0);

    --others
    signal reset               : std_logic;
    signal softwareResetFromCu : std_logic;
    
    --output signals
    signal dataToMem           : std_logic_vector(31 downto 0);
    signal CU_memWriteReq      : std_logic;
    signal CU_memReadReq       : std_logic;   

begin
    --reset signals
    reset <= hardwareReset or softwareResetFromCu;
    softwareReset <= softwareResetFromCu;

    --enable signals
    ALU_En <= enable and ALU_EnFromCU;

    --interrupts
    interrupts              <= externalInterrupts & CU_interrupts;
    externalInterruptsClr   <= interruptsClr(numInterrupts - 3 downto numInterrupts - 2 - numExternalInterrupts) ;
    
    --assigning output signals
    memWriteReq <= CU_memWriteReq;
    memReadReq <= CU_memReadReq;
    dataOut <= dataToMem;
    addressOut <= dataFromALU;
    
    ---             32 Bit        4 Bit       68 Bit      32 Bit       512 Bit             32 Bit     32 Bit     32 Bit      32 Bit        5 Bit         5 Bit         1 Bit                16 Bit             2 Bit                 5 Bit                  3 Bit        1 Bit     1 Bit      1 Bit                 numInterrupts Bit 38 Bit     1Bit             1 Bit        
    debug        <= dataFromALU & ALU_flags & ALU_debug & dataFromCU & dataFromRegisters & operand1 & operand2 & dataToMem & dataFromMem & operand1Sel & operand2Sel & dataToRegistersSel & loadRegistersSel & bitManipulationCode & bitManipulationValue & ALU_opCode & carryIn & upperSel & softwareResetFromCu & "0000000000" & CU_debug & CU_memWriteReq & CU_memReadReq;
   --debug <= (others => '0');

    ALU_inst : ALU
        port map(
            --inputs
            clk                     => clk,
            reset                   => reset,
            enable                  => ALU_En,
            alteredClk              => alteredClk,
            operand1                => operand1,          
            operand2                => operand2,             
    
            bitManipulationCode     => bitManipulationCode,
            bitManipulationValue    => bitManipulationValue,
    
            opCode                  => ALU_opCode,
            carryIn                 => carryIn,
            
            upperSel                => upperSel,        
    
            --outputs
            result                  => dataFromALU,
            flagsCPSR               => ALU_flags,
            debug                   => ALU_debug
        );

    RegisterFile_inst : registerFile
        port map(
            --inputs
            enable              => enable,     
            reset               => reset,
            clk                 => clk,
            alteredClk          => alteredClk,
    
            dataIn              => dataToRegisters,
            loadRegistersSel    => loadRegistersSel,
            createLink          => createLink,
            --output
            dataOut             => dataFromRegisters
        );

    busManagement_inst : busManagement
        port map(
            --inputs    
            dataFromRegisters           => dataFromRegisters,
            dataFromCU                  => dataFromCU,
            dataFromALU                 => dataFromALU,
            dataFromMem                 => dataFromMeM,
            bitManipulationValueFromCU  => bitManipulationValueFromCU,
      
            operand1Sel                 => operand1Sel,
            operand2Sel                 => operand2Sel,
            dataToMemSel                => dataToMemSel,
            bitManipulationValSel       => bitManipulationValSel,

            dataToRegistersSel          => dataToRegistersSel,

            --outputs
            operand1                    => operand1,            
            operand2                    => operand2,
            dataToMem                   => dataToMem,
            dataToRegisters             => dataToRegisters,
            bitManipulationValOut       => bitManipulationValue
        );

    interruptController_inst : coreInterruptController
        generic map(
            numInterrupts => numInterrupts
        )
        port map(
            --inputs
            clk                     => clk,
            interrupts              => interrupts,
            IVT_in                  => IVT, 
            IPR_in                  => IPR,
            --output
            interruptHandlerAddress => interruptHandlerAddress,
            interruptIndex          => interruptIndex
        );

    CU : controlUnit
        generic map(
            numInterrupts => numInterrupts
        )
        port map(
            --inputs
            enable                  => enable,
            hardwareReset           => hardwareReset,
            clk                     => clk,
            alteredClk              => alteredClk,

            programmingMode         => programmingMode,
            interruptHandlerAddress => interruptHandlerAddress,
            interruptIndex          => interruptIndex,
            dataFromMem             => dataFromMem,
            dataFromALU             => dataFromALU,
            flagsFromALU            => ALU_flags,
            memOpFinished           => memOpFinished,
            PC                      => dataFromRegisters(16 * 32-1 downto 15*32),

            --outputs
            operand1Sel             => operand1Sel,
            operand2Sel             => operand2Sel,
            dataToMemSel            => dataToMemSel,
    
            dataToRegistersSel      => dataToRegistersSel,
            createLink              => createLink,
            loadRegistersSel        => loadRegistersSel,
            bitManipulationValSel   => bitManipulationValSel,
    
            bitManipulationCode     => bitManipulationCode,
            bitManipulationValue    => bitManipulationValueFromCU,
    
            ALU_opCode              => ALU_opCode,
            ALU_En                  => ALU_EnFromCU,
            carryIn                 => carryIn,
            upperSel                => upperSel,

            memWriteReq             => CU_memWriteReq,
            memReadReq              => CU_memReadReq,

            softwareReset           => softwareResetFromCu,
            interruptsClr           => interruptsClr,

            dataToALU               => dataFromCU,
            
            interrupts              => CU_interrupts,
              
            debug                   => CU_debug
        );
        

end Behavioral;
