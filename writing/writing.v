module writing (
           input wire clk,
           input wire rst,
           input wire [7:0] data,
           input wire [7:0] address,
           inout wire sda,
           inout wire ack
       );

reg link_write;
reg [3:0] state;
reg [4:0] sh8out_state;
reg [7:0] sh8out_buf;
reg finish;
reg ack;

parameter IDLE = 0;
parameter ADDR_WRITE = 1;
parameter DATA_WRITE = 2;
parameter STOP_ACK = 3;

parameter BIT0 = 1;
parameter BIT1 = 2;
parameter BIT2 = 3;
parameter BIT3 = 4;
parameter BIT4 = 5;
parameter BIT5 = 6;
parameter BIT6 = 7;
parameter BIT7 = 8;

assign sda = link_wirte? sh8out_buf[7]: 1'bz;

always @(posedge clk) begin
	if(!rst) begin
		link_write <= 0;
		state <= IDLE;
		sh8out_state <= IDLE;
		sh8out_buf <= 0;
		finish <= 0;
		ack <= 0;
	end
	else
	case(state)
		IDLE: begin
			link_write <= 0;
			state <= ADDR_WRITE;
			sh8out_state <= IDLE;
			sh8out_buf <= address;
			finish <= 0;
			ack <= 0;
		end
		ADDR_WRITE: begin
			if(finish == 0)
				shift8_out;
			else begin
				// link_write <= 0;
				state <= DATA_WRITE;
				sh8out_state <= IDLE;
				sh8out_buf <= data;
				finish <= 0;
				// ack <= 0;
			end
		end
		DATA_WRITE: begin
			if(finish == 0)
				shift8_out;
			else begin
				// link_write <= 0;
				state <= STOP_ACK;
				// sh8out_state <= IDLE;
				// sh8out_buf <= 0;
				finish <= 0;
				ack <= 1;
			end
		end
		STOP_ACK: begin
			// link_write <= 0;
			state <= IDLE;
			// sh8out_state <= IDLE;
			// sh8out_buf <= 0;
			// finish <= 0;
			ack <= 0;
		end
	endcase

	task shift8_out ;
		case(sh8out_state)
			IDLE: begin
				link_write <= 1;
				sh8out_state <= BIT7;
			end
			BIT7: begin
				sh8out_state <= BIT6;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT6: begin
				sh8out_state <= BIT5;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT5: begin
				sh8out_state <= BIT4;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT4: begin
				sh8out_state <= BIT3;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT3: begin
				sh8out_state <= BIT2;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT2: begin
				sh8out_state <= BIT1;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT1: begin
				sh8out_state <= BIT0;
				sh8out_buf <= sh8out_buf << 1;
			end
			BIT0: begin
				link_wirte <= 0;
				finish <= 1;
			end
		endcase
	endtask
end
endmodule
