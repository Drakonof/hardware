`timescale 1ns / 1ps

`define WIDTH  8

module encode_3
(
    input wire                   data_0_i,
    input wire                   data_1_i,
    input wire                   data_2_i,
    
    output wire [`WIDTH - 1 : 0] data_o
);
    localparam [`WIDTH - 1 : 0] OUTPUT_0 = {`WIDTH{1'h0}};
    localparam [`WIDTH - 1 : 0] OUTPUT_1 = {`WIDTH{1'h0}} + 1'h1;
    localparam [`WIDTH - 1 : 0] OUTPUT_2 = {`WIDTH{1'h0}} + 2'h2;
    localparam [`WIDTH - 1 : 0] OUTPUT_3 = {`WIDTH{1'h0}} + 2'h3;
    localparam [`WIDTH - 1 : 0] OUTPUT_4 = {`WIDTH{1'h0}} + 3'h4;
    localparam [`WIDTH - 1 : 0] OUTPUT_5 = {`WIDTH{1'h0}} + 3'h5;
    localparam [`WIDTH - 1 : 0] OUTPUT_6 = {`WIDTH{1'h0}} + 3'h6;
    localparam [`WIDTH - 1 : 0] OUTPUT_7 = {`WIDTH{1'h0}} + 3'h7;
    
    assign   data_o [OUTPUT_0] = ~data_0_i & ~data_1_i & ~data_2_i;
    assign   data_o [OUTPUT_1] = ~data_0_i & ~data_1_i &  data_2_i;
    assign   data_o [OUTPUT_2] = ~data_0_i &  data_1_i & ~data_2_i;
    assign   data_o [OUTPUT_3] = ~data_0_i &  data_1_i &  data_2_i;
    assign   data_o [OUTPUT_4] =  data_0_i & ~data_1_i & ~data_2_i;
    assign   data_o [OUTPUT_5] =  data_0_i & ~data_1_i &  data_2_i;
    assign   data_o [OUTPUT_6] =  data_0_i &  data_1_i & ~data_2_i;
    assign   data_o [OUTPUT_7] =  data_0_i &  data_1_i &  data_2_i;

endmodule
