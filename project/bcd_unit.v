`timescale 1 ns/ 1 ps
module bcd_unit
(
	input wire clk,
	input wire rst_n,
	input wire cin,
	output reg cout,
	output reg [3:0] bcd
);

always @(negedge rst_n, posedge clk) begin
	if(!rst_n) begin
		bcd <= 4'b0;
		cout <= 0;
	end
	else begin
		bcd = (bcd > 4 ? bcd + 3 : bcd);
		cout = bcd[3];
		#1 bcd = {bcd, cin};	
	end
end
endmodule 