
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental /home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VivadoProject/MiPro-XG-V1/MiPro-XG-V1.srcs/utils_1/imports/synth_1/top.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2|
z/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VivadoProject/MiPro-XG-V1/MiPro-XG-V1.srcs/utils_1/imports/synth_1/top.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
^
Command: %s
53*	vivadotcl2-
+synth_design -top top -part xc7a35tcpg236-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xc7a35tZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xc7a35tZ17-349h px� 
D
Loading part %s157*device2
xc7a35tcpg236-1Z21-403h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
7Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
N
#Helper process launched with PID %s4824*oasys2
17229Z8-7075h px� 
�
%s*synth2�
�Starting RTL Elaboration : Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 1891.207 ; gain = 426.801 ; free physical = 5855 ; free virtual = 14574
h px� 
�
synthesizing module '%s'638*oasys2
top2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
688@Z8-638h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 20.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
clockGenerator2O
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
72
internalClockGenerator_inst2
clockGenerator2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
3578@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
clockGenerator2Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
218@Z8-638h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 20.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 20.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
P
%s
*synth28
6	Parameter DIVCLK_DIVIDE bound to: 1 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
MMCME2_BASE2@
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2
847082
	mmcm_inst2
MMCME2_BASE2Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
468@Z8-3491h px� 
�
synthesizing module '%s'%s4497*oasys2
MMCME2_BASE2
 2B
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2	
847088@Z8-6157h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 20.000000 - type: double 
h p
x
� 
P
%s
*synth28
6	Parameter DIVCLK_DIVIDE bound to: 1 - type: integer 
h p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
MMCME2_BASE2
 2
02
12B
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2	
847088@Z8-6155h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
clockGenerator2
02
12Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
218@Z8-256h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 40.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
clockGenerator2O
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
72
VGA_ClkGenerator_inst2
clockGenerator2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
3718@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2 
clockGenerator__parameterized12Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
218@Z8-638h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 40.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 40.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
P
%s
*synth28
6	Parameter DIVCLK_DIVIDE bound to: 1 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
MMCME2_BASE2@
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2
847082
	mmcm_inst2
MMCME2_BASE2Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
468@Z8-3491h px� 
�
synthesizing module '%s'%s4497*oasys2
MMCME2_BASE__parameterized12
 2B
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2	
847088@Z8-6157h px� 
Y
%s
*synth2A
?	Parameter CLKFBOUT_MULT_F bound to: 10.000000 - type: double 
h p
x
� 
W
%s
*synth2?
=	Parameter CLKIN1_PERIOD bound to: 10.000000 - type: double 
h p
x
� 
Z
%s
*synth2B
@	Parameter CLKOUT0_DIVIDE_F bound to: 40.000000 - type: double 
h p
x
� 
P
%s
*synth28
6	Parameter DIVCLK_DIVIDE bound to: 1 - type: integer 
h p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
MMCME2_BASE__parameterized12
 2
02
12B
>/home/jonas/Xilinx/Vivado/2024.2/scripts/rt/data/unisim_comp.v2	
847088@Z8-6155h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2 
clockGenerator__parameterized12
02
12Q
M/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/clockGenerator.vhd2
218@Z8-256h px� 
X
%s
*synth2@
>	Parameter numExternalInterrupts bound to: 6 - type: integer 
h p
x
� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2

CPU_Core2N
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
42
CPU_Core_inst2

CPU_Core2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
3848@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2

CPU_Core2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
398@Z8-638h px� 
X
%s
*synth2@
>	Parameter numExternalInterrupts bound to: 6 - type: integer 
h p
x
� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
ALU2I
G/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/ALU.vhd2
52

