
module mazeEscaper ( input logic [size-1:0] maze [size-1:0],
                     input logic             clk,
                     input logic             rst,
                     output logic done,
                     output logic [size-1:0] path [size-1:0]
                     );

   parameter size = 9;
   parameter N = 3;


   parameter FIND_START=0, FIND_STOP=1, VISIT=2, PICK_NEXT=3,MOVE=4,STOP=5,WASTE=6;


   parameter LEFT=0,RIGHT=1, DOWN=2, UP=3,NONE=4;

   logic [3:0]                               state;

   logic [N-1:0]                             x;
   logic [N-1:0]                             y;
   logic [N-1:0]                             sx;
   logic [N-1:0]                             sy;
   int                                       i;
   int                                       waste;

   initial begin
      for(i=0;i<size;i++)
        path[i] = '0;
   end

   //Keep track of direction
   logic [2:0] direction;

   //Implement wall follower right
   always_ff @(posedge clk or posedge rst) begin

      if(rst) begin
         state <= FIND_STOP;
         x  = 0;
         y = 0;
         sx = 0;
         sy = size-1;
         direction = DOWN;
         done = 0;
         waste = 0;


      end
      else begin
         case(state)
           FIND_STOP:
             if(maze[size-1][sx])
               sx++;
             else
               state <= FIND_START;
           FIND_START:
             if(maze[0][x])
               x++;
             else
               state <= WASTE;
           VISIT: begin
              path[y][x] = 1 ;

              if(sx == x && sy==y)
                state <= STOP;
              else
                state <= PICK_NEXT;
           end
           WASTE: begin
              // Let's waste some time just to get a bad result
              if(waste > 100)
                state <= VISIT;
              waste += 1;
           end
           PICK_NEXT: begin
              case(direction)
                LEFT: begin
                   if(~maze[y+1][x])
                     direction <= DOWN;
                   else if(~maze[y][x-1])
                     direction <= LEFT;
                   else if(~maze[y-1][x])
                     direction <= UP;
                   else if(~maze[y][x+1])
                     direction <= RIGHT;

                   else
                     direction <= NONE;
                end
                RIGHT: begin
                   if(~maze[y-1][x])
                     direction <= UP;
                   else if(~maze[y][x+1])
                     direction <= RIGHT;
                   else if(~maze[y+1][x])
                     direction <= DOWN;
                   else if(~maze[y][x-1])
                     direction <= LEFT;
                   else
                     direction <= NONE;
                end
                UP: begin
                   if(~maze[y][x-1])
                     direction <= LEFT;
                   else if(~maze[y-1][x])
                     direction <= UP;
                   else if(~maze[y][x+1])
                     direction <= RIGHT;
                   else if(~maze[y+1][x])
                     direction <= DOWN;
                   else
                     direction <= NONE;

                end
                DOWN: begin
                   if(~maze[y][x+1])
                     direction <= RIGHT;
                   else if(~maze[y+1][x])
                     direction <= DOWN;
                   else if(~maze[y][x-1])
                     direction <= LEFT;
                   else if(~maze[y-1][x])
                     direction <= UP;
                   else
                     direction <= NONE;
                end
              endcase // case (direction)
              state <= MOVE;
           end // case: PICK_NEXT
           MOVE: begin

              case(direction)
                LEFT:  x -=1;
                RIGHT: x +=1;
                UP:    y -=1;
                DOWN:  y +=1;
                NONE: x = x;
              endcase // case (direction)

              state <= VISIT;
           end // case: MOVE
           STOP: begin
              done <= 1;
           end
         endcase
      end // else: !if(rst)
   end // always_ff @ (posedge clk or posedge rst)









endmodule
