`include "fulladdr.sv"
module Mcell(ppBitIn, multiplicandBit, multiplierBit, carryIn, ppBitOut, carryOut);
  input ppBitIn, multiplicandBit, multiplierBit, carryIn; //ppBitIn is Incoming Partial Product Bit
  output ppBitOut, carryOut; //ppBitOut is Outgoing Partial Product Bit
  logic ppBit; //ppBit is to store Partial Product Bit obtained by ANDing Multiplicand bit and Multiplier bit

  assign #1 ppBit = multiplicandBit & multiplierBit;

  FullAdder FA(.a(ppBitIn), .b(ppBit), .carryIn(carryIn), .sum(ppBitOut), .carryOut(carryOut));

endmodule
