# 21 — Backlog operacional para Claude Code

> **Todas as tarefas estão PLANEJADAS — NÃO IMPLEMENTAR NESTA ETAPA.** A implementação começa somente após autorização explícita (CLAUDE.md §2) e o gate da Fase 0 (`INN-006`).

## 1. Como usar este backlog

* Uma tarefa por vez, ou um conjunto inseparável declarado. Respeitar dependências.
* IDs de sistemas (`sys_*`), puzzles (`pz*`), eventos (`evt_*`), checkpoints (`cp*`) e níveis vêm de `27-REGISTRO-DE-IDS.md`. Contratos em `17-ARQUITETURA-TECNICA.md`.
* **Categoria:** PROG programação · ARTE · AUDIO · ROT roteiro/texto · VAL validação.
* **Execução:** **A** automatizável por Claude Code · **H** depende de humano · **A+H** Claude Code prepara, humano aprova/executa parte.
* **Dificuldade:** 1 (trivial) a 5 (alta incerteza).

### 1.1. Protocolo de verificação antes de avançar

1. **Releitura do contrato:** a implementação corresponde ao contrato em 17 e ao design do documento pertinente? Se o comportamento mudou, atualizar o documento na mesma tarefa.
2. **Cena de validação isolada** do módulo existe em `game/tests/` e roda sem depender de capítulo.
3. **Testes de lógica headless** (importação do projeto + testes de comportamento e invariantes) executados com o Godot 4.7.2 portátil; registrar comando e saída resumida.
4. **Execução gráfica do export Windows** para tudo que envolve imagem, som, input ou desempenho. Headless **não** valida esses aspectos.
5. **Evidências** registradas na ficha da tarefa ou em `docs/qa/<tarefa>.md`: o que foi executado, resultado, capturas quando visuais, limitações conhecidas.
6. **Se a engine ou o hardware não estiver disponível:** entregar a mudança revisável e registrar exatamente qual validação ficou pendente. Nunca afirmar que um teste passou sem executá-lo.
7. **Coerência documental:** IDs novos adicionados ao registro 27; inventário 18 atualizado para qualquer asset novo, inclusive placeholder.
8. Só então marcar a tarefa como concluída e escolher a próxima desbloqueada.

---

## 2. Fase 0 — Pré-produção (tabela)

| ID | Título | Objetivo / descrição | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-000 | Revisão humana da documentação | Ler 00–27 e registrar correções | — | Lista de correções aplicada ou recusada com motivo | VAL | H | 2 |
| INN-001 | Responder questões críticas | Q-001, Q-003, Q-005, Q-010, Q-013 em 26 | INN-000 | Respostas registradas em `docs/decisions/` | VAL | H | 2 |
| INN-002 | Consulta jurídica | Confirmar domínio público, título, marcas (24 §8) | INN-000 | Parecer arquivado; Q-002 respondida | VAL | H | 3 |
| INN-003 | Revisão de sensibilidade inicial | Avaliar 02 e 10 com consultor (Q-013) | INN-000 | Recomendações incorporadas ou registradas | VAL | H | 3 |
| INN-004 | Quadro de referência visual | Fotos históricas de domínio público/licenciadas + paletas de 13/14 | INN-000 | Quadro com procedência de cada imagem | ARTE | H | 2 |
| INN-005 | Orçamento indicativo de assets | Estimar custo de 18 por origem (produção, compra, terceirização) | INN-000 | Planilha revisável; Q-012 preparada | VAL | A+H | 2 |
| INN-006 | Autorização da Fase 1 | Decisão explícita do usuário | INN-001, INN-002 | Autorização registrada | VAL | H | 1 |

---

## 3. Fase 1 — Protótipo técnico (fichas completas)

