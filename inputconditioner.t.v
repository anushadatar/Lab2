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
    pin = 0;
    $dumpfile("inputconditioner.vcd");
    $dumpvars(0, dut);

    pin=0; #153 pin=1; #284 pin=0; // Check for positiveedge and negativeedge

    // Debouncing Test
    pin=0;#500
    repeat (5) begin
      #11 pin=1; #11 pin=0;
    end
    #50 pin=1; #100 pin=0;
    end
endmodule
