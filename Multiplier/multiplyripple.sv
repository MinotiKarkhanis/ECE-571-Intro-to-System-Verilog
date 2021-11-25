`include "mcell.sv"
module multiply (multiplicand, multiplier, product);
  parameter N = 16;
  input logic [N-1 : 0] multiplicand, multiplier;
  output logic [2*N - 1 : 0] product;
  logic [N : 0] partialProductIn [N-1 : 0]; //making N-1 instances on [N:0] array for Partial Product Input to Multiplier rows
  logic [N : 0] partialProductOut [N-1 : 0]; //making N-1 instances on [N:0] array for storing Partial Product Output of Multiplier rows

  assign partialProductIn [0] = '0; //making zero th instance of Partial ProductIn as 0.
  genvar i;
  generate
    for (i = 0; i < N; i = i+1)
      begin
        MultiplierRow #(N) MR(.multiplicand(multiplicand),
                              .multiplierBit(multiplier[i]),
                              .partialProductIn(partialProductIn[i]),
                              .partialProductOut(partialProductOut[i]));
        assign product[i] = partialProductOut[i][0];
        assign partialProductIn[i+1] = partialProductOut[i];
      end
  endgenerate

  assign product[2*N - 1 : N] = partialProductOut[N-1][N:1];
endmodule

module MultiplierRow #(parameter N) (multiplicand, multiplierBit, partialProductIn, partialProductOut);
  //parameter N = 16;
  input [N-1 : 0] multiplicand;
  input [N : 0] partialProductIn;
  input multiplierBit;
  output [N : 0] partialProductOut;
  logic carryIn[N : 0];

  assign carryIn [0] = 1'b0;

  genvar i;
  generate
    for(i=0; i < N; i = i+1)
      begin
        Mcell MultiplierRow(.ppBitIn(partialProductIn[i+1]),
                            .multiplicandBit(multiplicand[i]),
                            .multiplierBit(multiplierBit),
                            .carryIn(carryIn[i]),
                            .ppBitOut(partialProductOut[i]),
                            .carryOut(carryIn[i+1]));
      end
  endgenerate

  assign partialProductOut[N] = carryIn[N];

endmodule
