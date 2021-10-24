//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-10-24
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

module bcharger_tb;


   logic clk = 0;
   logic reset = 0;
   parameter integer clk_period = 1;
   always #clk_period clk=~clk;


   wire              trkl,fast,vconst,done;
   logic             vtrkl,vterm,iterm,vrchrg;

   bcharger fsm1(.trkl(trlk),
                    .fast(fast),
                    .vconst(vconst),
                    .done(done),
                    .vtrkl(vtrkl),
                    .vterm(vterm),
                    .iterm(iterm),
                    .vrchrg(vrchrg),
                    .clk(clk),
                    .reset(reset)
                    );


   parameter integer t_trkl = 10;
   parameter integer t_vterm = t_trkl + 5;
   parameter integer t_iterm = t_vterm  + 5;
   parameter integer t_recharge = t_iterm + 5;
   parameter integer sim_end = t_recharge  + 100;

   integer           count;

   always_ff @(posedge clk or posedge reset) begin

     if(reset) begin
        count = 0;
        vtrkl = 0;
        vterm = 0;
        iterm  =0;
        vrchrg = 0;
     end
     else begin
        if(count == t_trkl) begin
          vtrkl = 1;
        end
        if(count > t_vterm) begin
           vterm = 1;
        end
        if (count > t_iterm) begin
          iterm = 1;
        end
        if( count > t_recharge) begin
          vrchrg = 1;
           vterm = 0;
           iterm = 0;

        end

     end

   count  = count + 1;

end

initial begin

   reset = 1;
   clk = 0;


   #1  reset=0;


   $dumpfile("bcharger_tb.vcd");
   $dumpvars(0,bcharger_tb);

   #sim_end
     $stop;

end


endmodule
