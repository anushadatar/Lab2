module addresslatch(
  input[7:0]       d,
  input            ce,
  input            clk,
  output reg [7:0] q
  );

  always @ (posedge clk) begin
    if(ce)begin
      q <= d;
    end
  end

endmodule
