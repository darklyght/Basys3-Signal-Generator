`timescale 1ns / 1ps

module d_flipflop(
    input CLK,
    input D,
    output reg Q
    );
    
    always @ (posedge CLK) begin
        Q <= D;
    end
    
endmodule
