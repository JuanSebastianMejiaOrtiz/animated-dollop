module control_unit (
    input logic reset, clk,
    input logic [15:0] rInstr,
    output logic we, enA, enB, enOut, enRI, enAI,
    output logic [2:0] selALU,
    output logic dataSrc
);

    logic [1:0] cycle, next_cycle;
    logic [1:0] CO;

    assign CO = rInstr[15:14];
    assign selALU = rInstr[13:11];  // pasa directamente la operacion a la ALU

    // Lógica de siguiente ciclo (máquina de estados simple)
    always_comb begin
        next_cycle = cycle;
        if (reset) begin
            next_cycle = 2'b00;
        end else begin
            case (CO)
                2'b00:   next_cycle = 2'b00;               // carga: 1 ciclo
                2'b01, 2'b10:                              // lógicas/aritméticas: 3 ciclos
                    if (cycle == 2'b10) next_cycle = 2'b00;
                    else next_cycle = cycle + 1'b1;
                2'b11:   next_cycle = 2'b00;               // arranque
                default: next_cycle = 2'b00;
            endcase
        end
    end

    // Registro del ciclo actual
    always_ff @(posedge clk) begin
        if (reset) cycle <= 2'b00;
        else       cycle <= next_cycle;
    end

    // Generación de señales de control (combinacional)
    always_comb begin
        // valores por defecto
        we = 1'b0; enA = 1'b0; enB = 1'b0;
        enOut = 1'b0; enRI = 1'b0; enAI = 1'b0; dataSrc = 1'b0;

        if (reset) begin
            enRI = 1'b1;   // carga la primera instrucción al salir de reset
        end else begin
            case (CO)
                2'b00: begin  // instrucción de carga (1 ciclo)
                    we = 1'b1;
                    enRI = 1'b1;
                    enAI = 1'b1;
                    dataSrc = 1'b1;
                end
                2'b01, 2'b10: begin  // instrucciones de 3 ciclos
                    case (cycle)
                        2'b00: begin enA = 1'b1; enB = 1'b1; end
                        2'b01: begin enOut = 1'b1; end
                        2'b10: begin we = 1'b1; enRI = 1'b1; enAI = 1'b1; end
                        // *No hace nada*
                        default: begin end
                    endcase
                end
                2'b11: begin  // instrucción de arranque
                    enRI = 1'b1;
                end
                // *No hace nada*
                default: begin end
            endcase
        end
    end
endmodule

/*
module control_unit(
    input logic reset, clk,
    input logic [15:0] rInstr,
    output logic we, enA, enB, enOut, enRI,
    output logic [2:0] selALU,
    output logic dataSrc
);
    logic [1:0] instCount, nextCount;
    logic [1:0] CO;

    assign selALU = rInstr[13:11];
    assign CO = rInstr[15:14];

    always_ff @(posedge clk) begin
        if (reset == 1'b1 | CO == 2'b11) begin
            {we, enA, enB, enOut, enRI, dataSrc} = 0;
            // Poner para que vuelva a la primera instruccion
            //
            // Esto podria ser mas bien en el reset del modulo donde se lee la
            // rom de instrucciones
        end
        else if (CO == 2'b00) begin
            enRI = 1'b1;
            enA = 1'b0;
            enB = 1'b0;
            enOut = 1'b0;
            dataSrc = 1'b1;
            we = 1'b1;
        end
        else begin
            if (instCount != 2'b11) begin
                // 01: Logicas
                if (CO == 2'b01) begin
                    case(selALU)
                        // AND, OR, XOR
                        3'b011, 3'b100, 3'b101: begin
                            if (instCount == 2'b00) begin
                                enRI    = 1'b0;
                                enA     = 1'b1;
                                enB     = 1'b1;
                                enOut   = 1'b0;
                                dataSrc = 1'b0;
                                we      = 1'b0;

                            end
                            else if (instCount == 2'b01) begin
                                enRI    = 1'b0;
                                enA     = 1'b0;
                                enB     = 1'b0;
                                enOut   = 1'b1;
                                dataSrc = 1'b0;
                                we      = 1'b0;
                            end
                            else begin
                                enRI    = 1'b1;
                                enA     = 1'b0;
                                enB     = 1'b0;
                                enOut   = 1'b0;
                                dataSrc = 1'b0;
                                we      = 1'b1;
                            end
                            nextCount = instCount + 1'b1;
                        end
                        default: begin
                            {we, enA, enB, enOut, dataSrc} = 0;
                            enRI = 1'b1;
                        end
                    endcase
                end
                // 10: Aritmeticas
                if (CO == 2'b10) begin
                    case(selALU)
                        // AND, OR, XOR
                        3'b011, 3'b100, 3'b101: begin
                            {we, enA, enB, enOut, dataSrc} = 0;
                            enRI = 1'b1;
                        end
                        default: begin
                            if (instCount == 2'b00) begin
                                enRI    = 1'b0;
                                enA     = 1'b1;
                                enB     = 1'b1;
                                enOut   = 1'b0;
                                dataSrc = 1'b0;
                                we      = 1'b0;

                            end
                            else if (instCount == 2'b01) begin
                                enRI    = 1'b0;
                                enA     = 1'b0;
                                enB     = 1'b0;
                                enOut   = 1'b1;
                                dataSrc = 1'b0;
                                we      = 1'b0;
                            end
                            else begin
                                enRI    = 1'b1;
                                enA     = 1'b0;
                                enB     = 1'b0;
                                enOut   = 1'b0;
                                dataSrc = 1'b0;
                                we      = 1'b1;
                            end
                            nextCount = instCount + 1'b1;
                        end
                    endcase
                end
            else begin
                nextCount = 2'b00;
                {we, enA, enB, enOut, dataSrc} = 0;
                enRI = 1'b1;
            end
        end
    end
endmodule
*/
