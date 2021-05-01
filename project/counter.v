`timescale 1 ns/ 1 ps
module counter 
#(
	parameter CNT_MAX = 25'd24_999_999,
			  CNT_WIDTH = 25
)
(
	input wire sys_clk,
	input wire sys_rst_n,
	output reg out
);

reg [CNT_WIDTH-1:0] cnt;
always @(posedge sys_clk, negedge sys_rst_n)
	if(!sys_rst_n) 			cnt <= {CNT_WIDTH{1'b0}};
	else if(cnt == CNT_MAX) cnt <= {CNT_WIDTH{1'b0}};
	else 					cnt <= cnt + 1;
	
always @(posedge sys_clk, negedge sys_rst_n)
	if(!sys_rst_n) 			out <= 0;
	else if(cnt == CNT_MAX) out <= ~out;
	else 					out <= out;
endmodule