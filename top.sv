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

    logic enRI, enAI;
    logic [2:0] addIn;
    logic clkdiv;
	logic [3:0] dec;
    logic [7:0] disp0, disp1;
	
	assign reset = ~nreset;
    assign addIn = rInstr[2:0];

    assign ndisp0 = ~disp0;
    assign ndisp1 = ~disp1;
		
	// Datapath unit instantiation
	datapath dp( clkdiv, reset, we, enA, enB,enOut, selALU,
						dataIn, dataSrc, rInstr, rC);

    // Instruction Memory unit instantiation
    instr_mem ins_mem_u (
        .reset(reset), .clk(clkdiv), .enRI(enRI), .enAI(enAI),
        .rInstr(rInstr)
    );

    // Data Memory unit instantiation
    romd dataROM (.addr(addIn), .data(dataIn));
						
    // Control unit instantiation
    control_unit control_u (
        .reset(reset), .clk(clkdiv), .rInstr(rInstr),
        .we(we), .enA(enA), .enB(enB), .enOut(enOut), .enRI(enRI), .enAI(enAI),
        .selALU(selALU), .dataSrc(dataSrc)
    );

    // Storing rC value
    flipflop #(.WIDTH(4)) rC_storage (
        .clk(clkdiv), .reset(reset), .en(we), .d(rC), .q(dec)
    );

   // Decoder for 7-Seg Screen unit instantiation
   Deco decoder_u (
       .S(dec), .DISP0(disp0), .DISP1(disp1)
   );

    // Clock Divider unit instantiation
    cntdiv_n #(
        .TOPVALUE(CYCLES)
    ) dividerClock_u (
        .clk(clk), .rst(reset), .clkout(clkdiv)
    );

endmodule

module tb_top;
	localparam CLK_PERIOD = 20ns;
    localparam CYCLES = 4;

   logic clk;
   logic nreset;
   logic [7:0] ndisp0, ndisp1;

   // Instancia del TOP
   top #(.CYCLES(CYCLES)) top_inst (clk, nreset, ndisp0, ndisp1);
	always #(CLK_PERIOD / 2) clk = ~clk;
	 
	initial begin
		clk = 1;
		nreset = 1;
		#(CLK_PERIOD * 10);
		nreset = 0;
		#(CLK_PERIOD * 10);
		nreset = 1;
		#(CLK_PERIOD * 300);
		$stop;
	 end

endmodule
