# 16 — Interface e acessibilidade

> **Estado:** proposta. Layouts serão validados em wireframe na Fase 1 e com jogadores na Fase 3. Nenhuma tela existe.

## 1. Princípios

1. **Sem HUD permanente.** Não há barra de vida, bússola, minimapa, marcador de missão ou contador de sanidade.
2. **A interface é papel.** Diário, documentos e mapa têm aparência de papel de 1927 renderizado em **resolução nativa** (D-018), nunca pixelizado.
3. **Prompts discretos.** Um ícone pequeno e um verbo ("Examinar", "Abrir", "Empurrar") aparecem só quando um interativo está em alcance e foco.
4. **A UI emite intenções.** Fechar um documento, escolher um tema ou pedir dica nunca concede itens nem altera progresso por si; quem decide é `sys_story_state`/`sys_chapter_flow`.
5. **Tudo pausa.** Menus, leitura, diário, mapa e Bolsos pausam simulação e perigo — inclusive em ch06–ch07 (o perigo é físico, não de gestão de menu).

## 2. Telas e fluxos

### 2.1 Menu principal

Cenário: a escrivaninha de `lvl_toledo_room` à noite, com o manuscrito. Itens: **Continuar**, **Novo manuscrito**, **Capítulos** (apenas capítulos concluídos), **Configurações**, **Créditos e licenças**, **Sair**. Aviso de conteúdo exibido na primeira execução (§8).

### 2.2 Espaços de partida

Três "manuscritos" (D-007). Cada espaço mostra capítulo, último checkpoint (descrição em texto, nunca só imagem), tempo de jogo e data real. Substituir pede confirmação.

### 2.3 Pausa

Retomar · Diário · Mapa (se possuído) · Configurações · Recomeçar do checkpoint (com confirmação e aviso do que se perde) · Menu principal. Mostra o objetivo atual do Diário em uma linha.

### 2.4 Bolsos (inventário)

Grade de até 8 itens (D-006). Selecionar abre inspeção 3D com rotação e a nota do narrador. Itens não são "usados" a partir do menu: o uso acontece no mundo (ex.: ferramenta no ferrolho), exceto **Mapa** e **Relógio** (consulta). Uísque, lanterna e mapa mostram estado relevante em texto ("garrafa pela metade").

### 2.5 Diário

Abas: **Objetivo** (uma frase no tom do narrador, nunca waypoint), **Notas** (pensamentos registrados), **Pessoas e lugares**, **Documentos** (releitura), **Testemunho** (registro de Zadok, `doc_zadok_record`), **Família** (ch08; contém `doc_family_chart`). Registra apenas o que o narrador sabe; nada de spoilers em títulos. **Pedir uma pista**: três níveis por objetivo (pergunta → onde procurar → próximo passo), solicitados um a um; não alteram progresso.

### 2.6 Mapa diegético

`item_sketch_map` desenhado a lápis pelo rapaz da mercearia [C]: ruas principais, praça, pontes (Fish Street marcada como arruinada [C]), refinaria, igrejas, Ordem de Dagon, estação, estradas. **Sem posição do jogador e sem escala** por padrão. À noite, o mapa é lido à luz da lanterna (tela mais escura; ler o mapa pausa o jogo, mas em ch07 a lanterna fica visível no mundo no instante de abrir e fechar — ver 11). Anotações do narrador são acrescentadas à mão quando ele visita um marco (carimbo textual, não ícone de "concluído").

Ajuda de navegação opcional (§6): nome da rua mais próxima ao parar 2 s junto a uma esquina com placa caída; destaque da rota planejada em ch07.

### 2.7 Leitor de documentos

Página em resolução nativa; transcrição em texto limpo alternável (Tab/Y); tamanho de fonte 16–32; rolagem; fac-símile de época opcional com fonte legível como padrão. Fotografias têm descrição textual completa (alternativa).

### 2.8 Diálogo

Caixa inferior com nome do falante. Temas listados (Zadok, Tilton, rapaz da mercearia, Peabody, Walter); "Continuar" avança a página. Zadok: oferecer a garrafa é uma ação de diálogo contextual (`pz04_zadok_pacing`), não item do menu. Sem rodas de moralidade, sem indicadores de aprovação.

### 2.9 Legendas

Ver 15 §6.7. Configurações: ligar/desligar falas e sons separadamente; tamanho (pequeno a extra-grande); fundo opaco 0–100%; nome do falante; indicação de direção.

## 3. Controles iniciais

Todas as ações são remapeáveis por dispositivo. Controle segue padrão Xbox (rótulos trocam conforme o dispositivo detectado).

