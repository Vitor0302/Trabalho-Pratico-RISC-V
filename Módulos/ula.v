module ULA (
    input  [31:0] in1, in2, 
    input  [3:0]  ula_control,
    output reg [31:0] ula_result,
    output reg        zero_flag
);

    always @(*)
    begin
        // Bloco case para selecionar a operação
        case(ula_control)
            4'b0000: ula_result = in1 & in2;  // AND
            4'b0001: ula_result = in1 | in2;  // OR
            4'b0010: ula_result = in1 + in2;  // ADD
            4'b0100: ula_result = in1 - in2;  // SUB
            4'b0101: ula_result = in1 >> in2;  // SRL
            4'b0011: ula_result = in1 << in2;  // SLL (extra)
            4'b0110: ula_result = in1 * in2;  // Multiply (extra)
            4'b0111: ula_result = in1 ^ in2;  // XOR (extra)
            4'b1000: begin                   // SLT (extra)
                if(in1 < in2)
                    ula_result = 32'd1;
                else
                    ula_result = 32'd0;
            end
            default: ula_result = 32'hxxxxxxxx; // Saída indefinida para controle inválido
        endcase

        // Lógica para a flag 'zero', fora do case
        if (ula_result == 32'd0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
    end

endmodule
