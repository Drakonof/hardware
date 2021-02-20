`timescale 1ns / 1ps

module counter #
(
    parameter integer COUNTER_MAX_VALUE = 255
)
(
    input  logic                                     clk_i,
    input  logic                                     s_rst_n_i,
    input  logic                                     enable_i,
           
    output logic [$clog2(COUNTER_MAX_VALUE) - 1 : 0] value_o
);
    localparam integer COUNTER_WIDTH = $clog2(COUNTER_MAX_VALUE);
    
    logic [COUNTER_WIDTH - 1 : 0] counter;

    always_comb begin
        value_o = counter;
    end
    
    always_ff @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            counter <= {COUNTER_WIDTH{1'h0}};
        end
        else if (1'h1 == enable_i) begin
            if (COUNTER_MAX_VALUE == counter) begin// неявное приведение COUNTER_MAX_VALUE к COUNTER_WIDTH, насколько плохо?
               counter <= {COUNTER_WIDTH{1'h0}};
            end
            else begin
                counter <= counter + 1'h1;
            end   
        end
    end

endmodule
