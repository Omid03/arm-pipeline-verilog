`timescale 1ns / 1ps

module EXE_Stage(
    input MEM_R_EN,
    input MEM_W_EN,
    input [3:0] EXE_CMD,
    input [31:0] Val_Rn,
    input [31:0] Val_Rm,
    input Imm,
    input [11:0] Shift_Operand,
    input [23:0] Signed_Imm_24,
    input [31:0] PC,
    input Cin,
    output [31:0] Br_Addr,
    output [3:0] status_bits,
    output [31:0] ALU_Res
    );
    wire [31:0] Val2;

    Val_2_Generator Val2Gen
    (
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .Imm(Imm),
        .Shift_operand(Shift_Operand), 
        .Val_Rm(Val_Rm), 
        .Val2(Val2)
    );

    ALU alu_inst
    (
        .in1(Val_Rn),
        .in2(Val2),
        .c_in(Cin),
        .EXE_CMD(EXE_CMD),
        .result(ALU_Res), 
        .status_bits(status_bits)
    );
    
    adder #(.num_bit(32)) adder_EXE 
    (
        .in1(PC),
        .in2({{8{Signed_Imm_24[23]}}, Signed_Imm_24}),
        .out0(Br_Addr)
    );
    
endmodule
