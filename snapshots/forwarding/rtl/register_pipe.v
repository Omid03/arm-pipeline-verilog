`timescale 1ns / 1ps

module register_pipe
#
(
    parameter num_bit = 8
)
(
    clk,
    rst,
    flush,
    freeze,
    in_reg,
    out_reg
);

    input  clk;
    input  rst;
    input  flush;
    input  freeze;
    input  [num_bit-1 : 0] in_reg;
    output [num_bit-1 : 0] out_reg;

    reg [num_bit-1 : 0] int_register;

    assign out_reg = int_register;
    
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            int_register <= 'b0;
        else
        begin
            if (~freeze)
            begin
                if (flush)
                    int_register <= 'b0;
                else
                    int_register <= in_reg;
            end
            else
                int_register <= int_register;
        end
    end

endmodule





