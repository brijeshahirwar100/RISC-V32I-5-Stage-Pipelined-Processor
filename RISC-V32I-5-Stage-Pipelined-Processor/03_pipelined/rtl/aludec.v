`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: aludec
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Decodes supported ALU functions and validates encodings.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module aludec (
    input  wire [1:0] ALUOp,
    input  wire [6:0] Op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControl,
    output reg        ALUValid
);
    // Legal function fields prevent unsupported instructions from writing state.
    always @(*) begin
        ALUControl = 4'b0000;
        ALUValid = 1'b0;
        case (ALUOp)
            2'b00: begin
                if ((Op == 7'b1101111) ||
                    (((Op == 7'b0000011) || (Op == 7'b0100011)) &&
                     (funct3 == 3'b010)))
                    ALUValid = 1'b1;
            end
            2'b01: begin
                if ((Op == 7'b1100011) && (funct3 == 3'b000)) begin
                    ALUControl = 4'b0001;
                    ALUValid = 1'b1;
                end
            end
            2'b10: begin
                if (Op == 7'b0110011) begin
                    case (funct3)
                        3'b000: begin
                            if (funct7 == 7'b0000000) begin
                                ALUControl = 4'b0000;
                                ALUValid = 1'b1;
                            end else if (funct7 == 7'b0100000) begin
                                ALUControl = 4'b0001;
                                ALUValid = 1'b1;
                            end
                        end
                        3'b010, 3'b110, 3'b111: begin
                            if (funct7 == 7'b0000000) begin
                                ALUValid = 1'b1;
                                case (funct3)
                                    3'b010: ALUControl = 4'b1000;
                                    3'b110: ALUControl = 4'b0011;
                                    3'b111: ALUControl = 4'b0010;
                                endcase
                            end
                        end
                        default: begin end
                    endcase
                end else if (Op == 7'b0010011) begin
                    case (funct3)
                        3'b000: begin ALUControl = 4'b0000; ALUValid = 1'b1; end
                        3'b010: begin ALUControl = 4'b1000; ALUValid = 1'b1; end
                        3'b110: begin ALUControl = 4'b0011; ALUValid = 1'b1; end
                        3'b111: begin ALUControl = 4'b0010; ALUValid = 1'b1; end
                        default: begin end
                    endcase
                end
            end
            default: begin end
        endcase
    end
endmodule
