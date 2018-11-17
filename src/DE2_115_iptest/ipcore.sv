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
    inout  logic [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
    output logic [19:0] SRAM_ADDR,   // SRAM Address bus 20 Bits
    output logic        SRAM_WE_N,   // SRAM Write Enable
    output logic        SRAM_CE_N,   // SRAM Chip Enable
    output logic        SRAM_OE_N,   // SRAM Output Enable
    output logic        SRAM_LB_N,   // SRAM Low-byte Data Mask 
    output logic        SRAM_UB_N,   // SRAM High-byte Data Mask 
    input  logic record,
    input  logic play,
    output logic [1:0] state,
    output logic debug
);
logic n_debug;

logic [1:0] n_state;
localparam IDLE = 2'd0;
localparam REC  = 2'd1;
localparam PLAY = 2'd2;

//SRAM variable
logic [19:0] n_SRAM_ADDR;
localparam NOT_SELECT = 5'b01000;
localparam READ       = 5'b10000;
localparam WRITE      = 5'b00000;

logic [15:0] r_SRAM_DQ, n_SRAM_DQ;
assign SRAM_DQ = SRAM_WE_N ? 16'hzzzz : n_SRAM_DQ;
assign to_dac_left_channel_data = SRAM_DQ;
assign to_dac_right_channel_data = 16'd0;


//audio variable

logic [19:0] counter, n_counter;

always_ff @(posedge i_clk or posedge i_rst) begin
    if ( i_rst ) begin
        state <= IDLE;
        SRAM_ADDR <= 0;
        counter <= 0;
        debug <= 0;
    end else begin
        state <= n_state;
        SRAM_ADDR <= n_SRAM_ADDR;
        counter <= n_counter;
        debug <= n_debug;
    end
end

always_comb begin

    n_state = state;
    n_SRAM_ADDR = SRAM_ADDR;
    from_adc_left_channel_ready = 0;
    n_SRAM_DQ = 0;
    setSRAMenable(NOT_SELECT);
    to_dac_left_channel_valid = 0;
    to_dac_right_channel_valid = 0;
    n_counter = counter;
    n_debug = debug;

    case(state)
        IDLE: begin
            n_SRAM_ADDR = 20'd0;
            n_debug = 0;
            if ( record ) begin
                n_state = REC;
                n_counter = 0;
            end else begin
                n_state = state;
            end
        end
        REC: begin
            from_adc_left_channel_ready = 1;
            if ( from_adc_left_channel_valid ) begin
                setSRAMenable(WRITE);
                n_SRAM_DQ = from_adc_left_channel_data;
                n_SRAM_ADDR = SRAM_ADDR + 1;
            end
            if ( play ) begin
                n_state = PLAY;
                n_SRAM_ADDR = 0;
            end else begin
                n_state = REC;
            end
        end
        PLAY: begin
            to_dac_left_channel_valid = 1;
            to_dac_right_channel_valid = 1;
            setSRAMenable(READ);
            
            //to_dac_left_channel_data = SRAM_DQ;
            //to_dac_right_channel_data = SRAM_DQ;    
            //They are assigned above        
            if (to_dac_left_channel_ready) begin
                n_debug = 1;
                n_SRAM_ADDR = SRAM_ADDR + 1;
                n_counter = counter + 1;
                if (counter == 20'd65535) begin
                    n_state = IDLE;
                end
            end
            n_state = state;
        end
        default: n_state = state;
    endcase
end

task setSRAMenable;
    input [4:0] mode;
    begin
        SRAM_WE_N = mode[4];
        SRAM_CE_N = mode[3];
        SRAM_OE_N = mode[2];
        SRAM_LB_N = mode[1];
        SRAM_UB_N = mode[0];
    end    
endtask 
endmodule
/*
assign from_adc_left_channel_ready  = to_dac_left_channel_ready;
assign from_adc_right_channel_ready = to_dac_right_channel_ready;
assign to_dac_left_channel_valid = from_adc_left_channel_valid;
assign to_dac_right_channel_valid = from_adc_right_channel_valid;
assign to_dac_left_channel_data = from_adc_left_channel_data;
assign to_dac_right_channel_data = from_adc_right_channel_data;
*/