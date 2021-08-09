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


//Implementation of https://en.wikipedia.org/wiki/Maze_generation_algorithm "Iterative Implementation"

module mazegen(
               input logic             clk,
               input logic             rst,
               input logic [15:0]      seed,
               output logic            done,
               output logic [size-1:0] maze [size-1:0]
               );

   parameter size = 9;
   parameter N = 3;

   parameter cells = (size-1)/2;
   parameter O = $clog2(cells);

   //Calculate possible number of cells
   parameter M = cells*cells;
   logic [cells-1:0]                   visited [cells-1:0];

   parameter WAIT_LFSR = 0,
     UNVISIT_CELLS = 1,
     PICK_START = 2,
     CHECK_LEFT =3,
     CHECK_RIGHT=4,
     CHECK_UP = 5,
     CHECK_DOWN = 6,
     CHECK_NEXT = 7,
     VISIT=8,
     PICK_UNVISITED=9,
     POP=10,
     REMOVE=11,
     PUSH=12,
     DONE=13 ;

   logic [4:0]                         state;
   logic [4:0]                         next_state;

   //Current cell position
   logic [O-1:0]                       x;
   logic [O-1:0]                       y;


   //Temporary cell position
   logic [O-1:0]                       tx;
   logic [O-1:0]                       ty;


   //Maze position for current cell position
   tri [N-1:0]                         mx;
   tri [N-1:0]                         my;
   assign mx = x*2+1;
   assign my = y*2+1;

   //Next position on stack
   tri [O-1:0]                         nx;
   tri [O-1:0]                         ny;
   assign ny = stack[ptr][2*O:O];
   assign nx = stack[ptr][O-1:0];

   logic [2*O-1:0]                     stack[M:0];
   logic [$clog2(M)-1:0]               ptr;

   wire [15:0]                         rnd;
   lfsr l1(rnd,clk,rst,seed);

   byte                                count;
   parameter logic [1:0]               LEFT=0,RIGHT=1,UP=2,DOWN=3;
   logic [1:0]                         location;
   logic [1:0]                         locations[3:0];
   logic [2:0]                         n_locs;
   logic                               has_start;
   logic                               has_stop;

   always_ff @(posedge clk or posedge rst) begin

      if(rst) begin
         x <= 0;
         y <= 0;
         tx <= 0;
         ty <= 0;
         done <= 0;
         has_start = 0;
         has_stop = 0;
         location <= 0;
         ptr=0;
         count <= 0;
         state <= WAIT_LFSR;

      end
      else begin
         case(state)
           WAIT_LFSR: begin
              // Wait for LFSR to ensure it's filled up
              if(count < 16)
                count++;
              else begin
                 count = 0;
                 state <= UNVISIT_CELLS;
              end
           end
           UNVISIT_CELLS: begin
              if(count < cells ) begin
                 visited[count] = '0;
              end

              if(count < size) begin
                 maze[count] <= '1;
                 count++;
              end
              else begin
                 state <= PICK_START;
                 count = 0;
              end
           end
           PICK_START: begin
              ty = rnd[15:8] % O;
              tx = rnd[7:0] % O;
              next_state <= POP;
              state <= PUSH;
           end // case: PICK_START
           POP: begin
              if(ptr > 0) begin
                 x = nx;
                 y = ny;
                 ptr <= ptr -1;
                 state <= VISIT;
              end
              else
                state <= DONE;
           end
           VISIT: begin
              n_locs = 0;
              maze[my][mx] = 1'b0;
              visited[y][x] = 1;

              if(y == 0 & !has_start) begin
                 maze[my-1][mx] = 1'b0;
                 has_start <= 1;
              end

              if(y == cells-1 & !has_stop) begin
                 maze[my+1][mx] = 1'b0;
                 has_stop <= 1;
              end
              state <= CHECK_UP;
           end
           CHECK_UP: begin
              //Check if cell has unvisited neighbour
              if( y+1 < cells )
                if(!visited[y+1][x]) begin
                   locations[n_locs] = UP;
                   n_locs +=1;
                end
              state <= CHECK_DOWN;
           end
           CHECK_DOWN: begin
              if(y > 0)
                if(!visited[y-1][x]) begin
                   locations[n_locs] = DOWN;
                   n_locs +=1;
                end
              state <= CHECK_RIGHT;
           end
           CHECK_RIGHT: begin
              if(x+1 < cells)
                if(!visited[y][x+1]) begin
                   locations[n_locs] = RIGHT;
                   n_locs +=1;
                end
              state <= CHECK_LEFT;
           end
           CHECK_LEFT: begin
              if(x > 0)
                if(!visited[y][x-1]) begin
                   locations[n_locs] = LEFT;
                   n_locs +=1;
                end
              state <= CHECK_NEXT;
           end
           CHECK_NEXT: begin
              if(n_locs > 0) begin
                 tx = x;
                 ty = y;
                 state <= PUSH;
                 next_state <= PICK_UNVISITED;
                 location = locations[rnd % n_locs];
              end
              else
                state <= POP;
           end // case: VISIT
           PICK_UNVISITED: begin
              case(location)
                UP: begin
                   tx <= x;
                   ty <= y+1;
                   maze[my+1][mx] <= 1'b0;
                   state <= PUSH;
                   next_state <= POP;
                end
                DOWN: begin
                   tx <= x;
                   ty <= y-1;
                   maze[my-1][mx] <= 1'b0;
                   state <= PUSH;
                   next_state <= POP;
                end
                RIGHT: begin
                   tx <= x+1;
                   ty <= y;
                   maze[my][mx+1] <= 1'b0;
                   state <= PUSH;
                   next_state <= POP;
                end
                LEFT: begin
                   tx <= x-1;
                   ty <= y;
                   maze[my][mx-1] <= 1'b0;
                   state <= PUSH;
                   next_state <= POP;
                end
              endcase // case (location)
           end // case: PICK_UNVISITED
           PUSH: begin
              ptr = ptr + 1;
              stack[ptr][2*O-1:O] <= ty;
              stack[ptr][O-1:0] <= tx;
              state <= next_state;
           end
           DONE: begin
              done <= 1;
           end
         endcase


      end

   end



endmodule
