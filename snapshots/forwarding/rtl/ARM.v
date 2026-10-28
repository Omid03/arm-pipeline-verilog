`timescale 1ns / 1ps

module ARM(
    input [0:0] clk,
    input [0:0] rst,
    input [0:0] FW_EN
    );
    
    //Hazard_Detection_Signals
    wire hazard, Two_src;

    //IF_Stage_Signals
    wire[31:0] IF_instruction_o, IF_pc_o;

    //ID_Stage_Signals
    wire[31:0] ID_instruction_i, ID_pc_i, ID_Result_WB_i, ID_Val_Rn_o, ID_Val_Rm_o;
    wire[23:0] ID_Signed_imm_24_o;
    wire[11:0] ID_Shift_operand_o;
    wire[3:0]  ID_EXE_CMD_o, ID_Dest_o, ID_src_1_o, ID_src_2_o;
    wire       ID_WB_o, ID_MEM_R_EN_o, ID_MEM_W_EN_o, ID_B_o, ID_S_o, ID_imm_o;

    //EXE_Stage_Signals
    wire[31:0] EXE_br_addr_o, EXE_pc_i, EXE_Val_Rn_i, EXE_Val_Rm_i, EXE_ALU_Result_o;
    wire[23:0] EXE_Signed_imm_24_i;
    wire[11:0] EXE_Shift_operand_i;
    wire[3:0]  EXE_EXE_CMD_i, EXE_Dest_i, EXE_src_1_i, EXE_src_2_i, EXE_status_bits_o;
    wire       EXE_WB_i, EXE_MEM_R_EN_i, EXE_MEM_W_EN_i, EXE_B_i, EXE_S_i, EXE_imm_i, Cin;

    //MEM_Stage_Signals
    wire[31:0] MEM_ALU_Result_i, MEM_Val_Rm_i, MEM_data_o;
    wire[3:0]  MEM_Dest_i;
    wire       MEM_WB_i, MEM_MEM_R_EN_i, MEM_MEM_W_EN_i;

    //WB_Stage_Signals
    wire[31:0] WB_ALU_Result_i, WB_data_i, WB_Value_o;
    wire[3:0]  WB_Dest_i;
    wire       WB_WB_i, WB_MEM_R_EN_i;

    //Status Reg
    wire[3:0] SR_status_bits_o;

    //Forwarding Unit
    wire[1:0]  src1_sel, src2_sel;
    wire[31:0] Forward_Val1, Forward_Val2;

    IF_Stage IF(
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .B(EXE_B_i),
        .br_addr(EXE_br_addr_o),
        .instruction_o(IF_instruction_o),
        .pc_o(IF_pc_o)
    );

    register_pipe #( .num_bit(64) ) IF_ID_Pipe(
        .clk(clk),
        .rst(rst),
        .flush(EXE_B_i),
        .freeze(hazard),
        .in_reg({IF_instruction_o, IF_pc_o}),
        .out_reg({ID_instruction_i, ID_pc_i})
    );
    
    ID_Stage ID(
        .clk(clk),
        .rst(rst),
        .Instruction(ID_instruction_i),
        .Result_WB(WB_Value_o),
        .writeBackEn(WB_WB_i),
        .Dest_wb(WB_Dest_i),
        .hazard(hazard),
        .SR(SR_status_bits_o),
        .WB_EN(ID_WB_o),
        .MEM_R_EN(ID_MEM_R_EN_o),
        .MEM_W_EN(ID_MEM_W_EN_o),
        .B(ID_B_o),
        .S(ID_S_o),
        .EXE_CMD(ID_EXE_CMD_o),
        .Val_Rn(ID_Val_Rn_o),
        .Val_Rm(ID_Val_Rm_o),
        .imm(ID_imm_o),
        .Shift_operand(ID_Shift_operand_o),
        .Signed_imm_24(ID_Signed_imm_24_o),
        .Dest(ID_Dest_o),
        .src_1(ID_src_1_o),
        .src_2(ID_src_2_o),
        .Two_src(Two_src)
    );

    register_pipe #( .num_bit(155) ) ID_EXE_Pipe(
        .clk(clk),
        .rst(rst),
        .flush(EXE_B_i),
        .freeze(1'b0),
        .in_reg({ID_pc_i           , ID_src_2_o         , ID_src_1_o , ID_Dest_o  , 
                ID_Signed_imm_24_o , ID_Shift_operand_o , ID_imm_o   , ID_Val_Rm_o, 
                ID_Val_Rn_o        , ID_EXE_CMD_o       , ID_S_o     , ID_B_o     , 
                ID_MEM_W_EN_o      , ID_MEM_R_EN_o      , ID_WB_o    , SR_status_bits_o[2]}),
        .out_reg({EXE_pc_i         , EXE_src_2_i        , EXE_src_1_i, EXE_Dest_i  , 
                EXE_Signed_imm_24_i, EXE_Shift_operand_i, EXE_imm_i  , EXE_Val_Rm_i, 
                EXE_Val_Rn_i       , EXE_EXE_CMD_i      , EXE_S_i    , EXE_B_i    , 
                EXE_MEM_W_EN_i     , EXE_MEM_R_EN_i     , EXE_WB_i , Cin})
    );

    //___________________________________________________________
    //Forwarding MUX
    mux3x1 #( .num_bit(32) ) Forwarding_MUX1(
        .in0(EXE_Val_Rn_i),
        .in1(MEM_ALU_Result_i),
        .in2(WB_Value_o),
        .sel(src1_sel),
        .out0(Forward_Val1)
    );

    mux3x1 #( .num_bit(32) ) Forwarding_MUX2(
        .in0(EXE_Val_Rm_i),
        .in1(MEM_ALU_Result_i),
        .in2(WB_Value_o),
        .sel(src2_sel),
        .out0(Forward_Val2)
    );
    //___________________________________________________________
    
    EXE_Stage EXE(
        .MEM_R_EN(EXE_MEM_R_EN_i),
        .MEM_W_EN(EXE_MEM_W_EN_i),
        .EXE_CMD(EXE_EXE_CMD_i),
        .Val_Rn(Forward_Val1),
        .Val_Rm(Forward_Val2),
        .Imm(EXE_imm_i),
        .Shift_Operand(EXE_Shift_operand_i),
        .Signed_Imm_24(EXE_Signed_imm_24_i),
        .PC(EXE_pc_i),
        .Cin(Cin),
        .Br_Addr(EXE_br_addr_o),
        .status_bits(EXE_status_bits_o),
        .ALU_Res(EXE_ALU_Result_o)
    );

    Status_Register Status_Reg(
        .clk(clk),
        .rst(rst),
        .S(EXE_S_i),
        .status_bits_pre(EXE_status_bits_o),
        .status_bits_new(SR_status_bits_o)
    );

    register_pipe #( .num_bit(71) ) EXE_MEM_Pipe(
        .clk(clk),
        .rst(rst),
        .flush(1'b0),
        .freeze(1'b0),
        .in_reg({EXE_WB_i, EXE_MEM_R_EN_i, EXE_MEM_W_EN_i, EXE_Dest_i, EXE_ALU_Result_o, EXE_Val_Rm_i}),
        .out_reg({MEM_WB_i, MEM_MEM_R_EN_i, MEM_MEM_W_EN_i, MEM_Dest_i, MEM_ALU_Result_i, MEM_Val_Rm_i})
    );
    
    dist_mem_gen_1 Data_Memory (
      .a(MEM_ALU_Result_i[10:0]),      // input wire [10 : 0] a
      .d(MEM_Val_Rm_i),      // input wire [31 : 0] d
      .clk(clk),  // input wire clk
      .we(MEM_MEM_W_EN_i),    // input wire we
      .spo(MEM_data_o)  // output wire [31 : 0] spo
    );

    register_pipe #( .num_bit(70) ) MEM_WB_Pipe(
        .clk(clk),
        .rst(rst),
        .flush(1'b0),
        .freeze(1'b0),
        .in_reg({MEM_WB_i, MEM_MEM_R_EN_i, MEM_ALU_Result_i, MEM_data_o, MEM_Dest_i}),
        .out_reg({WB_WB_i, WB_MEM_R_EN_i, WB_ALU_Result_i, WB_data_i, WB_Dest_i})
    );

    mux2x1 #(.num_bit(32)) WB_Stage
    (
        .in0(WB_ALU_Result_i),
        .in1(WB_data_i),
        .sel(WB_MEM_R_EN_i),
        .out0(WB_Value_o)
    );

    hazard_detection Hazard_Detector(
        .EXE_Dest(EXE_Dest_i),
        .MEM_Dest(MEM_Dest_i),
        .src1(ID_src_1_o),
        .src2(ID_src_2_o),
        .EXE_WB_EN(EXE_WB_i),
        .MEM_WB_EN(MEM_WB_i),
        .Two_src(Two_src),
        .Hazard(hazard),
        .EXE_MEM_R_EN(EXE_MEM_R_EN_i),
        .FW_EN(FW_EN)
    );

    forwarding_unit Forwarding_Unit(
        .MEM_Dest(MEM_Dest_i),
        .WB_Dest(WB_Dest_i),
        .src1(EXE_src_1_i),
        .src2(EXE_src_2_i),
        .MEM_WB_EN(MEM_WB_i),
        .WB_WB_EN(WB_WB_i),
        .FW_EN(FW_EN),
        .src1_sel(src1_sel),
        .src2_sel(src2_sel)
    );
    
endmodule
