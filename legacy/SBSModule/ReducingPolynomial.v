module ReducingPolynomial(mc, mi, reduced);

input [7:0] mc,mi; 
wire[14:0] tmp1;
output [7:0] reduced; 

assign tmp1[14] = mc[7] & mi[7] ; //c14=a7b7
assign tmp1[13] = (mc[6] & mi[7]) ^ (mc[7]&mi[6]);
assign tmp1[12] = (mc[5]&mi[7]) ^ (mc[6]&mi[6]) ^ (mc[7]&mi[5]) ;
assign tmp1[11] = (mc[4]&mi[7]) ^ (mc[5]&mi[6]) ^ (mc[6]&mi[5]) ^ (mc[7]&mi[4]) ;
assign tmp1[10] = (mc[3]&mi[7]) ^ (mc[4]&mi[6]) ^ (mc[5]&mi[5]) ^ (mc[6]&mi[4]) ^ (mc[7]&mi[3]) ;
assign tmp1[9] = (mc[2]&mi[7]) ^ (mc[3]&mi[6]) ^ (mc[4]&mi[5]) ^ (mc[5]&mi[4]) ^ (mc[6]&mi[3]) ^ (mc[7]&mi[2]);
assign tmp1[8] = (mc[1]&mi[7]) ^ (mc[2]&mi[6]) ^ (mc[3]&mi[5]) ^ (mc[4]&mi[4]) ^ (mc[5]&mi[3]) ^ (mc[6]&mi[2]) ^ (mc[7]&mi[1]); 

assign tmp1[7] =(mc[0]&mi[7]) ^(mc[1]&mi[6]) ^(mc[2]&mi[5]) ^(mc[3]&mi[4]) ^(mc[4]&mi[3]) ^(mc[5]&mi[2]) ^(mc[6]&mi[1]) ^(mc[7]&mi[0]);
assign tmp1[6] =(mc[0]&mi[6]) ^(mc[1]&mi[5]) ^(mc[2]&mi[4]) ^(mc[3]&mi[3]) ^(mc[4]&mi[2]) ^(mc[5]&mi[1]) ^(mc[6]&mi[0]);
assign tmp1[5] =(mc[0]&mi[5]) ^(mc[1]&mi[4]) ^(mc[2]&mi[3]) ^(mc[3]&mi[2]) ^(mc[4]&mi[1]) ^(mc[5]&mi[0]);
assign tmp1[4] =(mc[0]&mi[4]) ^(mc[1]&mi[3]) ^(mc[2]&mi[2]) ^(mc[3]&mi[1]) ^(mc[4]&mi[0]);
assign tmp1[3] =(mc[0]&mi[3]) ^(mc[1]&mi[2]) ^(mc[2]&mi[1]) ^(mc[3]&mi[0]);
assign tmp1[2] =(mc[0]&mi[2]) ^(mc[1]&mi[1]) ^(mc[2]&mi[0]);
assign tmp1[1] =(mc[0]&mi[1]) ^(mc[1]&mi[0]);
assign tmp1[0] =(mc[0]&mi[0]);//c0




assign reduced = tmp1[7:0] ^ ({8{tmp1[14]}} & 8'b1001_1010 ) ^ ({8{tmp1[13]}} & 8'b0100_1101 ) ^ ({8{tmp1[12]}} & 8'b1010_1011 ) ^ ( {8{tmp1[11]}}& 8'b1101_1000 ) ^ ( {8{tmp1[10]}}& 8'b0110_1100 ) ^ ( {8{tmp1[9]}}& 8'b0011_0110 ) ^ ( {8{tmp1[8]}}& 8'b0001_1011 );

endmodule