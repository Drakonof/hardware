`timescale 1ns / 1ps

module gray_encode #
(
    parameter integer DATA_WIDTH = 8
)
(
    input  wire [DATA_WIDTH - 1 : 0] binary_value_i,
    output wire [DATA_WIDTH - 1 : 0] gray_value_o
);

    assign gray_value_o = binary_value_i ^ (binary_value_i >> 1);

endmodule