`include "spimemory.v"

module spiMemoryTest();

  reg clk, sclk, cs_pin, mosi_pin;
  wire miso_pin;
  integer i;
  reg[6:0] READ_ADDRESS = 7'b1010101;
  reg[6:0] WRITE_ADDRESS = 7'b1010101;
  reg[7:0] DATA = 8'b10101010;
  wire[3:0] leds;

  spiMemory dut(clk, sclk, cs_pin, miso_pin, mosi_pin, leds);
  initial clk =0;
  always #5 clk = !clk;

  initial sclk =0;
  always #200 sclk = !sclk;

  initial begin
      $dumpfile("spitest.vcd");
      $dumpvars();
      cs_pin=1;mosi_pin=0;
      #800

      //cs_pin = 0;

      // Give the 6 address from MSB to LSB
      for (i=0; i<7; i=i+1) begin
          #400
          cs_pin = 0;
          mosi_pin = WRITE_ADDRESS[6-i];
      end
      #400
      mosi_pin = 0; // Specify the operation to be write

      if (dut.memory.address != READ_ADDRESS) begin
        $display("Test failed. Address incorrect.");
        $display(dut.memory.address);
      end

      // Transmit the data to be written from MSB to LSB
      for (i=0; i<8; i=i+1) begin
          #400
          mosi_pin = DATA[7-i];
      end

      #100
      cs_pin = 1;
      #400

      // Give the 6 address from MSB to LSB
      for (i=0; i<7; i=i+1) begin
          #400
          cs_pin = 0;
          mosi_pin = READ_ADDRESS[6-i];
      end
      #400
      mosi_pin = 1; #400 // Specify the operation to be read
      mosi_pin = 0;

      // Transmit the data to be written from MSB to LSB
      for (i=0; i<8; i=i+1) begin
          #400
          cs_pin = 0;
          mosi_pin = DATA[0];
      // end
      // for (i=0; i < 8; i=i+1) begin
      //     mosi_pin = DATA[0]; #200
          // if (miso_pin != DATA[7-i]) begin #100
          //    $display("Test failed at bit i");
          // end
          // sclk=1;#200
          // sclk=0;
          // for (i=0; i<20; i=i+1) begin
          //   sclk = 1; #200
          //   sclk = 0;
          // end
      // #2000
      end
      $finish;
  end
endmodule
