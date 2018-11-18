module IPCore(
    input  logic         i_clk,
    input  logic         i_rst,
    // avalon_audio_slave
    // avalon_left_channel_source
    output logic from_adc_left_channel_ready,
    input  logic [15:0] from_adc_left_channel_data,
    input  logic from_adc_left_channel_valid,
    // avalon_right_channel_source
    output logic from_adc_right_channel_ready,
    input  logic [15:0] from_adc_right_channel_data,
    input  logic from_adc_right_channel_valid,
    // avalon_left_channel_sink
    output logic [15:0] to_dac_left_channel_data,
    output logic to_dac_left_channel_valid,
    input  logic to_dac_left_channel_ready,
    // avalon_right_channel_sink
    output logic [15:0] to_dac_right_channel_data,
    output logic to_dac_right_channel_valid,
    input  logic to_dac_right_channel_ready,
    /* SRAM
    inout  logic [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
    output logic [19:0] SRAM_ADDR,   // SRAM Address bus 20 Bits
    output logic        SRAM_WE_N,   // SRAM Write Enable
    output logic        SRAM_CE_N,   // SRAM Chip Enable
    output logic        SRAM_OE_N,   // SRAM Output Enable
    output logic        SRAM_LB_N,   // SRAM Low-byte Data Mask 
    output logic        SRAM_UB_N,   // SRAM High-byte Data Mask 
    */
    output logic [22:0] new_sdram_controller_0_s1_address,                //                   new_sdram_controller_0_s1.address
	output logic [3:0]  new_sdram_controller_0_s1_byteenable_n,           //                   .byteenable_n
	output logic        new_sdram_controller_0_s1_chipselect,             //                   .chipselect
	output logic [31:0] new_sdram_controller_0_s1_writedata,              //                   .writedata
	output logic        new_sdram_controller_0_s1_read_n,                 //                   .read_n
	output logic        new_sdram_controller_0_s1_write_n,                //                   .write_n
	input  logic [31:0] new_sdram_controller_0_s1_readdata,               //                   .readdata
	input  logic        new_sdram_controller_0_s1_readdatavalid,          //                   .readdatavalid
	input  logic        new_sdram_controller_0_s1_waitrequest,            //                   .waitrequest

    input  logic record,
    input  logic play,
    output logic [2:0] state,
    output logic debug
);
logic n_debug;
logic [2:0] n_state;
localparam IDLE = 3'd0;
localparam REC  = 3'd1;
localparam PLAY = 3'd2;
localparam REC_WRITE = 3'd3;
localparam PLAY_READ = 3'd4;


/*
//SRAM variable
logic [19:0] n_SRAM_ADDR;
localparam NOT_SELECT = 5'b01000;
localparam READ       = 5'b10000;
localparam WRITE      = 5'b00000;


logic [15:0] r_SRAM_DQ, n_SRAM_DQ;
assign SRAM_DQ = SRAM_WE_N ? 16'hzzzz : n_SRAM_DQ;
*/

//SDRAM variable
logic [22:0] n_SDRAM_ADDR;
logic [31:0] SDRAM_DQ, n_SDRAM_DQ;
logic sdram_data_counter, n_sdram_data_counter; // 2-16 bit -> 32bit
assign new_sdram_controller_0_s1_byteenable_n = 4'b1111;
assign new_sdram_controller_0_s1_chipselect   = 1'b1;
assign new_sdram_controller_0_s1_writedata = SDRAM_DQ;

//audio variable
logic n_to_dac_left_channel_valid, n_to_dac_right_channel_valid;
assign to_dac_left_channel_data  = SDRAM_DQ[31:16];
assign to_dac_right_channel_data = SDRAM_DQ[15:0];



always_ff @(posedge i_clk or posedge i_rst) begin
    if ( i_rst ) begin
        state <= IDLE;
        new_sdram_controller_0_s1_address   <= 0;
        SDRAM_DQ <= 32'd0;
        debug <= 0;
        to_dac_left_channel_valid <= 0;
        to_dac_right_channel_valid <= 0;
        sdram_data_counter <= 1'b0;
    end else begin
        state <= n_state;
        new_sdram_controller_0_s1_address   <= n_SDRAM_ADDR;
        SDRAM_DQ <= n_SDRAM_DQ;
        debug <= n_debug;
        to_dac_left_channel_valid  <= n_to_dac_left_channel_valid;
        to_dac_right_channel_valid <= n_to_dac_right_channel_valid;
        sdram_data_counter <= n_sdram_data_counter;
    end
end

always_comb begin

    n_state = state;
    n_debug = debug;
    
    from_adc_left_channel_ready = 0;
    n_to_dac_left_channel_valid = to_dac_left_channel_valid;
    n_to_dac_right_channel_valid = to_dac_right_channel_valid;
    
    n_SDRAM_ADDR = new_sdram_controller_0_s1_address;
    n_SDRAM_DQ = SDRAM_DQ;
    n_sdram_data_counter = sdram_data_counter;

    new_sdram_controller_0_s1_read_n = 1;
    new_sdram_controller_0_s1_write_n = 1;

    case(state)
        IDLE: begin
            n_debug = 0;
            n_SDRAM_ADDR = 23'd0;
            n_sdram_data_counter = 0;
            if ( record ) begin
                n_state = REC;
            end 
        end
        REC: begin
            from_adc_left_channel_ready = 1;
            if ( from_adc_left_channel_valid ) begin
                if ( !sdram_data_counter ) begin
                    n_SDRAM_DQ[31:16] = from_adc_left_channel_data;
                end else begin
                    n_SDRAM_DQ[15:0]  = from_adc_left_channel_data;
                    n_state = REC_WRITE;                  
                end
                n_sdram_data_counter = ~sdram_data_counter;
            end
            if ( play ) begin
                n_state = PLAY_READ;
                n_SDRAM_ADDR = 0;
                n_to_dac_left_channel_valid = 0;
                n_to_dac_right_channel_valid = 0;
            end
        end
        REC_WRITE: begin
            new_sdram_controller_0_s1_write_n = 0;
            if ( !new_sdram_controller_0_s1_waitrequest ) begin
                n_SDRAM_ADDR = new_sdram_controller_0_s1_address + 1;
                n_state = REC;
            end
        end
        PLAY: begin
            
            //to_dac_left_channel_data  = SDRAM_DQ[31:16];
            //to_dac_right_channel_data = SDRAM_DQ[15:0];    

            if (to_dac_left_channel_ready && to_dac_left_channel_valid) begin
                n_to_dac_left_channel_valid = 0;
                n_to_dac_right_channel_valid = 1;
            end
            if (to_dac_right_channel_ready && to_dac_right_channel_valid) begin
                n_to_dac_left_channel_valid = 0;
                n_to_dac_right_channel_valid = 0;

                n_state = PLAY_READ;
            end
        end
        PLAY_READ: begin
            new_sdram_controller_0_s1_read_n = 0;
            n_SDRAM_DQ = new_sdram_controller_0_s1_readdata;
            if ( !new_sdram_controller_0_s1_waitrequest && new_sdram_controller_0_s1_readdatavalid ) begin
                n_state = PLAY;
                n_to_dac_left_channel_valid = 1;
                n_to_dac_right_channel_valid = 0;
                n_SDRAM_ADDR = new_sdram_controller_0_s1_address + 1;
            end
        end
        default: n_state = state;
    endcase
end

endmodule