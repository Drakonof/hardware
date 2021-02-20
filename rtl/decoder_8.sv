`timescale 1ns / 1ps

module decoder_8
(
    input  logic [2:0] data_i,
            
    output logic       q_0_o,
    output logic       q_1_o,
    output logic       q_2_o,
    output logic       q_3_o,
    output logic       q_4_o,
    output logic       q_5_o,
    output logic       q_6_o,
    output logic       q_7_o
);

    always_comb begin
        q_0_o = ~data_i[2] & ~data_i[1] & ~data_i[0];
        q_1_o = ~data_i[2] & ~data_i[1] & data_i[0];
        q_2_o = ~data_i[2] & data_i[1] & ~data_i[0];
        q_3_o = ~data_i[2] & data_i[1] & data_i[0];
        q_4_o = data_i[2] & ~data_i[1] & ~data_i[0];
        q_5_o = data_i[2] & ~data_i[1] & data_i[0];
        q_6_o = data_i[2] & data_i[1] & ~data_i[0];
        q_7_o = data_i[2] & data_i[1] & data_i[0];
    end
    
endmodule
