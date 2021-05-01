`timescale 1 ns/ 1 ps
module bcd_transformer
#(
	parameter BIN_WIDTH = 6,
			  DEC_WIDTH = 2
)
(
//	input wire sys_clk,
	input wire [BIN_WIDTH-1:0] bin,
	output wire [(DEC_WIDTH<<2)-1:0] bcd
);

wire c01,c12;
reg cin;
reg rst_n;
reg clk;
reg[3:0] i;

bcd_unit bu0(
	.clk(clk),
	.rst_n(rst_n),
	.cin(cin),
	.cout(c01),
	.bcd(bcd[3:0])
);
bcd_unit bu1(
	.clk(clk),
	.rst_n(rst_n),
	.cin(c01),
	.cout(c12),
	.bcd(bcd[7:4])
);

always @(bin) begin
	rst_n = 0;
	#5 rst_n = 1;
	for(i = BIN_WIDTH; i >= 1; i = i - 1) begin
		#5 clk = 1;
		cin = bin[i-1];
		#5 clk = 0;
	end
end

endmodule