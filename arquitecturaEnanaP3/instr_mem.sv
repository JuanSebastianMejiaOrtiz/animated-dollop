module instr_mem (
    input logic reset, clk, enRI, enAI,
    output logic [15:0] rInstr
);
    logic [3:0] pc;            // Program Counter (4 bits para 16 instrucciones)
    logic [15:0] instr_from_rom;

    // Contador de programa (se incrementa cuando enAI = 1)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (enAI)
            pc <= pc + 1;
    end

    // ROM de instrucciones (combinacional)
    romi rom_inst (
        .addr(pc),
        .data(instr_from_rom)
    );

    // Registro de instrucción (se carga cuando enRI = 1)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            rInstr <= 0;
        else if (enRI)
            rInstr <= instr_from_rom;
    end
endmodule
/*
module instr_mem (
    input logic reset, clk, enRI, enAI,
    output logic [15:0] rInstr
);
    logic [3:0] addInstr, addNextInstr;
    logic [15:0] Instr;

    flipflop #(.WIDTH(4)) ffAddressInstr1 (
        .clk(clk), .reset(reset), .en(enAI),
        .d(addNextInstr), .q(addInstr)
    );

    flipflop #(.WIDTH(4)) ffAddressInstr2 (
        .clk(clk), .reset(reset), .en(enRI),
        .d(Instr), .q(rInstr)
    );

    romi romInstr_u (
        .addr(addInstr), .data(Instr)
    );

    assign addInstr = addNextInstr;

endmodule
*/
