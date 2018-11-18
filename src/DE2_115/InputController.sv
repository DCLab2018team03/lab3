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
    output logic [15:0]  o_input_event,      // 4code,2speed,4param,1inter,5reserved
    
    // AudioCore stop signal
    input i_stop_signal,
);

    logic play_bit, pause_bit, stop_bit, record_bit;

    Debounce db1(.i_in(i_btn_play), .i_clk(i_clk), .o_neg(play_bit));
    Debounce db2(.i_in(i_btn_pause), .i_clk(i_clk), .o_neg(pause_bit));
    Debounce db3(.i_in(i_btn_stop), .i_clk(i_clk), .o_neg(stop_bit));
    Debounce db4(.i_in(i_btn_record), .i_clk(i_clk), .o_neg(record_bit));


    logic [3:0] mode;
    assign mode = {play_bit, pause_bit, stop_bit, record_bit};
    // control information
    logic [3:0] control_code;
    logic [1:0] control_mode;
    logic [3:0] control_speed;
    logic       control_interpol;

    localparam PLAY   = 4'b1000;
    localparam PAUSE  = 4'b0100;
    localparam STOP   = 4'b0010;
    localparam i_STOP = 4'b0000;
    localparam RECORD = 4'b0001;

    localparam SLOW   = 2'b01;
    localparam FAST   = 2'b10;
    


    assign o_input_event = {control_code, control_mode, control_speed, control_interpol, 5'd0};

    always_ff @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            control_code <= 0;
			control_mode <= 0;
			control_speed <= 0;
			control_interpol <= 0;
        end else begin
            case(mode | ~i_stop_signal)
                PLAY: if (control_code != REC_RECORD) control_code <= REC_PLAY;
                PAUSE: if (control_code != REC_STOP) control_code <= REC_PAUSE;
                STOP: control_code <= REC_STOP;
                i_STOP: control_code <= REC_STOP;
                RECORD: if (control_code != REC_PLAY) control_code <= REC_RECORD;
                default: control_code <= control_code;
            endcase
            case (i_sw_speed[1:0])
                SLOW: control_mode <= REC_SLOW;
                FAST: control_mode <= REC_FAST;
                default: control_mode <= REC_NORMAL;
            endcase
            case(i_sw_speed[8:2])
                7'b0000001: control_speed <= 4'd2;
                7'b0000010: control_speed <= 4'd3;
                7'b0000100: control_speed <= 4'd4;
                7'b0001000: control_speed <= 4'd5;
                7'b0010000: control_speed <= 4'd6;
                7'b0100000: control_speed <= 4'd7;
                7'b1000000: control_speed <= 4'd8;
                default: control_speed <= 4'd1;
            endcase
            control_interpol <= i_sw_interpol;
        end
    end

endmodule