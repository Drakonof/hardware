`timescale 1ns / 1ps


module mux_2 # 
(
    parameter integer DATA_WIDTH = 1
)
( 
    input  wire                      select_i,
    input  wire [DATA_WIDTH - 1 : 0] data_0_i,
    input  wire [DATA_WIDTH - 1 : 0] data_1_i,
    
    output wire [DATA_WIDTH - 1 : 0] data_o
);

    assign data_o = (1'h0 == select_i) ? data_0_i : data_1_i;

endmodule
