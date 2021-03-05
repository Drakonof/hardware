`timescale 1ns / 10ps

module sc_dual_block_ram # 
(
    parameter integer DATA_WIDTH     = 8,
    parameter integer ADDRESS_WIDTH  = 8,
    parameter         INIT_FILE_NAME = ""
)
(
    input  logic                            clk_i           ,

    input  logic [DATA_WIDTH - 1 : 0]       wr_data_i       ,
    input  logic [ADDRESS_WIDTH - 1 : 0]    wr_address_i    ,                    
    input  logic                            wr_enable_i     ,
    input  logic [(DATA_WIDTH / 8) - 1 : 0] wr_byte_enable_i,
 
    output logic [DATA_WIDTH - 1 : 0]       rd_data_o        ,
    input  logic [ADDRESS_WIDTH - 1 : 0]    rd_address_i     ,                    
    input  logic                            rd_enable_i      ,
    output logic                            rd_valid_o
);

    localparam integer BLOCK_RAM_DEPTH = (1 << ADDRESS_WIDTH);

    logic                         rd_valid;
    logic [ADDRESS_WIDTH - 1 : 0] rd_address;
  
    logic [DATA_WIDTH - 1 : 0]    block_ram [0 : BLOCK_RAM_DEPTH - 1];

    integer i = 0;

    generate 
        if ("" != INIT_FILE_NAME) begin : init_block_ram_from_file
            initial begin
                $readmemh(INIT_DAT_FILE_NAME, block_ram);
            end
        end
    endgenerate

    always_comb begin
       rd_data_o  = (1'h1 == rd_valid) ? block_ram[rd_address] : {DATA_WIDTH{1'h0}};
       rd_valid_o = rd_valid;
    end
     
    always_ff @ (posedge clk_i) begin
        if (1'h1 == wr_enable_i) begin
            for (i = 0; i < (DATA_WIDTH / 8); i = i + 1) begin
                if (1'h1 == wr_byte_enable_i[i]) begin
                    block_ram[wr_address_i][(i * 8) +: 8] <= wr_data_i[(i * 8) +: 8]; 
                end
            end 
        end

        rd_valid    <= rd_enable_i;
        rd_address  <= rd_address_i;
    end

endmodule