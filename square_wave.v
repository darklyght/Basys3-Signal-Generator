`timescale 1ns / 1ps

module square_wave(
    input CLK,
    input [11:0] PHASE,
    input [1:0] FORM,
    input [4:0] SQUARE_DUTY,
    output reg [11:0] DATA
    );
    
    always @ (posedge CLK) begin
        case (FORM)
            2'b00: DATA <= (PHASE <= (4095 * SQUARE_DUTY / 20)) ? 4095 : 0;
            2'b01: DATA <= (PHASE <= (4095 * SQUARE_DUTY / 20)) ? 4095 : 2048;
            2'b10: DATA <= (PHASE <= (4095 * SQUARE_DUTY / 20)) ? 0 : 4095;
            2'b11: DATA <= 4095;
        endcase
    end    
endmodule
