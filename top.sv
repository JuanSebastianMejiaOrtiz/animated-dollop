/*
 * This module is the TOP of the microarchitecture 
 */ 

module top #(parameter CYCLES=50_000_000) (
            input logic clk, nreset,
            output logic [7:0] ndisp0, ndisp1);
					
	logic reset;
	logic we, enA, enB, enOut, dataSrc;
	logic [2:0] selALU;
	logic [3:0] rC;
	logic [3:0] dataIn;
	logic [15:0] rInstr;
	
	assign reset = ~nreset;
		
	// Datapath unit instantiation
	datapath dp( clk, reset, we, enA, enB,enOut, selALU,
						dataIn, dataSrc, rInstr, rC);
						
endmodule

module tb_top;
	localparam CLK_PERIOD = 20ns;

   logic clk;
   logic nreset;
   logic [7:0] ndisp0, ndisp1;

   // Instancia del TOP
   top top_inst (clk, nreset, ndisp0, ndisp1);
	always #(CLK_PERIOD / 2) clk = ~clk;
	 
	initial begin
		clk = 1;
		nreset = 1;
		#(CLK_PERIOD);
		nreset = 0;
		#(CLK_PERIOD);
		nreset = 1;
		#(CLK_PERIOD*50);
		$stop;
	 end

endmodule
