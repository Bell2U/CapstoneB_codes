`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2022 03:59:12 PM
// Design Name: 
// Module Name: normalization
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module normalization
// normalization for two opperands (with zero padding)
#(parameter e=4, m=10, E=8, M=23, sb_size=3,
localparam input_size_1 = 1+e+m, 
localparam input_size_2 = 1+E+M,
localparam exp_zero_diff = E-e,
localparam man_zero_diff = M-m
)
(
    input [input_size_1-1:0] in1,
    input [input_size_2-1:0] in2,
    input signed [sb_size-1:0] shared_bias,
    output [input_size_2-1:0] out1, out2
    );
    
    reg [m-1:0] man1;
    reg [M-1:0] padded_man1, man2, shifted_man1, shifted_man2;

    reg signed [e-1:0] raw_exp1;
    reg signed [E-1:0] padded_raw_exp1, exp1, exp2;
    wire signed [E-1:0] exponent;
    
    // spit the mantissa and exponent
    always @(in1, in2) begin
        man1 <= in1[m-1:0];
        man2 <= in2[M-1:0];

        raw_exp1 <= in1[input_size_1-2:m];
        exp2 <= in2[input_size_2-2:M];
    end
    
    // zero padding
    always @(man1, raw_exp1, man_zero_diff, exp_zero_diff) begin 
        padded_man1 = { {man_zero_diff{1'b0}},man1 };
        padded_raw_exp1 = { {exp_zero_diff{1'b0}},raw_exp1 };
    end
    
    // merge shared bias
    always @(raw_exp1, shared_bias) begin 
        exp1 = raw_exp1 - shared_bias;
    end
    
    // find the maximum exponent
    wire [E-1:0] max_exp;
    assign max_exp = exp1 >= exp2 ? exp1 : exp2;
    assign exponent = max_exp;
   
    // set the maximum exponent as the exponent of the block floating point and shift the mantissa correspondingly
    reg signed [e-1:0] diff[1:2];
    always @ (max_exp, exp1, exp2) begin 
        diff[1] = max_exp - exp1;
        diff[2] = max_exp - exp2;
    end
    
    always @ (diff, padded_man1, man2) begin 
        shifted_man1 <= padded_man1 >> diff[1];
        shifted_man2 <= man2 >> diff[2];
    end
    
    // output form here: {sign, shifted mantissa}
    assign out1 = {in1[input_size_1-1], exponent, shifted_man1};
    assign out2 = {in2[input_size_2-1], exponent, shifted_man2};
    
endmodule
