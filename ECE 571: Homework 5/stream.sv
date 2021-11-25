//importing SIMD package to demonstrate the code

import SIMD::*;
module top();
  AVX512 ZMM[31:0];
  byte M[];
  shortint unsigned operands[32], results[32];
  int i,j,address;

  initial begin 
    M='{5{8'h1a,8'h1b,8'h1c,8'h1d,8'h12,8'h13,8'h14,8'h15,8'h16,8'h17,8'h18,8'h19,8'h21,8'h22,8'h23,8'h24,8'h25,8'h26,8'h27,8'h28,8'h29,8'h31,8'h32,8'h33,8'h34,8'h35,8'h36,8'h37,8'h38,8'h39,8'h41,8'h42,8'h43,8'h44,8'h45,8'h46,8'h47,8'h48,8'h49,8'h51,8'h52,8'h53,8'h54,8'h55,8'h56,8'h57,8'h58,8'h59,8'h61,8'h62,8'h63,8'h64,8'h65,8'h66,8'h67,8'h68,8'h69,8'h71,8'h72,8'h73,8'h74,8'h75,8'h76,8'h77}};

    for(j=0;j<32;j++)
      begin
        operands[j]=$urandom;
      end

    CopyToZMM(operands,ZMM[i]); 
    $display("ZMM %p",ZMM[i]);

    CopyFromZMM(results,ZMM[i]);
    $display("Results %p",results);

    address=2;
    i=4;
    LoadZMM(M,ZMM[i],address);
    $display("ZMM after LoadZMM %h",ZMM[i]);
    address=100;
    StoreZMM(M,ZMM[i],address);
    $display("M after StoreZMM  %h",M[i]);

  end
endmodule