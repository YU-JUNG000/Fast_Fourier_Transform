`timescale 1ns / 1ps
module testbench();
reg clk, rst;
reg  signed [12:0] real_in, imag_in;
wire [15:0] real_out1, real_out2, real_out3, real_out4, real_out5, real_out6, real_out7, real_out8;
wire [15:0] imag_out1, imag_out2, imag_out3, imag_out4, imag_out5, imag_out6, imag_out7, imag_out8;

top top(.clk(clk), .rst(rst), .real_in(real_in), .imag_in(imag_in), .real_out1(real_out1), .imag_out1(imag_out1), .real_out2(real_out2), .imag_out2(imag_out2), .real_out3(real_out3), .imag_out3(imag_out3), .real_out4(real_out4), .imag_out4(imag_out4), .real_out5(real_out5), .imag_out5(imag_out5), .real_out6(real_out6), .imag_out6(imag_out6), .real_out7(real_out7), .imag_out7(imag_out7), .real_out8(real_out8), .imag_out8(imag_out8));

initial begin
    clk = 1'b0;     rst = 1'b0;
    real_in <= 0;     imag_in <= 0;
    #5       rst = 1'b1;
    #100     rst = 1'b0;     
             real_in <= 0;     imag_in <= 0;
    #20      real_in <= 0;     imag_in <= 0;
    #20      real_in <= 724;   imag_in <= 724;
    #20      real_in <= 0;     imag_in <= 0;
    #20      real_in <= 0;     imag_in <= 1448;
    #20      real_in <= 0;     imag_in <= 0;
    #20      real_in <= 724;   imag_in <= -724;
    #20      real_in <= 0;     imag_in <= 0;
    #500    $finish;
end

always #10   clk = ~clk;

endmodule
