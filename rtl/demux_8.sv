module demux_8 # 
(
    parameter integer DATA_WIDTH = 1
)   
(   
    input  logic [2 : 0]              select_i,
    input  logic [DATA_WIDTH - 1 : 0] data_i,  
           
    output logic [DATA_WIDTH - 1 : 0] data_0_o, 
    output logic [DATA_WIDTH - 1 : 0] data_1_o,
    output logic [DATA_WIDTH - 1 : 0] data_2_o, 
    output logic [DATA_WIDTH - 1 : 0] data_3_o,  
    output logic [DATA_WIDTH - 1 : 0] data_4_o, 
    output logic [DATA_WIDTH - 1 : 0] data_5_o, 
    output logic [DATA_WIDTH - 1 : 0] data_6_o, 
    output logic [DATA_WIDTH - 1 : 0] data_7_o      
);   

    always_comb begin
        data_0_o = (3'h0 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_1_o = (3'h1 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_2_o = (3'h2 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_3_o = (3'h3 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_4_o = (3'h4 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_5_o = (3'h5 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_6_o = (3'h6 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
        data_7_o = (3'h7 == select_i) ? data_i : {DATA_WIDTH{1'hz}};
    end

endmodule