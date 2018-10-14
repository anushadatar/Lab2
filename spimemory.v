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
  wire writeEn;
  wire[7:0] Din, Dout;
  wire[6:0] address;

  fsm fsm(.clk(clk), .sclk_pin(sclk_r), .cs_pin(cs_c), .r_or_w(writeEn), .addr_wr(addr_wr), .s_r(s_r), .dm_wr(dm_wr), .miso_en(miso_en));

  inputconditioner mosi_input(.clk(clk), .noisysignal(mosi_pin), .conditioned(mosi_c), .positiveedge(), .negativeedge());
  inputconditioner sclk_input(.clk(clk), .noisysignal(sclk_pin), .conditioned(), .positiveedge(sclk_r), .negativeedge(sclk_f));
  inputconditioner cs_input(.clk(clk), .noisysignal(cs_pin), .conditioned(cs_c), .positiveedge(), .negativeedge());

  datamemory memory(.clk(clk), .dataOut(Dout), .address(), .writeEnable(dm_wr), .dataIn(Din));

  shiftregister #(8) shift(.clk(clk),
                         .peripheralClkEdge(sclk_pin),
                         .parallelLoad(parallelLoad),
                         .parallelDataIn(Dout),
                         .serialDataIn(serialDataIn),
                         .parallelDataOut(Din),
                         .serialDataOut(serialDataOut));

endmodule
