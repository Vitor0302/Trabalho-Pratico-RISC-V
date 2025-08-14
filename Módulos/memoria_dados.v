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

    // Declaração da memória: 1024 posições de 32 bits.
    reg [31:0] data_memory [1023:0];

    // Inicialização da memória com zeros
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            data_memory[i] = 32'b0;
        end
    end

    // Lógica de Leitura: Combinacional.
    assign read_data = data_memory[address[11:2]];

    // Lógica de Escrita: Síncrona.
    always @(posedge clock) begin
        if (MemWrite) begin
            data_memory[address[11:2]] <= write_data;
        end
    end

endmodule
