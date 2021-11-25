//Switchtail code
module switchtail(clk,out,rst);
  input clk,rst;
  output reg out;
  reg q1,q2,q3,q4;
    
  always@(posedge clk)
	begin
		if(rst)
			begin
        			q1<=0;
        			q2<=0;
        			q3<=0;
        			q4<=0;
        			out<=0;
			end
		else
			begin
				q1<=~out;
				q2<=q1;
				q3<=q2;
				q4<=q3;
				out<=q4;
			end
	end
endmodule