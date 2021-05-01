module main_fifo
       #(
           parameter DATA_WIDTH = 1,
           parameter DATA_SIZE = 8,
           parameter DATA_SIZE_WIDTH = get_width(DATA_SIZE-1)
       )
       (
           // fifo
           input wire clk,
           input wire rst,
           input wire en_write,
           input wire en_read,
           output wire empty,
           output wire full,
           // tri_state
           input wire [DATA_WIDTH-1:0]in,
           output wire [DATA_WIDTH-1:0]out,
           output wire [DATA_SIZE_WIDTH-1:0]head,
           output wire [DATA_SIZE_WIDTH-1:0]tail
       );

function integer get_width(input integer x);
	for(get_width = 0; x > 0; get_width = get_width + 1)
		x = x >> 1;
endfunction

wire [DATA_SIZE_WIDTH-1:0]databus;

fifo #(
         DATA_WIDTH,
         DATA_SIZE
     ) u_fifo (
         clk,
         rst,
         en_write,
         en_read,
         databus,
         empty,
         full,
         head,
         tail
     );

tri_state #(
              DATA_WIDTH
          ) u_tri_state (
              clk,
              rst,
              en_read, // reverse
              en_write,// reverse
              databus,
              in,
              out
          );
endmodule
