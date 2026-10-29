# 27 — Registro mestre de IDs e decisões fixadas

Este é o **documento de referência cruzada** do projeto. Todo capítulo, local, personagem, documento, puzzle, evento, checkpoint, sistema, tarefa e asset citado em outro documento deve usar um ID listado aqui. Se um documento precisar de um ID novo, ele é acrescentado aqui primeiro, na mesma alteração.

Regras de ID: ASCII minúsculo com `_`, estáveis, em inglês, nunca reutilizados para outro conteúdo. Tarefas e assets usam prefixo maiúsculo (`INN-`, `AST-`).

Marcação de fidelidade usada em toda a documentação:

| Marca | Significado |
|---|---|
| **[C]** Canônico | Está explicitamente no texto de 1936 / texto corrigido consultado. |
| **[I]** Interpretação | Dedução fundamentada a partir do texto, sem afirmação direta. |
| **[O]** Original | Criado para o jogo. Nunca apresentado como fato do conto. |

Níveis de escopo: **E** Essencial · **R** Recomendado · **Op** Opcional (ver `22-RISCOS-E-ESCOPO.md`).

---

## 1. Decisões fixadas (D-xxx)

Decisões abertas ficam em `26-DECISOES-PENDENTES.md` com prefixo `Q-`.

| ID | Decisão | Justificativa resumida | Documento-fonte |
|---|---|---|---|
| D-001 | Godot 4.7.2 Standard, GDScript tipado, renderizador Compatibility, alvo Windows x86_64. | Já instalado e validado nesta máquina (projeto Dunwich), estética de baixa fidelidade não exige Forward+, texto puro favorece edição por Claude Code, licença MIT. | 17 |
| D-002 | Primeira pessoa; protagonista **sem nome** (o "viajante"/narrador). | O conto nunca o nomeia. | 02, 03 |
| D-003 | Oito capítulos jogáveis + moldura do manuscrito (abertura e fecho). | Preserva os cinco capítulos literários e o epílogo genealógico. | 05 |
| D-004 | Mapa híbrido: núcleo urbano de Innsmouth em distritos carregados por streaming, reutilizado de dia e de noite; cenas pequenas separadas para Newburyport, ônibus, interiores, ferrovia, Arkham, Cleveland, Toledo e sonhos. | Melhor razão custo/identidade para equipe pequena. | 06, 07 |
| D-005 | Sem combate, sem armas utilizáveis, sem sanidade numérica, sem fome/sede/crafting/XP. | O narrador está desarmado e "lamenta estar desarmado" [C]; o horror é fuga e compreensão. | 03, 12 |
| D-006 | Inventário = "Bolsos" (≤ 8 itens-chave) + Diário + Documentos. | Evita gestão de objetos inúteis. | 12 |
| D-007 | Salvamento automático por checkpoint, 3 espaços de partida, seleção de capítulo após concluí-lo. Sem salvamento manual livre. | Impede estados impossíveis em sequências roteirizadas. | 17, 12 |
| D-008 | Diálogos em texto com vocalizações não verbais; dublagem completa apenas para Zadok Allen no nível R. | Custo de voz; Zadok é o coração dramático. | 15, 16 |
| D-009 | Vertical slice = **noite no Gilman House** (fim de ch05 até o pátio em ch06), com prelúdio curto na praça ao crepúsculo. | Máximo impacto, área delimitada, exercita quase todos os sistemas. | 20 |
| D-010 | Um único final canônico. A descida a Y'ha-nthlei é cena **simbólica [O]** em tempo futuro, não fato consumado. | O conto termina em plano, não em ação. | 04, 05 |
| D-011 | Revelação completa dos Profundos somente em `evt_rowley_procession` (ch07). Antes: silhuetas, sons, distância. | Fidelidade e construção do clímax. | 10, 09 |
| D-012 | Nenhum personagem nomeado inventado no escopo E. Papéis sem nome (ex.: agente federal) são marcados [O]. | Evita falsos fatos canônicos. | 10 |
| D-013 | A "aparência de Innsmouth" é desenhada a partir de traços anfíbios (olhos sem piscar, vincos/guelras no pescoço, pele cinza-azulada, membranas, andar) e **não** de traços étnicos humanos. | Responsabilidade na adaptação. | 02, 13 |
| D-014 | Os habitantes das ilhas do Pacífico citados por Zadok **nunca** são representados visualmente; a história chega apenas pela voz não confiável de Zadok e por objetos. | Evita reproduzir o enquadramento colonial. | 02, 04 |
| D-015 | Nenhuma ação interativa de suicídio. A pistola automática é objeto canônico observável e não utilizável; aviso de conteúdo no início. | Cuidado com tema sensível sem apagar o texto. | 02, 16 |
| D-016 | A operação federal de 1927–28 é apresentada de forma ambígua (prisões sem julgamento, campos, protestos) e não como vitória. | Fiel ao tom do capítulo I do conto. | 04 |
| D-017 | Interface e documentos em PT-BR; inglês como segundo idioma planejado (confirmação em Q-003). Código e IDs em inglês. | Público e convenção do estúdio. | 16 |
| D-018 | Mundo renderizado em resolução interna reduzida (altura 240 px padrão, opção 360 px); UI e legendas em resolução nativa. | Estética PS1 sem prejudicar leitura. | 13 |
| D-019 | Projeto isolado na pasta `THE-SHADOW-OVER-INNSMOUTH/`; o `AGENTS.md` da pasta-mãe pertence a The Dunwich Horror e não é alterado. | Preservar trabalho existente. | CLAUDE.md |
| D-020 | **Fechamento sem avaliação de terceiros (27/10/2026).** Por pedido do usuário ("termine o jogo sem avaliação de terceiros"), a versão 1.1 é fechada com autoteste próprio: jogadas automatizadas com renderização real, medições, revisão textual interna. Playtest, revisão de sensibilidade externa e parecer jurídico continuam recomendados antes de venda, mas não bloqueiam a 1.1. | Instrução direta do responsável. | 20, 23, 28 |
| D-021 | **Assets procedurais próprios são os assets da 1.1** (resolve Q-011 como "permitidos com divulgação"). Texturas (`TexFactory`), figuras (`FigureKit`) e sons (`SoundSynth`) são gerados por código do projeto, escrito com assistência de IA (Claude Code); não há arquivo de terceiros. O prefixo `ph_` sai dos IDs de som; os créditos e o material de loja divulgam a produção assistida por IA. Substituir por arte e áudio de produção continua possível sem mudar contratos. | Encerra a dependência de compra/contratação (proibida ao agente) e mantém licença limpa. | 18, 24 |
| D-022 | **Aviso de conteúdo** na primeira execução e no menu (resolve Q-010 como opção b), com a lista de 02 §6.4 e indicação do CVV (188) para o Brasil. | Cuidado com temas sensíveis. | 16 |
| D-023 | **Lançamento 1.1 só em PT-BR, sem dublagem** (estado atual de Q-003 e Q-007: opção a). Inglês continua planejado por D-017 e depende de Q-003. | Escopo do fechamento. | 16, 15 |

