
module AudioCoreDAC(
    input           i_rst,
    // Data
    input   [REC_BITLEN-1:0]  i_data,
    // Audio CODEC
    input           AUD_BCLK,
    input           AUD_DACLRCK,
    output          AUD_DACDAT
);

endmodule