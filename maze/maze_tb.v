
`timescale 1 ns / 1 ps

module maze_tb;

   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic rst =0;
   int   cycles  =0 ;

   parameter integer clk_period = 1;
   parameter integer sim_end = clk_period*5000;
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
   wire [size-1:0]      path[size-1:0];
   logic                done;


   mazeEscaper #(.size(size),.N(N)) me(maze, clk,rst,done,path);

   // Updated cycles everytime path changes
   int                  path_cycles = 0;
   int                  done_cycles = 0;
   logic                pathIsWrong = 0;

   genvar               i;
   for(i=0;i<size;i++) begin
      always @(path[i]) path_cycles = cycles;
   end

   always_ff @(posedge done) begin
         done_cycles = cycles;
         for(x=0;x<size;x++)
           pathIsWrong |= |(maze[x] & path[x]);
   end


   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   int                   fd,fo,fp;
   int                   idx;
   int                   str;
   int              x,y;
   initial
     begin



        //Load Maze
        fd = $fopen("maze.txt","r");
        idx = 0;
        while ($fscanf (fd, "%b\n", str, idx) == 1) begin
           maze[idx] = str;
           idx++;
        end

        $dumpfile("maze_tb.vcd");
        $dumpvars(0,maze_tb);
        //for(y=0;y<size;y++) begin
//           $dumpvars(0,maze[y]);
//        end


        fo = $fopen("path.txt","w");
        #sim_end
          for (y = 0; y<size; y=x+1) begin
             for (x = 0; x<size; x=x+1)
               $fwrite(fo,"%b\n",path[x]);
          end

        #sim_end  begin
           fp = $fopen("result.yaml","w");
           $fwrite(fp,"path_cycles: %d\n",path_cycles);
           $fwrite(fp,"done_cycles: %d\n",done_cycles);
           $fwrite(fp,"pathIsWrong: %d\n",pathIsWrong);
           $fwrite(fp,"size: %d\n",size);
        end
        #sim_end $fclose(fd);
        #sim_end $fclose(fo);

        #sim_end
          $stop;



     end


endmodule
