`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: tb_multi
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Checks architectural registers, unified memory, and halt cycles.
// 
// Dependencies: riscv_multi_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_multi;
    reg clk;
    reg reset;
    reg registers_ok;
    reg memory_ok;
    reg states_ok;
    reg halt_seen;
    reg recording_states;
    reg state_monitor_done;
    reg state_match;
    integer cycle_count;
    integer cycles_to_halt;
    integer states_failed;
    integer state_count;
    integer expected_count;
    integer state_index;
    reg [3:0] observed_states [0:4];
    reg [3:0] expected_states [0:4];
    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] Result;
    wire [31:0] WriteData;
    wire RegWrite;
    wire MemWrite;

    riscv_multi_top dut (
        .clk(clk), .reset(reset), .PC(PC), .Instr(Instr),
        .ALUResult(ALUResult), .ReadData(ReadData), .Result(Result),
        .WriteData(WriteData), .RegWrite(RegWrite), .MemWrite(MemWrite)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Collect each instruction's states and check them when the next Fetch starts.
    always @(posedge clk) begin
        if (reset) begin
            recording_states = 1'b0;
            state_monitor_done = 1'b0;
            state_count = 0;
            expected_count = 0;
        end else if (!state_monitor_done) begin
            if (dut.u_controller.u_mainfsm.state == 4'd0) begin
                if (recording_states) begin
                    state_match = (state_count == expected_count);
                    for (state_index = 0; state_index < state_count; state_index = state_index + 1) begin
                        if (observed_states[state_index] !== expected_states[state_index])
                            state_match = 1'b0;
                    end
                    if (!state_match)
                        states_failed = states_failed + 1;
                end

                if (PC === 32'd84) begin
                    recording_states = 1'b0;
                    state_monitor_done = 1'b1;
                end else begin
                    recording_states = 1'b1;
                    state_count = 1;
                    observed_states[0] = 4'd0;
                    expected_count = 0;
                end
            end else if (recording_states) begin
                observed_states[state_count] = dut.u_controller.u_mainfsm.state;
                state_count = state_count + 1;

                if (dut.u_controller.u_mainfsm.state == 4'd1) begin
                    case (dut.dp.IR[6:0])
                        7'b0010011: begin
                            expected_count = 4;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd8;
                            expected_states[3] = 4'd7;
                        end
                        7'b0110011: begin
                            expected_count = 4;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd6;
                            expected_states[3] = 4'd7;
                        end
                        7'b0000011: begin
                            expected_count = 5;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd2;
                            expected_states[3] = 4'd3;
                            expected_states[4] = 4'd4;
                        end
                        7'b0100011: begin
                            expected_count = 4;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd2;
                            expected_states[3] = 4'd5;
                        end
                        7'b1100011: begin
                            expected_count = 3;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd10;
                        end
                        7'b1101111: begin
                            expected_count = 4;
                            expected_states[0] = 4'd0;
                            expected_states[1] = 4'd1;
                            expected_states[2] = 4'd9;
                            expected_states[3] = 4'd7;
                        end
                        default: expected_count = 0;
                    endcase
                end
            end
        end
    end

    initial begin
        registers_ok = 1'b0;
        memory_ok = 1'b0;
        states_ok = 1'b0;
        halt_seen = 1'b0;
        cycle_count = 0;
        cycles_to_halt = 0;
        states_failed = 0;
        state_count = 0;
        expected_count = 0;
        recording_states = 1'b0;
        state_monitor_done = 1'b0;
        state_match = 1'b0;
        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;

        for (cycle_count = 0; cycle_count < 1000; cycle_count = cycle_count + 1) begin
            @(posedge clk);
            #1;
            if (!halt_seen && (PC === 32'd84)) begin
                cycles_to_halt = cycle_count + 1;
                halt_seen = 1'b1;
                $display("cycles to halt = %0d", cycles_to_halt);
            end
        end

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

        begin : print_register_status
            integer register_index;
            reg [31:0] actual_value;
            reg [31:0] expected_value;
            reg [63:0] status;

            for (register_index = 0; register_index <= 14; register_index = register_index + 1) begin
                actual_value = dut.dp.u_regfile.rf[register_index];
                case (register_index)
                    0: expected_value = 32'h00000000;
                    1: expected_value = 32'h00000005;
                    2: expected_value = 32'hFFFFFFFD;
                    3: expected_value = 32'h00000002;
                    4: expected_value = 32'h00000008;
                    5: expected_value = 32'h00000005;
                    6: expected_value = 32'hFFFFFFFD;
                    7: expected_value = 32'h00000001;
                    8: expected_value = 32'h00000002;
                    9: expected_value = 32'h00000009;
                    10: expected_value = 32'hFFFFFFFF;
                    11: expected_value = 32'h00000040;
                    12: expected_value = 32'h0000000C;
                    13: expected_value = 32'h00000009;
                    14: expected_value = 32'h00000001;
                    default: expected_value = 32'hxxxxxxxx;
                endcase

                if (actual_value === expected_value)
                    status = "OK      ";
                else
                    status = "MISMATCH";
                $display("x%0d actual=%h expected=%h %s", register_index,
                         actual_value, expected_value, status);
            end
        end

        memory_ok = (dut.u_mem.mem[22] === 32'd2) &&
                    (dut.u_mem.mem[23] === 32'd9);
        if (states_failed == 0)
            states_ok = 1'b1;

        if (registers_ok)
            $display("PASS: register checks");
        else
            $display("FAIL: register checks");
        if (memory_ok)
            $display("PASS: memory checks");
        else
            $display("FAIL: memory checks");
        if (states_ok)
            $display("PASS: state sequence checks");
        else
            $display("FAIL: state sequence checks");
        $finish;
    end
endmodule
