# 00 — Visão geral

> **Estado:** implementação autorizada em 27/10/2026. Existe a fatia vertical 0.1.0 do Gilman House com arte e som provisórios (ver `28-ESTADO-IMPLEMENTACAO.md`). O restante deste documento é **proposta**; números de duração, desempenho e custo são **hipóteses não medidas**.

## 1. Proposta em uma frase

Um jogo de horror cósmico em primeira pessoa, com estética 3D de baixa fidelidade inspirada no PlayStation 1, que adapta integralmente *The Shadow over Innsmouth* (H. P. Lovecraft, 1936): da curiosidade de um jovem antiquário em Newburyport até a noite de fuga em Innsmouth e a descoberta, anos depois, de que a cidade que o aterrorizou é a sua origem.

## 2. Ficha

| Item | Decisão |
|---|---|
| Nome provisório | The Shadow Over Innsmouth (verificação de marca pendente, Q-001) |
| Obra | *The Shadow over Innsmouth*, escrita nov.–dez. 1931, publicada em abril de 1936 (Visionary Publishing) |
| Gênero | Horror cósmico, investigação, exploração, sobrevivência sem combate |
| Câmera | Primeira pessoa (D-002) |
| Período | 14–16 de julho de 1927; epílogo 1927–1931 |
| Plataforma | PC Windows x86_64, offline, single-player |
| Engine | Godot 4.7.2 Standard, GDScript tipado, Compatibility (D-001) |
| Duração-alvo | 3h10–4h50 (mediana ~4h), **a validar** |
| Estrutura | Linear por capítulos, com exploração localizada em ch03 e rotas alternativas curtas em ch07 |
| Equipe pressuposta | 1–3 pessoas + Claude Code; arte, animação, voz e mixagem finais por humanos ou aquisição licenciada |
| Final | Único e canônico (D-010) |

## 3. Pilares de design

1. **Innsmouth é a personagem principal.** Ruas, janelas, sinos, cheiro (representado por som, névoa e texto) e o comportamento coletivo comunicam a ameaça antes de qualquer criatura.
2. **Investigar é ler o mundo.** Pistas vêm de conversas, documentos plausíveis, arquitetura e observação. Não há marcadores de pista nem "modo detetive".
3. **Vulnerabilidade sem combate.** O narrador é um estudante desarmado. O perigo real existe (ch06–ch07), é raro, legível e recuperável por checkpoint.
4. **A mesma cidade, duas naturezas.** A geografia aprendida de dia, com o mapa do rapaz da mercearia, é a ferramenta de sobrevivência à noite.
5. **Revelação em camadas.** Tiara → padre no porão → sons nas casas tapadas → ondulação no mar → vozes no hotel → silhuetas → nadadores → procissão. Nada é mostrado inteiro antes da hora (D-011).
6. **O epílogo é o segundo clímax.** A fuga termina o horror físico; a genealogia inaugura o horror da identidade e, por fim, a atração.

## 4. Curva emocional

Curiosidade (ch01) → Estranhamento (ch02) → Desconfiança (ch03) → Descoberta (ch04) → Aprisionamento (ch05) → Terror (ch06) → Fuga e revelação (ch07) → Negação, reconhecimento e pertencimento ambíguo (ch08).

## 5. O que o jogo não é

Não é um shooter, nem um jogo de perseguição contínua, nem um mundo aberto, nem um simulador de caminhada. Não há combate, sanidade numérica, inventário extenso, crafting, multiplayer, serviços online, geração procedural ou IA generativa em tempo de execução.

## 6. Mecânicas centrais (resumo; detalhes em 12)

| Mecânica | Função | Origem |
|---|---|---|
| Andar, andar cauteloso, correr, agachar | Exploração e furtividade | [O] |
| **Andar arrastado** (imitar o passo dos habitantes) | Atravessar espaços abertos ao luar com menos suspeita | [C] o narrador imita "o passo arrastado" |
| Interagir / examinar / ler | Investigação | [O] |
| Mapa desenhado | Orientação sem marcador de posição | [C] |
| Diário | Registra apenas o que o narrador sabe | [O] |
| Dosar a garrafa e escolher temas com Zadok | Ritmo do testemunho | [C] "cuidadoso para não exceder" |
| Ferrolho transferido com a ferramenta do chaveiro | Preparação no quarto | [C] |
| Ler o sentido de abertura das portas | Escolher a rota de fuga | [C] |
| Arrombar com o ombro, empurrar móveis, cortina-corda | Fuga do Gilman | [C] |
| Lanterna como risco | Ver mais, ser mais visível | [C] o narrador evita usá-la na rua |
| **Manter os olhos fechados** | Clímax de ch07; a resolução falha inevitavelmente | [C] |
| Quadro genealógico | Dedução final pelo jogador | [C] relações / [O] mecânica |

