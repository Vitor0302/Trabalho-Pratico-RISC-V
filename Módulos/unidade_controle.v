/*
 =================================================================
 Módulo da Unidade de Controle Principal ("CEO") - VERSÃO CORRETA
 =================================================================
*/
module Unidade_Controle_Principal (
    input  [6:0] opcode,
    output reg    RegWrite,
    output reg    ALUSrc,
    output reg    MemToReg,
    output reg    MemRead,
    output reg    MemWrite,
    output reg    Branch,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Valores padrão seguros para evitar comportamento inesperado
        RegWrite = 1'b0; ALUSrc = 1'b0; MemToReg = 1'b0; MemRead  = 1'b0;
        MemWrite = 1'b0; Branch = 1'b0; ALUOp    = 2'bxx; // Indefinido

        case (opcode)
            // Tipo-R (sub, or, srl)
            7'b0110011: begin
                RegWrite = 1'b1; ALUSrc = 1'b0; MemToReg = 1'b0; MemRead = 1'b0;
                MemWrite = 1'b0; Branch = 1'b0; ALUOp    = 2'b10; // Usar Functs
            end
            // Tipo-I Load (lh)
            7'b0000011: begin
                RegWrite = 1'b1; ALUSrc = 1'b1; MemToReg = 1'b1; MemRead = 1'b1;
                MemWrite = 1'b0; Branch = 1'b0; ALUOp    = 2'b00; // SOMA
            end
            // Tipo-I Imediato (andi)
            7'b0010011: begin
                RegWrite = 1'b1; ALUSrc = 1'b1; MemToReg = 1'b0; MemRead = 1'b0;
                MemWrite = 1'b0; Branch = 1'b0; ALUOp    = 2'b11; // AND
            end
            // Tipo-S Store (sh)
            7'b0100011: begin
                RegWrite = 1'b0; ALUSrc = 1'b1; MemToReg = 1'bx; // Don't Care
                MemRead  = 1'b0; MemWrite = 1'b1; Branch = 1'b0; ALUOp    = 2'b00; // SOMA
            end
            // Tipo-B Branch (beq)
            7'b1100011: begin
                RegWrite = 1'b0; ALUSrc = 1'b0; MemToReg = 1'bx; // Don't Care
                MemRead  = 1'b0; MemWrite = 1'b0; Branch = 1'b1; ALUOp    = 2'b01; // SUB
            end
        endcase
    end
endmodule


/*
 =================================================================
 Módulo da Unidade de Controle da ULA ("Gerente Especialista")
 =================================================================
*/
module Unidade_Controle_ULA (
    input  [1:0]  ALUOp,
    input  [6:0]  funct7,
    input  [2:0]  funct3,
    output reg [3:0]  alu_control_out
);
    localparam ALU_AND = 4'b0000, ALU_OR  = 4'b0001, ALU_ADD = 4'b0010, ALU_SUB = 4'b0100, ALU_SRL = 4'b0101;

    always @(*) begin
        case (ALUOp)
            2'b00: alu_control_out = ALU_ADD; // Comando para SOMA
            2'b01: alu_control_out = ALU_SUB; // Comando para SUB
            2'b11: alu_control_out = ALU_AND; // Comando para AND
            2'b10: begin // Comando para decodificar Tipo-R
                case (funct3)
                    3'b000: if (funct7 == 7'b0100000) alu_control_out = ALU_SUB; else alu_control_out = ALU_ADD;
                    3'b110: alu_control_out = ALU_OR;
                    3'b101: if (funct7 == 7'b0000000) alu_control_out = ALU_SRL; else alu_control_out = 4'hX;
                    default: alu_control_out = 4'hX;
                endcase
            end
            default: alu_control_out = 4'hX;
        endcase
    end
endmodule