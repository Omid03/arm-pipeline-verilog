`timescale 1ns / 1ps

module register
#
(
    parameter num_bit = 8
)
(
    clk,
    rst,
    init,
    ld,
    reg_in,
    reg_out
);

    input  clk;
    input  rst;
    input  init;
    input  ld;
    input  [num_bit-1 : 0]reg_in;
    output [num_bit-1 : 0]reg_out;
    
    reg [num_bit-1 : 0] int_register = 0;

    assign reg_out = int_register;

    always@(posedge clk, posedge rst)
    begin
        if (rst)
            int_register <= 'b0;
        else
        begin
            if (ld)
            begin
                if (init)
                    int_register <= 'b0;
                else
                    int_register <= reg_in;
            end
            else
                int_register <= int_register;
        end
    end

endmodule













