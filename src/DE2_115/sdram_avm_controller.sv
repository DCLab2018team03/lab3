module sdram_avm_controller (
    input           clk,
    input           rst,
    // Interface
    input           i_read,
    input           i_write,
    input   [31:0]  i_addr,
    inout   [15:0]  io_data,
    output          o_done,
    // SDRAM Controller
    output  [24:0]  o_avm_address,
    output  [3:0]   o_avm_byteenable,
    output          o_avm_chipselect,
    output  [31:0]  o_avm_writedata,
    output          o_avm_read,
    output          o_avm_write,
    input   [31:0]  i_avm_readdata,
    input           i_avm_readdatavalid,
    input           i_avm_waitrequest
);
endmodule