```text
INN-010
Título: Projeto Godot e estrutura de pastas
Descrição: Criar game/project.godot (Godot 4.7.2, renderizador Compatibility), preset de export Windows x86_64 e a árvore de pastas de 17 §6, sem conteúdo.
Objetivo: Base reproduzível com editor e templates da mesma versão.
Arquivos/módulos: game/project.godot, game/export_presets.cfg, pastas game/app, systems, content, chapters, worlds, actors, ui, render, audio, assets, localization, tests; tools/ (script de build).
Dependências: INN-006; Q-004 (local da engine).
Recursos: Godot 4.7.2 portátil e templates (já presentes em VHB/tools/godot/4.7.2, a confirmar no início).
Critérios de conclusão:
- Projeto abre e importa em modo headless sem erros.
- Export Windows gera executável que abre uma cena vazia.
- Nenhum autoload por sistema configurado.
Testes:
- Importação headless.
- Execução gráfica do executável exportado (janela abre e fecha limpa).
Dificuldade: 1
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-011
Título: sys_player — movimentação básica em primeira pessoa
Descrição: Corpo com andar, andar cauteloso, correr, agachar, degraus e rampas; estados free/locked; sinal footstep.
Objetivo: Permitir exploração confortável e previsível.
Arquivos/módulos: game/systems/player/, game/tests/player/.
Dependências: INN-010.
Recursos: geometria cinza de teste (Claude Code).
Critérios de conclusão:
- Movimento frontal, lateral e diagonal sem aceleração excessiva.
- Corrida por segurar e por alternância (opção).
- Agachar reduz altura e não atravessa geometria.
- Degraus de escada de hotel transpostos sem tropeço.
- Estado locked impede movimento e preserva posição.
Testes:
- Headless: transições de estado e de gait; locked ignora input.
- Gráfico (export): caminhar em plano, rampa, escada, corredor de 0,9 m, quinas; em 30, 60 e 144 FPS com velocidade igual (medir distância por segundo).
Dificuldade: 2
Categoria: PROG
Execução: A (validação gráfica de conforto: A+H)
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-012
Título: sys_camera — câmera em primeira pessoa e opções
Descrição: Olhar por mouse e analógico, limites de pitch, FOV ajustável, inversão, head bob opcional (desligado por padrão), tremor só por evento com intensidade 0–100%, modo seated com limites de yaw/pitch.
Objetivo: Controle de câmera consistente e confortável.
Arquivos/módulos: game/systems/camera/, game/tests/camera/.
Dependências: INN-011, INN-022 (opções; pode usar valores padrão até lá).
Recursos: nenhum.
Critérios de conclusão:
- Sensibilidade independente de FPS.
- FOV de 60° a 100° aplicado sem reiniciar.
- Tremor com intensidade 0 não move a câmera.
- Modo seated respeita limites (para lvl_bus).
Testes:
- Headless: limites de pitch/yaw; intensidade zero.
- Gráfico: giro de 360° em FPS diferentes; relato de conforto.
Dificuldade: 2
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-013
Título: Spike e sys_retro_render — resolução interna e efeitos
Descrição: Renderizar o mundo num viewport com altura 240 ou 360 px, filtro nearest, dithering, redução de cor e granulação graduáveis; snapping de vértice e distorção afim opcionais; UI e legendas em resolução nativa.
Objetivo: Validar a estética D-018 e seu custo no renderizador Compatibility.
Arquivos/módulos: game/render/, game/tests/render/, docs/decisions/ADR-render.md.
Dependências: INN-010.
Recursos: cena de teste com texto pequeno, placa de rua, rosto placeholder.
Critérios de conclusão:
- Cada efeito tem controle 0–100% ou liga/desliga.
- Texto da UI nítido em 1080p e 1440p com o mundo em 240 px.
- Custo medido (ms por quadro) registrado em hardware disponível, sem extrapolar para outros.
Testes:
- Gráfico: capturas comparativas de cada efeito; alternar resolução interna em jogo.
- Desempenho: medição com e sem efeitos no export.
Dificuldade: 3
Categoria: PROG
Execução: A+H (aprovação estética humana)
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-014
Título: sys_interaction — alvo contextual e prompt
Descrição: Raycast da câmera, alcance padrão ~2 m ajustável por Interactable, verbo contextual, interações de toque e de segurar com progresso.
Objetivo: Interação única e previsível para todo o jogo.
Arquivos/módulos: game/systems/interaction/, game/tests/interaction/.
Dependências: INN-011, INN-012.
Recursos: objetos de teste (porta, papel, móvel).
Critérios de conclusão:
- Alvo atrás de parede nunca selecionado.
- Interação indisponível não emite pedido.
- Segurar emite progresso e cancelamento ao soltar ou desviar o olhar.
- Opção "tocar em vez de segurar" atendida.
Testes:
- Headless: seleção entre dois alvos, oclusão, disponibilidade.
- Gráfico: prompt visível e legível em todas as resoluções internas.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-015
Título: sys_ui e sys_documents — pausa, prompt e leitor mínimo
Descrição: Menu de pausa, prompt de interação, leitor de documento com rolagem, fonte 17–32 e fundo opaco; a UI emite intenções.
Objetivo: Base de interface sem HUD permanente.
Arquivos/módulos: game/ui/, game/systems/documents/, game/tests/ui/.
Dependências: INN-014, INN-020.
Recursos: fonte com licença verificada (placeholder identificado se necessário).
Critérios de conclusão:
- Pausa e leitura congelam o mundo.
- Documento não obtido não abre.
- Nenhum método de UI concede item, documento ou fato (revisão de contrato).
Testes:
- Headless: abrir/fechar leitor; intenção sem concessão.
- Gráfico: navegação por teclado, mouse e controle; texto a 17 e 32.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-016
Título: Spike de iluminação e sys_time_of_day (2 perfis)
Descrição: Comparar vertex color pintado, luzes dinâmicas limitadas e, se viável no renderizador, lightmaps; implementar LightingProfile "tarde" e "noite de lua" com névoa de profundidade.
Objetivo: Decidir o método de iluminação de 14 com evidência.
Arquivos/módulos: game/systems/time_of_day/, game/content/lighting/, docs/decisions/ADR-lighting.md.
Dependências: INN-013.
Recursos: rua cinza com vertex color de teste (Claude Code), uma lanterna de rua, uma janela iluminada.
Critérios de conclusão:
- Noite navegável sem lanterna em rota de teste (aprovação humana).
- Troca de perfil em jogo com transição.
- ADR com recomendação e custo medido.
Testes:
- Gráfico: capturas na mesma posição para cada método; medição de tempo de quadro.
Dificuldade: 4
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-017
Título: Spike de água costeira e do Manuxet
Descrição: Shader simples de mar e rio (ondulação por vértice, cor por profundidade falsa, reflexo de lua simulado) compatível com a resolução interna.
Objetivo: Água legível de dia e ao luar, base para evt_swimmers.
Arquivos/módulos: game/render/water/, game/tests/water/.
Dependências: INN-013, INN-016.
Recursos: plano de água e costa cinza.
Critérios de conclusão:
- Água distinguível da névoa ao luar.
- Custo medido registrado.
Testes:
- Gráfico: capturas em perfil tarde e noite; medição.
Dificuldade: 3
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-018
Título: sys_audio — buses, zonas de ambiência e emissores 3D
Descrição: Buses Master, Music, Ambience, SFX, Voice, UI; zonas com crossfade; emissores 3D com atenuação; limite de vozes; ducking para diálogo.
Objetivo: Base do horror sonoro.
Arquivos/módulos: game/audio/, game/systems/audio/, game/tests/audio/.
Dependências: INN-010.
Recursos: sons placeholder com licença registrada (vento, ondas, rangido, passos).
Critérios de conclusão:
- Transição entre zonas sem corte seco.
- Pausa suspende sons de evento.
- Volumes por bus vindos das opções.
Testes:
- Headless: lógica de prioridade e limite de vozes.
- Gráfico/auditivo: espacialização esquerda/direita/atrás com fones (humano confirma).
Dificuldade: 2
Categoria: AUDIO
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-019
Título: sys_subtitles — legendas de fala e de som
Descrição: Legendas com falante e descrições sonoras ("[passos no corredor]"), tamanho 17–32, fundo opaco, contador congelado na pausa.
Objetivo: Nenhum aviso de perigo depender só de som.
Arquivos/módulos: game/systems/subtitles/, game/tests/subtitles/.
Dependências: INN-015, INN-018.
Recursos: nenhum.
Critérios de conclusão:
- Legendas de som desligáveis, exceto avisos de perigo, que têm indicação mínima obrigatória.
- Sem sobreposição com prompts.
Testes:
- Headless: fila e duração; pausa congela.
- Gráfico: legibilidade em 240 px de mundo e 1080p de UI.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-020
Título: sys_story_state — fatos, itens, eventos únicos e allowlists
Descrição: GameState com fatos primitivos, itens, documentos, eventos únicos, temas de diálogo; allowlists derivadas das definições; cópias somente-leitura.
Objetivo: Fonte única de progresso.
Arquivos/módulos: game/systems/story_state/, game/content/ (definições mínimas de teste), game/tests/story_state/.
Dependências: INN-010.
Recursos: nenhum.
Critérios de conclusão:
- IDs fora da allowlist rejeitados.
- Concessões idempotentes.
- Evento único concluído não pode ser desfeito por restore posterior ao seu checkpoint.
Testes:
- Headless: invariantes acima e cópia não altera o estado vivo.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-021
Título: sys_save — slots, esquema, backup e corrupção
Descrição: JSON primitivo com schema_version, 3 slots, gravação temporária-validação-rotação, backup, recuperação, migração em memória (17 §5).
Objetivo: Saves seguros e recuperáveis.
Arquivos/módulos: game/systems/save/, game/tests/save/.
Dependências: INN-020.
Recursos: arquivos de save de teste (válido, truncado, tipos errados, ID desconhecido, esquema futuro, caminho de recurso injetado).
Critérios de conclusão:
- Todos os arquivos inválidos rejeitados sem alterar estado vivo.
- Primário corrompido recupera o backup e renomeia o danificado para .corrupt.
- Nenhum campo do save é interpretado como caminho, script ou objeto.
Testes:
- Headless: matriz de arquivos de teste; gravação interrompida simulada.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-022
Título: sys_settings — opções persistentes e remapeamento de teclado
Descrição: Arquivo de opções separado com schema_version: volumes, FOV, sensibilidade, inversão, head bob, tremor, corrida alternada, segurar/tocar, texto, contraste, efeitos retrô, resolução interna, assistência de navegação, travessia assistida; remap de teclado.
Objetivo: Acessibilidade desde o protótipo.
Arquivos/módulos: game/systems/settings/, game/ui/settings/, game/tests/settings/.
Dependências: INN-015.
Recursos: nenhum.
Critérios de conclusão:
- Arquivo inválido mantém padrões.
- Remap persiste e não remove eventos de controle.
- Conflito de teclas avisado.
Testes:
- Headless: migração, validação, conflito.
- Gráfico: alterar opções durante a pausa e retomar.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-023
Título: sys_sequence — sequências roteirizadas pausáveis
Descrição: Executor de SequenceDef com passos wait, play_audio, move_actor, suggest_look, subtitle, set_light_profile, require_input; modo de repetição acelerada após falha.
Objetivo: Cenas vividas pelo jogador sem cutscenes longas.
Arquivos/módulos: game/systems/sequence/, game/content/sequences/, game/tests/sequence/.
Dependências: INN-018, INN-019, INN-016.
Recursos: sequência de teste com 6 passos.
Critérios de conclusão:
- Pausa congela todos os passos.
- Sequência concluída não reexecuta após load.
- Repetição acelerada pula falas marcadas como já vistas.
Testes:
- Headless: ordem, pausa, conclusão única, repetição.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-024
Título: sys_inventory — Bolsos
Descrição: Até 8 item_*, sem combinação livre; vista para a UI; consumo.
Objetivo: Coleção enxuta de itens-chave (D-006).
Arquivos/módulos: game/systems/inventory/, game/content/items/, game/tests/inventory/.
Dependências: INN-020, INN-015.
Recursos: ícones placeholder.
Critérios de conclusão:
- Conceder duplicado não duplica; ID desconhecido falha; limite respeitado.
Testes:
- Headless: invariantes; item consumido não reaparece após restore posterior.
Dificuldade: 1
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-025
Título: Cena de teste "rua e quarto" em geometria cinza
Descrição: Um quarteirão com calçada, rua de paralelepípedos cinza, porta interativa, escada até um quarto com janela; placeholders identificados.
Objetivo: Reunir os sistemas de Fase 1 num espaço único de prova.
Arquivos/módulos: game/tests/sandbox_street/.
Dependências: INN-011, INN-014, INN-016, INN-018.
Recursos: geometria cinza (Claude Code); manifesto de placeholders.
Critérios de conclusão:
- Todos os sistemas de Fase 1 exercitados na cena.
- Manifesto lista cada placeholder.
Testes:
- Gráfico: percurso completo no export.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-026
Título: AppRoot, sys_chapter_flow mínimo e sys_scene_loader básico
Descrição: Composição da aplicação: menu → cena de teste → pausa → retorno; carregamento de nível com tela simples; spawn por CheckpointDef.
Objetivo: Esqueleto da aplicação sem autoloads por sistema.
Arquivos/módulos: game/app/, game/systems/chapter_flow/, game/systems/scene_loader/, game/tests/app/.
Dependências: INN-015, INN-021, INN-025.
Recursos: nenhum.
Critérios de conclusão:
- Novo jogo, continuar e voltar ao menu sem vazamento de nós.
- Spawn correto em dois checkpoints de teste.
Testes:
- Headless: ciclo menu→jogo→menu 20 vezes; contagem de nós estável.
- Gráfico: fluxo completo no export.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-027
Título: Export Windows e verificação gráfica da Fase 1
Descrição: Script de build reproduzível e roteiro de verificação manual (imagem, som, input, desempenho).
Objetivo: Validar no alvo real o que headless não valida.
Arquivos/módulos: tools/ (script de build), docs/qa/fase1-export.md.
Dependências: INN-026.
Recursos: PC Windows disponível; hardware mínimo a definir (19).
Critérios de conclusão:
- Executável roda fora do editor, sem instalar a engine.
- Relatório com capturas, tempo de quadro medido e limitações.
Testes:
- Execução gráfica completa da cena de teste com teclado/mouse e com controle.
Dificuldade: 2
Categoria: VAL
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-028
Título: Relatório do gate da Fase 1
Descrição: Consolidar evidências das tarefas INN-010..INN-031 em docs/qa/fase1-prototipo.md.
Objetivo: Decisão humana informada sobre seguir para o vertical slice.
Arquivos/módulos: docs/qa/fase1-prototipo.md, docs/20-ROADMAP.md (estado).
Dependências: INN-010..INN-027, INN-030, INN-031.
Recursos: nenhum.
Critérios de conclusão:
- Cada critério do gate da Fase 1 tem evidência ou pendência explícita.
Testes:
- Revisão cruzada com 23 §1.
Dificuldade: 1
Categoria: VAL
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-030
Título: Spike de streaming de distritos de lvl_innsmouth
Descrição: Carregar e descarregar dois distritos cinza adjacentes em segundo plano ao cruzar um limiar; medir travadas.
Objetivo: Validar D-004 antes de produzir distritos.
Arquivos/módulos: game/systems/scene_loader/, game/tests/streaming/, docs/decisions/ADR-streaming.md.
Dependências: INN-026.
Recursos: dois blocos cinza com densidade próxima da prevista em 07.
Critérios de conclusão:
- Travadas medidas e registradas; plano B (transição com porta/ponte) documentado se exceder a meta de 19.
- 50 ciclos de carga sem crescimento contínuo de memória.
Testes:
- Gráfico/desempenho no export.
Dificuldade: 4
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-031
Título: sys_objectives e sys_journal mínimos
Descrição: Objetivo derivado de fatos, Diário com notas e documentos, dica graduada em 3 níveis solicitada pelo jogador.
Objetivo: Orientação sem HUD permanente.
Arquivos/módulos: game/systems/objectives/, game/systems/journal/, game/ui/journal/, game/tests/journal/.
Dependências: INN-020, INN-015.
Recursos: textos de teste.
Critérios de conclusão:
- Entrada condicionada a fato futuro nunca aparece.
- Pedir dica não concede progresso.
Testes:
- Headless: fatos fora de ordem → mesmo objetivo pendente.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

---

## 4. Fase 2 — Vertical slice: Gilman House (fichas completas)

Design de referência: `08-GILMAN-HOUSE.md`. Roteiro: `04-HISTORIA-E-ROTEIRO.md` (ch05–ch06).

```text
INN-100
Título: Greybox do 4º andar do Gilman House
Descrição: Corredor, escada, room_428, room_n1, room_n2, room_s1, room_s2 e banheiro conforme planta de 08, com sentido de abertura das portas fiel ao conto.
Objetivo: Validar escala, rotas e tempos antes da arte.
Arquivos/módulos: game/worlds/lvl_gilman_interior/.
Dependências: INN-028 (gate F1).
Recursos: planta de 08.
Critérios de conclusão:
- Porta de ligação sul de room_428 abre para dentro do quarto; a norte abre para longe (pz06_hinges).
- Janelas de room_428 dão vista de 3 andares de queda ao pátio, sem escada de incêndio.
- Distâncias medidas registradas para calibrar o SiegeDirector.
Testes:
- Gráfico: percurso das rotas válidas e inválidas.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-101
Título: Greybox da fuga exterior
Descrição: Telhado inclinado do bloco da Paine, claraboia, armazém (caixas, escada), porta da Paine, porta dos fundos, pátio, prédio do lado da Washington com porta travada e cômodo com veneziana.
Objetivo: lvl_gilman_exterior_escape jogável em cinza.
Arquivos/módulos: game/worlds/lvl_gilman_exterior_escape/.
Dependências: INN-100.
Recursos: planta de 08.
Critérios de conclusão:
- Caminho canônico completo do telhado à Washington Street.
- Quedas fora do telhado detectadas por volume.
Testes:
- Gráfico: percurso completo; tentativas de saída fora da rota.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-102
Título: Greybox parcial de dist_square ao crepúsculo
Descrição: Semicírculo de prédios, rio a um lado, fachada do Gilman com cúpula, lobby, entrada da Paine e do início da Eliot; perfil de luz crepúsculo.
Objetivo: Prelúdio do vertical slice e identidade da cidade.
Arquivos/módulos: game/worlds/lvl_innsmouth/dist_square/.
Dependências: INN-016, INN-100.
Recursos: 06 e 07.
Critérios de conclusão:
- Caminho do retorno (cp05_return) até o lobby.
- Ponto do ônibus definido.
Testes:
- Gráfico: leitura dos marcos (cúpula, rio, refinaria ao longe).
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-103
Título: Modelo de porta: sentido, fechadura, ferrolho e estados
Descrição: Componente de porta com hinge_side, opens_toward, lock (chave/chave-mestra), bolt (presente/ausente/fechado), estados closed/locked/bolted/ajar/forced, sinais.
Objetivo: Base de pz05, pz06, pz07 e do cerco.
Arquivos/módulos: game/systems/interaction/doors/ (subcomponente de sys_interaction), game/tests/doors/.
Dependências: INN-014.
Recursos: nenhum.
Critérios de conclusão:
- Porta aferrolhada resiste a chave-mestra.
- Porta que abre para o jogador não pode ser arrombada com o ombro (feedback textual).
- Estados serializáveis como primitivos para checkpoint.
Testes:
- Headless: matriz de estados e transições.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-104
Título: pz05_bolt — transferir o ferrolho do armário
Descrição: Examinar a porta (evt_missing_bolt: marcas de remoção), encontrar o ferrolho do armário, usar item_keyring_tool para soltar e fixar.
Objetivo: Preparação canônica que torna justo o cerco posterior.
Arquivos/módulos: game/chapters/ch05_trap/, game/content/puzzles/pz05_bolt.tres.
Dependências: INN-103, INN-024, INN-031.
Recursos: texto de exame (04).
Critérios de conclusão:
- Puzzle concluível sem pistas externas; dica graduada disponível.
- Fato bolt_installed persiste no checkpoint.
- Sem a ferramenta (estado inválido) o jogo concede o item de forma coerente pelo entry_state do capítulo.
Testes:
- Headless: sequência de passos; idempotência.
- Gráfico: legibilidade das marcas na porta em 240 px.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-105
Título: pz06_hinges — escolher a porta de ligação certa
Descrição: Examinar as duas portas de ligação; texto do narrador sobre sentido de abertura; janela revela telhados a dois quartos de distância.
Objetivo: A rota norte é deduzida, não imposta.
Arquivos/módulos: game/chapters/ch06_gilman_escape/.
Dependências: INN-103, INN-100.
Recursos: textos (04).
Critérios de conclusão:
- Tentar a porta sul gera feedback e perda de tempo, nunca bloqueio.
- Dica graduada aponta a pista física (dobradiças) antes da solução.
Testes:
- Headless: ambos os caminhos convergem.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-106
Título: Arrombar a porta de ligação com o ombro
Descrição: Interação de repetir ou segurar (opção de acessibilidade) que acumula dano na porta norte; barulho alto que adianta o SiegeDirector.
Objetivo: Ação física simples sob pressão.
Arquivos/módulos: game/chapters/ch06_gilman_escape/, game/systems/interaction/doors/.
Dependências: INN-103, INN-111.
Recursos: SFX placeholder de impacto e madeira.
Critérios de conclusão:
- Modo segurar e modo repetir chegam ao mesmo resultado em tempo equivalente.
- Arrombar emite evento consumido pelo diretor (evt_passkeys).
Testes:
- Headless: equivalência de modos.
- Gráfico: retorno visual e sonoro a cada impacto.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-107
Título: pz07_barricade — móveis empurráveis
Descrição: Cama, cômoda e lavatório empurráveis apenas ao longo de trilhos curtos pré-definidos até encaixes diante das portas (sem física livre).
Objetivo: Barricadas confiáveis e testáveis.
Arquivos/módulos: game/systems/interaction/ (empurrar), game/chapters/ch06_gilman_escape/.
Dependências: INN-014, INN-100.
Recursos: placeholders de móveis.
Critérios de conclusão:
- Móvel não atravessa paredes nem prende o jogador.
- Encaixe reconhecido altera resistência da porta no SiegeDirector.
Testes:
- Headless: encaixes e resistência.
- Gráfico: empurrar com teclado e controle; jogador nunca fica preso.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-108
Título: pz08_drapery — cortina-corda e descida
Descrição: Puxar cortinas com varão, enganchar argolas no fecho da veneziana, sair pela janela sul de room_n2 e descer até o telhado (estado climbing).
Objetivo: Recriar a solução canônica sem salto perigoso.
Arquivos/módulos: game/chapters/ch06_gilman_escape/, game/systems/player/ (climbing).
Dependências: INN-011, INN-100, INN-101.
Recursos: animação de mãos placeholder.
Critérios de conclusão:
- Três passos claros com prompt contextual.
- Descida não pode ser interrompida em estado inválido.
- Saltar sem a cortina é possível mas arriscado (queda = falha com checkpoint cp06_window), coerente com 08.
Testes:
- Headless: ordem de passos.
- Gráfico: conforto da descida; enjoo avaliado.
Dificuldade: 3
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-109
Título: Claraboia, armazém e saída ao pátio
Descrição: Pular pela claraboia sem degraus, descer escada do armazém, porta da Paine (luz fraca) vs. porta dos fundos para o pátio.
Objetivo: Trecho de transição em silêncio relativo.
Arquivos/módulos: game/worlds/lvl_gilman_exterior_escape/.
Dependências: INN-101.
Recursos: textos curtos.
Critérios de conclusão:
- cp06_roof ativado ao aterrissar; checkpoint seguro.
- Escolher a porta da Paine gera aviso diegético (bombeiros possivelmente acordados) e permite voltar.
Testes:
- Gráfico: navegação só com luz ambiente e com item_flashlight.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-110
Título: pz09_courtyard — sair pelo prédio da Washington
Descrição: Pátio às escuras, portas abertas do lado da Washington, corredor com porta de rua travada, retorno interrompido por evt_courtyard_crowd, cômodo com veneziana sem caixilho.
Objetivo: Fechar a sequência do hotel com a primeira visão da multidão.
Arquivos/módulos: game/chapters/ch06_gilman_escape/.
Dependências: INN-109, INN-119.
Recursos: textos (04).
Critérios de conclusão:
- Sair pela veneziana e fechá-la como estava; transição para ch07 em cp07_washington.
- Ser visto no pátio = captura justa com aviso.
Testes:
- Headless: ordem e falha.
- Gráfico: legibilidade das portas abertas no escuro.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-111
Título: SiegeDirector — estados e tempos do cerco
Descrição: Parte de sys_pursuit. Estados prowl → knock → passkeys → ram → breach, com tempos mínimos e máximos por estado, gatilhos por ação do jogador e janela mínima de reação após cada escalada (08).
Objetivo: Pressão coordenada e justa sem IA complexa.
Arquivos/módulos: game/systems/pursuit/siege_director.gd, game/content/pursuit/siege_ch06.tres, game/tests/pursuit/.
Dependências: INN-103, INN-023.
Recursos: tabela de tempos de 08.
Critérios de conclusão:
- breach só ocorre em quarto ocupado após tempo máximo e com aviso audível e legendado.
- Pausa congela o diretor.
- Opção de travessia assistida estende tempos máximos.
Testes:
- Headless: transições determinísticas para sequências de entrada fixas.
Dificuldade: 4
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-112
Título: Harness de jogador simulado para o cerco
Descrição: Cena de teste que reproduz rotas: ótima, lenta, porta sul primeiro, sem barricadas, assistida.
Objetivo: Provar ausência de capturas injustas e de estados sem saída.
Arquivos/módulos: game/tests/pursuit/siege_harness.tscn.
Dependências: INN-111, INN-100.
Recursos: nenhum.
Critérios de conclusão:
- Rota ótima nunca capturada; rota lenta capturada só após tempo máximo; todas as rotas terminam em sucesso ou captura (nenhum travamento).
Testes:
- Headless: execução das cinco rotas com relatório.
Dificuldade: 3
Categoria: VAL
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-113
Título: Eventos de ch05 encadeados
Descrição: evt_gilman_crowd, evt_bus_breakdown, evt_missing_bolt, evt_corridor_creaks, evt_key_in_lock, evt_connecting_tries como SequenceDef com condições de 05.
Objetivo: Escalada lenta de tensão sem perigo real.
Arquivos/módulos: game/chapters/ch05_trap/, game/content/events/.
Dependências: INN-023, INN-104.
Recursos: textos e SFX placeholder.
Critérios de conclusão:
- Eventos únicos não repetem após load.
- evt_key_in_lock só após o jogador apagar a luz e deitar ou após tempo máximo de espera (08).
Testes:
- Headless: ordem, condições, unicidade.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-114
Título: evt_power_cut, luz interior noturna e item_flashlight
Descrição: Interruptor que não funciona, perfil de luz interior noturna, lanterna de bolso com feixe estreito; na rua ela aumenta a percepção (sys_perception, ligado em ch07).
Objetivo: Escuridão navegável com a lanterna como escolha.
Arquivos/módulos: game/systems/time_of_day/, game/chapters/ch06_gilman_escape/.
Dependências: INN-016, INN-024.
Recursos: textura de feixe placeholder.
Critérios de conclusão:
- Quartos navegáveis só com luar e transom; lanterna melhora leitura de detalhes (pegadas de poeira).
Testes:
- Gráfico: comparação com e sem lanterna; aprovação humana.
Dificuldade: 2
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-115
Título: Paisagem sonora dos perseguidores (placeholder)
Descrição: Passos pesados, chaves, batidas, arfadas, grunhidos, latidos abafados, ausência de fala inteligível; legendas de som.
Objetivo: O som conduz o cerco.
Arquivos/módulos: game/audio/ch06/, inventário 18.
Dependências: INN-018, INN-019.
Recursos: banco de sons licenciado ou gravado (humano).
Critérios de conclusão:
- Cada estado do SiegeDirector tem assinatura sonora e legenda.
- Origem e licença de cada som registradas.
Testes:
- Auditivo com fones e alto-falantes (humano).
Dificuldade: 3
Categoria: AUDIO
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-116
Título: Checkpoints cp05_return a cp06_courtyard
Descrição: CheckpointDef com spawn, estado de portas e móveis, fatos e eventos únicos preservados.
Objetivo: Repetições curtas e sem duplicação.
Arquivos/módulos: game/content/checkpoints/, game/chapters/ch05_trap/, ch06_gilman_escape/.
Dependências: INN-021, INN-111.
Recursos: nenhum.
Critérios de conclusão:
- Restaurar cp06_knock mantém ferrolho instalado e reinicia o cerco.
- Nenhum item ou evento único duplicado.
Testes:
- Headless: matriz checkpoint × fatos.
Dificuldade: 3
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-117
Título: Captura, retorno e repetição acelerada
Descrição: Captura em fade com som, sem violência explícita; retorno ao checkpoint; falas já ouvidas encurtadas.
Objetivo: Falha compreensível e barata de repetir.
Arquivos/módulos: game/systems/pursuit/, game/ui/capture/.
Dependências: INN-116, INN-023.
Recursos: texto curto de captura (04).
Critérios de conclusão:
- Tempo do momento da captura até controle restaurado medido e registrado (alvo em 19).
Testes:
- Headless: estado após captura.
- Gráfico: tempo medido no export.
Dificuldade: 2
Categoria: PROG
Execução: A
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-118
Título: Vista da janela de room_428
Descrição: Impostores de telhados a oeste, desfiladeiro e estação à direita, ferrovia e estrada de Rowley, estrada de Ipswich à esquerda ao luar.
Objetivo: O jogador aprende a rota de ch07 olhando pela janela, como o narrador.
Arquivos/módulos: game/worlds/lvl_gilman_interior/view/.
Dependências: INN-100, INN-016.
Recursos: silhuetas placeholder.
Critérios de conclusão:
- Ferrovia e estação reconhecíveis ao luar na resolução interna padrão.
Testes:
- Gráfico: playtester identifica os três elementos sem ajuda (meta).
Dificuldade: 2
Categoria: ARTE
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-119
Título: evt_church_lights e evt_courtyard_crowd
Descrição: Luzes na Ordem de Dagon e nas igrejas vistas do telhado; grupo de 6–10 figuras com lanternas saindo do Gilman, figura de manto e tiara.
Objetivo: Primeira visão coletiva dos perseguidores, sem detalhes de rosto.
Arquivos/módulos: game/chapters/ch06_gilman_escape/, game/actors/pur_courtyard_party/.
Dependências: INN-120, INN-101.
Recursos: personagens placeholder com animação de andar arrastado.
Critérios de conclusão:
- Rostos indistinguíveis na luz do pátio (D-011).
Testes:
- Gráfico: verificação visual.
Dificuldade: 3
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-120
Título: Spike de multidão de baixo custo
Descrição: Medir instâncias animadas viáveis (animação compartilhada, deslocamento por shader, MultiMesh para silhuetas distantes) para pur_courtyard_party e, depois, deep_procession.
Objetivo: Base técnica para evt_rowley_procession.
Arquivos/módulos: game/tests/crowd/, docs/decisions/ADR-crowd.md.
Dependências: INN-013.
Recursos: um modelo placeholder com ciclo de andar.
Critérios de conclusão:
- Tabela medida: número de instâncias × tempo de quadro no hardware disponível.
Testes:
- Desempenho no export.
Dificuldade: 4
Categoria: PROG
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-121
Título: Kit de arte do andar do hotel em qualidade-alvo
Descrição: Paredes, portas, cama de ferro, cômoda, lavatório, armário, cortinas, banheiro, texturas 64–128 px conforme 13.
Objetivo: Provar a direção de arte num espaço fechado.
Arquivos/módulos: game/assets/env/gilman/, inventário 18.
Dependências: INN-100, INN-004.
Recursos: artista humano ou compra licenciada.
Critérios de conclusão:
- Aprovação da direção de arte; licença e procedência completas.
Testes:
- Gráfico: comparação com o quadro de referência.
Dificuldade: 3
Categoria: ARTE
Execução: H (integração A)
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-122
Título: Textos de ch05–ch06 integrados
Descrição: Notas do narrador, exames, legendas, falas de Sargent e dos funcionários, jornal vespertino (doc_evening_paper), em PT-BR, por chave de localização.
Objetivo: Voz narrativa consistente e fiel.
Arquivos/módulos: game/localization/, game/content/documents/.
Dependências: roteiro aprovado (04).
Recursos: revisão humana de texto.
Critérios de conclusão:
- Nenhum texto hardcoded; marcas C/I/O conferidas.
Testes:
- Headless: todas as chaves existem.
Dificuldade: 2
Categoria: ROT
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-123
Título: Mixagem provisória do vertical slice
Descrição: Balancear ambiência do hotel, quedas d'água distantes, cerco e silêncio.
Objetivo: Som suficiente para avaliar tensão.
Arquivos/módulos: game/audio/ (buses e níveis).
Dependências: INN-115.
Recursos: humano com fones de referência.
Critérios de conclusão:
- Diálogo e avisos inteligíveis em volume padrão.
Testes:
- Auditivo em fones e alto-falantes.
Dificuldade: 2
Categoria: AUDIO
Execução: H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-124
Título: Playtest do vertical slice
Descrição: Sessões com ≥ 5 pessoas (23 §4), com e sem conhecimento do conto.
Objetivo: Medir tensão, clareza e justiça.
Arquivos/módulos: docs/qa/vertical-slice-playtest.md.
Dependências: INN-100..INN-123.
Recursos: testadores, formulário de 23.
Critérios de conclusão:
- Resultados observados registrados separadamente das metas.
Testes:
- Protocolo de 23 §4.
Dificuldade: 2
Categoria: VAL
Execução: H (preparação A)
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

