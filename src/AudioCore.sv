module AudioCore(
    input           i_clk,
    input           i_rst,
    // Recorder Core
    input   [15:0]  i_event,                // 4code,2speed,4param,1inter,5reserved
    output logic [63:0]  o_time,                 // 12current,12total
    output logic o_stop_signal,
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
    // avalon_sram_slave
    output logic [20:0] address,
    output logic [1:0]  byteenable,
    output logic read,
    output logic write,
    output logic [15:0] writedata,
    input  [15:0] readdata,
    input  readdatavalid   
);

    logic [3:0] control_code;  // 1:play, 2:pause, 3:stop, 4:record
    logic [1:0] control_mode;  // 0:normal, 1:slow or 2:fast
    logic [4:0] control_speed; // 1X~8X
    logic control_interpol;    // 0 or 1
    assign o_time = 64'd1;
    assign o_stop_signal = 1'bz;
    assign byteenable = 2'b01;
    assign control_code     = i_event[15:12];
    assign control_mode     = i_event[11:10];
    assign control_speed    = {1'b0,i_event[9:6]};
    assign control_interpol = i_event[5];
    
    localparam IDLE = 0;
    localparam PLAY = 1;
    localparam PLAY_PAUSE = 2;
    localparam RECORD = 3;
    localparam RECORD_PAUSE =4;

    logic [2:0] state, n_state;
    logic [15:0] dacdatLeft_prev_r, dacdatLeft_prev_w, dacdatLeft_r, dacdatLeft_w;
    logic [15:0] dacdatRight_prev_r, dacdatRight_prev_w, dacdatRight_r, dacdatRight_w;
    logic [3:0] slow_speed_r, slow_speed_w;
    logic [3:0] slow_counter_r, slow_counter_w;
    logic [15:0] interpolLeft_r, interpolLeft_w, interpolRight_r, interpolRight_w;
    logic [19:0] address_r, address_w;
    logic [15:0] data_length;

    assign address = address_r;

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
            interpolLeft_r <= 0;
            interpolRight_r <= 0;
            from_adc_left_channel_ready <= 0;
            from_adc_right_channel_ready <= 0;
            to_dac_left_channel_valid <= 0;
            to_dac_right_channel_valid <= 0;
            address_r <= 0;
            read <= 0;
            write <= 0;
        end
        else begin
            state <= n_state;
            dacdatLeft_prev_r <= dacdatLeft_prev_w;
            dacdatRight_prev_r <= dacdatRight_prev_w;
            dacdatLeft_r <= dacdatLeft_w;
            dacdatRight_r <= dacdatRight_w;
            slow_speed_r <= slow_speed_w;
            slow_counter_r <= slow_counter_w;
            interpolLeft_r <= interpolLeft_w;
            interpolRight_r <= interpolRight_w;
            address_r <= address_w;
        end
    end

    always_comb begin
        n_state = state;
        dacdatLeft_prev_w = dacdatLeft_prev_r;
        dacdatRight_prev_w = dacdatRight_prev_r;
        dacdatLeft_w = dacdatLeft_r;
        dacdatRight_w = dacdatRight_r;
        slow_speed_w = slow_speed_r;
        from_adc_left_channel_ready = 0;
        from_adc_right_channel_ready = 0;
        to_dac_left_channel_valid = 0;
        to_dac_right_channel_valid = 0;
        address_w = address_r;
        read = 0;
        write = 0;
        case (state)
            IDLE: begin
                case (control_code)
                    1: begin
                        n_state = PLAY;
                        read = 1;
                        write = 0;
                    end
                    4: begin
                        n_state = RECORD;
                        read = 0;
                        write = 1;
                    end
                endcase
            end
            PLAY: begin
                case (control_code)
                    2: n_state = PLAY_PAUSE;
                    3: n_state = IDLE;
                endcase
                case (control_mode)
                    0: begin
                        read = 1;
                        to_dac_left_channel_valid = 0;
                        to_dac_right_channel_valid = 0;
                        if (to_dac_left_channel_ready && readdatavalid) begin
                            dacdatLeft_w = readdata;
                            to_dac_left_channel_data = dacdatLeft_r;
                            to_dac_left_channel_valid = 1;
                            address_w = address+2;
                        end
                        if (to_dac_right_channel_ready && readdatavalid) begin
                            dacdatRight_w = readdata;
                            to_dac_right_channel_data = dacdatRight_r;
                            to_dac_right_channel_valid = 1;
                            address_w = address+2;
                        end
                    end
                    1: begin
                        slow_speed_w = control_speed[3:0];
                        read = 1;
                        to_dac_left_channel_valid = 0;
                        to_dac_right_channel_valid = 0;
                        if (to_dac_left_channel_ready && readdatavalid) begin
                            dacdatLeft_w = readdata;
                            if (control_interpol == 0) begin
                                to_dac_left_channel_data = dacdatLeft_r;
                                to_dac_left_channel_valid = 1;
                                slow_counter_w = slow_counter_r + 1;
                                if (slow_counter_r == control_speed[3:0]-1)
                                    address_w = address+2;
                            end
                            else begin
                                to_dac_left_channel_data = dacdatLeft_prev_r+interpolLeft_r*slow_counter_r;
                                to_dac_left_channel_valid = 1;
                                slow_counter_w = slow_counter_r + 1;
                                if (slow_counter_r == control_speed[3:0]-1) begin
                                    dacdatLeft_prev_w = dacdatLeft_r;
                                    address_w = address+2;
                                end
                            end
                        end
                        if (to_dac_right_channel_ready && readdatavalid) begin
                            dacdatRight_w = readdata;
                            if (control_interpol == 0) begin
                                to_dac_right_channel_data = dacdatRight_prev_r;
                                to_dac_right_channel_valid = 1;
                                slow_counter_w = slow_counter_r + 1;
                                if (slow_counter_r == control_speed[3:0]-1)
                                    address_w = address+2;
                            end
                            else begin
                                to_dac_right_channel_data = dacdatRight_prev_r+interpolRight_r*slow_counter_r;
                                to_dac_right_channel_valid = 1;
                                slow_counter_w = slow_counter_r + 1;
                                if (slow_counter_r == control_speed[3:0]-1) begin
                                    address_w = address+2;
                                    dacdatRight_prev_w = dacdatRight_r;
                                end
                            end
                        end                       
                    end
                    2: begin
                        read = 1;
                        to_dac_left_channel_valid = 0;
                        to_dac_right_channel_valid = 0;
                        if (to_dac_left_channel_ready && readdatavalid) begin
                            dacdatLeft_w = readdata;
                            to_dac_left_channel_data = dacdatLeft_r;
                            to_dac_left_channel_valid = 1;
                            address_w = address_r+control_speed<<1;
                        end
                        if (to_dac_right_channel_ready && readdatavalid) begin
                            dacdatRight_w = readdata;
                            to_dac_right_channel_data = dacdatRight_r;
                            to_dac_right_channel_valid = 1;
                            address_w = address_r+control_speed<<1;
                        end 
                    end
                endcase
            end
            PLAY_PAUSE: begin
                case (control_code)
                    1: n_state = PLAY;
                    3: begin
                        n_state = IDLE;
                        address_w = 0;
                    end
                    4: begin
                        address_w = 0;
                        n_state = RECORD;
                    end
                endcase
            end
            RECORD: begin
                case (control_code)
                    2: n_state = RECORD_PAUSE;
                    3: begin
                        n_state = IDLE;
                        data_length = address_r[19:4];
                        address_w = 0;
                        writedata = data_length;
                    end
                endcase
                write = 1;
                from_adc_left_channel_ready = 1;
                from_adc_right_channel_ready = 1;
                
                if (from_adc_left_channel_valid) begin
                    from_adc_left_channel_ready = 0;
                    writedata = from_adc_left_channel_data;
                    address_w = address_r + 2;
                end
                if (from_adc_right_channel_valid) begin
                    from_adc_right_channel_ready = 0;
                    writedata = from_adc_right_channel_data;
                    address_w = address_r + 2;
                end
            end
            RECORD_PAUSE: begin
                case (control_code)
                    1: begin
                        n_state = PLAY;
                        address_w = 0;
                    end
                    3: begin
                        n_state = IDLE;
                        address_w = 0;
                    end
                    4: n_state = RECORD;
                endcase
            end

        endcase
    end
endmodule
