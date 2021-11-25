module top();

  bit [31:0] R;
  byte M[]={8'h1a,8'h1b,8'h1c,8'h1d,8'h12,8'h23,8'h45,8'h65};
  int address=0;

  initial begin 
    //Problem 1
    R={>>8{M[address+:4]}}; //>> operator used for big-endian
    $display("Big endian %h",R);

    //Problem 2
    R={<<8{M[address+:4]}}; //<< operator used for little-endian
    $display("Little endian %h",R);
  end
endmodule