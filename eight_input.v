`timescale 1ns / 1ps
(* dont_touch = "yes" *) module eight_input(clk, rst, in_real, in_imag, out_plus_real, out_plus_imag, out_minus_real, out_minus_imag);
input clk, rst;
input  signed [12:0] in_real, in_imag;
output signed [13:0] out_plus_real, out_plus_imag, out_minus_real, out_minus_imag;

reg signed [12:0] rd_rl_1, rd_rl_2, rd_rl_3, rd_rl_4;
reg signed [12:0] rd_ig_1, rd_ig_2, rd_ig_3, rd_ig_4; 
reg [2:0] cnt;

assign out_plus_real  = (cnt>=4'b0101) ? (rd_rl_4+in_real) : 0;
assign out_plus_imag  = (cnt>=4'b0101) ? (rd_ig_4+in_imag) : 0; 


wire signed [12:0] twiddle_real, twiddle_imag;
assign twiddle_real = (cnt==3'b101) ?  2048 : 
                      (cnt==3'b110) ?  1448 :
                      (cnt==3'b111) ?  0 : 
                      (cnt==3'b000) ? -1448 : 0;
                      
assign twiddle_imag = (cnt==3'b101) ?     0 :
                      (cnt==3'b110) ? -1448 :
                      (cnt==3'b111) ? -2048 : 
                      (cnt==3'b000) ? -1448 : 0;

wire signed [13:0] rl2, ig2;
wire signed [26:0] real_2, imag_2;
wire signed [13:0] test1, test2, test3;
assign rl2 = (cnt>=3'b101) ? (rd_rl_4-in_real) : 0;
assign ig2 = (cnt>=3'b101) ? (rd_ig_4-in_imag) : 0;
assign test1 = (cnt>=3'b101) ? rd_ig_4 : 0;
assign test2 = (cnt>=3'b101) ? in_real : 0;
assign test3 = (cnt>=3'b101) ? rd_rl_4-in_real : 0;
assign real_2 = rl2 * twiddle_real - ig2 * twiddle_imag;
assign imag_2 = rl2 * twiddle_imag + ig2 * twiddle_real;
assign out_minus_real = real_2[24:11];
assign out_minus_imag = imag_2[24:11];

always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        rd_rl_1 <= 0;
        rd_rl_2 <= 0;
        rd_rl_3 <= 0;
        rd_rl_4 <= 0;
        
        rd_ig_1 <= 0;
        rd_ig_2 <= 0;
        rd_ig_3 <= 0;
        rd_ig_4 <= 0;
    end
    else begin
        cnt <= cnt+1;
        rd_rl_1 <= in_real;
        rd_rl_2 <= rd_rl_1;
        rd_rl_3 <= rd_rl_2;
        rd_rl_4 <= rd_rl_3;
        
        rd_ig_1 <= in_imag;
        rd_ig_2 <= rd_ig_1;
        rd_ig_3 <= rd_ig_2;
        rd_ig_4 <= rd_ig_3;
    end
        
end


endmodule