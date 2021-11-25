module FSM(input Clock, Reset, Button, Obstacle, Timeout, DoorUp, DoorDown, output logic RaiseDoor, LowerDoor, ResetTimer, Increment);


enum logic[3:0] {StopRaising = 4'b0001,
		 RaisingDoor = 4'b0010,
		 StopLowering = 4'b0100,
		 LoweringDoor = 4'b1000}State,NextState;


always_ff @(posedge Clock)
begin
if (Reset)
	begin
	if (DoorUp)
		State <= StopRaising;
	else
		State <= StopLowering;		// so first button press will raise!
	end
else
	State <= NextState;
end

always_comb
begin
NextState = State;
unique case (State)
	RaisingDoor:	if (DoorUp | Button | Timeout)
						NextState <= StopRaising;
	StopRaising:	if (Button & ~Obstacle)
						NextState <= LoweringDoor;
	LoweringDoor:	if (DoorDown | Button | Obstacle | Timeout)
						NextState <= StopLowering;
	StopLowering:	if (Button)
						NextState <= RaisingDoor;
endcase
end

always_comb 
begin
{RaiseDoor, LowerDoor, ResetTimer, Increment} = 4'b0;
unique case (State)
	RaisingDoor:	begin RaiseDoor = 1'b1; Increment = 1'b1; end
	StopRaising:	ResetTimer = 1'b1;
	LoweringDoor:	begin LowerDoor = 1'b1; Increment = 1'b1; end
	StopLowering:	ResetTimer = 1'b1;
endcase
end
endmodule
