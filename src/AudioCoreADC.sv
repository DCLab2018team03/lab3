
module AudioCoreADC(
    input           i_rst,
    // Data
    output  [REC_BITLEN-1:0]  o_data,
    // Audio CODEC
    input           AUD_BCLK,
    input           AUD_ADCLRCK,
    input           AUD_ADCDAT
);
endmodule