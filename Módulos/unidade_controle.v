/*
 Módulo da Unidade de Controle da ULA.
 Recebe o sinal ALUOp da Controle Principal e os functs da instrução.
 Gera o sinal final de 4 bits que comanda a ULA.
*/
module Unidade_Controle_ULA (
    input  [1:0]  ALUOp,    // Vindo da Controle Principal
    input  [6:0]  funct7,
    input  [2:0]  funct3,
    output reg [3:0]  alu_control_out // Saída final para a ULA
);

    // Códigos das operações da nossa ULA (para referência)
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR  = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_SUB = 4'b0100;
    localparam ALU_SRL = 4'b0101;

    always @(*) begin
        // A lógica principal é um 'case' no ALUOp
        case (ALUOp)

            // Caso 1: A Controle Principal já sabe que é uma SOMA (para lh, sh)
            2'b00: begin
                alu_control_out = ALU_ADD;
            end

            // Caso 2: A Controle Principal sabe que é uma SUBTRAÇÃO (para beq)
            2'b01: begin
                alu_control_out = ALU_SUB;
            end

            // Caso 3: É uma instrução do Tipo-R. Precisamos olhar os functs.
            // Aqui entra o seu código original!
            2'b10: begin
                case (funct3)
                    3'b000: begin // ADD ou SUB
                        if (funct7 == 7'b0100000)
                            alu_control_out = ALU_SUB; // sub
                        else
                            alu_control_out = ALU_ADD; // add (não está na sua lista, mas é bom ter)
                    end
                    3'b110: begin // OR
                        alu_control_out = ALU_OR;
                    end
                    3'b101: begin // SRL
                        // Precisamos garantir que é o SRL (funct7=0) e não o SRA
                        if (funct7 == 7'b0000000)
                           alu_control_out = ALU_SRL;
                        else
                           alu_control_out = 4'hX; // Indefinido
                    end
                    // Adicionar outros casos de funct3 do seu conjunto aqui se necessário...
                    default: alu_control_out = 4'hX; // Operação Tipo-R desconhecida
                endcase
            end

            // Adicionar outros casos para ALUOp aqui (ex: para o ANDI)
            // Por exemplo, podemos definir ALUOp = 11 para AND
            2'b11: begin
                alu_control_out = ALU_AND; // Para o andi
            end

            default: alu_control_out = 4'hX; // ALUOp desconhecido

        endcase
    end

endmodule