module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 11 reset = 0;
     # 1 start = 1;
     # 20000 $stop;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  wire [7:0] valuegray;
  wire [7:0] value;
  graycounter c1 (valuegray, clk, reset);
  counter c2 (value, clk, reset);

   logic     start = 0;

  int       fg,fb;
  int      i;

  always @(valuegray) begin
     if(start)
       for (i=0;i<8;i=i+1) begin
          $fwrite(fg,"%b\n",valuegray);
       end
  end

  always @(value) begin
     if(start)
       for (i=0;i<8;i=i+1) begin
          $fwrite(fb,"%b\n",value);
       end
  end

  initial
    begin
       fg = $fopen("graycounter.csv","w");
       fb = $fopen("counter.csv","w");
       $dumpfile("test.vcd");
       $dumpvars(0,test);
       #20100 $fclose(fg);
       #20100 $fclose(fb);


    end
endmodule // test
