`timescale 1ns / 1ps

module signal_generator #
(
    parameter integer SIGNAL_WIDTH = 32,
    parameter         WAVE_FORM = "tri" //saw_p, saw_n, meander
)
(
    input  logic                        clk_i,
    input  logic                        s_rst_n_i,
    input  logic                        enable_i,
    
    output logic [SIGNAL_WIDTH - 1 : 0] signal_o
);
  
     generate 
         if ("tri" == WAVE_FORM) begin
             
             bit flag;
         
             always_ff @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal_o <= {SIGNAL_WIDTH{1'h0}};
                     flag  <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     if (1'h1 == flag) begin
                         signal_o <= signal_o - 1'h1;
                     end
                     else begin
                         signal_o <= signal_o + 1'h1;
                     end
                 end
             end
             
             always_ff @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     flag <= 1'h0;
                 end 
                 else if (1'h1 == enable_i) begin
                     if ({SIGNAL_WIDTH{1'h1}} == signal_o) begin
                         flag <= 1'h1;
                     end
                     else if ({SIGNAL_WIDTH{1'h0}} == signal_o) begin
                         flag <= 1'h0;
                     end
                 end
             end
             
         end 
         else if ("saw_p" == WAVE_FORM) begin
         
             always_ff @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal_o <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     signal_o <= signal_o + 1'h1;
                 end
             end
               
         end  
         else if ("saw_n" == WAVE_FORM) begin
         
             always_ff @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal_o <= {SIGNAL_WIDTH{1'h1}};
                 end 
                 else if (1'h1 == enable_i) begin
                     signal_o <= signal_o - 1'h1;
                 end
             end
             
         end
         else if ("meander" == WAVE_FORM) begin
         
             logic [SIGNAL_WIDTH - 1 : 0] counter;
         
             always_ff @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal_o <= {SIGNAL_WIDTH{1'h0}};
                     counter  <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     counter <= counter + 1'h1;
                     
                     if (1'h1 == counter[SIGNAL_WIDTH - 1]) begin
                         signal_o <= {SIGNAL_WIDTH{1'h1}};
                     end
                     else begin
                         signal_o <= {SIGNAL_WIDTH{1'h0}};
                     end
                 end
             end
             
         end   
     endgenerate
     
endmodule