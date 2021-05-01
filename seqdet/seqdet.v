
/**
 * P329 ex8
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
module seqdet(
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
parameter F = 'd6;
parameter G = 'd7;

assign out = (state == E && in == 0)? 1: 0;

always @(posedge clk) begin
	if(!rst)
		state <= IDLE;
	else
	casex(state)
		IDLE://default
			if(in == 1)
				state <= A;
		A://IDLE,D,E,F:1
			if(in == 0)
				state <=B;
		B://A,F:10
			if(in == 0)
				state <= C;
			else
				state <= F;
		C://B,E:100
			if(in == 1)
				state <= D;
			else
				state <= G;
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
		F://B,G:1 // == A?
			if(in == 1)
				state <= A;
			else
				state <= B;
		G://C:0 // == IDLE?
			if(in == 1)
				state <= F;
		default:
			state <= IDLE;
	endcase
end

endmodule
