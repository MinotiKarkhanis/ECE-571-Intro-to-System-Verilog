module top();
  parameter N = 8;
  logic [N-1:0] multiplicand, multiplier, a, b; //a and b to store multiplicand and multiplier coming out form the queue.
  bit clock;
  logic [2*N-1:0] product, expectedProduct;

  logic [N-1 : 0] multiplicandQ [$]; //multiplicand queue
  logic [N-1 : 0] multiplierQ [$]; //multiplier queue

  always #10 clock = ~clock;

  multiply #(N) mult(multiplicand, multiplier, product, clock);

  //generate exhaustive test cases for N bit operands
  initial
    begin
      for (int i = 0; i < 2**N; i = i+1)
        begin
          for (int j = 0; j < 2**N; j = j+1)
            begin
              @(negedge clock);
              multiplicand = i;
              multiplier = j;
              multiplicandQ.push_front(multiplicand);
              multiplierQ.push_front(multiplier);
            end
        end
    end

  //wait for N clocks for output ans then do self-checking
  initial
    begin
      repeat(N-1) @(negedge clock);

      while(multiplicandQ.size !== 0)
        begin
          @(negedge clock)
          a = multiplicandQ.pop_back();
          b = multiplierQ.pop_back();
          expectedProduct = a * b;

          if(expectedProduct !== product)
            $display("***ERROR : multiplicand = %0d, multiplier = %0d, product = %0d, expectedProduct = %0d", a, b, product, expectedProduct);

        end
      $finish();
    end

endmodule
