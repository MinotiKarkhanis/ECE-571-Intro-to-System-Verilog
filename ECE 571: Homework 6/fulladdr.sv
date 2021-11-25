module FullAdder(output S, CO, input A, B, CI);
assign #1 S = A ^ B ^ CI;
assign #1 CO = A & B | A & CI | B & CI;
endmodule