
module AudioBuffer(
    input           i_clk,
    input           i_rst,
    // Audio Core
    input           i_reload,
    input   [31:0]  i_reload_addr,
    input           i_read,
    input   [3:0]   i_increment,
    input           i_write,
    inout   [15:0]  io_data,
    output          o_done,
    // SRAM controller
    output          o_mem_read,
    output          o_mem_write,
    output  [31:0]  o_mem_addr,
    inout   [15:0]  io_mem_data,
    input           i_mem_done
);

  
endmodule