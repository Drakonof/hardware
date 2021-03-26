`timescale 1ns / 1ps

module byte_order_swap #
(
    parameter integer DATA_WIDTH = 32
)
(
    input wire [DATA_WIDTH - 1 : 0] data_i,
    input wire [DATA_WIDTH - 1 : 0] data_o
);
    localparam integer DATA_BYTE_NUMBER = DATA_WIDTH / 8;
    localparam integer DEC_DATA_WIDTH   = DATA_WIDTH - 1;

    generate
        genvar i;
        if (0 == (DATA_WIDTH % 8)) begin
            for(i = 0; i < DATA_BYTE_NUMBER; i = i + 1) begin
                assign data_o[(i * 8) +: 8] = data_i[(DEC_DATA_WIDTH - i * 8)  -: 8];
            end
        end
        else begin
            assign data_o = {DATA_WIDTH{1'h0}};
        end
    endgenerate

endmodule
