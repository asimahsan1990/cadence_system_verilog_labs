module mem_test ( 
                  mem_intf.tb mbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] rand_value;
int ok;
// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, i, debug);
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
    $display("random data test");
    for (int i = 0; i<32; i++)
      begin
        ok=randomize(rand_value) with {rand_value dist{[8'h41:8'h5a]:=4 , [8'h61:8'h7a]:=1};};
        mbus.write_mem (i, rand_value, debug);
        mbus.read_mem (i, rdata, debug);
        error_status = checkit (i, rdata, rand_value);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
// SYSTEMVERILOG: post-increment
     error_status++;
   end
// SYSTEMVERILOG: function return
   return (error_status);
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
