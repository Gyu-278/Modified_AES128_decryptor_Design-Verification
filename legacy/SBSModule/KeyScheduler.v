//key scheduler
//w3= key_in [31:0]
//column major OK

module KeyScheduler (rcon, key_in, key_out);

//input clk,rst;

input [7:0] rcon; //parameter in top module
input [127:0] key_in;
output [127:0] key_out;


//reg [] cnt;
wire [31:0] tmp;

/*RotWord + SBOX*/
SBOX s1 (.data_in(key_in[31-:8]), .data_out(tmp[7-:8]));
SBOX s2 (.data_in(key_in[23-:8]), .data_out(tmp[31-:8]));
SBOX s3 (.data_in(key_in[15-:8]), .data_out(tmp[23-:8]));
SBOX s4 (.data_in(key_in[7-:8]), .data_out(tmp[15-:8]));

/*XORs*/
assign key_out[127-:32] = tmp ^ {rcon,24'd0} ^ key_in [127-:32];//w4
assign key_out[95-:32] =  key_out[127-:32]^ key_in [95-:32];//w5
assign key_out[63-:32] =  key_out[95-:32]^ key_in [63-:32];//w6
assign key_out[31-:32] =  key_out[63-:32]^ key_in [31-:32];//w7

/* always @(posedge clk or negedge rst) begin


	if (!rst) begin
		
	end
	
	else begin
		//{key_in[23-:8],key_in[15-:8],key_in[7-:8],key_in [31-:8]}
		
	end

end */



endmodule