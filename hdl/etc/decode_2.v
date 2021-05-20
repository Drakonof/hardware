`timescale 1ns / 1ps

module decode_2
(
    input  wire data_i,
            
    output wire data_0_o,
    output wire data_1_o
);
   
    assign data_0_o = ~data_i;
    assign data_1_o =  data_i;
   
endmodule
