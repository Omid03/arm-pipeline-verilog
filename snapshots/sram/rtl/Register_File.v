`timescale 1ns / 1ps

module Register_File
#
(
    parameter num_bit = 32,
    parameter num_len = 16

)
(
    clk,
    rst,
    src_1,
    src_2,
    dest,
    result_WB,
    write_EN,
    reg_out_1,
    reg_out_2
);

    input    clk;
    input    rst;
    input [$clog2(num_len)-1:0] src_1;
    input [$clog2(num_len)-1:0] src_2;
    input [$clog2(num_len)-1:0] dest;
    input [num_bit-1:0] result_WB;
    input write_EN;
    output [num_bit-1:0] reg_out_1;
    output [num_bit-1:0] reg_out_2;

    integer i;

    reg [num_bit-1:0] reg_file [0:num_len-1];

    assign reg_out_1 = reg_file[src_1];
    assign reg_out_2 = reg_file[src_2];

    always@(negedge clk, posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i< num_len ; i=i+1)
                reg_file[i] <= i;
        end
        else
        begin
            if(write_EN) reg_file[dest] <= result_WB;
        end                
    end

endmodule
