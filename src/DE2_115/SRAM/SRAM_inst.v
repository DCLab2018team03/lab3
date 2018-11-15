	SRAM u0 (
		.clk_clk                        (<connected-to-clk_clk>),                        //                       clk.clk
		.reset_reset_n                  (<connected-to-reset_reset_n>),                  //                     reset.reset_n
		.sram_0_external_interface_DQ   (<connected-to-sram_0_external_interface_DQ>),   // sram_0_external_interface.DQ
		.sram_0_external_interface_ADDR (<connected-to-sram_0_external_interface_ADDR>), //                          .ADDR
		.sram_0_external_interface_LB_N (<connected-to-sram_0_external_interface_LB_N>), //                          .LB_N
		.sram_0_external_interface_UB_N (<connected-to-sram_0_external_interface_UB_N>), //                          .UB_N
		.sram_0_external_interface_CE_N (<connected-to-sram_0_external_interface_CE_N>), //                          .CE_N
		.sram_0_external_interface_OE_N (<connected-to-sram_0_external_interface_OE_N>), //                          .OE_N
		.sram_0_external_interface_WE_N (<connected-to-sram_0_external_interface_WE_N>)  //                          .WE_N
	);

