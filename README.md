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
├── Módulos/                      # Códigos-fonte em Verilog
│   ├── alu.v
│   ├── datapath.v
│   ├── control.v
│   └── ...
├── Documentação/                      # Documentação em LaTeX (formato SBC)
│   └── relatorio.pdf
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
- Objetivos
- Metodologias
- Análise de Resultados
- Conclusão
- Referências bibliográficas

---

## 👨‍🏫 Professor
**Racyus Delano Garcia Pacífico**

---

## ✅ Autores

- [Victor Pureza Cabral]
- [Otávio Augusto Ferreira]
