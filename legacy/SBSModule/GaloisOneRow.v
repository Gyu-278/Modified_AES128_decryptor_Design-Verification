module GaloisOneRow(in_row, in_data, out_row);

input[31:0] in_row;
input[127:0] in_data;
output[31:0] out_row;

GaloisOneElement first(in_row, in_data[127:96], out_row[31:24]); // 1st element of row
GaloisOneElement second(in_row, in_data[95:64], out_row[23:16]); // 2nd element of row
GaloisOneElement third(in_row, in_data[63:32], out_row[15:8]); // 3rd element of row
GaloisOneElement fourth(in_row, in_data[31:0], out_row[7:0]); // 4th element of row

endmodule