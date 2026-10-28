`timescale 1ns / 1ps

module adder
#
(
    parameter num_bit = 8
)
(
    in1,
    in2,
    out0
);

    input  [num_bit-1 : 0] in1;
    input  [num_bit-1 : 0] in2;
    output [num_bit-1 : 0] out0;

    assign out0 = in1 + in2;

endmodule
