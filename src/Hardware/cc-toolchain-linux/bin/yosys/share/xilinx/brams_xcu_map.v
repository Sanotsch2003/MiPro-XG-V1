module $__XILINX_BLOCKRAM_TDP_ (...);

parameter INIT = 0;
parameter OPTION_MODE = "FULL";
parameter OPTION_HAS_RDFIRST = 0;

parameter PORT_A_RD_WIDTH = 1;
parameter PORT_A_WR_WIDTH = 1;
parameter PORT_A_WR_EN_WIDTH = 1;
parameter PORT_A_RD_USED = 1;
parameter PORT_A_WR_USED = 1;
parameter PORT_A_OPTION_WRITE_MODE = "NO_CHANGE";
parameter PORT_A_RD_INIT_VALUE = 0;
parameter PORT_A_RD_SRST_VALUE = 1;

parameter PORT_B_RD_WIDTH = 1;
parameter PORT_B_WR_WIDTH = 1;
parameter PORT_B_WR_EN_WIDTH = 1;
parameter PORT_B_RD_USED = 0;
parameter PORT_B_WR_USED = 0;
parameter PORT_B_OPTION_WRITE_MODE = "NO_CHANGE";
parameter PORT_B_RD_INIT_VALUE = 0;
parameter PORT_B_RD_SRST_VALUE = 0;

input PORT_A_CLK;
input PORT_A_CLK_EN;
input [15:0] PORT_A_ADDR;
input [PORT_A_WR_WIDTH-1:0] PORT_A_WR_DATA;
input [PORT_A_WR_EN_WIDTH-1:0] PORT_A_WR_EN;
output [PORT_A_RD_WIDTH-1:0] PORT_A_RD_DATA;
input PORT_A_RD_SRST;

input PORT_B_CLK;
input PORT_B_CLK_EN;
input [15:0] PORT_B_ADDR;
input [PORT_B_WR_WIDTH-1:0] PORT_B_WR_DATA;
input [PORT_B_WR_EN_WIDTH-1:0] PORT_B_WR_EN;
output [PORT_B_RD_WIDTH-1:0] PORT_B_RD_DATA;
input PORT_B_RD_SRST;

`include "brams_defs.vh"

`define PARAMS_COMMON \
	.WRITE_MODE_A(PORT_A_OPTION_WRITE_MODE), \
	.WRITE_MODE_B(PORT_B_OPTION_WRITE_MODE), \
	.READ_WIDTH_A(PORT_A_RD_USED ? PORT_A_RD_WIDTH : 0), \
	.READ_WIDTH_B(PORT_B_RD_USED ? PORT_B_RD_WIDTH : 0), \
	.WRITE_WIDTH_A(PORT_A_WR_USED ? PORT_A_WR_WIDTH : 0), \
	.WRITE_WIDTH_B(PORT_B_WR_USED ? PORT_B_WR_WIDTH : 0), \
	.DOA_REG(0), \
	.DOB_REG(0), \
	.INIT_A(ival(PORT_A_RD_WIDTH, PORT_A_RD_INIT_VALUE)), \
	.INIT_B(ival(PORT_B_RD_WIDTH, PORT_B_RD_INIT_VALUE)), \
	.SRVAL_A(ival(PORT_A_RD_WIDTH, PORT_A_RD_SRST_VALUE)), \
	.SRVAL_B(ival(PORT_B_RD_WIDTH, PORT_B_RD_SRST_VALUE)),

