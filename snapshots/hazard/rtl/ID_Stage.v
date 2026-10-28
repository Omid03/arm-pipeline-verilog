`timescale 1ns / 1ps

module ID_Stage(
    clk, 
    rst,
    Instruction,
    Result_WB,
    writeBackEn,
    Dest_wb,
    hazard,
    SR,
    WB_EN, 
    MEM_R_EN, 
    MEM_W_EN, 
    B, 
    S,
    EXE_CMD,
    Val_Rn, 
    Val_Rm,
    imm,
    Shift_operand,
    Signed_imm_24,
    Dest,
    src_1, 
    src_2,
    Two_src
    );

    input clk;
    input rst;
    input hazard;
    input writeBackEn;
    input [3 : 0] SR;
    input [3 : 0] Dest_wb;
    input [31 : 0] Result_WB;
    input [31 : 0] Instruction;

    output B;
    output S;
    output imm;
    output WB_EN;
    output Two_src;
    output MEM_W_EN;
    output MEM_R_EN;
    output [3 : 0] Dest;
    output [3 : 0] EXE_CMD;
    output [3 : 0] src_1;
    output [3 : 0] src_2;
    output [11 : 0] Shift_operand;
    output [23 : 0] Signed_imm_24;
    output [31 : 0] Val_Rn;
    output [31 : 0] Val_Rm;

    wire[8:0] control_sig;
    wire[3:0] opcode, Rn, Rm, Rd, cond;
    wire[1:0] mode;
    wire cond_out;
    wire control_sel;
    wire uncond_MEM_W_EN, uncond_MEM_R_EN;

    wire S_in;

    controller ctrl
    (
        .opcode(opcode),
        .mode(mode),
        .S(S_in),
        .control_sig(control_sig)
    );

    Register_File RF
    (
        .clk(clk),
        .rst(rst),
        .src_1(src_1),
        .src_2(src_2),
        .dest(Dest_wb),
        .result_WB(Result_WB),
        .write_EN(writeBackEn),
        .reg_out_1(Val_Rn),
        .reg_out_2(Val_Rm)
    );
    
    cond_check condition_check
    (
        .cond(cond),
        .SR(SR),
        .cond_out(cond_out)
    );
    
    mux2x1 #(.num_bit(4)) src2mux
    (
        .in0(Rm),
        .in1(Rd),
        .sel(uncond_MEM_W_EN),
        .out0(src_2)
    );

    mux2x1 #(.num_bit(9)) ctrl_mux
    (
        .in0(control_sig),
        .in1(9'b0),
        .sel(control_sel),
        .out0({WB_EN, MEM_R_EN, MEM_W_EN, EXE_CMD, B, S})
    );

    assign control_sel      = hazard | cond_out;

    // Instruction Decode :
    assign cond             = Instruction[31:28];
    assign Rn               = Instruction[19:16];
    assign Rm               = Instruction[3:0];
    assign Rd               = Instruction[15:12];
    assign opcode           = Instruction[24:21];
    assign S_in             = Instruction[20];
    assign mode             = Instruction[27:26];

    //Internal Signals
    assign uncond_MEM_W_EN     = control_sig[6];           // UnConditional MEM_W_EN
    assign uncond_MEM_R_EN     = control_sig[7];           // UnConditional MEM_R_EN
    
    // Outputs
    assign imm              = Instruction[25];
    assign Shift_operand    = Instruction[11:0];
    assign Signed_imm_24    = Instruction[23:0];
    assign Dest             = Instruction[15:12];
    assign Two_src          = ~(uncond_MEM_R_EN | imm);
    assign src_1            = Rn;

endmodule