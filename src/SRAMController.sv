
module SRAMController(
    input           i_clk,
    input           i_rst,
    // Interface
    input           i_read,
    input           i_write,
    input   [31:0]  i_addr,
    inout   [15:0]  io_data,
    output          o_done,
    // SRAM
    output          SRAM_WE_N,
    output  [19:0]  SRAM_ADDR,
    inout   [15:0]  SRAM_DQ
);

endmodule