# CLAUDE.md — The Shadow Over Innsmouth

Instruções para Claude Code neste projeto. Este arquivo é a **fonte única** de regras operacionais; `AGENTS.md` apenas aponta para cá.

## 1. Projeto

Adaptação em primeira pessoa de *The Shadow over Innsmouth* (H. P. Lovecraft, 1936): horror cósmico, investigação e fuga sem combate, estética 3D de baixa fidelidade inspirada no PlayStation 1, PC Windows, offline, single-player, 3–5 horas (hipótese). Visão completa em `docs/00-VISAO-GERAL.md`; decisões fixadas e IDs em `docs/27-REGISTRO-DE-IDS.md`.

Objetivo: uma experiência narrativa completa, fiel à estrutura e aos temas do conto, comercializável e viável para uma equipe pequena.

## 2. Estado e autorização

- **Implementação autorizada pelo usuário em 27/10/2026** ("faça o jogo a partir do planejamento"). O desenvolvimento local segue `docs/20-ROADMAP.md` e `docs/21-BACKLOG-CLAUDE-CODE.md` na ordem das dependências; não pedir nova confirmação para tarefas reversíveis dentro desse escopo.
- Estado real do código, validações e pendências em `docs/28-ESTADO-IMPLEMENTACAO.md`. Não apresentar uma fatia jogável com arte provisória como jogo comercial completo.
- Não publicar, comprar, contratar, enviar builds ou criar contas por iniciativa própria.

## 3. Isolamento em relação a outros projetos

- Esta pasta é `VHB/Jogos/THE-SHADOW-OVER-INNSMOUTH/`. A VHB reúne jogos independentes em `Jogos/` (ver `../../AGENTS.md`); **The Dunwich Horror** fica em `../The Dunwich Horror/` com regras próprias, que não se aplicam aqui.
- Não copiar código de Dunwich (Q-005 resolvida como "só padrões"). A engine é uma cópia própria, verificada por SHA-256, em `tools/godot/4.7.2/` (Q-004 resolvida); não modificá-la.

## 4. Antes de alterar qualquer sistema

1. Ler `docs/00-VISAO-GERAL.md` e `docs/27-REGISTRO-DE-IDS.md`.
2. Ler o contrato do módulo em `docs/17-ARQUITETURA-TECNICA.md`.
3. Ler a tarefa em `docs/21-BACKLOG-CLAUDE-CODE.md` e suas dependências.
4. Ler o documento de design pertinente (mapa 06, níveis 07, hotel 08, fuga 09, personagens 10, IA 11, mecânicas 12, arte 13, luz 14, áudio 15, UI 16).
5. Inspecionar o estado atual dos arquivos e preservar alterações do usuário.

## 5. Fidelidade narrativa

- Toda informação narrativa recebe marca **[C]** canônica, **[I]** interpretação ou **[O]** original. Invenções nunca são apresentadas como fatos do conto (`docs/02-FIDELIDADE-CANONICA.md`).
- O narrador **não tem nome**. Não usar nomes de adaptações ou de notas de trabalho.
- Revelação completa dos Profundos somente na estrada de Rowley (`evt_rowley_procession`).
- A descida a Y'ha-nthlei é cena **simbólica [O]** em tempo futuro; o conto termina num plano.
- Nenhum personagem nomeado inventado no escopo Essencial.
- Responsabilidade: aparência nunca indica maldade; a "aparência de Innsmouth" usa traços anfíbios, não étnicos; os ilhéus do Pacífico não são representados visualmente; nenhuma ação interativa de suicídio; doença mental não é usada como espetáculo; a operação federal é ambígua.
- Citações do conto apenas do texto inglês (domínio público, a confirmar juridicamente); nunca de traduções modernas.

## 6. Escopo — limites

Proibido adicionar sem decisão documentada: combate, armas utilizáveis, mundo aberto, multiplayer, serviços online, LLM em tempo de execução, sanidade numérica, fome/sede/crafting/XP, geração procedural de capítulos, finais alternativos que substituam o canônico, visita ao sanatório de Canton, flashbacks visuais das ilhas do Pacífico.

