package SIMD;

//Problem 3
typedef union packed{
  bit [63:0][7:0]byte8;
  bit [31:0][15:0]word;
  bit [15:0][31:0]doubleword;
  bit [7:0][63:0]quadword;
  bit [15:0][31:0]SinglePrecisionFloat;
  bit [7:0][63:0]DoublePrecisionFloat;
}AVX512;

//Problem 4
function automatic void CopyToZMM (
  ref shortint unsigned operands[32],
  ref AVX512 ZMM);
  ZMM={>>{operands}};//copying operands to word in ZMM
endfunction

//Problem 5
function automatic void CopyFromZMM (
  ref  shortint unsigned results[32],
  ref AVX512 ZMM);
  results={>>{ZMM}}; //copying word from ZMM to results
endfunction

//Problem 6
function automatic void LoadZMM(
  ref byte M[], AVX512 ZMM, int address);
  bit[511:0]temp;
  temp={<<8{M[address+:64]}};
  ZMM={<<16{temp}};
endfunction

//Problem 7
function automatic void StoreZMM(
  ref byte M[], AVX512 ZMM, int address);
  bit[511:0]temp;
  temp={<<16{ZMM}};
  M[address+:64]={<<8{temp}};
endfunction

endpackage
