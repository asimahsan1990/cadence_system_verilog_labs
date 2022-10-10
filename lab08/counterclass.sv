class counterclass;
  int counter;
  
  function void load(int value);
    this.counter = value;
  endfunction

  function int get_counter(int value);
    return(this.counter);
  endfunction

  endclass


module tb_top;
  counterclass  c1=new;
  initial
    begin
      c1.load(20);
      $display("vlaue return = %d",c1.get_counter);
      $finish;
    end
  
  
endmodule

