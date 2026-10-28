`timescale 1ns / 1ps

// {Mode, OP-Code, S}
`define MOV     7'b00_1101_x
`define MVN     7'b00_1111_x
`define ADD     7'b00_0100_x
`define ADC     7'b00_0101_x
`define SUB     7'b00_0010_x
`define SBC     7'b00_0110_x
`define AND     7'b00_0000_x
`define ORR     7'b00_1100_x
`define EOR     7'b00_0001_x
`define CMP     7'b00_1010_1
`define TST     7'b00_1000_1
`define LDR     7'b01_0100_1
`define STR     7'b01_0100_0
`define B       7'b10_0xxx_x

// ALU Commands (EXE_CMD)
`define ALU_NOP 4'b0000
`define ALU_MOV 4'b0001
`define ALU_MVN 4'b1001
`define ALU_ADD 4'b0010
`define ALU_ADC 4'b0011
`define ALU_SUB 4'b0100
`define ALU_SBC 4'b0101
`define ALU_AND 4'b0110
`define ALU_ORR 4'b0111
`define ALU_EOR 4'b1000
`define ALU_CMP 4'b0100
`define ALU_TST 4'b0110
`define ALU_LDR 4'b0010
`define ALU_STR 4'b0010

module controller
(    
    opcode,
    mode,
    S,
    control_sig
);

    input [3:0] opcode;
    input [1:0] mode;
    input       S;
    output reg [8:0] control_sig;

    // control_sig = {WB_EN, MEM_R_EN, MEM_W_EN, EXE_CMD, B, S};

    always@(opcode, mode, S)
    begin
        casex ({mode, opcode, S})
            `MOV    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_MOV, 1'b0,    S};
            `MVN    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_MVN, 1'b0,    S};
            `ADD    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_ADD, 1'b0,    S};
            `ADC    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_ADC, 1'b0,    S};
            `SUB    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_SUB, 1'b0,    S};
            `SBC    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_SBC, 1'b0,    S};
            `AND    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_AND, 1'b0,    S};
            `ORR    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_ORR, 1'b0,    S};
            `EOR    : control_sig = {1'b1, 1'b0, 1'b0, `ALU_EOR, 1'b0,    S};
            `CMP    : control_sig = {1'b0, 1'b0, 1'b0, `ALU_CMP, 1'b0,    S};
            `TST    : control_sig = {1'b0, 1'b0, 1'b0, `ALU_TST, 1'b0,    S};
            
            `LDR    : control_sig = {1'b1, 1'b1, 1'b0, `ALU_ADD, 1'b0,    S};
            `STR    : control_sig = {1'b0, 1'b0, 1'b1, `ALU_ADD, 1'b0,    S};
            
            `B      : control_sig = {1'b0, 1'b0, 1'b0, `ALU_NOP, 1'b1, 1'b0};
            default : control_sig = 'b0;
        endcase
    end

endmodule
