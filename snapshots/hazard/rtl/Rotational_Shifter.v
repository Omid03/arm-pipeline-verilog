`timescale 1ns / 1ps

module Rotational_Shifter
(
    input  [0:0]  Imm,
    input  [11:0] shifter_operand,
    input  [31:0] Val_Rm,
    output [31:0] rotated_value
);

    wire [4:0] rotate_imm;
    wire [32:0] immed_32;
    
    assign immed_32      = Imm ? {24'b0, shifter_operand[7:0]} : Val_Rm;
    assign rotate_imm    = Imm ? {1'b0, shifter_operand[11:8]} << 1 : shifter_operand[11:7];
    assign rotated_value = immed_32 >> rotate_imm | immed_32 << (32 - rotate_imm);
endmodule
