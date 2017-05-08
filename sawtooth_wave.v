`timescale 1ns / 1ps

module sawtooth_wave(
    input CLK,
    input [11:0] PHASE,
    input [1:0] FORM,
    output reg [11:0] DATA
    );
    
    always @ (posedge CLK) begin
        case (FORM)
            2'b00: DATA <= PHASE;
            2'b01: DATA <= (PHASE <= 2048) ? 2048 : PHASE;
            2'b10: DATA <= 4095 - PHASE;
            2'b11: DATA <= (PHASE <= 2048) ? 4095 - PHASE : PHASE;
        endcase
    end   
endmodule