```text
INN-125
Título: Relatório do gate da Fase 2
Descrição: Consolidar evidências, problemas e recomendação seguir/ajustar/reduzir.
Objetivo: Decisão humana sobre a viabilidade do projeto.
Arquivos/módulos: docs/qa/vertical-slice.md.
Dependências: INN-124.
Recursos: nenhum.
Critérios de conclusão:
- Cada critério do gate tem evidência ou pendência.
Testes:
- Revisão cruzada com 20 e 23.
Dificuldade: 1
Categoria: VAL
Execução: A+H
Status: PLANEJADO — NÃO IMPLEMENTAR NESTA ETAPA.
```

---

## 5. Fase 3 — Demonstração (tabela)

| ID | Título | Objetivo / descrição | Módulos / IDs | Dependências | Critério de conclusão | Testes | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|---|---|
| INN-200 | Abertura do manuscrito | `ch00_frame` em `lvl_toledo_room`, `doc_manuscript` | sys_sequence, sys_documents | INN-125 | Abertura ≤ 3 min, pulável após 1ª vez | headless + gráfico | PROG | A | 2 |
| INN-201 | Greybox de Newburyport | `lvl_newburyport_station`, `_library`, `_society`, `_square` | sys_scene_loader | INN-125 | Fluxo completo de ch01 em cinza | gráfico | PROG | A | 2 |
| INN-202 | Diálogos de ch01 | Bilheteiro, bibliotecária, Tilton, recepcionista | sys_dialogue, `evt_agent_warning` | INN-201 | Tópicos registram só ao confirmar | headless | PROG | A | 2 |
| INN-203 | Documentos de ch01 | `doc_bus_timetable`, `doc_essex_history`, `doc_jewellery_note`, `doc_intro_note`, `doc_tiara_label`, `doc_marsh_offers` | sys_documents | INN-202 | Textos com marcas C/I/O | headless (chaves) | ROT | A+H | 2 |
| INN-204 | `pz01_tilton` e `evt_tiara_reveal` | Bilhete → casa da Srta. Tilton → sala de exposição | sys_interaction, sys_sequence | INN-203 | Sem bloqueio; dica graduada | headless + gráfico | PROG | A | 2 |
| INN-205 | Modelo da tiara (herói) | Tiara com relevos marinhos e geométricos, 13 | AST (18) | INN-004 | Aprovação de arte; licença | gráfico | ARTE | H | 4 |
| INN-206 | `lvl_bus`: viagem | Modo sentado, paisagem, `evt_square_avoidance`, `evt_sargent_look` | sys_camera (seated), sys_sequence | INN-201 | Viagem 5–7 min com olhar livre | gráfico | PROG | A | 3 |
| INN-207 | `evt_crest_panorama` | Vista da cidade, recife, cúpula, estação | sys_time_of_day | INN-206 | Marcos legíveis em 240 px | gráfico + humano | ARTE | A+H | 3 |
| INN-208 | Entrada em Innsmouth pelo ônibus | `dist_north` (fachadas), `evt_dagon_hall_pass`, `evt_basement_priest` acionado por `framing_reached` | sys_camera, sys_sequence | INN-207 | Evento ocorre só se o jogador olhar; alternativa garantida se não olhar | headless + gráfico | PROG | A | 3 |
| INN-209 | `dist_gorge` greybox e ponte | Quedas, `evt_falls_roar`, chegada à praça | sys_audio | INN-208 | Ruído das quedas espacializado | gráfico | PROG | A | 2 |
| INN-210 | `dist_square` completo (dia) | Lojas, Gilman lobby, `npc_gilman_day_clerk` | sys_npc_routine | INN-209 | 10 NPCs ou menos, rotinas sem bloqueio | gráfico | PROG | A | 3 |
| INN-211 | `lvl_grocery` e entrega do mapa | `npc_grocery_clerk`, `item_sketch_map`, `cp03_grocery` | sys_dialogue, sys_map | INN-210 | Mapa concedido uma vez; diário registra avisos | headless | PROG | A | 2 |
| INN-212 | Tela final da demo | Encerramento após o mapa, sem spoilers | sys_chapter_flow | INN-211 | Volta ao menu limpa | gráfico | PROG | A | 1 |
| INN-213 | Menus e acessibilidade completos para a demo | 16 integral no trecho | sys_ui, sys_settings | INN-212 | Checklist de 16 satisfeito | gráfico | PROG | A | 3 |
| INN-214 | Verificação de licenças da demo | Tudo na build com procedência (18) | inventário | INN-213 | 100% verificado | revisão | VAL | H | 2 |
| INN-215 | Playtest fechado da demo | 23 §4 | — | INN-214 | Relatório observado vs. esperado | protocolo 23 | VAL | H | 2 |

