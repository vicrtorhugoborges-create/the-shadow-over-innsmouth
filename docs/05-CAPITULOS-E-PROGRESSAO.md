# 05 — Capítulos e progressão

Fichas de capítulo (20 campos), catálogo de eventos, ritmo e regras de morte/falha/salvamento. O roteiro cena a cena está em `04`; IDs em `27`. Durações são **metas não validadas**.

Legenda de fidelidade do campo 20: proporção aproximada do conteúdo do capítulo por marca.

---

## 1. Fichas de capítulo

### `ch01_journey` — A Viagem

1. **Sinopse:** em Newburyport, ao recusar o trem caro, o narrador ouve falar de Innsmouth; lê sobre a cidade, vê a tiara na Sociedade Histórica e embarca no ônibus de Joe Sargent.
2. **Objetivo narrativo:** despertar curiosidade e plantar tiara, Marsh, Ordem de Dagon, recife e Gilman antes de qualquer perigo.
3. **Objetivo do jogador:** descobrir uma rota barata para Arkham; ver a joia; embarcar às 10h.
4. **Emoção inicial:** neutra, curiosa (turista econômico).
5. **Emoção final:** fascínio inquieto, primeira pseudo-memória.
6. **Locais:** `lvl_toledo_room` (moldura), `lvl_newburyport_station`, `lvl_newburyport_square`, `lvl_newburyport_library`, `lvl_newburyport_society`, `lvl_bus` (embarque).
7. **Personagens:** `npc_ticket_agent`, `npc_librarian`, `npc_anna_tilton`, `npc_ymca_clerk`, `npc_joe_sargent`, `npc_bus_passenger` ×3.
8. **Obrigatórios:** `evt_agent_warning`, leitura de `doc_essex_history`/`doc_jewellery_note`, `doc_intro_note`, `evt_tiara_reveal`, embarque com `evt_sargent_look`.
9. **Opcionais:** tópicos extras do bilheteiro; recusas na Market Square; `doc_marsh_offers` (R); `evt_square_avoidance` observado com atenção.
10. **Mecânicas:** diálogo por tópicos, leitura, exame com rotação, caminhada.
11. **Puzzles:** `pz01_tilton`.
12. **Ameaças:** nenhuma (zona sem falha).
13. **Sons:** estação (trens distantes), biblioteca (relógio, páginas), sala escura da Sociedade (zumbido da lâmpada), praça matinal.
14. **Visuais:** luz elétrica isolada na vitrine; manhã clara na praça; ônibus cinzento sujo.
15. **Documentos:** `doc_manuscript`, `doc_bus_timetable`, `doc_essex_history`, `doc_jewellery_note`, `doc_intro_note`, `doc_tiara_label`, `doc_marsh_offers` (R).
16. **Transições:** moldura → estação (tinta); biblioteca → rua noturna (porta); Sociedade → Y.M.C.A. → manhã (corte com texto); embarque → título do cap. II.
17. **Conclusão:** sentar no ônibus em movimento.
18. **Duração:** 25–35 min.
19. **Dependências técnicas:** `sys_dialogue`, `sys_documents`, `sys_interaction` (exame), `sys_journal`, `sys_chapter_flow`, `sys_scene_loader`.
20. **Fidelidade:** ~80% C (fatos, locais, falas reescritas), ~10% I, ~10% O (moldura, layouts, carta dos Marsh).

### `ch02_forgotten_town` — A Cidade Esquecida

1. **Sinopse:** a viagem costeira, o panorama da crista, a entrada pela New Church Green, o padre de tiara no porão, a ponte e a chegada à praça e ao Gilman.
2. **Objetivo narrativo:** apresentar Innsmouth como personagem e o primeiro choque psicológico.
3. **Objetivo do jogador:** chegar, deixar a valise, encontrar alguém de fora para perguntar.
4. **Emoção inicial:** expectativa de antiquário.
5. **Emoção final:** estranhamento e sensação de ser observado.
6. **Locais:** `lvl_bus`, `dist_north` (de passagem), `dist_gorge` (ponte), `dist_square`, `lvl_gilman_interior` (lobby).
7. **Personagens:** `npc_joe_sargent`, `npc_tiara_priest`, `npc_gilman_day_clerk`, `res_ordinary`, `res_wary`.
8. **Obrigatórios:** `evt_crest_panorama`, `evt_dagon_hall_pass`, `evt_basement_priest`, `evt_falls_roar`, entrega da valise.
9. **Opcionais:** observar Sargent no trajeto; ler `doc_gilman_register`; percorrer a praça.
10. **Mecânicas:** câmera livre sentado (sequência sobre trilho), exame à distância, caminhada.
11. **Puzzles:** nenhum.
12. **Ameaças:** nenhuma (zona sem falha).
13. **Sons:** motor e chocalho do ônibus, vento costeiro, gaivotas, sino rachado das 11, quedas ensurdecedoras na ponte.
14. **Visuais:** dia ensolarado e quente; dessaturação e névoa leve em Innsmouth; campanários sem relógio.
15. **Documentos:** `doc_gilman_register`.
16. **Transições:** saída de Newburyport em movimento contínuo; streaming do ônibus para `lvl_innsmouth`; desembarque sem carregamento visível.
17. **Conclusão:** entrar em `lvl_grocery`.
18. **Duração:** 15–20 min.
19. **Dependências:** `sys_sequence` (trajeto do ônibus), `sys_scene_loader` (streaming), `sys_time_of_day` (manhã), `sys_camera` (limites sentado).
20. **Fidelidade:** ~90% C, ~5% I (igreja congregacional), ~5% O (assinatura de Casey).

### `ch03_secrets` — Os Segredos de Innsmouth

