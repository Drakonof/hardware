`timescale 1ns / 1ps

`define SEL_WIDTH  2

module mux_3 # 
(
    parameter integer DATA_WIDTH = 1
)
( 
    input  wire [`SEL_WIDTH - 1 : 0] select_i,
    input  wire [DATA_WIDTH - 1 : 0] data_0_i,
    input  wire [DATA_WIDTH - 1 : 0] data_1_i,
    input  wire [DATA_WIDTH - 1 : 0] data_2_i,
    
    output wire [DATA_WIDTH - 1 : 0] data_o
);
    
    localparam [`SEL_WIDTH - 1 : 0] INPUT_0 = {`SEL_WIDTH{1'h0}};
    localparam [`SEL_WIDTH - 1 : 0] INPUT_1 = {`SEL_WIDTH{1'h0}} + 1'h1;
    localparam [`SEL_WIDTH - 1 : 0] INPUT_2 = {`SEL_WIDTH{1'h0}} + 2'h2;
    
    reg [DATA_WIDTH - 1 : 0] data;
    
    assign data_o = data;

    always begin
        case (select_i) 
            INPUT_0: begin
                data = data_0_i;
            end
            INPUT_1: begin
                data = data_1_i;
            end
            INPUT_2: begin
                data = data_2_i;
            end
            default: begin
                data = {`SEL_WIDTH{1'h0}};
            end
        endcase
    end

endmodule