## 7. Escopo mínimo jogável (E)

Os oito capítulos com: tiara; ônibus e chegada; mapa; Zadok; quarto 428 e fuga pelos quartos interligados; telhado e pátio; rota até a ferrovia; procissão na estrada de Rowley; Arkham/Peabody; Cleveland e joias; sonhos e espelho; decisão final. Tudo o mais é R ou Op (ver 22).

## 8. Vertical slice e demonstração

* **Vertical slice (Fase 2):** noite no Gilman House — prelúdio na praça ao crepúsculo, quarto 428, fuga pelos quartos, telhado, armazém e pátio (D-009).
* **Demonstração (Fase 3):** ch01 + ch02 + início de ch03 até receber o mapa (~40–50 min), terminando com o aviso do rapaz da mercearia e o mapa na mão. Não revela o hotel nem os Profundos.

## 9. Mapa da documentação

| Documento | Conteúdo |
|---|---|
| `../CLAUDE.md` | Regras operacionais para Claude Code |
| `01-ANALISE-DO-CONTO.md` | Análise literária completa, capítulo a capítulo |
| `02-FIDELIDADE-CANONICA.md` | Tabela C/I/O, responsabilidade na adaptação |
| `03-GAME-DESIGN-DOCUMENT.md` | GDD de referência |
| `04-HISTORIA-E-ROTEIRO.md` | Roteiro, falas-chave, cenas memoráveis |
| `05-CAPITULOS-E-PROGRESSAO.md` | Fichas de capítulo (20 campos), catálogo de eventos, ritmo, morte/falha/salvamento |
| `06-MAPA-DE-INNSMOUTH.md` | Geografia do texto vs. conexões de jogo |
| `07-LEVEL-DESIGN.md` | Distritos, identidade ambiental, barreiras, streaming |
| `08-GILMAN-HOUSE.md` | Documento dedicado à sequência do hotel |
| `09-FUGA-NOTURNA.md` | Documento dedicado a ch07 |
| `10-PERSONAGENS-E-PROFUNDOS.md` | Elenco, habitantes, Profundos |
| `11-INTELIGENCIA-ARTIFICIAL.md` | Estados, percepção, diretores de perseguição |
| `12-MECANICAS-E-PUZZLES.md` | Movimento, câmera, interação, inventário, documentos, puzzles |
| `13-DIRECAO-ARTISTICA.md` | Estética PS1, especificações, modelagem |
| `14-ILUMINACAO-E-ATMOSFERA.md` | Estados de luz, clima, neblina |
| `15-AUDIO.md` | Som, música, voz, padrões técnicos |
| `16-INTERFACE-E-ACESSIBILIDADE.md` | Menus, controles, acessibilidade |
| `17-ARQUITETURA-TECNICA.md` | Matriz de engine, módulos e contratos |
| `18-INVENTARIO-DE-ASSETS.md` | Lista de produção de assets |
| `19-PERFORMANCE-E-OTIMIZACAO.md` | Metas não verificadas e plano de medição |
| `20-ROADMAP.md` | Fases 0–6 com gates |
| `21-BACKLOG-CLAUDE-CODE.md` | Tarefas pequenas e verificáveis |
| `22-RISCOS-E-ESCOPO.md` | Riscos, níveis de escopo, cortes |
| `23-TESTES-E-QUALIDADE.md` | Plano de qualidade e playtests |
| `24-COMERCIALIZACAO-E-DIREITOS.md` | Situação jurídica e distribuição |
| `25-REFERENCIAS-E-FONTES.md` | Fontes consultadas e limitações |
| `26-DECISOES-PENDENTES.md` | Questões para validação humana |
| `27-REGISTRO-DE-IDS.md` | Registro mestre de IDs e decisões fixadas |
| `28-ESTADO-IMPLEMENTACAO.md` | O que existe em código, validações executadas e pendências |
