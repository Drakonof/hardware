`timescale 1ns / 1ps

module loaded_counter_tb;

    localparam integer                 COUNTER_WIDTH     = 8;
    localparam integer                 CLOCK_PERIOD      = 100;
    localparam integer                 MAX_VALUE         = COUNTER_WIDTH;
    localparam integer                 REPEATS           = 1000;
    localparam [COUNTER_WIDTH - 1 : 0] MAX_COUNTER_VALUE = ((2 << COUNTER_WIDTH) -1);
    localparam [COUNTER_WIDTH - 1 : 0] MIN_COUNTER_VALUE =  'h0;
    localparam [0 : 0]                 INCREMENT         = 1'h1;
    localparam [0 : 0]                 DECREMENT         = 1'h0;

    wire [COUNTER_WIDTH - 1 : 0] counter_value;

    reg                         clk         = 1'h0;                
    reg                         s_rst_n     = 1'h1;                
    reg                         enable      = 1'h0;   
    reg                         direction   = 1'h0;                
    reg                         load_enable =  'h0;
    reg [COUNTER_WIDTH - 1 : 0] load_data   =  'h0;
    reg [COUNTER_WIDTH - 1 : 0] increment   =  'h0;
    reg [COUNTER_WIDTH - 1 : 0] res         =  'h0;

    integer errors     = 0;
    integer increments = 0;
    integer decrements = 0;

    loaded_counter #
    (
      .COUNTER_WIDTH (COUNTER_WIDTH)
    )
    loaded_counter_dut
    (
      .clk_i         (clk),
      .s_rst_n_i     (s_rst_n),
      .enable_i      (enable),
      .direction_i   (direction),
      .load_enable_i (load_enable),
      .load_data_i   (load_data),      
      .increment_i   (increment),
      
      .value_o       (counter_value)
    );

    task check_increment(input reg [COUNTER_WIDTH - 1 : 0] increment_value,
                         input reg [0 : 0] dir);
    begin
        res         <= ($urandom + 1) % MAX_COUNTER_VALUE;
        @(posedge clk);
        
        direction   <= dir;
        load_enable <= 1'h1;
        load_data   <= res;
        increment   <= increment_value;
        @(posedge clk);

        load_enable <= 1'h0;
        enable      <= 1'h1;
        @(posedge clk);

        repeat(REPEATS) begin     
            if (1'h1 == direction) begin
                res <= res + increment_value;
            end
            else begin
                res <= res - increment_value;
            end
            @(posedge clk);
            
            if (counter_value !== res) begin
                errors = errors + 1;
                $display("An error ocurred\n");
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
        s_rst_n <= 1'h0;       
        @(posedge clk);

        s_rst_n <= 1'h1;
        @(posedge clk);

        repeat (REPEATS) begin
            if (1'h0 == (($urandom + 1) % 2)) begin
                check_increment(($urandom + 1) % MAX_VALUE, INCREMENT);
                increments = increments + 1;
            end
            else begin
              check_increment(($urandom + 1) % MAX_VALUE, DECREMENT); 
              decrements = decrements + 1;
            end
        end

        if (0 == errors) begin
            $display("Test passed.\nIncrements: %d\nDecrements: %d", increments, decrements, $time);
        end 
        else begin
            $display("Test failed with %d errors.", errors, $time);
        end
        
        $stop();  
    end
endmodule