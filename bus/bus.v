// TODO: 学习同步状态机
module bus #(

       )
       (
           inout wire[11:0] data_bus,
           input wire link_bus,
           input wire en
       );

reg[11:0] outsigs;
reg[13:0] insigs;

assign data_bus = (link_bus)?outsigs:12'hzzz;

always @(posedge en) begin
	outsigs <= data_bus * 3;
end

endmodule
