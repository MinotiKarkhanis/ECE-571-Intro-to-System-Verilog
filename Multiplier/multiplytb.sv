module top();
  parameter N = 16;
  logic [N-1:0] multiplicand, multiplier;
  logic [2*N-1:0] product;
  integer expectedProduct, i;

  multiply #(N) m1(multiplicand, multiplier, product);

  initial
    begin

      //directed testcases
      multiplier = 16'b1111111111111111; //65535 in decimal
      multiplicand = 16'b1111111111111111; // 65535 in decimal
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();

      multiplier = '0;
      multiplicand = '0;
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();

      multiplier = 16'b1101100111001101;
      multiplicand = 16'b1110101101101101;
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();

      multiplier = 7777;
      multiplicand = 7777;
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();

      multiplier = 5428;
      multiplicand = 2345;
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();

      multiplier = 8643;
      multiplicand = 23549;
      expectedProduct = multiplier * multiplicand;
      #500;
      SelfChecking();
      //end of directed testcases


      //random multiplier and multiplicand generation
      for (i=0; i<500; i=i+1)
        begin
          multiplicand=$urandom_range(65000, 0);
          multiplier=$urandom_range(65000, 0);
          expectedProduct = multiplier * multiplicand;
          #500;
          SelfChecking();
        end
    end

  task SelfChecking();
    if(product !== expectedProduct)
      $display("*** Error: Multiplicand = %0d, Multiplier = %0d, Product = %0d, ExpectedProduct = %0d", multiplicand, multiplier, product, expectedProduct);
  endtask

endmodule
