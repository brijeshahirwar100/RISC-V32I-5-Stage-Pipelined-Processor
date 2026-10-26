`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: pc
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Holds and optionally updates the current instruction byte address.
// Ports: clk, reset, EN, PCNext[31:0], PC[31:0]
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
    input  wire        EN,
    input  wire [31:0] PCNext,
    output reg  [31:0] PC
);
    // The PC resets synchronously and updates only when enabled.
    always @(posedge clk) begin
        if (reset)
            PC <= 32'd0;
        else if (EN)
            PC <= PCNext;
    end
endmodule
