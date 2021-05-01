// TODO: review FT
/**
 * LIST:
 * 1. my_fir
 */


// https://www.cnblogs.com/bixiaopengblog/p/7266999.html
/*-----------------------------------------------------------------------
 
Date                :        2017-07-26
Description            :        Design for FIR.
 
-----------------------------------------------------------------------*/

module my_fir(
           //global clock
           input                    clk,            //system clock
           input                    rst_n,             //sync reset

           //ad        interface
           input        [9:0]        ad_data,

           //lpf        interface

           output    reg    [24:0]        lpf_wave,
           output        [9:0]        lpf_1
       );

//--------------------------------
//Funtion :   定义抽头系数  12阶  放大100倍
parameter        C0        =        12'd1;
parameter        C1        =        12'd2;
parameter        C2        =        12'd6;
parameter        C3        =        12'd10;
parameter        C4        =        12'd14;
parameter        C5        =        12'd16;
//--------------------------------
//Funtion :      移位
reg            [9:0]        x0;
reg            [9:0]        x1;
reg            [9:0]        x2;
reg            [9:0]        x3;
reg            [9:0]        x4;
reg            [9:0]        x5;
reg            [9:0]        x6;
reg            [9:0]        x7;
reg            [9:0]        x8;
reg            [9:0]        x9;
reg            [9:0]        x10;
reg            [9:0]        x11;
//reg            [9:0]        x8;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x0 <= ad_data;
        x1 <= 10'd0;
        x2 <= 10'd0;
        x3 <= 10'd0;
        x4 <= 10'd0;
        x5 <= 10'd0;
        x6 <= 10'd0;
        x7 <= 10'd0;
        x8 <= 10'd0;
        x9 <= 10'd0;
        x10<= 10'd0;
        x11<= 10'd0;
    end
    else begin
        x0 <= ad_data;
        x1 <= x0;
        x2 <= x1;
        x3 <= x2;
        x4 <= x3;
        x5 <= x4;
        x6 <= x5;
        x7 <= x6;
        x8 <= x7;
        x9 <= x8;
        x10<= x9;
        x11<= x10;
    end
end


//--------------------------------
//Funtion :     求和

reg            [10:0]        add_one;
reg            [10:0]        add_two;
reg            [10:0]        add_three;
reg            [10:0]        add_four;
reg            [10:0]        add_five;
reg            [10:0]        add_six;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        add_one   <= 11'd0;
        add_two   <= 11'd0;
        add_three <= 11'd0;
        add_four  <= 11'd0;
        add_five  <= 11'd0;
        add_six   <= 11'd0;
    end
    else begin
        add_one   <= {1'b0,x0} + {1'b0,x11};
        add_two   <= {1'b0,x1} + {1'b0,x10};
        add_three <= {1'b0,x2} + {1'b0,x9};
        add_four  <= {1'b0,x3} + {1'b0,x8};
        add_five  <= {1'b0,x4} + {1'b0,x7};
        add_six   <= {1'b0,x5} + {1'b0,x6};
    end
end


//--------------------------------
//Funtion :     相乘

wire        [22:0]        mul_one;
wire        [22:0]        mul_two;
wire        [22:0]        mul_three;
wire        [22:0]        mul_four;
wire        [22:0]        mul_five;
wire        [22:0]        mul_six;
mul_12x11    mul_12x11_inst0 (
                 .dataa ( C0 ),        //12 bit
                 .datab ( add_one ),        //11 bit
                 .result ( mul_one )        //23 bit
             );

mul_12x11    mul_12x11_inst1 (
                 .dataa ( C1 ),        //12 bit
                 .datab ( add_two ),        //11 bit
                 .result ( mul_two )        //23 bit
             );

mul_12x11    mul_12x11_inst2 (
                 .dataa ( C2 ),        //12 bit
                 .datab ( add_three ),        //11 bit
                 .result ( mul_three )        //23 bit
             );

mul_12x11    mul_12x11_inst3 (
                 .dataa ( C3 ),        //12 bit
                 .datab ( add_four ),        //11 bit
                 .result ( mul_four )        //23 bit
             );

mul_12x11    mul_12x11_inst5 (
                 .dataa ( C4 ),        //12 bit
                 .datab ( add_five ),        //11 bit
                 .result ( mul_six )        //23 bit
             );

mul_12x11    mul_12x11_inst6 (
                 .dataa ( C5 ),        //12 bit
                 .datab ( add_six ),        //11 bit
                 .result ( mul_five )        //23 bit
             );
//--------------------------------
//Funtion :     求和


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lpf_wave <= 0;
    else
        lpf_wave <= mul_one + mul_two + mul_three + mul_four + mul_five ;
end


assign    lpf_1 = lpf_wave[24:15];

endmodule
