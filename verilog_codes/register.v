`timescale 1ns / 1ps



module register
#(parameter width = 15)
(
  input clk, reset, write_enable,
  input [width-1:0] data_in,
  output [width-1:0] data_out
);

  reg [width-1:0] register; // Declare a 15-bit register

  always @(posedge clk, posedge reset) begin
    if (reset) // If reset is high, set the register value to zero
      register = 0;
    else if (write_enable)
      register = data_in;
  end

  assign data_out = register; // Assign the register value to data_out

endmodule