---

## 6. Fase 4 — Campanha (tabelas por capítulo)

### ch01–ch02 (complemento da demo) — `INN-31x`, `INN-32x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-310 | Arte final de Newburyport | `lvl_newburyport_*` | INN-215 | Aprovação + licenças | ARTE | H | 3 |
| INN-311 | Y.M.C.A. e passagem da noite | transição 14→15 jul | INN-201 | Transição sem tela morta longa | PROG | A | 1 |
| INN-320 | Arte final do ônibus e de Sargent | `npc_joe_sargent` (look_1–2, D-013) | INN-206 | Aprovação de arte + revisão de sensibilidade | ARTE | H | 3 |
| INN-321 | Polimento do porão da igreja | `evt_basement_priest` | INN-208 | Teste de percepção em playtest | PROG | A+H | 2 |

### ch03 — `INN-33x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-330 | Greybox `dist_north` caminhável | igrejas Main/Church, Water norte, Martin | INN-030 | Streaming dentro da meta | PROG | A | 3 |
| INN-331 | Greybox `dist_patrician` | mansão Marsh, ponte precária, `doc_bridge_warning` | INN-330 | Rota até Paine/bombeiros | PROG | A | 2 |
| INN-332 | Greybox `dist_south_waterfront` | Main/Fish/Water sul, cais de Zadok | INN-030 | Cais de ch04 alcançável | PROG | A | 2 |
| INN-333 | `pz02_orientation` | `sys_map`, placas caídas, marcos | INN-330..332 | Todos os marcos alcançáveis sem marcador | PROG | A | 3 |
| INN-334 | Eventos ambientais de ch03 | `evt_window_watchers`, `evt_boarded_sounds`, `evt_bell_three`, `evt_marsh_car` (R) | INN-333 | Resfriamento evita repetição excessiva | PROG | A | 2 |
| INN-335 | Rotinas `res_*` diurnas | `sys_npc_routine` | INN-330 | Nenhum NPC bloqueia rota | PROG | A | 3 |
| INN-336 | Documentos de ch03 | `doc_order_notice`, `doc_church_tract` | INN-333 | Marcas C/I/O | ROT | A+H | 1 |
| INN-337 | `evt_zadok_sighting` e `pz03_whiskey` | `lvl_variety_store`, `item_whiskey`, `cp03_whiskey` | INN-333 | Pista do rapaz basta para achar a loja | PROG | A | 2 |
| INN-338 | Kit modular de Innsmouth (arte) | 13, 18 | INN-121 | Aprovação + licenças | ARTE | H | 5 |
| INN-339 | Trecho diurno opcional do bairro sul (R) | `dist_south_residential` | Q-016 | Só se aprovado | PROG | A | 2 |

