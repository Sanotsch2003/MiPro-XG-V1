
B
Command: %s
53*	vivadotcl2
phys_opt_designZ4-113h px� 

@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
Implementation2	
xc7a35tZ17-347h px� 
o
0Got license for feature '%s' and/or device '%s'
310*common2
Implementation2	
xc7a35tZ17-349h px� 
R

Starting %s Task
103*constraints2
Initial Update TimingZ18-103h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:02 ; elapsed = 00:00:00.56 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5402 ; free virtual = 14128h px� 
�
^PhysOpt_Tcl_Interface Runtime Before Starting Physical Synthesis Task | CPU: %ss |  WALL: %ss
566*	vivadotcl2
1.972
0.59Z4-1435h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2857.0662
0.0002
54022
14128Z17-722h px� 
O

Starting %s Task
103*constraints2
Physical SynthesisZ18-103h px� 
^

Phase %s%s
101*constraints2
1 2#
!Physical Synthesis InitializationZ18-101h px� 
n
EMultithreading enabled for phys_opt_design using a maximum of %s CPUs380*physynth2
8Z32-721h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.7232
-0.723Z32-619h px� 
[
%s*common2B
@Phase 1 Physical Synthesis Initialization | Checksum: 1b044c7d1
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.45 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5403 ; free virtual = 14129h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.7232
-0.723Z32-619h px� 
V

Phase %s%s
101*constraints2
2 2
DSP Register OptimizationZ18-101h px� 
j
FNo candidate cells for DSP register optimization found in the design.
274*physynthZ32-456h px� 
�
aEnd %s Pass. Optimized %s %s. Created %s new %s, deleted %s existing %s and moved %s existing %s
415*physynth2
22
02
net or cell2
02
cell2
02
cell2
02
cellZ32-775h px� 
S
%s*common2:
8Phase 2 DSP Register Optimization | Checksum: 1b044c7d1
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:01 ; elapsed = 00:00:00.48 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5402 ; free virtual = 14128h px� 
W

Phase %s%s
101*constraints2
3 2
Critical Path OptimizationZ18-101h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.7232
-0.723Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2l
3CPU_Core_inst/ALU_inst/resultReg_reg[9]_rep__0_0[5]3CPU_Core_inst/ALU_inst/resultReg_reg[9]_rep__0_0[5]8Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2J
"internalClockGenerator_inst/sysClk"internalClockGenerator_inst/sysClk8Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2N
$CPU_Core_inst/CU/flagsReg[3]_i_6_n_0$CPU_Core_inst/CU/flagsReg[3]_i_6_n_08Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2P
%CPU_Core_inst/CU/flagsReg[3]_i_10_n_0%CPU_Core_inst/CU/flagsReg[3]_i_10_n_08Z32-702h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
182
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[207]CPU_Core_inst/CU/D[207]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.6832
-0.683Z32-619h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
182
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[204]CPU_Core_inst/CU/D[204]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.6542
-0.654Z32-619h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth2N
$CPU_Core_inst/CU/flagsReg[3]_i_6_n_0$CPU_Core_inst/CU/flagsReg[3]_i_6_n_02P
%CPU_Core_inst/CU/flagsReg[3]_i_6_comp	%CPU_Core_inst/CU/flagsReg[3]_i_6_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/CU/flagsReg[3]_i_9_n_0$CPU_Core_inst/CU/flagsReg[3]_i_9_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.6532
-0.653Z32-619h px� 
�
(Processed net %s.  Re-placed instance %s337*physynth24
CPU_Core_inst/CU/D[198]CPU_Core_inst/CU/D[198]2J
"CPU_Core_inst/CU/resultReg[22]_i_1	"CPU_Core_inst/CU/resultReg[22]_i_18Z32-663h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[198]CPU_Core_inst/CU/D[198]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.5772
-0.577Z32-619h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
192
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[205]CPU_Core_inst/CU/D[205]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.5382
-0.538Z32-619h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[242]CPU_Core_inst/CU/D[242]2P
%CPU_Core_inst/CU/flagsReg[3]_i_1_comp	%CPU_Core_inst/CU/flagsReg[3]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/CU/flagsReg[3]_i_5_n_0$CPU_Core_inst/CU/flagsReg[3]_i_5_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.5162
-0.516Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth24
CPU_Core_inst/CU/D[204]CPU_Core_inst/CU/D[204]8Z32-702h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[204]CPU_Core_inst/CU/D[204]2T
'CPU_Core_inst/CU/resultReg[28]_i_1_comp	'CPU_Core_inst/CU/resultReg[28]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/ALU_inst/p_1_out__1_12$CPU_Core_inst/ALU_inst/p_1_out__1_128Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.5072
-0.507Z32-619h px� 
�
(Processed net %s.  Re-placed instance %s337*physynth2P
%CPU_Core_inst/CU/flagsReg[3]_i_18_n_0%CPU_Core_inst/CU/flagsReg[3]_i_18_n_02H
!CPU_Core_inst/CU/flagsReg[3]_i_18	!CPU_Core_inst/CU/flagsReg[3]_i_188Z32-663h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2P
%CPU_Core_inst/CU/flagsReg[3]_i_18_n_0%CPU_Core_inst/CU/flagsReg[3]_i_18_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.4602
-0.460Z32-619h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
182
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[198]CPU_Core_inst/CU/D[198]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.3932
-0.393Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth24
CPU_Core_inst/CU/D[205]CPU_Core_inst/CU/D[205]8Z32-702h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[205]CPU_Core_inst/CU/D[205]2T
'CPU_Core_inst/CU/resultReg[29]_i_1_comp	'CPU_Core_inst/CU/resultReg[29]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/ALU_inst/p_1_out__1_11$CPU_Core_inst/ALU_inst/p_1_out__1_118Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.3742
-0.374Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth24
CPU_Core_inst/CU/D[207]CPU_Core_inst/CU/D[207]8Z32-702h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[207]CPU_Core_inst/CU/D[207]2T
'CPU_Core_inst/CU/resultReg[31]_i_1_comp	'CPU_Core_inst/CU/resultReg[31]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/ALU_inst/p_1_out__1_10$CPU_Core_inst/ALU_inst/p_1_out__1_108Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.2682
-0.268Z32-619h px� 
�
(Processed net %s.  Re-placed instance %s337*physynth24
CPU_Core_inst/CU/D[200]CPU_Core_inst/CU/D[200]2J
"CPU_Core_inst/CU/resultReg[24]_i_1	"CPU_Core_inst/CU/resultReg[24]_i_18Z32-663h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[200]CPU_Core_inst/CU/D[200]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.2662
-0.266Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth24
CPU_Core_inst/CU/D[197]CPU_Core_inst/CU/D[197]8Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2Z
*CPU_Core_inst/CU/resultReg_reg[21]_i_3_n_0*CPU_Core_inst/CU/resultReg_reg[21]_i_3_n_08Z32-702h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
202
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2L
#CPU_Core_inst/ALU_inst/p_1_out__1_9#CPU_Core_inst/ALU_inst/p_1_out__1_98Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.2292
-0.229Z32-619h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[242]CPU_Core_inst/CU/D[242]2T
'CPU_Core_inst/CU/flagsReg[3]_i_1_comp_1	'CPU_Core_inst/CU/flagsReg[3]_i_1_comp_18Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth24
CPU_Core_inst/CU/D[206]CPU_Core_inst/CU/D[206]8Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.1792
-0.179Z32-619h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[242]CPU_Core_inst/CU/D[242]2P
%CPU_Core_inst/CU/flagsReg[3]_i_1_comp	%CPU_Core_inst/CU/flagsReg[3]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2N
$CPU_Core_inst/CU/flagsReg[3]_i_8_n_0$CPU_Core_inst/CU/flagsReg[3]_i_8_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.1572
-0.157Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth24
CPU_Core_inst/CU/D[198]CPU_Core_inst/CU/D[198]8Z32-702h px� 
�
[Processed net %s. Critical path length was reduced through logic transformation on cell %s.374*physynth24
CPU_Core_inst/CU/D[198]CPU_Core_inst/CU/D[198]2T
'CPU_Core_inst/CU/resultReg[22]_i_1_comp	'CPU_Core_inst/CU/resultReg[22]_i_1_comp8Z32-710h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2L
#CPU_Core_inst/ALU_inst/p_1_out__1_5#CPU_Core_inst/ALU_inst/p_1_out__1_58Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.1562
-0.156Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2L
#CPU_Core_inst/ALU_inst/p_1_out__1_9#CPU_Core_inst/ALU_inst/p_1_out__1_98Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2H
!CPU_Core_inst/ALU_inst/data12[21]!CPU_Core_inst/ALU_inst/data12[21]8Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2f
0CPU_Core_inst/ALU_inst/resultReg_reg[17]_i_4_n_00CPU_Core_inst/ALU_inst/resultReg_reg[17]_i_4_n_08Z32-702h px� 
^
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
92
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2`
-CPU_Core_inst/ALU_inst/resultReg[17]_i_11_n_0-CPU_Core_inst/ALU_inst/resultReg[17]_i_11_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.1102
-0.110Z32-619h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2H
!CPU_Core_inst/ALU_inst/data12[31]!CPU_Core_inst/ALU_inst/data12[31]8Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2h
1CPU_Core_inst/ALU_inst/resultReg_reg[27]_i_10_n_01CPU_Core_inst/ALU_inst/resultReg_reg[27]_i_10_n_08Z32-702h px� 
�
BPorcessed net %s. Optimizations did not improve timing on the net.366*physynth2f
0CPU_Core_inst/ALU_inst/resultReg_reg[20]_i_2_n_00CPU_Core_inst/ALU_inst/resultReg_reg[20]_i_2_n_08Z32-702h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
122
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2^
,CPU_Core_inst/ALU_inst/resultReg[20]_i_7_n_0,CPU_Core_inst/ALU_inst/resultReg[20]_i_7_n_08Z32-735h px� 
q
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
-0.0942
-0.094Z32-619h px� 
_
!Optimized %s %s.  Swapped %s %s.
322*physynth2
12
net2
122
pinsZ32-608h px� 
�
;Processed net %s. Optimization improves timing on the net.
394*physynth2^
,CPU_Core_inst/ALU_inst/resultReg[20]_i_8_n_0,CPU_Core_inst/ALU_inst/resultReg[20]_i_8_n_08Z32-735h px� 
o
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
0.0002
0.000Z32-619h px� 
o
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
0.0002
0.000Z32-619h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.012
00:00:00.012

2857.0662
0.0002
53982
14124Z17-722h px� 
T
%s*common2;
9Phase 3 Critical Path Optimization | Checksum: 1b044c7d1
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:02 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5398 ; free virtual = 14124h px� 
W

Phase %s%s
101*constraints2
4 2
Critical Path OptimizationZ18-101h px� 
o
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
0.0002
0.000Z32-619h px� 
o
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2
 2
0.0002
0.000Z32-619h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2857.0662
0.0002
53982
14124Z17-722h px� 
T
%s*common2;
9Phase 4 Critical Path Optimization | Checksum: 1b044c7d1
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:02 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5398 ; free virtual = 14124h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002
00:00:00.012

2857.0662
0.0002
53982
14124Z17-722h px� 
t
>Post Physical Optimization Timing Summary | WNS=%s | TNS=%s |
318*physynth2
0.0002
0.000Z32-603h px� 
B
-
Summary of Physical Synthesis Optimizations
*commonh px� 
B
-============================================
*commonh px� 


*commonh px� 


*commonh px� 
�
�-------------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 
�
�|  Optimization   |  WNS Gain (ns)  |  TNS Gain (ns)  |  Added Cells  |  Removed Cells  |  Optimized Cells/Nets  |  Dont Touch  |  Iterations  |  Elapsed   |
-------------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 
�
�|  DSP Register   |          0.000  |          0.000  |            0  |              0  |                     0  |           0  |           1  |  00:00:00  |
|  Critical Path  |          0.723  |          0.723  |            0  |              0  |                    19  |           0  |           2  |  00:00:02  |
|  Total          |          0.723  |          0.723  |            0  |              0  |                    19  |           0  |           3  |  00:00:02  |
-------------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 


*commonh px� 


*commonh px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2857.0662
0.0002
53982
14124Z17-722h px� 
P
%s*common27
5Ending Physical Synthesis Task | Checksum: 262e76bda
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:02 . Memory (MB): peak = 2857.066 ; gain = 0.000 ; free physical = 5398 ; free virtual = 14124h px� 
H
Releasing license: %s
83*common2
ImplementationZ17-83h px� 

G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1742
02
02
0Z4-41h px� 
O
%s completed successfully
29*	vivadotcl2
phys_opt_designZ4-42h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2
00:00:00.052
00:00:00.012

2857.0662
0.0002
53962
14124Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote PlaceDB: 2
00:00:00.852
00:00:00.322

2857.0662
0.0002
53732
14118Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote PulsedLatchDB: 2

00:00:002

00:00:002

2857.0662
0.0002
53732
14118Z17-722h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote RouteStorage: 2
00:00:00.012
00:00:00.012

2857.0662
0.0002
53732
14118Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote Netlist Cache: 2
00:00:00.012
00:00:00.012

2857.0662
0.0002
53702
14116Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote Device Cache: 2

00:00:002
00:00:00.012

2857.0662
0.0002
53702
14117Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write Physdb Complete: 2
00:00:00.882
00:00:00.352

2857.0662
0.0002
53702
14117Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2s
q/home/jonas/git/MiPro-XG-V1/src/Hardware/Basys3/VivadoProject/MiPro-XG-V1/MiPro-XG-V1.runs/impl_1/top_physopt.dcpZ17-1381h px� 


End Record