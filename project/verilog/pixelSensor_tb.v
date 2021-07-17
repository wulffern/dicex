


module pixelSensor_tb;


   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   reg clk =0;
   reg reset =0;
   parameter integer clk_period = 1;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   //------------------------------------------------------------
   // Pixel
   //------------------------------------------------------------
   parameter real    dv_pixel = 0.5;  //Set the expected photodiode current (0-1)

   //Analog signals
   wire              anaBias1;
   wire              anaBias2;
   wire              anaRamp;
   wire              anaReset;

   //Tie off the unused lines
   assign anaBias2 = 1;
   assign anaReset = 1;

   //Digital
   wire              pixErase;
   wire              pixTx;
   wire [7:0]        pixData;
   wire              pixRead;

   //Instanciate the pixel
   pixelSensor  #(.dv_pixel(dv_pixel))  ps1(anaBias1, anaBias2, anaRamp, anaReset, pixErase, pixTx, pixData,pixRead);


   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;
   reg               erase;
   reg               expose;
   reg               read;
   reg               convert;
   reg               convert_stop;

   reg [2:0]         state,next_state;   //States
   integer           counter;            //Delay counter in state machine

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 5;
   parameter integer c_read = 5;

   //Connect to the pixel
   assign pixRst = erase;
   assign pixTx = expose;
   assign pixRead = read;

   // Control the output signals
   always @(state) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read <= 0;
           expose <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read <= 0;
           expose <= 1;
        end
        CONVERT: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
        end
        READ: begin
           erase <= 0;
           read <= 1;
           expose <= 0;
        end
        IDLE: begin
           erase <= 0;
           read <= 0;
           expose <= 0;
        end
      endcase // case (state)
   end // always @ (state)

   // Control the state transitions
   always @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
                 convert = 1;
              end
           end
           CONVERT: begin
              if(convert_stop) begin
                 next_state <= READ;
                 state <= IDLE;
                 convert = 0;
              end
           end
           READ:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------

   reg[7:0] data;
   integer  val;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = pixTx ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign pixData = pixRead ? 8'bZ: data;

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus. Assert convert_stop to return control to main state machine.
   always @(posedge clk or reset) begin
      if(reset) begin
         convert_stop =0;
         data =0;
      end
      if(convert) begin
         data = val;
         val = val + 1;
      end
      else begin
         val = 0;
         convert_stop <= 0;
      end
      if(val == 256) begin
         convert_stop <= 1;
      end
   end // always @ (posedge clk or reset)

   //------------------------------------------------------------
   // Readout from pixelbus
   //------------------------------------------------------------
   reg [7:0] pixelDataOut;
   always @(posedge clk or reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else begin
         if(read)
           pixelDataOut <= pixData;
      end
   end

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelSensor_tb.vcd");
        $dumpvars(0,pixelSensor_tb);

        #sim_end
          $stop;
        #sim_end $finish;

     end

endmodule // test