---

## 2. Capítulos e cenas (`ch`)

| ID | Título | Data/hora no jogo [C salvo indicação] | Duração-alvo (não validada) |
|---|---|---|---|
| `ch00_frame` | Moldura — o manuscrito | inverno 1930–31 ou depois [I] | 2–3 min (abertura) + fecho em ch08 |
| `ch01_journey` | A Viagem | 14 jul 1927, tarde e noite → 15 jul, 10h | 25–35 min |
| `ch02_forgotten_town` | A Cidade Esquecida | 15 jul, 10h–11h30 | 15–20 min |
| `ch03_secrets` | Os Segredos de Innsmouth | 15 jul, 11h30–16h | 40–55 min |
| `ch04_zadok` | O Testemunho de Zadok Allen | 15 jul, ~16h–19h15 | 20–30 min |
| `ch05_trap` | A Armadilha | 15 jul, 19h15 → 16 jul, ~1h30 | 15–20 min |
| `ch06_gilman_escape` | Fuga do Gilman House | 16 jul, ~1h30–2h15 | 10–20 min (com tentativas) |
| `ch07_night` | A Noite de Innsmouth | 16 jul, ~2h15–4h | 30–45 min |
| `ch08_inheritance` | A Herança de Innsmouth | 16 jul (meio-dia) → 1931 | 30–45 min |

Total-alvo: **3h10–4h50**, mediana ~4h. Hipótese a validar em playtest (ver 23).

Subcenas de ch08: `ch08a_rain` (despertar na chuva, estrada de Rowley), `ch08b_arkham` (depoimento e Peabody), `ch08c_aftermath` (Toledo/Oberlin: recortes da operação), `ch08d_cleveland` (arquivos de Walter), `ch08e_vault` (joias Orne), `ch08f_dreams` (sonhos e espelho), `ch08g_final` (decisão e cena simbólica [O]).

---

## 3. Níveis e distritos (`lvl`, `dist`)

