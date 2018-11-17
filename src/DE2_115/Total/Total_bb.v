
module Total (
	audio_0_external_interface_ADCDAT,
	audio_0_external_interface_ADCLRCK,
	audio_0_external_interface_BCLK,
	audio_0_external_interface_DACDAT,
	audio_0_external_interface_DACLRCK,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	clk_clk,
	reset_reset_n,
	sram_0_external_interface_DQ,
	sram_0_external_interface_ADDR,
	sram_0_external_interface_LB_N,
	sram_0_external_interface_UB_N,
	sram_0_external_interface_CE_N,
	sram_0_external_interface_OE_N,
	sram_0_external_interface_WE_N,
	audio_0_avalon_left_channel_source_ready,
	audio_0_avalon_left_channel_source_data,
	audio_0_avalon_left_channel_source_valid,
	audio_0_avalon_right_channel_source_ready,
	audio_0_avalon_right_channel_source_data,
	audio_0_avalon_right_channel_source_valid,
	audio_0_avalon_left_channel_sink_data,
	audio_0_avalon_left_channel_sink_valid,
	audio_0_avalon_left_channel_sink_ready,
	audio_0_avalon_right_channel_sink_data,
	audio_0_avalon_right_channel_sink_valid,
	audio_0_avalon_right_channel_sink_ready,
	audio_pll_0_audio_clk_clk,
	sram_0_avalon_sram_slave_address,
	sram_0_avalon_sram_slave_byteenable,
	sram_0_avalon_sram_slave_read,
	sram_0_avalon_sram_slave_write,
	sram_0_avalon_sram_slave_writedata,
	sram_0_avalon_sram_slave_readdata,
	sram_0_avalon_sram_slave_readdatavalid);	

	input		audio_0_external_interface_ADCDAT;
	input		audio_0_external_interface_ADCLRCK;
	input		audio_0_external_interface_BCLK;
	output		audio_0_external_interface_DACDAT;
	input		audio_0_external_interface_DACLRCK;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	input		clk_clk;
	input		reset_reset_n;
	inout	[15:0]	sram_0_external_interface_DQ;
	output	[19:0]	sram_0_external_interface_ADDR;
	output		sram_0_external_interface_LB_N;
	output		sram_0_external_interface_UB_N;
	output		sram_0_external_interface_CE_N;
	output		sram_0_external_interface_OE_N;
	output		sram_0_external_interface_WE_N;
	input		audio_0_avalon_left_channel_source_ready;
	output	[15:0]	audio_0_avalon_left_channel_source_data;
	output		audio_0_avalon_left_channel_source_valid;
	input		audio_0_avalon_right_channel_source_ready;
	output	[15:0]	audio_0_avalon_right_channel_source_data;
	output		audio_0_avalon_right_channel_source_valid;
	input	[15:0]	audio_0_avalon_left_channel_sink_data;
	input		audio_0_avalon_left_channel_sink_valid;
	output		audio_0_avalon_left_channel_sink_ready;
	input	[15:0]	audio_0_avalon_right_channel_sink_data;
	input		audio_0_avalon_right_channel_sink_valid;
	output		audio_0_avalon_right_channel_sink_ready;
	output		audio_pll_0_audio_clk_clk;
	input	[19:0]	sram_0_avalon_sram_slave_address;
	input	[1:0]	sram_0_avalon_sram_slave_byteenable;
	input		sram_0_avalon_sram_slave_read;
	input		sram_0_avalon_sram_slave_write;
	input	[15:0]	sram_0_avalon_sram_slave_writedata;
	output	[15:0]	sram_0_avalon_sram_slave_readdata;
	output		sram_0_avalon_sram_slave_readdatavalid;
endmodule
