`timescale 1ns / 1ps

module pwm #
(
    parameter integer COUNTER_WIDTH = 8
)
( 
    input  wire                         clk_i,
    input  wire                         s_rst_n_i,
	input  wire                         enable_i,
	
    inout  wire [COUNTER_WIDTH - 1 : 0] req_value_i,

    output wire                         channel_o	
);

    reg [COUNTER_WIDTH - 1 : 0] counter;
	
	
	assign channel_o = (req_value_i != counter) ? 1'h1 : 1'h0;
	
	always @ (posedge clk_i) begin
	    if (1'h0 == s_rst_n_i) begin
		    counter <= {COUNTER_WIDTH{1'h0}};
		end
		else if (1'h1 == enable_i) begin
		    counter <= counter + 1'h1;
		end
    end

endmodule