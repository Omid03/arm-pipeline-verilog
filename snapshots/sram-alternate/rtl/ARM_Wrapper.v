`timescale 1ns / 1ps

module ARM_Wrapper(
    input [0:0] clk,
    input [0:0] key
    );
    
    wire rst, locked;
    wire clk_33MHz;
    
    ARM ARM_Core (
        .clk(clk_33MHz),
        .rst(rst),
        .FW_EN(1'b1)
    );
    
    
    ila_0 ILA (
        .clk(clk_33MHz), // input wire clk
    
    
        .probe0(rst), // input wire [0:0]  probe0  
        .probe1(ARM_Core.ID.RF.reg_file[0]), // input wire [31:0]  probe1 
        .probe2(ARM_Core.ID.RF.reg_file[1]), // input wire [31:0]  probe2 
        .probe3(ARM_Core.ID.RF.reg_file[2]), // input wire [31:0]  probe3 
        .probe4(ARM_Core.ID.RF.reg_file[3]), // input wire [31:0]  probe4 
        .probe5(ARM_Core.ID.RF.reg_file[4]), // input wire [31:0]  probe5 
        .probe6(ARM_Core.ID.RF.reg_file[5]), // input wire [31:0]  probe6 
        .probe7(ARM_Core.ID.RF.reg_file[6]) // input wire [31:0]  probe7
    );
    

    
    clk_wiz_0 CLK_WIZ(
        // Clock out ports
        .clk_out1(clk_33MHz),     // output clk_out1
        // Status and control signals
        .reset(1'b0),
        .locked(locked),
        .clk_in1(clk)
     ); 
    
    debouncer deb(
        .trig_in(~key),
        .clk(clk_33MHz),
        .trig_out(rst)
    );

endmodule
