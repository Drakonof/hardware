`timescale 1ns / 1ps

module gray_coder #
(
    parameter integer DATA_WIDTH = 8
)
(
    input  logic [DATA_WIDTH - 1 : 0] binary_value_i,
    output logic [DATA_WIDTH - 1 : 0] gray_value_o
);
    
    always_comb begin
        gray_value_o = (binary_value_i >> 1) ^ binary_value_i;
    end
    
endmodule
