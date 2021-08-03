module mazegen(
               input logic             clk,
               input logic             rst,
               input logic [15:0]      seed,
               output logic            done,
               output logic [size-1:0] maze [size-1:0]
               );

   parameter size = 9;
   parameter N = 3;


   parameter UNVISIT_CELLS = 0,PICK_START_X = 1,PICK_START_Y = 2, ADD_WALL = 3 ;

   logic [3:0]                         state;
   logic [N-1:0]                    cell_x;
   logic [N-1:0]                    cell_y;

   // Maze max size set at 255
   logic [7:0]                         bitpos;


   wire [15:0]                         rnd;
   lfsr l1(rnd,clk,rst,seed);

   always_ff @(posedge clk or posedge rst) begin

      if(rst) begin
         cell_x <= 0;
         cell_y <= 0;
         bitpos <= 0;
         state <= UNVISIT_CELLS;

      end
      else begin

         case(state)

           UNVISIT_CELLS: begin
              if(cell_y < size) begin
                maze[cell_y] <= `MAZE_SIZE'bZ;
              cell_y++;
              end
              else begin
                state <= PICK_START_X;
                 cell_y = 0;

              end
           end
           PICK_START_X: begin
              if(bitpos < size) begin
                 cell_x[bitpos] = rnd[0];

                 //If cell position is larger than the cell_size, then stop
                 if(cell_x > N) begin
                    cell_x[bitpos] =0;
                    bitpos = size;
                 end
                 bitpos++;
              end
              else begin
                 if(cell_x == 0)
                   cell_x++;
                 else if(cell_x == size-1)
                   cell_x--;

                 state <= PICK_START_Y;
                 bitpos= 0;
              end
           end
           PICK_START_Y: begin
              if(bitpos < size) begin
                cell_y[bitpos] = rnd[0];
                  //If cell position is larger than the cell_size, then stop
                 if(cell_y > N) begin
                    cell_y[bitpos] =0;
                    bitpos = size;
                 end
                 bitpos++;
                 end
              else begin
                state <= ADD_WALL;
                 if(cell_y == 0)
                   cell_y++;
                 else if(cell_y == size-1)
                   cell_y--;

              end
           end
           ADD_WALL: begin
              maze[cell_y-1][cell_x] <= 1;
              maze[cell_y][cell_x-1] <= 1;
              maze[cell_y+1][cell_x] <= 1;
              maze[cell_y][cell_x+1] <= 1;
           end
         endcase

      end
   end



endmodule
