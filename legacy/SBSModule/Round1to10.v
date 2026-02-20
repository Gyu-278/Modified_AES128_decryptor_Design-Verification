module Round1to10(round_input, key, roundkey_output);

input[127:0] round_input, key;
output[127:0] roundkey_output;

wire[127:0] shiftrow_output, subbytes_output;

InvShiftRows invshiftrows(round_input, shiftrow_output);
InvSubBytes invsubbytes(shiftrow_output, subbytes_output);
AddRoundKey addroundkey(subbytes_output, key, roundkey_output);

endmodule