| ID | Local | Fidelidade | Uso (cap.) | Período |
|---|---|---|---|---|
| `lvl_toledo_room` | Quarto/escrivaninha do narrador em Toledo | [I] local de escrita; quarto [O] | ch00, ch08f, ch08g | noite 1931 |
| `lvl_newburyport_station` | Bilheteria da estação de Newburyport | [C] | ch01 | tarde 14 jul |
| `lvl_newburyport_library` | Biblioteca Pública de Newburyport | [C] | ch01 | noite 14 jul |
| `lvl_newburyport_society` | Sala de exposição da Sociedade Histórica + rua até ela | [C] | ch01 | noite 14 jul |
| `lvl_newburyport_square` | Market Square, diante da Hammond's Drug Store | [C] | ch01 | manhã 15 jul |
| `lvl_bus` | Interior do ônibus + paisagem costeira + entrada em Innsmouth | [C] | ch01–ch02, ch05 (embarque frustrado) | manhã / 20h |
| `lvl_innsmouth` | Núcleo urbano (contém os distritos abaixo) | ver 06 | ch02–ch07 | dia e noite |
| `dist_square` | Town Square, Gilman House (fachada/lobby), Paine, início de Eliot, Waite, Marsh | [C] | ch02–ch07 | todos |
| `dist_gorge` | Desfiladeiro do Manuxet: ponte da Federal, quedas, refinaria, Old Square | [C] | ch02, ch03, vistas | dia, vista noturna |
| `dist_north` | Ao norte do rio: New Church Green, Ordem de Dagon, igreja gótica, cortiços da orla norte, igrejas de Main/Church, Martin | [C] | ch02 (ônibus), ch03 | dia; luzes vistas à noite |
| `dist_patrician` | Broad/Washington/Lafayette/Adams norte, mansão Marsh, ponte precária | [C] | ch03 | dia |
| `dist_south_waterfront` | Main, Fish e Water sul, cais em ruínas, cais de Zadok, quebra-mar | [C] | ch03, ch04, vista em ch07 | dia, entardecer |
| `dist_south_residential` | Washington sul, Bates, praça Eliot/Washington/South, South Street, Babson, Lafayette, Adams | [C] ruas; volumetria [O] | ch07 (R: trecho diurno opcional em ch03) | noite |
| `dist_bank_station` | Bank Street, armazéns, estação ferroviária em ruínas, borda do desfiladeiro | [C] | ch07 (vista em ch03/ch05) | noite |
| `lvl_grocery` | Mercearia First National (interior) | [C] | ch03 | dia |
| `lvl_variety_store` | Fundos da loja de variedades na Eliot | [C] | ch03 | dia |
| `lvl_restaurant` | Restaurante de balcão na praça | [C] | ch05 | crepúsculo |
| `lvl_gilman_interior` | Lobby, escadas, corredor do 4º andar, quartos `room_428`, `room_n1`, `room_n2`, `room_n3` (perseguidores; "the next door to the north" [I]), `room_s1`, `room_s2`, banheiro | [C] disposição; numeração vizinha [O] | ch02, ch05, ch06 | dia, noite |
| `lvl_gilman_exterior_escape` | Telhado do bloco da Paine, armazém pela claraboia, pátio, prédio do lado da Washington | [C] | ch06 | noite |
| `lvl_railway_marsh` | Trilhos à beira do desfiladeiro, ponte coberta, River Street, aterro, corte de mato, estrada de Rowley | [C] | ch07, ch08a | noite / chuva diurna |
| `lvl_arkham` | Sala de depoimento [O] + Sociedade Histórica de Arkham | [C] eventos; salas [O] | ch08b | dia |
| `lvl_cleveland_house` | Casa Williamson, escritório de Walter | [C] | ch08d | dia, jul 1928 |
| `lvl_cleveland_vault` | Sala de cofres de um banco no centro de Cleveland | [C] | ch08e | dia |
| `lvl_dream_sea` | Espaços oníricos submarinos, palácio fosforescente | [C] como sonho | ch08f | onírico |
| `lvl_reef_final` | Devil Reef e descida a Y'ha-nthlei | **[O] simbólico** | ch08g | noite onírica |

---

## 4. Personagens (`npc`) e arquétipos (`res`, `pur`, `deep`)

| ID | Personagem | Fidelidade | Capítulos | Interação |
|---|---|---|---|---|
| `narrator` | Viajante, 21 anos, de Toledo (Ohio), estudante de Oberlin, sem nome | [C] | todos | jogador |
| `npc_ticket_agent` | Bilheteiro de Newburyport, natural de Panton (Vermont) | [C] | ch01 | diálogo |
| `npc_ymca_clerk` | Recepcionista da Y.M.C.A. | [C] | ch01 | fala curta |
| `npc_librarian` | Bibliotecária de Newburyport (sem nome) | [C] | ch01 | diálogo curto, bilhete |
| `npc_anna_tilton` | Srta. Anna Tilton, curadora da Sociedade Histórica | [C] | ch01 | diálogo |
| `npc_joe_sargent` | Joe Sargent, motorista do ônibus | [C] | ch01, ch02, ch05 | quase mudo |
| `npc_bus_passenger` (×3) | Três passageiros de Innsmouth | [C] | ch01, ch05 | ambiente |
| `npc_gilman_day_clerk` | Funcionário idoso do Gilman, sem a "aparência" | [C] | ch02 | fala curta |
| `npc_gilman_night_clerk` | Funcionário noturno, taciturno | [C] | ch05 | fala curta |
| `npc_grocery_clerk` | Rapaz de ~17 anos da mercearia, de Arkham | [C] | ch03 | diálogo, entrega o mapa |
| `npc_fireman` (×2) | Bombeiros sem traços anormais | [C] | ch03 | ambiente |
| `npc_zadok_allen` | Zadok Allen, 96 anos | [C] | ch03, ch04 | testemunho |
| `npc_variety_clerk` | Vendedor da loja da Eliot, "civil a seu modo" | [C] | ch03 | compra do uísque |
| `npc_restaurant_staff` (×2) | Atendentes do restaurante | [C] | ch05 | fala curta |
| `npc_tiara_priest` | Figura de manto e tiara (porão da igreja; pátio; patrulha) | [C] | ch02, ch06, ch07 | silhueta |
| `npc_drunk_adams` | Homem embriagado na Adams Street | [C] | ch07 | susto sem perigo |
| `npc_federal_officer` | Funcionário do governo em Arkham (papel sem nome) | [C] existência / [O] fala | ch08b | depoimento |
| `npc_lapham_peabody` | E. Lapham Peabody, curador em Arkham | [C] | ch08b | diálogo |
| `npc_grandfather` | Avô Williamson | [C] | ch08d | ambiente, fala curta |
| `npc_uncle_walter` | Tio Walter | [C] | ch08d, ch08e | diálogo |
| `npc_father` | Pai do narrador | [C] | ch08f | presença sonora/porta |
| `npc_grandmother_dream` | Eliza Orne transformada, no sonho | [C] como sonho | ch08f | fala onírica |
| `npc_pththya_lyi` | Pth'thya-l'yi, no sonho | [C] como sonho | ch08f | presença, sem rosto pleno |
| Mencionados sem modelo | Obed Marsh, Barnabas Marsh, Matt Eliot, Walakea, Douglas, Lawrence, Eliza (fotos), mãe, Casey | [C] | docs/fotos | — |

