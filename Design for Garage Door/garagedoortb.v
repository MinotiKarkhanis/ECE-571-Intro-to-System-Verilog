module top();
reg Clock,Reset,ButtonAsynch,Obstacle,DoorUp,DoorDown;
wire RaiseDoor,LowerDoor;

parameter CLOCK_CYCLE = 40;
parameter CLOCK_WIDTH = CLOCK_CYCLE/2;

GarageDoor uut(
	.Clock(Clock),
	.Reset(Reset),
	.ButtonAsynch(ButtonAsynch),
	.Obstacle(Obstacle),
	.DoorUp(DoorUp),
	.DoorDown(DoorDown),
	.RaiseDoor(RaiseDoor),
	.LowerDoor(LowerDoor)
);

initial 
begin 
Clock= 1'b0;
forever #CLOCK_WIDTH Clock = ~Clock;
end

initial 
begin
Reset=1'b1;
 @ (negedge Clock);
Reset = 1'b0;
end

initial
begin
 @ (negedge Clock)
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
 @ (negedge Clock)
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
 @ (negedge Clock)
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock)
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
repeat(6400)@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1100;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1110;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1101;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1001;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0000;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b0110;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown,Reset}=5'b00001;
@ (negedge Clock);
{ButtonAsynch,Obstacle,DoorUp,DoorDown}=4'b1000;
$stop;
end

endmodule
