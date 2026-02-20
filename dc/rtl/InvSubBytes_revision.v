module InvSubBytes (
    input wire clk,
    input wire rst, 
    input wire [127:0] data_in,
    output wire [127:0] data_out
);

    // 128비트 데이터를 16개의 8비트 블록으로 나누어 
    // 각각 3단계 파이프라인 SBOX에 병렬로 연결
    
    // [Byte 0 ~ 3]
    InvSBOX_Pipe SBOX1st (.clk(clk), .rst_n(rst), .data_in(data_in[7:0]),   .data_out(data_out[7:0]));
    InvSBOX_Pipe SBOX2nd (.clk(clk), .rst_n(rst), .data_in(data_in[15:8]),  .data_out(data_out[15:8]));
    InvSBOX_Pipe SBOX3rd (.clk(clk), .rst_n(rst), .data_in(data_in[23:16]), .data_out(data_out[23:16]));
    InvSBOX_Pipe SBOX4th (.clk(clk), .rst_n(rst), .data_in(data_in[31:24]), .data_out(data_out[31:24]));

    // [Byte 4 ~ 7]
    InvSBOX_Pipe SBOX5th (.clk(clk), .rst_n(rst), .data_in(data_in[39:32]), .data_out(data_out[39:32]));
    InvSBOX_Pipe SBOX6th (.clk(clk), .rst_n(rst), .data_in(data_in[47:40]), .data_out(data_out[47:40]));
    InvSBOX_Pipe SBOX7th (.clk(clk), .rst_n(rst), .data_in(data_in[55:48]), .data_out(data_out[55:48]));
    InvSBOX_Pipe SBOX8th (.clk(clk), .rst_n(rst), .data_in(data_in[63:56]), .data_out(data_out[63:56]));

    // [Byte 8 ~ 11]
    InvSBOX_Pipe SBOX9th  (.clk(clk), .rst_n(rst), .data_in(data_in[71:64]),  .data_out(data_out[71:64]));
    InvSBOX_Pipe SBOX10th (.clk(clk), .rst_n(rst), .data_in(data_in[79:72]),  .data_out(data_out[79:72]));
    InvSBOX_Pipe SBOX11th (.clk(clk), .rst_n(rst), .data_in(data_in[87:80]),  .data_out(data_out[87:80]));
    InvSBOX_Pipe SBOX12th (.clk(clk), .rst_n(rst), .data_in(data_in[95:88]),  .data_out(data_out[95:88]));

    // [Byte 12 ~ 15]
    InvSBOX_Pipe SBOX13th (.clk(clk), .rst_n(rst), .data_in(data_in[103:96]),  .data_out(data_out[103:96]));
    InvSBOX_Pipe SBOX14th (.clk(clk), .rst_n(rst), .data_in(data_in[111:104]), .data_out(data_out[111:104]));
    InvSBOX_Pipe SBOX15th (.clk(clk), .rst_n(rst), .data_in(data_in[119:112]), .data_out(data_out[119:112]));
    InvSBOX_Pipe SBOX16th (.clk(clk), .rst_n(rst), .data_in(data_in[127:120]), .data_out(data_out[127:120]));

endmodule