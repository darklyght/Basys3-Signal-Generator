`timescale 1ns / 1ps

module triangle_wave(
    input CLK,
    input [11:0] PHASE,
    input [1:0] FORM,
    input [4:0] TRIANGLE_TIP,
    output reg [11:0] DATA
    );
    
    wire [11:0] PEAK_PHASE;
    wire [31:0] LARGE_PHASE;
    
    assign PEAK_PHASE = TRIANGLE_TIP * 4095 / 20;
    assign LARGE_PHASE = PHASE;
    
    always @ (posedge CLK) begin
        case (FORM)
            2'b00: DATA <= (PHASE <= PEAK_PHASE) ? LARGE_PHASE * 4095 / PEAK_PHASE : 4095 - ((LARGE_PHASE - PEAK_PHASE) * 4095) / (4095 - PEAK_PHASE);
            2'b01: DATA <= (PHASE <= PEAK_PHASE / 2) ? 2048 : (PHASE <= PEAK_PHASE) ? LARGE_PHASE * 4095 / PEAK_PHASE : (PHASE <= PEAK_PHASE + (4095 - PEAK_PHASE) / 2) ? 4095 - ((LARGE_PHASE - PEAK_PHASE) * 4095) / (4095 - PEAK_PHASE) : 2048;
            2'b10: DATA <= (PHASE <= PEAK_PHASE) ? 4095 - LARGE_PHASE * 4095 / PEAK_PHASE : ((LARGE_PHASE - PEAK_PHASE) * 4095) / (4095 - PEAK_PHASE);
            2'b11: DATA <= (PHASE <= PEAK_PHASE / 2) ? 4095 - LARGE_PHASE * 4095 / PEAK_PHASE : (PHASE <= PEAK_PHASE) ? LARGE_PHASE * 4095 / PEAK_PHASE : (PHASE <= PEAK_PHASE + (4095 - PEAK_PHASE) / 2) ? 4095 - ((LARGE_PHASE - PEAK_PHASE) * 4095) / (4095 - PEAK_PHASE) : ((LARGE_PHASE - PEAK_PHASE) * 4095) / (4095 - PEAK_PHASE);
        endcase
    end
    
endmodule
