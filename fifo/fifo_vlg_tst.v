`timescale 1ps/1ps

module fifo_vlg_tst;

parameter DATA_WIDTH = 4;
parameter DATA_SIZE = 8;

function integer get_width(input integer x);
	for(get_width = 0; x > 0; get_width = get_width + 1)
		x = x >> 1;
endfunction

parameter DATA_SIZE_WIDTH = get_width(DATA_SIZE-1);


reg clk;
reg rst;
reg en_write;
reg en_read;
wire empty;
wire full;
//----
reg [DATA_SIZE_WIDTH-1:0]in;
wire [DATA_SIZE_WIDTH-1:0]out;
wire [DATA_SIZE_WIDTH-1:0]head;
wire [DATA_SIZE_WIDTH-1:0]tail;


main_fifo #(
              DATA_WIDTH,
              DATA_SIZE
          ) u_main_fifo (
              clk,
              rst,
              en_write,
              en_read,
              empty,
              full,
              in,
              out,
              head,
              tail
          );

initial begin
	clk = 0;
	rst = 0;
	en_write = 0;
	en_read = 0;
	#10 rst = 1;

end

always #20 clk = ~clk;

always @(negedge clk) begin
	en_write = 0;
	en_read = 0;
	if({$random}&1) begin
		en_write = 1;
		in = {$random} & {DATA_WIDTH{1'b1}};
	end
	else
		en_read = 1;

end
endmodule
