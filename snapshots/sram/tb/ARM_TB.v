`timescale 1ns / 1ps

module ARM_TB();
    reg clk, rst;
    
    ARM ARM_Core(
        .clk(clk),
        .rst(rst),
        .FW_EN(1'b1)
    );
    
    initial begin
        rst = 0;
        #20;
        rst = 1;
        #20;
        rst = 0;
        #50000;
        $stop;
    end
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
endmodule
