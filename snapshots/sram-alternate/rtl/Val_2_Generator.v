`timescale 1ns / 1ps

module Val_2_Generator
(
    MEM_R_EN,
    MEM_W_EN,
    Imm,
    Shift_operand, 
    Val_Rm, 
    Val2
);

    input       MEM_R_EN; 
    input       MEM_W_EN; 
    input       Imm;
    input       [11:0] Shift_operand; 
    input       [31:0] Val_Rm; 
    output reg  [31:0] Val2;

    wire [31:0] rotated_value;
    wire mem_access;

    assign mem_access = MEM_R_EN | MEM_W_EN;

    Rotational_Shifter rotate_shifter
    (
        .Imm(Imm),
        .shifter_operand(Shift_operand),
        .Val_Rm(Val_Rm),
        .rotated_value(rotated_value)
    );

    always@(*)
    begin
        casex({mem_access, Imm, Shift_operand[6:4]})
            5'b1xxxx: Val2 <= {{20{Shift_operand[11]}}, Shift_operand};
            5'b01xxx: Val2 <= rotated_value;
            5'b00000: Val2 <= Val_Rm <<  Shift_operand[11:7];
            5'b00010: Val2 <= Val_Rm >>  Shift_operand[11:7];
            5'b00100: Val2 <= Val_Rm >>> Shift_operand[11:7];
            5'b00110: Val2 <= rotated_value;
            default : Val2 <= 'b0;
        endcase
    end 
    
endmodule
