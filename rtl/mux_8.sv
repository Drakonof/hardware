`timescale 1ns / 1ps

module mux_8 #
(
    parameter integer DATA_WIDTH = 1
)
(
    input  logic [2 : 0]              select_i,
           
    input  logic [DATA_WIDTH - 1 : 0] data_0_i,
    input  logic [DATA_WIDTH - 1 : 0] data_1_i,
    input  logic [DATA_WIDTH - 1 : 0] data_2_i,
    input  logic [DATA_WIDTH - 1 : 0] data_3_i,
    input  logic [DATA_WIDTH - 1 : 0] data_4_i,
    input  logic [DATA_WIDTH - 1 : 0] data_5_i,
    input  logic [DATA_WIDTH - 1 : 0] data_6_i,
    input  logic [DATA_WIDTH - 1 : 0] data_7_i,
           
    output logic [DATA_WIDTH - 1 : 0] data_o
);  

    always_comb begin
        case (select_i)
            3'h0: begin 
                data_o = data_0_i;
            end
            3'h1: begin 
                data_o = data_1_i;
            end
            3'h2: begin 
                data_o = data_2_i;
            end
            3'h3: begin 
                data_o = data_3_i;
            end
            3'h4: begin 
                data_o = data_4_i;
            end
            3'h5: begin 
                data_o = data_5_i;
            end
            3'h6: begin 
                data_o = data_6_i;
            end
            3'h7: begin 
                data_o = data_7_i;
            end
            default: begin // что бы избежать защелки, наверное...
                data_o = {DATA_WIDTH{1'h0}};
            end
        endcase
    end

endmodule
