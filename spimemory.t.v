`include "spimemory.v"

module spiMemoryTest();

reg clk, sclk, cs_pin, mosi_pin;
wire miso_pin;
integer i;
reg[7:0] READ_ADDRESS = 16'hA5;
reg[7:0] WRITE_ADDRESS = 16'hA4;
reg[7:0] DATA = 16'hA5;
wire[3:0] leds;
 
always begin #5 clk=0;sclk=0; #5 clk=1;sclk=0; #5 clk=0; sclk=1; #5 clk=1; sclk=1; end

spiMemory spi(clk, sclk, cs_pin, miso_pin, mosi_pin, leds);

initial begin
    $dumpfile("spitest.vcd");
    $dumpvars(0, clk, sclk, mosi_pin, miso_pin);
    cs_pin = 0;
    // Write values.
    for (i=0; i<7; i=i+1) begin
        #5 mosi_pin = WRITE_ADDRESS[i];
    end
    for (i=0; i<7; i=i+1) begin
        #5 mosi_pin = DATA[i];
    end
    #100
    // Read Values.
    for (i=0; i<7; i=i+1) begin
        #5 mosi_pin = READ_ADDRESS[i];
    end 
end 
endmodule
