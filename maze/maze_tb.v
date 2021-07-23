
`timescale 1 ns / 1 ps

module maze_tb;

   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   int   cycles  =0 ;

   parameter integer clk_period = 1;
   parameter integer sim_end = clk_period*100;
   always #clk_period clk=~clk;

   always_ff @(posedge clk) begin
      if(cycles == 0)
        reset = 1;
      if(cycles == 1)
        reset = 0;
      cycles +=1;
   end



   // The size should be an odd number to ensure walls on both sides
   parameter size = 17;


   logic[15:0]             seed = `MAZE_SEED;
   wire [size-1:0]      maze[size-1:0];
   logic [size-1:0]      ideal_path [size-1:0];


   mazeGen #(.size(size)) mzgen(seed,reset,clk,done,maze[size:0],ideal_path[size:0]);


   integer          x,f,y;


   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin

        //for(y=0;y<8;y++)
        //mazes[y] = 8'hff;

        f = $fopen("maze.txt","w");


        $dumpfile("maze_tb.vcd");
        $dumpvars(0,maze_tb);
        for(y=0;y<8;y++) begin
           $dumpvars(0,maze[y]);
        end



        #sim_end
          for (y = 0; y<size; y=x+1) begin
            for (x = 0; x<size; x=x+1)
              $fwrite(f,"%b\n",maze[x]);

          end


        #sim_end $fclose(f);
        #sim_end
          $stop;



     end


endmodule
