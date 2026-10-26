`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: mux3
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Selects the ALU, memory, or link value for writeback.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mux3 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [31:0] C,
    input  wire [1:0]  Sel,
    output reg  [31:0] Y
);
    // The three choices match ALU, load, and JAL writeback sources.
    always @(*) begin
        case (Sel)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            default: Y = 32'd0;
        endcase
    end
endmodule
