module multiply (multiplicand, multiplier, product, clock);
  parameter N = 16;
  input logic [N-1 : 0] multiplicand, multiplier;
  input logic clock;
  output logic [2*N-1 : 0] product;

  logic [N-1 : 0] aInput; //a Input of FullAdder for the 1st stage of Row
  logic [N-1 : 0] bInput [N-1 : 0]; //instantiating N-1 instances of bInput of full adder for Rows
  logic [N-1 : 0] carryIn; //1st stage of full adder carryIn row
  logic [N-1 : 0] sum [N-2 : 0];
  logic [N-1 : 0] carryOut [N-3 : 0];
  logic carryLastRow [N : 0];
  logic aInputLastRow [N-1 : 0];
  logic ab[N-1 : 0] [N-1 : 0]  ; //to store AND of Multiplicand and Multiplier

  //declaring pipeline registers
  struct{
    logic abPipeline [N-1 : 0] [N-1 : 0];
    logic [N-1 : 0] sumPipeline;
    logic [N-1 : 0] carryOutPipeline;
    logic [2*N-1 : 0] productPipeline;
  } pipeline [N-2 : 0];

  //generate AND instances of multlipand multiplier bits
  genvar i, j;
  generate
    begin
      for(i=0; i < N; i = i+1)
        begin
          for(j=0; j < N; j = j+1)
            assign #1 ab [i][j] = multiplicand[i] & multiplier[j];
        end
    end
  endgenerate

  //preparing inputs for the 1st row of the Multliplier using Carry Save Adder
  assign aInput[N-1] = 1'b0;
  assign carryIn[0] = 1'b0;
  genvar k;
  generate
    for(k = 0; k < N; k = k+1)
      begin
        if(k == (N-1) )
          assign bInput[0][k] = ab[k][1];
        else
          begin
            assign aInput[k] = ab[k+1][0];
            assign bInput[0][k] = ab[k][1];
            assign carryIn[k+1] = ab[k][2];
          end
      end
  endgenerate
  //end of preparing inputs for the 1st row of the Multliplier using Carry Save Adder

  //instantiate 1st row
  FullAddrRow #(N) FullAdderRow1(.a(aInput),
                                 .b(bInput[0]),
                                 .carryIn((carryIn)),
                                 .sum(sum[0]),
                                 .carryOut(carryOut[0]));

  //adding inputs and outputs of 1st row in the pipeline
  assign pipeline[0].abPipeline = ab;
  assign pipeline[0].sumPipeline = sum[0];
  assign pipeline[0].carryOutPipeline = carryOut[0];
  assign pipeline[0].productPipeline = {sum[0][0], ab[0][0]};

  //generate intermediate rows from 2nd Row to 2nd last Row
  genvar x, y;
  generate
    begin
      for(x = 3; x < N; x = x+1)
        begin
          for(y = 0; y < N-1; y = y+1)
            begin
              assign bInput[x-2][y+1] = pipeline[x-3].abPipeline[y][x];
            end
          assign bInput[x-2][0] = 1'b0;

          always_ff@(posedge clock)
            begin
              pipeline[x-2].abPipeline <= pipeline[x-3].abPipeline;
              pipeline[x-2].sumPipeline <= sum[x-2];
              pipeline[x-2].carryOutPipeline <= carryOut[x-2];
              pipeline[x-2].productPipeline <= {sum[x-2][0], pipeline[x-3].productPipeline[x-2 : 0]};
            end

          FullAddrRow #(N) FullAdderRows(.a({pipeline[x-3].abPipeline[N-1][x-1], pipeline[x-3].sumPipeline[N-1 : 1]}),
                                         .b(bInput[x-2]),
                                         .carryIn((pipeline[x-3].carryOutPipeline)),
                                         .sum(sum[x-2]),
                                         .carryOut(carryOut[x-2]));
        end
    end
  endgenerate

  //generate last row of carrry save adder using FullAdder module instantiation
  assign carryLastRow[0] = 1'b0;
  genvar m;
  generate
    begin
      for(m = 0; m < N; m = m+1)
        begin
          if (m == (N-1))
            assign aInputLastRow[m] = pipeline[N-3].abPipeline[N-1][N-1];
          else
            assign aInputLastRow[m] = pipeline[N-3].sumPipeline[m+1];

          FullAdder FullAdderLastRow(.a(aInputLastRow[m]),
                                     .b(pipeline[N-3].carryOutPipeline[m]),
                                     .carryIn(carryLastRow[m]),
                                     .sum(sum[N-2][m]),
                                     .carryOut(carryLastRow[m+1]));
          always_ff@ (posedge clock)
            begin
              pipeline[N-2].abPipeline <= pipeline[N-3].abPipeline;
              pipeline[N-2].sumPipeline <= sum[N-2];
              pipeline[N-2].productPipeline <= {carryLastRow[N], sum[N-2], pipeline[N-3].productPipeline[N-2 : 0]};
              product <= pipeline[N-2].productPipeline;
            end

        end

    end
  endgenerate
endmodule

module FullAddrRow #(parameter N) (a, b, carryIn, sum, carryOut);
  input logic [N-1 : 0] a, b, carryIn;
  output logic [N-1 : 0] sum, carryOut;

  genvar i;
  generate
    begin
      for(i=0; i < N; i = i+1)
        FullAdder FA(.a(a[i]),
                     .b(b[i]),
                     .carryIn(carryIn[i]),
                     .sum(sum[i]),
                     .carryOut(carryOut[i]));
    end
  endgenerate
endmodule
