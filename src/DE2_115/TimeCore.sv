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
    logic [3:0] increment;
    logic [2:0] sub_increment, n_sub_increment;

    logic [3:0] rec_min_1, rec_min_0, rec_sec_1, rec_sec_0;
    logic [3:0] n_rec_min_1, n_rec_min_0, n_rec_sec_1, n_rec_sec_0;
    logic [3:0] play_min_1, play_min_0, play_sec_1, play_sec_0;
    logic [3:0] n_play_min_1, n_play_min_0, n_play_sec_1, n_play_sec_0;
    assign o_record_time = {rec_min_1, rec_min_0, rec_sec_1, rec_sec_0};
    assign o_play_time = {play_min_1, play_min_0, play_sec_1, play_sec_0};


    logic [3:0] control_code;
    logic [5:0] control_mode_and_speed;
    logic       control_interpol;

    assign control_code               = i_input_event[15:12];
    assign control_mode_and_speed     = i_input_event[11:6];
    assign control_interpol           = i_input_event[5];

    localparam SLOW2 = 6'b010010;
    localparam SLOW3 = 6'b010011;
    localparam SLOW4 = 6'b010100;
    localparam SLOW5 = 6'b010101;
    localparam SLOW6 = 6'b010110;
    localparam SLOW7 = 6'b010111;
    localparam SLOW8 = 6'b011000;
    localparam FAST2 = 6'b100010;
    localparam FAST3 = 6'b100011;
    localparam FAST4 = 6'b100100;
    localparam FAST5 = 6'b100101;
    localparam FAST6 = 6'b100110;
    localparam FAST7 = 6'b100111;
    localparam FAST8 = 6'b101000;

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
            sub_increment <= 0;
            clk_counter <= 0;
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
            clk_counter <= n_clk_counter;
            sub_increment = n_sub_increment;
            state <= n_state;
        end
    end

    always_comb begin
        n_state = state;
        n_clk_counter = clk_counter;
        case(control_code)
            REC_RECORD: n_state = RECORD;
            REC_PAUSE : n_state = PAUSE;
            REC_STOP  : n_state = STOP;
            REC_PLAY  : n_state = PLAY;
        endcase

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

        increment = 0;
        n_sub_increment = sub_increment + 1;
        case(control_mode_and_speed)
            FAST2: increment = 2;
            FAST3: increment = 3;
            FAST4: increment = 4;
            FAST5: increment = 5;
            FAST6: increment = 6;
            FAST7: increment = 7;
            FAST8: increment = 8;
            SLOW2: begin
                if(sub_increment == 1) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW3: begin
                if(sub_increment == 2) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW4: begin
                if(sub_increment == 3) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW5: begin
                if(sub_increment == 4) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW6: begin
                if(sub_increment == 5) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW7: begin
                if(sub_increment == 6) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            SLOW8: begin
                if(sub_increment == 7) begin 
                    increment = 1;
                    n_sub_increment = 0;
                end
            end
            default: increment = 1;
        endcase

        case(state)
            RECORD: begin
                if ( clk_counter == 26'd50000000 ) begin
                    n_clk_counter = 0;
                    n_rec_sec_0 = rec_sec_0 + 1;
                end
                else begin
                    n_clk_counter = clk_counter + 1;
                end
            end
            STOP: begin
                n_clk_counter = 0;
                n_play_min_1 = 0;
                n_play_min_0 = 0;
                n_play_sec_1 = 0;
                n_play_sec_0 = 0;
                n_sub_increment = 0;
                if (control_code == REC_RECORD) begin
                    n_rec_min_1 = 0;
                    n_rec_min_0 = 0;
                    n_rec_sec_1 = 0;
                    n_rec_sec_0 = 0;
                end
            end
            PLAY: begin
                if ( clk_counter >= 26'd50000000 ) begin
                    n_clk_counter = 0;
                    n_play_sec_0 = play_sec_0 + 1;
                end
                else begin
                    n_clk_counter = clk_counter + increment;
                end
            end
        endcase
    end
endmodule