module edgedetector(clk,UnsynchInput,SynchOutput);
input clk,UnsynchInput;
output reg SynchOutput;
reg SR0,SR1,SR2;


always @(posedge clk)
begin

	SR0<=UnsynchInput;
	SR1<=SR0;
	SR2<=SR1;
	SynchOutput <= SR1 & (~SR2);

end
endmodule

	



