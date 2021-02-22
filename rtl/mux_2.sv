`timescale 1ns / 1ps

module mux_2 # 
(
    parameter integer DATA_WIDTH = 1
)
(
    input  logic                      select_i,
           
    input  logic [DATA_WIDTH - 1 : 0] data_0_i,
    input  logic [DATA_WIDTH - 1 : 0] data_1_i,
           
    output logic [DATA_WIDTH - 1 : 0] data_o
);
    
    always_comb begin
        data_o = (1'h0 == select_i) ? data_0_i : data_1_i;
    end

endmodule