### ch04 — `INN-34x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-340 | Caminhada com Zadok | Waite→Main→Water sul, `cp04_wharf` | INN-332 | Zadok segue sem bloquear | PROG | A | 2 |
| INN-341 | Temas desbloqueados por pistas | `sys_dialogue`, fatos de ch01–ch03 | INN-340 | Espinha fixa sempre completável | PROG | A | 3 |
| INN-342 | `pz04_zadok_pacing` | `item_whiskey`, estado `waiting_offer` | INN-341 | Cochilo sempre retoma | PROG | A | 2 |
| INN-343 | Luz e maré do testemunho | `evt_zadok_reef_gaze`, `evt_tide_turn`, perfil entardecer dourado | INN-016, INN-017 | Transição contínua | PROG | A+H | 3 |
| INN-344 | `evt_zadok_shriek` | ondulação local, fuga para o norte | INN-343 | Ambiguidade preservada (nada visível além da ondulação) | PROG | A | 2 |
| INN-345 | Texto final do testemunho | `doc_zadok_record` | 04 | Revisão literária e de sensibilidade (D-014) | ROT | H | 4 |
| INN-346 | Voz de Zadok (R) | `AST-VO` | Q-007 | Contrato e licença de voz | AUDIO | H | 4 |

### ch05–ch06 — `INN-35x`, `INN-36x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-350 | Retorno ao Gilman pela Marsh | `cp05_return`, encontro com grupos perto da Fall | INN-125, INN-332 | Rota ligada ao vertical slice | PROG | A | 2 |
| INN-351 | `lvl_restaurant` (R) | `npc_restaurant_staff` | INN-350 | Opcional, sem bloquear | PROG | A | 1 |
| INN-360 | Integração do vertical slice à campanha | fatos de ch01–ch05 | INN-350 | Save contínuo ch04→ch07 | PROG | A | 2 |

