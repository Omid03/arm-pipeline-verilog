`timescale 1ns / 1ps

module mux2x1
#
(
    parameter num_bit = 8
)
(
    in0,
    in1,
    sel,
    out0
);

    input  [num_bit-1 : 0] in0;
    input  [num_bit-1 : 0] in1;
    input  sel;
    output [num_bit-1 : 0] out0;

    assign out0 = sel ? in1 : in0; 

endmodule
