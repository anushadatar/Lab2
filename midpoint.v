`include "inputconditioner.v"
`include "shiftregister.v"
/*
Integrates shift register and input conditioner to 
process and consider signal as expected.
*/
module midpoint
#(parameter width = 8)
(
  input clk,
  input btn,
  input[1:0] switch,
  input[width-1:0] parallelDataIn,
  output[width-1:0] led
);

  wire bttn_neg, c_sw0;
  wire peripheralClkEdge;

  inputconditioner conditionerBttn(.clk(clk), .noisysignal(btn), .conditioned(), .positiveedge(), .negativeedge(bttn_neg));
  inputconditioner conditionerSw0(.clk(clk), .noisysignal(switch[0]), .conditioned(c_sw0), .positiveedge(), .negativeedge());
  inputconditioner conditionerSw1(.clk(clk), .noisysignal(switch[1]), .conditioned(), .positiveedge(peripheralClkEdge), .negativeedge());

  shiftregister #(width) dut(.clk(clk), .peripheralClkEdge(peripheralClkEdge), .parallelLoad(bttn_neg),  .parallelDataIn(parallelDataIn),
                         .serialDataIn(c_sw0), .parallelDataOut(led), .serialDataOut());

endmodule
