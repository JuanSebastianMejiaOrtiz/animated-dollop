module instr_mem (
    input logic reset, clk, enRI, enAI,
    output logic [15:0] rInstr
);
    logic [3:0] addInstr, addNextInstr;
    logic [15:0] Instr;

    flipflop #(.WIDTH(4)) ffAddressInstr (
        .clk(clk), .reset(reset), .en(enAI),
        .d(addNextInstr), .q(addInstr)
    );

    flipflop #(.WIDTH(4)) ffAddressInstr (
        .clk(clk), .reset(reset), .en(enRI),
        .d(Instr), .q(rInstr)
    );

    romi romInstr_u (
        .addr(addInstr), .data(Instr)
    );

    assign addInstr = addNextInstr;

endmodule
