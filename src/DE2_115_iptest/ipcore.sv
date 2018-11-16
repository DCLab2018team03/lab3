module AudioCore(
    input           i_clk,
    input           i_rst,
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
    input  to_dac_right_channel_ready
);

assign from_adc_left_channel_ready  = to_dac_left_channel_ready;
assign from_adc_right_channel_ready = to_dac_right_channel_ready;
assign to_dac_left_channel_valid = from_adc_left_channel_valid;
assign to_dac_right_channel_valid = from_adc_right_channel_valid;
assign to_dac_left_channel_data = from_adc_left_channel_data;
assign to_dac_right_channel_data = from_adc_right_channel_data;