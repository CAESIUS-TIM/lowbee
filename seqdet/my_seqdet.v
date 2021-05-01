
/**
 * module name: seqdet
 * function: compare 5'b10010
 */

/*
      AB
0ABCDEFG_
010010  |
_   __  V
P   10010
R       _
E       E
        N
        D
 
==字符串匹配 kmp==
10010
   10010
*/
module my_seqdet(
           input wire in,
           input wire clk,
           input wire rst,
           output wire out,
           output reg[2:0] state
       );
parameter IDLE = 'd0;
parameter A = 'd1;
parameter B = 'd2;
parameter C = 'd3;
parameter D = 'd4;
parameter E = 'd5;

assign out = (state == E && in == 0)? 1: 0;

always @(posedge clk) begin
	if(!rst)
		state <= IDLE;
	else
	casex(state)
		IDLE://default
			if(in == 1)
				state <= A;
		A://IDLE,D,E:1
			if(in == 0)
				state <=B;
		B://A:10
			if(in == 0)
				state <= C;
			else
				state <= A;
		C://B,E:100
			if(in == 1)
				state <= D;
			else
				state <= IDLE;
		D://C:1001
			if(in == 0)
				state <= E;
			else
				state <= A;
		E://D:10010
			if(in == 0)
				state <= C;
			else
				state<= A;
		default:
			state <= IDLE;
	endcase
end

endmodule
