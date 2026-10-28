`timescale 1ns / 1ps

module cond_check
(
    cond,
    SR,
    cond_out
);


    input [3:0] cond;
    input [3:0] SR;
    output cond_out;

    wire Z, C, N, V;
    
    reg cond_checked;

    assign {Z, C, N, V} = SR;

    assign cond_out = ~cond_checked;

        always @(*) begin
            case(cond)
                4'b0000: cond_checked = Z;                  //EQ
                4'b0001: cond_checked = ~Z;                 //NE
                4'b0010: cond_checked = C;                  //CS/HS
                4'b0011: cond_checked = ~C;                 //CC/LO
                4'b0100: cond_checked = N;                  //MI
                4'b0101: cond_checked = ~N;                 //PL
                4'b0110: cond_checked = V;                  //VS
                4'b0111: cond_checked = ~V;                 //VC
                4'b1000: cond_checked = C & (~Z);           //HI
                4'b1001: cond_checked = (~C) | (Z);         //LS
                4'b1010: cond_checked = ~(N ^ V);           //GE
                4'b1011: cond_checked = (N ^ V);            //LT
                4'b1100: cond_checked = (~Z) & (~(N ^ V));  //GT
                4'b1101: cond_checked = Z & (N ^ V);        //LE
                4'b1110: cond_checked = 1'b1;               //AL
                default: cond_checked = 1'b0;               //NONE
            endcase
        end

endmodule
