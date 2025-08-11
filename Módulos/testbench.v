/*
 Testbench completo para o Processador RISC-V Monociclo do Grupo 12.
 Monitora todos os 32 registradores e posições relevantes da memória.
*/
`timescale 1ns/1ps

module testbench;

    // Sinais de controle
    reg clock;
    reg reset;

    // Instância do processador
    processador DUT (
        .clock(clock),
        .reset(reset)
    );

    // Geração do clock (período de 20ns)
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    // Controle da simulação
    initial begin
        // Configuração do arquivo de onda
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);

        // 1. Inicialização com reset
        reset = 1;
        #15 reset = 0;
        
        // 2. Mensagem inicial
        $display("\nIniciando simulacao do processador RISC-V - Grupo 12");
        $display("Instrucoes suportadas: lh, sh, sub, or, andi, srl, beq\n");

        // 3. Monitoramento durante a execução
        $monitor("Time=%0t ns | PC=0x%h | Instr=0x%h", 
                 $time, 
                 DUT.w_pc_current, 
                 DUT.w_instruction);

        // 4. Finalização e relatório
        #300; // Executa por 300ns
        print_final_state();
        $finish;
    end

    // Tarefa para imprimir o estado final
    task print_final_state;
        begin
            $display("\n================ ESTADO FINAL ================");
            
            // Registradores
            $display("\n--- Registradores ---");
            for (integer i = 0; i < 32; i = i+4) begin
                $display("x%02d: 0x%h \t x%02d: 0x%h \t x%02d: 0x%h \t x%02d: 0x%h", 
                         i, DUT.u_regfile.reg_memory[i],
                         i+1, DUT.u_regfile.reg_memory[i+1],
                         i+2, DUT.u_regfile.reg_memory[i+2],
                         i+3, DUT.u_regfile.reg_memory[i+3]);
            end

            // Memória de dados (primeiras 10 palavras)
            $display("\n--- Memoria de Dados (enderecos 0-36) ---");
            for (integer j = 0; j < 10; j++) begin
                $display("Mem[%0d]: 0x%h", j*4, DUT.u_dmem.data_memory[j]);
            end

            // Estado especial
            $display("\n--- Flags ---");
            $display("Zero Flag: %b", DUT.u_alu.zero_flag);
            $display("==========================================\n");
        end
    endtask

endmodule