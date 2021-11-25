//Timeout counter testbench
module counter(Increment,ResetTimer,Timeout,clk);
input Increment,ResetTimer,clk;
output reg Timeout;
wire [3:0]Q,J,K;

jk jk0 (
	.j(Increment),
	.k(Increment),
	.clk(clk),
	.rst(ResetTimer),
	.q(Q[0])
	);
	
jk jk1 (
	.j(J[1]),
	.k(K[1]),
	.clk(clk),
	.rst(ResetTimer),
	.q(Q[1])
	);
	
jk jk2 (
	.j(J[2]),
	.k(K[2]),
	.clk(clk),
	.rst(ResetTimer),
	.q(Q[2])
	);
	
jk jk3 (
	.j(J[3]),
	.k(K[3]),
	.clk(clk),
	.rst(ResetTimer),
	.q(Q[3])
	);
	
	
assign J[1]=Q[0];
assign K[1]=Q[0];
assign J[2]=Q[0]&Q[1];
assign K[2]=Q[0]&Q[1];
assign J[3]=Q[0]&Q[1]&Q[2];
assign K[3]=Q[0]&Q[1]&Q[2];

always@(posedge clk,negedge ResetTimer)
	begin
		if(ResetTimer)
			begin
				Timeout<=1'b0;
			end
	
		else if(Q[0]&&Q[1]&&Q[2]&&Q[3])
			begin 
				Timeout<=1'b1;
			end
		
		else 
			Timeout<=Timeout;
	end
	
endmodule
  
module jk(q,clk,j,k,rst);
  input j,k,clk,rst;
  output reg q;
  
  always@(posedge clk)
    begin
	if (rst)
   		q<=1'b0;
	else
		begin
      			case ({j,k})
				2'b00 : q<=q;
				2'b11 : q<=~q;
     			endcase
		end
	end
        
 endmodule