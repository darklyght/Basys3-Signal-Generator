`timescale 1ns / 1ps

module seven_segment(
    input CLK,
    input [15:0] BCD,
    input [1:0] DECIMAL,
    output reg [7:0] SSEG,
    output reg [3:0] EN
    );
    
    reg [1:0] COUNT;
    reg [3:0] NUM_TMP;
    always @ (posedge CLK) COUNT <= COUNT + 1;
    
    always @ (*) begin
        case (COUNT[1:0])
            2'b00: begin
                EN = 4'b1110;
                NUM_TMP = BCD[3:0];
                if (DECIMAL == 2'b00) SSEG[0] = 1'b0;
                else SSEG[0] = 1'b1;
            end
            2'b01: begin
                EN = 4'b1101;
                NUM_TMP = BCD[7:4];
                if (DECIMAL == 2'b01) SSEG[0] = 1'b0;
                else SSEG[0] = 1'b1;
            end
            2'b10: begin
                EN = 4'b1011;
                NUM_TMP = BCD[11:8];
                if (DECIMAL == 2'b10) SSEG[0] = 1'b0;
                else SSEG[0] = 1'b1;
            end
            2'b11: begin
                EN = 4'b0111;
                NUM_TMP = BCD[15:12];
                if (DECIMAL == 2'b11) SSEG[0] = 1'b0;
                else SSEG[0] = 1'b1;
            end
        endcase
    end
    
    always @ (*) begin
        case(NUM_TMP)
            4'd0: SSEG[7:1] = 7'b1000000;
            4'd1: SSEG[7:1] = 7'b1111001;
            4'd2: SSEG[7:1] = 7'b0100100;
            4'd3: SSEG[7:1] = 7'b0110000;
            4'd4: SSEG[7:1] = 7'b0011001;
            4'd5: SSEG[7:1] = 7'b0010010;
            4'd6: SSEG[7:1] = 7'b0000010;
            4'd7: SSEG[7:1] = 7'b1111000;
            4'd8: SSEG[7:1] = 7'b0000000;
            4'd9: SSEG[7:1] = 7'b0010000;
            default: SSEG[7:1] = 7'b0111111;
        endcase
    end
        
endmodule
