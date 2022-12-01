virtual class counterclass;
  int counter;
  int min;
  int max;
  
  
  function new( int value, min, max);
    this.counter=value;
    this.min=min;
    this.max=max;
  endfunction
  
  function void check_limit(int val1,int val2);
    if(val1>val2)
      begin
        this.min=val2;
    	this.max=val1;
      end
    else
      begin
        this.min=val1;
    	this.max=val2;
      end
    
  endfunction
  
  function void check_set(int val);
    if (this.min<=val && this.max>=val)
      this.counter = val;
    else
      $display("value is out of range");
  endfunction
  
 
  function void load(int value);
    this.counter = value;
  endfunction

  function int get_counter(int value);
    return(this.counter);
  endfunction

endclass

class upcounter extends counterclass;
  bit carry;
  static int instance_count;
  function new(int value, int val1, int val2);
    super.new(value, val1, val2);
    this.carry=0;
    instance_count++;
  endfunction
  
  function string getval();
    return ($sformatf("%2d",counter));
  endfunction
  
  function void next();
    if(super.counter==max)
      begin
      super.check_set(min);
      this.carry=1;
      end
     else
       begin
       super.check_set(super.counter+1);
       this.carry=0;
       end
  endfunction
endclass


class downcounter extends counterclass;
  bit borrow;
  static int instance_count;
  function new(int value, int val1, int val2);
    super.new(value, val1, val2);
    this.borrow=0;
    instance_count++;
  endfunction
  
  function void next();
    if(super.counter==min)
      begin
      super.check_set(max);
      this.borrow=1;
      end
     else
       begin
       super.check_set(super.counter-1);
       this.borrow=0;
       end
  endfunction
endclass

class timer;
upcounter hours,minutes,seconds;
  function new (int hr=0,int min=0,int sec=0);
	hours   = new(hr,23,0);
    minutes = new(min,59,0);
    seconds = new(sec,59,0);
  endfunction
  
    function void load(input int unsigned hr, min, sec);
    hours.load(hr);
    minutes.load(min);
    seconds.load(sec);
  endfunction

  function void showval();
    $display("Timer display is %2d:%2d:%2d", hours.counter, minutes.counter, seconds.counter);
  endfunction

  function void next();
    seconds.next();
    if (seconds.carry == 1) begin
      minutes.next();
      if (minutes.carry == 1)
        hours.next();
    end
    showval();
  endfunction
  

  // extra method added for debug
  function string gettime();
    return ({hours.getval(),":",minutes.getval(),":",seconds.getval()});
  endfunction

  
endclass
module tb_top;
  timer t1;
  initial
    begin
      t1 = new();
      t1.showval();
      $display("Loading timer with 00:00:59");
      t1.load(0,0,59);
      t1.showval();
    end
endmodule


