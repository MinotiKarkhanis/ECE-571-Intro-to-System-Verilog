module fsm(clk,Reset,Button,DoorOpen,DoorClosed,Obstacle,Timeout,RaiseDoor,LowerDoor,Increment,ResetTimer);
input clk,Reset,Button,DoorOpen,DoorClosed,Obstacle,Timeout;
output RaiseDoor,LowerDoor,Increment,ResetTimer;
reg RaiseDoor,LowerDoor,Increment,ResetTimer;

parameter
	DoorRaising = 4'b0001,
	StopRaising = 4'b0010,
	DoorClosing = 4'b0100,
	StopClosing = 4'b1000;

reg [3:0] State,NextState;

always @(posedge clk)
	begin
	if(Reset)
		State<=StopClosing;
	else
		State<=NextState;
	end

always@(State)
	begin
	case(State)
		DoorRaising:begin
 			RaiseDoor=1'b1;
			LowerDoor=1'b0;
			Increment=1'b1;
			ResetTimer=1'b0;
			end

		StopRaising:begin
 			RaiseDoor=1'b0;
			LowerDoor=1'b0;
			Increment=1'b0;
			ResetTimer=1'b1;
			end

		DoorClosing:begin
 			RaiseDoor=1'b0;
			LowerDoor=1'b1;
			Increment=1'b1;
			ResetTimer=1'b0;
			end

		StopClosing:begin
 			RaiseDoor=1'b0;
			LowerDoor=1'b0;
			Increment=1'b0;
			ResetTimer=1'b1;
			end
		
	endcase
	end

always @(State or Button or DoorOpen or DoorClosed or Obstacle or Timeout or Reset)
begin
case(State)
	DoorRaising: begin
		if (DoorOpen || Button || Timeout || Obstacle)
			NextState=StopRaising;
		else if(Reset)
			NextState=StopClosing;
		else
			NextState = DoorRaising;
		end

	StopRaising : begin 
		if (Button && (~Obstacle))
			NextState=DoorClosing;
		else if (Reset)
			NextState=StopClosing;
		else
			NextState=StopRaising;
		end

	DoorClosing : begin
		if (DoorClosed || Button || Timeout || Obstacle || Reset)
			NextState=StopClosing;
		else
			NextState = DoorClosing;
		end

	
	StopClosing: begin 
		if (Button && (~Obstacle) && (~DoorOpen))
			NextState=DoorRaising;
		else if(Button && (~Obstacle) && DoorOpen)
			NextState=DoorClosing;
		else
			NextState=StopClosing;
		end
	endcase
	end
endmodule




	

