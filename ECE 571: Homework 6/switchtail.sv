module SwitchTailRingCounter(input Clock, input Reset, output ClockDiv10);
parameter N = 5;	// decade divider
logic [N-1:0] R;

assign ClockDiv10 = R[N-1];
always_ff @(posedge Clock)
begin
if (Reset)
	R <= 0;
else
	R <= {~R[0],R[N-1:1]};
end
endmodule