module main #(FPGAFREQ = 50_000_000) (
    input  logic CLK,
    input  logic nRST,  // reset
    input  logic [1:0] swt, //programación del modo
    input  logic nPBTON, // boton de programación de la hora
    output logic [7:0] ndisp5, ndisp4, ndisp3, ndisp2, ndisp1, ndisp0
);

    // Señales internas
    logic RST,PBTON;
    logic clkdiv0;
    logic clkdiv1;
    logic [4:0] counterhh;
    logic [5:0] countermm;
    logic [5:0] counterss;
    logic [3:0] unitsH, tensH, unitsM, tensM, unitsS, tensS;
    logic [7:0] disp5, disp4, disp3, disp2, disp1, disp0;

    // Reset activo alto
    assign RST = ~nRST;
	 assign PBTON = ~nPBTON;

    // División del reloj (1 Hz)
    cntdiv_n #(FPGAFREQ) cntDiv0 (
        .clk(CLK),
        .rst(RST),
        .clkout(clkdiv0)
    );

    // División del reloj(0.5 Hz)
    cntdiv_n #(FPGAFREQ/2) cntDiv1 (
        .clk(CLK),
        .rst(RST),
        .clkout(clkdiv1)
    );

    // Carga de datos desde switches en el reset
    always_ff @(posedge clkdiv1 or posedge RST) begin
        if (RST) begin
            counterhh <= 5'b00000;           // Horas (5 bits)
            countermm <= 6'b000000;          // Minutos (6 bits)
            counterss <= 6'b000000;          // Segundos (6 bits)

            // Validación de rango
        end else begin
            // Incremento normal del reloj
				
				
				if (PBTON) begin
				    case (swt) 
					    2'b00: begin
						      counterhh <= counterhh;
								countermm <= countermm;
								counterss <= counterss;
						   end
					    2'b01: begin
						      if (counterhh == 5'b10111)
                        counterhh <= 5'b00000;
                        else
                        counterhh <= counterhh + 5'b00001;
								//
								countermm <= countermm;
								counterss <= counterss;
						   end  
						2'b10: begin
						      counterhh <= counterhh;
								if (countermm == 6'b111011)
								  countermm <= 6'b000000;
								else
								  countermm <= countermm + 6'b000001;
								//
								counterss <= counterss;
						   end	
						 2'b11: begin
						      counterhh <= counterhh;
								countermm <= countermm;
								if (counterss == 6'b111011)
								  counterss <= 6'b000000;
								else
								counterss <= counterss + 6'b000001;
						   end	
							default: begin
						      counterhh <= counterhh;
								countermm <= countermm;
								counterss <= counterss;
						   end
						endcase
				  end
				else if (swt == 2'b00 & clkdiv0) begin 
					if (counterss == 6'b111011) begin
						 counterss <= 6'b000000;
						 
						 if (countermm == 6'b111011) begin
							  countermm <= 6'b000000;
							  if (counterhh == 5'b10111)
									counterhh <= 5'b00000;
							  else
									counterhh <= counterhh + 5'b00001;
						 end else begin
							  countermm <= countermm + 6'b000001;
						 end
					end else begin
						 counterss <= counterss + 6'b000001;
					end
			  end
        end
    end

    // Conversión para displays (BCD simple)
    always_comb begin
        // Horas
        unitsH    = 4'(counterhh % 5'd10);
        tensH     = 4'((counterhh / 5'd10));
        // Minutos
        unitsM = 4'(countermm % 6'd10);
        tensM       = 4'(countermm / 6'd10);
        // Segundos
        unitsS = 4'(counterss % 6'd10);
        tensS = 4'((counterss / 6'd10));
    end

    // Lógica de decodificación para 7 segmentos
    deco7seg_hexa dp0(tensH,    disp0);
    deco7seg_hexa dp1(unitsH,     disp1);
    deco7seg_hexa dp2(tensM, disp2);
    deco7seg_hexa dp3(unitsM,       disp3);
    deco7seg_hexa dp4(tensS,       disp4);
    deco7seg_hexa dp5(unitsS,       disp5);

    // Inversión para cátodo común
    assign ndisp5 = ~disp0; // Segundos
    assign ndisp4 = ~disp1; // Segundos
    assign ndisp3 = ~disp2; // Minutos
    assign ndisp2 = ~disp3; // Minutos
    assign ndisp1 = ~disp4; // Horas
    assign ndisp0 = ~disp5; // Horas

endmodule

`timescale 1ns/1ps

module testbench();
    // Parámetro de periodo de reloj
    localparam CLK_PERIOD = 20ns; // 6.25 MHz

    // Señales
    logic CLK;
    logic nRST;
	 logic [1:0] swt;
	 logic nPBTON;
	 logic [7:0] ndisp5, ndisp4, ndisp3, ndisp2, ndisp1, ndisp0;
	 
	 // unidad bajo test
	 main #(8) utt(CLK, nRST, swt, nPBTON, ndisp5, ndisp4, ndisp3, ndisp2, ndisp1, ndisp0); 

    // Generación del reloj de 50 MHz
    initial CLK = 1'b0;
	 always #(CLK_PERIOD / 2) CLK = ~CLK;

    // Estímulos de prueba
    initial begin
        nRST = 1; nPBTON = 1;
        swt = 2'b01;
        #(CLK_PERIOD * 2);

        nRST = 0;
        #(CLK_PERIOD * 2);

        nRST = 1;
        nPBTON = 0;
        #(CLK_PERIOD * 40);

        swt = 2'b10;
        #(CLK_PERIOD * 80);

        swt = 2'b11;
        #(CLK_PERIOD * 80);
        
        nPBTON = 1;
        swt = 2'b00;
        #(CLK_PERIOD * 100000); // Mayor tiempo para ver conteo

        $stop;
    end
endmodule
