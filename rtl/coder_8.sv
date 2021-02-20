//  |---|---|---|---|
//  |   | 2 | 1 | 0 | < the q's bits
//  |---|---|---|---|
//  | 0 | 0 | 0 | 0 |
//  |---|---|---|---|
//  | 1 | 0 | 0 | 1 |
//  |---|---|---|---|
//  | 2 | 0 | 1 | 0 |
//  |---|---|---|---|
//  | 3 | 0 | 1 | 1 |
//  |---|---|---|---|
//  | 4 | 1 | 0 | 0 |
//  |---|---|---|---|
//  | 5 | 1 | 0 | 1 |
//  |---|---|---|---|
//  | 6 | 1 | 1 | 0 |
//  |---|---|---|---|
//  | 7 | 1 | 1 | 1 |
//  |---|---|---|---|
//    ^
//    a value

`timescale 1ns / 1ps

module coder_8
(
    input  logic         data_0_i,
    input  logic         data_1_i,
    input  logic         data_2_i,
    input  logic         data_3_i,
    input  logic         data_4_i,
    input  logic         data_5_i,
    input  logic         data_6_i,
    input  logic         data_7_i,
    
    output logic [2 : 0] q_o
);
    always_comb begin
        q_o[0] = data_1_i | data_3_i | data_5_i | data_7_i;
        q_o[1] = data_2_i | data_3_i | data_6_i | data_7_i;
        q_o[2] = data_4_i | data_5_i | data_6_i | data_7_i;
    end

endmodule
