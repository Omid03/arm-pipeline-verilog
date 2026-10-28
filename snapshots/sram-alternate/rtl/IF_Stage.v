`timescale 1ns / 1ps

module IF_Stage(
    input clk,
    input rst,
    input freeze,
    input B,
    input [31:0] br_addr,
    output [31:0] instruction_o,
    output [31:0] pc_o
    );
    
    wire [31:0] adder_out;
    wire [31:0] pc_mux_out;
    wire [31:0] pc_out_reg;

    assign pc_o = adder_out;
    
    register #( .num_bit(32) ) pc
    (
        .clk(clk),
        .rst(rst),
        .init('b0),
        .ld(~freeze),
        .reg_in(pc_mux_out),
        .reg_out(pc_out_reg)
    );    

    adder #( .num_bit(32) ) adder_IF
    (
        .in1('d1),
        .in2(pc_out_reg),
        .out0(adder_out)
    );

    mux2x1 #( .num_bit(32) ) pc_mux
    (
        .in0(adder_out),
        .in1(br_addr),
        .sel(B),
        .out0(pc_mux_out)
    );
    
   dist_mem_gen_0 ROM_Instance (
        .a(pc_out_reg[10:0]),
        .spo(instruction_o)
    );
    
    
endmodule
