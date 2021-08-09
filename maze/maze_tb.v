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

`timescale 1 ns / 1 ps

module maze_tb;

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

   // The size should be an odd number to ensure walls on both sides
   parameter size = `MAZE_SIZE;
   parameter N = $clog2(size);
   logic [size-1:0]      maze[size-1:0];
   wire [size-1:0]       path[size-1:0];
   logic                 done;
   wire [N-1:0]          px;
   wire [N-1:0]          py;



   mazeEscaper #(.size(size),.N(N)) me(maze, clk,rst,px,py,done,path);

   // Updated cycles everytime path changes
   int                   path_cycles = 0;
   int                   done_cycles = 0;
   logic                 pathIsWrong = 0;
   logic                 startIsCorrect = 0;
   logic                 endIsCorrect = 0;

   always @(px,py) begin
      if(fxy)
        $fwrite(fxy,"%d,%d\n",px,py);
   end

   genvar               i;
   for(i=0;i<size;i++) begin
      always @(path[i]) path_cycles = cycles;
   end

   always_ff @(posedge done) begin
      done_cycles = cycles;
      for(x=0;x<size;x++)
        pathIsWrong |= |(maze[x] & path[x]);

      startIsCorrect = maze[0] ^ ~path[0];
      endIsCorrect = maze[size-1] ^ ~path[size-1];
   end

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   int                   fd,fo,fp,fxy;
   int                   idx;
   int                   str;
   int                   x,y;
   initial
     begin



        //Load Maze
        fd = $fopen("maze.txt","r");
        idx = 0;
        while ($fscanf (fd, "%b\n", str, idx) == 1) begin
           maze[idx] = str;
           idx++;
        end

        fxy = $fopen("turtle.txt","w");

        $dumpfile("maze_tb.vcd");
        $dumpvars(0,maze_tb);
        //for(y=0;y<size;y++) begin
        //           $dumpvars(0,maze[y]);
        //        end


        fo = $fopen("path.txt","w");
        #sim_end
          for (y = 0; y<size; y=y+1) begin
             $fwrite(fo,"%b\n",path[y]);
          end

        #sim_end  begin
           fp = $fopen("result.yaml","w");
           $fwrite(fp,"path_cycles: %d\n",path_cycles);
           $fwrite(fp,"done_cycles: %d\n",done_cycles);
           $fwrite(fp,"pathIsWrong: %d\n",pathIsWrong);
           $fwrite(fp,"endIsCorrect: %d\n",endIsCorrect);
           $fwrite(fp,"startIsCorrect: %d\n",startIsCorrect);
           $fwrite(fp,"size: %d\n",size);
        end
        #sim_end $fclose(fd);
        #sim_end $fclose(fo);
        #sim_end $fclose(fxy);

        #sim_end
          $stop;



     end


endmodule
