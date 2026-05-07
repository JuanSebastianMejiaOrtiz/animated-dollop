// Pone todo en decimal con signo
module modulo_dec (
    input  logic [3:0] S,   
    output logic [7:0] DISP0,    
    output logic [7:0] DISP1     
);

    logic [3:0] magnitud;
    logic [3:0] valor_a_mostrar;

    always_comb begin
        if (S[3]) begin
            magnitud = ~S + 4'b0001; 
        end else begin
            magnitud = S;
        end
    end

    // ACTIVO ALTO
    // DISP[7] es dp (el punto)
    always_comb begin
        case (magnitud)
            4'h0: DISP0 = 8'b0011_1111; // 0
            4'h1: DISP0 = 8'b0000_0110; // 1
            4'h2: DISP0 = 8'b0101_1011; // 2
            4'h3: DISP0 = 8'b0100_1111; // 3
            4'h4: DISP0 = 8'b0110_0110; // 4
            4'h5: DISP0 = 8'b0110_1101; // 5
            4'h6: DISP0 = 8'b0111_1101; // 6
            4'h7: DISP0 = 8'b0000_0111; // 7
            4'h8: DISP0 = 8'b0111_1111; // 8
            4'h9: DISP0 = 8'b0110_0111; // 9
            4'hA: DISP0 = 8'b0111_0111; // A
            4'hB: DISP0 = 8'b0111_1100; // b
            4'hC: DISP0 = 8'b0011_1001; // C
            4'hD: DISP0 = 8'b0101_1110; // d
            4'hE: DISP0 = 8'b0111_1001; // E
            4'hF: DISP0 = 8'b0111_0001; // F
            default: DISP0 = 8'b0000_0000; // Apagado por defecto
        endcase
    end
	 
    always_comb begin
        if (S[3]) begin
            DISP1 = 8'b01000000; 
        end else begin
            DISP1 = 8'b00000000; 
        end
    end

endmodule