`define PORTS_COMMON \
	.DOUTADOUT(DO_A), \
	.DOUTPADOUTP(DOP_A), \
	.DINADIN(DI_A), \
	.DINPADINP(DIP_A), \
	.DOUTBDOUT(DO_B), \
	.DOUTPBDOUTP(DOP_B), \
	.DINBDIN(DI_B), \
	.DINPBDINP(DIP_B), \
	.CLKARDCLK(PORT_A_CLK), \
	.CLKBWRCLK(PORT_B_CLK), \
	.ENARDEN(PORT_A_CLK_EN), \
	.ENBWREN(PORT_B_CLK_EN), \
	.REGCEAREGCE(1'b0), \
	.REGCEB(1'b0), \
	.ADDRENA(1'b1), \
	.ADDRENB(1'b1), \
	.RSTRAMARSTRAM(PORT_A_RD_SRST), \
	.RSTRAMB(PORT_B_RD_SRST), \
	.RSTREGARSTREG(1'b0), \
	.RSTREGB(1'b0), \
	.WEA(WE_A), \
	.WEBWE(WE_B), \
	.ADDRARDADDR(PORT_A_ADDR), \
	.ADDRBWRADDR(PORT_B_ADDR), \
	.SLEEP(1'b0),

`MAKE_DI(DI_A, DIP_A, PORT_A_WR_DATA)
`MAKE_DI(DI_B, DIP_B, PORT_B_WR_DATA)
`MAKE_DO(DO_A, DOP_A, PORT_A_RD_DATA)
`MAKE_DO(DO_B, DOP_B, PORT_B_RD_DATA)

wire [3:0] WE_A = {4{PORT_A_WR_EN}};
wire [3:0] WE_B = {4{PORT_B_WR_EN}};

generate

if (OPTION_MODE == "HALF") begin
	RAMB18E2 #(
		`PARAMS_INIT_18
		`PARAMS_INITP_18
		`PARAMS_COMMON
	) _TECHMAP_REPLACE_ (
		`PORTS_COMMON
	);
end else if (OPTION_MODE == "FULL") begin
	RAMB36E2 #(
		`PARAMS_INIT_36
		`PARAMS_INITP_36
		`PARAMS_COMMON
	) _TECHMAP_REPLACE_ (
		`PORTS_COMMON
	);
end

endgenerate

endmodule


module $__XILINX_BLOCKRAM_SDP_ (...);

parameter INIT = 0;
parameter OPTION_MODE = "FULL";
parameter OPTION_WRITE_MODE = "READ_FIRST";

parameter PORT_W_WIDTH = 1;
parameter PORT_W_WR_EN_WIDTH = 1;
parameter PORT_W_USED = 1;

parameter PORT_R_WIDTH = 1;
parameter PORT_R_USED = 0;
parameter PORT_R_RD_INIT_VALUE = 0;
parameter PORT_R_RD_SRST_VALUE = 0;

input PORT_W_CLK;
input PORT_W_CLK_EN;
input [15:0] PORT_W_ADDR;
input [PORT_W_WIDTH-1:0] PORT_W_WR_DATA;
input [PORT_W_WR_EN_WIDTH-1:0] PORT_W_WR_EN;

input PORT_R_CLK;
input PORT_R_CLK_EN;
input [15:0] PORT_R_ADDR;
output [PORT_R_WIDTH-1:0] PORT_R_RD_DATA;
input PORT_R_RD_SRST;

`include "brams_defs.vh"

`define PARAMS_COMMON \
	.WRITE_MODE_A(OPTION_WRITE_MODE), \
	.WRITE_MODE_B(OPTION_WRITE_MODE), \
	.READ_WIDTH_A(PORT_R_USED ? PORT_R_WIDTH : 0), \
	.READ_WIDTH_B(0), \
	.WRITE_WIDTH_A(0), \
	.WRITE_WIDTH_B(PORT_W_USED ? PORT_W_WIDTH : 0), \
	.DOA_REG(0), \
	.DOB_REG(0),

`define PORTS_COMMON \
	.CLKBWRCLK(PORT_W_CLK), \
	.CLKARDCLK(PORT_R_CLK), \
	.ENBWREN(PORT_W_CLK_EN), \
	.ENARDEN(PORT_R_CLK_EN), \
	.REGCEAREGCE(1'b0), \
	.REGCEB(1'b0), \
	.ADDRENA(1'b1), \
	.ADDRENB(1'b1), \
	.RSTRAMARSTRAM(PORT_R_RD_SRST), \
	.RSTRAMB(1'b0), \
	.RSTREGARSTREG(1'b0), \
	.RSTREGB(1'b0), \
	.WEA(0), \
	.WEBWE(PORT_W_WR_EN), \
	.ADDRARDADDR(PORT_R_ADDR), \
	.ADDRBWRADDR(PORT_W_ADDR), \
	.SLEEP(1'b0),

`MAKE_DI(DI, DIP, PORT_W_WR_DATA)
`MAKE_DO(DO, DOP, PORT_R_RD_DATA)

generate

if (OPTION_MODE == "HALF") begin
	RAMB18E2 #(
		`PARAMS_INIT_18
		`PARAMS_INITP_18
		`PARAMS_COMMON
		.INIT_A(PORT_R_WIDTH == 36 ? ival(18, PORT_R_RD_INIT_VALUE[17:0]) : ival(PORT_R_WIDTH, PORT_R_RD_INIT_VALUE)),
		.INIT_B(PORT_R_WIDTH == 36 ? ival(18, PORT_R_RD_INIT_VALUE[35:18]) : 0),
		.SRVAL_A(PORT_R_WIDTH == 36 ? ival(18, PORT_R_RD_SRST_VALUE[17:0]) : ival(PORT_R_WIDTH, PORT_R_RD_SRST_VALUE)),
		.SRVAL_B(PORT_R_WIDTH == 36 ? ival(18, PORT_R_RD_SRST_VALUE[35:18]) : 0),
	) _TECHMAP_REPLACE_ (
		`PORTS_COMMON
		.DOUTADOUT(DO[15:0]),
		.DOUTBDOUT(DO[31:16]),
		.DOUTPADOUTP(DOP[1:0]),
		.DOUTPBDOUTP(DOP[3:2]),
		.DINADIN(DI[15:0]),
		.DINBDIN(PORT_W_WIDTH == 36 ? DI[31:16] : DI[15:0]),
		.DINPADINP(DIP[1:0]),
		.DINPBDINP(PORT_W_WIDTH == 36 ? DIP[3:2] : DIP[1:0]),
	);
