`timescale 1ns / 1ps

module ARM_TB();
    reg clk, rst;
    
    ARM ARM_Core(
        .clk(clk),
        .rst(rst)
    );
    
    initial begin
        rst = 0;
        #20;
        rst = 1;
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
