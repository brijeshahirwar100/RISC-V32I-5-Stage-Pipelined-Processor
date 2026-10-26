`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: instr_mem
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Fetches 32-bit instructions by word address.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module instr_mem (
    input  wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] mem [0:1023];

    // Instruction bytes use aligned word addresses; the file is relative to simulation cwd.
    initial $readmemh("C:/Users/brije/Downloads/Vivado_projects/RISC_V_v1/program.hex", mem);
    assign RD = (A[31:2] < 30'd1024) ? mem[A[11:2]] : 32'd0;
endmodule
