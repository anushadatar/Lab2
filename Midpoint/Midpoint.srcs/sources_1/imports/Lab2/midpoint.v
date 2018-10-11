`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
#(parameter width = 8)
(
  input clk,
  input btn,
  input[1:0] switch,
  input[width-1:0] parallelDataIn,
  output[width-1:0] led
);

  wire bttn_neg, c_sw0, c_sw1;
  wire peripheralClkEdge;

  inputconditioner conditionerBttn(.clk(clk), .noisysignal(btn), .conditioned(), .positiveedge(), .negativeedge(bttn_neg));
  inputconditioner conditionerSw0(.clk(clk), .noisysignal(switch[0]), .conditioned(c_sw0), .positiveedge(), .negativeedge());
  inputconditioner conditionerSw1(.clk(clk), .noisysignal(switch[1]), .conditioned(), .positiveedge(c_sw1), .negativeedge());

  shiftregister #(width) dut(.clk(clk), .peripheralClkEdge(switch[1]), .parallelLoad(bttn_neg),  .parallelDataIn(parallelDataIn),
                         .serialDataIn(switch[0]), .parallelDataOut(led), .serialDataOut());

endmodule
