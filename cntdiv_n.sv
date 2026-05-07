/*
module cntdiv_n #(parameter TOPVALUE = 50_000_000) (
    input logic clk, rst,
    output logic clkout
);
    logic [$clog2(TOPVALUE)-1:0] cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt <= 0;
            clkout <= 0;
        end else begin
            if (cnt == TOPVALUE - 1) begin
                cnt <= 0;
                clkout <= ~clkout;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule
*/
module cntdiv_n #(TOPVALUE = 50_000_000) (clk, rst, clkout);
	input logic clk, rst;
	output logic clkout;
	
	// counter register 
	localparam BITS = $clog2(TOPVALUE/2);
	logic [BITS - 1 : 0] rCounter;

	// increment or reset the counter
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			rCounter <= 0;
			clkout <= 0;
		end else begin
			rCounter <= rCounter + 1'b1;
			if (rCounter == TOPVALUE/2-1) begin
				clkout <= ~clkout;
				rCounter <= 0;
			end	
		end	
	end		
endmodule

module cntdiv_n_tb();
	localparam CLK_PERIOD = 20ns;
	logic CLK;
	logic RST;
	logic CLK_OUT_0, CLK_OUT_1, CLK_OUT_2;
	
	cntdiv_n #(4) Inst_cntdiv_n0(CLK,~RST,CLK_OUT_0); //What is the frequency of the CLK OUT_0 signal?
	cntdiv_n #(50) Inst_cntdiv_n1(CLK,~RST,CLK_OUT_1); //What is the frequency of the CLK OUT_1 signal?
	cntdiv_n #(100) Inst_cntdiv_n2(CLK,~RST,CLK_OUT_2); //What is the frequency of the CLK OUT_2 signal?
	
	initial begin
		CLK = 0;
		RST = 0;
		#(CLK_PERIOD * 2);
		RST = 1;
		#(CLK_PERIOD * 500);
		$stop;
	end
	
	always #(CLK_PERIOD / 2) CLK = ~CLK;
endmodule
