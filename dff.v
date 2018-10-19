/*
Flip-flop associated with the MISO pin - changes
output such that it can then be enabled/disabled by
the MISO Buffer enable to tri-state the buffer.
*/
module dff 
(
    input serialDataOut,
    input clockEnable,
    input clk,
    output reg dataOut
);

  always @(posedge clk) begin
    if (clockEnable==1) begin
        dataOut <= serialDataOut;
    end
  end
endmodule

