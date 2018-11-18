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
	input [15:0] PLAY_TIME,
    input [15:0] TOT_TIME,
	
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
    logic [3:0] play_min_ten, play_min_one, play_sec_ten, play_sec_one;
    logic [3:0] tot_min_ten,  tot_min_one,  tot_sec_ten,  tot_sec_one;

	 assign stat = state;
	 
    assign control_code     = curr_status[15:12];
    assign control_mode     = curr_status[11:10];
    assign control_speed    = curr_status[9:6];
    assign control_interpol = curr_status[5];
    assign play_min_ten     = PLAY_TIME[15:12];
    assign play_min_one     = PLAY_TIME[11:8];
    assign play_sec_ten     = PLAY_TIME[7:4];
    assign play_sec_one     = PLAY_TIME[3:0];
    assign tot_min_ten      = TOT_TIME[15:12];
    assign tot_min_one      = TOT_TIME[11:8];
    assign tot_sec_ten      = TOT_TIME[7:4];
    assign tot_sec_one      = TOT_TIME[3:0];


    always_ff @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            curr_code <= REC_NONE;
            curr_status <= STATUS;
            state <= CLEAR_LCD;
            address <= 8'h00;
            line <= 1'b0;
        end else begin
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
                                                address <= 8'h05;
                                            end
                                            8'h05: begin
                                                ADDRESS <= 8'h05;
                                                CHARACTER <= 8'h30 + play_min_ten;
                                                address <= 8'h06;
                                            end
                                            8'h06: begin
                                                ADDRESS <= 8'h06;
                                                CHARACTER <= 8'h30 + play_min_one;
                                                address <= 8'h07;
                                            end
                                            8'h07: begin
                                                ADDRESS <= 8'h07;
                                                CHARACTER <= 8'h3a; // :
                                                address <= 8'h08;
                                            end
                                            8'h08: begin
                                                ADDRESS <= 8'h08;
                                                CHARACTER <= 8'h30 + play_sec_ten;
                                                address <= 8'h09;
                                            end
                                            8'h09: begin
                                                ADDRESS <= 8'h09;
                                                CHARACTER <= 8'h30 + play_sec_one;
                                                address <= 8'h0a;
                                            end
                                            8'h0a: begin
                                                ADDRESS <= 8'h0a;
                                                CHARACTER <= 8'h2f; // /
                                                address <= 8'h0b;
                                            end
                                            8'h0b: begin
                                                ADDRESS <= 8'h0b;
                                                CHARACTER <= 8'h30 + tot_min_ten;
                                                address <= 8'h0c;
                                            end
                                            8'h0c: begin
                                                ADDRESS <= 8'h0c;
                                                CHARACTER <= 8'h30 + tot_min_one;
                                                address <= 8'h0d;
                                            end
                                            8'h0d: begin
                                                ADDRESS <= 8'h0d;
                                                CHARACTER <= 8'h3a; // :
                                                address <= 8'h0e;
                                            end
                                            8'h0e: begin
                                                ADDRESS <= 8'h0e;
                                                CHARACTER <= 8'h30 + tot_sec_ten;
                                                address <= 8'h0f;
                                            end
                                            8'h0f: begin
                                                ADDRESS <= 8'h0f;
                                                CHARACTER <= 8'h30 + tot_sec_one;
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
                                                address <= 8'h0b;
                                            end
                                            8'h0b: begin
                                                ADDRESS <= 8'h0b;
                                                CHARACTER <= 8'h30 + tot_min_ten;
                                                address <= 8'h0c;
                                            end
                                            8'h0c: begin
                                                ADDRESS <= 8'h0c;
                                                CHARACTER <= 8'h30 + tot_min_one;
                                                address <= 8'h0d;
                                            end
                                            8'h0d: begin
                                                ADDRESS <= 8'h0d;
                                                CHARACTER <= 8'h3a; // :
                                                address <= 8'h0e;
                                            end
                                            8'h0e: begin
                                                ADDRESS <= 8'h0e;
                                                CHARACTER <= 8'h30 + tot_sec_ten;
                                                address <= 8'h0f;
                                            end
                                            8'h0f: begin
                                                ADDRESS <= 8'h0f;
                                                CHARACTER <= 8'h30 + tot_sec_one;
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
                    if(curr_status != STATUS) begin
                        curr_status <= STATUS;
                        state <= CLEAR_LCD;
                    end else begin
                        state <= WRITE;
                    end
                end
            endcase
        end
	end
endmodule