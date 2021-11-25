module PulseGenerator(input Clock, input Reset, input ButtonAsynch, output Button);
logic FF1, FF2, FF3;

assign Button = FF2 & ~FF3;
always_ff @(posedge Clock)
begin
if (Reset)
	begin
	FF1 <= 1'b0; FF2 <= 1'b0; FF3 <= 1'b0;
	end
else
	begin
	FF1 <= ButtonAsynch;
	FF2 <= FF1;
	FF3 <= FF2;	
	end
end
endmodule