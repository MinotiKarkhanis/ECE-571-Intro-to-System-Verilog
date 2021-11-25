//Problem 9
package strings;

function string splice(string s,int i,int j);

  if(i<0 || j>s.len()-1)
    begin
      splice=""; 
    end

  else
    begin
      splice={s.substr(0,i-1),s.substr(j+1,s.len()-1)}; 
    end
  return splice;

endfunction
endpackage