### ch07 — `INN-37x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-370 | `sys_perception` | luz, ruído, gait, lanterna | INN-114 | Determinístico; harness | PROG | A | 4 |
| INN-371 | Gait `shamble` | `sys_player` | INN-011 | Reduz suspeita só em área aberta ao luar | PROG | A | 2 |
| INN-372 | `PatrolDirector` | `pur_courtyard_party`, `pur_ipswich_party`, `pur_federal_motor` | INN-370 | Harness sem captura injusta | PROG | A | 4 |
| INN-373 | Greybox `dist_south_residential` noturno | Washington sul, Bates, Eliot/South, Babson, Lafayette, Adams | INN-030 | Rota de 09 completa | PROG | A | 3 |
| INN-374 | `evt_bates_hide`, `evt_washington_band` | pontos de esconderijo | INN-372 | Esconder-se é sempre legível | PROG | A | 3 |
| INN-375 | `evt_reef_signals`, `evt_swimmers`, `evt_rowboat` | vistas da South Street | INN-017 | Visíveis só ao olhar o mar; distância preservada | PROG | A+H | 3 |
| INN-376 | `evt_federal_motor` e mudança de plano | `sys_map`, `pz10_night_route` | INN-372 | Novo objetivo no Diário | PROG | A | 2 |
| INN-377 | `dist_bank_station` | armazéns, quedas mascaram passos, estação | INN-373 | `cp07_bank_street` | PROG | A | 2 |
| INN-378 | Ponte coberta e `pz11_bridge_gap` | `evt_bats`, `cp07_bridge` | INN-377 | Queda = retorno curto | PROG | A | 3 |
| INN-379 | `lvl_railway_marsh` e corte | `evt_ipswich_column`, `evt_wind_shift`, `cp07_cut` | INN-378 | Leitura do terreno ao luar | PROG | A | 3 |
| INN-380 | `evt_rowley_procession` | olhos fechados, `deep_procession`, desmaio | INN-120, INN-379 | Revelação dentro do orçamento medido | PROG | A+H | 5 |
| INN-381 | Profundos finais (modelo, rig, animação) | `deep_procession`, `deep_swimmer` | INN-338 | Aprovação + licenças | ARTE | H | 5 |

