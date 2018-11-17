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
    input  logic reccord,
    input  logic play,
    output logic [1:0] state;
);

logic [1:0] n_state;
localparam IDLE = 2'd0;
localparam REC  = 2'd1;
localparam PLAY = 2'd2;

//SRAM variable
logic [19:0] n_SRAM_ADDR;
localparam NOT_SELECT = 5'bz1zzz;
localparam READ       = 5'b10000;
localparam WRITE      = 5'b00z00;

logic [19:0] r_SRAM_DQ;
assign SRAM_DQ = SRAM_WE_N ? 20'bz : r_SRAM_DQ;
assign to_dac_left_channel_data = SRAM_DQ;
assign to_dac_right_channel_data = SRAM_DQ; 


//audio variable
logic n_from_adc_left_channel_ready;

always_ff @(posedge i_clk or posedge i_rst) begin
    if ( rst ) begin
        state <= IDLE;
        SRAM_ADDR <= 0;
        from_adc_left_channel_ready <= 0;
    end else begin
        state <= n_state;
        SRAM_ADDR <= n_SRAM_ADDR;
        from_adc_left_channel_ready <= n_from_adc_left_channel_ready;
    end
end

always_comb begin

    n_state = state;
    n_SRAM_ADDR = SRAM_ADDR;
    n_from_adc_left_channel_ready = from_adc_left_channel_ready;
    r_SRAM_DQ = 0;
    setSRAMenable(NOT_SELECT);
    to_dac_left_channel_valid = 0;
    to_dac_right_channel_valid = 0;

    case(state)
        IDLE: begin
            n_SRAM_ADDR = 20'd0;
            if ( REC ) begin
                n_state = REC;
            end else begin
                n_state = state;
            end
        end
        REC: begin
            if ( from_adc_left_channel_valid ) begin
                n_from_adc_left_channel_ready = 1;
                r_SRAM_DQ = from_adc_left_channel_data;
                n_SRAM_ADDR = SRAM_ADDR + 2;
                setSRAMenable(WRITE);
            end else begin
                n_from_adc_left_channel_ready = 0;
            end
            if ( PLAY ) begin
                n_state = PLAY;
                n_SRAM_ADDR = 0;
                setSRAMenable(WRITE);
                n_from_adc_left_channel_ready = 0;
            end else begin
                n_state = REC;
            end
        end
        PLAY: begin
            to_dac_left_channel_valid = 1;
            to_dac_right_channel_valid = 1;
            
            //to_dac_left_channel_data = SRAM_DQ;
            //to_dac_right_channel_data = SRAM_DQ;    
            //They are assigned above        
            
            n_SRAM_ADDR = SRAM_ADDR + 2;
            setSRAMenable(READ);
            n_state = state
        end
        default: n_state = state;
    endcase
end

task setSRAMenable;
    input [4:0] mode;
    begin
        SRAM_WE_N = mode[4]
        SRAM_CE_N = mode[3]
        SRAM_OE_N = mode[2]
        SRAM_LB_N = mode[1]
        SRAM_UB_N = mode[0]
    end    
endtask 

/*
assign from_adc_left_channel_ready  = to_dac_left_channel_ready;
assign from_adc_right_channel_ready = to_dac_right_channel_ready;
assign to_dac_left_channel_valid = from_adc_left_channel_valid;
assign to_dac_right_channel_valid = from_adc_right_channel_valid;
assign to_dac_left_channel_data = from_adc_left_channel_data;
assign to_dac_right_channel_data = from_adc_right_channel_data;
*/