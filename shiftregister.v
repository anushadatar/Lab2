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

    always @(posedge peripheralClkEdge) begin
        // Your Code Here
          shiftregistermem[0] <= serialDataIn;
          shiftregistermem[1] <= shiftregistermem[0];
          shiftregistermem[2] <= shiftregistermem[1];
          shiftregistermem[3] <= shiftregistermem[2];
          shiftregistermem[4] <= shiftregistermem[3];
          shiftregistermem[5] <= shiftregistermem[4];
          shiftregistermem[6] <= shiftregistermem[5];
          shiftregistermem[7] <= shiftregistermem[6];
          serialDataOut <= shiftregistermem[7];

          parallelDataOut[width-1:0] <= shiftregistermem[width-1:0];

//        if(parallelLoad == 1) // If trying to load, loading 'wins' over shift
//        begin

//        end
    end

    always @(posedge parallelLoad) begin
        shiftregistermem[width-1:0] <= parallelDataIn[width-1:0];
    end

endmodule
