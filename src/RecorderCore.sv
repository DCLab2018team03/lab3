`include "include/RecorderDefine.vh"

module RecorderCore(
    input           i_clk,
    input           i_rst,
    // Input Controller
    input   [15:0]  i_input_event,          // 4code,2speed,4param,1inter,5reserved
    // Audio Core
    output  [15:0]  o_event,
	 // Output Controller
	 output  [15:0]  o_event_hold,
    // Audio Init 
    output          o_aud_init_start,
    input           i_aud_init_fin,
    // Stop
    input           i_stop
);

endmodule