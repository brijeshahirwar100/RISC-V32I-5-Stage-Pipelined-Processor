`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: tb_single
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Runs the program and checks register and memory results.
// 
// Dependencies: riscv_single_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_single;
    reg clk, reset;
    reg registers_ok, memory_ok;
    wire [31:0] PC, Instr, ALUResult, ReadData, Result, WriteData;
    wire RegWrite, MemWrite;

    riscv_single_top dut (
        .clk(clk), .reset(reset), .PC(PC), .Instr(Instr),
        .ALUResult(ALUResult), .ReadData(ReadData), .Result(Result),
        .WriteData(WriteData), .RegWrite(RegWrite), .MemWrite(MemWrite)
    );

    // The clock and reset define the two reset edges and 200 run cycles.
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (200) @(posedge clk);
        #1;

        registers_ok =
            (dut.dp.u_regfile.rf[0] === 32'h00000000) &&
            (dut.dp.u_regfile.rf[1] === 32'h00000005) &&
            (dut.dp.u_regfile.rf[2] === 32'hFFFFFFFD) &&
            (dut.dp.u_regfile.rf[3] === 32'h00000002) &&
            (dut.dp.u_regfile.rf[4] === 32'h00000008) &&
            (dut.dp.u_regfile.rf[5] === 32'h00000005) &&
            (dut.dp.u_regfile.rf[6] === 32'hFFFFFFFD) &&
            (dut.dp.u_regfile.rf[7] === 32'h00000001) &&
            (dut.dp.u_regfile.rf[8] === 32'h00000002) &&
            (dut.dp.u_regfile.rf[9] === 32'h00000009) &&
            (dut.dp.u_regfile.rf[10] === 32'hFFFFFFFF) &&
            (dut.dp.u_regfile.rf[11] === 32'h00000040) &&
            (dut.dp.u_regfile.rf[12] === 32'h0000000C) &&
            (dut.dp.u_regfile.rf[13] === 32'h00000009) &&
            (dut.dp.u_regfile.rf[14] === 32'h00000001);
        memory_ok = (dut.u_data_mem.mem[0] === 32'd2) &&
                    (dut.u_data_mem.mem[1] === 32'd9);

        if (registers_ok && memory_ok)
            $display("PASS: register and memory checks");
        else
            $display("FAIL: register or memory mismatch");
        $finish;
    end
endmodule
