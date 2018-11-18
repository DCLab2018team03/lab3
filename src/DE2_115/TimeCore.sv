`include "include/RecorderDefine.vh"

module TimeCore(
    input i_clk,
    input i_rst,
    input [15:0] i_input_event,

    // LCD timing information
    output logic [15:0]  o_record_time,
    output logic [15:0]  o_play_time 
);
    
    logic [2:0] state, n_state;
    localparam IDLE   = 3'd0;
    localparam RECORD = 3'd1;
    localparam PAUSE  = 3'd2;
    localparam STOP   = 3'd3;
    localparam PLAY   = 3'd4;


    // timing information
    // 50000000 s -> 1 sec
    logic [25:0] clk_counter, n_clk_counter;
    logic [3:0] rec_min_1, rec_min_0, rec_sec_1, rec_sec_0;
    logic [3:0] n_rec_min_1, n_rec_min_0, n_rec_sec_1, n_rec_sec_0;
    logic [3:0] play_min_1, play_min_0, play_sec_1, play_sec_0;
    logic [3:0] n_play_min_1, n_play_min_0, n_play_sec_1, n_play_sec_0;
    assign o_record_time = {rec_min_1, rec_min_0, rec_sec_1, rec_sec_0};
    assign o_plat_time = {play_min_1, play_min_0, play_sec_1, play_sec_0};

    always_ff @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            rec_min_1  <= 0;
            rec_min_0  <= 0;
            rec_sec_1  <= 0;
            rec_sec_0  <= 0;
            play_min_1 <= 0;
            play_min_0 <= 0;
            play_sec_1 <= 0;
            play_sec_0 <= 0;

            state <= IDLE;
        end else begin
            rec_min_1  <= n_rec_min_1;
            rec_min_0  <= n_rec_min_0;
            rec_sec_1  <= n_rec_sec_1;
            rec_sec_0  <= n_rec_sec_0;
            play_min_1 <= n_play_min_1;
            play_min_0 <= n_play_min_0;
            play_sec_1 <= n_play_sec_1;
            play_sec_0 <= n_play_sec_0;

            state <= n_state;
        end
    end

    always_comb begin
        n_state = state;
        n_clk_counter = clk_counter;
        case(i_input_event[15:12]) begin
            REC_RECORD: n_state = RECORD;
            REC_PAUSE : n_state = PAUSE;
            REC_STOP  : n_state = STOP;
            REC_PLAY  : n_state = PLAY;
        end

        n_rec_min_1  = rec_min_1; 
        n_rec_min_0  = rec_min_0; 
        n_rec_sec_1  = rec_sec_1;
        n_rec_sec_0  = rec_sec_0;
        n_play_min_1 = play_min_1;
        n_play_min_0 = play_min_0;
        n_play_sec_1 = play_sec_1;
        n_play_sec_0 = play_sec_0;

        if (rec_sec_0 == 4'd10) begin
            n_rec_sec_0 = 0;
            n_rec_sec_1 = rec_sec_1 + 1;
        end

        if (rec_sec_1 == 4'd6) begin
            n_rec_sec_1 = 0;
            n_rec_min_0= rec_min_0 + 1;
        end

        if (rec_min_0 == 4'd10) begin
            n_rec_min_0 = 0;
            n_rec_min_1 = rec_min_1 + 1;
        end



        case(state)
            RECORD: begin
                if ( clk_counter >= 26'd50000000 ) begin
                    n_clk_counter = 0;
                    n_rec_sec0 = rec_sec0 + 1;
                end
                else begin
                    n_clk_counter = clk_counter + 1;
                end
            end
            PAUSE: begin
                
            end
            STOP: begin
                
            end
            PLAY: begin
                
            end

            default:
        endcase
    end
