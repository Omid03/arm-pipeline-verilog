`timescale 1ns / 1ps

module forwarding_unit
(
    MEM_Dest,
    WB_Dest,
    src1,
    src2,
    MEM_WB_EN,
    WB_WB_EN,
    FW_EN,
    src1_sel,
    src2_sel
);

    input [3:0] MEM_Dest;
    input [3:0] WB_Dest;
    input [3:0] src1;
    input [3:0] src2;

    input MEM_WB_EN;
    input WB_WB_EN;
    input FW_EN;

    output reg  [1:0] src1_sel;
    output reg  [1:0] src2_sel;

    wire src1_EQ_dest_mem, src2_EQ_dest_mem, src1_EQ_dest_wb, src2_EQ_dest_wb;
    wire mem_check, wb_check;

    assign src1_EQ_dest_mem = (src1 == MEM_Dest) ? 1 : 0;
    assign src2_EQ_dest_mem = (src2 == MEM_Dest) ? 1 : 0;
    assign src1_EQ_dest_wb  = (src1 == WB_Dest)  ? 1 : 0;
    assign src2_EQ_dest_wb  = (src2 == WB_Dest)  ? 1 : 0;

    assign mem_check = (src1_EQ_dest_mem || src2_EQ_dest_mem);
    assign wb_check = (src1_EQ_dest_wb || src2_EQ_dest_wb);

    always @(*) begin
        src1_sel = 2'b00;
        src2_sel = 2'b00;
        if(FW_EN) begin
            if(mem_check) begin
                if(src1_EQ_dest_mem && MEM_WB_EN) src1_sel = 2'b01;
                if(src2_EQ_dest_mem && MEM_WB_EN) src2_sel = 2'b01;
            end
            else if(wb_check) begin
                if(src1_EQ_dest_wb && WB_WB_EN) src1_sel = 2'b10;
                if(src2_EQ_dest_wb && WB_WB_EN) src2_sel = 2'b10;
            end
        end
    end

endmodule
