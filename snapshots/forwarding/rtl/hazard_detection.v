`timescale 1ns / 1ps

module hazard_detection(
    input  [3:0] src1,
    input  [3:0] src2,
    input  [3:0] EXE_Dest,
    input        EXE_MEM_R_EN,
    input        EXE_WB_EN,
    input        MEM_WB_EN,
    input        Two_src,
    input        FW_EN,
    input  [3:0] MEM_Dest,
    output reg   Hazard
);
    
    wire src1_EQ_dest_exe, src1_EQ_dest_mem, src2_EQ_dest_exe, src2_EQ_dest_mem;

    assign src1_EQ_dest_mem = (src1 == MEM_Dest) ? 1 : 0;
    assign src1_EQ_dest_exe = (src1 == EXE_Dest) ? 1 : 0;
    assign src2_EQ_dest_mem = (src2 == MEM_Dest) ? 1 : 0;
    assign src2_EQ_dest_exe = (src2 == EXE_Dest) ? 1 : 0;

    always @(*) begin
        Hazard = 1'b0;
        case (FW_EN)
            1'b1: 
            begin
                casex({src1_EQ_dest_exe, src2_EQ_dest_exe, EXE_MEM_R_EN, Two_src})
                    4'b1x1x : Hazard = 1'b1;
                    4'bx111 : Hazard = 1'b1;
                endcase
            end
            1'b0: 
            begin
                casex({src1_EQ_dest_mem, src2_EQ_dest_mem, MEM_WB_EN, src1_EQ_dest_exe, src2_EQ_dest_exe, EXE_WB_EN, Two_src})
                    7'b1x1xxxx: Hazard = 1'b1;
                    7'bxxx1x1x: Hazard = 1'b1;
                    7'bx11xxx1: Hazard = 1'b1;
                    7'bxxxx111: Hazard = 1'b1;
                endcase
            end
        endcase
    end
    
endmodule
