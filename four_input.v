`timescale 1ns / 1ps
(* dont_touch = "yes" *) module four_input(clk, rst, in1_real, in1_imag, in2_real, in2_imag, out1_plus_real, out1_plus_imag, out1_minus_real, out1_minus_imag, out2_plus_real, out2_plus_imag, out2_minus_real, out2_minus_imag);
input clk, rst;
input  signed [13:0] in1_real, in1_imag;
input  signed [13:0] in2_real, in2_imag;
output signed [14:0] out1_plus_real, out1_plus_imag, out1_minus_real, out1_minus_imag;
output signed [14:0] out2_plus_real, out2_plus_imag, out2_minus_real, out2_minus_imag;

reg signed [13:0] rd_rl_1, rd_rl_2, rd_rl_5, rd_rl_6;
reg signed [13:0] rd_ig_1, rd_ig_2, rd_ig_5, rd_ig_6; 
reg [1:0] cnt;

assign out1_plus_real  = (cnt>=2'b11 || cnt==3'b00) ? (rd_rl_2+in1_real) : 0;
assign out1_plus_imag  = (cnt>=2'b11 || cnt==3'b00) ? (rd_ig_2+in1_imag) : 0; 
assign out2_plus_real  = (cnt>=2'b11 || cnt==3'b00) ? (rd_rl_6+in2_real) : 0;
assign out2_plus_imag  = (cnt>=2'b11 || cnt==3'b00) ? (rd_ig_6+in2_imag) : 0; 


wire signed [12:0] twiddle_real, twiddle_imag;
assign twiddle_real = (cnt==2'b11) ?  2048 :  0;                      
assign twiddle_imag = (cnt==2'b11) ? 0 : -2048;

wire signed [14:0] rl_1, ig_1, rl_2, ig_2;
wire signed [27:0] real_1, imag_1;
wire signed [27:0] real_2, imag_2;
assign rl_1 = (cnt>=2'b11) ? (rd_rl_2-in1_real) : 0;
assign ig_1 = (cnt>=2'b11) ? (rd_ig_2-in1_imag) : 0;
assign real_1 = rl_1 * twiddle_real - ig_1 * twiddle_imag;
assign imag_1 = rl_1 * twiddle_imag + ig_1 * twiddle_real;
assign out1_minus_real = real_1[25:11];
assign out1_minus_imag = imag_1[25:11];

assign rl_2 = (cnt>=2'b11) ? (rd_rl_6-in2_real) : 0;
assign ig_2 = (cnt>=2'b11) ? (rd_ig_6-in2_imag) : 0;
assign real_2 = rl_2 * twiddle_real - ig_2 * twiddle_imag;
assign imag_2 = rl_2 * twiddle_imag + ig_2 * twiddle_real;
assign out2_minus_real = real_2[25:11];
assign out2_minus_imag = imag_2[25:11];


always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        rd_rl_1 <= 0;
        rd_rl_2 <= 0;
        rd_rl_5 <= 0;
        rd_rl_6 <= 0;
        
        rd_ig_1 <= 0;
        rd_ig_2 <= 0;
        rd_ig_5 <= 0;
        rd_ig_6 <= 0;
    end
    else begin
        cnt <= cnt+1;
        rd_rl_1 <= in1_real;
        rd_rl_2 <= rd_rl_1;
        rd_rl_5 <= in2_real;
        rd_rl_6 <= rd_rl_5;
        
        rd_ig_1 <= in1_imag;
        rd_ig_2 <= rd_ig_1;
        rd_ig_5 <= in2_imag;
        rd_ig_6 <= rd_ig_5;
        if (cnt < 2'b10) begin

        end
    end
end
endmodule