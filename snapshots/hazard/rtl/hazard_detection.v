`timescale 1ns / 1ps

module hazard_detection(
    input       [3:0] EXE_Dest,
    input       [3:0] MEM_Dest,
    input       [3:0] src1, src2,
    input       EXE_WB_EN, MEM_WB_EN, Two_src,
    output reg  Hazard
);
    
    wire src1_EQ_dest_exe, src1_EQ_dest_mem, src2_EQ_dest_exe, src2_EQ_dest_mem;

    assign src1_EQ_dest_mem = (src1 == MEM_Dest) ? 1 : 0;
    assign src1_EQ_dest_exe = (src1 == EXE_Dest) ? 1 : 0;
    assign src2_EQ_dest_mem = (src2 == MEM_Dest) ? 1 : 0;
    assign src2_EQ_dest_exe = (src2 == EXE_Dest) ? 1 : 0;

    always @(*) begin
        Hazard = 1'b0;
        begin
            casex({src1_EQ_dest_mem, src2_EQ_dest_mem, MEM_WB_EN, src1_EQ_dest_exe, src2_EQ_dest_exe, EXE_WB_EN, Two_src})
                7'b1x1xxxx: Hazard = 1'b1;
                7'bxxx1x1x: Hazard = 1'b1;
                7'bx11xxx1: Hazard = 1'b1;
                7'bxxxx111: Hazard = 1'b1;
            endcase
        end
    end
    
endmodule
