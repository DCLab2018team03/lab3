module Recorder (
    input           i_clk,
    input           i_rst,
    // Input
    input   [15:0]  i_input_event,
    // Output
	output	[15:0]  o_event_hold,
    output  [63:0]  o_time,
    
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
    // avalon_left_channel_sink
    output logic [15:0] to_dac_right_channel_data,
    output logic to_dac_right_channel_valid,
    input  to_dac_right_channel_ready,
    // avalon_sram_slave
    output logic [20:0] address,
    output logic read,
    output logic write,
    output logic [15:0] writedata,
    input  [15:0] readdata,
    input  readdatavalid
);
    wire w_audio_core_stop_signal;
    //assign w_audio_core_stop_signal = 0;
    //assign o_time = 0;
    RecorderCore recorderCore(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_input_event(i_input_event),
        .o_event(o_output_event),
		.o_event_hold(o_event_hold),
        .i_stop(w_audio_core_stop_signal)
    );
    

    AudioCore audioCore(
        .i_clk(i_clk),
        .i_rst(i_rst),
        // Recorder Core
        .i_event(o_output_event),                // 4code,2speed,4param,1inter,5reserved
        .o_time(0),                 // 12current,12total
        .o_stop_signal(w_audio_core_stop_signal),
        // avalon_audio_slave
        // avalon_left_channel_source
        .from_adc_left_channel_ready(from_adc_left_channel_ready),
        .from_adc_left_channel_data(from_adc_left_channel_data),
        .from_adc_left_channel_valid(from_adc_left_channel_valid),
        // avalon_right_channel_source
        .from_adc_right_channel_ready(from_adc_right_channel_ready),
        .from_adc_right_channel_data(from_adc_right_channel_data),
        .from_adc_right_channel_valid(from_adc_right_channel_valid),
        // avalon_left_channel_sink
        .to_dac_left_channel_data(to_dac_left_channel_data),
        .to_dac_left_channel_valid(to_dac_left_channel_valid),
        .to_dac_left_channel_ready(to_dac_left_channel_ready),
        // avalon_left_channel_sink
        .to_dac_right_channel_data(to_dac_right_channel_data),
        .to_dac_right_channel_valid(to_dac_right_channel_valid),
        .to_dac_right_channel_ready(to_dac_right_channel_ready),
        // avalon_sram_slave
        .address(address),
        .read(read),
        .write(write),
        .writedata(writedata),
        .readdata(readdata),
        .readdatavalid(readdatavalid)   
);
    

endmodule