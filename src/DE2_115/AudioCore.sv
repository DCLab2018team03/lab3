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
    output from_adc_left_channel_ready,
    input  [15:0] from_adc_left_channel_data,
    input  from_adc_left_channel_valid,
    // avalon_right_channel_source
    output from_adc_right_channel_ready,
    input  [15:0] from_adc_right_channel_data,
    input  from_adc_right_channel_valid,
    // avalon_left_channel_sink
    output [15:0] to_dac_left_channel_data,
    output to_dac_left_channel_valid,
    input  to_dac_left_channel_ready,
    // avalon_right_channel_sink
    output [15:0] to_dac_right_channel_data,
    output to_dac_right_channel_valid,
    input  to_dac_right_channel_ready,
    // avalon_sram_slave
    output [19:0] address,
    output read,
    output write,
    output [15:0] writedata,
    input  [15:0] readdata,
    input  readdatavalid   
);

    logic [3:0] control_code;  // 1:play, 2:pause, 3:stop, 4:record
    logic [1:0] control_mode;  // 0:normal, 1:slow or 2:fast
    logic [4:0] control_speed; // 1X~8X
    logic control_interpol;    // 0 or 1
    assign control_code     = i_event[15:12];
    assign control_mode     = i_event[11:10];
    assign control_speed    = {1'b0,i_event[9:6]};
    assign control_interpol = i_event[5];
    
    localparam IDLE = 0;
    localparam PLAY = 1;
    localparam PLAY_PAUSE = 2;
    localparam RECORD = 3;
    localparam RECORD_PAUSE = 4;
    localparam WRITE_DATALENGTH_BEFORE_STOP = 5;
    localparam WRITE_DATALENGTH_BEFORE_PAUSE = 6;

    logic [2:0] state, n_state;
    logic [15:0] dacdatLeft_prev_r, dacdatLeft_prev_w, dacdatLeft_r, dacdatLeft_w;
    logic [15:0] dacdatRight_prev_r, dacdatRight_prev_w, dacdatRight_r, dacdatRight_w;
    logic [3:0] slow_speed_r, slow_speed_w;
    logic [3:0] slow_counter_r, slow_counter_w;
    logic [31:0] play_counter_r, play_counter_w;
    logic [15:0] interpolLeft_r, interpolLeft_w, interpolRight_r, interpolRight_w;
    logic [19:0] address_r, address_w;
    logic [31:0] data_length_r, data_length_w;
    logic read_r, read_w;
    logic write_r, write_w;
    logic writedata_r, writedata_w;
    logic writedatalength_counter_w, writedatalength_counter_r;
    logic [15:0] to_dac_left_channel_data_r, to_dac_left_channel_data_w;
    logic [15:0] to_dac_right_channel_data_r, to_dac_right_channel_data_w;
    logic from_adc_left_channel_ready_r, from_adc_left_channel_ready_w;
    logic from_adc_right_channel_ready_r, from_adc_right_channel_ready_w;
    logic to_dac_left_channel_valid_r, to_dac_left_channel_valid_w;
    logic to_dac_right_channel_valid_r, to_dac_right_channel_valid_w;

    assign address = address_r;
    assign read = read_r;
    assign write = write_r;
    assign writedata = writedata_r;
    assign to_dac_left_channel_data = to_dac_left_channel_data_r;
    assign to_dac_right_channel_data = to_dac_right_channel_data_r;
    assign o_time = {play_counter_r, data_length_r};
    assign o_stop_signal = (play_counter_r == data_length_r) ? 1 : 0;
    assign from_adc_left_channel_ready = from_adc_left_channel_ready_r;
    assign from_adc_right_channel_ready = from_adc_right_channel_ready_r;
    assign to_dac_left_channel_valid = to_dac_left_channel_valid_r;
    assign to_dac_right_channel_valid = to_dac_right_channel_valid_r;

    AudioCoreInterpolation interpolLeft(
        .i_data_prev(dacdatLeft_prev_r),
        .i_data(dacdatLeft_r),
        .i_divisor(slow_speed_r),
        .o_quotient(interpolLeft_w)
    );
    AudioCoreInterpolation interpolRight(
        .i_data_prev(dacdatRight_prev_r),
        .i_data(dacdatRight_r),
        .i_divisor(slow_speed_r),
        .o_quotient(interpolRight_w)
    );
    
    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            state <= IDLE;
            dacdatLeft_prev_r <= 0;
            dacdatRight_prev_r <= 0;
            dacdatLeft_r <= 0;
            dacdatRight_r <= 0;
            slow_speed_r <= 1;
            slow_counter_r <= 0;
            play_counter_r <= 0;
            interpolLeft_r <= 0;
            interpolRight_r <= 0;
            address_r <= 0;
            data_length_r <= 0;
            read_r <= 0;
            write_r <= 0;
            writedata_r <= 0;
            writedatalength_counter_r <= 0;
            to_dac_left_channel_data_r <= 0;
            to_dac_right_channel_data_r <= 0;
            from_adc_left_channel_ready_r <= 0;
            from_adc_right_channel_ready_r <= 0;
            to_dac_left_channel_valid_r <= 0;
            to_dac_right_channel_valid_r <= 0;
        end
        else begin
            state <= n_state;
            dacdatLeft_prev_r <= dacdatLeft_prev_w;
            dacdatRight_prev_r <= dacdatRight_prev_w;
            dacdatLeft_r <= dacdatLeft_w;
            dacdatRight_r <= dacdatRight_w;
            slow_speed_r <= slow_speed_w;
            slow_counter_r <= slow_counter_w;
            play_counter_r <= play_counter_w;
            interpolLeft_r <= interpolLeft_w;
            interpolRight_r <= interpolRight_w;
            address_r <= address_w;
            data_length_r <= data_length_w;
            read_r <= read_w;
            write_r <= write_w;
            writedata_r <= writedata_w;
            writedatalength_counter_r <= writedatalength_counter_w;
            to_dac_left_channel_data_r <= to_dac_left_channel_data_w;
            to_dac_right_channel_data_r <= to_dac_right_channel_data_w;
            from_adc_left_channel_ready_r <= from_adc_left_channel_ready_w;
            from_adc_right_channel_ready_r <= from_adc_right_channel_ready_w;
            to_dac_left_channel_valid_r <= to_dac_left_channel_valid_w;
            to_dac_right_channel_valid_r <= to_dac_right_channel_valid_w;
        end
    end

    always_comb begin
        n_state = state;
        dacdatLeft_prev_w = dacdatLeft_prev_r;
        dacdatRight_prev_w = dacdatRight_prev_r;
        dacdatLeft_w = dacdatLeft_r;
        dacdatRight_w = dacdatRight_r;
        slow_speed_w = slow_speed_r;
        slow_counter_w = slow_counter_r;
        play_counter_w = play_counter_r;
        address_w = address_r;
        data_length_w = data_length_r;
        read_w = 0;
        write_w = 0;
        writedata_w = writedata_r;
        writedatalength_counter_w = writedatalength_counter_r;
        to_dac_left_channel_data_w = to_dac_left_channel_data_r;
        to_dac_right_channel_data_w = to_dac_right_channel_data_r;        

        from_adc_left_channel_ready_w = 0;
        from_adc_right_channel_ready_w = 0;
        to_dac_left_channel_valid_w = 0;
        to_dac_right_channel_valid_w = 0;
        case (state)
            IDLE: begin
                case (control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                        address_w = 0;
                        read_w = 1;
                        write_w = 0;
                        play_counter_w = 0;
                    end
                    REC_RECORD: begin
                        n_state = RECORD;
                        address_w = 4;
                        read_w = 0;
                        write_w = 1;
                    end
                endcase
            end
            PLAY: begin
                case (control_code)
                    REC_PAUSE: n_state = PLAY_PAUSE;
                    REC_STOP: n_state = IDLE;
                endcase
                if (address_r == 0) begin
                    if (readdatavalid) begin
                        read_w = 1;
                        write_w = 0;
                        data_length_w[31:16] = readdata;
                        address_w = 2;
                    end
                end
                else if (address_r == 2) begin
                    if (readdatavalid) begin
                        read_w = 1;
                        write_w = 0;
                        data_length_w[15:0] = readdata;
                        address_w = 4;
                    end
                end
                else begin
                    case (control_mode)
                        REC_NORMAL: begin
                            if (to_dac_left_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatLeft_w = readdata;
                                to_dac_left_channel_data_w = dacdatLeft_r;
                                to_dac_left_channel_valid_w = 1;
                            end
                            if (to_dac_right_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatRight_w = readdata;
                                to_dac_right_channel_data_w = dacdatRight_r;
                                to_dac_right_channel_valid_w = 1;
                                address_w = address_r + 2;
                                play_counter_w = play_counter_r + 2;     
                            end
                        end
                        REC_SLOW: begin
                            slow_speed_w = control_speed[3:0];
                            if (to_dac_left_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatLeft_w = readdata;
                                if (control_interpol == 0) begin
                                    to_dac_left_channel_data_w = dacdatLeft_r;
                                    to_dac_left_channel_valid_w = 1;
                                end
                                else begin
                                    to_dac_left_channel_data_w = dacdatLeft_prev_r + interpolLeft_r*slow_counter_r;
                                    to_dac_left_channel_valid_w = 1;
                                    slow_counter_w = slow_counter_r + 1;
                                end
                            end
                            //to_dac_right_channel_valid = 0;
                            if (to_dac_right_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatRight_w = readdata;
                                if (control_interpol == 0) begin
                                    to_dac_right_channel_data_w = dacdatRight_prev_r;
                                    to_dac_right_channel_valid_w = 1;
                                    slow_counter_w = slow_counter_r + 1;
                                    if (slow_counter_r == control_speed[3:0]-1) begin
                                        address_w = address_r + 2;
                                        play_counter_w = play_counter_r + 2;
                                    end
                                end
                                else begin
                                    to_dac_right_channel_data_w = dacdatRight_prev_r+interpolRight_r*slow_counter_r;
                                    to_dac_right_channel_valid_w = 1;
                                    slow_counter_w = slow_counter_r + 1;
                                    if (slow_counter_r == control_speed[3:0]-1) begin
                                        dacdatLeft_prev_w = dacdatLeft_r;
                                        dacdatRight_prev_w = dacdatRight_r;
                                        address_w = address_r + 2;
                                        play_counter_w = play_counter_r + 2;
                                    end
                                end
                            end                       
                        end
                        REC_FAST: begin
                            if (to_dac_left_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatLeft_w = readdata;
                                to_dac_left_channel_data_w = dacdatLeft_r;
                                to_dac_left_channel_valid_w = 1;
                            end
                            if (to_dac_right_channel_ready && readdatavalid) begin
                                read_w = 1;
                                write_w = 0;
                                dacdatRight_w = readdata;
                                to_dac_right_channel_data_w = dacdatRight_r;
                                to_dac_right_channel_valid_w = 1;
                                address_w = address_r + control_speed<<1;
                                play_counter_w = play_counter_r + control_speed<<1;
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
                        address_w = 4;   
                    end
                endcase
            end
            RECORD: begin
                case (control_code)
                    REC_PAUSE: begin
                        n_state = WRITE_DATALENGTH_BEFORE_PAUSE;
                        data_length_w = {12'd0, address_r};
                    end
                    REC_STOP: begin
                        n_state = WRITE_DATALENGTH_BEFORE_STOP;
                        data_length_w = {12'd0, address_r};
                    end
                endcase
                write_w = 1;
                read_w = 0;
                if (from_adc_left_channel_valid) begin
                    from_adc_left_channel_ready_w = 1;
                    writedata_w = from_adc_left_channel_data;
                    address_w = address_r + 2;
                end
                if (from_adc_right_channel_valid) begin
                    from_adc_right_channel_ready_w = 1;
                end
            end
            RECORD_PAUSE: begin
                case (control_code)
                    REC_PLAY: begin
                        n_state = PLAY;
                        address_w = 0;
                    end
                    REC_STOP: begin
                        n_state = IDLE;
                    end
                    REC_RECORD: n_state = RECORD;
                endcase
            end
            WRITE_DATALENGTH_BEFORE_STOP: begin
                write_w = 1;
                read_w = 0;
                if (writedatalength_counter_r == 0) begin
                    n_state = WRITE_DATALENGTH_BEFORE_STOP;
                    writedata_w = data_length_r[31:16];
                end
                else begin
                    n_state = IDLE;
                    writedata_w = data_length_r[15:0];
                end
                writedatalength_counter_w = writedatalength_counter_r + 1;
            end
            WRITE_DATALENGTH_BEFORE_PAUSE: begin
                write_w = 1;
                read_w = 0;
                if (writedatalength_counter_r == 0) begin
                    n_state = WRITE_DATALENGTH_BEFORE_PAUSE;
                    writedata_w = data_length_r[31:16];
                end
                else begin
                    n_state = RECORD_PAUSE;
                    writedata_w = data_length_r[15:0];
                end
                writedatalength_counter_w = writedatalength_counter_r + 1;
            end
        endcase
    end
endmodule
