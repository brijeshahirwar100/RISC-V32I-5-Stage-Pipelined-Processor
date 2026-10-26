`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: adder
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Adds byte addresses and sign-extended offsets.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module adder (
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Sum
);
    // Shared adder supports PC+4 and PC-relative targets.
    assign Sum = A + B;
endmodule