Arquétipos de população (sem nome): `res_ordinary`, `res_wary`, `res_order_member`, `res_advanced` (raro, entrevisto), `res_nonnative`; perseguidores `pur_courtyard_party`, `pur_ipswich_party`, `pur_federal_motor`; Profundos `deep_swimmer`, `deep_procession`, `deep_dream`. Estágios visuais da transformação `look_0`–`look_4` (arte, não estatística; ver 10).

---

## 5. Itens dos Bolsos (`item`)

| ID | Item | Origem | Uso |
|---|---|---|---|
| `item_valise` | Valise (deixada no Gilman) | [C] | âncora narrativa |
| `item_keyring_tool` | Chaveiro com ferramenta 3-em-1 (chave de fenda) | [C] | `pz05_bolt` |
| `item_sketch_map` | Mapa desenhado pelo rapaz da mercearia | [C] | navegação, `pz02`, `pz10` |
| `item_watch` | Relógio de bolso | [C] | consulta de hora (dramática, sem cronômetro) |
| `item_whiskey` | Garrafa de uísque (1 quarto de galão) | [C] | `pz04_zadok_pacing` |
| `item_flashlight` | Lanterna de bolso | [C] | noite (risco de detecção) |
| `item_crackers` | Bolachas de queijo e de gengibre | [C] | cosmético/diálogo |
| `item_peabody_notes` | Notas genealógicas de Arkham | [C] | `pz12_genealogy` |

---

## 6. Documentos (`doc`)

Lista mestre; conteúdo completo em `12-MECANICAS-E-PUZZLES.md` §Documentos e texto final em `04-HISTORIA-E-ROTEIRO.md`.

| ID | Documento | Cap. | Fidelidade | Progressão |
|---|---|---|---|---|
| `doc_manuscript` | Primeira página do manuscrito do narrador | ch00 | [C] conteúdo / [O] forma | não |
| `doc_bus_timetable` | Anotação do bilheteiro: horários 10h e 19h, Hammond's | ch01 | [C] | sim (objetivo) |
| `doc_essex_history` | Trechos das histórias do condado de Essex | ch01 | [C] fatos / [O] redação | sim (abre Tilton) |
| `doc_jewellery_note` | Referência às joias no Museu Miskatonic e na Sociedade | ch01 | [C] | sim |
| `doc_intro_note` | Bilhete de apresentação da bibliotecária à Srta. Tilton | ch01 | [C] | sim |
| `doc_tiara_label` | Etiqueta da tiara: "provável procedência das Índias Orientais ou Indochina" | ch01 | [C] | não |
| `doc_marsh_offers` | Carta dos Marsh oferecendo comprar a tiara | ch01 | [I] (ofertas são [C]; carta [O]) | não |
| `doc_gilman_register` | Livro de registro do Gilman | ch02, ch05 | [O] forma | não |
| `doc_sketch_map` | Mapa (mesmo que `item_sketch_map`) | ch03 | [C] | sim |
| `doc_bridge_warning` | Placa de advertência da ponte precária | ch03 | [C] | não |
| `doc_order_notice` | Aviso desbotado na Ordem de Dagon (festas 30 abr / 31 out) | ch03 | [I] datas [C] | não |
| `doc_church_tract` | Folheto de credo heterodoxo ("transformações", "imortalidade corporal") | ch03 | [C] conteúdo / [O] objeto | não |
| `doc_zadok_record` | Registro do testemunho no Diário (paráfrase) | ch04 | [C] | sim (ch05) |
| `doc_evening_paper` | Jornal vespertino comprado no Gilman | ch05 | [C] objeto / [O] notícias | não |
| `doc_raid_clippings` | Recortes sobre as batidas de fev. 1928 | ch08c | [C] fatos / [O] redação | não |
| `doc_federal_letter` | Carta de agentes federais sobre a campanha | ch08c | [C] visitas / [O] carta | não |
| `doc_orne_letters` | Cartas do lado Orne nos arquivos de Walter | ch08d | [C] existência / [O] texto | sim |
| `doc_photo_eliza` | Fotografia da avó Eliza Orne | ch08d | [C] | sim |
| `doc_photo_douglas` | Fotografia do tio Douglas | ch08d | [C] | sim |
| `doc_miniature` | Miniatura da bisavó | ch08d | [I] (miniaturas são [C]) | sim |
| `doc_governess_note` | Advertência da governanta francesa sobre as joias | ch08e | [C] conteúdo / [O] objeto | não |
| `doc_family_chart` | Quadro genealógico montado pelo jogador | ch08d | [C] relações / [O] mecânica | sim |
| `doc_dream_notes` | Notas dos sonhos (1930–31) | ch08f | [C] conteúdo / [O] forma | não |
| `doc_canton_plan` | Plano de buscar o primo Lawrence em Canton | ch08g | [C] intenção / [O] texto | sim (final) |

