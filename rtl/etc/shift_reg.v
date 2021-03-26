/*----------------------------------------------------------------------------------------------------
 | engineer:        Artyom Shimko (soikadigital@gmail.com)
 |
 | created:         18.01.21  
 |
 | device:          cross-platform
 |
 | description:     A loaded shift register.
 |
 | dependencies:    non
 |
 | doc:             non
 |
 | rtl:             shift_reg.v
 |
 | tb:              shift_reg_tb.v
 |
 | version:         1.0
 |
 | revisions:       18.01.21    - There was createde the base vertion file;   
 |   
 */

 /* 
  shift_reg #
  (
    .COUNTER_WIDTH (),
    .DO_MSB_FIRST  ()  // Thera is "TRUE" or "FALSE" required.
  )
  shift_reg_inst_0
  (
    .clk_i         (),
    .s_rst_n_i     (),
    .enable_i      (),
    .wr_enable_i   (), 
    .wr_data_i     (), // width: DATA_WIDTH  
    .serial_data_o ()
  );
 */

`timescale 1ns / 1ps

module shift_reg # 
(
    parameter integer DATA_WIDTH   = 16,
    parameter integer DO_MSB_FIRST = "TRUE"
)
(
    input  wire                      clk_i,
    input  wire                      s_rst_n_i,
    input  wire                      enable_i,
    input  wire                      wr_enable_i,
    
    input  wire [DATA_WIDTH - 1 : 0] wr_data_i,

    output wire                      serial_data_o
);  
    localparam integer MSB = DATA_WIDTH - 1;
    localparam integer LSB = 0;
    localparam integer XSB = ("TRUE" == DO_MSB_FIRST) ? MSB : LSB;

    reg [DATA_WIDTH - 1 : 0] parallel_data;

    assign serial_data_o = (1'h1 == enable_i) ? parallel_data[XSB] : 1'h0;
    
    always @ (posedge clk_i) begin
        if (1'h0 == s_rst_n_i) begin
            parallel_data <= {DATA_WIDTH{1'h0}};
        end
        else if (1'h1 == wr_enable_i) begin
            parallel_data <= wr_data_i;
        end
        else if (1'h1 == enable_i) begin
            if ("TRUE" == DO_MSB_FIRST) begin
                parallel_data <= {parallel_data[MSB - 1 : 0], 1'h0};
            end
            else begin
                parallel_data <= {1'h0, parallel_data[MSB: 1]};
            end  
        end
    end

endmodule