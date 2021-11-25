module GarageDoor(input Clock, Reset, ButtonAsynch, Obstacle, DoorUp, DoorDown, output RaiseDoor, LowerDoor);
wire Button;
wire ResetTimer;
wire Timeout;
wire Increment;
wire ClockDiv10;

PulseGenerator PG(Clock, Reset, ButtonAsynch, Button);
SwitchTailRingCounter RTC(Clock, Reset, ClockDiv10);
Counter C(ClockDiv10, ResetTimer, Increment, Timeout);
FSM F(Clock, Reset, Button, Obstacle, Timeout, DoorUp, DoorDown, RaiseDoor, LowerDoor, ResetTimer, Increment);
endmodule