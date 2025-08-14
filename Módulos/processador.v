/*
Módulo Top-Level do Processador RISC-V Monociclo.
Grupo 12: lh, sh, sub, or, andi, srl, beq
Este módulo integra todos os componentes do processador, incluindo a memória de instrução, banco de registradores, 
memória de dados, ULA e unidades de controle.    
*/
module processador(
    input clock,
    input reset
);

    // =================================================================
    // --- 1. FIOS (WIRES) E REGISTRADORES (REGS) ---
    // =================================================================
    
    // -- Sinais de Controle
    wire        w_RegWrite, w_ALUSrc, w_MemToReg, w_MemRead, w_MemWrite, w_Branch;
    wire [1:0]  w_ALUOp;
    wire [3:0]  w_Final_ALU_Control;

    // -- Barramentos de Dados
    reg  [31:0] w_pc_current;
    wire [31:0] w_pc_next, w_pc_plus_4, w_pc_branch_target;
    
    wire [31:0] w_instruction;
    wire [31:0] w_read_data_1, w_read_data_2;
    wire [31:0] w_immediate_extended;
    wire [31:0] w_alu_input_2;
    wire [31:0] w_alu_result;
    wire        w_alu_zero_flag;
    wire [31:0] w_mem_read_data;
    wire [31:0] w_write_data_to_regfile;
    
    // --- Fatiamento da Instrução
    wire [6:0] opcode = w_instruction[6:0];
    wire [4:0] rd     = w_instruction[11:7];
    wire [2:0] funct3 = w_instruction[14:12];
    wire [4:0] rs1    = w_instruction[19:15];
    wire [4:0] rs2    = w_instruction[24:20];
    wire [6:0] funct7 = w_instruction[31:25];


    // =================================================================
    // --- 2. CAMINHO DE DADOS (INSTÂNCIAS DOS MÓDULOS) ---
    // =================================================================

    // --- Estágio IF: Busca de Instrução ---
    
    // Registrador do PC
    always @(posedge clock or posedge reset) begin
        if (reset)
            w_pc_current <= 32'b0;
        else
            w_pc_current <= w_pc_next;
    end

    // Memória de Instrução (Modelada como ROM, precisa ser pré-carregada no testbench)
    Memoria_Instrucao u_imem (
        .address(w_pc_current), 
        .instruction(w_instruction)
    );

    // Lógica de cálculo do próximo PC
    assign w_pc_plus_4 = w_pc_current + 32'd4;
    assign w_pc_branch_target = w_pc_current + w_immediate_extended;
    assign w_pc_next = (w_Branch & w_alu_zero_flag) ? w_pc_branch_target : w_pc_plus_4;
    
    // --- Estágio ID: Decodificação e Banco de Registradores ---

    // Instância do Banco de Registradores
    REG_FILE u_regfile (
        .clock(clock), .reset(reset),
        .regwrite(w_RegWrite),
        .read_reg_num1(rs1),
        .read_reg_num2(rs2),
        .write_reg(rd),
        .write_data(w_write_data_to_regfile),
        .read_data1(w_read_data_1),
        .read_data2(w_read_data_2)
    );

    // Unidade de Extensão de Sinal
    assign w_immediate_extended = (opcode == 7'b0100011) ? {{20{w_instruction[31]}}, w_instruction[31:25], w_instruction[11:7]} : // Tipo-S (sh)
                                 (opcode == 7'b1100011) ? {{20{w_instruction[31]}}, w_instruction[7], w_instruction[30:25], w_instruction[11:8], 1'b0} : // Tipo-B (beq)
                                 {{20{w_instruction[31]}}, w_instruction[31:20]}; // Tipo-I (lh, andi)
    
    // --- Estágio EX: Execução ---

    // MUX para a segunda entrada da ULA
    assign w_alu_input_2 = w_ALUSrc ? w_immediate_extended : w_read_data_2;

    // Sinal de controle para a ULA
    ULA u_alu (
        .in1(w_read_data_1),
        .in2(w_alu_input_2),
        .ula_control(w_Final_ALU_Control),
        .ula_result(w_alu_result),
        .zero_flag(w_alu_zero_flag)
    );
  
    // --- Estágio MEM: Acesso à Memória ---

    // Instância da Memória de Dados
    Memoria_Dados u_dmem (
        .clock(clock),
        .MemWrite(w_MemWrite),
        .MemRead(w_MemRead),
        .address(w_alu_result),
        .write_data(w_read_data_2),
        .read_data(w_mem_read_data)
    );

    // --- Estágio WB: Escrita de Volta ---

    // MUX final que escolhe o dado a ser escrito no registrador
    assign w_write_data_to_regfile = w_MemToReg ? w_mem_read_data : w_alu_result;

    // =================================================================
    // --- 3. UNIDADE DE CONTROLE (INSTÂNCIAS) ---
    // =================================================================

    // Instância da Unidade de Controle Principal
    Unidade_Controle_Principal u_main_control (
        .opcode(opcode),
        .RegWrite(w_RegWrite),
        .ALUSrc(w_ALUSrc),
        .MemToReg(w_MemToReg),
        .MemRead(w_MemRead),
        .MemWrite(w_MemWrite),
        .Branch(w_Branch),
        .ALUOp(w_ALUOp)
    );
    
    // Instância da Unidade de Controle da ULA
    Unidade_Controle_ULA u_alu_control (
        .ALUOp(w_ALUOp),
        .funct7(funct7),
        .funct3(funct3),
        .alu_control_out(w_Final_ALU_Control)
    );

endmodule