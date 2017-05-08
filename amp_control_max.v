`timescale 1ns / 1ps

module amp_control_max(
    input ENABLE,
    input FF_CLOCK,
    input CLOCK_2HZ,
    input CLOCK_8HZ,
    input CLOCK_32HZ,
    input CLOCK_128HZ,
    input CLOCK_512HZ,
    input UP,
    input DOWN,
    input [31:0] MIN_AMP,
    output reg [31:0] MAX_AMP = 32'd4095
    );
    
    wire CLOCK;
    reg [3:0] COUNT = 6'd0;
    reg [15:0] SECONDS = 16'd0;
    
    assign CLOCK = (ENABLE == 0 || COUNT == 0) ? 1'b0 : (SECONDS <= 16'd1) ? CLOCK_2HZ : (SECONDS <= 16'd2) ? CLOCK_8HZ : (SECONDS <= 16'd4) ? CLOCK_32HZ : (SECONDS <= 16'd7) ? CLOCK_128HZ : CLOCK_512HZ;
    
    always @ (posedge FF_CLOCK) begin
        if (ENABLE == 1 && (UP == 1 || DOWN == 1)) begin
            COUNT = COUNT + 1;
            SECONDS = (COUNT == 6'd0) ? SECONDS + 1 : SECONDS;
        end
        else begin
            COUNT <= 0;
            SECONDS <= 0;
        end
    end
    
    always @ (posedge CLOCK) begin
        if (UP == 1 && MAX_AMP < 32'd4095) MAX_AMP <= MAX_AMP + 1;
        else if (DOWN == 1 && MAX_AMP > 32'd0 && MAX_AMP != MIN_AMP) MAX_AMP <= MAX_AMP - 1;
    end
endmodule
