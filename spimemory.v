//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "fsm.v"
`include "shiftregister.v"
`include "inputconditioner.v"
`include "datamemory.v"
`include "addresslatch.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
  wire mosi_c, sclk_r, sclk_f, cs_c;
  wire addr_wr, s_r, dm_wr, miso_en;
  wire writeEn, serialDataOut;
  wire[7:0] Din, Dout;
  wire[6:0] address;

  fsm fsm(.clk(clk), .sclk_pin(sclk_r), .cs_pin(cs_c), .r_or_w(writeEn), .addr_wr(addr_wr), .s_r(s_r), .dm_wr(dm_wr), .miso_en(miso_en));

  addresslatch addresslatch(.clk(clk), .ce(addr_wr), .d(Din), .q(address));

  inputconditioner mosi_input(.clk(clk), .noisysignal(mosi_pin), .conditioned(mosi_c), .positiveedge(), .negativeedge());
  inputconditioner sclk_input(.clk(clk), .noisysignal(sclk_pin), .conditioned(), .positiveedge(sclk_r), .negativeedge(sclk_f));
  inputconditioner cs_input(.clk(clk), .noisysignal(cs_pin), .conditioned(cs_c), .positiveedge(), .negativeedge());

  datamemory memory(.clk(clk), .dataOut(Dout), .address(address), .writeEnable(dm_wr), .dataIn(Din));

  shiftregister #(8) shift(.clk(clk),
                         .peripheralClkEdge(sclk_r),
                         .parallelLoad(s_r),
                         .parallelDataIn(Dout),
                         .serialDataIn(mosi_c),
                         .parallelDataOut(Din),
                         .serialDataOut(serialDataOut));

  assign miso_pin = (miso_en) ? serialDataOut : 1'bz;

endmodule
