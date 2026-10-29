# 22 — Riscos e escopo

> Probabilidade e impacto são julgamentos de planejamento (**B** baixa/baixo, **M** média/médio, **A** alta/alto), revistos a cada gate do roadmap. Nenhum é medido.

## 1. O que nunca se corta

Estes elementos definem a adaptação. Se o orçamento apertar, corta-se **ao redor** deles, nunca eles:

1. **O final do conto** — Arkham/Peabody, Cleveland e as joias Orne, os sonhos, o espelho e a decisão de voltar ao mar (`ch08`). Pode ser reduzido em duração e em número de ambientes, nunca removido ou trocado por um final alternativo.
2. **A sequência do Gilman House** — quarto 428, ferrolho, portas de ligação, barricadas, cortina-corda, telhado, pátio (`ch05`–`ch06`).
3. **A identidade de Innsmouth** — praça, Gilman com cúpula, desfiladeiro e quedas do Manuxet, Ordem de Dagon na New Church Green, refinaria, orla em ruínas, Devil Reef no horizonte, o mapa do rapaz da mercearia.
4. **O testemunho de Zadok Allen** e a ambiguidade do seu fim.
5. **A procissão na estrada de Rowley** como única revelação completa (D-011).

## 2. Níveis de escopo por feature

| Feature | Nível | Observação |
|---|---|---|
| Oito capítulos + moldura do manuscrito | E | D-003 |
| Movimento (andar, cauteloso, correr, agachar, andar arrastado) | E | |
| Interação contextual, exame de objetos, leitor de documentos | E | |
| Diário com objetivo derivado e dica graduada | E | |
| Mapa diegético sem marcador | E | assistência de navegação opcional é E por acessibilidade |
| Bolsos (≤ 8 itens) | E | D-006 |
| Save por checkpoint com 3 slots e backup | E | D-007 |
| `pz01`–`pz12` | E | `pz04` pode simplificar-se para escolha de temas sem dosagem |
| `SiegeDirector` e `PatrolDirector` roteirizados | E | |
| `sys_perception` com luz, ruído e gait | E | versão mínima: cones + zonas de luz autoradas |
| Distritos `dist_square`, `dist_gorge`, `dist_north`, `dist_patrician`, `dist_south_waterfront`, `dist_south_residential`, `dist_bank_station` | E (partes caminháveis listadas em 07) | fachadas além das rotas podem ser impostores |
| Interiores `lvl_grocery`, `lvl_variety_store`, `lvl_gilman_interior` | E | |
| `lvl_restaurant` | R | pode virar balcão visto da porta |
| Trecho diurno opcional do bairro sul | R | Q-016 |
| `evt_marsh_car` | R | |
| Rotinas ambientais ricas de `res_*` | R | mínimo E: olhares, portas e janelas que fecham |
| Dublagem completa de Zadok | R | Q-007; mínimo E: texto + vocalizações |
| Vocalizações não verbais de todos os NPCs | E | |
| Música original | R | mínimo E: drones e ambiência |
| Remapeamento de controle | R | teclado é E |
| Inglês como segundo idioma | R | Q-003 |
| Vista da janela com impostores detalhados | E | é pista de rota |
| Restaurante, jornal vespertino legível | Op | `doc_evening_paper` pode ser só objeto |
| Seleção de capítulo após conclusão | E | |
| Galeria de documentos/extras | Op | |
| Modo foto | Op | |
| Steam Deck / outras plataformas | Op | fora do escopo inicial |
| Finais alternativos | **Fora** | D-010 |
| Visita ao sanatório de Canton, flashbacks das ilhas | **Fora** | D-014 e CLAUDE.md §6 |

## 3. Registro de riscos

