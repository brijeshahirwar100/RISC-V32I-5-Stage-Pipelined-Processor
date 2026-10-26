`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: pipeline_reg
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Stores a pipeline-stage value with enable and synchronous clear.
// Ports: clk, EN, CLR, D[WIDTH-1:0], Q[WIDTH-1:0]
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module pipeline_reg #(
    parameter WIDTH = 32
) (
    input  wire             clk,
    input  wire             EN,
    input  wire             CLR,
    input  wire [WIDTH-1:0] D,
    output reg  [WIDTH-1:0] Q
);
    // Clear takes priority over enable so a flush can insert a bubble.
    always @(posedge clk) begin
        if (CLR)
            Q <= {WIDTH{1'b0}};
        else if (EN)
            Q <= D;
    end
endmodule
