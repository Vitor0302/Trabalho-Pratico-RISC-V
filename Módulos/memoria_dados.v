/*
 Módulo da Memória de Dados.
 Armazena os dados do programa.
 Realiza leituras de forma combinacional e escritas de forma síncrona.
*/
module Memoria_Dados (
    input         clock,
    input         MemWrite,      // Sinal que habilita a escrita
    input         MemRead,       // Sinal que habilita a leitura
    input  [31:0] address,       // Endereço vindo da ULA
    input  [31:0] write_data,    // Dado a ser escrito (vindo de rs2)
    output [31:0] read_data      // Dado lido da memória
);

    // Declaração da memória. Ex: 1024 posições de 32 bits.
    // Em um sistema real, seria muito maior.
    reg [31:0] data_memory [1023:0];

    // Lógica de Leitura: Combinacional.
    // Se MemRead estiver ativo, a saída recebe o valor da posição de memória.
    // Senão, a saída fica indefinida (alta impedância).
    assign read_data = MemRead ? data_memory[address[11:2]] : 32'hzzzzzzzz;


    // Lógica de Escrita: Síncrona.
    // Ocorre na borda de subida do clock.
    always @(posedge clock)
    begin
        // Só escreve se o sinal 'MemWrite' estiver ativo.
        if (MemWrite) 
        begin
            data_memory[address[11:2]] <= write_data;
        end
    end

endmodule