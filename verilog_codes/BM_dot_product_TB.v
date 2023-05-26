`timescale 1ns / 1ps

`define CLKflip 12
`define InputInterval 24

module BM_dot_product_TB;

    localparam e = 3, m = 4, E = 8, M = 23, SB_size = 4;
    
    reg clk, reset, write_enable;
    reg [e+m:0] in1, in2;
    reg signed [SB_size-1:0] sb1, sb2;
    wire flag_exp_overflow;
    wire [E+M:0] result;
    
    BM_dot_product #(.e(e), .m(m), .E(E), .M(M)) BMD (
    .BM1(in1),
    .BM2(in2),
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .shared_bias1(sb1),
    .shared_bias2(sb2),
    .FLAG_exp_overflow(flag_exp_overflow),
    .result(result)
    );
    
    // Correct one
//    initial begin
//        reset = 1'b0;
//        clk = 1'b1;
//        write_enable = 1'b0;
        
//        sb1 = -1;
//        sb2 = -1;
        
//        #5 reset = 1'b1;
//        #5 reset = 1'b0;    #15
        
//        in1 = 8'b00001000;
//        in2 = 8'b00000010;
//        #10 write_enable = 1'b1;
                         
//        #15              
//        in1 = 8'b00010011;
//        in2 = 8'b10001110;
                         
//        #25              
//        in1 = 8'b10001000;
//        in2 = 8'b00011000;
                         
//        #25              
//        in1 = 8'b10001011;
//        in2 = 8'b10010011;
                         
//        #25              
//        in1 = 8'b00000011;
//        in2 = 8'b10010100;
                         
//        #25               
//        in1 = 8'b00011011;
//        in2 = 8'b00000010;
                         
//        #25                 
//        in1 = 8'b10010010;
//        in2 = 8'b10001100;
                         
//        #25                
//        in1 = 8'b00001000;
//        in2 = 8'b00010110;
//    end
    
    initial begin
        reset = 1'b0;
        clk = 1'b1;
        write_enable = 1'b0;
        
        sb1 = 0;
sb2 = 0;

#5 reset = 1'b1;
#5 reset = 1'b0;    #15

in1 = 8'b00000000;
in2 = 8'b10100010;
#10 write_enable = 1'b1;

#15
in1 = 8'b10001110;
in2 = 8'b00011011;

#25
in1 = 8'b10110101;
in2 = 8'b00110101;

#25
in1 = 8'b00110110;
in2 = 8'b10010010;

#25
in1 = 8'b10001110;
in2 = 8'b10100110;

#25
in1 = 8'b00010100;
in2 = 8'b10101100;

#25
in1 = 8'b00001110;
in2 = 8'b10110010;

#25
in1 = 8'b00100000;
in2 = 8'b10101000;

    end
    
    always #12.5 clk = ~clk;
    
endmodule
