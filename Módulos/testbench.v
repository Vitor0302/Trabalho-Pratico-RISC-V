/*
Testbench para o Processador RISC-V Monociclo
Este testbench simula o processador, aplicando um reset inicial e monitorando a execução de um programa de teste.
Ele gera um log detalhado, ciclo a ciclo, e verifica o estado final dos registradores e da memória de dados.
*/

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

    // Controle da Simulação, Inicialização e LOG DETALHADO
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, DUT);

        $display("\nIniciando simulacao do processador RISC-V - Grupo 12");
        $display("Instrucoes suportadas: lh, sh, sub, or, andi, srl, beq\n");

        // 1. Aplica o reset
        reset = 1;
        #15;
        reset = 0;

        // 2. Inicializa a Memória de Dados diretamente a partir do Testbench
        $display("--- INICIALIZANDO MEMORIA DE DADOS ---");
        DUT.u_dmem.data_memory[0] = 32'd10; // Força o valor 10 no endereço 0
        DUT.u_dmem.data_memory[1] = 32'd3;  // Força o valor 3 no endereço 4 (índice de palavra 1)
        
        $display("\n--- INICIO DA EXECUCAO DO PROGRAMA ---\n");

        // --- 3. Execução Ciclo a Ciclo com Log Detalhado ---
        // Em vez de um $monitor, esperamos um ciclo e imprimimos o resultado específico.

        // Ciclo 1: Executa a primeira instrução (lh x10, 0(x0))
        #20; // Avança um ciclo de clock (20ns)
        $display(">> PC=0x00, Executando lh x10, 0(x0)");
        $display("   Lido da Mem[0] o valor %d. Escrito em x10.", DUT.u_dmem.data_memory[0]);
        $display("   Resultado: x10 = %d\n", DUT.u_regfile.reg_memory[10]);

        // Ciclo 2: Executa a segunda instrução (lh x11, 4(x0))
        #20;
        $display(">> PC=0x04, Executando lh x11, 4(x0)");
        $display("   Lido da Mem[4] o valor %d. Escrito em x11.", DUT.u_dmem.data_memory[1]);
        $display("   Resultado: x11 = %d\n", DUT.u_regfile.reg_memory[11]);
        
        // Ciclo 3: Executa a terceira instrução (sub x12, x10, x11)
        #20;
        $display(">> PC=0x08, Executando sub x12, x10, x11");
        $display("   Calculado %d - %d. Escrito em x12.", DUT.u_regfile.reg_memory[10], DUT.u_regfile.reg_memory[11]);
        $display("   Resultado: x12 = %d\n", DUT.u_regfile.reg_memory[12]);
        
        // Ciclo 4: Executa a quarta instrução (or x13, x10, x11)
        #20;
        $display(">> PC=0x0C, Executando or x13, x10, x11");
        $display("   Calculado %d | %d. Escrito em x13.", DUT.u_regfile.reg_memory[10], DUT.u_regfile.reg_memory[11]);
        $display("   Resultado: x13 = %d\n", DUT.u_regfile.reg_memory[13]);
        
        // Ciclo 5: Executa a quinta instrução (andi x14, x10, 8)
        #20;
        $display(">> PC=0x10, Executando andi x14, x10, 8");
        $display("   Calculado %d & 8. Escrito em x14.", DUT.u_regfile.reg_memory[10]);
        $display("   Resultado: x14 = %d\n", DUT.u_regfile.reg_memory[14]);
        
        // Ciclo 6: Executa a sexta instrução (srl x15, x10, 1)
        #20;
        $display(">> PC=0x14, Executando srl x15, x10, 1");
        $display("   Calculado %d >> 1. Escrito em x15.", DUT.u_regfile.reg_memory[10]);
        $display("   Resultado: x15 = %d\n", DUT.u_regfile.reg_memory[15]);
        
        // Ciclo 7: Executa a sétima instrução (beq x14, x10, 4)
        #20;
        $display(">> PC=0x18, Executando beq x14, x10, 4");
        $display("   Comparando x14(%d) e x10(%d). Como sao diferentes, o desvio NAO eh tomado.\n", DUT.u_regfile.reg_memory[14], DUT.u_regfile.reg_memory[10]);
        
        // Ciclo 8: Executa a oitava instrução (sh x12, 8(x0))
        #20;
        $display(">> PC=0x1C, Executando sh x12, 8(x0)");
        $display("   Escrito o valor de x12(%d) no endereco de memoria 8. Verificacao no estado final.\n", DUT.u_regfile.reg_memory[12]);

        // Ciclo 9: Executa a nona instrução (beq x0, x0, 0)
        #20;
        $display(">> PC=0x20, Executando beq x0, x0, 0");
        $display("   Comparando x0(0) e x0(0). Como sao iguais, o desvio eh tomado.");
        // Verifica e anuncia a mudança da Zero Flag
        if (DUT.w_alu_zero_flag == 1'b1) begin
            $display("   ** A ULA calculou 0 - 0, a Zero Flag foi ativada (0 -> 1)! **\n");
        end

        // Mais um ciclo para vermos o PC travar em 0x20
        #20; 
        $display(">> PC=0x20, Processador em loop final.");

        // 4. Exibe o estado final geral
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