/* 
Módulo de Banco de Registradores
Este módulo implementa um banco de registradores de 32 bits com 32 registradores.
Ele permite leitura e escrita síncrona, além de reset para inicialização dos registradores.
*/

module REG_FILE(
    input  [4:0]  read_reg_num1,
    input  [4:0]  read_reg_num2,
    input  [4:0]  write_reg,
    input  [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    input         regwrite,
    input         clock,
    input         reset
);

    reg [31:0] reg_memory [0:31];
    integer i;

    // Lógica de Leitura Combinacional
    assign read_data1 = (read_reg_num1 == 5'b0) ? 32'b0 : reg_memory[read_reg_num1];
    assign read_data2 = (read_reg_num2 == 5'b0) ? 32'b0 : reg_memory[read_reg_num2];

    // Lógica de escrita e reset UNIFICADA E SÍNCRONA
    always @(posedge clock or posedge reset)
    begin
        // Se o reset for ativado (reset == 1), inicializa os registradores
        if (reset) begin
            // Usando um loop para inicializar
            for (i=0; i<32; i=i+1) begin
                reg_memory[i] <= i;
            end
        end
        // Senão, é um ciclo de clock normal
        else begin
            // E a lógica de escrita normal é executada
            if (regwrite && (write_reg != 5'b0)) begin
                reg_memory[write_reg] <= write_data;
            end
        end
    end

endmodule