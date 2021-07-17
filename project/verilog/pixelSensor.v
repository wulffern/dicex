
module pixelSensor(anaBias1, anaBias2, anaRamp, anaReset, pixErase, pixTx, pixData, pixRead);

   parameter real v_erase = 1.2;
   parameter real lsb = v_erase/255;
   parameter real dv_pixel = 0.5;


   input wire        anaBias1, anaBias2, anaRamp, anaReset;
   input wire        pixErase, pixTx, pixRead;
   inout wire [7:0]  pixData;

   real              tmp;
   reg              cmp;
   real              adc;

   reg[7:0]       p_data;

   initial begin
      tmp = 0;
      cmp =0;
   end

   // Reset the pixel value on pixRst
   always @(pixErase) begin
      tmp = v_erase;
      p_data = 0;
      cmp  = 0;
   end

   // Use anaBias1 to provide a clock for integration when pixTx is high
   always @(posedge anaBias1) begin
      if(pixTx)
        tmp = tmp - dv_pixel*lsb;
   end

   // Use anaRamp to provide a clock for ADC conversion, assume that anaRamp
   // and pixData is synchronous
   always @(posedge anaRamp) begin
      adc = adc + lsb;
      if(adc > tmp)
        cmp <= 1;
   end

   always @(posedge cmp) begin
      if(cmp) begin
         p_data <= pixData;
      end

   end

   // Assign data to bus when pixRead = 0
   assign pixData = pixRead ? p_data : 8'bZ;

endmodule // re_control
