//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-8-10
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================

module mazegen_tb;


   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic rst =0;
   int   cycles  =0 ;

   parameter integer clk_period = 1;
   parameter integer sim_end = clk_period*20000;
   always #clk_period clk=~clk;

   always @(posedge clk) begin
      if(cycles == 0)
        rst = 1;
      if(cycles == 1)
        rst = 0;
      cycles +=1;
   end


   logic [15:0] seed;
   parameter size = `MAZE_SIZE;
   parameter N = $clog2(size);

   tri [size-1:0] maze[size-1:0];
   tri             done;

   mazegen #(.size(size),.N(N)) mz(clk,rst,seed,done,maze);

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   int                   fd,fo,fp;
   int                   idx;
   int                   str;
   int                x,y;

   initial
     begin

        seed = `MAZE_SEED;

        $dumpfile("mazegen_tb.vcd");
        $dumpvars(0,mazegen_tb);


        fo = $fopen("maze.txt","w");
        #sim_end
          for (y = 0; y<size; y=y+1) begin
               $fwrite(fo,"%b\n",maze[y]);
          end

        #sim_end $fclose(fo);

        #sim_end
          $stop;



     end

endmodule
