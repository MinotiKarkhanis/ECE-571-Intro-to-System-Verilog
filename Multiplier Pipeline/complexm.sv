import complexpkg :: *; //wildcard import

module top();
  shortreal realPart1, realPart2, imaginaryPart1, imaginaryPart2;
  shortreal addRealPart, multRealPart, addImaginaryPart, multImaginaryPart;
  complex ComplexNum1, ComplexNum2, AddResult, MultResult;


  initial
    begin
      realPart1 = 15.345;
      realPart2 = 11.578;
      imaginaryPart1 = 6.526;
      imaginaryPart2 = 2.554;

      ComplexNum1 = CreateComplex(realPart1, imaginaryPart1);
      PrintComplex(ComplexNum1); //print 1st of complex number

      ComplexNum2 = CreateComplex(realPart2, imaginaryPart2);
      PrintComplex(ComplexNum2); //print 2nd of complex number

      AddResult = AddComplex(ComplexNum1, ComplexNum2);
      PrintComplex(AddResult); //print addition of complex numbers

      MultResult = MultComplex(ComplexNum1, ComplexNum2);
      PrintComplex(MultResult); //print multiplication of complex numbers

      ComplexToComponents(AddResult, addRealPart, addImaginaryPart); //convert addition result to real and imaginary part
      ComplexToComponents(MultResult, multRealPart, multImaginaryPart); //convert multiplication result to real and imaginary part

      if(($shortrealtobits(addRealPart) !== $shortrealtobits(AddResult.RealPart)) || ($shortrealtobits(addImaginaryPart) !== $shortrealtobits(AddResult.ImaginaryPart)))
        $display("***ERROR: Error in Addition");
      if(($shortrealtobits(multRealPart) !== $shortrealtobits(MultResult.RealPart)) || ($shortrealtobits(multImaginaryPart) !== $shortrealtobits(MultResult.ImaginaryPart)))
        $display("***ERROR: Error in Multiplication");
    end

endmodule
