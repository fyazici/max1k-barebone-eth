`default_nettype none

module top(
   // CLOCKS
   input CLK12M,
   output [7:0] PIO,
   output [7:0] LED
);

    // eth clocks
    wire clk25;
    wire clk125;
    
    ethclk ethclk_inst (
        .areset(1'b0),
        .inclk0(CLK12M),
        .c0(clk25),
        .c1(clk125),
        .locked(LED[7])
    );
    
    // reset mgr
    wire rst;
    reg [31:0] reset_ctr;
    initial reset_ctr = 32'd100;
    always @(posedge clk25) if (reset_ctr > 0) reset_ctr <= reset_ctr - 1;
    assign rst = |reset_ctr;
    
    // frame send interval counter
    wire send_stb;
    localparam SEND_RELOAD = 32'd25000000;
    reg [31:0] send_ctr;
    always @(posedge clk25) begin
        if (rst) begin
            send_ctr <= SEND_RELOAD;
        end
        else begin
            if (send_ctr == 0) begin
                send_ctr <= SEND_RELOAD;
            end
            else begin
                send_ctr <= send_ctr - 1;
            end
        end
    end
    assign send_stb = ~|send_ctr;
    
    // frame bit stream
    localparam ETH_LENGTH_NIBBLES = 144;
    reg [15:0] eth_addr;
    reg [7:0] eth_mem [1500:0];
    reg [3:0] eth_nibble;
    initial begin
        $readmemh("eth_frame.txt", eth_mem);
    end
    always @(posedge clk25) begin
        eth_nibble <= eth_addr[0] ? eth_mem[eth_addr[15:1]][7:4] : eth_mem[eth_addr[15:1]][3:0];
    end
    
    // 100base-tx state machine
    reg [4:0] fiveb_out;
    localparam SYM_I = 5'b11111, SYM_J = 5'b11000, SYM_K = 5'b10001, SYM_T = 5'b01101, SYM_R = 5'b00111;
    reg [3:0] tx_state;
    reg [4:0] gap_ctr;
    localparam 
        S_tx_idle = 0, 
        S_tx_st_1 = 1, 
        S_tx_st_2 = 2, 
        S_tx_data = 3, 
        S_tx_end_1 = 4, 
        S_tx_end_2 = 5;
    
    always @(posedge clk25) begin
        if (rst) begin
            tx_state <= S_tx_idle;
            eth_addr <= 0;
            gap_ctr <= 0;
        end
        else begin
            case (tx_state)
                S_tx_idle: begin
                    if (gap_ctr != 23) gap_ctr <= gap_ctr + 1;
                    else if (send_stb) tx_state <= S_tx_st_1;
                end
                S_tx_st_1: begin
                    tx_state <= S_tx_st_2;
                    eth_addr <= 2;
                end
                S_tx_st_2: begin
                    tx_state <= S_tx_data;
                    eth_addr <= 3;
                end
                S_tx_data: begin
                    if (eth_addr < (ETH_LENGTH_NIBBLES + 1)) eth_addr <= eth_addr + 1;
                    else tx_state <= S_tx_end_1;
                end
                S_tx_end_1: begin
                    tx_state <= S_tx_end_2;
                end
                S_tx_end_2: begin
                    tx_state <= S_tx_idle;
                    gap_ctr <= 0;
                end
            endcase
        end
    end
    
    always @(*) begin
        case (tx_state)
            S_tx_idle: fiveb_out = SYM_I;
            S_tx_st_1: fiveb_out = SYM_J;
            S_tx_st_2: fiveb_out = SYM_K;
            S_tx_data: fiveb_out = encode_4b5b(eth_nibble);
            S_tx_end_1: fiveb_out = SYM_T;
            S_tx_end_2: fiveb_out = SYM_R;
        endcase
    end
    
    // lfsr 
    reg [10:0] lfsr;
    
    always @(posedge clk125) begin
        if (rst) begin
            lfsr <= {11{1'b1}};
        end
        else begin
            lfsr <= {lfsr[9:0], lfsr[8] ^ lfsr[10]};
        end
    end
    
    // mlt-3
    reg [4:0] fiveb_r;
    reg [2:0] serdes_ctr;
    reg [1:0] mlt_ctr;
    
    // clock domains are edge sync'd, no cdc needed
    always @(posedge clk125) begin
        if (rst) begin
            mlt_ctr <= 2'b00;
            serdes_ctr <= 0;
        end
        else begin
            if (serdes_ctr == 4) begin
                serdes_ctr <= 0;
                fiveb_r <= fiveb_out;
            end
            else begin
                serdes_ctr <= serdes_ctr + 1;
                fiveb_r <= {fiveb_r[3:0], 1'b0};
            end
            mlt_ctr <= mlt_ctr + (lfsr[0] ^ fiveb_r[4]);
        end
    end
    
    reg tx_p, tx_n;
    assign tx_p = (mlt_ctr == 2'b01) ? 1'b0 : 1'bz;
    assign tx_n = (mlt_ctr == 2'b11) ? 1'b0 : 1'bz;
    
    // output
    assign PIO[0] = tx_p;
    assign PIO[1] = tx_n;
    
    
    reg dbg_out;
    always @(posedge clk125) dbg_out <= fiveb_r[4];
    assign PIO[4] = dbg_out;
    assign PIO[6] = send_stb;
    
    reg clk_r=0;
    always @(posedge clk125) clk_r <= ~clk_r;
    assign PIO[7] = clk_r;
    
    
   // 4b5b encoding
    function [4:0] encode_4b5b;
        input [3:0] fourb;
        begin
            case (fourb)
                4'b0000: encode_4b5b = 5'b11110;
                4'b0001: encode_4b5b = 5'b01001;
                4'b0010: encode_4b5b = 5'b10100;
                4'b0011: encode_4b5b = 5'b10101;
                4'b0100: encode_4b5b = 5'b01010;
                4'b0101: encode_4b5b = 5'b01011;
                4'b0110: encode_4b5b = 5'b01110;
                4'b0111: encode_4b5b = 5'b01111;
                4'b1000: encode_4b5b = 5'b10010;
                4'b1001: encode_4b5b = 5'b10011;
                4'b1010: encode_4b5b = 5'b10110;
                4'b1011: encode_4b5b = 5'b10111;
                4'b1100: encode_4b5b = 5'b11010;
                4'b1101: encode_4b5b = 5'b11011;
                4'b1110: encode_4b5b = 5'b11100;
                4'b1111: encode_4b5b = 5'b11101;
            endcase
        end
    endfunction
    
endmodule   
