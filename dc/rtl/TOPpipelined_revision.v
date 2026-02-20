module TOPpipelined(ciphertext, key10, rst, clk, plaintext);

    input [127:0] ciphertext, key10;
    input rst, clk;
    output [127:0] plaintext;

    // Round Keys (Key10 -> Key0) 
    wire [127:0] key9, key8, key7, key6, key5, key4, key3, key2, key1, key0;
    KeySaving keysaving(key10, key9, key8, key7, key6, key5, key4, key3, key2, key1, key0);

    // Intermediate Wires 
    wire [127:0] preround_result;
    wire [127:0] round1, round2, round3, round4, round5, round6, round7, round8, round9, round10;
    wire [127:0] round1_1, round2_1, round3_1, round4_1, round5_1, round6_1, round7_1, round8_1, round9_1;

    // Pipeline Registers 
    reg [127:0] preround_reg;
    reg [127:0] round1_reg, round2_reg, round3_reg, round4_reg, round5_reg, round6_reg, round7_reg, round8_reg, round9_reg;
    reg [127:0] round1_1_reg, round2_1_reg, round3_1_reg, round4_1_reg, round5_1_reg, round6_1_reg, round7_1_reg, round8_1_reg, round9_1_reg;
    reg [127:0] round10_reg;

    // Decryption Flow 

    // Pre-Round: AddRoundKey 
    AddRoundKey initial_ark(ciphertext, key10, preround_result);

    // Round 1 
    Round1to10 r1(clk, rst, preround_reg, key9, round1);
    InvMixColumns r1_1(.clk(clk), .rst(rst), .data_in(round1_reg), .data_out(round1_1));

    // Round 2 
    Round1to10 r2(clk, rst, round1_1_reg, key8, round2);
    InvMixColumns r2_1(.clk(clk), .rst(rst), .data_in(round2_reg), .data_out(round2_1));

    // Round 3 
    Round1to10 r3(clk, rst, round2_1_reg, key7, round3);
    InvMixColumns r3_1(.clk(clk), .rst(rst), .data_in(round3_reg), .data_out(round3_1));

    // Round 4 
    Round1to10 r4(clk, rst, round3_1_reg, key6, round4);
    InvMixColumns r4_1(.clk(clk), .rst(rst), .data_in(round4_reg), .data_out(round4_1));

    // Round 5 
    Round1to10 r5(clk, rst, round4_1_reg, key5, round5);
    InvMixColumns r5_1(.clk(clk), .rst(rst), .data_in(round5_reg), .data_out(round5_1));

    // Round 6 
    Round1to10 r6(clk, rst, round5_1_reg, key4, round6);
    InvMixColumns r6_1(.clk(clk), .rst(rst), .data_in(round6_reg), .data_out(round6_1));

    // Round 7 
    Round1to10 r7(clk, rst, round6_1_reg, key3, round7);
    InvMixColumns r7_1(.clk(clk), .rst(rst), .data_in(round7_reg), .data_out(round7_1));

    // Round 8 
    Round1to10 r8(clk, rst, round7_1_reg, key2, round8);
    InvMixColumns r8_1(.clk(clk), .rst(rst), .data_in(round8_reg), .data_out(round8_1));

    // Round 9 
    Round1to10 r9(clk, rst, round8_1_reg, key1, round9);
    InvMixColumns r9_1(.clk(clk), .rst(rst), .data_in(round9_reg), .data_out(round9_1));

    // Round 10: No MixColumns 
    Round1to10 r10(clk, rst, round9_1_reg, key0, round10);

    // Pipeline Register Update Logic 
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            preround_reg <= 0;
            round1_reg <= 0;  round1_1_reg <= 0;
            round2_reg <= 0;  round2_1_reg <= 0;
            round3_reg <= 0;  round3_1_reg <= 0;
            round4_reg <= 0;  round4_1_reg <= 0;
            round5_reg <= 0;  round5_1_reg <= 0;
            round6_reg <= 0;  round6_1_reg <= 0;
            round7_reg <= 0;  round7_1_reg <= 0;
            round8_reg <= 0;  round8_1_reg <= 0;
            round9_reg <= 0;  round9_1_reg <= 0;
            round10_reg <= 0;
        end else begin
            preround_reg <= preround_result;
            round1_reg   <= round1;   round1_1_reg <= round1_1;
            round2_reg   <= round2;   round2_1_reg <= round2_1;
            round3_reg   <= round3;   round3_1_reg <= round3_1;
            round4_reg   <= round4;   round4_1_reg <= round4_1;
            round5_reg   <= round5;   round5_1_reg <= round5_1;
            round6_reg   <= round6;   round6_1_reg <= round6_1;
            round7_reg   <= round7;   round7_1_reg <= round7_1;
            round8_reg   <= round8;   round8_1_reg <= round8_1;
            round9_reg   <= round9;   round9_1_reg <= round9_1;
            round10_reg  <= round10;
        end
    end

    assign plaintext = round10_reg; // 최종 출력 

endmodule