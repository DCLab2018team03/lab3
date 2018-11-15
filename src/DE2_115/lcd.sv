module LCD(
	output  [7:0] LCD_DATA,
	output LCD_EN,
	output LCD_ON,
	output LCD_RW,
	output LCD_RS,
	output LCD_BLON,

	output BUSY,
	input START,
	input CLEAR,

	input [7:0] CHARACTER,
	input [7:0] ADDRESS,
	input  i_rst,
	input  i_clk
);

endmodule