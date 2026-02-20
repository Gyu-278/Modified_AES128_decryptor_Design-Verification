module Round1to10(clk, rst, round_input, key, roundkey_output);

    input clk, rst; 
    input [127:0] round_input, key;
    output [127:0] roundkey_output;

    wire [127:0] shiftrow_output, subbytes_output;
    
    //InvSubBytes 연산이 3사이클 소요됨에따라, Key값도 3사이클 뒤에 데이터를 만나도록 지연시킨다. 
    reg [127:0] key_d1, key_d2, key_d3;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            key_d1 <= 128'd0;
            key_d2 <= 128'd0;
            key_d3 <= 128'd0;
        end else begin
            key_d1 <= key;    // Stage 1
            key_d2 <= key_d1; // Stage 2
            key_d3 <= key_d2; // Stage 3 
        end
    end

    // 1. InvShiftRows 연산
    InvShiftRows invshiftrows(round_input, shiftrow_output);

    // 2. InvSubBytes 연산 3-stage 파이프라인 (3-cycle)
    InvSubBytes invsubbytes(clk, rst, shiftrow_output, subbytes_output);

    // 3. AddRoundKey: 데이터와 지연된 키를 XOR 연산 
    AddRoundKey addroundkey(subbytes_output, key_d3, roundkey_output);

endmodule