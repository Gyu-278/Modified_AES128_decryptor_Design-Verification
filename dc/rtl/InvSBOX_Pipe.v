module InvSBOX_Pipe (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    // stage1 Look up table 단계 
    // 256개의 SBOX 데이터를 32개씩 9갸 그룹 (p0~p7)으로 병렬로 배치 32 
    // 입력의 하위 5bit(data_in[4:0])을 인데스로 사용하여 8개의 후보를 동시에 추출한다. 
    reg [7:0] p0, p1, p2, p3, p4, p5, p6, p7;
    reg [2:0] sel_s1, sel_s2;// pipe line stage별 데이터 동기화를 위한 선택 신호 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {p0,p1,p2,p3,p4,p5,p6,p7} <= 64'h0;
            sel_s1 <= 3'b0;
        end else begin
            sel_s1 <= data_in[7:5];
            // 하위 5비트 기반 32:1 Lookup Table
            // Group 0: 0x00 ~ 0x1F
            case (data_in[4:0])
                5'h00: p0<=8'h52; 5'h01: p0<=8'h09; 5'h02: p0<=8'h6a; 5'h03: p0<=8'hd5; 5'h04: p0<=8'h30; 5'h05: p0<=8'h36; 5'h06: p0<=8'ha5; 5'h07: p0<=8'h38;
                5'h08: p0<=8'hbf; 5'h09: p0<=8'h40; 5'h0a: p0<=8'ha3; 5'h0b: p0<=8'h9e; 5'h0c: p0<=8'h81; 5'h0d: p0<=8'hf3; 5'h0e: p0<=8'hd7; 5'h0f: p0<=8'hfb;
                5'h10: p0<=8'h7c; 5'h11: p0<=8'he3; 5'h12: p0<=8'h39; 5'h13: p0<=8'h82; 5'h14: p0<=8'h9b; 5'h15: p0<=8'h2f; 5'h16: p0<=8'hff; 5'h17: p0<=8'h87;
                5'h18: p0<=8'h34; 5'h19: p0<=8'h8e; 5'h1a: p0<=8'h43; 5'h1b: p0<=8'h44; 5'h1c: p0<=8'hc4; 5'h1d: p0<=8'hde; 5'h1e: p0<=8'he9; 5'h1f: p0<=8'hcb;
            endcase
            // Group 1: 0x20 ~ 0x3F
            case (data_in[4:0])
                5'h00: p1<=8'h54; 5'h01: p1<=8'h7b; 5'h02: p1<=8'h94; 5'h03: p1<=8'h32; 5'h04: p1<=8'ha6; 5'h05: p1<=8'hc2; 5'h06: p1<=8'h23; 5'h07: p1<=8'h3d;
                5'h08: p1<=8'hee; 5'h09: p1<=8'h4c; 5'h0a: p1<=8'h95; 5'h0b: p1<=8'h0b; 5'h0c: p1<=8'h42; 5'h0d: p1<=8'hfa; 5'h0e: p1<=8'hc3; 5'h0f: p1<=8'h4e;
                5'h10: p1<=8'h08; 5'h11: p1<=8'h2e; 5'h12: p1<=8'ha1; 5'h13: p1<=8'h66; 5'h14: p1<=8'h28; 5'h15: p1<=8'hd9; 5'h16: p1<=8'h24; 5'h17: p1<=8'hb2;
                5'h18: p1<=8'h76; 5'h19: p1<=8'h5b; 5'h1a: p1<=8'ha2; 5'h1b: p1<=8'h49; 5'h1c: p1<=8'h6d; 5'h1d: p1<=8'h8b; 5'h1e: p1<=8'hd1; 5'h1f: p1<=8'h25;
            endcase
            // Group 2: 0x40 ~ 0x5F
            case (data_in[4:0])
                5'h00: p2<=8'h72; 5'h01: p2<=8'hf8; 5'h02: p2<=8'hf6; 5'h03: p2<=8'h64; 5'h04: p2<=8'h86; 5'h05: p2<=8'h68; 5'h06: p2<=8'h98; 5'h07: p2<=8'h16;
                5'h08: p2<=8'hd4; 5'h09: p2<=8'ha4; 5'h0a: p2<=8'h5c; 5'h0b: p2<=8'hcc; 5'h0c: p2<=8'h5d; 5'h0d: p2<=8'h65; 5'h0e: p2<=8'hb6; 5'h0f: p2<=8'h92;
                5'h10: p2<=8'h6c; 5'h11: p2<=8'h70; 5'h12: p2<=8'h48; 5'h13: p2<=8'h50; 5'h14: p2<=8'hfd; 5'h15: p2<=8'hed; 5'h16: p2<=8'hb9; 5'h17: p2<=8'hda;
                5'h18: p2<=8'h5e; 5'h19: p2<=8'h15; 5'h1a: p2<=8'h46; 5'h1b: p2<=8'h57; 5'h1c: p2<=8'ha7; 5'h1d: p2<=8'h8d; 5'h1e: p2<=8'h9d; 5'h1f: p2<=8'h84;
            endcase
            // Group 3: 0x60 ~ 0x7F
            case (data_in[4:0])
                5'h00: p3<=8'h90; 5'h01: p3<=8'hd8; 5'h02: p3<=8'hab; 5'h03: p3<=8'h00; 5'h04: p3<=8'h8c; 5'h05: p3<=8'hbc; 5'h06: p3<=8'hd3; 5'h07: p3<=8'h0a;
                5'h08: p3<=8'hf7; 5'h09: p3<=8'he4; 5'h0a: p3<=8'h58; 5'h0b: p3<=8'h05; 5'h0c: p3<=8'hb8; 5'h0d: p3<=8'hb3; 5'h0e: p3<=8'h45; 5'h0f: p3<=8'h06;
                5'h10: p3<=8'hd0; 5'h11: p3<=8'h2c; 5'h12: p3<=8'h1e; 5'h13: p3<=8'h8f; 5'h14: p3<=8'hca; 5'h15: p3<=8'h3f; 5'h16: p3<=8'h0f; 5'h17: p3<=8'h02;
                5'h18: p3<=8'hc1; 5'h19: p3<=8'haf; 5'h1a: p3<=8'hbd; 5'h1b: p3<=8'h03; 5'h1c: p3<=8'h01; 5'h1d: p3<=8'h13; 5'h1e: p3<=8'h8a; 5'h1f: p3<=8'h6b;
            endcase
            // Group 4: 0x80 ~ 0x9F
            case (data_in[4:0])
                5'h00: p4<=8'h3a; 5'h01: p4<=8'h91; 5'h02: p4<=8'h11; 5'h03: p4<=8'h41; 5'h04: p4<=8'h4f; 5'h05: p4<=8'h67; 5'h06: p4<=8'hdc; 5'h07: p4<=8'hea;
                5'h08: p4<=8'h97; 5'h09: p4<=8'hf2; 5'h0a: p4<=8'hcf; 5'h0b: p4<=8'hce; 5'h0c: p4<=8'hf0; 5'h0d: p4<=8'hb4; 5'h0e: p4<=8'he6; 5'h0f: p4<=8'h73;
                5'h10: p4<=8'h96; 5'h11: p4<=8'hac; 5'h12: p4<=8'h74; 5'h13: p4<=8'h22; 5'h14: p4<=8'he7; 5'h15: p4<=8'had; 5'h16: p4<=8'h35; 5'h17: p4<=8'h85;
                5'h18: p4<=8'he2; 5'h19: p4<=8'hf9; 5'h1a: p4<=8'h37; 5'h1b: p4<=8'he8; 5'h1c: p4<=8'h1c; 5'h1d: p4<=8'h75; 5'h1e: p4<=8'hdf; 5'h1f: p4<=8'h6e;
            endcase
            // Group 5: 0xA0 ~ 0xBF
            case (data_in[4:0])
                5'h00: p5<=8'h47; 5'h01: p5<=8'hf1; 5'h02: p5<=8'h1a; 5'h03: p5<=8'h71; 5'h04: p5<=8'h1d; 5'h05: p5<=8'h29; 5'h06: p5<=8'hc5; 5'h07: p5<=8'h89;
                5'h08: p5<=8'h6f; 5'h09: p5<=8'hb7; 5'h0a: p5<=8'h62; 5'h0b: p5<=8'h0e; 5'h0c: p5<=8'haa; 5'h0d: p5<=8'h18; 5'h0e: p5<=8'hbe; 5'h0f: p5<=8'h1b;
                5'h10: p5<=8'hfc; 5'h11: p5<=8'h56; 5'h12: p5<=8'h3e; 5'h13: p5<=8'h4b; 5'h14: p5<=8'hc6; 5'h15: p5<=8'hd2; 5'h16: p5<=8'h79; 5'h17: p5<=8'h20;
                5'h18: p5<=8'h9a; 5'h19: p5<=8'hdb; 5'h1a: p5<=8'hc0; 5'h1b: p5<=8'hfe; 5'h1c: p5<=8'h78; 5'h1d: p5<=8'hcd; 5'h1e: p5<=8'h5a; 5'h1f: p5<=8'hf4;
            endcase
            // Group 6: 0xC0 ~ 0xDF
            case (data_in[4:0])
                5'h00: p6<=8'h1f; 5'h01: p6<=8'hdd; 5'h02: p6<=8'ha8; 5'h03: p6<=8'h33; 5'h04: p6<=8'h88; 5'h05: p6<=8'h07; 5'h06: p6<=8'hc7; 5'h07: p6<=8'h31;
                5'h08: p6<=8'hb1; 5'h09: p6<=8'h12; 5'h0a: p6<=8'h10; 5'h0b: p6<=8'h59; 5'h0c: p6<=8'h27; 5'h0d: p6<=8'h80; 5'h0e: p6<=8'hec; 5'h0f: p6<=8'h5f;
                5'h10: p6<=8'h60; 5'h11: p6<=8'h51; 5'h12: p6<=8'h7f; 5'h13: p6<=8'ha9; 5'h14: p6<=8'h19; 5'h15: p6<=8'hb5; 5'h16: p6<=8'h4a; 5'h17: p6<=8'h0d;
                5'h18: p6<=8'h2d; 5'h19: p6<=8'he5; 5'h1a: p6<=8'h7a; 5'h1b: p6<=8'h9f; 5'h1c: p6<=8'h93; 5'h1d: p6<=8'hc9; 5'h1e: p6<=8'h9c; 5'h1f: p6<=8'hef;
            endcase
            // Group 7: 0xE0 ~ 0xFF
            case (data_in[4:0])
                5'h00: p7<=8'ha0; 5'h01: p7<=8'he0; 5'h02: p7<=8'h3b; 5'h03: p7<=8'h4d; 5'h04: p7<=8'hae; 5'h05: p7<=8'h2a; 5'h06: p7<=8'hf5; 5'h07: p7<=8'hb0;
                5'h08: p7<=8'hc8; 5'h09: p7<=8'heb; 5'h0a: p7<=8'hbb; 5'h0b: p7<=8'h3c; 
                5'h0c: p7<=8'h83; 
                5'h0d: p7<=8'h53; 
                5'h0e: p7<=8'h99; 5'h0f: p7<=8'h61;
                5'h10: p7<=8'h17; 5'h11: p7<=8'h2b; 5'h12: p7<=8'h04; 5'h13: p7<=8'h7e; 5'h14: p7<=8'hba; 5'h15: p7<=8'h77; 5'h16: p7<=8'hd6; 5'h17: p7<=8'h26;
                5'h18: p7<=8'he1; 5'h19: p7<=8'h69; 5'h1a: p7<=8'h14; 5'h1b: p7<=8'h63; 5'h1c: p7<=8'h55; 5'h1d: p7<=8'h21; 5'h1e: p7<=8'h0c; 5'h1f: p7<=8'h7d;
            endcase
        end
    end
    //Stage 2 4-to-1 Mux 
    // 32-to-1 Mux에서 나온 8개의 그룹중에서 4개씩 묶어서 두 그룹 (low, high)으로 배치합니다. 
    reg [7:0] mid_low, mid_high;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mid_low <= 8'h0; mid_high <= 8'h0; sel_s2 <= 3'b0;
        end else begin
            //stage 1의 sel_s1을 stage 2 sel_s2로 전달하여 
            sel_s2 <= sel_s1;
            // sel_s1[1:0] 비트를 이용해 p0~p3 중 하나를 선택하여 mid_low 생성
            mid_low  <= (sel_s1[1]) ? (sel_s1[0] ? p3 : p2) : (sel_s1[0] ? p1 : p0);
            // sel_s1[1:0] 비트를 이용해 p4~p7 중 하나를 선택하여 mid_high 생성
            mid_high <= (sel_s1[1]) ? (sel_s1[0] ? p7 : p6) : (sel_s1[0] ? p5 : p4);
        end
    end
    //stage 3 2-to-1 Mux 
    // low, high 그룹 중에서 MSB (data_in[7])의 정보를 담은 
    // sel_s2[2] 비트를 사용하여 최종 결과값을 결정하고 data_out으로 출력한다. 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'h0;
        end else begin
            data_out <= (sel_s2[2]) ? mid_high : mid_low;
        end
    end

endmodule