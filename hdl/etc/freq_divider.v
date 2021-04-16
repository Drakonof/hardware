`timescale 1ns / 1ps

module freq_divider #
(
    parameter integer DIVID_VALUE = 2
)
(
    input  wire clk_i,
    input  wire s_rst_n_i,
    
    output wire clk_o
);
    localparam integer COUNTER_WIDTH = $clog2(DIVID_VALUE);
    
    reg [COUNTER_WIDTH - 1 : 0] counter;
    
    assign clk_o = ({COUNTER_WIDTH{1'h0}} == counter) ? 1'h1 : 1'h0;

    always @ (posedge clk_i) begin
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
