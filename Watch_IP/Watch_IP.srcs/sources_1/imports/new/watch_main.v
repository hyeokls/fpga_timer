`timescale 1 ns / 1 ps
module watch_main #
(
	// Users to add parameters here

	// User parameters ends
	// Do not modify the parameters beyond this line

	// Parameters of Axi Slave Bus Interface S00_AXI
	parameter integer C_S00_AXI_DATA_WIDTH	= 32,
	parameter integer C_S00_AXI_ADDR_WIDTH	= 4
)
(

	// User ports ends
	// Do not modify the ports beyond this line
	input [3:0] sw,

	// Ports of Axi Slave Bus Interface S00_AXI
	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready
);

	wire [31:0] w_freq;
	wire [31:0] w_time;

// Instantiation of Axi Bus Interface S00_AXI
	myip_v1_0 # ( 
		.C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) u_myip_v1_0 (

		.s00_axi_aclk	(s00_axi_aclk	),
		.s00_axi_aresetn(s00_axi_aresetn),
		.s00_axi_awaddr	(s00_axi_awaddr	),
		.s00_axi_awprot	(s00_axi_awprot	),
		.s00_axi_awvalid(s00_axi_awvalid),
		.s00_axi_awready(s00_axi_awready),
		.s00_axi_wdata	(s00_axi_wdata	),
		.s00_axi_wstrb	(s00_axi_wstrb	),
		.s00_axi_wvalid	(s00_axi_wvalid	),
		.s00_axi_wready	(s00_axi_wready	),
		.s00_axi_bresp	(s00_axi_bresp	),
		.s00_axi_bvalid	(s00_axi_bvalid	),
		.s00_axi_bready	(s00_axi_bready	),
		.s00_axi_araddr	(s00_axi_araddr	),
		.s00_axi_arprot	(s00_axi_arprot	),
		.s00_axi_arvalid(s00_axi_arvalid),
		.s00_axi_arready(s00_axi_arready),
		.s00_axi_rdata	(s00_axi_rdata	),
		.s00_axi_rresp	(s00_axi_rresp	),
		.s00_axi_rvalid	(s00_axi_rvalid	),
		.s00_axi_rready	(s00_axi_rready	),
		.i_time(w_time),  // 시간을 레지스텅 저장
		.o_freq(w_freq) // 입력한 주파수가 out으로 나와서 틱으로 전달
		
	);



localparam P_TIME_BIT = 30; 
localparam P_SEC_BIT = 6; 
localparam P_MIN_BIT = 6; 
localparam P_HOUR_BIT = 5; 
localparam P_SEC_PER = 60;
localparam P_MIN_PER = 60;
localparam P_HOUR_PER = 24;


wire clk = s00_axi_aclk;
wire i_en = sw[0];
wire [P_TIME_BIT-1:0] i_freq;
wire [P_SEC_BIT-1:0] o_sec;
wire [P_MIN_BIT-1:0] o_min;
wire [P_HOUR_BIT-1:0] o_hour;
reg rst;

assign i_freq = w_freq[P_TIME_BIT-1:0];
assign w_time = {15'b0, o_hour, o_min, o_sec};  // 15 5 6 6 


always @(posedge clk) begin
	rst <= !s00_axi_aresetn;
end

watch# (
	.P_TIME_BIT (P_TIME_BIT),
	.P_SEC_BIT (P_SEC_BIT),
	.P_MIN_BIT (P_MIN_BIT),
	.P_HOUR_BIT (P_HOUR_BIT),
	.P_SEC_PER (P_SEC_PER),
	.P_MIN_PER (P_MIN_PER),
	.P_HOUR_PER (P_HOUR_PER)
) u_watch(
	.clk (clk),
	.rst (rst),
	.i_en (i_en),
	.i_freq (i_freq),
    .o_sec (o_sec),
    .o_min (o_min),
    .o_hour	(o_hour)
);

endmodule