end else if (OPTION_MODE == "FULL") begin
	RAMB36E2 #(
		`PARAMS_INIT_36
		`PARAMS_INITP_36
		`PARAMS_COMMON
		.INIT_A(PORT_R_WIDTH == 72 ? ival(36, PORT_R_RD_INIT_VALUE[35:0]) : ival(PORT_R_WIDTH, PORT_R_RD_INIT_VALUE)),
		.INIT_B(PORT_R_WIDTH == 72 ? ival(36, PORT_R_RD_INIT_VALUE[71:36]) : 0),
		.SRVAL_A(PORT_R_WIDTH == 72 ? ival(36, PORT_R_RD_SRST_VALUE[35:0]) : ival(PORT_R_WIDTH, PORT_R_RD_SRST_VALUE)),
		.SRVAL_B(PORT_R_WIDTH == 72 ? ival(36, PORT_R_RD_SRST_VALUE[71:36]) : 0),
	) _TECHMAP_REPLACE_ (
		`PORTS_COMMON
		.DOUTADOUT(DO[31:0]),
		.DOUTBDOUT(DO[63:32]),
		.DOUTPADOUTP(DOP[3:0]),
		.DOUTPBDOUTP(DOP[7:4]),
		.DINADIN(DI[31:0]),
		.DINBDIN(PORT_W_WIDTH == 72 ? DI[63:32] : DI[31:0]),
		.DINPADINP(DIP[3:0]),
		.DINPBDINP(PORT_W_WIDTH == 71 ? DIP[7:4] : DIP[3:0]),
	);
end

endgenerate

endmodule