1. **Sinopse:** o rapaz da mercearia explica a cidade e desenha o mapa; o narrador percorre desfiladeiro, orla sul, norte do rio e ruas patrícias; vê Zadok; compra uísque e o atrai.
2. **Objetivo narrativo:** acumular indícios de transformação, sigilo e coerção; ensinar a geografia que salvará a vida do jogador.
3. **Objetivo do jogador:** conhecer a cidade com o mapa; encontrar alguém que conte a história.
4. **Emoção inicial:** curiosidade metódica.
5. **Emoção final:** desconfiança e mal-estar crescente.
6. **Locais:** `lvl_grocery`, `dist_square`, `dist_gorge`, `dist_south_waterfront`, `dist_north`, `dist_patrician`, `lvl_variety_store`; vista de `dist_bank_station`.
7. **Personagens:** `npc_grocery_clerk`, `npc_fireman` ×2, `npc_zadok_allen`, `npc_variety_clerk`, `res_*`.
8. **Obrigatórios:** receber o mapa; visitar ao menos três distritos do mapa (ver §4.4); `evt_zadok_sighting`; comprar o uísque; atrair Zadok.
9. **Opcionais:** todos os tópicos do rapaz; quarto distrito; `evt_marsh_car` (R); aproximação à New Church Green; `doc_order_notice`, `doc_church_tract`; trecho diurno de `dist_south_residential` (R).
10. **Mecânicas:** navegação com mapa, exame, diálogo, compra (troca de item), "mostrar item".
11. **Puzzles:** `pz02_orientation`, `pz03_whiskey`.
12. **Ameaças:** psicológicas apenas; observação; nenhuma falha.
13. **Sons:** quedas, maré, rangidos atrás de fachadas tapadas, sino das 15h, ausência de cães e gatos.
14. **Visuais:** sol a pino → início de tarde; sombras curtas; janelas de sótão fechadas; olmos nas ruas patrícias.
15. **Documentos:** `doc_sketch_map`, `doc_bridge_warning`, `doc_order_notice`, `doc_church_tract`.
16. **Transições:** distritos por streaming sem tela de carga; interiores com porta (carregamento curto mascarado).
17. **Conclusão:** chegar à Main Street com Zadok seguindo.
18. **Duração:** 40–55 min.
19. **Dependências:** `sys_map`, `sys_objectives`, `sys_npc_routine`, `sys_audio` (zonas), `sys_scene_loader`, `sys_inventory`.
20. **Fidelidade:** ~75% C, ~10% I, ~15% O (gestos ambientais, layout de ruas, folheto).

### `ch04_zadok` — O Testemunho de Zadok Allen

1. **Sinopse:** no cais sul, Zadok conta a história de Obed, do pacto, de 1846 e dos Marsh; grita e foge.
2. **Objetivo narrativo:** transformar boatos em uma história coerente e não confiável; plantar as pistas genealógicas.
3. **Objetivo do jogador:** fazer Zadok falar sem embriagá-lo demais; escutar.
4. **Emoção inicial:** ceticismo curioso.
5. **Emoção final:** apreensão partilhada, susto.
6. **Locais:** `dist_south_waterfront` (Water Street sul, cais).
7. **Personagens:** `npc_zadok_allen`.
8. **Obrigatórios:** M1–M7, `evt_zadok_reef_gaze`, `evt_tide_turn`, `evt_zadok_shriek`.
9. **Opcionais:** temas `topic_*` (propostos, ver 04 §6.1); olhar o recife em momentos escolhidos.
10. **Mecânicas:** oferecer garrafa, perguntar tema, olhar livre, mão no ombro (trava breve).
11. **Puzzles:** `pz04_zadok_pacing`.
12. **Ameaças:** nenhuma real; ondulação ambígua.
13. **Sons:** maré subindo, ondas na alvenaria, gaivotas rareando, voz de Zadok (VO no nível R), grito.
14. **Visuais:** luz dourada crescente; recife nítido; ondulação local no fim.
15. **Documentos:** `doc_zadok_record` (entradas por movimento), `jrn_obed_daughter`, `jrn_obed_eyes` (propostos).
16. **Transições:** caminhada → assento (sem corte); elipses por mudança de luz entre movimentos; fuga de Zadok → hora 19h15.
17. **Conclusão:** chegar à Water Street após a fuga e constatar a ausência de Zadok.
18. **Duração:** 20–30 min.
19. **Dependências:** `sys_dialogue` (movimentos, temas condicionais), `sys_sequence`, `sys_time_of_day` (transição contínua), `sys_subtitles`, `sys_story_state`.
20. **Fidelidade:** ~90% C, ~5% I, ~5% O (mecânica de temas, deslocamento da fala dos olhos).

### `ch05_trap` — A Armadilha

1. **Sinopse:** o retorno, o ônibus "quebrado", o quarto 428, o jantar, o ferrolho, os rangidos, a chave na fechadura.
2. **Objetivo narrativo:** aprisionar; converter premonição em ameaça real.
3. **Objetivo do jogador:** sair da cidade; depois, apenas passar a noite em segurança.
4. **Emoção inicial:** pressa e alívio próximo.
5. **Emoção final:** certeza de perigo, decisão de fugir.
6. **Locais:** `dist_square`, `lvl_bus`, `lvl_gilman_interior`, `lvl_restaurant`.
7. **Personagens:** `npc_joe_sargent`, `npc_bus_passenger` ×3, `npc_gilman_night_clerk`, `npc_restaurant_staff` ×2, `res_*`.
8. **Obrigatórios:** `evt_gilman_crowd`, `evt_bus_breakdown`, registro, `evt_missing_bolt`, `pz05_bolt`, deitar, `evt_key_in_lock`, `evt_connecting_tries`.
9. **Opcionais:** jantar (recomendado pelo Diário; pode ser pulado), jornal/revista, banheiro.
10. **Mecânicas:** rota com mapa, ferramenta, ferrolhos, ação "deitar", escuta.
11. **Puzzles:** `pz05_bolt`.
12. **Ameaças:** sem falha neste capítulo.
13. **Sons:** cochichos, guturais, motor parado, escadas, corredor, rangidos, chave.
14. **Visuais:** dourado → crepúsculo azul → lâmpada fraca → escuridão quase total.
15. **Documentos:** `doc_gilman_register`, `doc_evening_paper`.
16. **Transições:** praça → hotel → restaurante (porta) → quarto; tempo avança por ações ("deitar").
17. **Conclusão:** fim de `evt_connecting_tries`.
18. **Duração:** 15–20 min.
19. **Dependências:** `sys_interaction` (ferrolhos), `sys_inventory` (ferramenta), `sys_time_of_day`, `sys_audio` (oclusão por portas), `sys_sequence`.
20. **Fidelidade:** ~90% C, ~10% O (notícias do jornal, desfazimento do texto).

