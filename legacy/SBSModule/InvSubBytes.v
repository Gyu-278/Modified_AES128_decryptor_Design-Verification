module InvSubBytes (data_in, data_out);

input[127:0] data_in;
output [127:0] data_out;

InvSBOX SBOX1st(data_in[7:0], data_out[7:0]);
InvSBOX SBOX2nd(data_in[15:8], data_out[15:8]);
InvSBOX SBOX3rd(data_in[23:16], data_out[23:16]);
InvSBOX SBOX4th(data_in[31:24], data_out[31:24]);
InvSBOX SBOX5th(data_in[39:32], data_out[39:32]);
InvSBOX SBOX6th(data_in[47:40], data_out[47:40]);
InvSBOX SBOX7th(data_in[55:48], data_out[55:48]);
InvSBOX SBOX8th(data_in[63:56], data_out[63:56]);
InvSBOX SBOX9th(data_in[71:64], data_out[71:64]);
InvSBOX SBOX10th(data_in[79:72], data_out[79:72]);
InvSBOX SBOX11th(data_in[87:80], data_out[87:80]);
InvSBOX SBOX12th(data_in[95:88], data_out[95:88]);
InvSBOX SBOX13th(data_in[103:96], data_out[103:96]);
InvSBOX SBOX14th(data_in[111:104], data_out[111:104]);
InvSBOX SBOX15th(data_in[119:112], data_out[119:112]);
InvSBOX SBOX16th(data_in[127:120], data_out[127:120]);


endmodule