# 🚀 Trabalho Prático – RISC-V (CSI509)

Repositório do Trabalho Prático 1 da disciplina **CSI509 – Organização e Arquitetura de Computadores II** (UFOP – Engenharia da Computação). O objetivo é implementar um processador RISC-V simplificado, suportando um subconjunto de instruções.

---

## 📌 Grupo: [12]
### Instruções implementadas:
- `lh`
- `sh`
- `sub`
- `or`
- `andi`
- `srl`
- `beq`

---

## 📁 Estrutura do Repositório

```plaintext
├── src/                      # Códigos-fonte em Verilog
│   ├── alu.v
│   ├── datapath.v
│   ├── control.v
│   └── ...
├── quartus/                  # Projeto para síntese no Quartus (Mercúrio IV)
│   └── [arquivos .qpf, .qsf...]
├── doc/                      # Documentação em LaTeX (formato SBC)
│   └── relatorio.pdf
├── testbench/                # Testbench para simulação
│   └── tb_processor.v
├── dados/
│   ├── codigo.asm            # Código de teste em assembly RISC-V
│   ├── codigo_binario.txt    # Instruções em binário (ROM)
│   ├── regs_iniciais.txt     # Estado inicial dos registradores
│   └── memoria_dados.txt     # Estado inicial da memória de dados
└── README.md
```
---

## 🧪 Testbench

O testbench simula o funcionamento do processador, exibindo no terminal o estado dos 32 registradores e da memória de dados após a execução. Um clock automático é usado, e os resultados são comparados com os valores esperados.

---

## 🔧 Implementação no FPGA

- **Placa:** Mercúrio IV (UFOP)
- **Clock e Reset:** Conectados a botões/switches da placa
- **Display de 7 segmentos:** Exibe o Program Counter (PC)

---

## 📄 Documentação

A documentação está em formato SBC (LaTeX), contendo:

- Introdução
- Desenvolvimento do caminho de dados
- Resultados da simulação e execução na FPGA
- Considerações finais
- Referências bibliográficas

---

## 👨‍🏫 Professor
**Racyus Delano Garcia Pacífico**

---

## ✅ Autores

- [Victor Pureza Cabral]
- [Otávio Augusto Ferreira]
