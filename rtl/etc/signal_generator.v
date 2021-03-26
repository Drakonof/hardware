`timescale 1ns / 1ps

module signal_generator #
(
    parameter integer SIGNAL_WIDTH = 32,
    parameter         WAVE_FORM = "tri" //tri, saw_p, saw_n, meander
)
(
    input  wire                        clk_i,
    input  wire                        s_rst_n_i,
    input  wire                        enable_i,
    
    output wire [SIGNAL_WIDTH - 1 : 0] signal_o
);

     reg [SIGNAL_WIDTH - 1 : 0] signal;
     assign signal_o = signal;
  
     generate 
         if ("tri" == WAVE_FORM) begin
             
             reg flag;
         
             always @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal <= {SIGNAL_WIDTH{1'h0}};
                     flag   <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     if (1'h1 == flag) begin
                         signal <= signal_o - 1'h1;
                     end
                     else begin
                         signal <= signal_o + 1'h1;
                     end
                 end
             end
             
             always @ (posedge clk_i) begin
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
         
             always @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     signal <= signal_o + 1'h1;
                 end
             end
               
         end  
         else if ("saw_n" == WAVE_FORM) begin
         
             always @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal <= {SIGNAL_WIDTH{1'h1}};
                 end 
                 else if (1'h1 == enable_i) begin
                     signal <= signal_o - 1'h1;
                 end
             end
             
         end
         else if ("meander" == WAVE_FORM) begin
         
             reg [SIGNAL_WIDTH - 1 : 0] counter;
         
             always @ (posedge clk_i) begin
                 if (1'h0 == s_rst_n_i) begin
                     signal <= {SIGNAL_WIDTH{1'h0}};
                     counter  <= {SIGNAL_WIDTH{1'h0}};
                 end 
                 else if (1'h1 == enable_i) begin
                     counter <= counter + 1'h1;
                     
                     if (1'h1 == counter[SIGNAL_WIDTH - 1]) begin
                         signal <= {SIGNAL_WIDTH{1'h1}};
                     end
                     else begin
                         signal <= {SIGNAL_WIDTH{1'h0}};
                     end
                 end
             end
             
         end   
     endgenerate
     
endmodule
