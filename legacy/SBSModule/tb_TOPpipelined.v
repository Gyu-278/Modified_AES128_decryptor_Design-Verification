`timescale 1ns / 1ps

module tb_TOPpipelined;

    // -----------------------------
    // ????
    // -----------------------------
    localparam integer NUM_BLOCKS        = 24; // cipher_out_6.txt ?? ?
    localparam integer NUM_KEYS         = 27; // key10.txt ?? ?
    localparam integer TEAM             = 6;  // 6? -> 6?? ? ??
    localparam integer PIPELINE_LATENCY = 20; // TOPpipelined ????? ???

    // DUT ??
    reg         clk;
    reg         rst;          // TOP ???? !rst ? reset ??
    reg  [127:0] ciphertext;
    reg  [127:0] key10;
    wire [127:0] plaintext;

    // DUT ????
    TOPpipelined dut (
        .ciphertext (ciphertext),
        .key10      (key10),
        .rst        (rst),
        .clk        (clk),
        .plaintext  (plaintext)
    );

    // ???? ??? ???
    reg [127:0] cipher_mem [0:NUM_BLOCKS-1];
    reg [127:0] key10_mem   [0:NUM_KEYS-1];

    // ???? ?? (Moore's law ?? 24??)
    reg [127:0] plain_exp   [0:NUM_BLOCKS-1];

    // TEAM ?? key10
    reg [127:0] key10_fixed;

    integer i;
    integer idx;

    // -----------------------------
    // ?? ?? ???
    // -----------------------------
    initial begin
        plain_exp[0]  = 128'h54686500636f6d706c65786974790066;
        plain_exp[1]  = 128'h6f72006d696e696d756d00636f6d706f;
        plain_exp[2]  = 128'h6e656e7400636f737473006861730069;
        plain_exp[3]  = 128'h6e637265617365640061740061007261;
        plain_exp[4]  = 128'h7465006f6600726f7567686c79006100;
        plain_exp[5]  = 128'h666163746f72006f660074776f007065;
        plain_exp[6]  = 128'h7200796561722e004365727461696e6c;
        plain_exp[7]  = 128'h79006f766572007468650073686f7274;
        plain_exp[8]  = 128'h7465726d007468697300726174650000;
        plain_exp[9]  = 128'h63616e00626500657870656374656400;
        plain_exp[10] = 128'h746f00636f6e74696e75652c00696600;
        plain_exp[11] = 128'h6e6f7400746f00696e6372656173652e;
        plain_exp[12] = 128'h4f76657200746865006c6f6e67657200;
        plain_exp[13] = 128'h7465726d2c0074686500726174650000;
        plain_exp[14] = 128'h6f6600696e6372656173650069730061;
        plain_exp[15] = 128'h626974006d6f726500756e6365727400;
        plain_exp[16] = 128'h61696e2c00616c74686f756768007468;
        plain_exp[17] = 128'h657265006973006e6f00726561736f6e;
        plain_exp[18] = 128'h746f0062656c69657665006974007700;
        plain_exp[19] = 128'h696c6c006e6f740072656d61696e006e;
        plain_exp[20] = 128'h6561726c7900636f6e7374616e740066;
        plain_exp[21] = 128'h6f72006174006c656173740031300079;
        plain_exp[22] = 128'h656172732e002d4d6f6f72652773006c;
        plain_exp[23] = 128'h61770000000000000000000000000000;
    end

    // -----------------------------
    // ?? ??
    // -----------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 10ns period
    end

    // -----------------------------
    // ?? ???
    // -----------------------------
    initial begin
        // ???
        rst        = 1'b0;   // active-low reset
        ciphertext = 128'd0;
        key10      = 128'd0;

        // ???? ??? ??
        // ????? ?? ?????
        // cipher_out_6.txt, key10.txt ??? ?
        $readmemh("cipher_out_6.txt", cipher_mem);
        $readmemh("key10.txt",        key10_mem);

        // TEAM ?? ? key10 ?? (6? ? key10_mem[5])
        key10_fixed = key10_mem[TEAM-1];

        $display("TEAM=%0d, key10 = %032h", TEAM, key10_fixed);

        // reset ? ??? ??
        @(negedge clk);
        rst = 1'b0;
        @(negedge clk);
        rst = 1'b1; // reset ??

        // -------------------------
        // ciphertext ?? + ?? ??
        // -------------------------
        // ? NUM_BLOCKS ?? ??,
        // ????? ????? ? ??? ??
        for (i = 0; i < NUM_BLOCKS + PIPELINE_LATENCY; i = i + 1) begin
            @(negedge clk);

            // ?? ??
            if (i < NUM_BLOCKS) begin
                ciphertext = cipher_mem[i];
                key10      = key10_fixed;
                $display("TIME=%0t ns | FEED i=%0d | CIPHER=%032h",
                         $time, i, ciphertext);
            end else begin
                // ??? ???? ?? 0??
                ciphertext = 128'd0;
                key10      = key10_fixed;
            end

            // ?? ?? (??? ??)
            if (i >= PIPELINE_LATENCY) begin
                idx = i - PIPELINE_LATENCY;
                if (idx < NUM_BLOCKS) begin
                    if (plaintext !== plain_exp[idx]) begin
                        $display("TIME=%0t ns | OUT idx=%0d | PLAIN=%032h | EXPECT=%032h  **MISMATCH**",
                                 $time, idx, plaintext, plain_exp[idx]);
                    end else begin
                        $display("TIME=%0t ns | OUT idx=%0d | PLAIN=%032h  [OK]",
                                 $time, idx, plaintext);
                    end
                end
            end
        end

        $finish;
    end

endmodule
