
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
create_project: 2

00:00:052

00:00:052

1411.1332
0.0232
17512
14401Z17-722h px� 
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental /home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/utils_1/imports/synth_1/ALU.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2g
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/utils_1/imports/synth_1/ALU.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
�
Command: %s
53*	vivadotcl2j
hsynth_design -top top -part xc7a35tcpg236-1 -directive AreaOptimized_medium -control_set_opt_threshold 1Z4-113h px� 
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
Z
$Part: %s does not have CEAM library.966*device2
xc7a35tcpg236-1Z21-9227h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
4Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
P
#Helper process launched with PID %s4824*oasys2	
1552114Z8-7075h px� 
�
%s*synth2�
�Starting RTL Elaboration : Time (s): cpu = 00:00:02 ; elapsed = 00:00:03 . Memory (MB): peak = 2154.918 ; gain = 413.715 ; free physical = 687 ; free virtual = 13340
h px� 
�
synthesizing module '%s'638*oasys2
top2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
408@Z8-638h px� 
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
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
mmcm_ClockGenerator2m
k/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/mmcm_ClockGenerator.vhd2
72
ClockGenerator2
mmcm_ClockGenerator2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
2428@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
mmcm_ClockGenerator2o
k/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/mmcm_ClockGenerator.vhd2
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
MMCME2_BASE2F
D/home/jonas/tools/Xilinx/Vivado/2024.1/scripts/rt/data/unisim_comp.v2
825082
	mmcm_inst2
MMCME2_BASE2o
k/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/mmcm_ClockGenerator.vhd2
458@Z8-3491h px� 
�
synthesizing module '%s'%s4497*oasys2
MMCME2_BASE2
 2H
D/home/jonas/tools/Xilinx/Vivado/2024.1/scripts/rt/data/unisim_comp.v2	
825088@Z8-6157h px� 
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
12H
D/home/jonas/tools/Xilinx/Vivado/2024.1/scripts/rt/data/unisim_comp.v2	
825088@Z8-6155h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
mmcm_ClockGenerator2
02
12o
k/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/mmcm_ClockGenerator.vhd2
218@Z8-256h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2

CPU_Core2b
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
42
CPU_Core_inst2

CPU_Core2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
2558@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2

CPU_Core2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
408@Z8-638h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 867 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
ALU2]
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/ALU.vhd2
62

ALU_inst2
ALU2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
2318@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
ALU2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/ALU.vhd2
308@Z8-638h px� 
�
default block is never used226*oasys2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/ALU.vhd2
828@Z8-226h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
ALU2
02
12_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/ALU.vhd2
308@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
registerFile2f
d/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/registerFile.vhd2
122
RegisterFile_inst2
registerFile2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
2558@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
registerFile2h
d/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/registerFile.vhd2
258@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
registerFile2
02
12h
d/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/registerFile.vhd2
258@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
busManagement2g
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/busManagement.vhd2
52
busManagement_inst2
busManagement2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
2698@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
busManagement2i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/busManagement.vhd2
298@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
busManagement2
02
12i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/busManagement.vhd2
298@Z8-256h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
coreInterruptController2q
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/coreInterruptController.vhd2
62
interruptController_inst2
coreInterruptController2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
2938@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
coreInterruptController2s
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/coreInterruptController.vhd2
208@Z8-638h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
coreInterruptController2
02
12s
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/coreInterruptController.vhd2
208@Z8-256h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
controlUnit2e
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
52
CU2
controlUnit2d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
3068@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
controlUnit2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
538@Z8-638h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
controlUnit2
02
12g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
538@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2

