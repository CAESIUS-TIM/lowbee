`timescale 1 ns/ 1 ps
module flipflop
(
	input wire rst_n,
    input wire in,
    output reg out
);
    
always @(negedge rst_n, posedge in) begin
	if(!rst_n) out <= 0;
	else 	   out <= ~out;
end
endmodule