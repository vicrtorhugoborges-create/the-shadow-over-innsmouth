# 11 — Inteligência artificial e comportamento de NPCs

> Contratos de módulo (`sys_npc_routine`, `sys_perception`, `sys_pursuit`) em `17-ARQUITETURA-TECNICA.md`. Este documento define **comportamento**. Aplicações concretas em `08` (Gilman) e `09` (fuga).

## 1. Princípio

O horror de Innsmouth vem de uma comunidade **coordenada**. Coordenação percebida é barata quando é **roteirizada por diretores**; IA autônoma complexa é cara, difícil de testar e produz situações injustas. A maior parte dos NPCs não "pensa": segue rotinas e reage a poucos estímulos.

## 2. Comparação de abordagens

| Critério | A. FSM simples + diretores roteirizados | B. Behavior trees / utility AI / GOAP com simulação social |
|---|---|---|
| Sensação de coordenação | Alta (o diretor decide quem aparece onde) | Alta em teoria, imprevisível na prática |
| Justiça e legibilidade | Alta: prazos e rotas conhecidos | Baixa: emergências difíceis de ler |
| Custo de implementação | Baixo | Alto |
| Testabilidade automatizada | Alta: estados determinísticos | Baixa |
| Fidelidade ao conto | Alta: o conto descreve grupos cumprindo um "general plan" [C] | Indiferente |
| Risco de travar progressão | Baixo | Médio |

**Decisão: A.** Três camadas:

1. **Rotina** (`sys_npc_routine`): caminhos e poses diurnos; reações de olhar.
2. **Percepção** (`sys_perception`): cálculo de suspeita por grupo, não por indivíduo, à noite.
3. **Diretores** (`sys_pursuit`): `SiegeDirector` (ch06) e `PatrolDirector` (ch07) disparam e coordenam grupos.

## 3. Estados

Estados do briefing (§11.4), aplicados a **grupos** de perseguição e, em versão reduzida, a moradores diurnos.

| Estado | Entrada | Comportamento | Saída |
|---|---|---|---|
| `routine` | padrão diurno | Caminhar entre pontos, entrar/sair de portas, sentar, trabalhar | `observing` |
| `patrol` | gatilho do diretor (noite) | Percorrer spline fixa com velocidade fixa ±10 % | `suspicious`, `returning` |
| `observing` | jogador a < 8 m de dia, ou a < 12 m em área sensível (Green, igrejas, refinaria) | Parar, virar cabeça, olhar fixo; se a conversa estava ocorrendo, interrompê-la | `routine` quando o jogador se afasta |
| `suspicious` | suspeita ≥ 0,35 (noite) | Parar, levantar lanterna, emitir som curto, virar para a última posição percebida | `investigating` ou `patrol` |
| `investigating` | suspeita ≥ 0,6 ou ruído | Ir ao ponto do estímulo; procurar por 6–10 s | `alert` ou `returning` |
| `alert` | suspeita = 1 (detecção) | Chamado gutural; outros grupos no raio entram em `searching` | `chasing` |
| `searching` | chamado de outro grupo | Mover-se rumo à área do chamado por rota fixa | `chasing` ou `returning` |
| `chasing` | linha de visão após `alert` | Velocidade de perseguição, sempre um pouco menor que a corrida do jogador (≈ 90 %) | captura ou `searching` após 4–6 s sem visão |
| `returning` | fim de busca | Volta ao ponto da spline e retoma `patrol` | `patrol` |

Moradores diurnos usam apenas `routine` e `observing` (sem perigo). O estado `observing` também dispara comportamentos de rumor: dois moradores que conversam se calam; um deles entra numa casa e fecha a porta [C "furtive"; I].

## 4. Percepção

### 4.1 Visão

Cada grupo tem um **cone** (110°, distância base 30 m à noite) a partir do membro líder; membros adicionais ampliam o cone em ±15° cada (máx. 4). A visibilidade do jogador é um produto de fatores:

| Fator | Valores |
|---|---|
| Luz no ponto do jogador | sombra 0,2 · luar 1,0 · lanterna de um grupo 1,4 · **lanterna do jogador acesa 2,5** |
| Andar | parado 0,3 · agachado 0,4 · cauteloso 0,6 · normal 1,0 · **arrastado 0,25 em luar, 1,0 em sombra fechada** · corrida 1,8 |
| Distância | linear de 1,0 (≤ 5 m) a 0 (limite do cone) |
| Esconderijo | dentro de volume de esconderijo → 0 |

