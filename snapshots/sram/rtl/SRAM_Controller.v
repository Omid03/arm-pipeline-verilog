`timescale 1ns / 1ps

module SRAM_Controller(
    input wire clk,
    input wire rst,

    // --- Processor Interface ---
    input wire [31:0] cpu_addr,
    input wire [31:0] cpu_wdata,
    input wire cpu_mem_read,
    input wire cpu_mem_write,
    output reg [31:0] cpu_rdata,
    output wire cpu_ready,

    // --- SRAM Interface  ---
    output reg [10:0] sram_addr,
    inout  wire [7:0] sram_data,
    output reg sram_cs_n,
    output reg sram_oe_n,
    output wire sram_we_n 
);

    localparam IDLE  = 3'd0;
    localparam BYTE0 = 3'd1;
    localparam BYTE1 = 3'd2;
    localparam BYTE2 = 3'd3;
    localparam BYTE3 = 3'd4;
    localparam DONE  = 3'd5;

    reg [2:0] ps, ns;
    reg [7:0] write_byte_buffer;

    assign sram_we_n = !cpu_mem_write;

    assign sram_data = (!sram_cs_n && !sram_we_n) ? write_byte_buffer : 8'bz;

    wire mem_req = cpu_mem_read || cpu_mem_write;
    assign cpu_ready = (ps == DONE) || (ps == IDLE && !mem_req);

    always @(posedge clk or posedge rst) begin
        if (rst) ps <= IDLE;
        else     ps <= ns;
    end

    always @(*) begin
        ns = IDLE;
        case (ps)
            IDLE:  ns = mem_req ? BYTE0 : IDLE;
            BYTE0: ns = BYTE1;
            BYTE1: ns = BYTE2;
            BYTE2: ns = BYTE3;
            BYTE3: ns = DONE;
            DONE:  ns = IDLE;
            default: ns = IDLE;
        endcase
    end
    always @(*) begin
        sram_cs_n = 1;
        sram_oe_n = 1;
        sram_addr = 0;
        write_byte_buffer = 8'b0;
        case (ps)
            IDLE: begin
                if (mem_req)begin
                    sram_addr = {cpu_addr[8:0],2'b0};
                    sram_cs_n = 0;
                    if (cpu_mem_write) begin
                        sram_oe_n = 1;
                        write_byte_buffer = cpu_wdata[7:0];
                    end else begin
                        sram_oe_n = 0;
                    end
                end
            end
            BYTE0: begin
                sram_addr = {cpu_addr[8:0],2'b01};
                sram_cs_n = 0;
                if (cpu_mem_write) begin
                    sram_oe_n = 1;
                    write_byte_buffer = cpu_wdata[15:8];
                end else begin
                    sram_oe_n = 0;
                end
            end
            BYTE1: begin
                sram_addr = {cpu_addr[6:0],2'b10};
                sram_cs_n = 0;
                if (cpu_mem_write) begin
                    sram_oe_n = 1;
                    write_byte_buffer = cpu_wdata[23:16];
                end else begin
                    sram_oe_n = 0;
                end
            end
            BYTE2: begin
                sram_addr = {cpu_addr[6:0],2'b11};
                sram_cs_n = 0;
                if (cpu_mem_write) begin
                    sram_oe_n = 1;
                    write_byte_buffer = cpu_wdata[31:24];
                end else begin
                    sram_oe_n = 0;
                end
            end
            BYTE3: begin sram_cs_n = 0; sram_oe_n = cpu_mem_write; end
            DONE:  ;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            cpu_rdata <= 0;
        end else begin
            case (ps)
                BYTE0: begin
                    if (cpu_mem_read) cpu_rdata[7:0] <= sram_data;
                end
                BYTE1: begin
                    if (cpu_mem_read) cpu_rdata[15:8] <= sram_data;
                end
                BYTE2: begin
                    if (cpu_mem_read) cpu_rdata[23:16] <= sram_data;
                end
                BYTE3: begin
                    if (cpu_mem_read) cpu_rdata[31:24] <= sram_data;
                end
                DONE: ;
                default: ;
            endcase
        end
    end


endmodule