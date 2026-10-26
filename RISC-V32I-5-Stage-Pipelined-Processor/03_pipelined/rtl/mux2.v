`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: mux2
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Selects one of two 32-bit datapath values.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mux2 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Sel,
    output wire [31:0] Y
);
    // Sel chooses the alternate input for immediate and target paths.
    assign Y = Sel ? B : A;
endmodule