ALU_inst2
ALU2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
2378@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
ALU2K
G/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/ALU.vhd2
298@Z8-638h px� 
�
default block is never used226*oasys2K
G/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/ALU.vhd2
778@Z8-226h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
ALU2
02
12K
G/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/ALU.vhd2
298@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
registerFile2R
P/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/registerFile.vhd2
122
RegisterFile_inst2
registerFile2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
2618@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
registerFile2T
P/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/registerFile.vhd2
278@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
registerFile2
02
12T
P/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/registerFile.vhd2
278@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
busManagement2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/busManagement.vhd2
52
busManagement_inst2
busManagement2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
2768@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
busManagement2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/busManagement.vhd2
278@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
busManagement2
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/busManagement.vhd2
278@Z8-256h px� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
coreInterruptController2]
[/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/coreInterruptController.vhd2
42
interruptController_inst2
coreInterruptController2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
3008@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
coreInterruptController2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/coreInterruptController.vhd2
208@Z8-638h px� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
coreInterruptController2
02
12_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/coreInterruptController.vhd2
208@Z8-256h px� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
controlUnit2Q
O/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/controlUnit.vhd2
72
CU2
controlUnit2P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
3158@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
controlUnit2S
O/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/controlUnit.vhd2
618@Z8-638h px� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
controlUnit2
02
12S
O/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/controlUnit.vhd2
618@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2

CPU_Core2
02
12P
L/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/CORE/CPU_Core.vhd2
398@Z8-256h px� 
d
%s
*synth2L
J	Parameter defaultSerialInterfacePrescaler bound to: 434 - type: integer 
h p
x
� 
U
%s
*synth2=
;	Parameter numDigitalIO_Pins bound to: 16 - type: integer 
h p
x
� 
Z
%s
*synth2B
@	Parameter numSevenSegmentDisplays bound to: 4 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
e
%s
*synth2M
K	Parameter individualSevenSegmentDisplayControll bound to: 0 - type: bool 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 432 - type: integer 
h p
x
� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
U
%s
*synth2=
;	Parameter numMMIO_Interrupts bound to: 5 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
memoryMapping2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
82
memoryMapping_inst2
memoryMapping2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
4138@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
memoryMapping2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
608@Z8-638h px� 
d
%s
*synth2L
J	Parameter defaultSerialInterfacePrescaler bound to: 434 - type: integer 
h p
x
� 
U
%s
*synth2=
;	Parameter numDigitalIO_Pins bound to: 16 - type: integer 
h p
x
� 
Z
%s
*synth2B
@	Parameter numSevenSegmentDisplays bound to: 4 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
e
%s
*synth2M
K	Parameter individualSevenSegmentDisplayControll bound to: 0 - type: bool 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 432 - type: integer 
h p
x
� 
P
%s
*synth28
6	Parameter numInterrupts bound to: 8 - type: integer 
h p
x
� 
U
%s
*synth2=
;	Parameter numMMIO_Interrupts bound to: 5 - type: integer 
h p
x
� 
Z
%s
*synth2B
@	Parameter numSevenSegmentDisplays bound to: 4 - type: integer 
h p
x
� 
e
%s
*synth2M
K	Parameter individualSevenSegmentDisplayControll bound to: 0 - type: bool 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
sevenSegmentDisplays2Z
X/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/sevenSegmentDisplays.vhd2
172
IO_SevenSegmentDisplay_inst2
sevenSegmentDisplays2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5048@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
sevenSegmentDisplays2\
X/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/sevenSegmentDisplays.vhd2
348@Z8-638h px� 
Z
%s
*synth2B
@	Parameter numSevenSegmentDisplays bound to: 4 - type: integer 
h p
x
� 
e
%s
*synth2M
K	Parameter individualSevenSegmentDisplayControll bound to: 0 - type: bool 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
sevenSegmentDisplays2
02
12\
X/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/sevenSegmentDisplays.vhd2
348@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
clockController2U
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/clockController.vhd2
92
clockController_inst2
clockController2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5208@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
clockController2W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/clockController.vhd2
228@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
clockController2
02
12W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/clockController.vhd2
228@Z8-256h px� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 432 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
serialInterface2U
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/serialInterface.vhd2
42
serialInterface_inst2
serialInterface2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5348@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
serialInterface2W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/serialInterface.vhd2
318@Z8-638h px� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 868 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 432 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
serialInterface2
02
12W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/serialInterface.vhd2
318@Z8-256h px� 
M
%s
*synth25
3	Parameter countWidth bound to: 8 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
hardwareTimer2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
152
hardwareTimer0_inst2
hardwareTimer2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5598@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
hardwareTimer2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-638h px� 
M
%s
*synth25
3	Parameter countWidth bound to: 8 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
hardwareTimer2
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-256h px� 
N
%s
*synth26
4	Parameter countWidth bound to: 16 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
hardwareTimer2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
152
hardwareTimer1_inst2
hardwareTimer2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5788@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
hardwareTimer__parameterized12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-638h px� 
N
%s
*synth26
4	Parameter countWidth bound to: 16 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
hardwareTimer__parameterized12
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-256h px� 
N
%s
*synth26
4	Parameter countWidth bound to: 16 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
hardwareTimer2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
152
hardwareTimer2_inst2
hardwareTimer2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
5978@Z8-3491h px� 
N
%s
*synth26
4	Parameter countWidth bound to: 32 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
hardwareTimer2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
152
hardwareTimer3_inst2
hardwareTimer2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6168@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
hardwareTimer__parameterized32U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-638h px� 
N
%s
*synth26
4	Parameter countWidth bound to: 32 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
hardwareTimer__parameterized32
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/hardwareTimer.vhd2
388@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
198@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
IO_PinDigital2
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
198@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_PinDigital2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/IO_PinDigital.vhd2
42
IO_PinDigital_inst2
IO_PinDigital2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
6368@Z8-3491h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
memoryMapping2
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/MMIO/memoryMapping.vhd2
608@Z8-256h px� 
M
%s
*synth25
3	Parameter ramSize bound to: 8188 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
RAM2H
F/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/RAM.vhd2
52

ram_inst2
RAM2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
4548@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
RAM2J
F/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/RAM.vhd2
218@Z8-638h px� 
M
%s
*synth25
3	Parameter ramSize bound to: 8188 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
RAM2
02
12J
F/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/RAM.vhd2
218@Z8-256h px� 
M
%s
*synth25
3	Parameter memSize bound to: 8188 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
addressDecoder2S
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/addressDecoder.vhd2
102
addressDecoder_inst2
addressDecoder2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
4698@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
addressDecoder2U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/addressDecoder.vhd2
458@Z8-638h px� 
M
%s
*synth25
3	Parameter memSize bound to: 8188 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
addressDecoder2
02
12U
Q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/RAM/addressDecoder.vhd2
458@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
VGA_Controller2X
V/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/VGA_Controller.vhd2
52
VGA_Controller_inst2
VGA_Controller2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
4988@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
VGA_Controller2Z
V/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/VGA_Controller.vhd2
258@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
VGA_Controller2
02
12Z
V/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/VGA_Controller.vhd2
258@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
imageBuffer2U
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/imageBuffer.vhd2
102
imageBuffer_inst2
imageBuffer2F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
5148@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
imageBuffer2W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/imageBuffer.vhd2
308@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
imageBuffer2
02
12W
S/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/GRAPHICS/imageBuffer.vhd2
308@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
top2
02
12F
B/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VHDL_Files/top.vhd2
688@Z8-256h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[31]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[30]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[29]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[28]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[27]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[26]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[25]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[24]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[23]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[22]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[21]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[20]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[19]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[18]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[17]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[16]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[15]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[14]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[13]2
RAMZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[31]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[30]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[29]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[28]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[27]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[26]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[25]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[24]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[23]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[22]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[21]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[20]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[19]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[18]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[17]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[16]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[15]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[14]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[13]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[12]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[11]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[10]2
controlUnitZ8-7129h px� 
n
9Port %s in module %s is either unconnected or has no load4866*oasys2

upperSel2
ALUZ8-7129h px� 
�
%s*synth2�
�Finished RTL Elaboration : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 2024.176 ; gain = 559.770 ; free physical = 5693 ; free virtual = 14417
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 2039.020 ; gain = 574.613 ; free physical = 5695 ; free virtual = 14418
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 2039.020 ; gain = 574.613 ; free physical = 5695 ; free virtual = 14418
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.112

00:00:00.12

2041.9882
0.0002
56872
14410Z17-722h px� 
S
-Analyzing %s Unisim elements for replacement
17*netlist2
2Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
Parsing XDC File [%s]
179*designutils2O
K/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/constraints/constraints.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2O
K/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/constraints/constraints.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2M
K/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/constraints/constraints.xdc2
.Xil/top_propImpl.xdcZ1-236h px� 
8
Deriving generated clocks
2*timingZ38-2h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2178.7702
0.0002
56572
14380Z17-722h px� 
�
!Unisim Transformation Summary:
%s111*project2V
T  A total of 2 instances were transformed.
  MMCME2_BASE => MMCME2_ADV: 2 instances
Z1-111h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
 Constraint Validation Runtime : 2
00:00:00.012
00:00:00.012

2178.7702
0.0002
56572
14380Z17-722h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:11 ; elapsed = 00:00:11 . Memory (MB): peak = 2178.770 ; gain = 714.363 ; free physical = 5652 ; free virtual = 14376
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Loading part: xc7a35tcpg236-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:11 ; elapsed = 00:00:11 . Memory (MB): peak = 2186.773 ; gain = 722.367 ; free physical = 5652 ; free virtual = 14376
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:11 ; elapsed = 00:00:11 . Memory (MB): peak = 2186.773 ; gain = 722.367 ; free physical = 5652 ; free virtual = 14376
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
s
3inferred FSM for state register '%s' in module '%s'802*oasys2
procState_reg2
controlUnitZ8-802h px� 
z
3inferred FSM for state register '%s' in module '%s'802*oasys2
receiveState_reg2
serialInterfaceZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                 iSTATE1 |                              000 |                              000
h p
x
� 
y
%s
*synth2a
_                 iSTATE5 |                              001 |                              001
h p
x
� 
y
%s
*synth2a
_                 iSTATE0 |                              010 |                              010
h p
x
� 
y
%s
*synth2a
_                  iSTATE |                              011 |                              011
h p
x
� 
y
%s
*synth2a
_                 iSTATE2 |                              100 |                              100
h p
x
� 
y
%s
*synth2a
_                 iSTATE3 |                              101 |                              101
h p
x
� 
y
%s
*synth2a
_                 iSTATE4 |                              110 |                              110
h p
x
� 

%s
*synth2
*
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
procState_reg2

sequential2
controlUnitZ8-3354h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_            receive_idle |                              000 |                              000
h p
x
� 
y
%s
*synth2a
_       receive_start_bit |                              001 |                              001
h p
x
� 
y
%s
*synth2a
_            receive_data |                              010 |                              010
h p
x
� 
y
%s
*synth2a
_      receive_parity_bit |                              011 |                              011
h p
x
� 
y
%s
*synth2a
_        receive_stop_bit |                              100 |                              100
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
receiveState_reg2

sequential2
serialInterfaceZ8-3354h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:14 ; elapsed = 00:00:14 . Memory (MB): peak = 2186.773 ; gain = 722.367 ; free physical = 5683 ; free virtual = 14408
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   3 Input   33 Bit       Adders := 4     
h p
x
� 
F
%s
*synth2.
,	   3 Input   32 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   4 Input   32 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input   32 Bit       Adders := 8     
h p
x
� 
F
%s
*synth2.
,	   2 Input   31 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   20 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   16 Bit       Adders := 4     
h p
x
� 
F
%s
*synth2.
,	   2 Input   15 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   13 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    6 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    5 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit       Adders := 13    
h p
x
� 
F
%s
*synth2.
,	   3 Input    4 Bit       Adders := 2     
h p
x
� 
F
%s
*synth2.
,	   8 Input    3 Bit       Adders := 1     
h p
x
� 
&
%s
*synth2
+---XORs : 
h p
x
� 
H
%s
*synth20
.	   2 Input     32 Bit         XORs := 1     
h p
x
� 
H
%s
*synth20
.	   2 Input      1 Bit         XORs := 3     
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	             1300 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	              128 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               98 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               66 Bit    Registers := 2     
h p
x
� 
H
%s
*synth20
.	               50 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               32 Bit    Registers := 50    
h p
x
� 
H
%s
*synth20
.	               31 Bit    Registers := 2     
h p
x
� 
H
%s
*synth20
.	               26 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               16 Bit    Registers := 7     
h p
x
� 
H
%s
*synth20
.	               13 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               11 Bit    Registers := 16    
h p
x
� 
H
%s
*synth20
.	               10 Bit    Registers := 6     
h p
x
� 
H
%s
*synth20
.	                9 Bit    Registers := 16    
h p
x
� 
H
%s
*synth20
.	                8 Bit    Registers := 21    
h p
x
� 
H
%s
*synth20
.	                6 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                5 Bit    Registers := 6     
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 12    
h p
x
� 
H
%s
*synth20
.	                3 Bit    Registers := 8     
h p
x
� 
H
%s
*synth20
.	                2 Bit    Registers := 11    
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 34    
h p
x
� 
&
%s
*synth2
+---RAMs : 
h p
x
� 
Z
%s
*synth2B
@	            1024K Bit	(32768 X 32 bit)          RAMs := 1     
h p
x
� 
Y
%s
*synth2A
?	             255K Bit	(8188 X 32 bit)          RAMs := 1     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   2 Input  128 Bit        Muxes := 4     
h p
x
� 
F
%s
*synth2.
,	  46 Input  128 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input   32 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   2 Input   32 Bit        Muxes := 62    
h p
x
� 
F
%s
*synth2.
,	   7 Input   32 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   6 Input   32 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   31 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   5 Input   31 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   20 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input   19 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   16 Bit        Muxes := 12    
h p
x
� 
F
%s
*synth2.
,	   8 Input   16 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input   16 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	  31 Input   16 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input   13 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input   12 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    9 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   5 Input    8 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input    8 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   7 Input    6 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    6 Bit        Muxes := 6     
h p
x
� 
F
%s
*synth2.
,	   4 Input    6 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input    6 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    5 Bit        Muxes := 51    
h p
x
� 
F
%s
*synth2.
,	   7 Input    5 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input    5 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   6 Input    5 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit        Muxes := 24    
h p
x
� 
F
%s
*synth2.
,	   3 Input    4 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   4 Input    4 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   7 Input    4 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   6 Input    4 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   5 Input    4 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    3 Bit        Muxes := 11    
h p
x
� 
F
%s
*synth2.
,	   5 Input    3 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   8 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	  38 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   6 Input    2 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 183   
h p
x
� 
F
%s
*synth2.
,	   7 Input    1 Bit        Muxes := 12    
h p
x
� 
F
%s
*synth2.
,	   4 Input    1 Bit        Muxes := 99    
h p
x
� 
F
%s
*synth2.
,	   3 Input    1 Bit        Muxes := 7     
h p
x
� 
F
%s
*synth2.
,	   6 Input    1 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   5 Input    1 Bit        Muxes := 35    
h p
x
� 
F
%s
*synth2.
,	   8 Input    1 Bit        Muxes := 2     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
%s
*synth2X
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
V
%s
*synth2>
<DSP Report: Generating DSP p_1_out, operation Mode is: A*B.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_0_out is absorbed into DSP p_1_out.
h p
x
� 
V
%s
*synth2>
<DSP Report: Generating DSP p_1_out, operation Mode is: A*B.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_0_out is absorbed into DSP p_1_out.
h p
x
� 
a
%s
*synth2I
GDSP Report: Generating DSP p_1_out, operation Mode is: (PCIN>>17)+A*B.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_1_out is absorbed into DSP p_1_out.
h p
x
� 
U
%s
*synth2=
;DSP Report: operator p_0_out is absorbed into DSP p_1_out.
h p
x
� 
x
%s
*synth2`
^DSP Report: Generating DSP VGA_Controller_inst/pixelCount0, operation Mode is: C+A*(B:0x280).
h p
x
� 
�
%s
*synth2m
kDSP Report: operator VGA_Controller_inst/pixelCount0 is absorbed into DSP VGA_Controller_inst/pixelCount0.
h p
x
� 
�
%s
*synth2h
fDSP Report: operator VGA_Controller_inst/multOp is absorbed into DSP VGA_Controller_inst/pixelCount0.
h p
x
� 
i
+design %s has port %s driven by constant %s3447*oasys2
top2
VGA_Green[2]2
0Z8-3917h px� 
i
+design %s has port %s driven by constant %s3447*oasys2
top2
VGA_Green[1]2
0Z8-3917h px� 
i
+design %s has port %s driven by constant %s3447*oasys2
top2
VGA_Green[0]2
0Z8-3917h px� 
g
+design %s has port %s driven by constant %s3447*oasys2
top2

VGA_Red[0]2
0Z8-3917h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[31]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[30]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[29]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[28]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[27]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[26]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[25]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[24]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[23]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[22]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[21]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[20]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[19]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[18]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[17]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[16]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[15]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[14]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[13]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[12]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[11]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
dataFromALU[10]2
controlUnitZ8-7129h px� 
n
9Port %s in module %s is either unconnected or has no load4866*oasys2

upperSel2
ALUZ8-7129h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:46 ; elapsed = 00:00:47 . Memory (MB): peak = 2269.422 ; gain = 805.016 ; free physical = 5587 ; free virtual = 14329
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
U
%s
*synth2=
; Sort Area is  p_1_out_0 : 0 0 : 2701 4456 : Used 1 time 0
h p
x
� 
U
%s
*synth2=
; Sort Area is  p_1_out_0 : 0 1 : 1755 4456 : Used 1 time 0
h p
x
� 
U
%s
*synth2=
; Sort Area is  p_1_out_3 : 0 0 : 1755 1755 : Used 1 time 0
h p
x
� 
k
%s
*synth2S
Q Sort Area is  VGA_Controller_inst/pixelCount0_5 : 0 0 : 115 115 : Used 1 time 0
h p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
h px� 
l
%s*synth2T
R---------------------------------------------------------------------------------
h px� 
;
%s*synth2#
!
ROM: Preliminary Mapping Report
h px� 
b
%s*synth2J
H+---------------------+--------------+---------------+----------------+
h px� 
c
%s*synth2K
I|Module Name          | RTL Object   | Depth x Width | Implemented As | 
h px� 
b
%s*synth2J
H+---------------------+--------------+---------------+----------------+
h px� 
c
%s*synth2K
I|sevenSegmentDisplays | displays[0]0 | 32x7          | LUT            | 
h px� 
c
%s*synth2K
I|sevenSegmentDisplays | displays[0]0 | 32x7          | LUT            | 
h px� 
c
%s*synth2K
I|sevenSegmentDisplays | displays[0]0 | 32x7          | LUT            | 
h px� 
c
%s*synth2K
I+---------------------+--------------+---------------+----------------+

h px� 
R
%s*synth2:
8
Block RAM: Preliminary Mapping Report (see note below)
h px� 
�
%s*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h px� 
�
%s*synth2�
�|Module Name | RTL Object                       | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
h px� 
�
%s*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h px� 
�
%s*synth2�
�|top         | ram_inst/ram_reg                 | 7 K x 32(READ_FIRST)   | W | R |                        |   |   | Port A           | 0      | 8      | 
h px� 
�
%s*synth2�
�|top         | imageBuffer_inst/framebuffer_reg | 32 K x 32(READ_FIRST)  | W | R | 32 K x 32(WRITE_FIRST) |   | R | Port A and B     | 0      | 32     | 
h px� 
�
%s*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

h px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
h px� 
v
%s*synth2^
\
DSP: Preliminary Mapping Report (see note below. The ' indicates corresponding REG is set)
h px� 
�
%s*synth2�
�+---------------+----------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
h px� 
�
%s*synth2�
�|Module Name    | DSP Mapping    | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
h px� 
�
%s*synth2�
�+---------------+----------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
h px� 
�
%s*synth2�
�|ALU            | A*B            | 15     | 15     | -      | -      | 15     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h px� 
�
%s*synth2�
�|ALU            | A*B            | 18     | 18     | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h px� 
�
%s*synth2�
�|ALU            | (PCIN>>17)+A*B | 15     | 15     | -      | -      | 15     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h px� 
�
%s*synth2�
�|VGA_Controller | C+A*(B:0x280)  | 10     | 10     | 10     | -      | 19     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
h px� 
�
%s*synth2�
�+---------------+----------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

h px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the DSPs inferred at the current stage of the synthesis flow. Some DSP may be reimplemented as non DSP primitives later in the synthesis flow. Multiple instantiated DSPs are reported only once.
h px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
h px� 
l
%s*synth2T
R---------------------------------------------------------------------------------
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:51 ; elapsed = 00:00:52 . Memory (MB): peak = 2274.422 ; gain = 810.016 ; free physical = 5583 ; free virtual = 14322
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:01:00 ; elapsed = 00:01:01 . Memory (MB): peak = 2407.289 ; gain = 942.883 ; free physical = 5463 ; free virtual = 14202
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!
Block RAM: Final Mapping Report
h p
x
� 
�
%s
*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h p
x
� 
�
%s
*synth2�
�|Module Name | RTL Object                       | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
h p
x
� 
�
%s
*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h p
x
� 
�
%s
*synth2�
�|top         | ram_inst/ram_reg                 | 7 K x 32(READ_FIRST)   | W | R |                        |   |   | Port A           | 0      | 8      | 
h p
x
� 
�
%s
*synth2�
�|top         | imageBuffer_inst/framebuffer_reg | 32 K x 32(READ_FIRST)  | W | R | 32 K x 32(WRITE_FIRST) |   | R | Port A and B     | 0      | 32     | 
h p
x
� 
�
%s
*synth2�
�+------------+----------------------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

h p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_02
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_12
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_22
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_32
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_42
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_52
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_62
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2
ram_inst/ram_reg_72
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_02
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_02
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_12
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_12
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_22
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_22
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_32
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_32
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_42
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_42
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_52
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_52
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_62
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_62
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_72
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_72
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_82
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_82
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_92
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2&
$imageBuffer_inst/framebuffer_reg_0_92
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_102
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_102
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_112
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_112
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_122
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_122
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_132
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_132
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_142
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_142
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_152
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_152
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_162
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_162
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_172
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_172
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_182
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_182
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_192
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_192
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_202
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_202
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_212
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_212
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_222
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_222
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_232
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_232
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_242
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_242
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_252
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_252
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_262
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_262
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_272
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_272
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_282
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_282
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_292
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_292
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_302
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_302
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_312
BlockZ8-7052h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the ram block. Providing additional output register may help in improving timing.
4799*oasys2'
%imageBuffer_inst/framebuffer_reg_0_312
BlockZ8-7052h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:01:02 ; elapsed = 00:01:04 . Memory (MB): peak = 2453.289 ; gain = 988.883 ; free physical = 5444 ; free virtual = 14179
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:01:05 ; elapsed = 00:01:07 . Memory (MB): peak = 2498.102 ; gain = 1033.695 ; free physical = 5417 ; free virtual = 14153
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:01:05 ; elapsed = 00:01:07 . Memory (MB): peak = 2498.102 ; gain = 1033.695 ; free physical = 5417 ; free virtual = 14153
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:01:06 ; elapsed = 00:01:07 . Memory (MB): peak = 2498.102 ; gain = 1033.695 ; free physical = 5412 ; free virtual = 14147
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:01:06 ; elapsed = 00:01:07 . Memory (MB): peak = 2498.102 ; gain = 1033.695 ; free physical = 5412 ; free virtual = 14147
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:01:06 ; elapsed = 00:01:07 . Memory (MB): peak = 2506.039 ; gain = 1041.633 ; free physical = 5411 ; free virtual = 14147
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:01:06 ; elapsed = 00:01:07 . Memory (MB): peak = 2506.039 ; gain = 1041.633 ; free physical = 5411 ; free virtual = 14147
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
W
%s
*synth2?
=
DSP Final Report (the ' indicates corresponding REG is set)
h p
x
� 
�
%s
*synth2�
�+---------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
h p
x
� 
�
%s
*synth2�
�|Module Name    | DSP Mapping  | A Size | B Size | C Size | D Size | P Size | AREG | BREG | CREG | DREG | ADREG | MREG | PREG | 
h p
x
� 
�
%s
*synth2�
�+---------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+
h p
x
� 
�
%s
*synth2�
�|ALU            | A*B          | 30     | 18     | -      | -      | 15     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h p
x
� 
�
%s
*synth2�
�|ALU            | A*B          | 17     | 17     | -      | -      | 48     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h p
x
� 
�
%s
*synth2�
�|ALU            | PCIN>>17+A*B | 30     | 18     | -      | -      | 15     | 0    | 0    | -    | -    | -     | 0    | 0    | 
h p
x
� 
�
%s
*synth2�
�|VGA_Controller | C+A*B        | 10     | 10     | 10     | -      | 19     | 0    | 0    | 0    | -    | -     | 0    | 0    | 
h p
x
� 
�
%s
*synth2�
�+---------------+--------------+--------+--------+--------+--------+--------+------+------+------+------+-------+------+------+

h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
7
%s*synth2
+------+------------+------+
h px� 
7
%s*synth2
|      |Cell        |Count |
h px� 
7
%s*synth2
+------+------------+------+
h px� 
7
%s*synth2
|1     |BUFG        |     3|
h px� 
7
%s*synth2
|2     |CARRY4      |   302|
h px� 
7
%s*synth2
|3     |DSP48E1     |     4|
h px� 
7
%s*synth2
|5     |LUT1        |   225|
h px� 
7
%s*synth2
|6     |LUT2        |   733|
h px� 
7
%s*synth2
|7     |LUT3        |   318|
h px� 
7
%s*synth2
|8     |LUT4        |   944|
h px� 
7
%s*synth2
|9     |LUT5        |   623|
h px� 
7
%s*synth2
|10    |LUT6        |  2607|
h px� 
7
%s*synth2
|11    |MMCME2_BASE |     2|
h px� 
7
%s*synth2
|12    |MUXF7       |   413|
h px� 
7
%s*synth2
|13    |MUXF8       |   192|
h px� 
7
%s*synth2
|14    |RAMB36E1    |    40|
h px� 
7
%s*synth2
|23    |FDCE        |  4098|
h px� 
7
%s*synth2
|24    |FDPE        |    15|
h px� 
7
%s*synth2
|25    |FDRE        |    56|
h px� 
7
%s*synth2
|26    |FDSE        |     1|
h px� 
7
%s*synth2
|27    |IBUF        |     8|
h px� 
7
%s*synth2
|28    |IOBUF       |    16|
h px� 
7
%s*synth2
|29    |OBUF        |    26|
h px� 
7
%s*synth2
+------+------------+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:01:06 ; elapsed = 00:01:07 . Memory (MB): peak = 2506.039 ; gain = 1041.633 ; free physical = 5411 ; free virtual = 14147
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
a
%s
*synth2I
GSynthesis finished with 0 errors, 0 critical warnings and 28 warnings.
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:01:03 ; elapsed = 00:01:05 . Memory (MB): peak = 2506.039 ; gain = 901.883 ; free physical = 5411 ; free virtual = 14147
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:01:06 ; elapsed = 00:01:08 . Memory (MB): peak = 2506.047 ; gain = 1041.633 ; free physical = 5411 ; free virtual = 14147
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.072
00:00:00.062

2506.0472
0.0002
55862
14322Z17-722h px� 
U
-Analyzing %s Unisim elements for replacement
17*netlist2
969Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2562.0662
0.0002
55822
14317Z17-722h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 18 instances were transformed.
  IOBUF => IOBUF (IBUF, OBUFT): 16 instances
  MMCME2_BASE => MMCME2_ADV: 2 instances
Z1-111h px� 
U
%Synth Design complete | Checksum: %s
562*	vivadotcl2	
e99325cZ4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1852
702
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
synth_design: 2

00:01:132

00:01:132

2562.0662

1187.1912
55812
14317Z17-722h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2

Physical2
PSS2=
;(MB): overall = 2048.679; main = 1935.483; forked = 349.983Z17-2834h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2	
Virtual2
VSS2=
;(MB): overall = 3316.945; main = 2562.070; forked = 909.652Z17-2834h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2
00:00:00.022

00:00:002

2586.0782
0.0002
55812
14317Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2l
j/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VivadoProject/MiPro-XG-V1/MiPro-XG-V1.runs/synth_1/top.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2Q
Oreport_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Wed Apr  2 20:56:43 2025Z17-206h px� 


End Record