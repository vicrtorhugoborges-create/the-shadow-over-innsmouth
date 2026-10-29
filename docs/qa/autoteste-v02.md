# Autoteste da 0.2.0 — 27/10/2026

Pedido do usuário: "teste por conta própria caso possível". O que um agente consegue testar sem um jogador humano foi feito abaixo; o que não consegue está listado no fim.

## 1. Navegação andando de verdade (`tests/walkthrough.gd`)

Um andarilho percorre as rotas dos capítulos V–VII com **input real de movimento** (câmera girada como pelo mouse, tecla de avançar pressionada), sem teletransporte entre os pontos. Percepção e cerco desligados: o alvo é só a geometria.

| Rodada | Resultado | Achado |
|---|---|---|
| 1 | 13/24 | **Defeito real:** cada vestíbulo tinha um bloco sólido no centro — os esconderijos obrigatórios (Bates, portal da Washington, Babson) eram inalcançáveis a pé. Os testes por teletransporte não detectavam isso. Corrigido (o nicho é a célula vazia da grade). |
| 2 | 22/24 | Caminho do teste cortava pela rampa e batia na laje (não é defeito de jogo); percurso ajustado. |
| 3 | **24/24** | Praça, saguão, corredor e quartos, passagem 428 → n1 → n2, telhado até a claraboia, escadas do armazém, pátio, sala das venezianas, toda a rota noturna até o corte. [Log](walkthrough-v02.log) |

## 2. Desempenho medido (export de release, 1920×1080, vsync desligado, 6 s por cena)

Máquina de teste: Intel i7-13650HX, NVIDIA GeForce RTX 4060 Laptop (OpenGL 3.3, Compatibility), 15,7 GB. **Não representa o requisito mínimo** (docs/19, Q-021).

| Cena | Média | p99 | Pior quadro | Chamadas de desenho |
|---|---|---|---|---|
| Praça ao crepúsculo (`cp05_return`) | 1,02 ms | 1,31 ms | 6,67 ms | 517 |
| Quarto 428 (`cp05_room`) | 1,21 ms | 1,65 ms | 5,22 ms | 521 |
| Pátio (`cp06_courtyard`) | 1,30 ms | 1,66 ms | 3,27 ms | 1.045 |
| Praça noturna e recife | 1,00 ms | 1,46 ms | 4,45 ms | 522 → **40** |
| Washington noturna | 2,08 ms | 2,65 ms | 3,69 ms | 1.657 → **55** |
| Procissão (corte) | 0,85 ms | 1,08 ms | 5,04 ms | 235 |

**Achado:** a cidade noturna desenhava cada caixa separadamente (1.657 chamadas), um risco para GPUs integradas. `WorldKit.merge_static` agora funde a geometria estática por material; as colisões continuam nos nós originais. Valores após a fusão medidos na execução do projeto (debug); imagem conferida idêntica. [Log](desempenho-v02.log)

## 3. Níveis de áudio (`tests/audio_levels.gd`)

| Antes | Depois |
|---|---|
| 6 sons saturando em 0 dBFS (`amb_sea`, `ph_bell`, `ph_blow`, `ph_crash`, `ph_croak_low`, `ph_key`) e 1 inaudível (`amb_room`, pico −24 dBFS) | 0 fora da faixa: todos normalizados a pico −3 dBFS na síntese; o equilíbrio fica no volume de reprodução. [Log](audio-niveis-v02.log) |

## 4. O que continua dependendo de um humano

- Sensação de controle (mouse, teclado, controle físico), conforto da câmera e enjoo.
- Se os sons provisórios são agradáveis, legíveis e assustadores — os números acima só garantem que não saturam nem somem.
- Legibilidade da noite em monitores comuns e no brilho de cada pessoa.
- Calibragem fina da percepção e dos prazos, e se o jogo assusta.
- Desempenho em hardware fraco (GPU integrada): esta máquina força a NVIDIA; medir em um PC de referência (Q-021).
