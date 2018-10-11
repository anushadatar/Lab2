//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;

    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));
    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
    
    /*
    Use gtkwave to visualize the signal output - 

    Clock Synchronization :
    The conditioned signal should be synchronized to the clock signal. 
    Debouncing : 
    The conditioned signal should not be disrupted by the included disruption.
    Edge Detection : 
    The posedge and negedge should be aligned with the conditioned signal's 
    positive and negative edges for a single clock pulse.
    */

    pin = 0;
    $dumpfile("inputconditioner.vcd");
    $dumpvars(0, dut);
    // Create signal on pin.
    pin=0; #153 pin=1; #284 pin=0; // Check for positiveedge and negativeedge

    // Debouncing Test - The conditioned signal should not be disrupted 
    // by this glitch.
    pin=0;#500
    repeat (5) begin
      #11 pin=1; #11 pin=0;
    end
    #50 pin=1; #100 pin=0;
    end
endmodule
