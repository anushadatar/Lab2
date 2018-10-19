/*
Finite state machine to handle SPI memory inputs and outputs 
as specified. Sets bits to read address, checks if bit is read or write,
and then sets bits to write or read accordingly.
*/

module fsm(
    input      clk,
    input      sclk_pin,
    input      cs_pin,
    input      r_or_w,
    output reg addr_wr,
    output reg s_r,
    output reg dm_wr,
    output reg miso_en
);

  reg[3:0] counter = 4'd15;

  always @ (posedge clk) begin
    if (!cs_pin) begin
      if(sclk_pin)begin
        counter <= counter + 1;
        case(counter)
          // Read address.
          4'd0: begin
            addr_wr <= 1'b1; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
          end
          // Characterize based on state.
          4'd6: begin
            addr_wr <= 1'b0;
            if(!r_or_w) begin
              s_r <= 1'b0; dm_wr <= 1'b1; miso_en <= 1'b0;
            end
            else begin
              s_r <= 1'b1; dm_wr <= 1'b0; miso_en <= 1'b1;
            end
          end
          // Complete operation accordingly.
          4'd15: begin
            addr_wr <= 1'b0; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
          end
          default: begin
            addr_wr <= addr_wr; s_r <= s_r; dm_wr <= dm_wr; miso_en <= miso_en;
          end
        endcase
      end
      // Set serial read as needed.
      if(counter==4'd7) begin
        if(s_r) s_r <= 0;
      end
    end
    // Account for chip select.
    if(cs_pin) begin
      counter <= 4'd15;
      addr_wr <= 1'b0; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
    end

  end

endmodule
