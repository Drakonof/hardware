`timescale 1ns / 1ps

module coder_2
(
    input  logic data_0_i,
    input  logic data_1_i,
    
    output logic q_o
);

    always_comb begin
        q_o = data_1_i;
    end

endmodule
