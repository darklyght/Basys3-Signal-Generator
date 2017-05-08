`timescale 1ns / 1ps

module vga_output(
    input CLK,
    input CHANNEL,
    input DC,
    input MIN_MAX,
    input BOTH,
    input WAVE,
    input AMP_MODE,
    input [39:0] FREQ1,
    input [31:0] MAX_AMP1,
    input [31:0] MIN_AMP1,
    input [1:0] WAVE1,
    input [1:0] FORM1,
    input [39:0] FREQ2,
    input [31:0] MAX_AMP2,
    input [31:0] MIN_AMP2,
    input [1:0] WAVE2,
    input [1:0] FORM2,
    input KEYBOARD,
    input MAX_AMP_MOD,
    input MIN_MAX_AMP_MOD,
    input FREQ_MOD,
    input [23:0] BANDWIDTH,
    input PHASE_MOD,
    input [23:0] DUTY_CYCLE,
    input SUPERPOSE,
    output reg H_SYNC,
    output reg V_SYNC,
    output [3:0] RED,
    output [3:0] GREEN,
    output [3:0] BLUE
    );
    
    parameter H_SYNC_PULSE = 96;
    parameter V_SYNC_PULSE = 2;
    parameter H_MAX = 800;
    parameter V_MAX = 525;
    parameter H_FRONT_PORCH = 100;
    parameter H_BACK_PORCH = -36;
    parameter V_FRONT_PORCH = 43;
    parameter V_BACK_PORCH = 0;
    
    reg [10:0] H_COUNT, V_COUNT, H_NEXT, V_NEXT;
    reg [9:0] X_COORD, Y_COORD;
    reg[11:0] COLOUR;
    wire [7:0] CHAR;
    wire DATA;
    
    always @ (posedge CLK)
    begin
        V_COUNT <= V_NEXT;
        H_COUNT <= H_NEXT;
        if (H_NEXT < H_MAX - 1) H_NEXT <= H_NEXT + 1;
        else begin
            H_NEXT <= 0;
            if (V_NEXT < V_MAX - 1) V_NEXT <= V_NEXT + 1;
            else V_NEXT <= 0;
        end
        if (H_COUNT < H_SYNC_PULSE) H_SYNC <= 1;
        else H_SYNC <= 0;
        if (V_COUNT < V_SYNC_PULSE) V_SYNC <= 1;
        else V_SYNC <= 0;
        if ((H_COUNT >= H_SYNC_PULSE + H_FRONT_PORCH) && (H_COUNT < H_MAX - H_BACK_PORCH)) X_COORD <= H_COUNT - H_SYNC_PULSE - H_FRONT_PORCH;
        else X_COORD <= 0;
        if ((V_COUNT >= V_SYNC_PULSE + V_FRONT_PORCH) && (V_COUNT < V_MAX - V_BACK_PORCH)) Y_COORD <= V_COUNT - V_SYNC_PULSE - V_FRONT_PORCH;
        else Y_COORD <= 0;
        if (((H_COUNT < H_SYNC_PULSE + H_FRONT_PORCH) || (H_COUNT >= H_MAX - H_BACK_PORCH)) || ((V_COUNT < V_SYNC_PULSE + V_FRONT_PORCH) || (V_COUNT >= V_MAX - V_BACK_PORCH))) COLOUR <= 12'h000;
        else if (DATA == 1) COLOUR <= 12'hFFF;
        else COLOUR <= 12'h000;
    end
    
    character_rom characters(CLK, CHANNEL, DC, MIN_MAX, BOTH, WAVE, AMP_MODE, FREQ1, MAX_AMP1, MIN_AMP1, WAVE1, FORM1, FREQ2, MAX_AMP2, MIN_AMP2, WAVE2, FORM2, KEYBOARD, MAX_AMP_MOD, MIN_MAX_AMP_MOD, FREQ_MOD, BANDWIDTH, PHASE_MOD, DUTY_CYCLE, SUPERPOSE, Y_COORD >> 4, X_COORD >> 3, CHAR);
    display_rom bits(CLK, CHAR, Y_COORD[3:0], X_COORD[2:0] - 1'b1, DATA);
    
    assign RED = COLOUR[11:8];
    assign GREEN = COLOUR[7:4];
    assign BLUE = COLOUR[3:0];
    
endmodule
