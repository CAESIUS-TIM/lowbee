`timescale 1 ns/ 1 ps
//`include"flipflop.v"

/**
 * sw
 * 0 rst
 * [3:1] mode0~7
 */
module switch(
	input wire [KEY_WIDTH - 1:0] key,
	input wire [SW_WIDTH:0] sw,
	output reg[DATA_WIDTH - 1:0] led
	);
	
	parameter DATA_WIDTH = 8;
	parameter KEY_WIDTH = 4;
	parameter SW_WIDTH = 4;
	parameter MODE_NUMBER = 1<<(SW_WIDTH-1);
	
	wire[DATA_WIDTH - 1:0] wire_bin[MODE_NUMBER - 1:0];
//	reg [7:0] reg_bin [7:0]; // replaced with modules' own ones;
	reg [MODE_NUMBER - 1:0] en;
	reg [SW_WIDTH - 1:0] mode;
	reg clk;
	wire rst = sw[0];
	
//	always #100_000_000 begin
//		if(rst) clk <= 0;
//		else clk <= ~clk;
//	end 
	always @(key[0]) begin
		if(rst) clk = 0;
		else clk = key[0];
	end
	// mode0
	flipflop m0(.a(key[3] && en[0]), .rst(/*!en[0] ||*/ rst), .out(wire_bin[0][0]));
	flipflop m1(.a(key[2] && en[0]), .rst(/*!en[0] ||*/ rst), .out(wire_bin[0][1]));
	flipflop m2(.a(key[1] && en[0]), .rst(/*!en[0] ||*/ rst), .out(wire_bin[0][2]));
	flipflop m3(.a(key[0] && en[0]), .rst(/*!en[0] ||*/ rst), .out(wire_bin[0][3]));
	assign wire_bin[0][7:4] = 4'b1111;
	
	// mode2
	flowing_led fl1(.rst(rst), .clk(clk), .led(wire_bin[2]));
	
	
//	always @(wire_bin) begin
//		reg_bin = wire_bin;
//	end
	
	
	always @(sw, wire_bin) begin
		if(rst) begin
			led <= 8'hff;
		end
		else led <= wire_bin[mode];
		
		if(rst)
			en <= 8'h00;
		else begin
			case(sw[3:1]) // encode
			3'b000: en <= 8'b0000_0001;
			3'b001: en <= 8'b0000_0010;
			3'b010: en <= 8'b0000_0100;
			3'b011: en <= 8'b0000_1000;
			3'b100: en <= 8'b0001_0000;
			3'b101: en <= 8'b0010_0000;
			3'b110: en <= 8'b0100_0000;
			3'b111: en <= 8'b1000_0000;
			default:en <= 2'h00;
			endcase
		end
	end
	
	always @(en) begin 
		case(en) // decode
		8'b0000_0001: mode <= 3'b000;
		8'b0000_0010: mode <= 3'b001;
		8'b0000_0100: mode <= 3'b010;
		8'b0000_1000: mode <= 3'b011;
		8'b0001_0000: mode <= 3'b100;
		8'b0010_0000: mode <= 3'b101;
		8'b0100_0000: mode <= 3'b110;
		8'b1000_0000: mode <= 3'b111;
		default: mode <= 3'b000;
		endcase
	end
endmodule