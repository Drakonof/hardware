`timescale 1ns / 1ps

module register
(
    input  wire clk_i,
    input  wire s_rst_n_i,
    input  wire enable_i,
           
    input  wire data_i, 
           
    output wire q_o
);

    reg register_;
 
    assign   q_o = register_;

    always @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            register_ <= 1'h0;
        end
        else if (1'h1 == enable_i) begin
            register_ <= data_i;
        end
    end
        
endmodule
