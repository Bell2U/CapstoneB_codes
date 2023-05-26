`timescale 1ns / 1ps


//module tests;
//    // for BM_multiplier
//    localparam m = 4, e = 3;
//    localparam BM_size = 1+e+m;
//    reg [BM_size-1:0] BM1 = 8'b00111100;
//    reg [BM_size-1:0] BM2 = 8'b01110101;
//    wire [2*m+e+3:0] result;
    
//    BM_multiplier #(.e(e), .m(m)) BM_mul (
//    .BM1(BM1),
//    .BM2(BM2),
//    .result(result)
//    );
    
//endmodule


module tests;
    // for normalization
    localparam e=4, m=10;
    localparam E=8, M=23;
//    localparam E=8, M=23;
    localparam bm1_size = 1+e+m, bm2_size = 1+E+M;
    reg [bm1_size-1:0] BM1 = 15'b010101110011000;
    reg [bm2_size-1:0] BM2 = 32'b00001001101100001000001101001010;
    reg signed [e-1:0] shared_bias1 = -1;
    reg signed [e-1:0] shared_bias2 = 0;
    wire [bm2_size-1:0] Mor_bm1, Mor_bm2;
    
    normalization #(.e(e), .m(m), .E(E), .M(M)) Mor1 (
    .in1(BM1),
    .in2(BM2),
    .shared_bias1(shared_bias1), 
    .shared_bias2(shared_bias2),
    .out1(Mor_bm1),
    .out2(Mor_bm2)
    );
    
endmodule

//module tests;
//    // for adder
//    localparam BM_size = 15, e = 4;
//    localparam m = BM_size - e - 1;
//    localparam Sum_size = 15, E = 4;
//    localparam M = BM_size - e - 1;
    
//    // test one: a normal test, to see if it can work correctly
//    reg [BM_size-1:0] BM1 = 15'b101111001001100;
//    reg [BM_size-1:0] BM2 = 15'b101111010100011;
//    wire [Sum_size-1:0] sum;
//    wire FLAG_exp_overflow;
    
//    BM_adder #(.BM_size(BM_size),.e(e), .m(m), .Sum_size(Sum_size), .E(E), .M(M)) Adder1 (
//    .BM1(BM1),
//    .BM2(BM2),
//    .Sum(sum),
//    .FLAG_Exponent_overflow(FLAG_exp_overflow)
//    );
    
//endmodule

//module tests;
//    // for BM_multiplier
//    localparam e = 3, m = 4;
//    localparam BM_size = 1 + e + m;
    
//    // test one: a normal test, to see if it can work correctly
//    reg [BM_size-1:0] BM1 = 8'b10110101;
//    reg [BM_size-1:0] BM2 = 8'b00110010;
//    wire [2*m+e+3:0] result;
//    wire FLAG_exp_overflow;
    
//    BM_multiplier #(.e(e), .m(m)) BMM (.BM1(BM1), .BM2(BM2), .result(result), .exp_overflow(FLAG_exp_overflow));
    
//endmodule