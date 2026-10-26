`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: pc
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Holds the current byte address of the instruction.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module pc (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] PCNext,
    output reg  [31:0] PC
);
    // The PC changes only at a rising edge and resets synchronously.
    always @(posedge clk) begin
        if (reset)
            PC <= 32'd0;
        else
            PC <= PCNext;
    end
endmodule