O andar arrastado só é eficaz onde o jogador está à vista ao longe — ele imita o passo dos moradores; de perto (< 6 m) perde efeito (fator 0,8). Isso traduz o conto: a estratégia engana à distância [C].

A suspeita sobe por `visibilidade × taxa` (taxa padrão 0,5/s) e cai 0,25/s sem visão. No modo **Fuga assistida**, taxa 0,3/s e queda 0,4/s.

### 4.2 Audição

| Fonte | Raio |
|---|---|
| Passo normal | 6 m |
| Passo cauteloso | 2 m |
| Corrida | 14 m |
| Cerca/entulho/ripas | 18 m |
| Arrombar porta (ch06) | todo o andar (roteirizado) |
| Bank Street, ponte das quedas | todos os raios × 0,1 [C quedas abafam] |

Som ouvido gera evento de `investigating` no ponto do som para o grupo mais próximo apenas (evita convergência injusta).

### 4.3 Presença

Não há "sentido sobrenatural": nenhum grupo detecta o jogador através de paredes.

## 5. Diretores

### 5.1 `SiegeDirector` (ch06)

Máquina de fases S0–S8 descrita em `08 §5`. Não controla corpos visíveis: controla **sons, portas, luzes de lanterna sob portas e prazos**. Entradas: progresso do jogador (portas trancadas, barricadas, golpes), relógio de fase, falhas anteriores. Saídas: solicitações de eventos (`evt_knocking`, `evt_passkeys`, `evt_ram`), estados de portas e falha.

### 5.2 `PatrolDirector` (ch07)

| Responsabilidade | Regra |
|---|---|
| Disparo de grupos | Cada grupo (`pur_*`) tem gatilho de posição do jogador e spline; o diretor o instancia apenas quando necessário (máx. 3 grupos ativos) |
| Momentos obrigatórios | `evt_bates_hide`, `evt_ipswich_party`, `evt_washington_band`: o grupo **espera** até que o jogador esteja no ponto de observação ou escondido; se o jogador correr adiante, o grupo é disparado de forma a cruzar sua frente com tempo de reação |
| Coordenação | `alert` de um grupo coloca os demais em `searching` por rotas pré-definidas, nunca por pathfinding livre através de becos |
| Justiça | Um grupo nunca aparece no campo de visão já em `chasing`; sempre passa por `suspicious` (≥ 1 s audível e visível) |
| Teto | Se o jogador for capturado 3 vezes no mesmo trecho, o diretor oferece (uma vez, pelo menu de pausa) ativar a Fuga assistida; nunca ativa sozinho |
| Procissão | `evt_rowley_procession` é sequência sem percepção ativa (seguro) |

### 5.3 Rotinas diurnas

`sys_npc_routine` usa pontos nomeados por distrito (porta, banco, janela, esquina) e horários de capítulo (não relógio real): um NPC tem 2–4 pontos e escolhe o seguinte por lista fixa. Densidade visível por distrito em `07`. Comportamentos-assinatura:

| Comportamento | Onde | Gatilho |
|---|---|---|
| Ociosos se afastam do ônibus | Newburyport | `evt_square_avoidance` |
| Rostos nas janelas que se retiram | orla norte, mansões | `evt_window_watchers` (resfriamento 90 s, nunca no mesmo ponto duas vezes seguidas) |
| Conversa interrompida | praça, orla norte | jogador a < 8 m |
| Morador que entra e fecha porta | zona norte | `observing` por 4 s |
| Observadores à porta do Gilman | praça 19h45 | `evt_gilman_crowd` (todos olham, ninguém fala) |
| Membro da Ordem sai ao pórtico | Green | jogador a < 15 m do pórtico |

## 6. Navegação

Malha de navegação por distrito apenas para rotinas diurnas e para `investigating`/`searching` em trechos curtos. Perseguições usam splines autorizadas, o que impede que grupos cortem por caminhos que o jogador não conhece.

## 7. Testes isolados (resumo; plano em 23)

1. Cena de validação de percepção: jogador fantasma em grade de posições × luz × andar; verificar monotonicidade (mais luz nunca reduz suspeita; esconderijo sempre zera).
2. Cena de validação do `PatrolDirector`: simulação headless de uma rota completa com jogador roteirizado; nenhum grupo entra em `chasing` sem `suspicious` prévio.
3. Cena de validação do `SiegeDirector`: jogador roteirizado rápido, médio e lento; o prazo nunca vence antes do tempo mínimo de cada fase; pausa congela tudo.
