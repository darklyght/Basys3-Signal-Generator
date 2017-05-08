`timescale 1ns / 1ps

module special_feature(
    input CLK,
    input ENABLE,
    input INCREASE,
    input DECREASE,
    output reg [4:0] OUT = 5'd10
    );
    
    always @ (posedge CLK) begin
        if (INCREASE == 1 && ENABLE == 1) OUT <= (OUT < 5'd20) ? OUT + 1 : OUT;
        else if (DECREASE == 1 && ENABLE == 1) OUT <= (OUT > 5'd0) ? OUT - 1 : OUT;
    end            
endmodule