### ch08 — `INN-38x`

| ID | Título | Módulos / IDs | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-382 | `ch08a_rain` | `evt_no_prints`, `cp08_rain`, perfil chuva | INN-379 | Contraste calmo | PROG | A | 2 |
| INN-383 | `lvl_arkham` | `npc_federal_officer`, `npc_lapham_peabody`, `evt_marsh_eyes`, `item_peabody_notes` | INN-382 | Diálogos curtos; notas concedidas | PROG | A | 2 |
| INN-384 | `ch08c_aftermath` | `doc_raid_clippings`, `doc_federal_letter` (D-016) | INN-383 | Tom ambíguo revisado | ROT | A+H | 2 |
| INN-385 | `lvl_cleveland_house` e `pz12_genealogy` | fotos, cartas, miniatura, `doc_family_chart`, `evt_photo_shift` | INN-384 | Sem bloqueio; ambiguidade preservada | PROG | A | 4 |
| INN-386 | `lvl_cleveland_vault` | `evt_vault_tiara`, `doc_governess_note` | INN-385 | Desmaio silencioso | PROG | A | 2 |
| INN-387 | Sonhos e espelho | `lvl_dream_sea`, `evt_dream_descent`, `evt_grandmother_palace`, `evt_mirror_look` | INN-386 | Opção de reduzir efeitos; pistola não utilizável (D-015) | PROG | A+H | 4 |
| INN-388 | Final simbólico | `lvl_reef_final`, `evt_final_descent`, `doc_canton_plan`, créditos | INN-387 | Marcado [O] no material; tempo futuro | PROG | A+H | 3 |
| INN-389 | Fio contínuo ch00→ch08 | todos | INN-388 | Campanha completa em save contínuo e por seleção | VAL | A+H | 3 |