| # | Risco | Prob. | Impacto | Prevenção | Alternativa simplificada | Critério para adiar/remover |
|---|---|---|---|---|---|---|
| R01 | **Cidade grande demais** | A | A | Distritos limitados às rotas canônicas; fachadas fora da rota como impostores; kit modular | Substituir trechos de conexão por transições curtas (ponte, porta) | Se o streaming (`INN-030`) exceder a meta de 19 ou um distrito passar de 2× o esforço estimado no gate da Fase 4.1 |
| R02 | **Excesso de interiores** | M | M | Só interiores canônicos e funcionais (mercearia, loja da Eliot, Gilman, restaurante R) | Interiores vistos da porta | Interior sem função de jogo ou narrativa é removido |
| R03 | **Quantidade de NPCs** | M | M | ≤ ~10 visíveis por área de dia; rotinas simples | Silhuetas em janelas, NPCs distantes sem rotina | Se o número de NPCs com rotina exigir mais de um ciclo de animação único por arquétipo |
| R04 | **Animações de criaturas** | A | A | Profundos aparecem pouco, no escuro, em grupo com ciclos compartilhados; variação por escala e acessórios | Procissão em silhueta contra luar + som + 3–5 modelos próximos | Se `INN-381` não tiver orçamento/artista até o gate da Fase 4.4 |
| R05 | **Dependência de cutscenes** | M | A | `sys_sequence` com o jogador no controle da câmera; enquadramento sugerido | Encurtar falas e manter o jogador andando | Cena com > 90 s sem input significativo é reescrita |
| R06 | **Dublagem** | A | M | Texto como base; voz só para Zadok (R) | Vocalizações e legendas | Sem contrato e licença de voz até a Fase 5 → manter texto |
| R07 | **Perseguição com IA complexa** | M | A | Diretores roteirizados com trilhos e estados (11) | Sequências 100% roteirizadas com pontos de esconderijo fixos | Se o harness mostrar capturas injustas após duas iterações |
| R08 | **Inventário desnecessário** | B | M | D-006, ≤ 8 itens | — | Item sem uso em puzzle ou narrativa é removido |
| R09 | **Puzzles difíceis de testar** | M | M | Puzzles com estados discretos e testes headless | Reduzir passos | Puzzle sem teste automatizável de conclusão não entra |
| R10 | **Falhas de progressão** | M | A | Objetivos derivados de fatos, `entry_state` por capítulo, unicidade de eventos | Seleção de capítulo como recuperação | Qualquer bloqueio reproduzível é bloqueante de release |
| R11 | **Desempenho** | M | M | Metas e plano de 19; spikes cedo | Reduzir distância de desenho e densidade | Metas não atingidas no hardware mínimo no gate da Fase 5 |
| R12 | **Excesso de assets únicos** | A | A | Kit modular, famílias de material (13), reutilização dia/noite | Variações por textura e cor | Asset único sem papel de marco é substituído por modular |
| R13 | **Epílogo percebido como apêndice** | M | A | Pistas de ch01–ch04 ganham novo sentido em ch08 (`evt_marsh_eyes` retoma a fala de Zadok sobre os olhos) | Encurtar viagens, manter descobertas | Nunca remover; ajustar ritmo se playtests indicarem desinteresse |
| R14 | **Representação ofensiva** (racismo, eugenia, doença mental) | M | A | D-013, D-014, D-015; revisão de sensibilidade (Q-013) | Reescrever cena | Qualquer achado grave da revisão é bloqueante |
| R15 | **Risco jurídico** (texto, título, marcas) | B–M | A | Parecer (Q-002), texto inglês de 1936, tradução própria | Mudar título | Parecer desfavorável bloqueia comercialização |
| R16 | **Dependência de terceiros** (arte, áudio) | A | A | Orçamento e cronograma por gate; placeholders identificados | Reduzir quantidade, comprar packs licenciados | Sem fornecedor no gate da Fase 4 → reduzir escopo R |
| R17 | **Divergência entre documentos** | M | M | Registro 27 como fonte única de IDs; revisão a cada tarefa | — | Divergência encontrada é corrigida na mesma tarefa |
| R18 | **Limitações do renderizador Compatibility à noite** | M | M | Spike `INN-016` | Iluminação mais pintada/baked; trocar renderizador com ADR | Se a noite não for legível após o spike |
| R19 | **Reaproveitamento de código não auditado do Dunwich** | M | M | Q-005; cópia seletiva com revisão e testes | Reescrever com os mesmos padrões | Código sem testes não é copiado |
| R20 | **Enjoo/desconforto** | M | M | Head bob desligado, FOV, tremor 0, descida curta | Opções extras | Relatos em playtest → ajuste obrigatório |
