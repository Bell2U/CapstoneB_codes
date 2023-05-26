`timescale 1ns / 1ps


module BM_multiplier
#(parameter e = 3, m = 4, sb_size = 3, 
localparam BM_size = 1+e+m
)
(
    input [BM_size-1:0] BM1, BM2,
    input signed [sb_size-1:0] shared_bias1, shared_bias2,
    output [2*m+e+3:0] result,
    output signed [sb_size-1:0] shared_bias,
    output exp_overflow
    );
    
    wire sign;
    wire signed [e-1:0] exp1, exp2;
    wire signed [e:0] exp;
    wire [m-1:0] man1_raw, man2_raw;
    wire [m:0] man1, man2;
    wire [2*m+1:0] man;
    
    reg signed [e:0] new_exp;
    reg FLAG_exponent_overflow;
    
    // sign
    assign sign = BM1[BM_size-1] ^ BM2[BM_size-1];
    
    // exponent
    assign exp1 = BM1[BM_size-2 -: e];
    assign exp2 = BM2[BM_size-2 -: e];
    always @(exp1, exp2, e) begin 
        if ( exp1+exp2+2 > 2**e-1 ) begin
            FLAG_exponent_overflow = 1'b1;
        end else begin
            FLAG_exponent_overflow = 1'b0;
        end
        new_exp = exp1 + exp2 + 2;
    end
    assign exp = new_exp;
    assign exp_overflow = FLAG_exponent_overflow;

    // mantissa
    assign man1_raw = BM1[BM_size-e-2:0];
    assign man2_raw = BM2[BM_size-e-2:0];
    assign man1 = {1'b1, man1_raw};
    assign man2 = {1'b1, man2_raw};
    assign man = man1 * man2;
    
    // shared bias
    assign shared_bias = shared_bias1 + shared_bias2;
    
    // result
    assign result = {sign, exp, man};
    
endmodule
