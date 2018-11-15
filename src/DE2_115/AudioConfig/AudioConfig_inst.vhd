	component AudioConfig is
		port (
			clk_clk                                          : in    std_logic := 'X'; -- clk
			reset_reset_n                                    : in    std_logic := 'X'; -- reset_n
			audio_and_video_config_0_external_interface_SDAT : inout std_logic := 'X'; -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic         -- SCLK
		);
	end component AudioConfig;

	u0 : component AudioConfig
		port map (
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK  --                                            .SCLK
		);

