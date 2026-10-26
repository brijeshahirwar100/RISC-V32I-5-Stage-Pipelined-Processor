`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: mem
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Unified 1024-word instruction and data memory.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mem (
    input  wire        clk,
    input  wire        WE,
    input  wire [31:0] Adr,
    input  wire [31:0] WriteData,
    output wire [31:0] ReadData
);
    reg [31:0] mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'd0;
        $readmemh("C:/Users/brije/Downloads/Vivado_projects/Multi_Cycle_RISC-V/program.hex", mem);
    end

    assign ReadData = mem[Adr[11:2]];

    always @(posedge clk) begin
        if (WE)
            mem[Adr[11:2]] <= WriteData;
    end
endmodule
