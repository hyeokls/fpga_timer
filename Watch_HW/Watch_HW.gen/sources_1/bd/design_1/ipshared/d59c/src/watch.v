//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 10:41:19 PM
// Design Name: 
// Module Name: watch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module watch(
    clk,
    rst,
    i_en,
    i_freq,
    o_sec,
    o_min,
    o_hour
    );
    
parameter P_HOUR_BIT = 5;
parameter P_MIN_BIT = 6;
parameter P_SEC_BIT = 6;
parameter P_SEC_PER = 60;
parameter P_MIN_PER = 60;
parameter P_HOUR_PER = 24;
parameter P_TIME_BIT = 30;

input clk;
input rst;
input i_en;
input [31:0] i_freq;
input [P_HOUR_BIT-1:0] o_hour;
input [P_MIN_BIT-1:0] o_min;
input [P_SEC_BIT-1:0] o_sec;

wire w_tick_gen_sec;
wire w_tick_gen_min;
wire w_tick_gen_hour;


sec_gen u_sec_gen(
    .clk (clk),
    .rst (rst),
    .i_en (i_en),
    .i_freq(i_freq),
    .o_sec_gen(w_tick_gen_sec)    
);

tick_gen #(
.P_DELAY_CNT (2),
.P_TIME_BIT (P_SEC_BIT),
.P_TIME_CNT (P_SEC_PER)
) u_tick_gen_sec(
    .clk (clk),
    .rst (rst),
    .i_en (i_en),
    .i_tick (w_tick_gen_sec),
    .o_tick_gen(w_tick_gen_min),
    .o_cnt(o_sec)

);



tick_gen #(
.P_DELAY_CNT (1),
.P_TIME_BIT (P_MIN_BIT),
.P_TIME_CNT (P_MIN_PER)
) u_tick_gen_min(
    .clk (clk),
    .rst (rst),
    .i_en (i_en),
    .i_tick(w_tick_gen_min),
    .o_tick_gen(w_tick_gen_hour),
    .o_cnt(o_min)
);


tick_gen #(
.P_DELAY_CNT (0),
.P_TIME_BIT (P_HOUR_BIT),
.P_TIME_CNT (P_HOUR_PER)
) u_tick_gen_hour(
    .clk (clk),
    .rst (rst),
    .i_en (i_en),
    .i_tick(w_tick_gen_hour),
    .o_tick_gen(),
    .o_cnt(o_hour)

);


endmodule
