`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 09:38:36 PM
// Design Name: 
// Module Name: sec_gen
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


module sec_gen(
    clk,
    rst,
    i_en,
    i_freq,
    o_sec_gen
    );
      
input clk;
input rst;
input i_en;
input [31:0] i_freq;
output reg o_sec_gen;

reg [31:0] cnt;

always@(posedge clk) begin 
    if(rst) begin
        cnt <= 32'b0;
        o_sec_gen <= 1'b0;
        
    end else if(i_en)begin
        if(cnt == i_freq -1)begin
            cnt <= 1'b0;
            o_sec_gen <=1'b1;
        
        end else begin     
            cnt <= cnt + 1'b1;
            o_sec_gen <= 1'b0;
        end

    end else begin
        o_sec_gen <= 1'b0;
    end
end

endmodule