### `ch06_gilman_escape` — Fuga do Gilman House

1. **Sinopse:** luz cortada, batidas, arrombamento da porta norte, corrida pelos quartos, barricadas, cortina-corda, telhado, armazém e pátio.
2. **Objetivo narrativo:** terror ativo e coordenado; a cidade organizada contra o narrador.
3. **Objetivo do jogador:** chegar à rua sem ser capturado.
4. **Emoção inicial:** medo controlado.
5. **Emoção final:** fuga precária, cidade inteira desperta.
6. **Locais:** `lvl_gilman_interior` (`room_428`, `room_n1`, `room_n2`, `room_s1`), `lvl_gilman_exterior_escape`.
7. **Personagens:** perseguidores (som), `pur_courtyard_party`, `npc_tiara_priest`.
8. **Obrigatórios:** `evt_power_cut`, `evt_knocking`, `evt_passkeys`, `evt_ram`, `pz06_hinges`, `pz07_barricade`, `pz08_drapery`, `evt_church_lights`, `evt_courtyard_crowd`, `pz09_courtyard`.
9. **Opcionais:** examinar pegadas no pó; tentar a porta sul (perde tempo); olhar pela janela do 428 antes de agir.
10. **Mecânicas:** arrombar com o ombro (repetição ou segurar), ferrolhos, empurrar móveis, descer pela cortina, cair pela claraboia, venezianas.
11. **Puzzles:** `pz06_hinges`, `pz07_barricade`, `pz08_drapery`, `pz09_courtyard`.
12. **Ameaças:** captura nos quartos e no pátio (ver §3).
13. **Sons:** batidas, chaves-mestras, aríete, latidos e coaxos, madeira estilhaçando, ardósias, morcego-silêncio do armazém.
14. **Visuais:** lanterna do jogador; luz trêmula pelo bandeirote; lua sobre telhados; lanternas no pátio.
15. **Documentos:** nenhum (perigo; leitura bloqueada).
16. **Transições:** contínuas; queda pela claraboia mascara troca de cena para `lvl_gilman_exterior_escape`.
17. **Conclusão:** sair pela janela de venezianas para a Washington Street.
18. **Duração:** 10–20 min.
19. **Dependências:** `sys_pursuit` (`SiegeDirector`), `sys_interaction` (móveis), `sys_save` (checkpoints em perigo), `sys_audio` (posicional por porta), `sys_perception` (pátio).
20. **Fidelidade:** ~90% C, ~10% O (cronômetros, numeração dos quartos).

### `ch07_night` — A Noite de Innsmouth

1. **Sinopse:** fuga pelas ruas do sul ao luar; sinais e nadadores; estradas vigiadas; rota pela ferrovia; ponte coberta; procissão na estrada de Rowley.
2. **Objetivo narrativo:** clímax de perigo e revelação dos Profundos.
3. **Objetivo do jogador:** sair de Innsmouth sem ser visto.
4. **Emoção inicial:** urgência.
5. **Emoção final:** colapso — terror absoluto e desmaio.
6. **Locais:** `dist_south_residential`, `dist_bank_station`, `lvl_railway_marsh`; vistas de `dist_square` e do recife.
7. **Personagens:** `pur_courtyard_party`, `pur_ipswich_party`, `pur_federal_motor`, `npc_tiara_priest`, `npc_drunk_adams`, `deep_swimmer`, `deep_procession`.
8. **Obrigatórios:** `evt_reef_signals`, `evt_swimmers`, `evt_federal_motor`, `evt_washington_band`, `pz10_night_route`, `pz11_bridge_gap`, `evt_rowley_procession`.
9. **Opcionais:** `evt_bates_hide` (pode ser evitado com outra calçada), `evt_rowboat` (exige olhar), desvios curtos de rota.
10. **Mecânicas:** andar arrastado, agachar, esconderijos, lanterna como risco, mapa, salto, manter olhos fechados.
11. **Puzzles:** `pz10_night_route`, `pz11_bridge_gap`.
12. **Ameaças:** detecção e captura por patrulhas; queda na ponte.
13. **Sons:** "pattering", vozes roucas, motor, quedas que mascaram passos, morcegos, baque colossal, coaxos.
14. **Visuais:** luar amarelo, ruas apagadas, clarões no recife, cúpula, brilho de cor indefinível, coluna ondulante.
15. **Documentos:** `doc_sketch_map` (consulta).
16. **Transições:** streaming entre distritos; estação → `lvl_railway_marsh` por trilho contínuo; desmaio → negro.
17. **Conclusão:** fim de `evt_rowley_procession`.
18. **Duração:** 30–45 min.
19. **Dependências:** `sys_perception`, `sys_pursuit` (`PatrolDirector`), `sys_npc_routine`, `sys_audio`, `sys_time_of_day` (noite), `sys_retro_render` (névoa e distância), multidões de baixo custo (09, 13).
20. **Fidelidade:** ~90% C, ~10% O (patrulhas jogáveis, cronometragens).

