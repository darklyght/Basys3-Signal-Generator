`timescale 1ns / 1ps

module phase_accumulator(
    input CLK,
    input RESET,
    input [31:0] FREQ,
    input [11:0] PHASE_MOD,
    output [11:0] PHASE
    );
    
    wire [47:0] INCREMENT = (49'h1000000000000 / 49'd1000000) * (FREQ / 49'd1000);
    reg [47:0] TEMP_PHASE = 48'd0;
    
    always @ (posedge CLK) begin
        if (RESET) TEMP_PHASE <= 48'd0;
        else TEMP_PHASE <= TEMP_PHASE + INCREMENT;
    end
    
    assign PHASE = TEMP_PHASE[47:36] + PHASE_MOD[11:0];
endmodule
