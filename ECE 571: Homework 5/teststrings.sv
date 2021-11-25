import strings::*;
module top();
  string s,str;
  int i,j;

  initial begin 
    s="System Verilog strings";
	
	//Problem 8
    str=s.substr(-8,50);//out of bound index
    $display("%s",str);//returns an empty string if index is out of bound
	
	//Demonstrating Problem 9
    str=splice(s,-1,24); //i and j both out of bound
    $display("%s",str);
    str=splice(s,0,6); //i and j are valid index
    $display("%s",str);
    str=splice(s,-24,65);//i and j both out of bound
    $display("%s",str);
    str=splice(s,-7,5); //i out of bound
    $display("%s",str);
    str=splice(s,0,30);//j out of bound
    $display("%s",str);
    str=splice(s,0,14);//i and j are valid index
    $display("%s",str);
    
  end
endmodule