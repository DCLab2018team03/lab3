	component SRAM is
		port (
			clk_clk                        : in    std_logic                     := 'X';             -- clk
			reset_reset_n                  : in    std_logic                     := 'X';             -- reset_n
			sram_0_external_interface_DQ   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_0_external_interface_ADDR : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_0_external_interface_LB_N : out   std_logic;                                        -- LB_N
			sram_0_external_interface_UB_N : out   std_logic;                                        -- UB_N
			sram_0_external_interface_CE_N : out   std_logic;                                        -- CE_N
			sram_0_external_interface_OE_N : out   std_logic;                                        -- OE_N
			sram_0_external_interface_WE_N : out   std_logic                                         -- WE_N
		);
	end component SRAM;

	u0 : component SRAM
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                       clk.clk
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                     reset.reset_n
			sram_0_external_interface_DQ   => CONNECTED_TO_sram_0_external_interface_DQ,   -- sram_0_external_interface.DQ
			sram_0_external_interface_ADDR => CONNECTED_TO_sram_0_external_interface_ADDR, --                          .ADDR
			sram_0_external_interface_LB_N => CONNECTED_TO_sram_0_external_interface_LB_N, --                          .LB_N
			sram_0_external_interface_UB_N => CONNECTED_TO_sram_0_external_interface_UB_N, --                          .UB_N
			sram_0_external_interface_CE_N => CONNECTED_TO_sram_0_external_interface_CE_N, --                          .CE_N
			sram_0_external_interface_OE_N => CONNECTED_TO_sram_0_external_interface_OE_N, --                          .OE_N
			sram_0_external_interface_WE_N => CONNECTED_TO_sram_0_external_interface_WE_N  --                          .WE_N
		);

