`timescale 1ns / 1ps

module freq_control(
    input PS2Clk,
    input PS2Data,
    input KEYBOARD_E,
    input ENABLE,
    input [2:0] INCREMENT,
    input FF_CLOCK,
    input CLOCK_2HZ,
    input CLOCK_8HZ,
    input CLOCK_32HZ,
    input CLOCK_128HZ,
    input CLOCK_512HZ,
    input CLOCK_2048HZ,
    input LEFT,
    input RIGHT,
    output reg [31:0] FREQ = 32'd10000000,
    output KB_FLAG
    );
    
    wire CLOCK;
    wire [31:0] KB_FREQ;
    wire [19:0] BCD_KB_FREQ;
    reg [5:0] COUNT = 6'd0;
    reg [15:0] SECONDS = 16'd1000;
    
    assign CLOCK = (ENABLE == 0 || COUNT == 0) ? 1'b0 : (SECONDS <= 16'd1) ? CLOCK_2HZ : (SECONDS <= 16'd2) ? CLOCK_8HZ : (SECONDS <= 16'd3) ? CLOCK_32HZ : (SECONDS <= 16'd4) ? CLOCK_128HZ : (SECONDS <= 16'd5) ? CLOCK_512HZ : CLOCK_2048HZ;
    keyboard_freq kb_freq(PS2Clk, PS2Data, KEYBOARD_E, BCD_KB_FREQ, KB_FLAG);
    bcd_to_bin freq_bin(BCD_KB_FREQ, KB_FREQ);
    
    always @ (posedge FF_CLOCK) begin
        if (ENABLE == 1 && (LEFT == 1 || RIGHT == 1)) begin
            COUNT = COUNT + 1;
            SECONDS = (COUNT == 6'd0) ? SECONDS + 1 : SECONDS;
        end
        else begin
            COUNT <= 0;
            SECONDS <= 0;
        end
    end
    
    always @ (posedge CLOCK or posedge KB_FLAG) begin
        if (KB_FLAG == 1) FREQ <= (KB_FREQ > 50000) ? 50000000 : KB_FREQ * 1000;
        else if (ENABLE == 1) begin
            if (RIGHT == 1 && FREQ <= 32'd9999000) FREQ <= (INCREMENT[0] == 1) ? FREQ + 10000 : (INCREMENT[1] == 1) ? FREQ + 100000 : (INCREMENT[2] == 1) ? FREQ + 1000000 : FREQ + 1000;
            else if (RIGHT == 1 && FREQ < 32'd50000000) FREQ <= (INCREMENT[0] == 1 && FREQ <= 32'd49900000) ? FREQ + 100000 : (INCREMENT[1] == 1 && FREQ <= 32'd49000000) ? FREQ + 1000000 : (INCREMENT[2] == 1 && FREQ <= 32'd40000000) ? FREQ + 10000000 : FREQ + 10000;
            else if (LEFT == 1 && FREQ >= 32'd10010000) FREQ <= (INCREMENT[0] == 1) ? FREQ - 100000 : (INCREMENT[1] == 1) ? FREQ - 1000000 : (INCREMENT[2] == 1) ? FREQ - 10000000 : FREQ - 10000;
            else if (LEFT == 1 && FREQ > 32'd0) FREQ <= (INCREMENT[0] == 1 && FREQ >= 32'd10000) ? FREQ - 10000 : (INCREMENT[1] == 1 && FREQ >= 32'd100000) ? FREQ - 100000 : (INCREMENT[2] == 1 && FREQ >= 32'd1000000) ? FREQ - 1000000 : FREQ - 1000;
        end
    end
        
endmodule
