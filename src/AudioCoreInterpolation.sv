module AudioCoreInterpolation (
    input   [15:0]  i_data_prev,
    input   [15:0]  i_data,
    input   [3:0]   i_divisor,
    output logic [15:0]  o_quotient
);
    wire [15:0] C, _C;
    assign C = i_data + ~i_data_prev + 16'b1;
    assign _C = ~C + 16'b1;
    
    /*  
    x/1  = x
    x/2  = x>>1
    x/3 ~= x>>2 + x>>4 + x>>6
    x/4  = x>>2
    x/5 ~= x>>3 + x>>4 + x>>6
    x/6 ~= x>>3 + x>>5 + x>>7
    x/7 ~= x>>3 + x>>6 + x>>9
    x/8  = x>>3
    */
    
    always_comb begin
        case (i_divisor)
            4'd1:    o_quotient = C;
            4'd2:    o_quotient = C[15] ? (16'b1+~(_C>>1)) : (C>>1);
            4'd3:    o_quotient = C[15] ? (16'b1+~((_C>>2)+(_C>>4)+(_C>>6))) : ((C>>2)+(C>>4)+(C>>6));
            4'd4:    o_quotient = C[15] ? (16'b1+~(_C>>2)) : (C>>2);
            4'd5:    o_quotient = C[15] ? (16'b1+~((_C>>3)+(_C>>4)+(_C>>6))) : ((C>>3)+(C>>4)+(C>>6));
            4'd6:    o_quotient = C[15] ? (16'b1+~((_C>>3)+(_C>>5)+(_C>>7))) : ((C>>3)+(C>>5)+(C>>7));
            4'd7:    o_quotient = C[15] ? (16'b1+~((_C>>3)+(_C>>6)+(_C>>9))) : ((C>>3)+(C>>6)+(C>>9));
            4'd8:    o_quotient = C[15] ? (16'b1+~(_C>>3)) : (C>>3);
            default: o_quotient = 0;
        endcase
    end
    
endmodule
