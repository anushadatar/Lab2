//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`include "shiftregister.v"
module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn;

    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk),
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad),
    		           .parallelDataIn(parallelDataIn),
    		           .serialDataIn(serialDataIn),
    		           .parallelDataOut(parallelDataOut),
    		           .serialDataOut(serialDataOut));

    initial peripheralClkEdge = 0;
    always #30 peripheralClkEdge=!peripheralClkEdge;
    initial parallelLoad = 0;

    initial begin
      $dumpfile("shiftregister.vcd");
      $dumpvars(0, dut);

      serialDataIn = 1;
      #500

      parallelDataIn = 8'hAA;

      #100
      parallelLoad = 1;
      #100
      parallelLoad = 0;


    end

endmodule
