## config.mk

EXE =

## toolchain
YOSYS = ../../bin/yosys/yosys$(EXE)
PR    = ../../bin/p_r/p_r$(EXE)
OFL   = ../../bin/openFPGALoader/openFPGALoader$(EXE)

GTKW = gtkwave
IVL = iverilog
VVP = vvp
IVLFLAGS = -g2012 -gspecify -Ttyp
GHDL = ghdl

## simulation libraries
CELLS_SYNTH = ../../bin/yosys/share/gatemate/cells_sim.v
CELLS_IMPL = ../../bin/p_r/cpelib.v

## target sources
VLOG_SRC = $(shell find ./src/ -type f \( -iname \*.v -o -iname \*.sv \))
VHDL_SRC = $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))

## misc tools
RM = rm -rf

## toolchain targets
synth: synth_vlog

synth_vlog: $(VLOG_SRC)
	$(YOSYS) -qql log/synth.log -p 'read_verilog -sv $^; synth_gatemate -top $(TOP) -nomx8 -vlog net/$(TOP)_synth.v'

synth_vhdl: $(VHDL_SRC)
	$(YOSYS) -ql log/synth.log -p 'ghdl --warn-no-binding -C --ieee=synopsys $^ -e $(TOP); synth_gatemate -top $(TOP) -nomx8 -vlog net/$(TOP)_synth.v'

impl:
	$(PR) -i net/$(TOP)_synth.v -o $(TOP) $(PRFLAGS) > log/$@.log

jtag:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag $(TOP)_00.cfg

jtag-flash:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag -f --verify $(TOP)_00.cfg

spi:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_spi -m $(TOP)_00.cfg

spi-flash:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_spi -f --verify $(TOP)_00.cfg

all: synth impl jtag

## verilog simulation targets
vlog_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ $(VLOG_SRC) sim/iverilog/$(TOP)_tb.v $(CELLS_SYNTH) $(CELLS_IMPL)

synth_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ net/$(TOP)_synth.v sim/iverilog/$(TOP)_tb.v $(CELLS_SYNTH) $(CELLS_IMPL)

impl_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ $(TOP)_00.v sim/iverilog/$(TOP)_tb.v $(CELLS_IMPL)

## vhdl simulation target
vhdl_sim:
	$(GHDL) -a $(VHDL_SRC) sim/ghdl/$(TOP)_tb.vhd
	$(GHDL) -e tb
	$(GHDL) -r tb --vcd=sim/mult_tb.vcd --stop-time=1us

.PHONY: %sim %sim.vvp
%sim: %sim.vvp
	$(VVP) -N sim/iverilog/$< -fst
	@$(RM) sim/$^

wave:
	$(GTKW) sim/$(TOP)_tb.vcd sim/config.gtkw

clean:
	$(RM) log/*.log
	$(RM) net/*_synth.v
	$(RM) *.history
	$(RM) *.txt
	$(RM) *.refwire
	$(RM) *.refparam
	$(RM) *.refcomp
	$(RM) *.pos
	$(RM) *.pathes
	$(RM) *.path_struc
	$(RM) *.net
	$(RM) *.id
	$(RM) *.prn
	$(RM) *_00.v
	$(RM) *.used
	$(RM) *.sdf
	$(RM) *.place
	$(RM) *.pin
	$(RM) *.cfg*
	$(RM) *.cdf
	$(RM) sim/*.vcd
	$(RM) sim/*.vvp
	$(RM) sim/*.gtkw
