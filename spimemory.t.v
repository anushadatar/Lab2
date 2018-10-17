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

  initial begin
      $dumpfile("spitest.vcd");
      $dumpvars();
      clk=0;sclk=0;cs_pin=1;mosi_pin=0;
      #500

      cs_pin = 0;

      // Give the 6 address from MSB to LSB
      for (i=0; i<7; i=i+1) begin
          mosi_pin = WRITE_ADDRESS[6-i]; #200
          sclk=1;#200
          sclk=0;
      end
      mosi_pin = 0; #100 // Specify the operation to be write
      sclk=1;#200
      sclk = 0;

      if (dut.memory.address != READ_ADDRESS) begin
        $display("Test failed. Address incorrect.");
        $display(dut.memory.address);
      end

      // Transmit the data to be written from MSB to LSB
      for (i=0; i<8; i=i+1) begin
          mosi_pin = DATA[7-i]; #200
          sclk=1; #200
          sclk = 0;
      end
      #100
      cs_pin = 1;


      #100
      cs_pin = 0;

      // Give the 6 address from MSB to LSB
      for (i=0; i<7; i=i+1) begin
          mosi_pin = READ_ADDRESS[6-i];#200
          sclk=1;#200
          sclk=0;
      end
      mosi_pin = 0; #100 // Specify the operation to be write
      sclk=1;#200
      sclk = 0;
      // Transmit the data to be written from MSB to LSB
      for (i=0; i < 8; i=i+1) begin
          mosi_pin = DATA[0]; #200
          // if (miso_pin != DATA[7-i]) begin #100
          //    $display("Test failed at bit i");
          // end
          sclk=1;#200
          sclk=0;
      end
      $finish;
  end
endmodule
