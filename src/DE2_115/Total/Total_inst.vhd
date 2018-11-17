	component Total is
		port (
			audio_0_external_interface_ADCDAT                : in    std_logic                     := 'X';             -- ADCDAT
			audio_0_external_interface_ADCLRCK               : in    std_logic                     := 'X';             -- ADCLRCK
			audio_0_external_interface_BCLK                  : in    std_logic                     := 'X';             -- BCLK
			audio_0_external_interface_DACDAT                : out   std_logic;                                        -- DACDAT
			audio_0_external_interface_DACLRCK               : in    std_logic                     := 'X';             -- DACLRCK
			audio_and_video_config_0_external_interface_SDAT : inout std_logic                     := 'X';             -- SDAT
			audio_and_video_config_0_external_interface_SCLK : out   std_logic;                                        -- SCLK
			clk_clk                                          : in    std_logic                     := 'X';             -- clk
			reset_reset_n                                    : in    std_logic                     := 'X';             -- reset_n
			sram_0_external_interface_DQ                     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_0_external_interface_ADDR                   : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_0_external_interface_LB_N                   : out   std_logic;                                        -- LB_N
			sram_0_external_interface_UB_N                   : out   std_logic;                                        -- UB_N
			sram_0_external_interface_CE_N                   : out   std_logic;                                        -- CE_N
			sram_0_external_interface_OE_N                   : out   std_logic;                                        -- OE_N
			sram_0_external_interface_WE_N                   : out   std_logic;                                        -- WE_N
			audio_0_avalon_left_channel_source_ready         : in    std_logic                     := 'X';             -- ready
			audio_0_avalon_left_channel_source_data          : out   std_logic_vector(15 downto 0);                    -- data
			audio_0_avalon_left_channel_source_valid         : out   std_logic;                                        -- valid
			audio_0_avalon_right_channel_source_ready        : in    std_logic                     := 'X';             -- ready
			audio_0_avalon_right_channel_source_data         : out   std_logic_vector(15 downto 0);                    -- data
			audio_0_avalon_right_channel_source_valid        : out   std_logic;                                        -- valid
			audio_0_avalon_left_channel_sink_data            : in    std_logic_vector(15 downto 0) := (others => 'X'); -- data
			audio_0_avalon_left_channel_sink_valid           : in    std_logic                     := 'X';             -- valid
			audio_0_avalon_left_channel_sink_ready           : out   std_logic;                                        -- ready
			audio_0_avalon_right_channel_sink_data           : in    std_logic_vector(15 downto 0) := (others => 'X'); -- data
			audio_0_avalon_right_channel_sink_valid          : in    std_logic                     := 'X';             -- valid
			audio_0_avalon_right_channel_sink_ready          : out   std_logic;                                        -- ready
			audio_pll_0_audio_clk_clk                        : out   std_logic;                                        -- clk
			sram_0_avalon_sram_slave_address                 : in    std_logic_vector(19 downto 0) := (others => 'X'); -- address
			sram_0_avalon_sram_slave_byteenable              : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			sram_0_avalon_sram_slave_read                    : in    std_logic                     := 'X';             -- read
			sram_0_avalon_sram_slave_write                   : in    std_logic                     := 'X';             -- write
			sram_0_avalon_sram_slave_writedata               : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			sram_0_avalon_sram_slave_readdata                : out   std_logic_vector(15 downto 0);                    -- readdata
			sram_0_avalon_sram_slave_readdatavalid           : out   std_logic                                         -- readdatavalid
		);
	end component Total;

	u0 : component Total
		port map (
			audio_0_external_interface_ADCDAT                => CONNECTED_TO_audio_0_external_interface_ADCDAT,                --                  audio_0_external_interface.ADCDAT
			audio_0_external_interface_ADCLRCK               => CONNECTED_TO_audio_0_external_interface_ADCLRCK,               --                                            .ADCLRCK
			audio_0_external_interface_BCLK                  => CONNECTED_TO_audio_0_external_interface_BCLK,                  --                                            .BCLK
			audio_0_external_interface_DACDAT                => CONNECTED_TO_audio_0_external_interface_DACDAT,                --                                            .DACDAT
			audio_0_external_interface_DACLRCK               => CONNECTED_TO_audio_0_external_interface_DACLRCK,               --                                            .DACLRCK
			audio_and_video_config_0_external_interface_SDAT => CONNECTED_TO_audio_and_video_config_0_external_interface_SDAT, -- audio_and_video_config_0_external_interface.SDAT
			audio_and_video_config_0_external_interface_SCLK => CONNECTED_TO_audio_and_video_config_0_external_interface_SCLK, --                                            .SCLK
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                                         clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                                       reset.reset_n
			sram_0_external_interface_DQ                     => CONNECTED_TO_sram_0_external_interface_DQ,                     --                   sram_0_external_interface.DQ
			sram_0_external_interface_ADDR                   => CONNECTED_TO_sram_0_external_interface_ADDR,                   --                                            .ADDR
			sram_0_external_interface_LB_N                   => CONNECTED_TO_sram_0_external_interface_LB_N,                   --                                            .LB_N
			sram_0_external_interface_UB_N                   => CONNECTED_TO_sram_0_external_interface_UB_N,                   --                                            .UB_N
			sram_0_external_interface_CE_N                   => CONNECTED_TO_sram_0_external_interface_CE_N,                   --                                            .CE_N
			sram_0_external_interface_OE_N                   => CONNECTED_TO_sram_0_external_interface_OE_N,                   --                                            .OE_N
			sram_0_external_interface_WE_N                   => CONNECTED_TO_sram_0_external_interface_WE_N,                   --                                            .WE_N
			audio_0_avalon_left_channel_source_ready         => CONNECTED_TO_audio_0_avalon_left_channel_source_ready,         --          audio_0_avalon_left_channel_source.ready
			audio_0_avalon_left_channel_source_data          => CONNECTED_TO_audio_0_avalon_left_channel_source_data,          --                                            .data
			audio_0_avalon_left_channel_source_valid         => CONNECTED_TO_audio_0_avalon_left_channel_source_valid,         --                                            .valid
			audio_0_avalon_right_channel_source_ready        => CONNECTED_TO_audio_0_avalon_right_channel_source_ready,        --         audio_0_avalon_right_channel_source.ready
			audio_0_avalon_right_channel_source_data         => CONNECTED_TO_audio_0_avalon_right_channel_source_data,         --                                            .data
			audio_0_avalon_right_channel_source_valid        => CONNECTED_TO_audio_0_avalon_right_channel_source_valid,        --                                            .valid
			audio_0_avalon_left_channel_sink_data            => CONNECTED_TO_audio_0_avalon_left_channel_sink_data,            --            audio_0_avalon_left_channel_sink.data
			audio_0_avalon_left_channel_sink_valid           => CONNECTED_TO_audio_0_avalon_left_channel_sink_valid,           --                                            .valid
			audio_0_avalon_left_channel_sink_ready           => CONNECTED_TO_audio_0_avalon_left_channel_sink_ready,           --                                            .ready
			audio_0_avalon_right_channel_sink_data           => CONNECTED_TO_audio_0_avalon_right_channel_sink_data,           --           audio_0_avalon_right_channel_sink.data
			audio_0_avalon_right_channel_sink_valid          => CONNECTED_TO_audio_0_avalon_right_channel_sink_valid,          --                                            .valid
			audio_0_avalon_right_channel_sink_ready          => CONNECTED_TO_audio_0_avalon_right_channel_sink_ready,          --                                            .ready
			audio_pll_0_audio_clk_clk                        => CONNECTED_TO_audio_pll_0_audio_clk_clk,                        --                       audio_pll_0_audio_clk.clk
			sram_0_avalon_sram_slave_address                 => CONNECTED_TO_sram_0_avalon_sram_slave_address,                 --                    sram_0_avalon_sram_slave.address
			sram_0_avalon_sram_slave_byteenable              => CONNECTED_TO_sram_0_avalon_sram_slave_byteenable,              --                                            .byteenable
			sram_0_avalon_sram_slave_read                    => CONNECTED_TO_sram_0_avalon_sram_slave_read,                    --                                            .read
			sram_0_avalon_sram_slave_write                   => CONNECTED_TO_sram_0_avalon_sram_slave_write,                   --                                            .write
			sram_0_avalon_sram_slave_writedata               => CONNECTED_TO_sram_0_avalon_sram_slave_writedata,               --                                            .writedata
			sram_0_avalon_sram_slave_readdata                => CONNECTED_TO_sram_0_avalon_sram_slave_readdata,                --                                            .readdata
			sram_0_avalon_sram_slave_readdatavalid           => CONNECTED_TO_sram_0_avalon_sram_slave_readdatavalid            --                                            .readdatavalid
		);

