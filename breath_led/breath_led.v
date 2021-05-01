`include "../util/util.v"
module breath_led #(
           parameter CNT_NUM = 2400
       )(
           input wire clk,
           input wire rst,
           output wire led
       );

parameter CNT_WIDTH = util.get_width(CNT_NUM);
reg [CNT_WIDTH-1:0] cnt1;
reg [CNT_WIDTH-1:0] cnt2;
reg flag;

always@(posedge clk, negedge rst) begin
    if(!rst)
        cnt1 <= {CNT_WIDTH{1'b0}};
    else begin
        if(cnt1 >= CNT_NUM-1)
            cnt1 <= {CNT_WIDTH{1'b0}};
        else
            cnt1 <= cnt1 + 1'b1;
    end
end

always@(posedge clk, negedge rst) begin
    if(!rst) begin
        cnt2 <= {CNT_WIDTH{1'b0}};
        flag <= 1'b0;
    end
    else if(cnt1 == CNT_NUM - 1) begin
        if(!flag) begin
            if(cnt2 >= CNT_NUM-1)
                flag <= 1'b1;
            else
                cnt2 <= cnt2 + 1'b1;
        end
        else begin
            if(cnt2 <= 0)
                flag <= 1'b0;
            else
                cnt2 <= cnt2 - 1'b1;
        end
    end
    else
        cnt2 <= cnt2;
end
assign led = (cnt1<cnt2)?1'b0:1'b1;
endmodule