---

## 7. Puzzles e desafios (`pz`)

| ID | Nome | Cap. | Tipo | Falha possível |
|---|---|---|---|---|
| `pz01_tilton` | Ver a tiara fora de hora | ch01 | investigação/social | não |
| `pz02_orientation` | Orientar-se com ruas sem placas | ch03 | navegação | não |
| `pz03_whiskey` | Obter bebida para Zadok | ch03 | investigação | não |
| `pz04_zadok_pacing` | Dosar a garrafa e escolher temas | ch04 | social | suave (Zadok cochila e retoma) |
| `pz05_bolt` | Transferir o ferrolho do armário | ch05 | manipulação | não |
| `pz06_hinges` | Ler a direção das portas e escolher a rota norte | ch06 | lógica espacial | sim (perda de tempo) |
| `pz07_barricade` | Barricadas com cama, cômoda, lavatório | ch06 | ação sob pressão | sim (captura) |
| `pz08_drapery` | Escada improvisada com cortina e argolas | ch06 | manipulação | sim (queda: E apenas se mal-sucedido por tempo) |
| `pz09_courtyard` | Sair do pátio pelo prédio da Washington | ch06 | exploração sob pressão | sim (captura) |
| `pz10_night_route` | Rota pelo mapa até a estação | ch07 | navegação/furtividade | sim (captura) |
| `pz11_bridge_gap` | Vão na ponte coberta | ch07 | travessia | sim (queda) |
| `pz12_genealogy` | Reconstruir a ascendência | ch08 | dedução documental | não |

---

## 8. Checkpoints (`cp`)

| ID | Momento seguro | Restaura |
|---|---|---|
| `cp01_station` | Início de ch01 | — |
| `cp01_library` | Entrada na biblioteca | documentos de ch01 já lidos |
| `cp01_society` | Diante da Sociedade | idem |
| `cp01_bus_stop` | Manhã, diante da Hammond's | idem |
| `cp02_bus_ride` | Ônibus em movimento | — |
| `cp02_square` | Desembarque na praça | — |
| `cp03_grocery` | Saída da mercearia com o mapa | mapa |
| `cp03_tour` | Autosave na entrada de cada distrito | descobertas |
| `cp03_whiskey` | Uísque comprado | garrafa |
| `cp04_wharf` | Sentados no cais | temas desbloqueados |
| `cp05_return` | 19h15, início do retorno | — |
| `cp05_room` | Entrada no quarto 428 | — |
| `cp06_knock` | Início das batidas à porta (ferrolho já colocado) | estado do quarto |
| `cp06_window` | Barricadas feitas em `room_n2` | — |
| `cp06_roof` | Aterrissagem no telhado | — |
| `cp06_courtyard` | Pátio | — |
| `cp07_washington` | Na Washington Street | — |
| `cp07_south_crossing` | Antes de cruzar a praça da South | — |
| `cp07_babson` | Babson Street | — |
| `cp07_bank_street` | Bank Street | — |
| `cp07_bridge` | Entrada da ponte coberta | — |
| `cp07_cut` | Entrada no corte de mato | — |
| `cp08_rain` | Despertar | — |
| `cp08_arkham` | Arkham | — |
| `cp08_cleveland` | Cleveland | progresso do quadro |
| `cp08_vault` | Sala de cofres | — |
| `cp08_dreams` | Primeira noite de sonhos | — |
| `cp08_final` | Antes da cena final | — |

---

## 9. Eventos (`evt`)

Catálogo completo com condição, duração, repetição e teste em `05-CAPITULOS-E-PROGRESSAO.md` §Catálogo de eventos. Categorias: **AMB** ambiental, **NAR** narrativo, **PSI** psicológico, **PER** perigo, **REV** revelação fundamental. Eventos marcados *único* nunca se repetem após concluídos e salvos.

