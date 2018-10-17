
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

