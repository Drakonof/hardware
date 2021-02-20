`timescale 1ns / 1ps

// bram или распределённая память?
module register
(
    input  logic clk_i,
    input  logic s_rst_n_i,
    input  logic enable_i,
           
    input  logic data_i, 
           
    output logic q_o
);

    logic register_;
   
    always_comb begin
        q_o = register_;
    end
    
    always_ff @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            register_ <= 1'h0;
        end
        else if (1'h1 == enable_i) begin
            register_ <= data_i;
        end
    end
        
endmodule
