
?
Command: %s
53*	vivadotcl2
place_designZ4-113h px� 
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
H
Releasing license: %s
83*common2
ImplementationZ17-83h px� 
>
Running DRC with %s threads
24*drc2
8Z23-27h px� 
D
DRC finished with %s
79*	vivadotcl2

0 ErrorsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
^
,Running DRC as a precondition to command %s
22*	vivadotcl2
place_designZ4-22h px� 
>
Running DRC with %s threads
24*drc2
8Z23-27h px� 
Q
DRC finished with %s
79*	vivadotcl2
0 Errors, 21 WarningsZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
k
BMultithreading enabled for place_design using a maximum of %s CPUs12*	placeflow2
8Z30-611h px� 
C

Starting %s Task
103*constraints2
PlacerZ18-103h px� 
R

Phase %s%s
101*constraints2
1 2
Placer InitializationZ18-101h px� 
d

Phase %s%s
101*constraints2
1.1 2'
%Placer Initialization Netlist SortingZ18-101h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2
00:00:00.012
00:00:00.012

1856.0662
0.0002
130492
29223Z17-722h px� 
a
%s*common2H
FPhase 1.1 Placer Initialization Netlist Sorting | Checksum: 19fc7af8f
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.03 ; elapsed = 00:00:00.03 . Memory (MB): peak = 1856.066 ; gain = 0.000 ; free physical = 13049 ; free virtual = 29223h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
8
Deriving generated clocks
2*timingZ38-2h px� 
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

2257.0202
0.0002
127052
28879Z17-722h px� 
q

Phase %s%s
101*constraints2
1.2 24
2IO Placement/ Clock Placement/ Build Placer DeviceZ18-101h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
n
%s*common2U
SPhase 1.2 IO Placement/ Clock Placement/ Build Placer Device | Checksum: 1d3a59ccf
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 2298.941 ; gain = 442.875 ; free physical = 12686 ; free virtual = 28860h px� 
Y

Phase %s%s
101*constraints2
1.3 2
Build Placer Netlist ModelZ18-101h px� 
V
%s*common2=
;Phase 1.3 Build Placer Netlist Model | Checksum: 28739e937
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12667 ; free virtual = 28842h px� 
V

Phase %s%s
101*constraints2
1.4 2
Constrain Clocks/MacrosZ18-101h px� 
S
%s*common2:
8Phase 1.4 Constrain Clocks/Macros | Checksum: 28739e937
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12667 ; free virtual = 28842h px� 
O
%s*common26
4Phase 1 Placer Initialization | Checksum: 28739e937
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:06 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12667 ; free virtual = 28842h px� 
M

Phase %s%s
101*constraints2
2 2
Global PlacementZ18-101h px� 
L

