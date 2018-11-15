	component Total is
		port (
			clk_clk                                          : in    std_logic                     := 'X';             -- clk
			reset_reset_n                                    : in    std_logic                     := 'X';             -- reset_n
			audio_0_external_interface_ADCDAT                : in    std_logic                     := 'X';             -- ADCDAT
			audio_0_external_interface_ADCLRCK               : in    std_logic                     := 'X';             -- ADCLRCK
			audio_0_external_interface_BCLK                  : in    std_logic                     := 'X';             -- BCLK
			audio_0_external_interface_DACDAT                : out   std_logic;                                        -- DACDAT
			audio_0_external_interface_DACLRCK               : in    std_logic                     := 'X';             -- DACLRCK
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                     := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                        -- SCLK
			sram_0_external_interface_DQ                     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_0_external_interface_ADDR                   : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_0_external_interface_LB_N                   : out   std_logic;                                        -- LB_N
			sram_0_external_interface_UB_N                   : out   std_logic;                                        -- UB_N
			sram_0_external_interface_CE_N                   : out   std_logic;                                        -- CE_N
			sram_0_external_interface_OE_N                   : out   std_logic;                                        -- OE_N
			sram_0_external_interface_WE_N                   : out   std_logic                                         -- WE_N
		);
	end component Total;

	u0 : component Total
		port map (
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			audio_0_external_interface_ADCDAT                => CONNECTED_TO_audio_0_external_interface_ADCDAT,                --                  audio_0_external_interface.ADCDAT
			audio_0_external_interface_ADCLRCK               => CONNECTED_TO_audio_0_external_interface_ADCLRCK,               --                                            .ADCLRCK
			audio_0_external_interface_BCLK                  => CONNECTED_TO_audio_0_external_interface_BCLK,                  --                                            .BCLK
			audio_0_external_interface_DACDAT                => CONNECTED_TO_audio_0_external_interface_DACDAT,                --                                            .DACDAT
			audio_0_external_interface_DACLRCK               => CONNECTED_TO_audio_0_external_interface_DACLRCK,               --                                            .DACLRCK
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			sram_0_external_interface_DQ                     => CONNECTED_TO_sram_0_external_interface_DQ,                     --                   sram_0_external_interface.DQ
			sram_0_external_interface_ADDR                   => CONNECTED_TO_sram_0_external_interface_ADDR,                   --                                            .ADDR
			sram_0_external_interface_LB_N                   => CONNECTED_TO_sram_0_external_interface_LB_N,                   --                                            .LB_N
			sram_0_external_interface_UB_N                   => CONNECTED_TO_sram_0_external_interface_UB_N,                   --                                            .UB_N
			sram_0_external_interface_CE_N                   => CONNECTED_TO_sram_0_external_interface_CE_N,                   --                                            .CE_N
			sram_0_external_interface_OE_N                   => CONNECTED_TO_sram_0_external_interface_OE_N,                   --                                            .OE_N
			sram_0_external_interface_WE_N                   => CONNECTED_TO_sram_0_external_interface_WE_N                    --                                            .WE_N
		);

