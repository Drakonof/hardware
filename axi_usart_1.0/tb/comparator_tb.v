`timescale 1ns / 1ps

module comparator_tb;

    localparam integer DATA_WIDTH    = 32;
    localparam integer DATA_RANGE    = (1 << (DATA_WIDTH - 1));
    
    localparam integer REPEAT_NUMBER = 100;
    localparam integer DELAY         = 10;
    
    wire equal;
    wire greater;
    wire lower;
    
    reg [DATA_WIDTH - 1 : 0] data_0;
    reg [DATA_WIDTH - 1 : 0] data_1;
    
    integer errors = 0;

    comparator # 
    (
        .DATA_WIDTH (DATA_WIDTH)
    )
    comparator_dut
    (
        .data_0_i  (data_0 ), 
        .data_1_i  (data_1 ), 
                 
        .equal_o   (equal  ),  
        .greater_o (greater),
        .lower_o   (lower  )  
    );
    
    task check_comparator;
    begin
        repeat (REPEAT_NUMBER) begin
            data_0 = $random % DATA_RANGE; 
            data_1 = $random % DATA_RANGE; 
            
            #DELAY;
            
            if (data_0 < data_1) begin 
                if (1'h1 != lower) begin
                    $error("the lower signal is error ",  $time);
                    errors = errors + 1;
                end
            end 
            else if (data_0 > data_1) begin
                if (1'h1 != greater) begin
                    $error("the greater signal is error ",  $time);
                    errors = errors + 1;
                end
            end 
            else if (data_0 === data_1) begin
                if (1'h1 != equal) begin
                   $error("the equal signal is error ",  $time);
                   errors = errors + 1;
                end
            end
        end
    end
    endtask
    
    initial begin
        
        check_comparator;
        
        if (0 == errors) begin
            $display("the test passed successfully ",  $time);
        end 
        else begin
            $display("the test failed ",  $time);
        end
    
        $stop();
    end


endmodule
