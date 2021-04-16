`timescale 1ns / 1ps

module gray_decode #
(
    parameter integer DATA_WIDTH = 8
)
(
    input  wire [DATA_WIDTH - 1 : 0] gray_value_i,
    output wire [DATA_WIDTH - 1 : 0] binary_value_o
);

    assign binary_value_o = binary_value_o ^ (gray_value_i >> 1);
	
endmodule
