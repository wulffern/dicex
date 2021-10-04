`timescale 1 ns / 1 ps

module test;

  logic reset = 0;

  logic clk = 0;
  always #5 clk = !clk;

  logic [7:0] count;
  counter c1 (.out(count), .clk(clk), .reset(reset));

  initial
    begin
       $dumpfile("counter.vcd");
       $dumpvars(0,test);

       #10 reset = 1;
       #10 reset = 0;

       #2600 $stop;

    end
endmodule // test
