`timescale 1ns / 1ps

module wave_mux(
    input CLK,
    input CORDIC_CLK,
    input RESET,
    input [31:0] FREQ,
    input [1:0] WAVE,
    input [1:0] FORM,
    input [31:0] MIN_AMP,
    input [31:0] MAX_AMP,
    input [11:0] PHASE_MOD,
    input [4:0] SQUARE_DUTY,
    input [4:0] TRIANGLE_TIP,
    output [11:0] DATA
    );
    
    wire [11:0] PHASE;
    wire [11:0] SQUARE_OUT, SAWTOOTH_OUT, TRIANGLE_OUT, SINE_OUT, SINE_OUT_HIGH, OUT;
    
    phase_accumulator phase(CLK, RESET, FREQ, PHASE_MOD, PHASE);
    square_wave square(CLK, PHASE, FORM, SQUARE_DUTY, SQUARE_OUT);
    sawtooth_wave sawtooth(CLK, PHASE, FORM, SAWTOOTH_OUT);
    triangle_wave triangle(CLK, PHASE, FORM, TRIANGLE_TIP, TRIANGLE_OUT);
    sine_wave sine(CORDIC_CLK, PHASE, FORM, SINE_OUT);
    dds_sine_rom sine_high(CLK, PHASE, FORM, SINE_OUT_HIGH);
    
    assign OUT = (WAVE == 2'b00) ? SQUARE_OUT :
                 (WAVE == 2'b01) ? SAWTOOTH_OUT :
                 (WAVE == 2'b10) ? TRIANGLE_OUT : 
                 (FREQ <= 32'd9999000) ? SINE_OUT : 
                 SINE_OUT_HIGH;
    
    assign DATA = OUT * ((MAX_AMP - MIN_AMP) / 2) / 32'd2048 + MIN_AMP;
endmodule
