`timescale 1ns / 1ps

`define WIDTH  3

module decode_3
(
    input  wire [`WIDTH - 1 : 0] data_i,
            
    output wire                  data_0_o,
    output wire                  data_1_o,
    output wire                  data_2_o,
    output wire                  data_3_o,
    output wire                  data_4_o,
    output wire                  data_5_o,
    output wire                  data_6_o,
    output wire                  data_7_o
);

    assign data_0_o = ~data_i[2] & ~data_i[1] & ~data_i[0];
    assign data_1_o = ~data_i[2] & ~data_i[1] &  data_i[0];
    assign data_2_o = ~data_i[2] &  data_i[1] & ~data_i[0];
    assign data_3_o = ~data_i[2] &  data_i[1] &  data_i[0];
    assign data_4_o =  data_i[2] & ~data_i[1] & ~data_i[0];
    assign data_5_o =  data_i[2] & ~data_i[1] &  data_i[0];
    assign data_6_o =  data_i[2] &  data_i[1] & ~data_i[0];
    assign data_7_o =  data_i[2] &  data_i[1] &  data_i[0];
   
endmodule
