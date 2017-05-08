`timescale 1ns / 1ps

module signal_generator(
    input CLK,
    input C_PB,
    input U_PB,
    input D_PB,
    input L_PB,
    input R_PB,
    input [15:0] SWITCH,
    input PS2Clk,
    input PS2Data,
    output LED,
    output [3:0] JA,
    output [7:0] SSEG,
    output [3:0] EN,
    output [15:4] NUM,
    output HSYNC,
    output VSYNC,
    output [3:0] VGA_RED,
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE
    );
    
    parameter SAMP = 16'd128;
    
    wire HALF_CLOCK, VGA_CLOCK, SAMP_CLOCK, CORDIC_CLOCK;
    wire CLOCK_1KHZ, CLOCK_64HZ, CLOCK_4HZ;
    wire MOD_CLOCK;
    wire [11:0] MOD_SIGNAL;
    wire SP_CENTRE, SP_UP, SP_DOWN, SP_LEFT, SP_RIGHT;
    
    wire [15:0] BCD_MIN_AMP1_V, BCD_MAX_AMP1_V, BCD_MIN_AMP1_N, BCD_MAX_AMP1_N, BCD_MIN_AMP1, BCD_MAX_AMP1, BCD_FREQ1, BCD_DATA1;
    wire [15:0] BCD_MIN_AMP2_V, BCD_MAX_AMP2_V, BCD_MIN_AMP2_N, BCD_MAX_AMP2_N, BCD_MIN_AMP2, BCD_MAX_AMP2, BCD_FREQ2, BCD_DATA2;
    wire [31:0] ASCII_MAX_AMP1, ASCII_MIN_AMP1;
    wire [31:0] ASCII_MAX_AMP2, ASCII_MIN_AMP2;
    wire [39:0] ASCII_FREQ1;
    wire [39:0] ASCII_FREQ2;
    wire [23:0] ASCII_DT;
    wire [23:0] ASCII_BW;
    
    reg [31:0] BCD;
    reg [1:0] BCD_FLAG = 0;
    reg [1:0] DECIMAL = 2'b11;

    wire [31:0] MAX_AMP1;
    reg MAX_AMP1_E = 1'b0;
    wire [31:0] MIN_AMP1;
    reg MIN_AMP1_E = 1'b0;
    wire [31:0] MAX_AMP2;
    reg MAX_AMP2_E = 1'b0;
    wire [31:0] MIN_AMP2;
    reg MIN_AMP2_E = 1'b0;
    wire [31:0] FREQ1;
    reg FREQ1_E = 1'b0;
    wire [31:0] FREQ2;
    reg FREQ2_E = 1'b0;
    
    wire U_FF, D_FF, L_FF, R_FF;
    wire CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_512HZ, CLOCK_2048HZ;
    wire CLOCK_RST;
    
    reg [1:0] WAVE1 = 2'b00;
    reg [1:0] WAVE2 = 2'b00;
    reg [1:0] FORM1 = 2'b00;
    reg [1:0] FORM2 = 2'b00;
    
    wire [4:0] SQUARE_DUTY1, TRIANGLE_TIP1;
    wire [4:0] SQUARE_DUTY2, TRIANGLE_TIP2;
    wire [7:0] DUTY_CYCLE;
    
    wire [11:0] DATA_A;
    wire [11:0] DATA_A1;
    wire [11:0] DATA_A2;
    
    wire [15:0] BCD_KB_FREQ;
    wire [31:0] KB_FREQ;
    wire KB_FLAG1, KB_FLAG2;
    
    wire [4:0] FM_BW;
    
    vga_output vga(VGA_CLOCK, SWITCH[3], SWITCH[0], SWITCH[1], SWITCH[2], SWITCH[15], SWITCH[5], ASCII_FREQ1, ASCII_MAX_AMP1, ASCII_MIN_AMP1, WAVE1, FORM1, ASCII_FREQ2, ASCII_MAX_AMP2, ASCII_MIN_AMP2, WAVE2, FORM2, SWITCH[14], SWITCH[13], SWITCH[12], SWITCH[11], ASCII_BW, SWITCH[10] & ~SWITCH[11], ASCII_DT, SWITCH[9], HSYNC, VSYNC, VGA_RED, VGA_GREEN, VGA_BLUE);
    
    freq_to_ascii freq1(FREQ1, ASCII_FREQ1);
    bcd_to_ascii_amp max_amp1(BCD_MAX_AMP1, ASCII_MAX_AMP1);
    bcd_to_ascii_amp min_amp1(BCD_MIN_AMP1, ASCII_MIN_AMP1);
    
    freq_to_ascii freq2(FREQ2, ASCII_FREQ2);
    bcd_to_ascii_amp max_amp2(BCD_MAX_AMP2, ASCII_MAX_AMP2);
    bcd_to_ascii_amp min_amp2(BCD_MIN_AMP2, ASCII_MIN_AMP2);
    
    dt_to_ascii duty_cycle(DUTY_CYCLE * 5, ASCII_DT);
    dt_to_ascii bandwidth(FM_BW * 5, ASCII_BW);
    
    slow_clock clock_vga(CLK, 0, 32'd25000000, VGA_CLOCK);    
    slow_clock clock_50mhz(CLK, 0, 32'd50000000, HALF_CLOCK);
    slow_clock clock_1khz(CLK, 0, 32'd1000, CLOCK_1KHZ);
    slow_clock clock_64hz(CLK, 0, 32'd64, CLOCK_64HZ);
    slow_clock clock_1mhz(CLK, 0, 32'd1000000, SAMP_CLOCK);
    slow_clock clock_48mhz(CLK, 0, 32'd48000000, CORDIC_CLOCK);
    
    single_pulse centre(CLOCK_64HZ, C_PB, SP_CENTRE);
    single_pulse up(CLOCK_64HZ, U_PB, SP_UP);
    single_pulse down(CLOCK_64HZ, D_PB, SP_DOWN);
    single_pulse left(CLOCK_64HZ, L_PB, SP_LEFT);
    single_pulse right(CLOCK_64HZ, R_PB, SP_RIGHT);
    
    bin_to_bcd bintobcdfreq1((FREQ1 <= 32'd9999000) ? FREQ1[31:0] / 1000 : FREQ1[31:0] / 10000, BCD_FREQ1);
    bin_to_bcd bintobcdfreq2((FREQ2 <= 32'd9999000) ? FREQ2[31:0] / 1000 : FREQ2[31:0] / 10000, BCD_FREQ2);
    
    bin_to_bcd bintobcdampmax1v(MAX_AMP1[31:0] * 3300 / 4096, BCD_MAX_AMP1_V);
    bin_to_bcd bintobcdampmin1v(MIN_AMP1[31:0] * 3300 / 4096, BCD_MIN_AMP1_V);
    bin_to_bcd bintobcdampmax2v(MAX_AMP2[31:0] * 3300 / 4096, BCD_MAX_AMP2_V);
    bin_to_bcd bintobcdampmin2v(MIN_AMP2[31:0] * 3300 / 4096, BCD_MIN_AMP2_V);
    bin_to_bcd bintobcdampmax1n(MAX_AMP1[31:0], BCD_MAX_AMP1_N);
    bin_to_bcd bintobcdampmin1n(MIN_AMP1[31:0], BCD_MIN_AMP1_N);
    bin_to_bcd bintobcdampmax2n(MAX_AMP2[31:0], BCD_MAX_AMP2_N);
    bin_to_bcd bintobcdampmin2n(MIN_AMP2[31:0], BCD_MIN_AMP2_N);
    
    bin_to_bcd bintobcddata1(DATA_A1[11:0], BCD_DATA1);
    bin_to_bcd bintobcddata2(DATA_A2[11:0], BCD_DATA2);
    
    assign BCD_MIN_AMP1 = (SWITCH[5] == 0) ? BCD_MIN_AMP1_V : BCD_MIN_AMP1_N;
    assign BCD_MAX_AMP1 = (SWITCH[5] == 0) ? BCD_MAX_AMP1_V : BCD_MAX_AMP1_N;
    assign BCD_MIN_AMP2 = (SWITCH[5] == 0) ? BCD_MIN_AMP2_V : BCD_MIN_AMP2_N;
    assign BCD_MAX_AMP2 = (SWITCH[5] == 0) ? BCD_MAX_AMP2_V : BCD_MAX_AMP2_N;

    seven_segment display(CLOCK_1KHZ, BCD, DECIMAL, SSEG, EN);
    
    d_flipflop up_ff(CLOCK_64HZ, U_PB, U_FF);
    d_flipflop down_ff(CLOCK_64HZ, D_PB, D_FF);
    d_flipflop left_ff(CLOCK_64HZ, L_PB, L_FF);
    d_flipflop right_ff(CLOCK_64HZ, R_PB, R_FF);
    
    assign CLOCK_RST = SP_UP | SP_DOWN | SP_LEFT | SP_RIGHT;
    
    slow_clock clock_2hz(CLK, CLOCK_RST, 32'd2, CLOCK_2HZ);
    slow_clock clock_8hz(CLK, CLOCK_RST, 32'd8, CLOCK_8HZ);
    slow_clock clock_32hz(CLK, CLOCK_RST, 32'd32, CLOCK_32HZ);
    slow_clock clock_128hz(CLK, CLOCK_RST, 32'd128, CLOCK_128HZ);
    slow_clock clock_512hz(CLK, CLOCK_RST, 32'd512, CLOCK_512HZ);
    slow_clock clock_2048hz(CLK, CLOCK_RST, 32'd2048, CLOCK_2048HZ);
    
    amp_control_max max_amp1_control(MAX_AMP1_E, CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, U_FF, D_FF, MIN_AMP1, MAX_AMP1);
    amp_control_min min_amp1_control(MIN_AMP1_E, CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, U_FF, D_FF, MAX_AMP1, MIN_AMP1);
    amp_control_max max_amp2_control(MAX_AMP2_E, CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, U_FF, D_FF, MIN_AMP2, MAX_AMP2);
    amp_control_min min_amp2_control(MIN_AMP2_E, CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, U_FF, D_FF, MAX_AMP2, MIN_AMP2);
    freq_control freq1_control(PS2Clk, PS2Data, ~SWITCH[3] & SWITCH[14], FREQ1_E & ~SWITCH[4] & ~(SWITCH[11] & SWITCH[10]), SWITCH[8:6], CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, CLOCK_2048HZ, L_FF, R_FF, FREQ1, KB_FLAG1);
    freq_control freq2_control(PS2Clk, PS2Data, SWITCH[3] & SWITCH[14], FREQ2_E & ~SWITCH[4] & ~(SWITCH[11] & SWITCH[10]), SWITCH[8:6], CLOCK_64HZ, CLOCK_2HZ, CLOCK_8HZ, CLOCK_32HZ, CLOCK_128HZ, CLOCK_512HZ, CLOCK_2048HZ, L_FF, R_FF, FREQ2, KB_FLAG2);
    
    always @ (posedge CLOCK_64HZ) begin
        if (SWITCH[15] == 1) begin
            MAX_AMP1_E <= 1'b0;
            MIN_AMP1_E <= 1'b0;
            MAX_AMP2_E <= 1'b0;
            MIN_AMP2_E <= 1'b0;
            FREQ1_E <= 1'b0;
            FREQ2_E <= 1'b0;
            if (SWITCH[3] == 0) begin
                if (SP_UP == 1) FORM1 <= FORM1 + 1;
                if (SP_DOWN == 1) FORM1 <= FORM1 - 1;
                if (SP_RIGHT == 1) WAVE1 <= WAVE1 + 1;
                if (SP_LEFT == 1) WAVE1 <= WAVE1 - 1;
            end
            else begin
                if (SP_UP == 1) FORM2 <= FORM2 + 1;
                if (SP_DOWN == 1) FORM2 <= FORM2 - 1;
                if (SP_RIGHT == 1) WAVE2 <= WAVE2 + 1;
                if (SP_LEFT == 1) WAVE2 <= WAVE2 - 1;
            end
        end
        else if (SWITCH[3] == 0) begin
            FREQ1_E <= 1'b1;
            FREQ2_E <= 1'b0;
            if (SP_LEFT == 1 || SP_RIGHT == 1) BCD_FLAG <= 2;
            if (SWITCH[2] == 1) begin
                MAX_AMP1_E <= 1'b1;
                MIN_AMP1_E <= 1'b1;
                MAX_AMP2_E <= 1'b0;
                MIN_AMP2_E <= 1'b0;
                if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 0;
            end
            else begin
                if (SWITCH[1] == 1) begin
                    MAX_AMP1_E <= 1'b1;
                    MIN_AMP1_E <= 1'b0;
                    MAX_AMP2_E <= 1'b0;
                    MIN_AMP2_E <= 1'b0;
                    if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 0;
                end
                else begin
                    MAX_AMP1_E <= 1'b0;
                    MIN_AMP1_E <= 1'b1;
                    MAX_AMP2_E <= 1'b0;
                    MIN_AMP2_E <= 1'b0;
                    if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 1;
                end
            end
        end
        else begin
            FREQ1_E <= 1'b0;
            FREQ2_E <= 1'b1;
            if (SP_LEFT == 1 || SP_RIGHT == 1) BCD_FLAG <= 2;
            if (SWITCH[2] == 1) begin
                MAX_AMP1_E <= 1'b0;
                MIN_AMP1_E <= 1'b0;
                MAX_AMP2_E <= 1'b1;
                MIN_AMP2_E <= 1'b1;
                if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 0;
            end
            else begin
                if (SWITCH[1] == 1) begin
                    MAX_AMP1_E <= 1'b0;
                    MIN_AMP1_E <= 1'b0;
                    MAX_AMP2_E <= 1'b1;
                    MIN_AMP2_E <= 1'b0;
                    if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 0;
                end
                else begin
                    MAX_AMP1_E <= 1'b0;
                    MIN_AMP1_E <= 1'b0;
                    MAX_AMP2_E <= 1'b0;
                    MIN_AMP2_E <= 1'b1;
                    if (SP_UP == 1 || SP_DOWN == 1) BCD_FLAG <= 1;
                end
            end
        end
    end
    
    always @ (posedge CLOCK_1KHZ) begin
        if (SWITCH[3] == 0) begin
            if (BCD_FLAG == 0) begin
                BCD <= BCD_MAX_AMP1;
                DECIMAL <= (SWITCH[5] == 0) ? 2'b11 : 2'b00;
            end
            if (BCD_FLAG == 1) begin
                BCD <= BCD_MIN_AMP1;
                DECIMAL <= (SWITCH[5] == 0) ? 2'b11 : 2'b00;
            end
            if (BCD_FLAG == 2) begin
                BCD <= BCD_FREQ1;
                DECIMAL <= (FREQ1 <= 32'd9999000) ? 2'b00 : 2'b10;
            end
        end
        else if (SWITCH[3] == 1) begin
            if (BCD_FLAG == 0) begin
                BCD <= BCD_MAX_AMP2;
                DECIMAL <= (SWITCH[5] == 0) ? 2'b11 : 2'b00;
            end
            if (BCD_FLAG == 1) begin
                BCD <= BCD_MIN_AMP2;
                DECIMAL <= (SWITCH[5] == 0) ? 2'b11 : 2'b00;
            end
            if (BCD_FLAG == 2) begin
                BCD <= BCD_FREQ2;
                DECIMAL <= (FREQ2 <= 32'd9999000) ? 2'b00 : 2'b10;
            end
        end
    end
    
    special_feature square1(CLOCK_64HZ, (~SWITCH[3] & SWITCH[4]) && WAVE1 == 2'b00, SP_RIGHT, SP_LEFT, SQUARE_DUTY1);
    special_feature square2(CLOCK_64HZ, (SWITCH[3] & SWITCH[4]) && WAVE2 == 2'b00, SP_RIGHT, SP_LEFT, SQUARE_DUTY2);
    special_feature triangle1(CLOCK_64HZ, (~SWITCH[3] & SWITCH[4]) && WAVE1 == 2'b10, SP_RIGHT, SP_LEFT, TRIANGLE_TIP1);
    special_feature triangle2(CLOCK_64HZ, (SWITCH[3] & SWITCH[4]) && WAVE2 == 2'b10, SP_RIGHT, SP_LEFT, TRIANGLE_TIP2);
    special_feature fm_bandwidth(CLOCK_64HZ, (SWITCH[11] & SWITCH[10]), SP_RIGHT, SP_LEFT, FM_BW);
    
    assign DUTY_CYCLE = (~SWITCH[3] && WAVE1 == 2'b00) ? SQUARE_DUTY1 : (SWITCH[3] && WAVE2 == 2'b00) ? SQUARE_DUTY2 : (~SWITCH[3] && WAVE1 == 2'b10) ? TRIANGLE_TIP1 : (SWITCH[3] && WAVE2 == 2'b10) ? TRIANGLE_TIP2 : 8'b0;
    
    wave_mux choose_wave1(SAMP_CLOCK, CORDIC_CLOCK, SP_CENTRE, FREQ1, WAVE1, FORM1, MIN_AMP1, MAX_AMP1, 12'b0, SQUARE_DUTY1, TRIANGLE_TIP1, DATA_A1);
    wave_mux choose_wave2(SAMP_CLOCK, CORDIC_CLOCK, SP_CENTRE, (SWITCH[11]) ? FREQ2 + (FREQ2 / 4096 * DATA_A1 * FM_BW / 20) : FREQ2, WAVE2, FORM2, (SWITCH[12]) ? 2048 - DATA_A1 / 2 : MIN_AMP2, (SWITCH[12]) ? 2047 + DATA_A1 / 2 : (SWITCH[13]) ? DATA_A1 : MAX_AMP2, (SWITCH[10] & ~SWITCH[11]) ? DATA_A1 : 12'b0, SQUARE_DUTY2, TRIANGLE_TIP2, DATA_A2);

    assign NUM[15:4] = DATA_A;
    assign DATA_A[11:0] = (SWITCH[0] == 1 && SWITCH[3] == 0) ? MAX_AMP1 : (SWITCH[0] == 1 && SWITCH[3] == 1) ? MAX_AMP2 : (SWITCH[10] == 1 || SWITCH[11] == 1 || SWITCH[12] == 1 || SWITCH[13] == 1) ? DATA_A2[11:0] : (SWITCH[9] == 1) ? (DATA_A1 / 2) + (DATA_A2 / 2) : (SWITCH[3] == 0) ? DATA_A1[11:0] : DATA_A2[11:0];

DA2RefComp u1(
    //SIGNALS PROVIDED TO DA2RefComp
    .CLK(HALF_CLOCK), 
    .START(SAMP_CLOCK),
    .DATA1(DATA_A), 
    .DATA2(), 
    .RST(),
        
    //DO NOT CHANGE THE FOLLOWING LINES
    .D1(JA[1]), 
    .D2(JA[2]), 
    .CLK_OUT(JA[3]), 
    .nSYNC(JA[0]), 
    .DONE(LED)
    );

endmodule
