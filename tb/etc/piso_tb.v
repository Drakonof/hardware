`timescale 1ns / 1ps

module piso_tb;
 
    localparam                      DO_MSB_FIRST = "FALSE";
    localparam integer              DATA_WIDTH   = 8;
    localparam [DATA_WIDTH - 1 : 0] MAX_VALUE    = ((2 << DATA_WIDTH) -1);
    localparam integer              CLOCK_PERIOD = 100;
    localparam integer              REPEATS      = 1000;
    
    wire                     serl_data; 

    reg                      clk       = 1'h0;                
    reg                      s_rst_n   = 1'h1; 
    reg                      enable    = 1'h0; 
    
    reg                      wr_enable = 1'h0; 
    reg [DATA_WIDTH - 1 : 0] parl_data =  'h0;
    reg [DATA_WIDTH - 1 : 0] comp_data =  'h0;
    
    integer errors = 0;
    integer i      = 0;

    piso #
    (
        .DATA_WIDTH   (DATA_WIDTH  ),
        .DO_MSB_FIRST (DO_MSB_FIRST)    
    )
    piso_dut
    (
        .clk_i      (clk      ), 
        .s_rst_n_i  (s_rst_n  ),
        .enable_i   (enable   ),
                    
        .wr_enable_i(wr_enable),
        .data_i     (parl_data),
                    
        .data_o     (serl_data)
    );
    
    task check_piso;
    begin
        repeat(REPEATS) begin
            comp_data = $urandom % MAX_VALUE;
            
            wr_enable <= 1'h1;
            enable    <= 1'h1;
            parl_data <= comp_data;
            @(posedge clk);
            
            wr_enable <= 1'h0;
             
            // An MSB is the first one
            // An LSB is the first one
            i = ("TRUE" == DO_MSB_FIRST) ? DATA_WIDTH - 1 : 0;
            
            repeat(DATA_WIDTH) begin 
                @(posedge clk);
                
                if (serl_data !== comp_data[i]) begin
                    errors = errors + 1;
                     $display("An error ocurred. A data bit is: %b, but have to be %b\n", serl_data, comp_data[i], $time);
                end 
                
                i = ("TRUE" == DO_MSB_FIRST) ? i - 1 : i + 1;

            end
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
        s_rst_n   <= 1'h0;
        enable    <= 1'h0;
                  
        wr_enable <= 1'h0;
        parl_data <=  'h0;
        @(posedge clk);
        
        s_rst_n   <= 1'h1;
        @(posedge clk);
        
        check_piso;
        
        if (0 == errors) begin
            $display("Test passed.");
        end 
        else begin
            $display("Test failed with %d errors.", errors);
        end
        
        $stop();
    end 

endmodule