## 7. Engine e convenções técnicas

- **Godot 4.7.2 Standard, GDScript tipado, renderizador Compatibility, Windows x86_64** (D-001). Editor e templates na mesma versão. Mudar engine, renderizador ou dependência só com justificativa documentada e teste de migração separado.
- Código, nomes de arquivo, nós, sinais e IDs em **inglês**; documentos, interface e comunicação em **português brasileiro**.
- Arquivos `snake_case.gd`/`.tscn`/`.tres`; classes `PascalCase`; constantes `UPPER_SNAKE`; sinais no passado (`door_forced`); IDs persistentes ASCII, estáveis e nunca reutilizados.
- Composição de cenas e `Resource`s tipados. Um único `AppRoot` compõe sistemas; **sem autoload por sistema e sem barramento global de eventos**.
- Separar definição imutável (Resources de conteúdo), estado de partida serializável (`sys_story_state`) e apresentação. A UI emite intenções; nunca concede itens nem altera progressão.
- Saves: JSON com tipos primitivos, `schema_version`, allowlist de IDs, cópia anterior preservada, recuperação de corrupção testada. Nunca carregar scripts, objetos ou caminhos vindos do save. Restaurar checkpoint não repete concessões nem eventos únicos.
- Input por ações remapeáveis. Nenhuma pista obrigatória depende só de cor, som, tremor ou efeito retrô. UI e legendas fora da resolução reduzida do mundo.
- Pausa congela simulação, perigo e temporizadores de sequência.

## 8. Assets e conteúdo externo

- Claude Code pode criar **geometria cinza, placeholders identificados e integração**. Modelos finais, rigs, animações complexas, texturas artísticas, vozes e mixagem final exigem produção humana ou aquisição licenciada e revisão.
- Todo recurso externo entra no inventário (`docs/18-INVENTARIO-DE-ASSETS.md`) com origem, autor, licença, prova de uso comercial, atribuição, alterações e status **antes** de entrar numa build distribuível. Placeholders usam prefixo `ph_` no nome do arquivo.
- Assets gerados por IA só com decisão registrada (Q-011) e divulgação exigida pela plataforma.

## 9. Fluxo de implementação futura (por tarefa)

1. Escolher a próxima tarefa desbloqueada do backlog; trabalhar numa tarefa pequena ou num conjunto inseparável.
2. Ler contratos e dependências (seção 4).
3. Implementar com uma **cena de validação isolada** para o módulo antes de usá-lo num capítulo.
4. Testar comportamento e invariantes (não testes que repetem a implementação). Lógica em modo headless; imagem, som, input e desempenho numa execução gráfica do export Windows.
5. Registrar evidências (comando executado, resultado, limitações) na própria tarefa ou em `docs/qa/`.
6. Atualizar documentação de contrato se o comportamento mudou e o registro de IDs se surgiram IDs.
7. Informar arquivos alterados, testes executados, resultado e riscos. Nunca afirmar que um teste passou sem executá-lo; se a engine/hardware não estiver disponível, registrar a validação pendente.
8. Nunca marcar fase concluída apenas porque arquivos existem: usar os gates de `docs/20-ROADMAP.md` e a matriz de `docs/23-TESTES-E-QUALIDADE.md`.

## 10. Segurança das alterações

- Inspecionar antes de editar; não restaurar, limpar ou sobrescrever arquivos alheios.
- Sem comandos destrutivos (`rm -rf`, `git reset --hard`, limpeza de `%APPDATA%`) sem pedido explícito.
- Executar apenas comandos existentes e necessários; comandos citados na documentação são exemplos futuros.
- Manter os documentos coerentes: mapa ↔ roteiro ↔ mecânicas ↔ backlog ↔ roadmap ↔ inventário de assets. Ao mudar um, verificar os demais.

## 11. Critérios de qualidade

Fidelidade ao conto; horror por antecipação e não por sustos aleatórios; legibilidade em perigo; nenhum bloqueio de progresso sem pista; checkpoints justos; acessibilidade da seção 16; desempenho dentro das metas de 19 **medidas** em hardware representativo; licenças completas.
