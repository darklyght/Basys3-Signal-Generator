`timescale 1ns / 1ps

module slow_clock(
    input CLK,
    input RST,
    input [31:0] FREQ,
    output reg SLOWCLOCK = 1'b1
    );
    
    reg [31:0] THRESHOLD = 32'd0;
    reg [31:0] COUNT = 32'd0;
    
    always @ (FREQ) THRESHOLD = (FREQ == 32'd0) ? 32'd0 : 32'd100000000 / (2 * FREQ);
    
    always @ (posedge CLK) begin
        SLOWCLOCK = (RST == 1) ? 1'b1 : SLOWCLOCK;
        COUNT = COUNT + 1;
        SLOWCLOCK = (COUNT == THRESHOLD) ? ~SLOWCLOCK : SLOWCLOCK;
        COUNT = (RST == 1 || COUNT == THRESHOLD) ? 32'd0 : COUNT;
    end
    
endmodule
