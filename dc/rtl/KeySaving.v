module KeySaving(key10, key9, key8, key7, key6, key5, key4, key3, key2, key1, key0);
// KeySaving: AES decryptor의 필요한 모든 round key를 미리 생성하여 저장하는 역할
input [127:0] key10; // AES encryptor 과정의 가장 마지막 round key 

output [127:0] key9;
output [127:0] key8;
output [127:0] key7;
output [127:0] key6;
output [127:0] key5;
output [127:0] key4;
output [127:0] key3;
output [127:0] key2;
output [127:0] key1;
output [127:0] key0;

//InvKeyScheduler을 instance하여 Key9,key8...key0생성 
InvKeyScheduler key9_gen(8'h36, key10, key9); 
InvKeyScheduler key8_gen(8'h1B, key9, key8);  
InvKeyScheduler key7_gen(8'h80, key8, key7);
InvKeyScheduler key6_gen(8'h40, key7, key6);
InvKeyScheduler key5_gen(8'h20, key6, key5);
InvKeyScheduler key4_gen(8'h10, key5, key4);
InvKeyScheduler key3_gen(8'h08, key4, key3);
InvKeyScheduler key2_gen(8'h04, key3, key2);
InvKeyScheduler key1_gen(8'h02, key2, key1);
InvKeyScheduler key0_gen(8'h01, key1, key0);


endmodule

