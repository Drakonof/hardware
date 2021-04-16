`timescale 1ns / 1ps

module counter_tb;

    localparam integer MAX_VALUE     = 255;
    localparam integer CLOCK_PERIOD  = 100;
    localparam integer COUNTER_WIDTH = $clog2(MAX_VALUE);

    wire [COUNTER_WIDTH - 1 : 0] value;

    reg                         clk        = 1'h0;
    reg                         s_rst_n    = 1'h1;
    reg                         enable     = 1'h0;
    reg [COUNTER_WIDTH - 1 : 0] cmpr_value =  'h0;
    
    integer errors = 0;

    counter #
    (
        .MAX_VALUE (MAX_VALUE)
    )
    counter_dut
    (
        .clk_i     (clk    ),    
        .s_rst_n_i (s_rst_n),
        .enable_i  (enable ), 
                  
        .value_o   (value  ) 
    );
    
    initial begin
        clk = 1'h0;
 
        forever begin
            #( CLOCK_PERIOD / 2 ) clk = !clk;
        end 
    end

    task check_counter_value;
    begin
        repeat(MAX_VALUE - 1) begin
            @(posedge clk);
            
            cmpr_value <= cmpr_value + 1'h1;
            
            if (value !== cmpr_value) begin
               errors = errors + 1;
            end
            
            $display("A dut value: %h.  A compared value: %h",value, cmpr_value, $time);
        end
    end
    endtask
    
    initial begin
        cmpr_value <=  'h0;
        s_rst_n    <= 1'h0;
        @(posedge clk);
        
        s_rst_n    <= 1'h1;
        enable     <= 1'h1;
    
        repeat(MAX_VALUE - 1) begin
            check_counter_value;
        end
        
        if (0 == errors) begin
            $display("The test successfully finished\n", $time);  
        end
        else begin
            $display("The test failed with %d errors\n", errors, $time); 
        end
        
        $stop();
    end

endmodule
