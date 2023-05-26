`timescale 1ns / 1ps


module BM_dot_product
#(parameter e = 3, m = 4, E = 8, M = 23, sb = 3,
localparam in_width = 1+e+m,
localparam result_width = 1+E+M
)
(
    input [in_width-1:0] BM1, BM2,
    input clk, reset, write_enable,
    input signed [sb-1:0] shared_bias1, shared_bias2,
    output FLAG_exp_overflow,
    output [result_width-1:0] result
    );
    
    wire [2*m+e+3:0] product;
    wire [result_width-1:0] Nor_bm1, Nor_bm2, sum;
    wire [result_width-1:0] DotProduct;
    wire exp_overflow1, exp_overflow2;
    wire signed [sb-1:0] shared_bias;
    
    BM_multiplier #(.e(e), .m(m), .sb_size(sb)) BM_mul (
    .BM1(BM1),  // 1+e+m
    .BM2(BM2),  // 1+e+m
    .shared_bias1(shared_bias1),    // e
    .shared_bias2(shared_bias2),    // e
    .result(product),     // 1 + e+1 + 2m+2 = 2m+e+4
    .shared_bias(shared_bias),
    .exp_overflow(exp_overflow1)
    );
    
    normalization #(.e(e+1), .m(2*m+2), .E(E), .M(M), .sb_size(sb)) Nor1 (
    .in1(product),     // 2m+e+4
    .in2(DotProduct),  // 2m+e+4
    .shared_bias(shared_bias),  // e  not aligned!! but it's ok
    .out1(Nor_bm1), // 1+E+M
    .out2(Nor_bm2)  // 1+E+M
    );
    
    BM_adder #(.E(E), .M(M)) Adder1 (
    .BM1(Nor_bm1),
    .BM2(Nor_bm2),
    .Sum(sum),
    .FLAG_Exponent_overflow(exp_overflow2));
    
    register #(.width(result_width)) Reg1 (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .data_in(sum),
    .data_out(DotProduct)
    );
    
    assign result = DotProduct;
    assign FLAG_exp_overflow = exp_overflow1 | exp_overflow2;

endmodule
