module top();
reg clk=0,UnsynchInput;
wire SynchOutput;

edgedetector uut( 
		.clk(clk),
		.UnsynchInput(UnsynchInput),
		.SynchOutput(SynchOutput)
		);

always #10 clk=~clk;
initial 
begin 

	@(negedge clk) UnsynchInput=1'b0;
	@(negedge clk) UnsynchInput=1'b1;
	@(negedge clk) UnsynchInput=1'b1;
	@(negedge clk) UnsynchInput=1'b0;
	@(negedge clk) UnsynchInput=1'b1;
	#100;
	
	$finish;
end
endmodule
