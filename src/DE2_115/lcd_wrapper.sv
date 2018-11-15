module LCD_wrapper(
	output reg [7:0] CHARACTER,
	output reg [7:0] ADDRESS,

	output reg START,
	output CLEAR,
	input BUSY,

	input i_clk,
	input i_rst,
	input [15:0] STATUS,
	input [63:0] TIME
);

endmodule