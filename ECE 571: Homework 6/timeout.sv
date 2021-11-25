module Counter(input Clock, input Reset, input Increment, output Timeout);
parameter N = 4;
logic [N:0] Count;

assign Timeout = Count[N];
always_ff @(posedge Clock, posedge Reset)
begin
if (Reset)
	Count <= 0;
else
	begin
	if (Increment && ~Count[N])
		  Count <= Count + 1'b1;
	else
		Count <= Count;
	end
end
endmodule