`include "include/RecorderDefine.vh"

module RecorderCore(
    input           i_clk,
    input           i_rst,
    // Input Controller
    input  [15:0]  i_input_event,          // 4code,2speed,4param,1inter,5reserved
    // Audio Core
    output [15:0]  o_event,
	// Output Controller to LCD
	output [15:0]  o_event_hold,
    // Stop
    input           i_stop
);
    parameter IDLE   = 2'd0;
    parameter PLAY   = 2'd1;
    parameter PAUSE  = 2'd2;
    parameter RECORD = 2'd3;

    logic [3:0] control_code;
    logic [1:0] control_mode;
    logic [3:0] control_speed;
    logic       control_interpol;

    assign control_code     = i_input_event[15:12];
    assign control_mode     = i_input_event[11:10];
    assign control_speed    = i_input_event[9:6];
    assign control_interpol = i_input_event[5];
    assign o_event = i_input_event;
    assign o_event_hold = i_input_event;

    logic [2:0] state, n_state;

    always_ff @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            state <= IDLE;
        end else begin
            state <= n_state;
        end
    end

    always_comb begin
        n_state = state;
        case(state)
            IDLE: begin
                case(control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                    end
                    REC_RECORD: begin
                        n_state = RECORD;
                    end
                    default: n_state = IDLE;
                endcase
            end
            PLAY: begin
                case(control_code)
                    REC_PAUSE: begin
                        n_state = PAUSE;
                    end
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    default: n_state = state;
                endcase
                if (i_stop) begin
                    n_state = IDLE;
                end
            end
            PAUSE: begin
                case(control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                    end
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    default: n_state = state;
                endcase
                if (i_stop) begin
                    n_state = IDLE;
                end
            end
            RECORD: begin  // can merge with PLAY
                case(control_code)
                    REC_PAUSE: begin
                        n_state = PAUSE;
                    end
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    default: n_state = state;
                endcase
                if (i_stop) begin
                    n_state = IDLE;
                end
            end
        endcase
    end
endmodule