module datapath(	input logic clk, reset, we, 
						input logic enA, enB,enOut,
						input  logic [2:0] selALU,
						input logic [3:0] dataIn,
						input logic dataSrc,
						input logic [15:0] rInstr,
						output logic [3:0] rC);

	logic [2:0] dirA, dirB, dirC;
	logic [3:0] rOut, rA, rB, SrcA,SrcB, ALUresult;
	
	assign dirC = rInstr[10:8];
	assign dirA = rInstr[7:5];
	assign dirB = rInstr[4:2];
	
	regfile rf (clk, we, dirA, dirB, dirC, rC, rA, rB);
	flipflop #(4) Areg (clk, reset, enA, rA, SrcA);
	flipflop #(4) Breg (clk, reset, enB, rB, SrcB);
	
	alu alu(SrcA, SrcB, selALU, ALUresult);
	flipflop #(4) alureg(clk, reset, enOut, ALUresult, rOut);

	mux2 #(4) resmux (rOut, dataIn, dataSrc, rC);
endmodule