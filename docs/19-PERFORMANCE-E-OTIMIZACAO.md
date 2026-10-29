# 19 — Desempenho e otimização

> **Estado:** nenhum número deste documento foi medido. Todas as metas são **hipóteses de projeto** a confirmar com o plano de medição (§6). Recursos que dependem da engine estão marcados **"verificar em spike"**.

## 1. Premissa

Baixo polígono não garante desempenho. Os custos prováveis deste projeto são: **número de draw calls** numa cidade de muitos módulos, **pós-processamento** em tela cheia (dithering, redução de cor, granulação, upscale), **luzes dinâmicas** à noite, **transparências** (vegetação, névoa por cartão, chuva, multidão impostora), **streaming** entre distritos e **áudio** com muitas fontes posicionais em ch06–ch07.

## 2. Requisitos preliminares (Windows, não verificados)

| Item | Mínimo (hipótese) | Recomendado (hipótese) |
|---|---|---|
| SO | Windows 10 64-bit | Windows 10/11 64-bit |
| CPU | 4 threads, ~2,5 GHz (classe Intel Core i3 de 8ª geração) | 6+ threads (classe Core i5 de 9ª geração / Ryzen 5 2600) |
| GPU | Integrada com suporte a OpenGL 3.3 (classe Intel UHD 620) | Dedicada classe GTX 1050 / RX 560 |
| RAM | 4 GB | 8 GB |
| Armazenamento | 3 GB livres, HDD | SSD |
| Áudio | Estéreo | Fones com estéreo |

O renderizador Compatibility é escolhido também para ampliar a compatibilidade com GPUs integradas (D-001); o requisito de API gráfica exato deve ser **verificado em spike** com a versão 4.7.2 e publicado só após testes.

## 3. Metas iniciais (não verificadas)

| Métrica | Meta mínima | Meta recomendada | Como medir |
|---|---|---|---|
| FPS em exploração (1080p saída, 427×240 interna) | 30 estável no mínimo | 60 estável no recomendado | média e 1% low em rota fixa |
| FPS em ch06/ch07 (pior caso) | 30 | 60 | rota fixa com perseguidores ativos |
| Tempo de quadro p99 | ≤ 40 ms | ≤ 20 ms | captura de 5 min |
| Hitch de streaming | nenhum > 100 ms | nenhum > 50 ms | travessia de fronteira de distrito |
| Memória do processo | ≤ 2,5 GB | ≤ 1,5 GB | pico em `lvl_innsmouth` |
| VRAM | ≤ 1 GB | ≤ 512 MB | ferramenta de GPU/monitor da engine |
| Carregamento inicial até menu | ≤ 15 s (HDD) | ≤ 5 s (SSD) | cronômetro, 3 execuções |
| Carregamento de capítulo | ≤ 20 s (HDD) | ≤ 8 s (SSD) | idem |
| Tamanho de instalação | ≤ 2,5 GB | ≤ 1,5 GB | build de release |
| Save/load de checkpoint | imperceptível (< 1 quadro de travamento visível) | idem | captura |

As metas só passam a valer como compromisso após a Fase 1 confirmar viabilidade; resultados ficam registrados em `docs/qa/` com hardware, driver, build e data.

## 4. Orçamentos por cena (hipóteses)

| Recurso | Exploração diurna | Noite (ch07) | Interior (Gilman) |
|---|---|---|---|
| Draw calls visíveis | ≤ 600 | ≤ 500 | ≤ 250 |
| Triângulos visíveis | ≤ 250 mil | ≤ 200 mil | ≤ 80 mil |
| Luzes dinâmicas visíveis | 1 direcional + ≤ 4 | 1 direcional + ≤ 8 | ≤ 4 |
| Luzes com sombra | ≤ 1 | ≤ 1 | ≤ 1 |
| NPCs com lógica ativa | ≤ 12 | ≤ 16 (perseguidores) | ≤ 6 (majoritariamente sonoros) |
| NPCs animados visíveis | ≤ 12 | ≤ 20 + impostores | ≤ 4 |
| Vozes de áudio simultâneas | ≤ 32 | ≤ 32 | ≤ 24 |
| Partículas (sistemas ativos) | ≤ 4 | ≤ 6 | ≤ 2 |

Validar e ajustar na vertical slice (Gilman) e num distrito diurno de teste.

## 5. Técnicas (§26)

