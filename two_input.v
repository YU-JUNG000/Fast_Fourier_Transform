`timescale 1ns / 1ps
(* dont_touch = "yes" *) module two_input(clk, rst, in1_real, in1_imag, in2_real, in2_imag, in3_real, in3_imag, in4_real, in4_imag, out1_plus_real, out1_plus_imag, out1_minus_real, out1_minus_imag, out2_plus_real, out2_plus_imag, out2_minus_real, out2_minus_imag, out3_plus_real, out3_plus_imag, out3_minus_real, out3_minus_imag, out4_plus_real, out4_plus_imag, out4_minus_real, out4_minus_imag);
input clk, rst;
input  signed [14:0] in1_real, in1_imag;
input  signed [14:0] in2_real, in2_imag;
input  signed [14:0] in3_real, in3_imag;
input  signed [14:0] in4_real, in4_imag;
output signed [15:0] out1_plus_real, out1_plus_imag, out1_minus_real, out1_minus_imag;
output signed [15:0] out2_plus_real, out2_plus_imag, out2_minus_real, out2_minus_imag;
output signed [15:0] out3_plus_real, out3_plus_imag, out3_minus_real, out3_minus_imag;
output signed [15:0] out4_plus_real, out4_plus_imag, out4_minus_real, out4_minus_imag;

reg signed [14:0] rd_rl_1, rd_rl_3, rd_rl_5, rd_rl_7;
reg signed [14:0] rd_ig_1, rd_ig_3, rd_ig_5, rd_ig_7; 

assign out1_plus_real  = rd_rl_1 + in1_real;
assign out1_plus_imag  = rd_ig_1 + in1_imag; 
assign out1_minus_real = rd_rl_1 - in1_real;
assign out1_minus_imag = rd_ig_1 - in1_imag; 

assign out2_plus_real  = rd_rl_3 + in2_real;
assign out2_plus_imag  = rd_ig_3 + in2_imag; 
assign out2_minus_real = rd_rl_3 - in2_real;
assign out2_minus_imag = rd_ig_3 - in2_imag; 

assign out3_plus_real  = rd_rl_5 + in3_real;
assign out3_plus_imag  = rd_ig_5 + in3_imag; 
assign out3_minus_real = rd_rl_5 - in3_real;
assign out3_minus_imag = rd_ig_5 - in3_imag; 

assign out4_plus_real  = rd_rl_7 + in4_real;
assign out4_plus_imag  = rd_ig_7 + in4_imag; 
assign out4_minus_real = rd_rl_7 - in4_real;
assign out4_minus_imag = rd_ig_7 - in4_imag; 





always @(posedge clk) begin
    if (rst) begin
        rd_rl_1 <= 0;
        rd_rl_3 <= 0;
        rd_rl_5 <= 0;
        rd_rl_7 <= 0;
        
        rd_ig_1 <= 0;
        rd_ig_3 <= 0;
        rd_ig_5 <= 0;
        rd_ig_7 <= 0;
    end
    else begin
        rd_rl_1 <= in1_real;
        rd_rl_3 <= in2_real;
        rd_rl_5 <= in3_real;
        rd_rl_7 <= in4_real;
        
        rd_ig_1 <= in1_imag;
        rd_ig_3 <= in2_imag;
        rd_ig_5 <= in3_imag;
        rd_ig_7 <= in4_imag;
    end
end
endmodule