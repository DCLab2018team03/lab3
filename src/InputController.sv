`include "include/RecorderDefine.vh"

module InputController(
    input           i_clk,
    input           i_rst,
    // Raw Input
    input           i_btn_play,
    input           i_btn_pause,
    input           i_btn_stop,
    input           i_btn_record,
    input   [8:0]   i_sw_speed,
    input           i_sw_interpol,
    // Recorder Core
    output  [15:0]  o_input_event       // 4code,2speed,4param,1inter,5reserved
);
endmodule