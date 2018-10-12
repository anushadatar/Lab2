//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output reg          serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    always @(posedge clk) begin
        // Your Code Here
          if (parallelLoad) begin
            shiftregistermem <= parallelDataIn; end
          else if (peripheralClkEdge) begin
          shiftregistermem[0] <= serialDataIn;
          shiftregistermem[1] <= shiftregistermem[0];
          shiftregistermem[2] <= shiftregistermem[1];
          shiftregistermem[3] <= shiftregistermem[2];
          shiftregistermem[4] <= shiftregistermem[3];
          shiftregistermem[5] <= shiftregistermem[4];
          shiftregistermem[6] <= shiftregistermem[5];
          shiftregistermem[7] <= shiftregistermem[6];
          serialDataOut <= shiftregistermem[7];
          end
          parallelDataOut <= shiftregistermem;
          serialDataOut <= shiftregistermem[7];
    end

endmodule