### `ch08_inheritance` — A Herança de Innsmouth

1. **Sinopse:** despertar na chuva; depoimento e Peabody em Arkham; recortes da operação; Cleveland, fotos, quadro, joias; sonhos e espelho; decisão e descida simbólica.
2. **Objetivo narrativo:** deslocar o horror da cidade para a identidade e terminar na ambivalência.
3. **Objetivo do jogador:** retomar a vida e a genealogia; compreender a própria ascendência.
4. **Emoção inicial:** exaustão, dúvida da própria memória.
5. **Emoção final:** horror transmutado em atração inquietante.
6. **Locais:** `lvl_railway_marsh` (dia, chuva), `lvl_arkham`, `lvl_toledo_room` (e quarto de Oberlin como variação [O]), `lvl_cleveland_house`, `lvl_cleveland_vault`, `lvl_dream_sea`, `lvl_reef_final`.
7. **Personagens:** `npc_federal_officer`, `npc_lapham_peabody`, `npc_grandfather`, `npc_uncle_walter`, `npc_father`, `npc_grandmother_dream`, `npc_pththya_lyi`.
8. **Obrigatórios:** `evt_no_prints`, depoimento, `evt_marsh_eyes`, `doc_raid_clippings`, `evt_photo_shift`, `pz12_genealogy`, `evt_vault_tiara`, três noites de `evt_dream_descent`, `evt_grandmother_palace`, `evt_mirror_look`, `doc_canton_plan`, `evt_final_descent`.
9. **Opcionais:** placa do Museu Miskatonic; carta federal; cartas extras; olhar a gaveta.
10. **Mecânicas:** caminhada, depoimento por ordem, leitura, quadro genealógico, exame de fotos, sonho com movimento flutuante, escrita.
11. **Puzzles:** `pz12_genealogy`.
12. **Ameaças:** nenhuma (zona sem falha).
13. **Sons:** chuva, silêncio após o mar, escritórios, relógios de parede, cofres, sons submarinos graves, tema da revelação.
14. **Visuais:** cinza chuvoso; interiores burgueses; fosforescência onírica; espelho.
15. **Documentos:** `item_peabody_notes`, `doc_raid_clippings`, `doc_federal_letter`, `doc_orne_letters`, `doc_photo_eliza`, `doc_photo_douglas`, `doc_miniature`, `doc_family_chart`, `doc_governess_note`, `doc_dream_notes`, `doc_canton_plan`.
16. **Transições:** elipses textuais com data e local; desmaio no cofre → anos depois; sonhos ↔ quarto; papel ↔ mar.
17. **Conclusão:** créditos.
18. **Duração:** 30–45 min.
19. **Dependências:** `sys_documents`, `sys_journal` (fichas), quadro genealógico (`sys_ui` + `sys_story_state`), `sys_retro_render` (sonho), reflexo do espelho (13).
20. **Fidelidade:** ~75% C, ~10% I, ~15% O (salas, quadro, descida simbólica).

---

## 2. Catálogo de eventos

Colunas: **Ativação** (condição); **V/S** (visual / sonoro); **Dur.** (duração aproximada); **Estado** (fatos de `sys_story_state` exigidos); **Rep.** (repetição); **Cons.** (consequência); **Dep.** (dependência narrativa); **Teste** (critério verificável). "Repete após cp" = o evento reinicia se o jogador falhar e voltar a um checkpoint anterior à sua conclusão; nunca se repete depois de concluído e salvo.

### 2.1 ch01–ch02

| ID | Local | Ativação | V / S | Dur. | Estado | Rep. | Cons. | Dep. | Teste |
|---|---|---|---|---|---|---|---|---|---|
| `evt_agent_warning` | `lvl_newburyport_station` | Escolher tópico "o ônibus" | Bilheteiro gesticula / voz ambiente da estação | 1–2 min | início ch01 | único | `doc_bus_timetable`; objetivo "Hammond's, 10h" | nenhuma | Concede o documento uma vez mesmo se o tópico for repetido |
| `evt_tiara_reveal` | `lvl_newburyport_society` | Primeiro exame da tiara | Relevos nítidos, dessaturação 1,5 s / tom grave, motivo da tiara | 20–40 s | `doc_intro_note` usado | único | fato `tiara_seen`; desbloqueia `topic_tiara` | `pz01_tilton` | Reexaminar não repete o efeito PSI; após load, a tiara permanece examinável sem efeito |
| `evt_square_avoidance` | `lvl_newburyport_square` | 60 s antes da chegada do ônibus ou ao olhar a rua | Ociosos se dispersam / passos, porta do lunch room | 30 s | `cp01_bus_stop` | único | — | nenhuma | NPCs saem do campo de visão sem atravessar paredes |
| `evt_sargent_look` | `lvl_bus` | Pagar a passagem | Sargent encara 1 s / moedas | 3 s | embarque | único | troco 40 ¢ (cosmético) | `evt_square_avoidance` | Câmera não é forçada; olhar dura no máx. 1,5 s |
| `evt_crest_panorama` | `lvl_bus` | Ônibus atinge a crista | Vale, campanários, recife / vento cai, tom de "aceno" ao mirar o recife | 20–30 s | `cp02_bus_ride` | único | fato `reef_seen` | nenhuma | Tom só toca se o recife estiver no centro de 30% da tela; jogador sem olhar recebe o fato mesmo assim |
| `evt_dagon_hall_pass` | `dist_north` | Gatilho no trilho do ônibus | Letreiro desbotado legível / motor | 10 s | ch02 | único | fato `dagon_hall_seen` | `evt_crest_panorama` | Letreiro legível em 240 p a 6 m (verificar em 13) |
| `evt_basement_priest` | `dist_north` | Sino das 11 no trilho | Porta do porão aberta, figura de tiara cruza 1,2 s / sino rachado, motivo da tiara | 6 s | `dagon_hall_seen` | único | fato `priest_seen`; `topic_churches` | `tiara_seen` (reforça; não exige) | Com "puxão de câmera" desligado, uma legenda indica "à esquerda"; figura nunca vista por mais de 1,5 s |
| `evt_falls_roar` | `dist_gorge` | Entrar no volume da ponte | Água abundante / quedas ensurdecedoras | contínuo | — | sempre | mascara passos (usado em ch07 só em Bank Street) | nenhuma | Volume reduz sons de passos do jogador no volume |

