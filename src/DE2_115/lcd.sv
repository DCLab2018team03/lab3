module LCD(
	output  [7:0] LCD_DATA,
	output LCD_RS,
	output LCD_EN,
	output LCD_ON,
	output LCD_RW,
	output LCD_BLON,

	output BUSY,
	input START,
	input CLEAR,

	input [7:0] CHARACTER,
	input [7:0] ADDRESS,
	input  i_rst,
	input  i_clk
);

    logic [2:0]  state, last_state;
    logic [7:0]  last_addr;
    logic [19:0] dly_val;
    logic [1:0]  init_idx;
    logic [7:0]  data;
    logic        rs;
    logic        en;
    logic        busy;

    parameter BOOT_DLY  = 20'hea600; // 19.2ms
    parameter CLEAR_DLY = 20'h12ad4; // 1.53ms
    parameter WRITE_DLY = 20'h866;   // 43us

    parameter INIT = 3'h0;
    parameter IDLE = 3'h1;
    parameter COMD = 3'h2;
    parameter DATA = 3'h3;
    parameter WAIT = 3'h4;
    parameter CLER = 3'h5;

    assign LCD_DATA = data;
    assign LCD_RS = rs;
    assign LCD_EN = en;
    assign LCD_ON = 1;
    assign LCD_RW = 0;
    assign LCD_BLON = 1;
    assign BUSY = busy;

    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            state <= WAIT;
            last_state <= INIT;
            last_addr <= 0;
            dly_val <= BOOT_DLY;
            init_idx <= 0;
            en <= 0;
            busy <= 1;
        end else begin
            case (state)
                INIT: begin
                    case(init_idx)
                        0: begin
                            data <= 8'h38; // function set
                            last_state <= INIT;
                            state <= COMD;
                            init_idx <= 1;
                        end
                        1: begin
                            data <= 8'h0C; // disp on
                            last_state <= INIT;
                            state <= COMD;
                            init_idx <= 2;
                        end
                        2: begin
                            last_state <= INIT;
                            state <= CLER;
                            init_idx <= 3;
                        end
                        3: begin
                            data <= 8'h06; // entry mode set
                            last_state <= IDLE;
                            state <= COMD;
                        end
                    endcase
                end
                IDLE: begin
                    if(START) begin
                        busy <= 1;
                        if(ADDRESS == last_addr+1) begin
                            state <= DATA;
                        end else begin
                            last_state <= DATA;
                            state <= COMD;
                        end
                    end else if(CLEAR) begin
                        busy <= 1;
                        state <= CLER;
                        last_state <= IDLE;
                    end else begin
                        busy <= 0;
                        en <= 0;
                    end
                end
                COMD: begin
                    en <= 1;
                    rs <= 0;
                    last_addr <= ADDRESS;
                    dly_val <= WRITE_DLY;
                    state <= WAIT;
                end
                DATA: begin
                    en <= 1;
                    rs <= 1;
                    dly_val <= WRITE_DLY;
                    last_state <= IDLE;
                    state <= WAIT;
                end
                WAIT: begin
                    if(dly_val > 0) begin
                        dly_val <= dly_val - 1;
                    end else begin
                        state <= last_state;
                        en <= 0;
                    end
                end
                CLER: begin
                    data <= 8'h01;
                    en <= 1;
                    rs <= 0;
                    dly_val <= CLEAR_DLY;
                    state <= WAIT;
                end
            endcase
        end
    end
endmodule