CPU_Core2
02
12d
`/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/CPU_Core.vhd2
408@Z8-256h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
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
B	Parameter numCPU_CoreDebugSignals bound to: 867 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 128 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
memoryMapping2g
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/memoryMapping.vhd2
52
memoryMapping_inst2
memoryMapping2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
2828@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
memoryMapping2i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/memoryMapping.vhd2
518@Z8-638h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
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
B	Parameter numCPU_CoreDebugSignals bound to: 867 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 128 - type: integer 
h p
x
� 
N
%s
*synth26
4	Parameter numDisplays bound to: 4 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
IO_SevenSegmentDisplays2q
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/IO_SevenSegmentDisplays.vhd2
162
IO_SevenSegmentDisplay_inst2
IO_SevenSegmentDisplays2i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/memoryMapping.vhd2
3678@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
IO_SevenSegmentDisplays2s
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/IO_SevenSegmentDisplays.vhd2
358@Z8-638h px� 
N
%s
*synth26
4	Parameter numDisplays bound to: 4 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
IO_SevenSegmentDisplays2
02
12s
o/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/IO_SevenSegmentDisplays.vhd2
358@Z8-256h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 867 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 128 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
serialInterface2i
g/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/serialInterface.vhd2
62
serialInterface_inst2
serialInterface2i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/memoryMapping.vhd2
3958@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
serialInterface2k
g/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/serialInterface.vhd2
368@Z8-638h px� 
Q
%s
*synth29
7	Parameter numInterrupts bound to: 10 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numCPU_CoreDebugSignals bound to: 867 - type: integer 
h p
x
� 
\
%s
*synth2D
B	Parameter numExternalDebugSignals bound to: 128 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
serialInterface2
02
12k
g/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/serialInterface.vhd2
368@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
memoryMapping2
02
12i
e/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/memoryMapping.vhd2
518@Z8-256h px� 
M
%s
*synth25
3	Parameter ramSize bound to: 1024 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
RAM2]
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/RAM.vhd2
52

ram_inst2
RAM2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
3178@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
RAM2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/RAM.vhd2
228@Z8-638h px� 
M
%s
*synth25
3	Parameter ramSize bound to: 1024 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
RAM2
02
12_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/RAM.vhd2
228@Z8-256h px� 
M
%s
*synth25
3	Parameter memSize bound to: 1024 - type: integer 
h p
x
� 
f
%s
*synth2N
L	Parameter memoryMappedAddressesStart bound to: 1073741824 - type: integer 
h p
x
� 
d
%s
*synth2L
J	Parameter memoryMappedAddressesEnd bound to: 1073741924 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
addressDecoder2h
f/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/addressDecoder.vhd2
52
addressDecoder_inst2
addressDecoder2_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
3338@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
addressDecoder2j
f/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/addressDecoder.vhd2
448@Z8-638h px� 
M
%s
*synth25
3	Parameter memSize bound to: 1024 - type: integer 
h p
x
� 
f
%s
*synth2N
L	Parameter memoryMappedAddressesStart bound to: 1073741824 - type: integer 
h p
x
� 
d
%s
*synth2L
J	Parameter memoryMappedAddressesEnd bound to: 1073741924 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
addressDecoder2
02
12j
f/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/addressDecoder.vhd2
448@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
top2
02
12_
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/top.vhd2
408@Z8-256h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2$
"invalidInstructionInterruptReg_reg2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
7478@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2
softwareInterruptReg_reg2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
7488@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2#
!currentlyHandlingInterruptReg_reg2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
7458@Z8-6014h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
debug2
controlUnit2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/sources_1/new/controlUnit.vhd2
498@Z8-3848h px� 
l
9Port %s in module %s is either unconnected or has no load4866*oasys2
enable2
RAMZ8-7129h px� 
k
9Port %s in module %s is either unconnected or has no load4866*oasys2
reset2
RAMZ8-7129h px� 
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
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[12]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[11]2
RAMZ8-7129h px� 
q
9Port %s in module %s is either unconnected or has no load4866*oasys2
address[10]2
RAMZ8-7129h px� 
y
9Port %s in module %s is either unconnected or has no load4866*oasys2
	manualClk2
memoryMappingZ8-7129h px� 
~
9Port %s in module %s is either unconnected or has no load4866*oasys2
manualClocking2
memoryMappingZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[49]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[48]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[47]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[46]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[45]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[44]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[43]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[42]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[41]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[40]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[39]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[38]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[37]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[36]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[35]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[34]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[33]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[32]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[31]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[30]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[29]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[28]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[27]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[26]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[25]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[24]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[23]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[22]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[21]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[20]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[19]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[18]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[17]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[16]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[15]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[14]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[13]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[12]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[11]2
controlUnitZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	debug[10]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[9]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[8]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[7]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[6]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[5]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[4]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[3]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[2]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[1]2
controlUnitZ8-7129h px� 
v
9Port %s in module %s is either unconnected or has no load4866*oasys2

debug[0]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[31]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[30]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[29]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[28]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[27]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[26]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[25]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[24]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[23]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[22]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[21]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[20]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[19]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[18]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[17]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[16]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[15]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[14]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[13]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[12]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[11]2
controlUnitZ8-7129h px� 
}
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[10]2
controlUnitZ8-7129h px� 
|
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[9]2
controlUnitZ8-7129h px� 
|
9Port %s in module %s is either unconnected or has no load4866*oasys2
IVT_address[8]2
controlUnitZ8-7129h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2
Synth 8-71292
100Z17-14h px� 
�
%s*synth2�
�Finished RTL Elaboration : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 2266.855 ; gain = 525.652 ; free physical = 563 ; free virtual = 13215
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
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 2284.668 ; gain = 543.465 ; free physical = 550 ; free virtual = 13203
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
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 2284.668 ; gain = 543.465 ; free physical = 550 ; free virtual = 13203
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
00:00:00.032
00:00:00.042

2290.6052
0.0002
5472
13199Z17-722h px� 
S
-Analyzing %s Unisim elements for replacement
17*netlist2
1Z29-17h px� 
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
179*designutils2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/constrs_1/new/constraints.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2g
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/constrs_1/new/constraints.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2e
c/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/constrs_1/new/constraints.xdc2
.Xil/top_propImpl.xdcZ1-236h px� 
�
Parsing XDC File [%s]
179*designutils2v
r/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/constrs_1/new/constraintsSerialInterface.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2v
r/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.srcs/constrs_1/new/constraintsSerialInterface.xdc8Z20-178h px� 
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

2429.4182
0.0002
4842
13136Z17-722h px� 
�
!Unisim Transformation Summary:
%s111*project2V
T  A total of 1 instances were transformed.
  MMCME2_BASE => MMCME2_ADV: 1 instance 
Z1-111h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
 Constraint Validation Runtime : 2
00:00:00.012
00:00:00.012

2429.4182
0.0002
4842
13136Z17-722h px� 
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
�Finished Constraint Validation : Time (s): cpu = 00:00:09 ; elapsed = 00:00:09 . Memory (MB): peak = 2429.418 ; gain = 688.215 ; free physical = 472 ; free virtual = 13120
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
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:09 ; elapsed = 00:00:09 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 472 ; free virtual = 13120
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
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:09 ; elapsed = 00:00:09 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 472 ; free virtual = 13120
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
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
_            receive_idle |                            00001 |                              000
h p
x
� 
y
%s
*synth2a
_       receive_start_bit |                            00010 |                              001
h p
x
� 
y
%s
*synth2a
_            receive_data |                            00100 |                              010
h p
x
� 
y
%s
*synth2a
_      receive_parity_bit |                            01000 |                              011
h p
x
� 
y
%s
*synth2a
_        receive_stop_bit |                            10000 |                              100
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
one-hot2
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
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:10 ; elapsed = 00:00:10 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 477 ; free virtual = 13127
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
,	   2 Input   32 Bit       Adders := 9     
h p
x
� 
F
%s
*synth2.
,	   2 Input   31 Bit       Adders := 8     
h p
x
� 
F
%s
*synth2.
,	   2 Input   16 Bit       Adders := 1     
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
,	   2 Input    5 Bit       Adders := 9     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit       Adders := 8     
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
,	   6 Input    3 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   3 Input    2 Bit       Adders := 1     
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
.	             1005 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               32 Bit    Registers := 40    
h p
x
� 
H
%s
*synth20
.	               31 Bit    Registers := 1     
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
.	                9 Bit    Registers := 16    
h p
x
� 
H
%s
*synth20
.	                8 Bit    Registers := 17    
h p
x
� 
H
%s
*synth20
.	                5 Bit    Registers := 5     
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 11    
h p
x
� 
H
%s
*synth20
.	                3 Bit    Registers := 11    
h p
x
� 
H
%s
*synth20
.	                2 Bit    Registers := 4     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 20    
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
Y
%s
*synth2A
?	              32K Bit	(1024 X 32 bit)          RAMs := 1     
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
,	   4 Input   32 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   2 Input   32 Bit        Muxes := 69    
h p
x
� 
F
%s
*synth2.
,	 257 Input   32 Bit        Muxes := 1     
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
,	   2 Input   31 Bit        Muxes := 10    
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
,	   2 Input   16 Bit        Muxes := 3     
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
,	   2 Input    9 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit        Muxes := 1     
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
,	   4 Input    7 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    5 Bit        Muxes := 59    
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
,	   4 Input    5 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   5 Input    5 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit        Muxes := 17    
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
,	   4 Input    4 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   3 Input    4 Bit        Muxes := 1     
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
,	   5 Input    3 Bit        Muxes := 4     
h p
x
� 
F
%s
*synth2.
,	   2 Input    3 Bit        Muxes := 7     
h p
x
� 
F
%s
*synth2.
,	   4 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   3 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit        Muxes := 3     
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
,	   2 Input    1 Bit        Muxes := 164   
h p
x
� 
F
%s
*synth2.
,	   4 Input    1 Bit        Muxes := 27    
h p
x
� 
F
%s
*synth2.
,	   8 Input    1 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   3 Input    1 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   7 Input    1 Bit        Muxes := 3     
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
,	   5 Input    1 Bit        Muxes := 21    
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
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:53 ; elapsed = 00:00:53 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 511 ; free virtual = 13169
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
d
%s*synth2L
J+------------------------+-------------+---------------+----------------+
h px� 
e
%s*synth2M
K|Module Name             | RTL Object  | Depth x Width | Implemented As | 
h px� 
d
%s*synth2L
J+------------------------+-------------+---------------+----------------+
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[3] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[2] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[1] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[0] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[3] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[2] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[1] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K|IO_SevenSegmentDisplays | displays[0] | 32x7          | LUT            | 
h px� 
e
%s*synth2M
K+------------------------+-------------+---------------+----------------+

h px� 
R
%s*synth2:
8
Block RAM: Preliminary Mapping Report (see note below)
h px� 
�
%s*synth2�
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h px� 
�
%s*synth2�
�|Module Name | RTL Object       | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
h px� 
�
%s*synth2�
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h px� 
�
%s*synth2�
�|top         | ram_inst/ram_reg | 1 K x 32(READ_FIRST)   | W | R |                        |   |   | Port A           | 0      | 1      | 
h px� 
�
%s*synth2�
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

h px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
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
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:56 ; elapsed = 00:00:57 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 510 ; free virtual = 13168
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
�Finished Timing Optimization : Time (s): cpu = 00:01:05 ; elapsed = 00:01:06 . Memory (MB): peak = 2437.422 ; gain = 696.219 ; free physical = 509 ; free virtual = 13169
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
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h p
x
� 
�
%s
*synth2�
�|Module Name | RTL Object       | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
h p
x
� 
�
%s
*synth2�
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
h p
x
� 
�
%s
*synth2�
�|top         | ram_inst/ram_reg | 1 K x 32(READ_FIRST)   | W | R |                        |   |   | Port A           | 0      | 1      | 
h p
x
� 
�
%s
*synth2�
�+------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

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
4799*oasys2
ram_inst/ram_reg2
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
�Finished Technology Mapping : Time (s): cpu = 00:01:07 ; elapsed = 00:01:08 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 487 ; free virtual = 13147
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
�Finished IO Insertion : Time (s): cpu = 00:01:10 ; elapsed = 00:01:11 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 474 ; free virtual = 13138
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
�Finished Renaming Generated Instances : Time (s): cpu = 00:01:10 ; elapsed = 00:01:11 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 474 ; free virtual = 13138
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
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 463 ; free virtual = 13128
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
�Finished Renaming Generated Ports : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 463 ; free virtual = 13128
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
�Finished Handling Custom Attributes : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 461 ; free virtual = 13126
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
�Finished Renaming Generated Nets : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 460 ; free virtual = 13125
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
|1     |BUFG        |     1|
h px� 
7
%s*synth2
|2     |CARRY4      |  1075|
h px� 
7
%s*synth2
|3     |LUT1        |   404|
h px� 
7
%s*synth2
|4     |LUT2        |  1103|
h px� 
7
%s*synth2
|5     |LUT3        |  1767|
h px� 
7
%s*synth2
|6     |LUT4        |  1796|
h px� 
7
%s*synth2
|7     |LUT5        |  1362|
h px� 
7
%s*synth2
|8     |LUT6        |  1910|
h px� 
7
%s*synth2
|9     |MMCME2_BASE |     1|
h px� 
7
%s*synth2
|10    |MUXF7       |   296|
h px� 
7
%s*synth2
|11    |MUXF8       |   121|
h px� 
7
%s*synth2
|12    |RAMB36E1    |     1|
h px� 
7
%s*synth2
|13    |FDCE        |  1552|
h px� 
7
%s*synth2
|14    |FDPE        |   216|
h px� 
7
%s*synth2
|15    |FDRE        |     1|
h px� 
7
%s*synth2
|16    |IBUF        |     6|
h px� 
7
%s*synth2
|17    |OBUF        |    12|
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
�Finished Writing Synthesis Report : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.422 ; gain = 717.219 ; free physical = 460 ; free virtual = 13125
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
b
%s
*synth2J
HSynthesis finished with 0 errors, 0 critical warnings and 108 warnings.
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:01:09 ; elapsed = 00:01:11 . Memory (MB): peak = 2458.422 ; gain = 572.469 ; free physical = 461 ; free virtual = 13126
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:01:11 ; elapsed = 00:01:12 . Memory (MB): peak = 2458.430 ; gain = 717.219 ; free physical = 461 ; free virtual = 13126
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
00:00:00.042
00:00:00.042

2458.4302
0.0002
6202
13285Z17-722h px� 
V
-Analyzing %s Unisim elements for replacement
17*netlist2
1494Z29-17h px� 
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

2517.4182
0.0002
6132
13278Z17-722h px� 
�
!Unisim Transformation Summary:
%s111*project2V
T  A total of 1 instances were transformed.
  MMCME2_BASE => MMCME2_ADV: 1 instance 
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

14436322Z4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
712
1052
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

00:01:172

00:01:172

2517.4182

1106.2852
6212
13285Z17-722h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2

Physical2
PSS2=
;(MB): overall = 2049.111; main = 1703.711; forked = 396.489Z17-2834h px� 
�
%s peak %s Memory [%s] %s12246*common2
synth_design2	
Virtual2
VSS2>
<(MB): overall = 3484.711; main = 2517.422; forked = 1026.285Z17-2834h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2
00:00:00.042
00:00:00.022

2541.4302
0.0002
6282
13294Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2W
U/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.runs/synth_1/top.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2Q
Oreport_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Fri Dec 27 16:57:39 2024Z17-206h px� 


End Record