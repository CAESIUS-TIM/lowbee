`timescale 1 ns/ 1 ps

module main
#(
parameter KEY_WIDTH = 4,
		  SW_WIDTH  = 4,
		  LED_WIDTH = 8,
		  MODE_NUMBER = 1 << (SW_WIDTH - 1)
)
(
	input wire [KEY_WIDTH-1:0] keys,
	input wire [SW_WIDTH-1 :0] sws,
	output reg [LED_WIDTH-1:0] leds
);


parameter flowing_led_mode = 0,
		  bcd_transformer_mode = 1,
		  flipflop_mode    = 2,
		  blink_mode 	   = 3;


reg	[MODE_NUMBER-1:0]	en;
wire[MODE_NUMBER-1:0]	bus[MODE_NUMBER-1:0];
wire					rst_n;
reg 					clk;
wire 					onesec_clk;

// rst_n
assign rst_n = sws[0];

// clk
// ERROR: clk must be reset instantly
always #20 begin
	if(!rst_n) clk <= 0;
	else 	   clk <= ~clk;
end

counter onesec_counter(
	.sys_clk(clk),
	.sys_rst_n(rst_n),
	.out(onesec_clk)
);

// leds
always @(sws,bus) begin
	if(!rst_n) leds <= {(LED_WIDTH){1'b1}};
	else 	   leds <= bus[sws[3:1]];
end

// mode_selector (sw[3:1]) -> en
always @(sws[3:1]) 
case(sws[3:1])
	0: en <= 'b0000_0001;
	1: en <= 'b0000_0010; 
	2: en <= 'b0000_0100;
	3: en <= 'b0000_1000;
	4: en <= 'b0001_0000;
	5: en <= 'b0010_0000;
	6: en <= 'b0100_0000;
	7: en <= 'b1000_0000;
	default: en <= 'b0000_0001;
endcase

/*=============================================================================
	MODE CODEs
=============================================================================*/

// mode0: flowing_led
flowing_led fl1(
	.rst_n(rst_n && en[flowing_led_mode]), 
	.clk(onesec_clk), 
	.key(|keys), 
	.leds(bus[flowing_led_mode])
);

// mode1: bcd_transformer
//reg[5:0] bcd_transformer_bin;
wire[7:0] bcd_transformer_bcd;
bcd_transformer 
#(
	.BIN_WIDTH(6)
)bt1
(
	.bin(6'b111111 & rst_n),//~bus[flipflop_mode]),
	.bcd(bcd_transformer_bcd)
);
assign bus[bcd_transformer_mode] = ~bcd_transformer_bcd;


// mode2: flipflop
wire[KEY_WIDTH-1:0] flipflop_bus;
wire flipflop_rst_n = rst_n;
flipflop ff1(.rst_n(flipflop_rst_n), .in(keys[0] && en[flipflop_mode]), .out(flipflop_bus[3]));
flipflop ff2(.rst_n(flipflop_rst_n), .in(keys[1] && en[flipflop_mode]), .out(flipflop_bus[2]));
flipflop ff3(.rst_n(flipflop_rst_n), .in(keys[2] && en[flipflop_mode]), .out(flipflop_bus[1]));
flipflop ff4(.rst_n(flipflop_rst_n), .in(keys[3] && en[flipflop_mode]), .out(flipflop_bus[0]));
assign bus[flipflop_mode] = {{4{1'b1}},~flipflop_bus};

// mode3: blink
wire[KEY_WIDTH-1:0] blink_bus;
wire blink_rst_n = rst_n && en[blink_mode];
flipflop bl1(.rst_n(blink_rst_n), .in(onesec_clk && en[blink_mode]), .out(blink_bus[0]));
flipflop bl2(.rst_n(blink_rst_n), .in(onesec_clk && en[blink_mode]), .out(blink_bus[1]));
flipflop bl3(.rst_n(blink_rst_n), .in(onesec_clk && en[blink_mode]), .out(blink_bus[2]));
flipflop bl4(.rst_n(blink_rst_n), .in(onesec_clk && en[blink_mode]), .out(blink_bus[3]));
assign bus[blink_mode] = {{4{1'b1}},~blink_bus};

endmodule