| Ação (nome interno) | Teclado / mouse | Controle | Observações |
|---|---|---|---|
| `move_*` | W A S D | Analógico esquerdo | Analógico proporcional |
| `look_*` | Mouse | Analógico direito | Sensibilidade e inversão por eixo |
| `walk_careful` | Ctrl (segurar ou alternar) | Pressionar analógico esquerdo | Andar cauteloso, silencioso |
| `run` | Shift (segurar ou alternar) | LB | |
| `shamble` | Alt (segurar ou alternar) | LT | Andar arrastado (ch07) |
| `crouch` | C (alternar) | B (toque) | |
| `interact` | E / clique esquerdo | A | Verbo contextual |
| `interact_hold` | segurar E | segurar A | Empurrar móvel, arrombar (alternativa a martelar) |
| `close_eyes` | Segurar Espaço | Segurar RB | Exclusivo de `evt_rowley_procession` |
| `flashlight` | F | RT | |
| `journal` | J | Y | |
| `map` | M | Direcional ↑ | |
| `pockets` | Tab / I | Direcional ↓ | |
| `watch` | T | Direcional → | Consulta do relógio |
| `pause` | Esc | Start | |
| `ui_back` | Esc / clique direito | B | Contextual: documento → índice → mundo |
| `reader_toggle` | Tab | X | Fac-símile ↔ transcrição |
| `reader_scroll` | Roda / Page Up-Down | Analógico direito | |

Interação até ~2 m, com tolerância de mira generosa. Nenhuma ação exige combinação simultânea de teclas.

## 4. Configurações

**Imagem:** resolução de saída, tela cheia/janela, V-Sync, limite de FPS, resolução interna (240/360), dithering 0–100%, instabilidade de vértices 0–3, granulação 0–100%, proporção 16:9/4:3, brilho/gama com calibração.
**Câmera e conforto:** FOV 60–100°, balanço de cabeça desligado/leve, tremor de câmera desligado/reduzido/completo, desfoque de movimento inexistente, retículo central opcional (ponto pequeno) para enjoo.
**Áudio:** volumes por bus, faixa dinâmica (completa/reduzida), mono, legendas (§2.9).
**Controles:** remapeamento, sensibilidade, inversão, alternar/segurar para correr/agachar/andar arrastado/cauteloso, vibração (desligada por padrão).
**Acessibilidade:** §5.
**Idioma:** PT-BR (padrão); EN (Q-003).

## 5. Acessibilidade (§19.2 e complementos)

| Necessidade | Solução |
|---|---|
| Legendas configuráveis | §2.9 |
| Tamanho de fonte | Documentos, diário e legendas 16–32; menus em três escalas |
| Contraste | Fundo opaco; tema de alto contraste para UI |
| Intensidade de efeitos | Sliders de dithering, granulação, instabilidade; preset "Retrô suave" e "Limpo" |
| Tremor | Desligado por padrão; desmaio sem tremor (só escurecimento) |
| Head bob | Desligado por padrão |
| FOV | 60–100° |
| Fotossensibilidade | Clarões do recife e cortes de luz com limite de frequência (≤ 3 por segundo) e opção de suavização |
| Alternativa a pistas sonoras | **Indicador de presença** opcional: arco discreto na borda da tela mostrando direção de sons de perigo e de pistas obrigatórias; legendas de som com direção |
| Pistas sem depender de cor | Formas e textos acompanham toda distinção de cor (rota, sinais, joias) |
| Navegação assistida | Nome da rua ao parar; rota planejada destacada no mapa em ch07; "lembrete de objetivo" no diário |
| Perseguição assistida | Patrulhas mais lentas, janelas de percepção maiores, checkpoints mais frequentes; pode ser alterada a qualquer momento sem reiniciar |
| Sequências de tempo | "Mais tempo": estende os limites do `SiegeDirector` em ch06 |
| Martelar botão | Arrombar e empurrar aceitam **segurar** em vez de repetir |
| Segurar botão | `close_eyes` e `interact_hold` aceitam alternância |
| Motricidade fina | Sem QTE; mira de interação com tolerância ampla |
| Cognição | Pedir uma pista (3 níveis); resumo "Até aqui" ao carregar |
| Leitura | Transcrição limpa de todo documento; descrição de fotografias |
| Enjoo | Ponto central, sem balanço, FOV alto, resolução 360 |

Estas opções não marcam a partida como "fácil" nem bloqueiam conquistas.

## 6. Avisos de conteúdo

Exibidos na primeira execução e disponíveis no menu: **suicídio** (mencionado e implícito no epílogo; nenhuma ação interativa — D-015), **doença mental e internação** (mencionadas, sem visita a instituições), **violência e morte** (implícitas, sem gore), **preconceito histórico** (o conto de 1936 contém visões racistas e eugenistas; a adaptação as reconhece e não as reproduz como verdade — ver 02), **perseguição e confinamento**, **horror corporal** (transformação). Texto final do aviso revisado por pessoa e por leitores sensíveis (Q-010, proposto). Inclui indicação de recursos de apoio em saúde mental (texto a definir por região de lançamento).

## 7. Onboarding sem tutorial

* ch01 ensina interação, leitura e diálogo em espaços seguros (estação, biblioteca).
* Primeira vez de cada verbo: prompt com o nome da tecla por 1 ocorrência; depois só o ícone.
* ch03 ensina o mapa (o rapaz o entrega e explica que as placas caíram, [C]).
* Andar arrastado é apresentado pelo pensamento do narrador ao chegar à primeira praça aberta em ch07, com o prompt da tecla.
* `close_eyes` aparece apenas quando necessário, com prompt explícito.

## 8. Critérios de aceitação

* Todos os fluxos navegáveis só com teclado, só com mouse e só com controle.
* Cada pista obrigatória possui caminho visual e textual (verificação por lista em 23).
* Testadores completam ch01 sem perguntar "como faço X?" em ≥ 80% dos casos (meta qualitativa, 23).
* UI legível a 1280×720 com fonte padrão.
