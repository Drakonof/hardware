`timescale 1ns / 1ps

module comp_8_bit 
(
    input  logic [7 : 0] a_i,
    input  logic [7 : 0] b_i,
           
    output logic         equal_o,
    output logic         greater_o,
    output logic         lower_o
);

    bit x[7 : 0];  

    always_comb begin
        x[0] = (a_i[0] & b_i[0]) | (~a_i[0] & ~b_i[0]);
        x[1] = (a_i[1] & b_i[1]) | (~a_i[1] & ~b_i[1]);
        x[2] = (a_i[2] & b_i[2]) | (~a_i[2] & ~b_i[2]);
        x[3] = (a_i[3] & b_i[3]) | (~a_i[3] & ~b_i[3]);
        x[4] = (a_i[4] & b_i[4]) | (~a_i[4] & ~b_i[4]);
        x[5] = (a_i[5] & b_i[5]) | (~a_i[5] & ~b_i[5]);
        x[6] = (a_i[6] & b_i[6]) | (~a_i[6] & ~b_i[6]);
        x[7] = (a_i[7] & b_i[7]) | (~a_i[7] & ~b_i[7]);
    
   
        greater_o = (a_i[7] & ~b_i[7]) | 
                    (x[7] & a_i[6] & ~b_i[6]) | 
                    (x[7] & x[6] & a_i[5] & ~b_i[5]) |
                    (x[7] & x[6] & x[5] & a_i[4] & ~b_i[4]) |
                    (x[7] & x[6] & x[5] & x[4] & a_i[3] & ~b_i[3]) |
                    (x[7] & x[6] & x[5] & x[4] & x[3] & a_i[2] & ~b_i[2]) |
                    (x[7] & x[6] & x[5] & x[4] & x[3] & x[2] & a_i[1] & ~b_i[1]) |
                    (x[7] & x[6] & x[5] & x[4] & x[3] & x[2] & x[1] & a_i[0] & ~b_i[0]);

        lower_o = (~a_i[7] & b_i[7]) | 
                  (x[7] & ~a_i[6] & b_i[6]) | 
                  (x[7] & x[6] & ~a_i[5] & b_i[5]) |
                  (x[7] & x[6] & x[5] & ~a_i[4] & b_i[4]) |
                  (x[7] & x[6] & x[5] & x[4] & ~a_i[3] & b_i[3]) |
                  (x[7] & x[6] & x[5] & x[4] & x[3] & ~a_i[2] & b_i[2]) |
                  (x[7] & x[6] & x[5] & x[4] & x[3] & x[2] & ~a_i[1] & b_i[1]) |
                  (x[7] & x[6] & x[5] & x[4] & x[3] & x[2] & x[1] & ~a_i[0] & b_i[0]);
                     
        equal_o = x[7] | x[6] | x[5] | x[4] | x[3] | x[2] |x[1] | x[0];
    end


endmodule
