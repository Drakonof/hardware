`timescale 1ns / 1ps

module uart_tx #
(
    parameter integer COUNTET_VAL_WIDTH = 8,
    parameter integer DATA_WIDTH        = 8
)
(
    input  wire                              clk_i,
    input  wire                              s_rst_n_i,
    input  wire                              enable_i,

    input  wire                              baud_tick_i,
    
    input  wire                              stop_bit_num_i,
    input  wire [$clog2(DATA_WIDTH) -  1: 0] data_bit_num_i,
    
    output wire                              counter_rst_n_o, 
    output wire                              counter_enable_o,
    input  wire [COUNTET_VAL_WIDTH - 1 : 0]  counter_value_i,
 
    output wire                              piso_rst_n_o,
    output wire                              piso_enable_o,
    output wire                              piso_wr_enable_o,
   
    input  wire [DATA_WIDTH - 1 : 0]         data_i,
    output wire [DATA_WIDTH - 1 : 0]         data_o
);

    localparam integer FSM_ST_NUM     = 4;
    localparam integer FSM_ST_WIDTH   = $clog2(FSM_ST_NUM);
    localparam integer DATA_BIT_WIDTH = $clog2(DATA_WIDTH);

    localparam [FSM_ST_WIDTH - 1 : 0] IDLE  = {FSM_ST_WIDTH{1'h0}};
    localparam [FSM_ST_WIDTH - 1 : 0] START = {FSM_ST_WIDTH{1'h0}} + 1'h1;
    localparam [FSM_ST_WIDTH - 1 : 0] SEND  = {FSM_ST_WIDTH{1'h0}} + 2'h2;
    localparam [FSM_ST_WIDTH - 1 : 0] STOP  = {FSM_ST_WIDTH{1'h0}} + 2'h3;
  
    reg                          piso_wr_enable;
    reg                          duable_stop_flag;
    reg [DATA_BIT_WIDTH -  1: 0] data_bit_num;
    reg [DATA_WIDTH - 1 : 0]     data;
    reg [FSM_ST_WIDTH - 1 : 0]   fsm_state;
    
    assign counter_rst_n_o  = !((START == fsm_state) || (1'h0 == s_rst_n_i));
    assign counter_enable_o = (SEND == fsm_state);
    
    assign piso_rst_n_o     = !((IDLE == fsm_state) || (1'h0 == s_rst_n_i));
    assign piso_enable_o    = (IDLE != fsm_state);
    
    assign piso_wr_enable_o = piso_wr_enable;
    
    assign data_o           = data;
    
    always @ (posedge clk_i) 
    begin
        if (1'h0 == s_rst_n_i) begin
            data             <= {DATA_WIDTH{1'h0}};
            fsm_state        <= IDLE;
            piso_wr_enable   <= 1'h0;
            duable_stop_flag <= 1'h0;
            data_bit_num     <= {DATA_BIT_WIDTH{1'h0}};
        end 
        else begin
            case (fsm_state)
            IDLE: begin   
                if (1'h1 == enable_i) begin
                    data           <= {DATA_WIDTH{1'h0}};
                    fsm_state      <= START; 
                    piso_wr_enable <= 1'h1;
                end              
            end
            START: begin
                if (1'h1 == baud_tick_i) begin
                    data             <= data_i;
                    fsm_state        <= SEND;
                    piso_wr_enable   <= 1'h1;
                    duable_stop_flag <= stop_bit_num_i;
                    data_bit_num     <= data_bit_num_i - 1'h1;
                end
                else begin
                    piso_wr_enable <= 1'h0;
                end
            end
            SEND: begin    
                if (1'h1 == baud_tick_i) begin
                    if (data_bit_num == counter_value_i) begin
                        data           <= {DATA_WIDTH{1'h0}} + 1'h1;
                        fsm_state      <= STOP;
                        piso_wr_enable <= 1'h1;
                    end
                end
                else begin
                    piso_wr_enable <= 1'h0;
                end
            end
            STOP: begin
                if (1'h1 == baud_tick_i) begin
                    if (1'h1 == enable_i)  begin
                        piso_wr_enable <= 1'h1; 
                       
                        if (1'h0 == duable_stop_flag) begin
                            fsm_state <= START;  
                            data      <= {DATA_WIDTH{1'h0}};
                        end
                        else begin
                            data             <= {DATA_WIDTH{1'h0}} + 1'h1;
                            duable_stop_flag <= 1'h0;
                        end                           
                    end 
                    else begin
                        if (1'h0 == duable_stop_flag) begin
                            fsm_state <= IDLE;  
                        end
                        else begin
                            duable_stop_flag <= 1'h0;
                        end                 
                    end
                end 
                else begin
                    piso_wr_enable <= 1'h0;
                end
            end
            endcase
         end
     end
endmodule

