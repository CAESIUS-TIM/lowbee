// TODO: search the best solution
// `include "../util/util.v"
module fifo #(
           parameter DATA_WIDTH = 1,
           parameter DATA_SIZE = 8,
           parameter DATA_SIZE_WIDTH = get_width(DATA_SIZE-1)
       ) (
           input wire clk,
           input wire rst,
           input wire en_write,
           input wire en_read,
           inout wire [DATA_WIDTH-1:0]databus,
           output wire empty,
           output wire full,
           output wire [DATA_SIZE_WIDTH-1:0]head_bin,
           output wire [DATA_SIZE_WIDTH-1:0]tail_bin
       );

// parameter DATA_SIZE_WIDTH = util.get_width(DATA_SIZE);

reg [DATA_WIDTH-1:0] register[DATA_SIZE-1:0];
reg [DATA_SIZE_WIDTH-1:0]head;
reg [DATA_SIZE_WIDTH-1:0]tail;

assign head_bin = bcd2bin(head);
assign tail_bin = bcd2bin(tail);

assign databus = (en_read)?register[head_bin]:{DATA_WIDTH{1'bz}};
assign empty = (head == tail);
assign full = (head == inc_gray(tail));

always @(posedge clk, negedge rst) begin
	if(!rst) begin
		head = 0;
		for(tail = 0; tail < DATA_SIZE - 1; tail = tail + 1) begin
			register[tail] = 0;
		end
		register[tail] = 0;
		tail = 0;
	end
	else if(en_write) begin
		if(!full) begin
			register[tail_bin] = databus;
			// tail = (tail + 1) % DATA_SIZE;
			tail = inc_gray(tail);
		end
	end
	else if(en_read) begin
		if(!empty) begin
			// databus = register[head];
			// TODO: TEST OVERFLOW
			// head = (head - 1) % DATA_SIZE;
			// head = (head + 1) % DATA_SIZE;
			head = inc_gray(head);
		end
	end
	else
		; // latch
end

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

function [2:0] bcd2bin(input [2:0] x);
	case(x)
		'b000: //0
			bcd2bin = 3'b000;
		'b001: //1
			bcd2bin = 3'b001;
		'b011: //2
			bcd2bin = 3'b010;
		'b010: //3
			bcd2bin = 3'b011;
		'b110: //4
			bcd2bin = 3'b100;
		'b111: //5
			bcd2bin = 3'b101;
		'b101: //6
			bcd2bin = 3'b110;
		'b100: //7
			bcd2bin = 3'b111;
		default:
			bcd2bin = 3'b101;
	endcase
endfunction

function [2:0] bin2bcd(input [2:0] x);
	case(x)
		'b000: //0
			bin2bcd = 3'b000;
		'b001: //1
			bin2bcd = 3'b001;
		'b010: //2
			bin2bcd = 3'b011;
		'b011: //3
			bin2bcd = 3'b010;
		'b100: //4
			bin2bcd = 3'b110;
		'b101: //5
			bin2bcd = 3'b111;
		'b110: //6
			bin2bcd = 3'b101;
		'b111: //7
			bin2bcd = 3'b100;
		default:
			bin2bcd = 3'b101;
	endcase
endfunction

endmodule