### 2.2 ch03–ch04

| ID | Local | Ativação | V / S | Dur. | Estado | Rep. | Cons. | Dep. | Teste |
|---|---|---|---|---|---|---|---|---|---|
| `evt_window_watchers` | `dist_patrician`, `dist_north` | Jogador parado ≥ 4 s olhando fachada marcada | Fresta de veneziana se fecha / ferrolho de janela | 2 s | ch03 ativo | repetível, resfriamento 90 s e máx. 6 por capítulo | nenhuma | nenhuma | Nunca dispara durante diálogo ou leitura; contagem respeita o teto |
| `evt_boarded_sounds` | `dist_north` | Passar a ≤ 6 m de fachada tapada marcada | — / rangidos, correria, ruídos roucos atrás da madeira | 3–6 s | ch03 ativo | repetível por fachada, 1 vez por visita | Diário: nota sobre túneis (1ª vez) | conversa do rapaz (texto muda se não ouviu) | Som vem da fachada tapada, não de casa habitada vizinha |
| `evt_bell_three` | `dist_patrician` | Primeira entrada em `dist_patrician` depois de ≥ 2 distritos visitados, ou 25 min de ch03 | — / sino rachado 3 vezes, à esquerda | 6 s | ch03 | único | hora passa a 15h | `priest_seen` (texto) | Dispara uma vez mesmo com ordem diferente de visita |
| `evt_marsh_car` (R) | `dist_gorge` | Entrar no desfiladeiro antes de `evt_bell_three` | Carro fechado e cortinado entra na refinaria / motor, portão | 15 s | ch03 | único | fato `marsh_car_seen` | nenhuma | Ninguém sai do carro à vista |
| `evt_zadok_sighting` | `dist_square` (Paine) | Requisitos mínimos de ch03 cumpridos e entrar na Paine | Zadok no banco com bombeiros / conversa abafada | 10 s | mapa; ≥ 3 distritos | único | objetivo "uísque" | `pz02_orientation` | Antes dos requisitos, Zadok não está no banco (está "andando", fora do mapa) |
| `evt_zadok_reef_gaze` | cais sul | Fim de M1 | Zadok fixa o recife, pega a lapela / pragas sussurradas | 15 s | `cp04_wharf` | único | inicia M2 | M1 | Inicia mesmo se o jogador não oferecer a garrafa após 90 s (fallback) |
| `evt_tide_turn` | cais sul | Fim da lista de desaparecidos em M5 | Luz dourada, maré sobe / ondas mais altas | transição 60 s | M5 | único | — | M5 | Transição de luz contínua, sem salto visível |
| `evt_zadok_shriek` | cais sul | Fim de M7 | Ondulação local 3 s, Zadok foge / grito, onda, segundo grito | 25 s | M7 | único | fato `zadok_fled`; hora 19h15 | M1–M7 | Ondulação nunca contém silhueta; jogador não alcança Zadok (porta do armazém fecha rota) |

### 2.3 ch05–ch06

| ID | Local | Ativação | V / S | Dur. | Estado | Rep. | Cons. | Dep. | Teste |
|---|---|---|---|---|---|---|---|---|---|
| `evt_gilman_crowd` | `dist_square` | Entrar na praça em ch05 | Grupo na porta, olhos acompanham / cochichos | até entrar no hotel | ch05 | único | — | `zadok_fled` | Nenhum NPC bloqueia a porta fisicamente |
| `evt_bus_breakdown` | `lvl_bus` | Sentar no ônibus | Sargent volta, fala / motor desligado | 30 s | valise retirada | único | objetivo "pernoitar no Gilman" | `evt_gilman_crowd` | Sair do ônibus antes da fala não quebra a sequência (Sargent fala na calçada) |
| `evt_missing_bolt` | `room_428` | Examinar a porta do corredor | Marcas de parafusos recentes / — | — | `cp05_room` | único | ativa `pz05_bolt` | nenhuma | O Diário lembra o ferrolho se o jogador deitar antes (deitar fica bloqueado até resolver) |
| `evt_corridor_creaks` | `lvl_gilman_interior` | Após luz da cama acesa e ≥ 40 s de leitura/espera | — / rangidos furtivos na escada e corredor | 4–8 s cada | `pz05_bolt` resolvido | repetível, 3–5 vezes, intervalos 25–50 s | prepara `evt_key_in_lock` | `evt_missing_bolt` | Sempre posicionado atrás da porta do corredor; nunca dentro do quarto |
| `evt_key_in_lock` | `room_428` | Deitar com luz apagada + 30 s | Quase preto / chave tentando a fechadura | 12 s | ferrolhos corridos | único | — | `evt_corridor_creaks` | Com legenda ligada, "[uma chave tenta a fechadura]" aparece com direção |
| `evt_connecting_tries` | `room_n1`, `room_s1` | Fim de `evt_key_in_lock` | — / chave-mestra norte, ferrolho testado; idem sul; passos descem | 35 s | idem | único | fim de ch05 | `evt_key_in_lock` | Som posicional muda de lado de modo distinguível em estéreo e em mono (legenda) |
| `evt_power_cut` | `room_428` | Primeira tentativa de acender a luz em ch06 | Interruptor inútil / vozes "não vozes" abaixo | 15 s | início ch06 | único | lanterna obrigatória | ch05 | Lâmpada não acende nem por debug de interação |
| `evt_knocking` | `room_428` | Barricada preparatória feita ou 90 s após `evt_power_cut` | Luz trêmula no bandeirote / passos pesados, batida, batidas contínuas | até forçar a porta norte | `cp06_knock` | único; repete após cp | inicia `SiegeDirector` | `pz06_hinges` (ou tempo) | Restaurar `cp06_knock` recomeça das batidas sem repetir `evt_power_cut` |
| `evt_passkeys` | `room_n1`, `room_n2` | Porta norte cede | Fechaduras giram / chaves nos dois lados | janela de ação 6–10 s (ver 08) | `evt_knocking` | idem | início da corrida | `evt_knocking` | Janela mínima respeitada no modo assistido (08) |
| `evt_ram` | `room_n2` | Barricadas de `room_n2` concluídas | Painel estilhaça progressivamente / aríete | 20–40 s até ceder | `cp06_window` | idem | prazo para `pz08_drapery` | `pz07_barricade` | Cama sempre segura a porta sul até o jogador sair |
| `evt_church_lights` | telhado | Aterrissar no telhado | Luzes na Ordem, batista, congregacional / vento e cânticos distantes muito baixos | 8 s | `cp06_roof` | único | — | `pz08_drapery` | Três luzes identificáveis no horizonte norte em 240 p |
| `evt_courtyard_crowd` | pátio | Voltar da porta emperrada (`pz09_courtyard`) | Multidão com lanternas, figura de tiara / coaxos, palavras não inglesas | até o jogador sair | `cp06_courtyard` | idem | perigo de detecção | porta emperrada tentada | Multidão não detecta o jogador dentro do prédio; detecta no pátio iluminado |

