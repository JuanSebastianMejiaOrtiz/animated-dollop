module romd (
    input logic [2:0] addr,
    output logic [3:0] data
);
    always_comb begin
        /*
        case(addr)
            3'd0:  data = 4'b0000;
            3'd1:  data = 4'b0000;
            3'd2:  data = 4'b0000;
            3'd3:  data = 4'b0000;
            3'd4:  data = 4'b0000;
            3'd5:  data = 4'b0000;
            3'd6:  data = 4'b0000;
            3'd7:  data = 4'b0000;
        endcase
        */
        case (addr)
            3'd0: data = 4'd2;
            3'd1: data = 4'd3;
            3'd2: data = 4'd5;
            default: data = 4'd0;
        endcase
    end
endmodule