Phase %s%s
101*constraints2
2.1 2
FloorplanningZ18-101h px� 
I
%s*common20
.Phase 2.1 Floorplanning | Checksum: 1eba97350
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:07 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12663 ; free virtual = 28837h px� 
`

Phase %s%s
101*constraints2
2.2 2#
!Update Timing before SLR Path OptZ18-101h px� 
]
%s*common2D
BPhase 2.2 Update Timing before SLR Path Opt | Checksum: 1e6ed467f
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:07 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12681 ; free virtual = 28855h px� 
_

Phase %s%s
101*constraints2
2.3 2"
 Post-Processing in FloorplanningZ18-101h px� 
\
%s*common2C
APhase 2.3 Post-Processing in Floorplanning | Checksum: 1e6ed467f
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:07 ; elapsed = 00:00:05 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12681 ; free virtual = 28855h px� 
R

Phase %s%s
101*constraints2
2.4 2
Global Place Phase1Z18-101h px� 
O
%s*common26
4Phase 2.4 Global Place Phase1 | Checksum: 27e96496e
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:13 ; elapsed = 00:00:07 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12695 ; free virtual = 28869h px� 
R

Phase %s%s
101*constraints2
2.5 2
Global Place Phase2Z18-101h px� 
g

Phase %s%s
101*constraints2
2.5.1 2(
&UpdateTiming Before Physical SynthesisZ18-101h px� 
d
%s*common2K
IPhase 2.5.1 UpdateTiming Before Physical Synthesis | Checksum: 27a3cfe88
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:14 ; elapsed = 00:00:07 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12690 ; free virtual = 28864h px� 
]

Phase %s%s
101*constraints2
2.5.2 2
Physical Synthesis In PlacerZ18-101h px� 
w
FFound %s LUTNM shape to break, %s LUT instances to create LUTNM shape
553*physynth2
62
938Z32-1035h px� 
�
YBreak lutnm for timing: one critical %s, two critical %s, total %s, new lutff created %s
561*physynth2
62
02
62
0Z32-1044h px� 
�
^End %s Pass. Optimized %s %s. Breaked %s %s, combined %s existing %s and moved %s existing %s
576*physynth2
12
4322
nets or LUTs2
62
LUTs2
4262
LUTs2
02
LUTZ32-1138h px� 
K
)No high fanout nets found in the design.
65*physynthZ32-65h px� 
e
$Optimized %s %s. Created %s new %s.
216*physynth2
02
net2
02

instanceZ32-232h px� 
�
aEnd %s Pass. Optimized %s %s. Created %s new %s, deleted %s existing %s and moved %s existing %s
415*physynth2
12
02
net or cell2
02
cell2
02
cell2
02
cellZ32-775h px� 
q
0No setup violation found.  %s was not performed.344*physynth2
DSP Register OptimizationZ32-670h px� 

0No setup violation found.  %s was not performed.344*physynth2)
'Shift Register to Pipeline OptimizationZ32-670h px� 
s
0No setup violation found.  %s was not performed.344*physynth2
Shift Register OptimizationZ32-670h px� 
r
0No setup violation found.  %s was not performed.344*physynth2
BRAM Register OptimizationZ32-670h px� 
r
0No setup violation found.  %s was not performed.344*physynth2
URAM Register OptimizationZ32-670h px� 
o
KNo candidate nets found for dynamic/static region interface net replication521*physynthZ32-949h px� 
�
aEnd %s Pass. Optimized %s %s. Created %s new %s, deleted %s existing %s and moved %s existing %s
415*physynth2
12
02
net or cell2
02
cell2
02
cell2
02
cellZ32-775h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2337.9842
0.0002
126882
28862Z17-722h px� 
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
�-----------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 
�
�|  Optimization                                     |  Added Cells  |  Removed Cells  |  Optimized Cells/Nets  |  Dont Touch  |  Iterations  |  Elapsed   |
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 
�
�|  LUT Combining                                    |            6  |            426  |                   432  |           0  |           1  |  00:00:01  |
|  Retime                                           |            0  |              0  |                     0  |           0  |           1  |  00:00:00  |
|  Very High Fanout                                 |            0  |              0  |                     0  |           0  |           1  |  00:00:00  |
|  DSP Register                                     |            0  |              0  |                     0  |           0  |           0  |  00:00:00  |
|  Shift Register to Pipeline                       |            0  |              0  |                     0  |           0  |           0  |  00:00:00  |
|  Shift Register                                   |            0  |              0  |                     0  |           0  |           0  |  00:00:00  |
|  BRAM Register                                    |            0  |              0  |                     0  |           0  |           0  |  00:00:00  |
|  URAM Register                                    |            0  |              0  |                     0  |           0  |           0  |  00:00:00  |
|  Dynamic/Static Region Interface Net Replication  |            0  |              0  |                     0  |           0  |           1  |  00:00:00  |
|  Total                                            |            6  |            426  |                   432  |           0  |           4  |  00:00:01  |
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*commonh px� 


*commonh px� 


*commonh px� 
Z
%s*common2A
?Phase 2.5.2 Physical Synthesis In Placer | Checksum: 31da05adb
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:15 ; elapsed = 00:00:08 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12687 ; free virtual = 28861h px� 
O
%s*common26
4Phase 2.5 Global Place Phase2 | Checksum: 3086a1648
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:16 ; elapsed = 00:00:08 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12687 ; free virtual = 28862h px� 
J
%s*common21
/Phase 2 Global Placement | Checksum: 3086a1648
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:16 ; elapsed = 00:00:08 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12687 ; free virtual = 28862h px� 
M

Phase %s%s
101*constraints2
3 2
Detail PlacementZ18-101h px� 
Y

Phase %s%s
101*constraints2
3.1 2
Commit Multi Column MacrosZ18-101h px� 
V
%s*common2=
;Phase 3.1 Commit Multi Column Macros | Checksum: 2bda81b76
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:16 ; elapsed = 00:00:09 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12687 ; free virtual = 28862h px� 
[

Phase %s%s
101*constraints2
3.2 2
Commit Most Macros & LUTRAMsZ18-101h px� 
X
%s*common2?
=Phase 3.2 Commit Most Macros & LUTRAMs | Checksum: 29d9cb615
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:17 ; elapsed = 00:00:09 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12686 ; free virtual = 28861h px� 
U

Phase %s%s
101*constraints2
3.3 2
Area Swap OptimizationZ18-101h px� 
R
%s*common29
7Phase 3.3 Area Swap Optimization | Checksum: 2e705a68e
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:17 ; elapsed = 00:00:09 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12686 ; free virtual = 28860h px� 
]

Phase %s%s
101*constraints2
3.4 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.4 Pipeline Register Optimization | Checksum: 2fda10ecc
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:17 ; elapsed = 00:00:09 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12686 ; free virtual = 28860h px� 
[

Phase %s%s
101*constraints2
3.5 2
Small Shape Detail PlacementZ18-101h px� 
X
%s*common2?
=Phase 3.5 Small Shape Detail Placement | Checksum: 2d92a8372
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:19 ; elapsed = 00:00:10 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12677 ; free virtual = 28852h px� 
Q

Phase %s%s
101*constraints2
3.6 2
Re-assign LUT pinsZ18-101h px� 
N
%s*common25
3Phase 3.6 Re-assign LUT pins | Checksum: 2563487dd
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:19 ; elapsed = 00:00:10 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12676 ; free virtual = 28851h px� 
]

Phase %s%s
101*constraints2
3.7 2 
Pipeline Register OptimizationZ18-101h px� 
Z
%s*common2A
?Phase 3.7 Pipeline Register Optimization | Checksum: 22dd96f1f
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:19 ; elapsed = 00:00:10 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12676 ; free virtual = 28851h px� 
J
%s*common21
/Phase 3 Detail Placement | Checksum: 22dd96f1f
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:19 ; elapsed = 00:00:10 . Memory (MB): peak = 2337.984 ; gain = 481.918 ; free physical = 12676 ; free virtual = 28851h px� 
e

Phase %s%s
101*constraints2
4 2*
(Post Placement Optimization and Clean-UpZ18-101h px� 
W

Phase %s%s
101*constraints2
4.1 2
Post Commit OptimizationZ18-101h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
\

Phase %s%s
101*constraints2
4.1.1 2
Post Placement OptimizationZ18-101h px� 
V
APost Placement Optimization Initialization | Checksum: 15da0d1e0
*commonh px� 
Q

Phase %s%s
101*constraints2

4.1.1.1 2
BUFG InsertionZ18-101h px� 
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
-0.5572
-0.776Z32-619h px� 
Z
%s*common2A
?Phase 1 Physical Synthesis Initialization | Checksum: ee105f99
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.28 ; elapsed = 00:00:00.07 . Memory (MB): peak = 2351.781 ; gain = 0.000 ; free physical = 12660 ; free virtual = 28834h px� 
�
PProcessed net %s, BUFG insertion was skipped due to placement/routing conflicts.32*	placeflow2
CPU_Core_inst/CU/AR[0]Z46-33h px� 
�
PProcessed net %s, BUFG insertion was skipped due to placement/routing conflicts.32*	placeflow2
ClockGenerator/enableZ46-33h px� 
�
�BUFG insertion identified %s candidate nets. Inserted BUFG: %s, Replicated BUFG Driver: %s, Skipped due to Placement/Routing Conflicts: %s, Skipped due to Timing Degradation: %s, Skipped due to netlist editing failed: %s.43*	placeflow2
22
02
02
22
02
0Z46-56h px� 
P
%s*common27
5Ending Physical Synthesis Task | Checksum: 199ebe35d
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.43 ; elapsed = 00:00:00.17 . Memory (MB): peak = 2351.781 ; gain = 0.000 ; free physical = 12659 ; free virtual = 28834h px� 
N
%s*common25
3Phase 4.1.1.1 BUFG Insertion | Checksum: 15da0d1e0
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:21 ; elapsed = 00:00:11 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28834h px� 
e

Phase %s%s
101*constraints2

4.1.1.2 2$
"Post Placement Timing OptimizationZ18-101h px� 
�
hPost Placement Timing Summary WNS=%s. For the most accurate timing information please run report_timing.610*place2
0.505Z30-746h px� 
b
%s*common2I
GPhase 4.1.1.2 Post Placement Timing Optimization | Checksum: 15d7b9f97
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
T
%s*common2;
9Phase 4.1 Post Commit Optimization | Checksum: 15d7b9f97
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
U

Phase %s%s
101*constraints2
4.2 2
Post Placement CleanupZ18-101h px� 
R
%s*common29
7Phase 4.2 Post Placement Cleanup | Checksum: 15d7b9f97
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
O

Phase %s%s
101*constraints2
4.3 2
Placer ReportingZ18-101h px� 
[

Phase %s%s
101*constraints2
4.3.1 2
Print Estimated CongestionZ18-101h px� 
�
'Post-Placement Estimated Congestion %s
38*	placeflow2�
�
 ____________________________________________________
|           | Global Congestion | Short Congestion  |
| Direction | Region Size       | Region Size       |
|___________|___________________|___________________|
|      North|                1x1|                2x2|
|___________|___________________|___________________|
|      South|                1x1|                2x2|
|___________|___________________|___________________|
|       East|                1x1|                2x2|
|___________|___________________|___________________|
|       West|                1x1|                1x1|
|___________|___________________|___________________|
Z30-612h px� 
X
%s*common2?
=Phase 4.3.1 Print Estimated Congestion | Checksum: 15d7b9f97
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
L
%s*common23
1Phase 4.3 Placer Reporting | Checksum: 15d7b9f97
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
V

Phase %s%s
101*constraints2
4.4 2
Final Placement CleanupZ18-101h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Netlist sorting complete. 2

00:00:002

00:00:002

2351.7812
0.0002
126592
28833Z17-722h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
b
%s*common2I
GPhase 4 Post Placement Optimization and Clean-Up | Checksum: 1f39a3027
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
D
%s*common2+
)Ending Placer Task | Checksum: 1b3243a50
h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:22 ; elapsed = 00:00:12 . Memory (MB): peak = 2351.781 ; gain = 495.715 ; free physical = 12659 ; free virtual = 28833h px� 
~
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
412
02
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
place_designZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
place_design: 2

00:00:242

00:00:122

2351.7812	
639.8322
126592
28833Z17-722h px� 
�
)Running report commands "%s" in parallel.56334*	planAhead24
2report_control_sets, report_io, report_utilizationZ12-24838h px� 
Y
+Running report generation with %s threads.
56333*	planAhead2
3Z12-24831h px� 
�
Executing command : %s
56330*	planAhead2@
>report_control_sets -verbose -file top_control_sets_placed.rptZ12-24828h px� 
�
�report_control_sets: Time (s): cpu = 00:00:00.06 ; elapsed = 00:00:00.03 . Memory (MB): peak = 2351.781 ; gain = 0.000 ; free physical = 12652 ; free virtual = 28826
*commonh px� 
e
Executing command : %s
56330*	planAhead2#
!report_io -file top_io_placed.rptZ12-24828h px� 
�
�report_io: Time (s): cpu = 00:00:00.09 ; elapsed = 00:00:00.06 . Memory (MB): peak = 2351.781 ; gain = 0.000 ; free physical = 12644 ; free virtual = 28819
*commonh px� 
�
Executing command : %s
56330*	planAhead2S
Qreport_utilization -file top_utilization_placed.rpt -pb top_utilization_placed.pbZ12-24828h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write ShapeDB Complete: 2
00:00:00.082
00:00:00.012

2358.7662
6.9842
126142
28789Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote PlaceDB: 2
00:00:00.662
00:00:00.322

2358.7662
6.9842
125902
28778Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote PulsedLatchDB: 2

00:00:002

00:00:002

2358.7662
0.0002
125902
28778Z17-722h px� 
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

00:00:002

00:00:002

2358.7662
0.0002
125902
28778Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote Netlist Cache: 2
00:00:00.012
00:00:00.012

2358.7662
0.0002
125902
28779Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Wrote Device Cache: 2

00:00:002
00:00:00.012

2358.7662
0.0002
125902
28780Z17-722h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2
Write Physdb Complete: 2
00:00:00.672
00:00:00.342

2358.7662
6.9842
125902
28780Z17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2]
[/home/jonas/git/MiPro-XG-V1/src/Hardware/MiPro-XG-V1/MiPro-XG-V1.runs/impl_1/top_placed.dcpZ17-1381h px� 


End Record