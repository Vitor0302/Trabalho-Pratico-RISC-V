/*
 Testbench para o Processador RISC-V Monociclo do Grupo 12.
*/
`timescale 1ns/1ps

module testbench;

    // Sinais que o testbench vai gerar para o processador
    reg clock;
    reg reset;

    // --- Instância do nosso Processador (Device Under Test - DUT) ---
    // Note que o testbench não tem portas de entrada ou saída.
    processador DUT (
        .clock(clock),
        .reset(reset)
    );

    // --- Geração do Clock ---
    // Este bloco 'initial' define o comportamento do clock.
    initial begin
        clock = 0; // Começa em 0
        forever #10 clock = ~clock; // A cada 10 unidades de tempo, o clock inverte.
                                      // Isso nos dá um período de 20ns.
    end

    // --- Controle da Simulação e Monitoramento ---
    initial begin
        // Configuração para gerar o arquivo de forma de onda (VCD)
        // que pode ser aberto em programas como o GTKWave.
        $dumpfile("dump.vcd");
        $dumpvars(0, DUT);

        // 1. Aplica o pulso de reset no início
        reset = 1;
        #15; // Mantém o reset ativo por 15ns
        reset = 0;

        // 2. Monitora os sinais que nos interessam a cada ciclo de clock
        // Vamos "espionar" o PC e os registradores que nosso programa usa.
        $monitor("Time=%0t | PC=0x%h | x10=%d | x11=%d | x12=%d | x13=%d | x14=%d | x15=%d",
                 $time, 
                 DUT.w_pc_current, 
                 DUT.u_regfile.reg_memory[10],
                 DUT.u_regfile.reg_memory[11],
                 DUT.u_regfile.reg_memory[12],
                 DUT.u_regfile.reg_memory[13],
                 DUT.u_regfile.reg_memory[14],
                 DUT.u_regfile.reg_memory[15]
        );

        // 3. Roda a simulação por um tempo e depois termina
        #300; // Deixa a simulação rodar por 300ns
        $finish; // Encerra a simulação
    end

endmodule