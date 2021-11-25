module FullAdder(a, b, carryIn, sum, carryOut);
  input logic a, b, carryIn;
  output logic sum, carryOut;

  assign sum = a ^ b ^ carryIn;
  assign carryOut = (a & b) | (a & carryIn) | (b & carryIn);

endmodule
