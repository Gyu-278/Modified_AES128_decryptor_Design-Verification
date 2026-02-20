module GaloisOneElement(in_row, data_column, out_element);

input[31:0] in_row;
input[31:0] data_column;
output[7:0] out_element;

wire[7:0] tmp1, tmp2, tmp3, tmp4;
ReducingPolynomial first(in_row[31:24], data_column[31:24], tmp1);
ReducingPolynomial second(in_row[23:16], data_column[23:16], tmp2);
ReducingPolynomial third(in_row[15:8], data_column[15:8], tmp3);
ReducingPolynomial fourth(in_row[7:0], data_column[7:0], tmp4);

assign out_element = (tmp1 ^ tmp2) ^ (tmp3 ^ tmp4);

endmodule