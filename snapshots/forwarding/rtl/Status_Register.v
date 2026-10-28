`timescale 1ns / 1ps

module Status_Register
(

    clk,
    rst,
    S,
    status_bits_pre,
    status_bits_new
);

    input clk;
    input rst;
    input S;
    input  [3:0] status_bits_pre;
    output reg [3:0] status_bits_new;
    
    always@(negedge clk, posedge rst)
    begin
        if (rst)
            status_bits_new <= 'b0;
        else
        begin
            if (S)
                status_bits_new <= status_bits_pre;
            else
                status_bits_new <= status_bits_new;
        end
    end
 
endmodule
