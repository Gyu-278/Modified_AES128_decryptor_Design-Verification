`timescale 1ns / 1ps
module tb_TOP;
localparam integer NUM_BLOCKS       = 24; //  #line of cipher_out_6.txt
localparam integer NUM_KEYS         = 27; // # number of key in key10.txt
localparam integer TEAM             = 6;  // Team number
localparam integer PIPELINE_LATENCY = 59;// 59 cycle 

reg  clk;
reg  rst;   // Active Low Reset
reg  [127:0] ciphertext;
reg  [127:0] key10;
wire [127:0] plaintext;

reg [127:0] cipher_mem [0:NUM_BLOCKS-1]; 
reg [127:0] key10_mem  [0:NUM_KEYS-1];   
reg [127:0] plain_exp  [0:NUM_BLOCKS-1]; 
reg [127:0] key10_fixed;                 

integer i, idx;
integer out_file; 

TOPpipelined dut(
    .ciphertext (ciphertext),
    .key10      (key10),
    .rst        (rst),
    .clk        (clk),
    .plaintext  (plaintext)

); 
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
initial begin
        clk = 1'b0; //10ns period 
        forever #5 clk = ~clk; 
    end
initial begin
        
        rst        = 1'b0;
        ciphertext = 128'd0;
        key10      = 128'd0;

        
        $readmemh("cipher_out_6.txt", cipher_mem); 
        $readmemh("key10.txt",        key10_mem);

        
        out_file = $fopen("decrypted.txt", "w");
        if (out_file == 0) begin
            $display("Error: Could not open output file 'decrypted.txt'");
            $finish;
        end

        
        key10_fixed = key10_mem[TEAM-1];
        $display("------------------------------------------------");
        $display("START SIMULATION | TEAM=%0d | Key10=%h", TEAM, key10_fixed);
        $display("------------------------------------------------");

    
        @(negedge clk);
        rst = 1'b0; // Active Low Reset
        @(negedge clk);
        rst = 1'b1; // Reset Release (Start)

        for (i = 0; i < NUM_BLOCKS + PIPELINE_LATENCY; i = i + 1) begin
            
            @(negedge clk); 

           
            if (i < NUM_BLOCKS) begin
                ciphertext = cipher_mem[i];
                key10      = key10_fixed;
                // $display("IN [%0d]: Cipher=%h", i, ciphertext);
            end else begin
               
                ciphertext = 128'd0;
                key10      = key10_fixed;
            end

            // --- [Output Stage]
            if (i >= PIPELINE_LATENCY) begin
                idx = i - PIPELINE_LATENCY; 

                if (idx < NUM_BLOCKS) begin
                    //hextoasci.sh 
                    $fwrite(out_file, "%h\n", plaintext);

                    //  (Self-Checking)
                    if (plaintext !== plain_exp[idx]) begin
                        $display("[Mismatch] Time=%0t | Idx=%0d | Out=%h | Exp=%h", 
                                 $time, idx, plaintext, plain_exp[idx]);
                    end else begin
                        $display("[OK]       Time=%0t | Idx=%0d | Out=%h", 
                                 $time, idx, plaintext);
                    end
                end
            end
        end
        
        
        $fclose(out_file);
        $display("------------------------------------------------");
        $display("SIMULATION DONE. 'decrypted.txt' generated.");
        $display("------------------------------------------------");
        $finish;
    end
endmodule