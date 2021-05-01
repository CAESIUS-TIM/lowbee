`include "../trans/main_trans.v"
module password #(
           N = 4
       )(
           input wire clk,
           input wire rst,
           input wire sw,
           input wire [N-1:0] in,
           output wire [N-1:0] led,
           output reg pwd
       );

reg [N-1:0] PWD;
initial begin
    PWD = 4'b1010;
end

main_trans #(
    .N(N)
) u_main_trans (
    .clk(clk),
    .rst(rst),
    .key(in),
    .led(led)
);

always @(led) begin
        if(sw)
            if(led == ~PWD)
                pwd <= 0;
            else
                pwd <= 1;
        else
            PWD = ~led;
	end
	
	
endmodule