| Técnica | Aplicação | Nota |
|---|---|---|
| **Culling por frustum** | padrão da engine | — |
| **Occlusion culling** | ruas estreitas e quarteirões densos favorecem oclusão | Verificar em spike disponibilidade e custo no Compatibility; alternativa: **portais manuais** por distrito/rua e visibilidade por zonas ativadas por gatilho. |
| **Instanciamento** | módulos repetidos, vegetação, estacas, telhas, multidão impostora | Verificar em spike instanciamento de malhas no Compatibility; agrupar módulos estáticos por quarteirão quando não houver interação. |
| **Reutilização de materiais** | atlas por bairro, ≤ 6 materiais por distrito | Reduz troca de estado. |
| **Iluminação estática** | cor de vértice assada; lightmaps só se o spike confirmar | Cada distrito tem variante dia/noite. |
| **Limites de partículas** | chuva, morcegos, poeira | Contagem fixa e baixa; cartões presos à câmera. |
| **Distância de renderização** | 60–120 m + névoa + impostors de horizonte | Devil Reef, campanários e cúpula como impostors. |
| **LOD** | personagens (2 níveis), marcos (2), Profundos (silhueta) | Multidão: cartões animados além de ~30 m. |
| **Gestão de NPCs** | `sys_npc_routine` desativa lógica fora da zona; NPCs de fundo sem navegação | Perseguidores de ch07 fora de vista viram "fichas" no `PatrolDirector` (posição abstrata, sem animação). |
| **Carregamento de áreas** | `sys_scene_loader` carrega distritos vizinhos em segundo plano; fronteiras com curva ou portão | Verificar em spike carregamento em thread e custo de instanciar cena grande; preferir pré-instanciar durante transições roteirizadas (ônibus, escadas, claraboia). |
| **Memória** | texturas pequenas, compressão adequada; descarregar distritos não adjacentes | Pico esperado em ch07. |
| **Áudio** | OGG para loops, WAV curto; limite de vozes; ambientes por zona, não por objeto | Fontes distantes agregadas em um emissor de zona. |
| **Tamanho de instalação** | sem masters na build; música e voz comprimidas | VO de Zadok é o maior item de áudio previsto. |
| **Custos de sombra** | 1 luz com sombra (lanterna do jogador ou roteirizada) | Sombras do sol/lua pintadas. |
| **Água** | textura rolante + ondulação de vértice em malha esparsa | Sem reflexão/refração em tempo real. |
| **Pós-processamento** | resolução interna baixa torna a maioria dos efeitos baratos; o upscale e a UI nativa são o custo fixo | Um único passe combinado para dithering, redução de cor, grão e grading — verificar em spike o pipeline de viewport/pós no Compatibility. |
| **Transparência** | alfa recortado em vez de mescla; névoa por cartão limitada | Overdraw é o risco principal em GPU integrada. |

## 6. Plano de medição

### 6.1 Hardware representativo

| Perfil | Exemplo de configuração | Papel |
|---|---|---|
| H1 — piso | notebook com Intel UHD 620, 8 GB, SSD SATA | valida mínimo |
| H2 — HDD | desktop antigo com HDD | valida carregamentos |
| H3 — médio | GTX 1050 / RX 560, 8 GB | valida recomendado |
| H4 — atual | GPU recente, 16 GB | detecta problemas de V-Sync, taxas altas |
| H5 — esta máquina | equipamento de desenvolvimento | regressões rápidas; não substitui H1–H3 |

Se H1–H3 não estiverem disponíveis, registrar a lacuna e não publicar requisitos (CLAUDE.md §9.7).

### 6.2 Cenários de teste fixos

1. **P1 — Praça diurna:** caminho gravado da saída do ônibus até a mercearia (`dist_square`).
2. **P2 — Travessia de distritos:** praça → ponte → `dist_north` → `dist_patrician` (mede streaming).
3. **P3 — Gilman ch06:** de `cp06_knock` a `cp06_courtyard` com todos os eventos.
4. **P4 — Rota noturna:** `cp07_washington` → `cp07_bank_street` com patrulhas.
5. **P5 — Procissão:** `cp07_cut` até o desmaio (pior caso de multidão e áudio).
6. **P6 — Carregamentos:** frio/quente para menu, ch03, ch07.
7. **P7 — Sessão longa:** 60 min contínuos para detectar crescimento de memória.

### 6.3 Procedimento

* Sempre com o **export Windows de release** em execução gráfica (headless não mede GPU, áudio ou input).
* Três repetições por cenário; registrar média, 1% low, p99, pico de memória, maior hitch.
* Registrar build, data, driver, resolução de saída, resolução interna e opções gráficas.
* Comparar contra a última medição; regressão > 10% bloqueia o merge da tarefa até análise.
* Telemetria apenas local; nenhum envio a serviço externo (escopo offline).

### 6.4 Gates

| Fase | Requisito de desempenho |
|---|---|
| 1 — Protótipo | P1 em H5 e, se possível, H1, com o pós-processo completo; decisão sobre occlusion/lightmaps registrada. |
| 2 — Vertical slice | P3 dentro da meta mínima em H1 ou equivalente documentado. |
| 3 — Demo | P1, P2, P6 dentro das metas mínimas em H1–H3. |
| 5 — Integração | P1–P7 completos; requisitos publicáveis definidos com base em medição. |
| 6 — Lançamento | Repetição completa na build candidata. |

## 7. Riscos de desempenho

| Risco | Mitigação |
|---|---|
| Draw calls de cidade modular | Fusão estática por quarteirão, atlas, portais |
| Overdraw de vegetação/névoa em GPU integrada | Alfa recortado, densidade limitada, opção "vegetação reduzida" |
| Hitches de streaming | Transições roteirizadas para carregamento, pré-carga de vizinhos |
| Multidão da procissão | Impostores animados + 10–20 modelos reais em primeiro plano (09) |
| Luzes dos perseguidores | Limite de lanternas com luz real; demais como emissivo + cartão |
| Sombras dinâmicas | Uma só; lanterna do jogador tem prioridade |
