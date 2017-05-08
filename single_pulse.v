`timescale 1ns / 1ps

module single_pulse(
    input CLK,
    input IN,
    output OUT
    );
    
    wire dff1out, dff2out;
        
    d_flipflop dff1(CLK, IN, dff1out);
    d_flipflop dff2(CLK, dff1out, dff2out);
    
    assign OUT = dff1out & ~dff2out;
        
endmodule
