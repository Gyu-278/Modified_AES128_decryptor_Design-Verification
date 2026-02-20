module InvMixColumns(
    input clk,
    input rst,
    input [127:0] data_in,
    output [127:0] data_out
);

    //각 행렬 곱셉의 항을 저장할 128bit register 
    //결과값은 term_0 ^ term_1 ^ term_2 ^ term_3 로 계산
    reg [127:0] term_0;
    reg [127:0] term_1;
    reg [127:0] term_2;
    reg [127:0] term_3;
    // Galois Field (GF(2^8))에서의 곱셈 함수 function으로 정의 
    function [7:0] gmul;
        input [7:0] mi;
        input [7:0] mc;
        reg [14:0] tmp1;
        begin // bit 별 곱셈을 수행하여 중간값 tmp1생성 
            tmp1[14] = (mc[7] & mi[7]);
            tmp1[13] = (mc[6] & mi[7]) ^ (mc[7] & mi[6]);
            tmp1[12] = (mc[5] & mi[7]) ^ (mc[6] & mi[6]) ^ (mc[7] & mi[5]);
            tmp1[11] = (mc[4] & mi[7]) ^ (mc[5] & mi[6]) ^ (mc[6] & mi[5]) ^ (mc[7] & mi[4]);
            tmp1[10] = (mc[3] & mi[7]) ^ (mc[4] & mi[6]) ^ (mc[5] & mi[5]) ^ (mc[6] & mi[4]) ^ (mc[7] & mi[3]);
            tmp1[9]  = (mc[2] & mi[7]) ^ (mc[3] & mi[6]) ^ (mc[4] & mi[5]) ^ (mc[5] & mi[4]) ^ (mc[6] & mi[3]) ^ (mc[7] & mi[2]);
            tmp1[8]  = (mc[1] & mi[7]) ^ (mc[2] & mi[6]) ^ (mc[3] & mi[5]) ^ (mc[4] & mi[4]) ^ (mc[5] & mi[3]) ^ (mc[6] & mi[2]) ^ (mc[7] & mi[1]);
            tmp1[7]  = (mc[0] & mi[7]) ^ (mc[1] & mi[6]) ^ (mc[2] & mi[5]) ^ (mc[3] & mi[4]) ^ (mc[4] & mi[3]) ^ (mc[5] & mi[2]) ^ (mc[6] & mi[1]) ^ (mc[7] & mi[0]);
            tmp1[6]  = (mc[0] & mi[6]) ^ (mc[1] & mi[5]) ^ (mc[2] & mi[4]) ^ (mc[3] & mi[3]) ^ (mc[4] & mi[2]) ^ (mc[5] & mi[1]) ^ (mc[6] & mi[0]);
            tmp1[5]  = (mc[0] & mi[5]) ^ (mc[1] & mi[4]) ^ (mc[2] & mi[3]) ^ (mc[3] & mi[2]) ^ (mc[4] & mi[1]) ^ (mc[5] & mi[0]);
            tmp1[4]  = (mc[0] & mi[4]) ^ (mc[1] & mi[3]) ^ (mc[2] & mi[2]) ^ (mc[3] & mi[1]) ^ (mc[4] & mi[0]);
            tmp1[3]  = (mc[0] & mi[3]) ^ (mc[1] & mi[2]) ^ (mc[2] & mi[1]) ^ (mc[3] & mi[0]);
            tmp1[2]  = (mc[0] & mi[2]) ^ (mc[1] & mi[1]) ^ (mc[2] & mi[0]);
            tmp1[1]  = (mc[0] & mi[1]) ^ (mc[1] & mi[0]);
            tmp1[0]  = (mc[0] & mi[0]);
            //reducing polynomial 연산 
            gmul = tmp1[7:0] ^
                   ({8{tmp1[14]}} & 8'b1001_1010) ^
                   ({8{tmp1[13]}} & 8'b0100_1101) ^ ({8{tmp1[12]}} & 8'b1010_1011) ^
                   ({8{tmp1[11]}} & 8'b1101_1000) ^ ({8{tmp1[10]}} & 8'b0110_1100) ^
                   ({8{tmp1[ 9]}} & 8'b0011_0110) ^ ({8{tmp1[ 8]}} & 8'b0001_1011);
        end
    endfunction
    // clock의 rising edge에서 연산 수행 1 cycle 발생 
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            term_0 <= 128'd0;
            term_1 <= 128'd0;
            term_2 <= 128'd0;
            term_3 <= 128'd0;
        end else begin
            //Colunm 0연산 
            term_0[127:120] <= gmul(data_in[127:120], 8'h0E); term_1[127:120] <= gmul(data_in[119:112], 8'h0B); 
            term_2[127:120] <= gmul(data_in[111:104], 8'h0D); term_3[127:120] <= gmul(data_in[103:96],  8'h09);
            
         
            term_0[119:112] <= gmul(data_in[127:120], 8'h09); term_1[119:112] <= gmul(data_in[119:112], 8'h0E);
            term_2[119:112] <= gmul(data_in[111:104], 8'h0B); term_3[119:112] <= gmul(data_in[103:96],  8'h0D);
            
     
            term_0[111:104] <= gmul(data_in[127:120], 8'h0D); term_1[111:104] <= gmul(data_in[119:112], 8'h09);
            term_2[111:104] <= gmul(data_in[111:104], 8'h0E); term_3[111:104] <= gmul(data_in[103:96],  8'h0B);

        
            term_0[103:96]  <= gmul(data_in[127:120], 8'h0B); term_1[103:96]  <= gmul(data_in[119:112], 8'h0D);
            term_2[103:96]  <= gmul(data_in[111:104], 8'h09); term_3[103:96]  <= gmul(data_in[103:96],  8'h0E);
            //Colunm 1연산 
            term_0[95:88]   <= gmul(data_in[95:88],   8'h0E); term_1[95:88]   <= gmul(data_in[87:80],   8'h0B);
            term_2[95:88]   <= gmul(data_in[79:72],   8'h0D); term_3[95:88]   <= gmul(data_in[71:64],   8'h09);

   
            term_0[87:80]   <= gmul(data_in[95:88],   8'h09); term_1[87:80]   <= gmul(data_in[87:80],   8'h0E);
            term_2[87:80]   <= gmul(data_in[79:72],   8'h0B); term_3[87:80]   <= gmul(data_in[71:64],   8'h0D);

      
            term_0[79:72]   <= gmul(data_in[95:88],   8'h0D); term_1[79:72]   <= gmul(data_in[87:80],   8'h09);
            term_2[79:72]   <= gmul(data_in[79:72],   8'h0E); term_3[79:72]   <= gmul(data_in[71:64],   8'h0B);

   
            term_0[71:64]   <= gmul(data_in[95:88],   8'h0B); term_1[71:64]   <= gmul(data_in[87:80],   8'h0D);
            term_2[71:64]   <= gmul(data_in[79:72],   8'h09); term_3[71:64]   <= gmul(data_in[71:64],   8'h0E);

            //Colunm 2연산 
            term_0[63:56]   <= gmul(data_in[63:56],   8'h0E); term_1[63:56]   <= gmul(data_in[55:48],   8'h0B);
            term_2[63:56]   <= gmul(data_in[47:40],   8'h0D); term_3[63:56]   <= gmul(data_in[39:32],   8'h09);


            term_0[55:48]   <= gmul(data_in[63:56],   8'h09); term_1[55:48]   <= gmul(data_in[55:48],   8'h0E);
            term_2[55:48]   <= gmul(data_in[47:40],   8'h0B); term_3[55:48]   <= gmul(data_in[39:32],   8'h0D);

         
            term_0[47:40]   <= gmul(data_in[63:56],   8'h0D); term_1[47:40]   <= gmul(data_in[55:48],   8'h09);
            term_2[47:40]   <= gmul(data_in[47:40],   8'h0E); term_3[47:40]   <= gmul(data_in[39:32],   8'h0B);

        
            term_0[39:32]   <= gmul(data_in[63:56],   8'h0B); term_1[39:32]   <= gmul(data_in[55:48],   8'h0D);
            term_2[39:32]   <= gmul(data_in[47:40],   8'h09); term_3[39:32]   <= gmul(data_in[39:32],   8'h0E);

            //Colunm 3연산 
            term_0[31:24]   <= gmul(data_in[31:24],   8'h0E); term_1[31:24]   <= gmul(data_in[23:16],   8'h0B);
            term_2[31:24]   <= gmul(data_in[15:8],    8'h0D); term_3[31:24]   <= gmul(data_in[7:0],     8'h09);

 
            term_0[23:16]   <= gmul(data_in[31:24],   8'h09); term_1[23:16]   <= gmul(data_in[23:16],   8'h0E);
            term_2[23:16]   <= gmul(data_in[15:8],    8'h0B); term_3[23:16]   <= gmul(data_in[7:0],     8'h0D);

          
            term_0[15:8]    <= gmul(data_in[31:24],   8'h0D); term_1[15:8]    <= gmul(data_in[23:16],   8'h09);
            term_2[15:8]    <= gmul(data_in[15:8],    8'h0E); term_3[15:8]    <= gmul(data_in[7:0],     8'h0B);

 
            term_0[7:0]     <= gmul(data_in[31:24],   8'h0B); term_1[7:0]     <= gmul(data_in[23:16],   8'h0D);
            term_2[7:0]     <= gmul(data_in[15:8],    8'h09); term_3[7:0]     <= gmul(data_in[7:0],     8'h0E);
        end
    end
    //최종결과 연산 
    assign data_out = term_0 ^ term_1 ^ term_2 ^ term_3;

endmodule