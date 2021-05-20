`timescale 1ns / 1ps

module uart_tx_tb;

    localparam integer DATA_WIDTH          = 8;
    localparam integer DATA_BIT_NUM_WIDTH  = 4;
    localparam integer CLK_VALUE_MHZ       = 10;     
                                           
    localparam integer BAUD_MAX_VALUE      = 115200;  
    localparam integer BAUD_VALUE          = 9600;  
    
    localparam         DO_MSB_FIRST        = "FALSE"; 
    
    localparam integer CLOCK_PERIOD        = 100;
    
    localparam integer REPITING_NUMBER     = 1000;
    
    localparam integer MAX_DATA_VALUE      = {DATA_WIDTH{1'h1}};
    
    localparam integer DATA_WIDTH_WIDTH    = $clog2(DATA_WIDTH);
                                   
    localparam integer BD_GEN_CNTR_MAX_VAL = 10; //(CLK_VALUE_MHZ * 1000000) / BAUD_MAX_VALUE;
    localparam integer BD_GEN_VAL          = 2;
    
    localparam integer BD_GEN_CNTR_WIDTH   = $clog2(BD_GEN_CNTR_MAX_VAL);

    wire                             baud_tick;

    wire                             serl_data;

    wire                             dt_cnter_enable;
    wire                             piso_enable;
    wire                             piso_wr_enable;

    wire                             dt_cnter_rst_n; 
    wire                             piso_s_rst_n; 
    
    wire                             bd_gn_cnter_rst_n;
    wire                             dt_cnter_bd_enable;
    wire                             dt_piso_bd_enable;

    wire [DATA_WIDTH - 1 : 0]        parl_data;
    wire [DATA_WIDTH - 1 : 0]        dt_cnter_value;
    
    wire [BD_GEN_CNTR_WIDTH - 1 : 0] bd_gen_value;
    
    reg                              clk             = 1'h0;                
    reg                              s_rst_n         = 1'h1; 

    reg                              bd_cnter_enable = 1'h0;
    reg                              uart_tx_enable  = 1'h0;
    reg                              stop_bit_num    = 1'h0;
    
    reg [DATA_BIT_NUM_WIDTH - 1 : 0] data_bit_num    = {4{1'h0}};
    reg [DATA_WIDTH - 1 : 0]         tx_data         = {DATA_WIDTH{1'h0}};
    reg [BD_GEN_CNTR_WIDTH - 1 : 0]  baud_value      = {BD_GEN_CNTR_WIDTH{1'h0}} + 2'h2;

    integer errors = 0;
    
    assign bd_gn_cnter_rst_n  = !((1'h0 === s_rst_n) || (1'h1 === baud_tick));
    assign dt_cnter_bd_enable = (1'h1 === dt_cnter_enable) && (1'h1 === baud_tick);
    assign dt_piso_bd_enable  = (1'h1 === piso_enable) && (1'h1 === baud_tick );
    
    counter #
    (
        .MAX_VALUE (BD_GEN_CNTR_MAX_VAL)
    )
    baud_gen_counter
    (
        .clk_i     (clk              ),    
        .s_rst_n_i (bd_gn_cnter_rst_n),
        .enable_i  (bd_cnter_enable  ), 
                  
        .value_o   (bd_gen_value     )
    );
    
    comparator #
    (
        .DATA_WIDTH (BD_GEN_CNTR_WIDTH)
    )
    baud_generator
    (
        .data_0_i  (baud_value  ),
        .data_1_i  (bd_gen_value), 
                 
        .equal_o   (baud_tick   ),  
        .greater_o (),
        .lower_o   ()
    );
    
    counter #
    (
        .MAX_VALUE (DATA_WIDTH)
    )
    data_counter
    (
        .clk_i     (clk               ),    
        .s_rst_n_i (dt_cnter_rst_n    ),
        .enable_i  (dt_cnter_bd_enable), 
                  
        .value_o   (dt_cnter_value    )
    );
    
    piso #
    (
        .DATA_WIDTH   (DATA_WIDTH  ),
        .DO_MSB_FIRST (DO_MSB_FIRST)
    )
    piso_inst
    (
        .clk_i       (clk              ), 
        .s_rst_n_i   (piso_s_rst_n     ),
        .enable_i    (dt_piso_bd_enable),
                     
        .wr_enable_i (piso_wr_enable   ),
        .data_i      (parl_data        ),
                     
        .data_o      (serl_data        )
    );

    uart_tx #
    (
        .COUNTET_VAL_WIDTH (DATA_WIDTH_WIDTH)
    )
    uart_tx_dut
    (
        .clk_i            (clk    ),
        .s_rst_n_i        (s_rst_n),
        .enable_i         (uart_tx_enable ),
                          
        .baud_tick_i      (baud_tick),
                          
        .stop_bit_num_i   (stop_bit_num),
        .data_bit_num_i   (data_bit_num),
                          
        .counter_rst_n_o  (dt_cnter_rst_n), 
        .counter_enable_o (dt_cnter_enable),
        .counter_value_i  (dt_cnter_value),
                          
        .piso_rst_n_o     (piso_s_rst_n),
        .piso_enable_o    (piso_enable),
        .piso_wr_enable_o (piso_wr_enable),
                          
        .data_i           (tx_data),
        .data_o           (parl_data)
    );
    
    task check_serial_data (input reg [DATA_WIDTH - 1 : 0] data);
    begin
        s_rst_n         <= 1'h1;
        uart_tx_enable  <= 1'h1;
        bd_cnter_enable <= 1'h1;
        stop_bit_num    <= 1'h0;
        data_bit_num    <= 4'h8;
        tx_data         <= data;
        @(posedge clk);
        repeat (8 * (BD_GEN_VAL + 1)) begin
            @(posedge clk);
        end
    end
    endtask
    
    initial begin
        clk = 1'h0;
 
        forever begin
            #( CLOCK_PERIOD / 2 ) clk = !clk;
        end 
    end   

    initial begin
        s_rst_n         <= 1'h0;
        uart_tx_enable  <= 1'h0;
        bd_cnter_enable <= 1'h0;
        stop_bit_num    <= 1'h0;
        data_bit_num    <= 4'h8;
        baud_value      <= {BD_GEN_CNTR_WIDTH{1'h0}} + 2'h2;
        @(posedge clk);
        
        repeat (REPITING_NUMBER) begin
            check_serial_data($random % MAX_DATA_VALUE);
        end
        
        if (0 == errors) begin
            $display("Test passed.");
        end 
        else begin
            $display("Test failed with %d errors.", errors);
        end
        
        $stop();
    end 

endmodule
