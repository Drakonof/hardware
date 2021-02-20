`timescale 1ns / 1ps

module mux # 
(
    parameter integer DATA_WIDTH   = 8,
    parameter integer INPUT_NUMBER = 8
)
(
    input  logic [$clog2(INPUT_NUMBER) - 1 : 0] select_i,
    input  logic [DATA_WIDTH - 1 : 0]           data_i[INPUT_NUMBER - 1 : 0],
    output logic[DATA_WIDTH - 1 : 0]            data_o
);

    always_comb begin
        data_o = data_i[select_i];
    end
        
endmodule
