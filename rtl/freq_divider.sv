`timescale 1ns / 1ps

module freq_divider #
(
    parameter integer DIVID_VALUE = 2
)
(
    input  logic clk_i,
    input  logic s_rst_n_i,
           
    output logic clk_o
);
    localparam integer COUNTER_WIDTH = $clog2(DIVID_VALUE);
    
    logic [COUNTER_WIDTH - 1 : 0] counter;
    
    always_comb begin
        clk_o = ({COUNTER_WIDTH{1'h0}} == counter) ? 1'h1 : 1'h0;
    end
    
    always_ff @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            counter <= DIVID_VALUE;
        end
        else begin
            if ({COUNTER_WIDTH{1'h0}} == counter) begin
                counter <= DIVID_VALUE;
            end
            else begin 
                counter <= counter - 1'h1;
            end
        end      
    end

endmodule
