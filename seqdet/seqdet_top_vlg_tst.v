module seqdet_top_vlg_tst;

wire in;
reg clk;
reg rst;
wire  out;
wire [2:0] state;

reg [23:0]data;

my_seqdet utt (
    in,
    clk,
    rst,
    out,
    state
);

assign in = data[23];

initial begin
    clk = 0;
    rst = 0;
    data = 'b1100_1001_0100_1001_0100;

    #100 rst = 1;
    #500 $stop;
end

always #20 clk = ~clk;

always @(negedge clk) begin
    data = {data[22:0],data[23]};
end

endmodule