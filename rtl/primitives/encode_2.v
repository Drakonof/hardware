`timescale 1ns / 1ps

module encode_2
(
    input wire data_0_i,
    input wire data_1_i,
    
    output wire [3:0] data_o
);

     assign   data_o [0] = ~data_0_i & ~data_1_i;
     assign   data_o [1] = ~data_0_i &  data_1_i;
     assign   data_o [2] =  data_0_i & ~data_1_i;
     assign   data_o [3] =  data_0_i &  data_1_i;
     
endmodule
