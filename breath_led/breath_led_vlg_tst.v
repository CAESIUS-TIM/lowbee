`timescale 1ps/1ps
module breath_led_vlg_tst;

reg clk;
reg rst;
reg key_up;
reg key_down;
wire led;
wire [3:0] cnt1;
wire [3:0] cnt2;

control_led_tst uut(
                    clk,
                    rst,
                    key_up,
                    key_down,
                    led,
                    cnt1,
                    cnt2
                );

initial begin
    clk = 0;
    rst = 0;
    key_up = 0;
    key_down = 0;
    #40 rst = 1;
    forever begin
        if({$random}&1)
            key_up = 1;
        else
            key_down = 1;
        #40;
        key_up = 0;
        key_down = 0;
        #40;
        #400;
    end

end

always #20 clk = ~clk;

endmodule
