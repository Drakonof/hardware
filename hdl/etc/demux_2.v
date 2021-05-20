`timescale 1ns / 1ps

module demux_2 # 
(
    parameter integer DATA_WIDTH = 1
)
(
    input  wire                      select_i,
    input  wire [DATA_WIDTH - 1 : 0] data_i,  
      
    output wire [DATA_WIDTH - 1 : 0] data_0_o, 
    output wire [DATA_WIDTH - 1 : 0] data_1_o  
);  
    
    assign data_0_o = (1'h0 == select_i) ? data_i : {DATA_WIDTH{1'h0}};
    assign data_1_o = (1'h1 == select_i) ? data_i : {DATA_WIDTH{1'h0}};

endmodule
