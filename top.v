`timescale 1ns / 1ps
(* dont_touch = "yes" *) module top(clk, rst, real_in, imag_in, real_out1, imag_out1, real_out2, imag_out2, real_out3, imag_out3, real_out4, imag_out4, real_out5, imag_out5, real_out6, imag_out6, real_out7, imag_out7, real_out8, imag_out8);
input             clk, rst;
input      [12:0] real_in, imag_in;
output reg [15:0] real_out1, imag_out1, real_out2, imag_out2, real_out3, imag_out3, real_out4, imag_out4;
output reg [15:0] real_out5, imag_out5, real_out6, imag_out6, real_out7, imag_out7, real_out8, imag_out8;

wire [13:0] w1_11, w1_12, w1_21, w1_22;
wire [14:0] w2_11, w2_12, w2_21, w2_22, w2_31, w2_32, w2_41, w2_42;
wire [15:0] w3_11, w3_12, w3_21, w3_22, w3_31, w3_32, w3_41, w3_42, w3_51, w3_52, w3_61, w3_62, w3_71, w3_72, w3_81, w3_82;

eight_input eight_input(.clk(clk), .rst(rst), .in_real(real_in), .in_imag(imag_in), .out_plus_real(w1_11), .out_plus_imag(w1_12), .out_minus_real(w1_21), .out_minus_imag(w1_22));
four_input four_input(.clk(clk), .rst(rst), .in1_real(w1_11), .in1_imag(w1_12), .in2_real(w1_21), .in2_imag(w1_22), 
                                            .out1_plus_real(w2_11), .out1_plus_imag(w2_12), .out1_minus_real(w2_21), .out1_minus_imag(w2_22), .out2_plus_real(w2_31), .out2_plus_imag(w2_32), .out2_minus_real(w2_41), .out2_minus_imag(w2_42));
two_input two_input(.clk(clk), .rst(rst), .in1_real(w2_11), .in1_imag(w2_12), .in2_real(w2_21), .in2_imag(w2_22), .in3_real(w2_31), .in3_imag(w2_32), .in4_real(w2_41), .in4_imag(w2_42), 
                                            .out1_plus_real(w3_11), .out1_plus_imag(w3_12), .out1_minus_real(w3_21), .out1_minus_imag(w3_22), .out2_plus_real(w3_31), .out2_plus_imag(w3_32), .out2_minus_real(w3_41), .out2_minus_imag(w3_42), 
                                            .out3_plus_real(w3_51), .out3_plus_imag(w3_52), .out3_minus_real(w3_61), .out3_minus_imag(w3_62), .out4_plus_real(w3_71), .out4_plus_imag(w3_72), .out4_minus_real(w3_81), .out4_minus_imag(w3_82));

always @(posedge clk) begin
    if (rst) begin
        real_out1 <= 0;
        real_out2 <= 0;
        real_out3 <= 0;
        real_out4 <= 0;
        real_out5 <= 0;
        real_out6 <= 0;
        real_out7 <= 0;
        real_out8 <= 0;
        
        imag_out1 <= 0;
        imag_out2 <= 0;
        imag_out3 <= 0;
        imag_out4 <= 0;
        imag_out5 <= 0;
        imag_out6 <= 0;
        imag_out7 <= 0;
        imag_out8 <= 0;
    end
    else begin
        real_out1 <= w3_11;
        real_out2 <= w3_51;
        real_out3 <= w3_31;
        real_out4 <= w3_71;
        real_out5 <= w3_21;
        real_out6 <= w3_61;
        real_out7 <= w3_41;
        real_out8 <= w3_81;
        
        imag_out1 <= w3_12;
        imag_out2 <= w3_52;
        imag_out3 <= w3_32;
        imag_out4 <= w3_72;
        imag_out5 <= w3_22;
        imag_out6 <= w3_62;
        imag_out7 <= w3_42;
        imag_out8 <= w3_82;
    end
end

endmodule
