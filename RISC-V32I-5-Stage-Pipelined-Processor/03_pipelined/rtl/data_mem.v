`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: data_mem
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Stores words with asynchronous reads and clocked writes.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module data_mem (
    input  wire        clk,
    input  wire        WE,
    input  wire [31:0] A,
    input  wire [31:0] WD,
    output reg  [31:0] RD
);
    reg [31:0] mem [0:1023];
    integer i;

    // Zeroed words make reads deterministic before a program stores data.
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'd0;
    end

    // Stores update one aligned word on the clock edge.
    always @(posedge clk) begin
        if (WE && (A[31:2] < 30'd1024))
            mem[A[11:2]] <= WD;
    end

    // Loads read asynchronously; invalid or unknown indices return zero.
    always @(*) begin
        if (A[31:2] < 30'd1024)
            RD = mem[A[11:2]];
        else
            RD = 32'd0;
    end
endmodule
