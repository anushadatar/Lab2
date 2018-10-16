`include "spimemory.v"

module spiMemoryTest();

reg clk, sclk, cs_pin, mosi_pin;
wire miso_pin;
integer i;
reg[6:0] READ_ADDRESS = 7'b0000011;
reg[6:0] WRITE_ADDRESS = 7'b0000011;
reg[7:0] DATA = 8'b10101010;
wire[3:0] leds;
 
spiMemory dut(clk, sclk, cs_pin, miso_pin, mosi_pin, leds);
initial clk =0;
always #5 clk = !clk;

initial begin
    $dumpfile("spitest.vcd");
    $dumpvars();
 
    cs_pin = 0; 

    // Give address values.
    for (i=0; i<7; i=i+1) begin
        #100
        sclk = 0; 
        mosi_pin = WRITE_ADDRESS[i]; #100
        sclk=1; 
    end

    if (dut.memory.address != READ_ADDRESS) begin
        $display("Test failed. Address incorrect.");
    end
    // Change the state to write.
    sclk = 0; mosi_pin = 0; #100
    sclk = 1; #100

    // Write data. 
    for (i=0; i<8; i=i+1) begin
        #100
        sclk = 0;
        mosi_pin = DATA[i]; #100
        sclk=1; 
    end
    #100
    cs_pin = 1;
    #100
    cs_pin = 0;

    // Give read values.
    for (i=0; i<7; i=i+1) begin
        #100
        sclk=0;
        mosi_pin = READ_ADDRESS[i];
        #100
        sclk=1; 
    end 
    
    // Set read.
    sclk=0; mosi_pin=0; #100
    sclk=1; #100

    for (i=0; i < 8; i=i+1) begin
        #100
        sclk=0;
        if (miso_pin != DATA[i]) begin
           $display("Test failed at bit i");
        end 
        #100
        sclk=1;
    end
    $finish();
end 
endmodule
