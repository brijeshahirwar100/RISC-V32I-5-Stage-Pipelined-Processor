`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: extend
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Builds signed I, S, B, and J immediates.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module extend (
    input  wire [31:0] Instr,
    input  wire [1:0]  ImmSrc,
    output reg  [31:0] ImmExt
);
    // Each format places its sign and low alignment bits differently.
    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            2'b10: ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7],
                             Instr[30:25], Instr[11:8], 1'b0};
            2'b11: ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12],
                             Instr[20], Instr[30:21], 1'b0};
            default: ImmExt = 32'd0;
        endcase
    end
endmodule
