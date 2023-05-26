`timescale 1ns / 1ps


module BM_adder
// before adding, addends are normalized, which means they have same exponents.
// BM2 is the larger addend {S, E, M}
#(parameter E = 8, M = 23,
localparam Sum_size = 1+E+M 
)
(
    input [Sum_size-1:0] BM1, BM2,
    output [Sum_size-1:0] Sum,
    output FLAG_Exponent_overflow
    );
    
    reg sign1, sign2;
    reg [M-1:0] man1, man2, case1_man, case2_man;
    reg signed [E-1:0] exp1, exp2, case1_exp;

    // sepreate the exponent and the mantissa
    always @(BM1, BM2) begin
        sign1 <= BM1[Sum_size-1];
        sign2 <= BM2[Sum_size-1];
    
        man1 <= BM1[M-1:0];
        man2 <= BM2[M-1:0];

        exp1 <= BM1[Sum_size-2:M];
        exp2 <= BM2[Sum_size-2:M];
    end
    
    reg Flag_case1 = 1'b0;
    reg Flag_case2 = 1'b0;
    // distinguish the situation: case1 or case2.
    always @(sign1, sign2) begin 
        if (sign1^sign2) begin 
            Flag_case2 = 1'b1;
            Flag_case1 = 1'b0;
        end else begin 
            Flag_case1 = 1'b1;
            Flag_case2 = 1'b0;
        end
    end
    
    // Case one: two operands have the same sign
    wire [M:0] tem_sum;
    reg exp_overflow = 1'b0;
    assign tem_sum = man1 + man2;
    always @(tem_sum, exp2) begin
        if (tem_sum[M]) begin
            case1_man = tem_sum[M:1];
            case1_exp = exp2 + 1'b1;
            if (case1_exp == {1'b1, {(E-1){1'b0}}}) begin 
                exp_overflow = 1'b1;
            end
        end else begin 
            case1_man = tem_sum[M-1:0];
            case1_exp = exp2;
        end
    end
    
    // Case two: two operands have the opposite sign
    // Find the relatively larger and the smaller mantissa and their corresponding sign
     reg [M-1:0] larger_man, smaller_man;
     reg case2_sign;
     always @(man1, man2, sign1, sign2) begin 
        if (man2 >= man1) begin
            larger_man = man2;
            smaller_man = man1;
            case2_sign = sign2;
        end else begin 
            larger_man = man1;
            smaller_man = man2;
            case2_sign = sign1;
        end
     end
     
     always @(larger_man, smaller_man) begin
        case2_man = larger_man - smaller_man;
     end
     
     // Base on the case, construct the result
     reg [Sum_size-1:0] sum;
     always @(*) begin
        if (Flag_case1) begin 
            sum = {sign2, case1_exp, case1_man};
        end else if (Flag_case2) begin 
            sum = {case2_sign, exp2, case2_man};
        end
     end
     
     // finish up
     assign Sum = sum;
     assign FLAG_Exponent_overflow = exp_overflow;
     
endmodule
