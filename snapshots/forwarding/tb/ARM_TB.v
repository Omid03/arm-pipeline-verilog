`timescale 1ns / 1ps

module ARM_TB();
    reg clk, rst, FW_EN;
    
    ARM ARM_Core(
        .clk(clk),
        .rst(rst),
        .FW_EN(FW_EN)
    );
    
    initial begin
        rst = 0;
        FW_EN = 0;
        #20;
        rst = 1;
        #20;
        rst = 0;
        #10000;
        rst = 1;
        FW_EN = 1;
        #20;
        rst = 0;
        #10000;
        $stop;
    end
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
endmodule
