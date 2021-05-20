`timescale 1ns / 1ps

module counter #
(
    parameter integer MAX_VALUE = 8
)
(
    input  wire                             clk_i,
    input  wire                             s_rst_n_i,
    input  wire                             enable_i,
          
    output wire [$clog2(MAX_VALUE) - 1 : 0] value_o
);
    localparam integer COUNTER_WIDTH = $clog2(MAX_VALUE);
    
    reg [COUNTER_WIDTH - 1 : 0] counter;

    assign value_o = counter;
    
    always @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            counter <= {COUNTER_WIDTH{1'h0}};
        end
        else if (1'h1 == enable_i) begin
            if (MAX_VALUE == counter) begin
               counter <= {COUNTER_WIDTH{1'h0}};
            end
            else begin
                counter <= counter + 1'h1;
            end   
        end
    end

endmodule
