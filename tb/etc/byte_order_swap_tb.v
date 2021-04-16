`timescale 1ns / 1ps

module byte_order_swap_tb;

    localparam integer              DATA_WIDTH          = 32;
    localparam integer              CLOCK_PERIOD        = 100;
    localparam integer              ITERATION_NUMBER    = 1000;
    localparam [DATA_WIDTH - 1 : 0] COUNTER_START_VALUE = 32'hAABB1122;
    
    wire [DATA_WIDTH - 1 : 0] counter_swap_value;
    
    reg                      clk;
    reg [DATA_WIDTH - 1 : 0] counter_dir_value;

    byte_order_swap #
    (
        .DATA_WIDTH (DATA_WIDTH)
    )
    byte_order_swap_dut
    (
        .data_i (counter_dir_value),
        .data_o (counter_swap_value)
    );
    
    initial begin
        clk = 1'h0;
 
        forever begin
            #( CLOCK_PERIOD / 2 ) clk = !clk;
        end 
    end
    
    initial begin
        counter_dir_value <= COUNTER_START_VALUE;
    
        repeat(ITERATION_NUMBER) begin
            @(posedge clk);
            counter_dir_value <= counter_dir_value + 1'h1;
        end
    end
    
    task monitor_swap;
    begin
        repeat(ITERATION_NUMBER) begin
            @(posedge clk);
            $display("A direction value:  %h -> the swap value: %h",counter_dir_value, counter_swap_value, $time);
        end
    end
    endtask
    
    initial begin
    
        monitor_swap;
        
        $stop();
    end

endmodule
