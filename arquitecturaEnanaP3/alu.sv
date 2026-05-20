/*
 * This module is the ALU of the Datapath Unit
 */ 
module alu (A, B, selALU, result);

	input  logic [3:0] A, B;
   input  logic [2:0] selALU;
   output logic [3:0] result;
	 
	always_comb begin
		case(selALU)
			3'b000: begin
				result = A + B;
			end
			3'b001: begin
				result = A + (~B + 4'b00001);
			end
			3'b010: begin
				result = B + 4'b1111;
			end
			3'b011: result = A & B;
			3'b100: result = A | B;
			3'b101: result = A ^ B;
			3'b110: begin
				result = A << 1;
			end
			3'b111: begin
				result = B;
			end
			default: result = 0;
		endcase
	end
endmodule