| ID | Cat. | Cap. | Resumo | Único |
|---|---|---|---|---|
| `evt_agent_warning` | NAR | ch01 | Bilheteiro descreve Innsmouth | sim |
| `evt_tiara_reveal` | REV | ch01 | Primeira visão da tiara; pseudo-memória | sim |
| `evt_square_avoidance` | AMB | ch01 | Ociosos se afastam quando o ônibus chega | sim |
| `evt_sargent_look` | PSI | ch01 | Sargent observa o passageiro; troco sem palavra | sim |
| `evt_crest_panorama` | REV | ch02 | Do alto, a cidade e Devil Reef; "aceno" | sim |
| `evt_dagon_hall_pass` | NAR | ch02 | Ônibus passa pela Ordem de Dagon | sim |
| `evt_basement_priest` | PSI | ch02 | Sino das 11; figura de tiara no porão escuro | sim |
| `evt_falls_roar` | AMB | ch02 | Ruído das quedas na ponte | não |
| `evt_window_watchers` | AMB | ch03 | Janelas fechadas de sótão; sensação de vigia | não (com resfriamento) |
| `evt_boarded_sounds` | AMB | ch03 | Sons mais fortes nas fachadas tapadas ao norte | não |
| `evt_bell_three` | NAR | ch03 | Sino das 15h | sim |
| `evt_marsh_car` | NAR | ch03 | Carro fechado e cortinado rumo à refinaria | sim (R) |
| `evt_zadok_sighting` | NAR | ch03 | Zadok com os bombeiros | sim |
| `evt_zadok_reef_gaze` | NAR | ch04 | Zadok vê o recife e começa a falar | sim |
| `evt_tide_turn` | AMB | ch04 | A maré vira e sobe | sim |
| `evt_zadok_shriek` | REV | ch04 | Grito; ondulação local; fuga de Zadok | sim |
| `evt_gilman_crowd` | PSI | ch05 | Olhares na porta do hotel | sim |
| `evt_bus_breakdown` | NAR | ch05 | Sargent anuncia o defeito | sim |
| `evt_missing_bolt` | NAR | ch05 | Marcas do ferrolho removido | sim |
| `evt_corridor_creaks` | AMB | ch05 | Rangidos furtivos nas escadas | não |
| `evt_key_in_lock` | PER | ch05 | Chave tentada na fechadura | sim |
| `evt_connecting_tries` | PER | ch05 | Portas de ligação testadas ao norte e ao sul | sim |
| `evt_power_cut` | PER | ch06 | Luz cortada; vozes que não são vozes | sim |
| `evt_knocking` | PER | ch06 | Batidas firmes, depois contínuas | sim (repete após checkpoint) |
| `evt_passkeys` | PER | ch06 | Chaves-mestras nos quartos vizinhos | sim (idem) |
| `evt_ram` | PER | ch06 | Aríete na porta de ligação | sim (idem) |
| `evt_church_lights` | AMB | ch06 | Luzes na Ordem, igreja batista e congregacional | sim |
| `evt_courtyard_crowd` | PER | ch06 | Multidão com lanternas e figura de tiara no pátio | sim (idem) |
| `evt_bates_hide` | PER | ch07 | Duas figuras cruzam; esconder-se no vestíbulo | sim (idem) |
| `evt_reef_signals` | REV | ch07 | Clarões no recife e resposta da cúpula do Gilman | sim |
| `evt_swimmers` | REV | ch07 | Horda nadando rumo à cidade | sim |
| `evt_federal_motor` | PER | ch07 | Motor e perseguição pela Federal; mudança de plano | sim |
| `evt_ipswich_party` | PER | ch07 | Grupo da estrada de Ipswich, figura saltitante | sim (idem) |
| `evt_rowboat` | REV | ch07 | Bote com carga sob lona; brilho constante no recife | sim |
| `evt_washington_band` | PER | ch07 | Bando a uma quadra; teste do andar arrastado | sim (idem) |
| `evt_drunk_adams` | PSI | ch07 | Bêbado sai de uma porta | sim |
| `evt_bats` | AMB | ch07 | Morcegos na ponte coberta | sim |
| `evt_ipswich_column` | REV | ch07 | Coluna ondulante distante | sim |
| `evt_wind_shift` | PSI | ch07 | Vento muda; odor e sons do mar | sim |
| `evt_rowley_procession` | REV | ch07 | Procissão dos Profundos; olhos fechados; desmaio | sim |
| `evt_no_prints` | PSI | ch08 | Lama sem pegadas | sim |
| `evt_marsh_eyes` | REV | ch08 | Peabody: "os verdadeiros olhos Marsh" | sim |
| `evt_photo_shift` | PSI | ch08 | Rostos das fotos passam a sugerir algo | sim |
| `evt_vault_tiara` | REV | ch08 | Tiara Orne desembrulhada; desmaio silencioso | sim |
| `evt_dream_descent` | PSI | ch08 | Sonhos progressivos | sim por noite |
| `evt_grandmother_palace` | REV | ch08 | Sonho com a avó e Pth'thya-l'yi; shoggoth | sim |
| `evt_mirror_look` | REV | ch08 | O espelho confirma a aparência | sim |
| `evt_final_descent` | REV | ch08 | Cena simbólica [O] do recife a Y'ha-nthlei | sim |

