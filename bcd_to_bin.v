`timescale 1ns / 1ps

module bcd_to_bin(
    input [19:0] BCD,
    output reg [31:0] BIN
    );
    
    reg [3:0] NUM;
    reg [3:0] i;
    
    always @ (BCD) begin
        BIN = 12'b0;
        for (i = 0; i < 5; i = i + 1) begin
            NUM = {BCD[3+(i*4)], BCD[2+(i*4)], BCD[1+(i*4)], BCD[(i*4)]};
            case (NUM)
                4'b0000: BIN = BIN + (0 * (10 ** i));
                4'b0001: BIN = BIN + (1 * (10 ** i));
                4'b0010: BIN = BIN + (2 * (10 ** i));
                4'b0011: BIN = BIN + (3 * (10 ** i));
                4'b0100: BIN = BIN + (4 * (10 ** i));
                4'b0101: BIN = BIN + (5 * (10 ** i));
                4'b0110: BIN = BIN + (6 * (10 ** i));
                4'b0111: BIN = BIN + (7 * (10 ** i));
                4'b1000: BIN = BIN + (8 * (10 ** i));
                4'b1001: BIN = BIN + (9 * (10 ** i));
            endcase
        end
    end
        
endmodule
