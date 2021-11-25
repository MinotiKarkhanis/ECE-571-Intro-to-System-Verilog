module FullAdder(a, b, carryIn, sum, carryOut);
  input logic a, b, carryIn;
  output logic sum, carryOut;

  assign #1 sum = a ^ b ^ carryIn;
  assign #1 carryOut = (a & b) | (a & carryIn) | (b & carryIn);

endmodule
