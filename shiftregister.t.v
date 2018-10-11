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

    /*
    This test runs both modes of the shift register : Parallel In, serial Out
    and Serial In, Parallel Out. Use the run_test script for the shift register
    to view the waveforms and check that the data has loaded as expected 
    (shifted bit by bit for serial in with a full output for the corresponding
    paralleut and a full replacement for parallelin with the MSB reported for
    serialout). 
    */

    initial begin
      $dumpfile("shiftregister.vcd");
      $dumpvars(0, dut);

      serialDataIn = 1;
      #500
      parallelDataIn = 8'hAA;

      // Parallel In, Serial Out
      #100
      parallelLoad = 1;
      
      // Serial In, Parallel Out
      #100
      parallelLoad = 0;


    end

endmodule
