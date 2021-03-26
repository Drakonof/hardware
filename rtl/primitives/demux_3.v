`timescale 1ns / 1ps

`define SEL_WIDTH  2

module demux_3 # 
(
    parameter integer DATA_WIDTH = 1
)   
(   
    input  wire [`SEL_WIDTH - 1 : 0] select_i,
    input  wire [DATA_WIDTH - 1 : 0] data_i,  
      
    output wire [DATA_WIDTH - 1 : 0] data_0_o, 
    output wire [DATA_WIDTH - 1 : 0] data_1_o,
    output wire [DATA_WIDTH - 1 : 0] data_2_o     
);   

    localparam [`SEL_WIDTH - 1 : 0] INPUT_0 = {`SEL_WIDTH{1'h0}};
    localparam [`SEL_WIDTH - 1 : 0] INPUT_1 = {`SEL_WIDTH{1'h0}} + 1'h1;
    localparam [`SEL_WIDTH - 1 : 0] INPUT_2 = {`SEL_WIDTH{1'h0}} + 2'h2;

    assign data_0_o = (INPUT_0 == select_i) ? data_i : {DATA_WIDTH{1'h0}};
    assign data_1_o = (INPUT_1 == select_i) ? data_i : {DATA_WIDTH{1'h0}};
    assign data_2_o = (INPUT_2 == select_i) ? data_i : {DATA_WIDTH{1'h0}};
    
endmodule