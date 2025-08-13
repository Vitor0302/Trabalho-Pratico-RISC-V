`timescale 1ns/1ps

module testbench;

    reg clock;
    reg reset;
    integer i;

    // Instancia o nosso processador
    processador DUT (
        .clock(clock),
        .reset(reset)
    );

    // Geração do Clock
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // Período de 20ns
    end

    // Controle da Simulação e Inicialização
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, DUT);

        $display("\nIniciando simulacao do processador RISC-V - Grupo 12");
        $display("Instrucoes suportadas: lh, sh, sub, or, andi, srl, beq\n");

        // 1. Aplica o reset
        reset = 1;
        #15;
        reset = 0;

        // 2. ***** A CORREÇÃO CRÍTICA ESTÁ AQUI *****
        // Inicializa a Memória de Dados diretamente a partir do Testbench
        $display("--- INICIALIZANDO MEMORIA DE DADOS ---");
        DUT.u_dmem.data_memory[0] = 32'd10; // Força o valor 10 no endereço 0
        DUT.u_dmem.data_memory[1] = 32'd3;  // Força o valor 3 no endereço 4 (índice de palavra 1)
        
        // 3. Monitora a execução do programa
        $monitor("Time=%0t ns | PC=0x%h | Instr=0x%h", $time, DUT.w_pc_current, DUT.w_instruction);

        // 4. Roda a simulação por tempo suficiente e exibe o estado final
        #200;

        $display("\n================ ESTADO FINAL ================");
        $display("\n--- Registradores ---");
        for (i=0; i<32; i=i+4) begin
            $display("x%02d: 0x%h    x%02d: 0x%h    x%02d: 0x%h    x%02d: 0x%h",
                i, DUT.u_regfile.reg_memory[i], i+1, DUT.u_regfile.reg_memory[i+1],
                i+2, DUT.u_regfile.reg_memory[i+2], i+3, DUT.u_regfile.reg_memory[i+3]);
        end

        $display("\n--- Memoria de Dados (enderecos 0-36) ---");
        for (i=0; i<10; i=i+1) begin
            $display("Mem[%d]: 0x%h", i*4, DUT.u_dmem.data_memory[i]);
        end

        $display("\n--- Flags ---");
        $display("Zero Flag: %b", DUT.w_alu_zero_flag);
        $display("==========================================");

        $finish; // Encerra a simulação
    end

endmodule