---

## 10. Sistemas (`sys`)

Contratos em `17-ARQUITETURA-TECNICA.md`.

`sys_player`, `sys_camera`, `sys_interaction`, `sys_inventory`, `sys_documents`, `sys_journal`, `sys_map`, `sys_dialogue`, `sys_objectives`, `sys_story_state`, `sys_chapter_flow`, `sys_sequence`, `sys_npc_routine`, `sys_perception`, `sys_pursuit` (contém `SiegeDirector` de ch06 e `PatrolDirector` de ch07), `sys_audio`, `sys_subtitles`, `sys_time_of_day`, `sys_retro_render`, `sys_save`, `sys_settings`, `sys_ui`, `sys_scene_loader`, `sys_localization`.

---

## 11. Faixas de IDs de tarefas e assets

| Faixa | Fase / categoria |
|---|---|
| `INN-000`–`INN-009` | Fase 0 — pré-produção (validações humanas) |
| `INN-010`–`INN-099` | Fase 1 — protótipo técnico |
| `INN-100`–`INN-199` | Fase 2 — vertical slice (Gilman House) |
| `INN-200`–`INN-299` | Fase 3 — demonstração (ch01–ch02 + início de ch03) |
| `INN-300`–`INN-389` | Fase 4 — campanha (`INN-31x` ch01 … `INN-38x` ch08) |
| `INN-400`–`INN-499` | Fase 5 — integração |
| `INN-500`–`INN-599` | Fase 6 — polimento e lançamento |
| `AST-ENV-###` | Ambientes e kits modulares |
| `AST-PRP-###` | Objetos |
| `AST-CHR-###` | Personagens e criaturas |
| `AST-TEX-###` | Texturas e materiais |
| `AST-ANM-###` | Animações |
| `AST-AMB-###` / `AST-SFX-###` / `AST-MUS-###` / `AST-VO-###` | Áudio |
| `AST-UI-###` / `AST-FNT-###` | Interface e fontes |

---

## 12. IDs acrescentados na implementação 0.1.0 (27/10/2026)

| ID | Tipo | Uso |
|---|---|---|
| `room_n3` | quarto | Quarto ao norte de `room_n2`, ocupado pelos perseguidores; origem do aríete [I]. |
| Fatos de ch05–ch06 | `sys_story_state` | Lista fechada em `game/systems/story_state.gd` (`ALLOWED_FACTS`): `breakdown_heard`, `room_given`, `missing_bolt_seen`, `bolt_removed`, `bolt_fitted`, `hall_bolted`, `north_bolted`, `south_bolted`, `lay_down`, `key_in_lock_done`, `connecting_tries_done`, `power_cut_done`, `south_hinge_read`, `north_hinge_read`, `bed_at_south`, `bureau_at_hall`, `north_forced`, `n1_bolted`, `n2_bolted`, `n2_bed`, `n2_bureau`, `n2_washstand`, `n2_north_bolted`, `n2_south_bolted`, `drapery_down`, `rope_ready`, `roof_reached`, `church_lights_seen`, `attic_reached`, `courtyard_reached`, `wedged_door_seen`, `crowd_seen`, `shutter_closed`, `washington_reached`, entre outros. |
| Fases `S0`–`S8`, prazos `T1`–`T4`, falhas `F1`–`F6` | `SiegeDirector` | Internos do módulo (docs/08 §5–6); `FALL` = queda do telhado. |
| `ph_*`, `amb_*` | áudio provisório | Sons sintetizados por `SoundSynth`; substituir antes de distribuir. |
| `tod_dusk`, `tod_twilight`, `tod_moon_night` | perfis de luz | Implementados em `GilmanChapter._set_time` (docs/14). |

## 13. IDs acrescentados na implementação 0.2.0 (27/10/2026)

| ID | Tipo | Uso |
|---|---|---|
| Fatos de ch07 | `sys_story_state` | `bates_passed`, `reef_signals_seen`, `swimmers_seen`, `motor_heard`, `railway_plan`, `ipswich_party_seen`, `rowboat_seen`, `band_passed`, `drunk_seen`, `bank_reached`, `bats_seen`, `gap_jumped`, `marsh_reached`, `column_seen`, `wind_shift_seen`, `eyes_failed`, `procession_seen`, `ch07_done`. |
| `cp08_rain` | checkpoint | Gravado ao fim de ch07; abre ch08 quando existir. |
| Grupos do `PatrolDirector` | internos | `bates_pair` (dupla avulsa da Bates), `ipswich_car` + `ipswich_party` (= `pur_ipswich_party`), `band` (= `pur_courtyard_party`), `sentry_south` (sentinela [O]). |
| Portais/esconderijos | internos | `v_bates`, `v_portal`, `v_babson1`, `v_babson2`, `v_lafayette`, `v_adams` (volumetria [O]). |
| Fases de `NightChapter` | internos | `washington`, `bates`, `crossing`, `hide_portal`, `plan`, `babson`, `lafayette`, `south2`, `adams`, `bank`, `tracks`, `bridge`, `marsh`, `cut`, `procession`. |
| `CAPTURE`, `FALL_GAP`, `FALL` | falhas | Captura após detecção; queda no vão da ponte; queda no desfiladeiro. |
| `ph_motor`, `ph_flop`, `ph_patter`, `ph_bats` | áudio provisório | Sintetizados por `SoundSynth`. |

