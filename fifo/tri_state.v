module tri_state #(
           parameter DATA_WIDTH = 1
       )(
           input wire clk,
           input wire rst,
           input wire en_write,
           input wire en_read,
           inout wire [DATA_WIDTH-1:0]databus,
           input wire [DATA_WIDTH-1:0]in,
           output reg [DATA_WIDTH-1:0]out
       );

always @(posedge clk, negedge rst) begin
	if(!rst)
		out <= 0;
	else if(en_write)
		out <= databus;
	else
		out <= 0;
end

assign databus = (en_read)?in:{DATA_WIDTH{1'bz}};

endmodule
