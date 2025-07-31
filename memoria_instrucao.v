/*
 Módulo da Memória de Instrução (ROM).
 Armazena as instruções do programa a ser executado.
 O conteúdo é carregado a partir de um arquivo externo no início da simulação.
*/
module Memoria_Instrucao (
    input  [31:0] address,       // Endereço vindo do PC
    output [31:0] instruction    // Instrução de 32 bits lida da memória
);

    // Declaração da memória. Ex: 256 posições de 32 bits.
    // O tamanho pode ser ajustado conforme a necessidade do programa.
    reg [31:0] rom_memory [255:0];

    // -- O "Pulo do Gato": Carregando o Programa --
    // Este bloco 'initial' é executado apenas UMA VEZ no início da simulação.
    // O comando $readmemh lê o arquivo "programa.hex" e carrega seu conteúdo
    // para dentro da nossa 'rom_memory'.
    initial begin
        $readmemh("programa.hex", rom_memory);
    end

    // Lógica de Leitura: Combinacional.
    // O endereço do PC é um endereço de byte, mas nossa memória é um array de
    // palavras de 32 bits (4 bytes). Por isso, ignoramos os 2 bits menos
    // significativos do endereço para selecionar a palavra correta.
    assign instruction = rom_memory[address[9:2]]; // Usamos [9:2] para 256 palavras.

endmodule