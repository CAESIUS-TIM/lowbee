`include "../debounce/debounce.v"
module main_control_led
       (
           input wire clk,
           input wire rst,
           input wire key_up,
           input wire key_down,
           output wire led,
           output wire out
       );

wire key_up_pulse;
wire key_down_pulse;
wire clk_n;
assign clk_n = ~clk;
assign out = led;

debounce u_debounce_up(
             clk,
             rst,
             key_up,
             key_up_pulse
         );

debounce u_debounce_down(
             clk,
             rst,
             key_down,
             key_down_pulse
         );

control_led_tst u_control_led_tst(
                clk_n,
                rst,
                key_up_pulse,
                key_down_pulse,
                led
            );

endmodule
