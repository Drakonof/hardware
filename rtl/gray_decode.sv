`timescale 1ns / 1ps

module gray_decode #
(
    parameter integer DATA_WIDTH = 8
)
(
    input  logic [DATA_WIDTH - 1 : 0] gray_value_i,
    output logic [DATA_WIDTH - 1 : 0] binary_value_o
);

    always_comb begin
        binary_value_o = binary_value_o ^ (gray_value_i >> 1);
    end
	
endmodule