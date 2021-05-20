
`timescale 1 ns / 1 ps

module axi_lite_usart #
(
	parameter integer DATA_WIDTH     = 32,
	parameter integer CLK_VALUE_MHZ  = 10,
	parameter integer BAUD_MAX_VALUE = 115200
)
(
	input  wire                            axi_clk,
	input  wire                            axi_a_rst_n,
	
	input  wire [DATA_WIDTH - 1 : 0]       s_axi_awaddr,
	input  wire [2 : 0]                    s_axi_awprot,
	input  wire                            s_axi_awvalid,
	output wire                            s_axi_awready,
	
	input  wire [DATA_WIDTH - 1 : 0]       s_axi_wdata,
	input  wire [(DATA_WIDTH / 8) - 1 : 0] s_axi_wstrb,
	input  wire                            s_axi_wvalid,
	output wire                            s_axi_wready,
	
	output wire [1 : 0]                    s_axi_bresp,
	output wire                            s_axi_bvalid,
	input  wire                            s_axi_bready,
	
	input  wire [DATA_WIDTH - 1 : 0]       s_axi_araddr,
	input  wire [2 : 0]                    s_axi_arprot,
	input  wire                            s_axi_arvalid,
	output wire                            s_axi_arready,
	
	output wire [DATA_WIDTH - 1 : 0]       s_axi_rdata,
	output wire [1 : 0]                    s_axi_rresp,
	output wire                            s_axi_rvalid,
	input  wire                            s_axi_rready,
	
	output wire                            tx,
	input  wire                            rx
);
    
    localparam integer BAUD_GEN_CNTER_MAX_VAL     = (CLK_VALUE_MHZ * 1000000) / BAUD_MAX_VALUE;
    localparam integer BAUD_GEN_CNTER_WIDTH       = $clog2(BAUD_GEN_CNTER_MAX_VAL);
    
    localparam integer REGISTER_NUMBER            = 5;
    localparam         INIT_FILE_NAME             = "";
    
    localparam integer TX_RX_DATA_BIT_MAX_VALUE   = 8;
    localparam integer TX_RX_DATA_BIT_CNTER_WIDTH = $clog2(BAUD_GEN_CNTER_MAX_VAL);
    
    wire                                      baud_gen_cnter_en;
    wire                                      baud_gen_cnter_rst_n;
    wire                                      baud_tick;
    wire [BAUD_GEN_CNTER_WIDTH - 1 : 0]       baud_gen_cnter_val;  
    wire [BAUD_GEN_CNTER_WIDTH - 1 : 0]       baud_tick_value;
    
    wire                                      tx_cnter_rst_n;
    wire                                      tx_cnter_enable;
    wire [TX_RX_DATA_BIT_CNTER_WIDTH - 1 : 0] tx_cnter_value;
    
    wire                                      tx_piso_rst_n;
    wire                                      tx_piso_enable;
    wire                                      tx_piso_wr_enable;
    wire [7:0]                                tx_piso_data;
    
    wire                                      tx_enable;
    wire [7:0]                                tx_data;
    
    wire                                      rx_cnter_rst_n;
    wire                                      rx_cnter_enable;
    wire [TX_RX_DATA_BIT_CNTER_WIDTH - 1 : 0] rx_cnter_value;
    
    wire                                      rx_sipo_rst_n;
    wire                                      rx_sipo_enable;
    wire                                      rx_sipo_data_valid;
    wire [7:0]                                rx_sipo_data;
    
    wire                                      rx_enable;      
    wire [7:0]                                rx_data;
    
    wire                                      stop_bit_num;
    wire [3:0]                                data_bit_num;
    
    //--------------------------------------------------  a baud generater  --------------------------------------------------//
    
    counter # // ++
    ( 
        .MAX_VALUE (BAUD_GEN_CNTER_MAX_VAL)
    )
    baud_gen_cnter
    (
        .clk_i     (axi_clk             ),     
        .s_rst_n_i (baud_gen_cnter_rst_n),  // from controller
        .enable_i  (baud_gen_cnter_en   ),  // from controller
                  
        .value_o   (baud_gen_cnter_val  )
    );  
 
    comparator # // ++
    (
        .DATA_WIDTH (BAUD_GEN_CNTER_WIDTH)
    )
    baud_generator
    (
        .a_i       (baud_tick_value   ), // from controller
        .b_i       (baud_gen_cnter_val),
              
        .equal_o   (baud_tick         ),
        .greater_o (                  ),
        .lower_o   (                  )
    );
    
    //--------------------------------------------------    a controller    --------------------------------------------------//
    
  /*  usart_controller # //--
    (
        
    )
    usart_controller_inst
    (
    
    
    
    );
    
    simple_dual_block_ram # //+-
    (
        .DATA_WIDTH     (DATA_WIDTH             ),
        .ADDRESS_WIDTH  ($clog2(REGISTER_NUMBER)),
        .INIT_FILE_NAME (INIT_FILE_NAME         )
    )
    reg_space
    (
        clk_i        (axi_clk),       
                     
        wr_data_i    (),   
        wr_address_i (),
        wr_enable_i  (), 
        wr_valid_i   (),  
                     
        rd_data_o    (), 
        rd_address_i (),
        rd_enable_i  (), 
        rd_valid_o   () 
    );
    */
    //--------------------------------------------------    a transmiter    --------------------------------------------------//
    
    counter # //++
    (
        .MAX_VALUE (TX_RX_DATA_BIT_CNTER_WIDTH)
    )
    tx_counter
    (
        .clk_i     (axi_clk        ),     
        .s_rst_n_i (tx_cnter_rst_n ),
        .enable_i  (baud_tick && tx_cnter_enable),
                  
        .value_o   (tx_cnter_value )
    );
    
    piso # //+-
    (
        .DATA_WIDTH   (8),
        .DO_MSB_FIRST ("TRUE")
    )
    tx_piso
    (
        .clk_i     (axi_clk          ),
        .s_rst_n_i (tx_piso_rst_n    ),
        
        .enable    (tx_piso_enable   ),
        .wr_enable (tx_piso_wr_enable),
        
        .data_i    (tx_piso_data     ),
        .data_o    (tx               )
    );
    
    uart_tx # //--
    (
        .COUNTET_VAL_WIDTH (TX_RX_DATA_BIT_CNTER_WIDTH)
    )
    uart_tx_inst
    (
        .clk_i            (axi_clk          ),           
        .s_rst_n_i        (axi_a_rst_n      ),       
        .enable_i         (1'h1),//(tx_enable        ), // from controller   
                             
        .baud_tick_i      (baud_tick        ),     
                           
        .stop_bit_num_i   (1'h0),//(stop_bit_num     ), // from controller 
        .data_bit_num_i   (4'h8),//(data_bit_num     ), // from controller 
        
        .counter_rst_n_o  (tx_cnter_rst_n   ),   
        .counter_enable_o (tx_cnter_enable  ),                
        .counter_value_i  (tx_cnter_value   ), 
                       
        .piso_rst_n_o     (tx_piso_rst_n    ),             
        .piso_enable_o    (tx_piso_enable   ),   
        .piso_wr_enable_o (tx_piso_wr_enable),
                      
        .data_i           (8'h33          ),//(tx_data          ), // from controller      
        .data_o           (tx_piso_data     )       
    );
    
    //--------------------------------------------------     a receiver     --------------------------------------------------//
    
  /*  counter # //++
    (
        .MAX_VALUE (8)
    )
    rx_counter
    (
        .clk_i     (axi_clk),     
        .s_rst_n_i (rx_cnter_rst_n),  
        .enable_i  (rx_cnter_enable),  
                  
        .value_o   (rx_cnter_value)
    );
    
    sipo # //+-
    (
        .DATA_WIDTH (8)
    )
    rx_sipo
    (
        .clk_i      (axi_clk),          
        .s_rst_n_i  (rx_sipo_rst_n),         
        .enable_i   (rx_sipo_enable),       
                       
        .data_i     (rx),         
                          
        .data_o     (rx_sipo_data),         
        .data_val_o (rx_sipo_data_valid)
    );
    
    uart_rx # //--
    (
    
    )
    uart_rx_inst
    (
        .clk_i            (axi_clk           ),           
        .s_rst_n_i        (axi_a_rst_n       ),       
        .enable_i         (rx_enable         ), // from controller
        
        .baud_tick_i      (baud_tick         ),
        
        .stop_bit_num_i   (stop_bit_num      ), // from controller 
        .data_bit_num_i   (data_bit_num      ), // from controller 
        
        .counter_rst_n_o  (rx_cnter_rst_n    ),   
        .counter_enable_o (rx_cnter_enable   ),                
        .counter_value_i  (rx_cnter_value    ), 
        
        .sipo_rst_n_o     (rx_sipo_rst_n     ),             
        .sipo_enable_o    (rx_sipo_enable    ),   
        .sipo_data_val_i  (rx_sipo_data_valid),
        
        .data_i           (rx_sipo_data      ),
        .data_o           (rx_data           ) // to controller 
    );
*/
endmodule























