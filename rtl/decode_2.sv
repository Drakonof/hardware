`timescale 1ns / 1ps

module decode_2
(
    input  logic data_i,
            
    output logic q_0_o,
    output logic q_1_o
);
    always_comb begin
        q_0_o = ~data_i;
        q_1_o = data_i;
    end

endmodule