## 14. IDs acrescentados na implementação 0.3.0 (27/10/2026)

| ID | Tipo | Uso |
|---|---|---|
| Fatos de ch08 | `sys_story_state` | `no_prints_seen`, `told_zadok`, `told_hotel`, `told_signals`, `told_procession`, `testimony_done`, `peabody_met`, `marsh_eyes_heard`, `museum_skipped`, `clippings_read`, `letter_read`, `photos_eliza`, `photos_douglas`, `photo_shift_seen`, `letters_read`, `miniature_seen`, `chart_complete`, `chart_question`, `governess_read`, `tiara_fainted`, `dream1_done`, `dream2_done`, `dream3_done`, `mirror_seen`, `drawer_seen`, `plan_written`, `final_seen`, `ch08_done`. |
| `doc_peabody_notes` | documento | Versão legível de `item_peabody_notes` (registrado aqui como novo). |
| Posições do quadro | `pz12` | `slot_eliza`, `slot_douglas`, `slot_walter`, `slot_benjamin`, `slot_bride`, `slot_parents`, `slot_question` (opcional). |
| Fichas do quadro | `pz12` | `c_eliza`, `c_douglas`, `c_walter`, `c_benjamin`, `c_bride`, `c_parents`, `c_zadok` (pergunta), `c_tiara` (distratora). |
| Fases de `InheritanceChapter` | internos | `rain`, `interview`, `society`, `oberlin`, `cleveland`, `vault`, `night`, `dream1`–`dream3`, `mirror`, `final`, `swim`, `descent`. |

## 15. IDs acrescentados na implementação 1.0.0 (27/10/2026)

| ID | Tipo | Uso |
|---|---|---|
| `cp00_frame` | checkpoint | Moldura: a escrivaninha em Toledo; início de toda nova partida. |
| Fatos de ch00–ch04 | `sys_story_state` | `frame_written`, `agent_bus`, `agent_town`, `agent_hotel`, `no_talk`, `essex_read`, `jewellery_read`, `intro_note`, `tiara_seen`, `tilton_done`, `offers_read`, `ymca_done`, `avoidance_seen`, `sargent_paid`, `crest_seen`, `priest_seen`, `valise_checked`, `grocery_met`, `grocery_streets`, `grocery_avoid`, `grocery_churches`, `grocery_people`, `grocery_marsh`, `grocery_zadok`, `map_received`, `tour_started`, `visit_refinery`, `visit_waterfront`, `visit_north`, `visit_patrician`, `tract_read`, `woman_seen`, `order_watched`, `washington_bridge`, `zadok_present`, `zadok_sighted`, `hey_mister`, `zadok_fled`. |
| `item_whiskey` | item | A garrafa da loja da Eliot (`pz03_whiskey`). |
| Temas de Zadok | `pz04` | `topic_tiara`, `topic_reef`, `topic_refinery_gold`, `topic_churches`, `topic_marsh_house`, `topic_1846`, `topic_look` (propostos no docs/04, agora implementados). |
| `jrn_obed_daughter`, `jrn_obed_eyes` | notas do Diário | Pistas neutras do M7 para o `pz12`. |
| Capítulos | `AppRoot.CHAPTER_STARTS` | Menu "Escolher capítulo": `cp00_frame`, `cp02_bus_ride`, `cp03_grocery`, `cp04_wharf`, `cp05_return`, `cp06_knock`, `cp07_washington`, `cp08_rain`. |

## 16. IDs alterados ou acrescentados na versão 1.1.0 (27–29/10/2026)

| ID | Tipo | Uso |
|---|---|---|
| `sfx_*` (23 sons) | som procedural | Substituem os antigos `ph_*` com o mesmo sufixo (`ph_knock` → `sfx_knock` etc.), por D-021. Os `ph_*` não são reutilizados. |
| `Ambience`, `Effects` | canais de áudio | Laços de ambiente e sons pontuais; volumes em Configurações. |
| `ambience_volume`, `effects_volume`, `retro_strength`, `brightness`, `fullscreen`, `vsync`, `center_dot`, `subtitle_bg` | configurações (esquema 1) | Opções da 1.1; arquivos da 1.0 continuam válidos (teste de migração). |
| `chapters_unlocked` | configurações (esquema 1) | Lista permitida de inícios de capítulo alcançados (`SettingsStore.CHAPTER_IDS`). |
| `jrn_islands` | nota do Diário | Fim do M2 do testemunho: Zadok só repete o que ouviu de Obed e Matt Eliot (02 §6.1, D-014). |
| `action` | tipo de legenda | Descrição de algo visível; sempre exibida. |
