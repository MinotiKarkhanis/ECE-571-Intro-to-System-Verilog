package complexpkg;

//creating a user-defined data type for complex numbers
typedef struct {
  shortreal RealPart;
  shortreal ImaginaryPart;
} complex;

//Add two complex numbers, returning a complex number
function complex AddComplex(input complex M, N);
  complex Sum;
  Sum.RealPart = M.RealPart + N.RealPart;
  Sum.ImaginaryPart = M.ImaginaryPart + N.ImaginaryPart;
  return Sum;
endfunction

//Multiply two complex numbers, returning a complex number
function complex MultComplex(input complex M, N);
  complex Mul;
  Mul.RealPart = (M.RealPart * N.RealPart) - (M.ImaginaryPart * N.ImaginaryPart);
  Mul.ImaginaryPart = (M.RealPart * N.ImaginaryPart) - (N.RealPart * M.ImaginaryPart);
  return Mul;
endfunction

//Create and return a complex number from two shortreal components (real and imaginary)
function complex CreateComplex(input shortreal RealPart, ImaginaryPart);
  complex ComplexNumber;
  ComplexNumber.RealPart = RealPart;
  ComplexNumber.ImaginaryPart = ImaginaryPart;
  return ComplexNumber;
endfunction

//Accept a complex number and print its components using the format (r: number, i: number) where each component is a shortreal
function void PrintComplex(input complex C);
  $display("r: %0f, i: %0f", C.RealPart, C.ImaginaryPart);
endfunction

//Accept a complex number and return (as outputs) the components (real and imaginary)
function void ComplexToComponents(input complex C, output shortreal RealPart, ImaginaryPart);
  RealPart = C.RealPart;
  ImaginaryPart = C.ImaginaryPart;
endfunction

endpackage
