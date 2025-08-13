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