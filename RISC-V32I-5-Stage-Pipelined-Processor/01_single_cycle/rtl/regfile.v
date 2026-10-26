`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: regfile
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Stores the processor's 32 architectural registers.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module regfile (
    input  wire        clk,
    input  wire        reset,
    input  wire        WE3,
    input  wire [4:0]  A1,
    input  wire [4:0]  A2,
    input  wire [4:0]  A3,
    input  wire [31:0] WD3,
    output wire [31:0] RD1,
    output wire [31:0] RD2
);
    reg [31:0] rf [0:31];
    integer i;

    // Reset gives deterministic architectural state; writes preserve x0.
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'd0;
        end else if (WE3 && (A3 != 5'd0)) begin
            rf[A3] <= WD3;
        end
    end

    // x0 is constant while both register reads remain asynchronous.
    assign RD1 = (A1 == 5'd0) ? 32'd0 : rf[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : rf[A2];
endmodule
