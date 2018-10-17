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

  always @ (posedge sclk_pin) begin
    if (!cs_pin) begin
    counter <= counter + 1;
    case(counter)
      4'd0: begin
        addr_wr <= 1'b1; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
      end
      4'd6: begin
        addr_wr <= 1'b0;
        if(!r_or_w) begin
          s_r <= 1'b0; dm_wr <= 1'b1; miso_en <= 1'b0;
        end
        else begin
          s_r <= 1'b1; dm_wr <= 1'b0; miso_en <= 1'b1;
        end
      end
      //4'd8: begin
        //s_r <= 1'b0;
      //end
      4'd15: begin
        addr_wr <= 1'b0; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
      end
      default: begin
        addr_wr <= addr_wr; s_r <= s_r; dm_wr <= dm_wr; miso_en <= miso_en;
      end
    endcase
    end
    if(cs_pin) begin
      counter <= 4'd15;
      addr_wr <= 1'b0; s_r <= 1'b0; dm_wr <= 1'b0; miso_en <= 1'b0;
    end

  end

endmodule
