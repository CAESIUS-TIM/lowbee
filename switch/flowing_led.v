`timescale 1 ns/1 ps
module flowing_led(
	input 			rst,
	input 			clk,
	output reg[DATA_WIDTH - 1:0] led
	);
	
	parameter DATA_WIDTH = 8;
	
	always @(posedge clk, posedge rst) begin
		if(rst) led <= 8'hef;
		else begin
			led[0] <= led[1];
			led[1] <= led[2];
			led[2] <= led[3];
			led[3] <= led[4];
			led[4] <= led[5];
			led[5] <= led[6];
			led[6] <= led[7];
			led[7] <= led[0];
		end
	end
endmodule
