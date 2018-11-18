`include "include/RecorderDefine.vh"

module LCD_wrapper(
	output reg [7:0] CHARACTER,
	output reg [7:0] ADDRESS,

	output reg START,
	output CLEAR,
	input BUSY,

	input i_clk,
	input i_rst,
	input [15:0] STATUS,
	input [63:0] TIME,
	
	output [1:0] stat
);
    parameter REST   = 2'd0;
    parameter WRITE   = 2'd1;
    parameter CLEAR_LCD  = 2'd2;

    logic [3:0] control_code, curr_code;
    logic [15:0] curr_status;
    logic [1:0] control_mode;
    logic [3:0] control_speed;
    logic       control_interpol;
    logic [1:0] state;
    logic [7:0] address;
    logic       line;
    logic [25:0] clk_count;
    logic [3:0] sec_one;
    logic [2:0] sec_ten;
    logic [4:0] min;

	 assign stat = state;
	 
    assign control_code     = curr_status[15:12];
    assign control_mode     = curr_status[11:10];
    assign control_speed    = curr_status[9:6];
    assign control_interpol = curr_status[5];

    always_ff @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            curr_code <= REC_NONE;
            curr_status <= STATUS;
            state <= CLEAR_LCD;
            address <= 8'h00;
            line <= 1'b0;
            clk_count <= 26'b0;
            sec_ten <= 3'b0;
            sec_one <= 4'b0;
            min <= 5'b0;
        end else begin
            if (curr_code != control_code) begin
                address <= 8'h0;
                clk_count <= 26'b0;
                sec_ten <= 3'b0;
                sec_one <= 4'b0;
                min <= 5'b0;
                curr_code <= control_code;
                //state <= WRITE;
            end else begin
                if(clk_count == 26'd50000000) begin
                    if(sec_one == 4'd9) begin
                            if(sec_ten == 3'd5) begin
                                sec_ten <= 3'd0;
                                min <= min + 1;
                            end else begin
                                sec_ten <= sec_ten + 1;
                            end
                        sec_one <= 4'b0;
                    end else begin
                        sec_one <= sec_one + 1;
                    end
                end else begin
                    clk_count <= clk_count + 1;
                end
                case(state)
                    WRITE: begin
                        if(!BUSY) begin
                            START <= 1;
									 CLEAR <= 0;
                            case(line)
                                1'b0: begin
                                    case(control_code)
                                        REC_NONE: begin
                                            case(address)
                                                8'h00: begin
                                                    ADDRESS <= 8'h00;
                                                    CHARACTER <= 8'h49; //I
                                                    address <= 8'h01;
                                                end
                                                8'h01: begin
                                                    ADDRESS <= 8'h01;
                                                    CHARACTER <= 8'h64; //d
                                                    address <= 8'h02;
                                                end
                                                8'h02: begin
                                                    ADDRESS <= 8'h02;
                                                    CHARACTER <= 8'h6c; //l
                                                    address <= 8'h03;
                                                end
                                                8'h03: begin
                                                    ADDRESS <= 8'h03;
                                                    CHARACTER <= 8'h65; //e
                                                    address <= 8'h04;
                                                end
                                                8'h04: begin
                                                    ADDRESS <= 8'h04;
                                                    CHARACTER <= 8'h2e; //.
                                                    address <= 8'h05;
                                                end
                                                8'h05: begin
                                                    ADDRESS <= 8'h05;
                                                    CHARACTER <= 8'h2e; //.
                                                    address <= 8'h06;
                                                end
                                                8'h06: begin
                                                    ADDRESS <= 8'h04;
                                                    CHARACTER <= 8'h2e; //.
                                                    address <= 8'h40;
                                                    line <= 1'b1;
                                                end
                                            endcase
                                        end
                                        REC_PLAY: begin
                                            case(address)
                                                8'h00: begin
                                                    ADDRESS <= 8'h00;
                                                    CHARACTER <= 8'h50; //P
                                                    address <= 8'h01;
                                                end
                                                8'h01: begin
                                                    ADDRESS <= 8'h01;
                                                    CHARACTER <= 8'h6c; //l
                                                    address <= 8'h02;
                                                end
                                                8'h02: begin
                                                    ADDRESS <= 8'h02;
                                                    CHARACTER <= 8'h61; //a
                                                    address <= 8'h03;
                                                end
                                                8'h03: begin
                                                    ADDRESS <= 8'h03;
                                                    CHARACTER <= 8'h79; //y
                                                    address <= 8'h0c;
                                                end
                                                8'h0c: begin
                                                    ADDRESS <= 8'h0c;
                                                    CHARACTER <= 8'h30 + min;
                                                    address <= 8'h0d;
                                                end
                                                8'h0d: begin
                                                    ADDRESS <= 8'h0d;
                                                    CHARACTER <= 8'h3a;
                                                    address <= 8'h0e;
                                                end
                                                8'h0e: begin
                                                    ADDRESS <= 8'h0e;
                                                    CHARACTER <= 8'h30 + sec_ten;
                                                    address <= 8'h0f;
                                                end
                                                8'h0f: begin
                                                    ADDRESS <= 8'h0f;
                                                    CHARACTER <= 8'h30 + sec_one;
                                                    address <= 8'h40;
                                                    line <= 1'b1;
                                                end
                                            endcase
                                        end
                                        REC_PAUSE: begin
                                            case(address)
                                                8'h00: begin
                                                    ADDRESS <= 8'h00;
                                                    CHARACTER <= 8'h50; // P
                                                    address <= 8'h01;
                                                end
                                                8'h01: begin
                                                    ADDRESS <= 8'h01;
                                                    CHARACTER <= 8'h61; // a
                                                    address <= 8'h02;
                                                end
                                                8'h02: begin
                                                    ADDRESS <= 8'h02;
                                                    CHARACTER <= 8'h75; // u
                                                    address <= 8'h03;
                                                end
                                                8'h03: begin
                                                    ADDRESS <= 8'h03;
                                                    CHARACTER <= 8'h73; // s
                                                    address <= 8'h04;
                                                end
                                                8'h04: begin
                                                    ADDRESS <= 8'h04;
                                                    CHARACTER <= 8'h65; // e
                                                    address <= 8'h40;
                                                    line <= 1'b1;
                                                end
                                            endcase
                                        end
                                        REC_STOP: begin
                                            case(address)
                                                8'h00: begin
                                                    ADDRESS <= 8'h00;
                                                    CHARACTER <= 8'h53; // S
                                                    address <= 8'h01;
                                                end
                                                8'h01: begin
                                                    ADDRESS <= 8'h01;
                                                    CHARACTER <= 8'h74; // t
                                                    address <= 8'h02;
                                                end
                                                8'h02: begin
                                                    ADDRESS <= 8'h02;
                                                    CHARACTER <= 8'h6f; // o
                                                    address <= 8'h03;
                                                end
                                                8'h03: begin
                                                    ADDRESS <= 8'h03;
                                                    CHARACTER <= 8'h70; // p
                                                    address <= 8'h40;
                                                    line <= 1'b1;
                                                end
                                            endcase
                                        end
                                        REC_RECORD: begin
                                            case(address)
                                                8'h00: begin
                                                    CHARACTER <= 8'h52; // R
                                                    ADDRESS <= 8'h00;
                                                    address <= 8'h01;
                                                end
                                                8'h01: begin
                                                    ADDRESS <= 8'h01;
                                                    CHARACTER <= 8'h65; // e
                                                    address <= 8'h02;
                                                end
                                                8'h02: begin
                                                    ADDRESS <= 8'h02;
                                                    CHARACTER <= 8'h63; // c
                                                    address <= 8'h03;
                                                end
                                                8'h03: begin
                                                    ADDRESS <= 8'h03;
                                                    CHARACTER <= 8'h6f; // o
                                                    address <= 8'h04;
                                                end
                                                8'h04: begin
                                                    ADDRESS <= 8'h04;
                                                    CHARACTER <= 8'h72; // r
                                                    address <= 8'h05;
                                                end
                                                8'h05: begin
                                                    ADDRESS <= 8'h05;
                                                    CHARACTER <= 8'h64; // d
                                                    address <= 8'h06;
                                                end
                                                8'h06: begin
                                                    ADDRESS <= 8'h06;
                                                    CHARACTER <= 8'h69; // i
                                                    address <= 8'h07;
                                                end
                                                8'h07: begin
                                                    ADDRESS <= 8'h07;
                                                    CHARACTER <= 8'h6e; // n
                                                    address <= 8'h08;
                                                end
                                                8'h08: begin
                                                    ADDRESS <= 8'h08;
                                                    CHARACTER <= 8'h67; // g
                                                    address <= 8'h0c;
                                                end
                                                8'h0c: begin
                                                    ADDRESS <= 8'h0c;
                                                    CHARACTER <= 8'h30 + min;
                                                    address <= 8'h0d;
                                                end
                                                8'h0d: begin
                                                    ADDRESS <= 8'h0d;
                                                    CHARACTER <= 8'h3a;
                                                    address <= 8'h0e;
                                                end
                                                8'h0e: begin
                                                    ADDRESS <= 8'h0e;
                                                    CHARACTER <= 8'h30 + sec_ten;
                                                    address <= 8'h0f;
                                                end
                                                8'h0f: begin
                                                    ADDRESS <= 8'h0f;
                                                    CHARACTER <= 8'h30 + sec_one;
                                                    address <= 8'h40;
                                                    line <= 1'b1;
                                                end
                                            endcase
                                        end
                                    endcase
                                end
                                1'b1: begin
                                    case(address)
                                        8'h40: begin
                                            case(control_mode)
                                                REC_SLOW: begin
                                                    CHARACTER <= 8'h2f; // / 
                                                    ADDRESS <= 8'h40;
                                                    address <= 8'h41;
                                                end
                                                REC_FAST: begin
                                                    CHARACTER <= 8'h2a; // *
                                                    ADDRESS <= 8'h40;
                                                    address <= 8'h41;
                                                end
												REC_NORMAL: begin
													address <= 8'h43;
												end
                                            endcase
                                        end
                                        8'h41: begin
                                            CHARACTER <= 8'h30+control_speed;
                                            ADDRESS <= 8'h41;
                                            address <= 8'h42;
                                        end
                                        8'h42: begin
                                            CHARACTER <= 8'h20;
                                            ADDRESS <= 8'h42;
                                            address <= 8'h43;
                                        end
                                        8'h43: begin
                                            case(control_interpol)
                                                1'b1: begin
                                                    CHARACTER <= 8'h40;
                                                end
                                                1'b0: begin
                                                    CHARACTER <= 8'h30;
                                                end
                                            endcase
                                            ADDRESS <= 8'h43;
                                            address <= 8'h44;
                                        end
                                        8'h44: begin
                                            if(control_code != REC_PLAY) begin
                                                address <= 8'h0;
                                                state <= REST;
                                            end else begin
                                                address <= 8'h0;
                                                state <= REST;
                                            end
                                        end
                                    endcase
                                end
                            endcase
                        end
                    end
                    CLEAR_LCD: begin
                        if(!BUSY) begin
                            START <= 0;
                            CLEAR <= 1;
                            address <= 8'h0;
                            line <= 1'b0;
                            state <= WRITE;
                        end
                    end
                    REST: begin
                        START <= 0;
								CLEAR <= 0;
                        if(STATUS != curr_status) begin
                            curr_status <= STATUS;
                            state <= CLEAR_LCD;
                        end
                    end
                endcase
            end
        end
	end
endmodule