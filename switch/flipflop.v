`timescale 1 ns/ 1 ps
module flipflop(
	input 	   a,
	input 	   rst,
	output reg out
	);
	always @(negedge a, posedge rst) begin
		if(rst) out <= 1;
		else 	out <= !out;
	end
endmodule