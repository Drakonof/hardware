`timescale 1ns / 1ps

module demux_2 # 
(
    parameter integer DATA_WIDTH = 1
)
(
    input  logic                      select_i,
    input  logic [DATA_WIDTH - 1 : 0] data_i,  
           
    output logic [DATA_WIDTH - 1 : 0] data_0_o, 
    output logic [DATA_WIDTH - 1 : 0] data_1_o  
);  
    
    always_comb begin
        data_0_o = (1'h0 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_1_o = (1'h1 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
    end

endmodule