### 2.4 ch07

| ID | Local | Ativação | V / S | Dur. | Estado | Rep. | Cons. | Dep. | Teste |
|---|---|---|---|---|---|---|---|---|---|
| `evt_bates_hide` | `dist_south_residential` | Chegar à esquina da Bates pela calçada leste | Duas figuras cruzam / passos arrastados | 10 s | `cp07_washington` | idem | ensina esconderijo | — | Vestíbulo oferece proteção total se o jogador entrar em até 3 s após o aviso sonoro |
| `evt_reef_signals` | South Street (vista) | Olhar para o mar a partir da praça da South | Clarões no recife; resposta da cúpula do Gilman (NE) / — | 15 s | `cp07_south_crossing` | único | fato `signals_seen` | travessia iniciada | Ocorre mesmo sem olhar: os clarões refletem nas janelas da rua (legenda descritiva) |
| `evt_swimmers` | South Street (vista) | 4 s após `evt_reef_signals` | Cabeças e braços na água entre recife e costa (impostores, 09) / — | 6 s | `signals_seen` | único | narrador corre; fato `swimmers_seen` | `evt_reef_signals` | Nenhuma silhueta legível como forma completa |
| `evt_federal_motor` | Washington/Federal | Uma quadra ao sul da praça | Faróis na transversal / motor, passos, guturais | 20 s | `swimmers_seen` | único | objetivo muda para a ferrovia; abre `pz10_night_route` | `evt_swimmers` | Objetivo só muda depois da nota do narrador |
| `evt_ipswich_party` | Babson/Eliot | Segunda pausa em esconderijo da Babson | Carro e bando na Eliot; figura de diadema saltitante / motor, coaxos | 20 s | `cp07_babson` | idem | — | `evt_federal_motor` | Bando nunca entra na Babson |
| `evt_rowboat` | South Street (2ª travessia) | Olhar o mar durante a travessia | Bote com lona; brilho constante de cor indefinível; cúpula escura / remos distantes | 8 s | travessia 2 | único | fato `rowboat_seen` | `evt_reef_signals` | Se não olhar, o evento não ocorre e não é exigido |
| `evt_washington_band` | praça da South (2ª vez) | Meio da segunda travessia | Bando a uma quadra; figura simiesca; tiara saltitante / jargão gutural | 15 s | travessia 2 | idem | teste do andar arrastado (09) | `evt_courtyard_crowd` | Com andar arrastado e sem correr, nunca há detecção |
| `evt_drunk_adams` | Adams Street | Passar a porta marcada | Homem cambaleia para fora / tropeço, resmungo | 5 s | — | único | nenhuma | — | Não aciona `sys_perception` nem perseguição |
| `evt_bats` | ponte coberta | 4 m dentro da ponte com lanterna acesa ou não | Nuvem de morcegos / bater de asas | 3 s | `cp07_bridge` | único | — | — | Opção "reduzir sustos súbitos" diminui volume e densidade |
| `evt_ipswich_column` | corte (vista) | Olhar para trás ao entrar no corte | Movimento ondulante brilhante ao sul / sugestão de raspar e bramir (vento contra) | 10 s | `cp07_cut` | único | — | — | Sem detalhe legível a qualquer resolução |
| `evt_wind_shift` | corte | 20 s dentro do corte | Névoa leve se move / odor (legenda), murmúrios, "flopping" | 20 s | `cp07_cut` | único | prepara procissão; agachar sugerido | `evt_ipswich_column` | Legenda "[cheiro de peixe forte]" quando legendas de sons ligadas |
| `evt_rowley_procession` | estrada de Rowley | Jogador agachado no ponto do corte ou 30 s após `evt_wind_shift` | Tela preta (olhos fechados) → procissão / babel de coaxos, balidos, chão tremendo | 60–120 s | `evt_wind_shift` | único (só repete se o jogador sair do jogo antes do desmaio) | desmaio; fim ch07 | toda a cadeia de revelação | Revelação completa só aqui (D-011); multidão sem colisão com o jogador; opção de acessibilidade "olhos fechados assistido" |

