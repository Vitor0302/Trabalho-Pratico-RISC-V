// /*
//  Módulo da Memória de Instrução (ROM).
//  Armazena as instruções do programa a ser executado.
//  O conteúdo é carregado a partir de um arquivo externo no início da simulação.
// */
// module Memoria_Instrucao (
//     input  [31:0] address,       // Endereço vindo do PC
//     output [31:0] instruction    // Instrução de 32 bits lida da memória
// );

//     // Declaração da memória. Ex: 256 posições de 32 bits.
//     // O tamanho pode ser ajustado conforme a necessidade do programa.
//     reg [31:0] rom_memory [0:255];

//     // -- O "Pulo do Gato": Carregando o Programa --
//     // Este bloco 'initial' é executado apenas UMA VEZ no início da simulação.
//     // O comando $readmemh lê o arquivo "programa.hex" e carrega seu conteúdo
//     // para dentro da nossa 'rom_memory'.
//     initial begin
//         $readmemh("programa.hex", rom_memory);
//     end

//     // Lógica de Leitura: Combinacional.
//     // O endereço do PC é um endereço de byte, mas nossa memória é um array de
//     // palavras de 32 bits (4 bytes). Por isso, ignoramos os 2 bits menos
//     // significativos do endereço para selecionar a palavra correta.
//     assign instruction = rom_memory[address[9:2]]; // Usamos [9:2] para 256 palavras.

// endmodule

/*
 Módulo da Memória de Instrução (ROM) - VERSÃO DE DEPURAÇÃO
 O programa está "hardcoded" para garantir o carregamento correto.
*/
module Memoria_Instrucao (
    input  [31:0] address,
    output [31:0] instruction
);

    reg [31:0] rom_memory [0:255];

    // -- DEBUG: Carregando o programa diretamente na memória --
    initial begin
        // Comentamos a linha que lê o arquivo externo
        // $readmemh("programa.hex", rom_memory); 

        // E colocamos os valores na mão
        rom_memory[0] = 32'h00001503; // 0x00: lh x10, 0(x0)
        rom_memory[1] = 32'h00401583; // 0x04: lh x11, 4(x0)
        rom_memory[2] = 32'h40b50633; // 0x08: sub x12, x10, x11
        rom_memory[3] = 32'h00b566b3; // 0x0C: or x13, x10, x11
        rom_memory[4] = 32'h00857713; // 0x10: andi x14, x10, 8
        rom_memory[5] = 32'h001557b3; // 0x14: srl x15, x10, 1
        rom_memory[6] = 32'h00a70263; // 0x18: beq x14, x10, 4
        rom_memory[7] = 32'h00c02423; // 0x1C: sh x12, 8(x0)
        rom_memory[8] = 32'h00000063; // 0x20: beq x0, x0, 0
    end

    assign instruction = rom_memory[address[9:2]];

endmodule