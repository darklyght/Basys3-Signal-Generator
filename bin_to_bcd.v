`timescale 1ns / 1ps

module bin_to_bcd(
    input [13:0] BIN,
    output [15:0] BCD
    );
    
    assign BCD[3:0] = BIN % 10;
    assign BCD[7:4] = (BIN / 10) % 10;
    assign BCD[11:8] = (BIN / 100) % 10;
    assign BCD[15:12] = (BIN / 1000);
    
endmodule