### 2.5 ch08

| ID | Local | Ativação | V / S | Dur. | Estado | Rep. | Cons. | Dep. | Teste |
|---|---|---|---|---|---|---|---|---|---|
| `evt_no_prints` | estrada de Rowley | Olhar a lama da estrada | Lama lisa, chuva / chuva sem mar | 5 s | `cp08_rain` | único | nota do Diário | `evt_rowley_procession` | Decal de pegadas ausente mesmo nas texturas do terreno |
| `evt_marsh_eyes` | `lvl_arkham` | Fim do relato de Peabody | Peabody fixa o rosto do jogador / relógio de parede | 8 s | `cp08_arkham` | único | `item_peabody_notes` | — | A fala ocorre uma única vez |
| `evt_photo_shift` | `lvl_cleveland_house` | Reexaminar uma foto já examinada após ler ≥ 1 carta | Troca sutil de textura dos olhos / leve tom grave | 1 s | `cp08_cleveland` | único por foto (2) | fichas de foto "inquietantes" no quadro | `evt_marsh_eyes` | Troca não é visível ao primeiro exame |
| `evt_vault_tiara` | `lvl_cleveland_vault` | Pedir a Walter que continue após o peitoral | Tiara surge / todo som cessa | 6 s | `pz12_genealogy` concluído | único | elipse de dois anos | `pz12_genealogy` | Corte para preto sem som alto (opção de sustos não afeta: não há susto) |
| `evt_dream_descent` | `lvl_dream_sea` | Deitar em cada noite | Espaços submersos crescentes / drones submarinos | 1–3 min | `cp08_dreams` | único por noite (3) | `doc_dream_notes` | `evt_vault_tiara` | Ordem das noites fixa; recarregar volta ao início da noite atual |
| `evt_grandmother_palace` | `lvl_dream_sea` | Noite 3 | Palácio fosforescente, avó, Pth'thya-l'yi ao fundo, shoggoth entrevisto / voz da avó, grito ao acordar | 3–4 min | noite 2 concluída | único | espelho descoberto | `evt_dream_descent` ×2 | Pth'thya-l'yi nunca em plano fechado |
| `evt_mirror_look` | `lvl_toledo_room` | Aproximar-se do espelho após a noite 3 | Reflexo com "a aparência" / silêncio | livre | `evt_grandmother_palace` | único (reflexo permanece) | libera a escrivaninha | — | Reflexo correto também com FOV e resolução alterados |
| `evt_final_descent` | `lvl_reef_final` | Assinar `doc_canton_plan` | Nado ao recife, descida, luzes de Y'ha-nthlei / mar, tema final | 2–3 min | `cp08_final` | único | créditos; fato `game_completed` | tudo | Legenda em tempo futuro sempre visível; cena nunca mostra Lawrence |

---

## 3. Morte, falha e salvamento

### 3.1 Zonas sem falha

ch01, ch02, ch03, ch04, ch05 e ch08 **não têm falha**. Nada pode matar ou capturar o jogador; quedas são impedidas por colisão ou por bordas baixas. Isso protege a investigação longa de qualquer repetição.

### 3.2 Condições de falha (somente ch06 e ch07)

| Falha | Onde | Condição | Apresentação | Retorno |
|---|---|---|---|---|
| Captura no quarto | `room_428`–`room_n2` | Porta forçada pelos perseguidores antes de o jogador passar ao cômodo seguinte / descer a cortina (cronologia em 08) | Porta cede, lanternas, mãos; corte para preto antes de qualquer contato visível; som abafado | `cp06_knock` ou `cp06_window` |
| Queda do telhado | telhado da Paine | Sair da área de ardósia marcada (raro; bordas com aviso sonoro de telha solta) | Escorregão, corte | `cp06_roof` |
| Captura no pátio | pátio | Detecção total por `pur_courtyard_party` | Lanternas convergem, corte | `cp06_courtyard` |
| Captura nas ruas | ch07 | Medidor interno de suspeita do grupo chega a "perseguição" e o jogador é alcançado (11) | Corrida curta; corte ao ser alcançado | último `cp07_*` |
| Queda na ponte | ponte coberta | Salto mal-sucedido no vão | Queda, corte antes do impacto | `cp07_bridge` |
| Revelação interrompida | corte | Nenhuma: a procissão não detecta o jogador | — | — |

Não há morte gráfica. "Captura" implica destino desconhecido, coerente com os desaparecidos do conto.

### 3.3 Checkpoints e autosave

* Checkpoints exatamente os de `27` §8. Cada um é **momento seguro**: sem perigo ativo, sem sequência em curso, sem diálogo aberto.
* Autosave ao atingir um checkpoint, ao concluir um capítulo e (ch03) ao entrar em cada distrito.
* Não há salvamento manual (D-007). Sair pelo menu de pausa grava apenas se o último checkpoint for o atual (nunca grava estado intermediário de perigo).
* Três espaços de partida; após concluir um capítulo, ele fica disponível em "Capítulos" a partir do seu primeiro checkpoint, com os fatos canônicos dos capítulos anteriores reconstruídos.

### 3.4 O que persiste

| Dado | Persiste entre checkpoints | Observação |
|---|---|---|
| Documentos lidos e itens | sim | Nunca removidos por falha; itens essenciais (mapa, lanterna, ferramenta) não podem ser descartados |
| Diário (entradas e fontes) | sim | Entradas de uma sequência em perigo só são gravadas ao alcançar o checkpoint seguinte |
| Temas de Zadok ouvidos | sim | Afetam só texto do Diário |
| Fatos de eventos únicos | sim | Concluído = nunca repetido |
| Estado de móveis, portas e barricadas | não (reconstruído do checkpoint) | `cp06_knock` sempre reconstrói: ferrolho transferido, ferrolhos laterais corridos, cômoda e cama na posição que o checkpoint define (08) |
| Posição de patrulhas | não | Reiniciadas a partir do roteiro do checkpoint |
| Preferências e acessibilidade | arquivo separado | Nunca afetadas por falha |

