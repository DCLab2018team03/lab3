`include "include/RecorderDefine.vh"

`timescale 1ns/100ps

module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;

	logic clk, start_cal, fin, rst;
	initial clk = 0;
	always #HCLK clk = ~clk;

	// logic between I2S and AudioCore
	logic            w_adc_left_ready;
	logic    [15:0]  w_adc_left_data;
	logic            w_adc_left_valid;
	logic            w_dac_left_ready;
	logic    [15:0]  w_dac_left_data;
	logic            w_dac_left_valid;
	logic            w_adc_right_ready;
	logic    [15:0]  w_adc_right_data;
	logic            w_adc_right_valid;
	logic            w_dac_right_ready;
	logic    [15:0]  w_dac_right_data;
	logic            w_dac_right_valid;
    // logic between AudioCore and SRAM
    logic    [19:0]  w_address;
    logic            w_read;
    logic            w_write;
    logic    [15:0]  w_writedata;
    logic    [15:0]  w_readdata;
    logic            w_readdatavalid;

    logic    [15:0]  w_input_event;
    logic    [15:0]  w_event_hold;
	logic    [63:0]  w_time;

    AudioCore recorder(
		.i_clk(clk),
		.i_rst(rst),
		// Input
		.i_event(w_input_event),
        // Output
		.o_stop_signal(),
		.o_time(w_time),
        // avalon_audio_slave
        // avalon_left_channel_source
		.from_adc_left_channel_ready(w_adc_left_ready),
        .from_adc_left_channel_data(w_adc_left_data),
        .from_adc_left_channel_valid(w_adc_left_valid),
        // avalon_right_channel_source
        .from_adc_right_channel_ready(w_adc_right_ready),
        .from_adc_right_channel_data(w_adc_right_data),
        .from_adc_right_channel_valid(w_adc_right_valid),
        // avalon_left_channel_sink
        .to_dac_left_channel_data(w_dac_left_data),
        .to_dac_left_channel_valid(w_dac_left_valid),
        .to_dac_left_channel_ready(w_dac_left_ready),
        // avalon_left_channel_sink
        .to_dac_right_channel_data(w_dac_right_data),
        .to_dac_right_channel_valid(w_dac_right_valid),
        .to_dac_right_channel_ready(w_dac_right_ready),
        // avalon_sram_slave
        .address      (w_address),
        .read         (w_read),
        .write        (w_write),
        .writedata    (w_writedata),
        .readdata     (w_readdata),
        .readdatavalid(w_readdatavalid)
	); 

	initial begin
		$fsdbDumpfile("lab2.fsdb");
		$fsdbDumpvars;
		rst = 1;
		#(2*CLK)
		rst = 0;
        @(posedge clk);
        w_input_event = {REC_RECORD, 12'd0};
        w_adc_left_valid = 1;
		@(posedge clk);
        w_adc_left_data = 16'h5B;
        @(posedge clk);
        w_adc_left_data = 16'h4F;
        @(posedge clk);
        w_adc_left_data = 16'h29;
        @(negedge clk);
        w_adc_left_valid = 0;
        @(posedge clk);
        @(posedge clk);
        w_adc_left_valid = 1;
        w_adc_left_data = 16'h5B;
        @(posedge clk);
        w_adc_left_valid = 1;
        w_adc_left_data = 16'h09;
        @(posedge clk);
        w_adc_left_valid = 1;
        w_adc_left_data = 16'h66;
        @(posedge clk);
        w_adc_left_valid = 1;
        w_adc_left_data = 16'h66;
        @(posedge clk);
        w_adc_left_valid = 0;
        @(posedge clk);
        @(posedge clk);
        w_input_event = {REC_STOP, 12'd0};
        @(posedge clk);
        w_input_event = {REC_PLAY, 12'd0};
        w_readdatavalid = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        w_readdatavalid = 1;
        w_readdata = 16'h66;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        w_readdatavalid = 1;
        w_readdata = 16'h65;
        @(posedge clk);
        w_readdatavalid = 1;
        w_readdata = 16'h36;       
        @(posedge clk);
        @(posedge clk);
        w_readdatavalid = 1;
        w_readdata = 16'h56;
        @(posedge clk);
        @(posedge clk);
        w_readdatavalid = 1;
        w_readdata = 16'h66;
        $finish;
	end

	initial begin
		#(500000*CLK)
		$display("Too slow, abort.");
		$finish;
	end

endmodule


