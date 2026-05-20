module main #(FPGAFREQ = 25_000_000)(
	input logic CLK,
	input logic nRST,
	input logic nPBTON,
	output logic [7:0] ndisp2,ndisp1,ndisp0);
	
	logic RST;
	logic PBTON;
	logic clkdiv0; //What is the period and frequency of the signal?
	logic [9:0] counter;
	logic [3:0] units, tens, hundreds;
	logic [7:0] disp2,disp1,disp0;
		
	assign RST = ~nRST;
	assign PBTON = ~nPBTON;
	
	///////////Bloque N1 ///////////////////////
	cntdiv_n #(FPGAFREQ) cntDiv0(CLK, RST, clkdiv0);
	
	/////////// Bloque N2////////////////////
	always_ff @(posedge clkdiv0, posedge RST)begin
		if(RST)begin
			counter <= 10'b00_0000_0000;
		end else begin
            // Hola
            if(PBTON)begin
                if(counter == 999)
                    counter <= 10'b00_0000_0000;
                else
                    counter <= counter + 1'b1;
            end else 
				counter <= counter;
		end
	end
	
	/////////// Bloque N3////////////////////
	always_comb begin
		units = 4'(counter % 10'd10);
		tens = 4'((counter / 10'd10)%10'd10);
		hundreds = 4'(counter / 10'd100);
	end
	
	
	/////////// Bloque N4////////////////////
	deco7seg_hexa dp0 (units, disp0);
	deco7seg_hexa dp1 (tens, disp1);
	deco7seg_hexa dp2 (hundreds, disp2);
	
	assign ndisp0 = ~disp0;
	assign ndisp1 = ~disp1;
	assign ndisp2 = ~disp2;

endmodule

module main_tb();
    // Parametros
    localparam CLK_PERIOD = 160ns;
    localparam cycles = 4;
    // Inputs
    logic clk, nrst, nbtn;
    // Outputs
    logic [7:0] ndispH, ndispT, ndispU;
    // Interno
    logic [11:0] i, j;

    main #(
        .FPGAFREQ(cycles)
    ) contador_u (
        .CLK(clk), .nRST(nrst), .nPBTON(nbtn),
        .ndisp2(ndispH), .ndisp1(ndispT), .ndisp0(ndispU)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        nrst = 0; nbtn = 1;
        @(posedge clk);
        nrst = 1;
        @(posedge clk);

        for(i = 0; i < 200; i++) begin
            nbtn = 0;
            for(j = 0; j < cycles; j++) @(posedge clk);
            nbtn = 1;
        end

        for(i = 0; i < 5*cycles; i++) @(posedge clk);

        nbtn = 0;
        for(i = 0; i < 800*cycles; i++) @(posedge clk);
        nbtn = 1;

        nrst = 0;
        @(posedge clk);

        $stop;
    end

endmodule
