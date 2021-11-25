`include"edge.v"
`include"switchtail.v"
`include"timeout.v"
`include "fsm.v"

module GarageDoor(
input Clock,Reset,ButtonAsynch,Obstacle,DoorUp,DoorDown,
output RaiseDoor,LowerDoor);
wire out,ResetTimer,Increment,Timeout,Button1;

edgedetector edgeinitialise(
	.clk(Clock),
	.UnsynchInput(ButtonAsynch),
	.SynchOutput(Button1)
	);

switchtail switchinitialise(
	.clk(Clock),
	.rst(Reset),
	.out(out)
);

counter timeoutinitialise(

	.clk(out),
	.ResetTimer(ResetTimer),
	.Increment(Increment),
	.Timeout(Timeout)
);

fsm fsminitialise(
	.clk(Clock),
	.Reset(Reset),
	.Button(Button1),
	.Obstacle(Obstacle),
	.Timeout(Timeout),
	.DoorClosed(DoorDown),
	.DoorOpen(DoorUp),
	.RaiseDoor(RaiseDoor),
	.LowerDoor(LowerDoor),
	.Increment(Increment),
	.ResetTimer(ResetTimer)
);

endmodule


	

