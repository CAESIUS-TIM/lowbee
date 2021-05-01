`timescale 1ps/1ps
module seqdet_random_vlg_tst;

reg in;
reg clk;
reg rst;
wire  out;
wire [2:0] state;

my_seqdet utt (
    in,
    clk,
    rst,
    out,
    state
);

initial begin
    in = 0;
    clk = 0;
    rst = 0;
    #100 rst = 1;
end

always #20 clk = ~clk;
always @(negedge clk) begin
    in = {$random} & 1;
end
endmodule
