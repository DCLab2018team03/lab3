
module Total (
	clk_clk,
	reset_reset_n,
	audio_0_external_interface_ADCDAT,
	audio_0_external_interface_ADCLRCK,
	audio_0_external_interface_BCLK,
	audio_0_external_interface_DACDAT,
	audio_0_external_interface_DACLRCK,
	audio_and_video_config_0_external_interface_SDAT,
	audio_and_video_config_0_external_interface_SCLK,
	sram_0_external_interface_DQ,
	sram_0_external_interface_ADDR,
	sram_0_external_interface_LB_N,
	sram_0_external_interface_UB_N,
	sram_0_external_interface_CE_N,
	sram_0_external_interface_OE_N,
	sram_0_external_interface_WE_N);	

	input		clk_clk;
	input		reset_reset_n;
	input		audio_0_external_interface_ADCDAT;
	input		audio_0_external_interface_ADCLRCK;
	input		audio_0_external_interface_BCLK;
	output		audio_0_external_interface_DACDAT;
	input		audio_0_external_interface_DACLRCK;
	inout		audio_and_video_config_0_external_interface_SDAT;
	output		audio_and_video_config_0_external_interface_SCLK;
	inout	[15:0]	sram_0_external_interface_DQ;
	output	[19:0]	sram_0_external_interface_ADDR;
	output		sram_0_external_interface_LB_N;
	output		sram_0_external_interface_UB_N;
	output		sram_0_external_interface_CE_N;
	output		sram_0_external_interface_OE_N;
	output		sram_0_external_interface_WE_N;
endmodule
