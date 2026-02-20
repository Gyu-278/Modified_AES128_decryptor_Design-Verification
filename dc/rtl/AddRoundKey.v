module AddRoundKey(data_in, key, data_out);
input[127:0] data_in, key;
output[127:0] data_out;

assign data_out = data_in ^ key;

endmodule