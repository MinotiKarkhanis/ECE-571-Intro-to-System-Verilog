//Timeout counter testbench
module top();
reg Increment,ResetTimer,clk=1;
wire Timeout;

counter uut(
	.Increment(Increment),
	.ResetTimer(ResetTimer),
	.clk(clk),
	.Timeout(Timeout)
	);

always #5 clk=~clk;

initial 
	begin 
		ResetTimer=1'b1;
		#10 	ResetTimer=1'b0;
		repeat(40) @(posedge clk) Increment=1'b1;
		#10 	ResetTimer=1'b1;
	end
endmodule
