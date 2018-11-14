`include "include/RecorderDefine.vh"

module AudioCore(
    input           i_clk,
    input           i_rst,
    // Recorder Core
    input   [15:0]  i_event,               // 4code,2speed,4param,1inter,5reserved
    output  [63:0]  o_time,                 // 12current,12total
    // Audio CODEC
    input           AUD_BCLK,
    input           AUD_ADCLRCK,
    input           AUD_ADCDAT,
    input           AUD_DACLRCK,
    output          AUD_DACDAT,
    // Audio Buffer
    output          o_buf_reload,
    output          o_buf_read,
    output          o_buf_write,
    output  [3:0]   o_buf_increment,
    inout   [15:0]  io_buf_data,
    input           i_buf_done,
    output  [31:0]  o_buf_reload_addr,
    // Output Signal
    output          o_stop_signal
);
endmodule