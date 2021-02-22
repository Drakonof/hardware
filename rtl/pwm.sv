`timescale 1ns / 1ps

module pwm #
(
    parameter integer PWM_COUNTER_WIDTH = 8
)
( 
    input  logic                             clk_i,
    input  logic                             s_rst_n_i,
	input  logic                             enable_i,
	
    inout  logic [PWM_COUNTER_WIDTH - 1 : 0] req_value_i,

    output logic                             channel_o	
);

    logic [PWM_COUNTER_WIDTH - 1 : 0] counter;
	
	always_comb begin
	    channel_o = (req_value_i != counter) ? 1'h1 : 1'h0;
	end
	
	always_ff @ (posedge clk_i) begin
	    if (1'h0 == s_rst_n_i) begin
		    counter <= {PWM_COUNTER_WIDTH{1'h0}};
		end
		else if (1'h1 == enable_i) begin
		    counter <= counter + 1'h1;
		end
    end

endmodule