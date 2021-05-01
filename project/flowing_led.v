module flowing_led
#(
    parameter LED_WIDTH = 8
)
(
    input wire rst_n,
    input wire clk,
    input wire key,
    output reg[LED_WIDTH-1:0] leds
);

    reg order;

    always @(negedge rst_n, posedge key) begin
        if(!rst_n) order <= 1;
        else 	   order <= ~order;
    end

    always @(negedge rst_n, posedge clk) begin
        if(!rst_n) begin
            leds <= {{(LED_WIDTH){1'b1}},1'b0};
        end
		else if(order) begin
			leds[0] <= leds[1];
			leds[1] <= leds[2];
			leds[2] <= leds[3];
			leds[3] <= leds[4];
			leds[4] <= leds[5];
			leds[5] <= leds[6];
			leds[6] <= leds[7];
			leds[7] <= leds[0];
		end
		else begin
			leds[1] <= leds[0];
			leds[2] <= leds[1];
			leds[3] <= leds[2];
			leds[4] <= leds[3];
			leds[5] <= leds[4];
			leds[6] <= leds[5];
			leds[7] <= leds[6];
			leds[0] <= leds[7];
		end
    end
	
//	always @(negedge rst_n, posedge clk) begin
//        if(!rst_n) begin
//            leds <= {{(LED_WIDTH){1'b1}},1'b0};
//        end
//		else if(order) begin
//			leds <= {leds[LED_WIDTH-2:0],leds[LED_WIDTH-1]};
//		end
//		else begin
//			leds <= {leds[0],leds[LED_WIDTH-1:1]};
//		end
//    end
endmodule