`timescale 1ns / 1ps

module piso # 
(
    parameter         DATA_WIDTH   = 8,
    parameter integer DO_MSB_FIRST = "TRUE"      
)
(
    input  wire                     clk_i,
    input  wire                     s_rst_n_i,
    input  wire                     enable_i,
    
    input  wire                     wr_enable_i,
    input  wire  [DATA_WIDTH - 1:0] data_i,

    output wire                     data_o
);
     
    localparam integer MSB = DATA_WIDTH - 1;
    localparam integer LSB = 0;
    localparam integer XSB = ("TRUE" == DO_MSB_FIRST) ? MSB : LSB;

    reg [DATA_WIDTH - 1 : 0] buff;

    assign data_o = (1'h1 == enable_i) ? buff[XSB] : 1'h0;
    
    always @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            buff <= {DATA_WIDTH{1'h0}};
        end
        else if (1'h1 == wr_enable_i) begin
            buff <= data_i;
        end
        else if (1'h1 == enable_i) begin
            if ("TRUE" == DO_MSB_FIRST) begin
                buff <= {buff[MSB - 1 : 0], 1'h0};
            end
            else begin
                buff <= {1'h0, buff[MSB: 1]};
            end  
        end
    end
endmodule