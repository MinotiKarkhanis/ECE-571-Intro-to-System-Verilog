//Switchtail testbench
module top();
  reg clk=0,rst;
  wire out,q1,q2,q3,q4;
  
  switchtail uut(
    	.rst(rst),
    	.out(out),
    	.clk(clk),
	.q1(q1),
	.q2(q2),
	.q3(q3),
	.q4(q4)
  );
   
  always #10 clk=~clk;
  initial 
    begin
      rst<=1;
      #10
      rst<=0;
      #10
      #500
      $stop;
    end
      
endmodule
  
  