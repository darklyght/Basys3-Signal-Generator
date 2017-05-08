`timescale 1ns / 1ps

module keyboard_freq(
    input PS2Clk,
    input PS2Data,
    input ENABLE, 
    output reg [19:0] NUM = 16'b0,
    output reg KB_FLAG = 1'b0
    );
    
    reg [1:0] COUNT = 2'b00;
    reg [7:0] KB_CURR = 8'hf0;
    reg [7:0] KB_PREV = 8'hf0;
    reg [3:0] KB_COUNT = 4'h1;

    always @ (negedge PS2Clk) begin
        if (ENABLE == 1) begin
            case (KB_COUNT)
                1:;
                2: KB_CURR[0] <= PS2Data;
                3: KB_CURR[1] <= PS2Data;
                4: KB_CURR[2] <= PS2Data;
                5: KB_CURR[3] <= PS2Data;
                6: KB_CURR[4] <= PS2Data;
                7: KB_CURR[5] <= PS2Data;
                8: KB_CURR[6] <= PS2Data;
                9: KB_CURR[7] <= PS2Data;
                10: KB_FLAG <= 1'b1;
                11: KB_FLAG <= 1'b0;
            endcase
            if (KB_COUNT <= 10) KB_COUNT <= KB_COUNT + 1;
            else if (KB_COUNT == 11) KB_COUNT <= 1;
        end
    end
    
    always @ (posedge KB_FLAG) begin
        if (KB_CURR == 8'hf0) begin
            case (KB_PREV)
                8'h16: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0001;
                end
                8'h1E: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0010;
                end
                8'h26: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0011;
                end
                8'h25: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0100;
                end
                8'h2E: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0101;
                end
                8'h36: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0110;
                end
                8'h3D: begin 
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0111;
                end
                8'h3E: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b1000;
                end
                8'h46: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b1001;
                end
                8'h45: begin
                    NUM = NUM << 4;
                    NUM = NUM + 4'b0000;
                end
                default: NUM = NUM;
            endcase
        end
        else KB_PREV <= KB_CURR;
    end
    
endmodule
