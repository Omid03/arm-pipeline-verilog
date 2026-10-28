`timescale 1ns / 1ps

module mux3x1
#
(
    parameter num_bit = 8
)
(
    in0,
    in1,
    in2,
    sel,
    out0
);

    input  [num_bit-1 : 0] in0;
    input  [num_bit-1 : 0] in1;
    input  [num_bit-1 : 0] in2;
    input  [1:0] sel;
    output [num_bit-1 : 0] out0;

    assign out0 = sel[1] ? in2 : 
                  sel[0] ? in1 : in0; 

endmodule