---

## 7. Fase 5 — Integração (tabela)

| ID | Título | Objetivo | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-400 | Revisão narrativa integral | Coerência com 01, 02, 04 | INN-389 | Lista de correções aplicada | ROT | H | 3 |
| INN-401 | Substituição de placeholders | Nenhum `ph_` na build | INN-389 | Varredura automática vazia | VAL | A | 2 |
| INN-402 | Animações finais | 18 §Animações | INN-381 | Aprovação | ARTE | H | 4 |
| INN-403 | Mixagem e masterização | 15 | INN-389 | Medição de loudness registrada | AUDIO | H | 4 |
| INN-404 | Localização EN (se Q-003) | `sys_localization` | INN-400 | Nenhuma chave faltando | ROT | A+H | 3 |
| INN-405 | Otimização por perfil medido | 19 | INN-401 | Metas medidas no hardware mínimo | PROG | A+H | 4 |
| INN-406 | Revisão de sensibilidade final | Q-013 | INN-400 | Parecer incorporado | VAL | H | 3 |
| INN-407 | Ajuste de ritmo | 05 curva de tensão vs. playtests | INN-389 | Durações observadas registradas | VAL | H | 3 |
| INN-408 | Suporte a controle completo | 16 §Controles | INN-213 | Remap de controle (R) | PROG | A | 3 |

## 8. Fase 6 — Polimento e lançamento (tabela)

| ID | Título | Objetivo | Dependências | Critério de conclusão | Cat. | Exec. | Dif. |
|---|---|---|---|---|---|---|---|
| INN-500 | Playtest amplo | 23 §4 com amostra maior | INN-405 | Relatório | VAL | H | 3 |
| INN-501 | Regressão completa | 23 §1 matriz | INN-500 | Sem bloqueantes | VAL | A+H | 3 |
| INN-502 | Revisão de acessibilidade | 16 | INN-500 | Checklist completo | VAL | H | 2 |
| INN-503 | Validação de licenças | 18 + 24 | INN-401 | Inventário 100% | VAL | H | 3 |
| INN-504 | Créditos e avisos de terceiros | Godot MIT e dependências | INN-503 | Tela e arquivo de licenças | PROG | A | 1 |
| INN-505 | Aviso de conteúdo | Q-010 | INN-406 | Texto aprovado no jogo e na loja | ROT | H | 1 |
| INN-506 | Instalação limpa em 3 máquinas | 19 | INN-501 | Relatório | VAL | H | 2 |
| INN-507 | Migração de saves beta→RC | `sys_save` | INN-501 | Saves antigos carregam | VAL | A | 2 |
| INN-508 | Material de loja para revisão | textos, capturas, trailer | INN-505 | Pacote revisável, **não publicado** | VAL | A+H | 2 |
| INN-509 | Release candidate | gate da Fase 6 | INN-500..508 | Decisão humana de lançamento | VAL | H | 2 |
