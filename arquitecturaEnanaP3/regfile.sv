/*
 * This module is the Register File of the Datapath Unit
 */
module regfile(input logic clk,
					input logic we,
					input logic [2:0] dirA, dirB, dirC,
					input logic [3:0] rC,
					output logic [3:0] rA, rB);
					
	// Internal signals
	logic [3:0] rf[7:0];
	
	// Three ported register file
	// Write third port on rising edge of clock
	always_ff @(posedge clk)
		if (we) rf[dirC] <= rC;
		
	assign rA = rf[dirA];
	assign rB = rf[dirB];

endmodule