// TODO: search common functions
module util;
function integer get_width(input integer x);
	for(get_width = 0; x > 0; get_width = get_width + 1)
		x = x >> 1;
endfunction

function [2:0] inc_gray(input [2:0] x);
	case(x)
		'b000: //0
			inc_gray = 3'b001;
		'b001: //1
			inc_gray = 3'b011;
		'b011: //2
			inc_gray = 3'b010;
		'b010: //3
			inc_gray = 3'b110;
		'b110: //4
			inc_gray = 3'b111;
		'b111: //5
			inc_gray = 3'b101;
		'b101: //6
			inc_gray = 3'b100;
		'b100: //7
			inc_gray = 3'b000;
		default:
			inc_gray = 3'b101;
	endcase
endfunction

function [2:0] dec_gray(input [2:0] x);
	case(x)
		'b000: //0
			dec_gray = 3'b100;
		'b001: //1
			dec_gray = 3'b000;
		'b011: //2
			dec_gray = 3'b001;
		'b010: //3
			dec_gray = 3'b011;
		'b110: //4
			dec_gray = 3'b010;
		'b111: //5
			dec_gray = 3'b110;
		'b101: //6
			dec_gray = 3'b111;
		'b100: //7
			dec_gray = 3'b101;
		default:
			dec_gray = 3'b101;
	endcase
endfunction
endmodule