### 3.5 Repetir o cerco sem repetir diálogos

* Tudo que é fala ou nota de ch05 termina antes de `cp06_knock`. Ao restaurar `cp06_knock`, o jogador está de pé no 428, lanterna na mão, móveis preparados, e as batidas começam após 3 s — sem `evt_power_cut`, sem fala do narrador.
* Notas de exame já vistas não reaparecem automaticamente.
* O `SiegeDirector` (08, 11) reinicia sua fase a partir do checkpoint, não do início do capítulo.
* Após duas falhas no mesmo trecho, o jogo oferece (uma vez, recusável) ativar a **travessia assistida** do cerco (16).

### 3.6 Prevenção de estados impossíveis

* Itens essenciais são concedidos por fatos, não por objetos físicos coletáveis que possam cair fora do mapa; ao carregar, `sys_story_state` reconcilia: se `cp03_grocery` foi alcançado, `item_sketch_map` existe.
* Toda porta que fecha rota por roteiro tem estado derivado de fatos, não de física.
* Saída de um distrito durante uma sequência é bloqueada por barreiras narrativas suaves (06/07), nunca por paredes invisíveis sem justificativa.
* Eventos com "Estado" não satisfeito não disparam; eventos obrigatórios têm fallback por tempo (ex.: `evt_zadok_reef_gaze`, `evt_knocking`).
* Saves são validados contra allowlist de IDs e checkpoints; um save com combinação incoerente de fatos (ex.: `zadok_fled` sem `cp04_wharf`) é rejeitado e o backup é usado (17).
* Testes de cada regra acima estão em `23-TESTES-E-QUALIDADE.md`.

---

## 4. Ritmo e curva de tensão

### 4.1 Tabela de ritmo

Terror e demais colunas em escala 0–5 (0 = ausente, 5 = máximo). Valores são **intenção de design**, a confirmar em playtest.

| Capítulo | Duração | Terror | Exploração | Investigação | Diálogo | Perigo real | Revelações | Descanso |
|---|---|---|---|---|---|---|---|---|
| ch00 moldura | 2–3 min | 1 | 0 | 0 | 0 | 0 | 0 | 5 |
| ch01 | 25–35 min | 1 | 2 | 4 | 4 | 0 | 2 (tiara) | 4 |
| ch02 | 15–20 min | 2 | 2 | 1 | 1 | 0 | 2 (panorama, padre) | 3 |
| ch03 | 40–55 min | 2→3 | 5 | 4 | 3 | 0 | 2 | 3 |
| ch04 | 20–30 min | 3 | 0 | 3 | 5 | 0 | 4 (história) | 2 |
| ch05 | 15–20 min | 3→4 | 1 | 2 | 1 | 0 | 1 | 1 |
| ch06 | 10–20 min | 5 | 2 | 1 | 0 | 5 | 2 | 0 |
| ch07 | 30–45 min | 4→5 | 3 | 1 | 0 | 4 | 5 (procissão) | 1 (abrigos) |
| ch08 | 30–45 min | 2→4 | 1 | 5 | 3 | 0 | 5 (genealogia, espelho) | 3 |

### 4.2 Curva

```text
Terror
5 |                                  ████ ██▄▄█
4 |                              ▄▄██    █     █        ▄██
3 |                    ▄▄▄▄▄▄▄██                  ▄▄▄██
2 |         ▄▄▄▄▄▄▄▄██                         ▄▄█
1 | ▄▄▄▄▄▄██                                ▄█
0 +----------------------------------------------------------
    ch01   ch02    ch03        ch04  ch05 ch06  ch07   ch08a-c ch08d-g
```

Princípios:

* **Alternância:** depois de cada pico há um vale curto — o cais após o passeio tenso do norte; o jantar antes da noite; os vestíbulos e a Bank Street (quedas cobrindo passos) entre travessias; a chuva silenciosa após a procissão.
* **Nunca mais de ~15 min contínuos em terror 5:** o cerco (10–20 min) é seguido de telhado e armazém (respiro relativo); ch07 alterna travessia e abrigo.
* **O epílogo é outra curva:** começa baixo (alívio, burocracia) e sobe por compreensão, não por ameaça. O último pico (espelho, palácio) é de identidade.
* **Para que a genealogia não pareça apêndice:** as pistas são plantadas em ch01 (tiara), ch04 (`jrn_obed_daughter`, `jrn_obed_eyes`), ch07 (motivo da tiara na procissão) e pagas em ch08; ch08 começa imediatamente após o desmaio, sem tela de "fim de jogo".

### 4.3 Metas de ritmo verificáveis (para 23)

* Nenhuma conversa obrigatória fora de ch04 ultrapassa 3 min de leitura em velocidade média.
* Intervalo entre eventos AMB/PSI em ch03 entre 1 e 4 min.
* Tempo médio entre perigo e próximo checkpoint ≤ 3 min em ch06–ch07.
* Tempo de ch08 desde `cp08_rain` até `pz12_genealogy` ≤ 15 min.

### 4.4 Requisitos mínimos de ch03

Para que `evt_zadok_sighting` aconteça: mapa recebido e **três** entre `dist_gorge`, `dist_south_waterfront`, `dist_north`, `dist_patrician` visitados (entrar no volume do distrito e ver seu momento de assinatura). O Diário lista quais faltam se o jogador pedir dica (12). Isso garante as pistas mínimas para pelo menos três temas de Zadok sem obrigar exploração total.
