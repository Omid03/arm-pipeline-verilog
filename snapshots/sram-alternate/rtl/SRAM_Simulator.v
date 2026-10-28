`timescale 1ns / 1ps

module SRAM_Model (
    input wire clk,
    input wire [10:0] Address, // 2^11 = 2048 Locations
    input wire CS_n,           // Chip Select (Active Low)
    input wire OE_n,           // Output Enable (Active Low)
    input wire WE_n,           // Write Enable (Active Low)
    inout wire [7:0] DataIO    // Bidirectional Data Bus
);

    wire [7:0] read_data;

    assign DataIO = (!CS_n && !OE_n && WE_n) ? read_data : 8'bz;

   xpm_memory_spram #(
      .ADDR_WIDTH_A(11),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),       // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("none"),     // String
      .MEMORY_INIT_PARAM("0"),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE(2048*8),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(8),        // DECIMAL
      .READ_LATENCY_A(1),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .USE_MEM_INIT(0),              // DECIMAL
      .WAKEUP_TIME("disable_sleep"), // String
      .WRITE_DATA_WIDTH_A(8),       // DECIMAL
      .WRITE_MODE_A("write_first")    // String
   )
   xpm_memory_spram_inst (
      .dbiterra(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port A.

      .douta(read_data),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .sbiterra(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port A.

      .addra(Address),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      .clka(clk),                     // 1-bit input: Clock signal for port A.
      .dina(DataIO),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(1'b1),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read or write operations are initiated. Pipelined
                                       // internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regcea(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rsta(1'b0),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(~WE_n)                        // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                                       // data port dina. 1 bit wide when word-wide writes are used. In
                                       // byte-wide write configurations, each bit controls the writing one
                                       // byte of dina to address addra. For example, to synchronously write
                                       // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
                                       // 4'b0010.

   );
endmodule