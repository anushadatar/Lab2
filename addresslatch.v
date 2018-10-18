module addresslatch(
  input[7:0]       d,
  input            ce,
  input            clk,
  output reg [6:0] q
  );

  always @ (posedge clk) begin
    if(ce)begin
      q <= d[6:0];
    end
  end

endmodule
