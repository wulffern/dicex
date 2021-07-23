



module mazeGen (input logic[15:0] seed,
                input logic             reset,
                input logic             clk,
                output logic            done,
                output logic [size-1:0] maze [size-1:0],
                output logic [size-1:0] path [size-1:0]
                );

   parameter size = 8;
   parameter M = size/2-1;



   logic [15:0]                         lfsr_out;
   lfsr lf1(lfsr_out,clk,reset,seed);


   /* Algorithm
    1. Randomly select a node (or cell) N.
    2. Push the node N onto a stack Q.
    3. Mark the cell N as visited.
    4. Randomly select an adjacent cell A of node N that has not been visited. If all the neighbors of N have been visited:
       - Continue to pop items off the queue Q until a node is encountered with at least one non-visited neighbor - assign this node to N and go to step 4.
       - If no nodes exist: stop.
    5. Break the wall between N and A.
    6. Assign the value A to N.
    Go to step 2.
    */

   // Positions in the array
   logic [$clog2(M)-1:0]    Nx;
   logic [$clog2(M)-1:0]    Ny;

   stack #(.WIDTH($clog2(M)-1),.DEPTH(M)) stack_x(clk,reset,pop,push,empty,full,Nx,Nx_out);
   stack #(.WIDTH($clog2(M)-1),.DEPTH(M)) stack_y(clk,reset,pop,push,empty,full,Ny,Ny_out);

   parameter IDLE = 0,PICK_START =1, ADD_TO_Q=2, MARK_AS_VISITED=3, SELECT_NEIGHBOUR=4, BREAK_WALL=5, NEW_N = 6;

   logic [2:0] state;


   logic [$clog2(M)-1:0] Ax;
   logic [$clog2(M)-1:0] Ay;

   // Positions
   genvar                j;

   logic [$clog2(size)-1:0] start_x;
   logic [$clog2(size)-1:0] start_y;


   logic [M:0] visited [M:0];

   int         idx;
   int         count;


   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         idx = 0;
         count =0;

         // Fill maze with walls
         for(idx=0;idx<size;idx++)
             maze[idx] = '1;
         state <= IDLE;
      end
      else begin
         case(state)
           IDLE: begin
              if(count > 5) begin
                 state <= PICK_START;
              end
              else
                count++;
           end
           PICK_START: begin
              Nx = lfsr_out;
              Ny = lfsr_out >> 5 ;
              start_x = Nx*2;
              start_y = Ny*2;
              maze[start_y][start_x] = 0;
              state <= ADD_TO_Q;
           end
           ADD_TO_Q: begin

           end
           MARK_AS_VISITED: begin

           end
           SELECT_NEIGHBOUR: begin

           end
           NEW_N: begin

           end
         endcase

      end
   end


endmodule
