`timescale 1ns / 1ps

module sine_wave(
    input CORDIC_CLK,
    input [11:0] PHASE,
    input [1:0] FORM,
    output [11:0] DATA
    );
    
    reg [3:0] COUNT = 0;
    reg [11:0] PHASE_REG;
    reg IN_VALID = 1;
    wire [31:0] OUT;
    wire [15:0] ANGLE;
    wire [15:0] SIN;
    
    assign SIN = OUT[15:0];
    assign ANGLE = (PHASE <= 1024) ? PHASE * 4 * 333 / 106 : (PHASE <= 2048) ? (2048 - PHASE) * 4 * 333 / 106 : (PHASE <= 3072) ? (PHASE - 2048) * 4 * 333 / 106 : (4096 - PHASE) * 4 * 333 / 106;
    assign DATA = (FORM == 2'b00) ? ((PHASE_REG < 1024) ? 2046 + SIN * 2 : (PHASE_REG < 2048) ? 2049 - SIN * 2 : (PHASE_REG < 3072) ? 2049 - SIN * 2 : 2046 + SIN * 2) :
                  (FORM == 2'b01) ? ((PHASE_REG < 1024) ? 2046 + SIN * 2 : (PHASE_REG < 2048) ? 2048 : (PHASE_REG < 3072) ? 2048 : 2046 + SIN * 2) :
                  (FORM == 2'b10) ? ((PHASE_REG < 1024) ? 2049 - SIN * 2 : (PHASE_REG < 2048) ? 2046 + SIN * 2 : (PHASE_REG < 3072) ? 2046 + SIN * 2 : 2049 - SIN * 2) : 
                  ((PHASE_REG < 1024) ? 2046 + SIN * 2 : (PHASE_REG < 2048) ? 2046 + SIN * 2 : (PHASE_REG < 3072) ? 2046 + SIN * 2 : 2046 + SIN * 2);
    
    always @ (posedge CORDIC_CLK) begin
        COUNT = COUNT + 1;
        PHASE_REG = (COUNT == 4'b0000) ? PHASE : PHASE_REG;
    end
        
    cordic_core cordic_ip_core(.aclk(CORDIC_CLK), .s_axis_phase_tvalid(IN_VALID), .s_axis_phase_tdata(ANGLE), .m_axis_dout_tdata(OUT));
endmodule
