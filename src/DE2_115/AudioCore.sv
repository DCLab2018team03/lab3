`include "include/RecorderDefine.vh"

module AudioCore(
    input           i_clk,
    input           i_rst,
    // Recorder Core
    input   [15:0]  i_event,                // 4code,2speed,4param,1inter,5reserved
    output  [63:0]  o_time,                 // 12current,12total
    output  o_stop_signal,
    // avalon_audio_slave
    // avalon_left_channel_source
    output logic from_adc_left_channel_ready,
    input  [15:0] from_adc_left_channel_data,
    input  from_adc_left_channel_valid,
    // avalon_right_channel_source
    output logic from_adc_right_channel_ready,
    input  [15:0] from_adc_right_channel_data,
    input  from_adc_right_channel_valid,
    // avalon_left_channel_sink
    output logic [15:0] to_dac_left_channel_data,
    output logic to_dac_left_channel_valid,
    input  to_dac_left_channel_ready,
    // avalon_right_channel_sink
    output logic [15:0] to_dac_right_channel_data,
    output logic to_dac_right_channel_valid,
    input  to_dac_right_channel_ready,
    // SRAM
    inout  logic [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
    output logic [19:0] SRAM_ADDR,   // SRAM Address bus 20 Bits
    output logic        SRAM_WE_N,   // SRAM Write Enable
    output logic        SRAM_CE_N,   // SRAM Chip Enable
    output logic        SRAM_OE_N,   // SRAM Output Enable
    output logic        SRAM_LB_N,   // SRAM Low-byte Data Mask 
    output logic        SRAM_UB_N   // SRAM High-byte Data Mask   
);

    logic [3:0] control_code;  // 1:play, 2:pause, 3:stop, 4:record
    logic [1:0] control_mode;  // 0:normal, 1:slow or 2:fast
    logic [4:0] control_speed; // 1X~8X
    logic control_interpol;    // 0 or 1
    assign control_code     = i_event[15:12];
    assign control_mode     = i_event[11:10];
    assign control_speed    = i_event[9:6];
    assign control_interpol = i_event[5];
    
    localparam IDLE = 0;
    localparam PLAY = 1;
    localparam PLAY_PAUSE = 2;
    localparam RECORD = 3;
    localparam RECORD_PAUSE = 4;
    localparam WRITE_DATALENGTH_BEFORE_STOP = 5;
    localparam WRITE_DATALENGTH_BEFORE_PAUSE = 6;

    logic [2:0] state, n_state;
    logic [15:0] dacdatLeft_prev_r, dacdatLeft_prev_w;
    logic [15:0] dacdatRight_prev_r, dacdatRight_prev_w;
    logic [3:0] slow_counter_r, slow_counter_w;
    logic [31:0] play_counter_r, play_counter_w;
    logic [15:0] interpolLeft_r, interpolLeft_w, interpolRight_r, interpolRight_w;
    logic [31:0] data_length_r, data_length_w;
    logic writedatalength_counter_w, writedatalength_counter_r;
    // output control
    assign o_time = {play_counter_r, data_length_r};
    assign o_stop_signal = (play_counter_r == data_length_r) ? 1 : 0;
    // audio
    logic n_to_dac_left_channel_valid, n_to_dac_right_channel_valid;
    // sram
    logic [15:0] n_SRAM_DQ;
    logic [19:0] n_SRAM_ADDR;
    localparam SRAM_NOT_SELECT = 5'b01000;
    localparam SRAM_READ       = 5'b10000;
    localparam SRAM_WRITE      = 5'b00000;
    assign SRAM_ADDR = address_r;
    assign SRAM_DQ = SRAM_WE_N ? 16'hzzzz : n_SRAM_DQ;

    AudioCoreInterpolation interpolLeft(
        .i_data_prev(dacdatLeft_prev_r),
        .i_data(SRAM_DQ),
        .i_divisor(control_speed),
        .o_quotient(interpolLeft_w)
    );
    AudioCoreInterpolation interpolRight(
        .i_data_prev(dacdatRight_prev_r),
        .i_data(SRAM_DQ),
        .i_divisor(control_speed),
        .o_quotient(interpolRight_w)
    );
    
    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            state <= IDLE;
            dacdatLeft_prev_r <= 0;
            dacdatRight_prev_r <= 0;
            slow_counter_r <= 0;
            play_counter_r <= 0;
            interpolLeft_r <= 0;
            interpolRight_r <= 0;
            data_length_r <= 0;
            writedatalength_counter_r <= 0;
            SRAM_ADDR <= 0;
            to_dac_left_channel_valid = 0;
            to_dac_right_channel_valid = 0;
        end
        else begin
            state <= n_state;
            dacdatLeft_prev_r <= dacdatLeft_prev_w;
            dacdatRight_prev_r <= dacdatRight_prev_w;
            slow_counter_r <= slow_counter_w;
            play_counter_r <= play_counter_w;
            interpolLeft_r <= interpolLeft_w;
            interpolRight_r <= interpolRight_w;
            data_length_r <= data_length_w;
            writedatalength_counter_r <= writedatalength_counter_w;
            SRAM_ADDR <= n_SRAM_ADDR;
            to_dac_left_channel_valid  = n_to_dac_left_channel_valid;
            to_dac_right_channel_valid = n_to_dac_right_channel_valid;
        end
    end

    always_comb begin
        n_state = state;
        dacdatLeft_prev_w = dacdatLeft_prev_r;
        dacdatRight_prev_w = dacdatRight_prev_r;
        slow_counter_w = slow_counter_r;
        play_counter_w = play_counter_r;
        data_length_w = data_length_r;
        writedatalength_counter_w = writedatalength_counter_r;

        n_SRAM_ADDR = SRAM_ADDR;
        from_adc_left_channel_ready = 0;
        n_SRAM_DQ = 0;
        setSRAMenable(NOT_SELECT);
        n_debug = debug;
        n_to_dac_left_channel_valid = to_dac_left_channel_valid;
        n_to_dac_right_channel_valid = to_dac_right_channel_valid;      

        case (state)
            IDLE: begin
                case (control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                        n_SRAM_ADDR = 0;
                        play_counter_w = 0;
                        n_to_dac_left_channel_valid = 1;
                        n_to_dac_right_channel_valid = 0;
                    end
                    REC_RECORD: begin
                        n_state = RECORD;
                        n_SRAM_ADDR = 2;
                    end
                endcase
            end
            PLAY: begin
                case (control_code)
                    REC_PAUSE: n_state = PLAY_PAUSE;
                    REC_STOP: n_state = IDLE;
                endcase
                setSRAMenable(SRAM_READ);
                if (SRAM_ADDR == 0) begin
                    data_length_w[31:16] = SRAM_DQ;
                end
                else if (SRAM_ADDR == 1) begin
                    data_length_w[15:0] = SRAM_DQ;
                end
                else begin
                    case (control_mode)
                        REC_NORMAL: begin
                            to_dac_left_channel_data = SRAM_DQ;
                            to_dac_right_channel_data = SRAM_DQ;
                            if (to_dac_left_channel_ready && to_dac_left_channel_valid) begin
                                n_to_dac_right_channel_valid = 1;
                                n_to_dac_left_channel_valid = 0;
                                n_SRAM_ADDR = SRAM_ADDR + 1;
                                play_counter_w = play_counter_r + 1; 
                            end
                            if (to_dac_right_channel_ready && to_dac_right_channel_valid) begin
                                n_to_dac_right_channel_valid = 0;
                                n_to_dac_left_channel_valid = 1;
                                n_SRAM_ADDR = SRAM_ADDR + 1;
                                play_counter_w = play_counter_r + 1;
                            end
                        end
                        REC_SLOW: begin
                            if (control_interpol == 0) begin
                                to_dac_left_channel_data = SRAM_DQ;
                                to_dac_right_channel_data = SRAM_DQ;
                            end
                            else begin
                                to_dac_left_channel_data = SRAM_DQ + interpolLeft_r*slow_counter_r;
                                to_dac_right_channel_data = SRAM_DQ + interpolRight_r*slow_counter_r;
                            end
                            if (to_dac_left_channel_ready && to_dac_left_channel_valid) begin
                                n_to_dac_right_channel_valid = 1;
                                n_to_dac_left_channel_valid = 0;
                                if (slow_counter_r == control_speed - 1) begin 
                                    n_SRAM_ADDR = SRAM_ADDR + 1;
                                    slow_counter_w = 0;
                                    dacdatLeft_prev_w = SRAM_DQ;
                                    dacdatRight_prev_w = SRAM_DQ;
                                    play_counter_w = play_counter_r + 1; 
                                end
                                else slow_counter_w = slow_counter_r + 1;
                            end
                            if (to_dac_right_channel_ready && to_dac_right_channel_valid) begin
                                n_to_dac_right_channel_valid = 0;
                                n_to_dac_left_channel_valid = 1;
                                n_SRAM_ADDR = SRAM_ADDR + 1;
                                if (slow_counter_r == control_speed - 1) begin
                                    n_SRAM_ADDR = SRAM_ADDR + 1;
                                    slow_counter_w = 0;
                                    dacdatLeft_prev_w = SRAM_DQ;
                                    dacdatRight_prev_w = SRAM_DQ;
                                    play_counter_w = play_counter_r + 1; 
                                end
                                else slow_counter_w = slow_counter_r + 1;
                            end                      
                        end
                        REC_FAST: begin
                            to_dac_left_channel_data = SRAM_DQ;
                            to_dac_right_channel_data = SRAM_DQ;
                            if (to_dac_left_channel_ready && to_dac_left_channel_valid) begin
                                n_to_dac_right_channel_valid = 1;
                                n_to_dac_left_channel_valid = 0;
                                n_SRAM_ADDR = SRAM_ADDR + control_speed;
                                play_counter_w = play_counter_r + control_speed; 
                            end
                            if (to_dac_right_channel_ready && to_dac_right_channel_valid) begin
                                n_to_dac_right_channel_valid = 0;
                                n_to_dac_left_channel_valid = 1;
                                n_SRAM_ADDR = SRAM_ADDR + control_speed;
                                play_counter_w = play_counter_r + control_speed;
                            end
                        end
                    endcase
                end
            end
            PLAY_PAUSE: begin
                case (control_code)
                    REC_PLAY: n_state = PLAY;
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    REC_RECORD: begin
                        n_state = RECORD;
                        n_SRAM_ADDR = 4;   
                    end
                endcase
            end
            RECORD: begin
                case (control_code)
                    REC_PAUSE: begin
                        n_state = WRITE_DATALENGTH_BEFORE_PAUSE;
                        data_length_w = {12'd0, SRAM_ADDR};
                    end
                    REC_STOP: begin
                        n_state = WRITE_DATALENGTH_BEFORE_STOP;
                        data_length_w = {12'd0, SRAM_ADDR};
                    end
                endcase
                from_adc_left_channel_ready = 1;    
                if ( from_adc_left_channel_valid ) begin
                    setSRAMenable(SRAM_WRITE);
                    n_SRAM_DQ = from_adc_left_channel_data;
                    n_SRAM_ADDR = SRAM_ADDR + 1;
                end
            end
            RECORD_PAUSE: begin
                case (control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                        n_SRAM_ADDR = 0;
                    end
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    REC_RECORD: n_state = RECORD;
                endcase
            end
            WRITE_DATALENGTH_BEFORE_STOP: begin
                setSRAMenable(SRAM_WRITE);             
                if (writedatalength_counter_r == 0) begin
                    n_state = WRITE_DATALENGTH_BEFORE_STOP;
                    n_SRAM_DQ = data_length_r[31:16];
                    n_SRAM_ADDR = SRAM_ADDR + 1;
                end
                else begin
                    n_state = IDLE;
                    n_SRAM_DQ = data_length_r[15:0];
                    n_SRAM_ADDR = SRAM_ADDR + 1;
                end
                writedatalength_counter_w = writedatalength_counter_r + 1;
            end
            WRITE_DATALENGTH_BEFORE_PAUSE: begin
                setSRAMenable(SRAM_WRITE);
                if (writedatalength_counter_r == 0) begin
                    n_state = WRITE_DATALENGTH_BEFORE_PAUSE;
                    n_SRAM_DQ = data_length_r[31:16];
                    n_SRAM_ADDR = SRAM_ADDR + 1;
                end
                else begin
                    n_state = RECORD_PAUSE;
                    n_SRAM_DQ = data_length_r[15:0];
                    n_SRAM_ADDR = SRAM_ADDR + 1;
                end
                writedatalength_counter_w = writedatalength_counter_r + 1;
            end
        endcase
    end

task setSRAMenable;
    input [4:0] mode;
    begin
        SRAM_WE_N = mode[4];
        SRAM_CE_N = mode[3];
        SRAM_OE_N = mode[2];
        SRAM_LB_N = mode[1];
        SRAM_UB_N = mode[0];
    end    
endtask

endmodule
