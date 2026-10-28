`timescale 1ns / 1ps

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

module ALU
(
    in1, 
    in2, 
    c_in, 
    EXE_CMD,
    result, 
    status_bits
);

    input c_in;
    input signed [31:0] in1; 
    input signed [31:0] in2; 
    input        [03:0] EXE_CMD;

    output reg signed [31:0] result; 
    output            [03:0] status_bits;

    wire OverflowA;
    wire OverflowS;
    wire OverflowAC;
    wire OverflowSC;

    wire Z;
    reg  C;
    wire N;
    reg  V;

    wire [32:0] ADD_result;
    wire [32:0] SUB_result;
    wire [32:0] ADDC_result;
    wire [32:0] SUBC_result;
    
    assign ADD_result   = in1 + in2;
    assign SUB_result   = in1 - in2;
    assign ADDC_result  = ADD_result + c_in;
    assign SUBC_result  = SUB_result + {32{~c_in}};

    assign OverflowA    =  in1[31] & in2[31] &  ~ADD_result[31] |
                          ~in1[31] &~in2[31] &   ADD_result[31];
                          
    assign OverflowAC   =  in1[31] & in2[31] &  ~ADDC_result[31] |
                          ~in1[31] &~in2[31] &   ADDC_result[31];

    assign OverflowS    =  in1[31] &~in2[31] &  ~SUB_result[31] |
                          ~in1[31] & in2[31] &   SUB_result[31];

    assign OverflowSC   =  in1[31] &~in2[31] &  ~SUBC_result[31] |
                          ~in1[31] & in2[31] &   SUBC_result[31];

    assign Z            = ~|result;
    assign N            =   result[31];
    
    assign status_bits  = {Z, C, N, V};
                                                     
    always@(*)
    begin
        case(EXE_CMD)
            `ALU_ADD     : {V, C, result} = {OverflowA , ADD_result};
            `ALU_ADC     : {V, C, result} = {OverflowAC, ADDC_result};
            `ALU_SUB     : {V, C, result} = {OverflowS , SUB_result};
            `ALU_SBC     : {V, C, result} = {OverflowSC, SUBC_result};
            
            `ALU_AND     : {V, C, result} = {1'b0, 1'b0, in1 & in2};
            `ALU_ORR     : {V, C, result} = {1'b0, 1'b0, in1 | in2};
            `ALU_EOR     : {V, C, result} = {1'b0, 1'b0, in1 ^ in2};
            `ALU_MVN     : {V, C, result} = {1'b0, 1'b0, ~(in2)};
            `ALU_MOV     : {V, C, result} = {1'b0, 1'b0,  (in2)};
            default      : {V, C, result} = {1'b0, 1'b0, 32'b0};
        endcase
    end

endmodule
