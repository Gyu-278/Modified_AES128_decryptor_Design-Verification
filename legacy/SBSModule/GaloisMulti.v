module GaloisMulti(invMDS, in, out);

input[127:0] invMDS;
input[127:0] in;
output[127:0] out;

GaloisOneRow firstrow({invMDS[127:120], invMDS[95:88], invMDS[63:56], invMDS[31:24]}, in, {out[127:120], out[95:88], out[63:56], out[31:24]});
GaloisOneRow secondrow({invMDS[119:112], invMDS[87:80], invMDS[55:48], invMDS[23:16]}, in, {out[119:112], out[87:80], out[55:48], out[23:16]});
GaloisOneRow thirdrow({invMDS[111:104], invMDS[79:72], invMDS[47:40], invMDS[15:8]}, in, {out[111:104], out[79:72], out[47:40], out[15:8]});
GaloisOneRow lastrow({invMDS[103:96], invMDS[71:64], invMDS[39:32], invMDS[7:0]}, in, {out[103:96], out[71:64], out[39:32], out[7:0]});

endmodule
