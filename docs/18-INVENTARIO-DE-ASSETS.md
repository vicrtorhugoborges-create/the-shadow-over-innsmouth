# 18 — Inventário de assets

> **Estado:** planejamento. **Nenhum asset existe.** Toda licença está "pendente". Este documento é a lista de produção e, depois, o registro de procedência obrigatório antes de qualquer build distribuível (CLAUDE.md §8).

## 1. Divisão do trabalho

| Quem | Pode fazer | Não pode fazer sozinho |
|---|---|---|
| **Claude Code (CC)** | Geometria cinza (blockout) de níveis a partir das plantas de 06/07/08/09; primitivas identificadas como placeholder; colisões, volumes, pontos de interação, gatilhos; materiais de cor sólida; integração e importação de arquivos entregues; manifestos e verificação de inventário; tons sintéticos e silêncio rotulado como placeholder de áudio; legendas e textos. | Modelos finais, rigs, animações de personagem, texturas artísticas, ilustrações, fotografias de época, gravações, vozes, mixagem final, aprovação estética. |
| **Humano (HUM)** | Modelagem, texturização, rig, animação, ilustração do mapa e documentos, foley, design de vocalizações, composição, direção de voz, mix, revisão de arte e de sensibilidade. | — |
| **Aquisição (AQ)** | Bibliotecas de som/textura/modelos com licença comercial compatível (CC0, CC-BY, licenças comerciais pagas sem NC). | Licenças NC, "uso pessoal", ou sem prova de permissão comercial. |
| **Gravação (GRAV)** | Foley e ambientes gravados pela equipe; fotos próprias de referência/textura. | — |

Assets gerados por IA dependem de Q-011; até a decisão, não são usados.

## 2. Status e campos

Pipeline de status: `planejado` → `ph` (placeholder, arquivo com prefixo `ph_`) → `em_producao` → `licenciado` (procedência completa) → `final_aprovado` (revisão humana em execução gráfica do export Windows).

Campos de procedência a preencher quando o asset existir (além das tabelas abaixo): origem/URL, autor, licença, prova de uso comercial (arquivo ou link), atribuição exigida, alterações feitas, data, responsável pela aprovação.

Legenda das tabelas:

* **Pri:** E / R / Op (22).
* **Comp.:** B baixa · M média · A alta.
* **Reuso:** B / M / A (A = usado em muitas cenas).
* **PH aceitável:** forma do placeholder que permite testar sem o asset final.
* **Origem:** CC, HUM, AQ, GRAV (combinações possíveis; CC sempre faz a integração).
* **Aprov.:** código de critério (§9).
* **Lic.:** situação de licença — todas `pendente` nesta fase.

---

## 3. Modelos 3D — ambientes (§22.1)

### 3.1 Kits modulares

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-ENV-001 | Kit tijolo Federal (~1800): fachadas 2–3 andares, vitrines, telhado inclinado | `dist_square`, `dist_south_residential`, `dist_bank_station` | E | M | A | caixas cinza com recortes de porta/janela | HUM | AST-TEX-300 | AP-M | pendente |
| AST-ENV-002 | Kit madeira gambrel/frontão, 3 alturas, 4 estados de decadência | `dist_north`, `dist_south_waterfront`, `dist_south_residential`, `lvl_bus` | E | M | A | prismas cinza com telhado | HUM | AST-TEX-301/302 | AP-M | pendente |
| AST-ENV-003 | Kit georgiano patrício: casa quadrada, cúpula, *widow's walk*, cercas, jardins | `dist_patrician`, `dist_south_residential` | E | M | A | cubos com telhado de 4 águas | HUM | AST-TEX-300/301 | AP-M | pendente |
| AST-ENV-004 | Kit industrial: muros de contenção, armazéns de tijolo e pedra | `dist_gorge`, `dist_bank_station`, `dist_south_waterfront` | E | M | A | blocos cinza | HUM | AST-TEX-300/303 | AP-M | pendente |
| AST-ENV-005 | Kit cais e quebra-mar: estacas, tábuas, lajes, pedras com musgo | `dist_south_waterfront`, `dist_north` | E | B | A | caixas e cilindros | HUM | AST-TEX-301/303 | AP-M | pendente |
| AST-ENV-006 | Kit de rua: paralelepípedo, calçada de tijolo, meio-fio, postes com dois fios, placas caídas | todos os distritos, `lvl_newburyport_square` | E | B | A | planos cinza com faixas | HUM | AST-TEX-304 | AP-M | pendente |
| AST-ENV-007 | Kit de decadência: tábuas pregadas, buracos de telhado, vigas, entulho, chaminés caídas | todos | E | B | A | cubos achatados | HUM | AST-TEX-315 | AP-M | pendente |
| AST-ENV-008 | Kit Newburyport: tijolo conservado, vitrines vivas, toldos | `lvl_newburyport_*` | E | M | M | caixas cinza | HUM | AST-ENV-001 | AP-M | pendente |
| AST-ENV-009 | Kit interior 1920: paredes, rodapés, portas, janelas, escadas, corrimãos | todos os interiores | E | M | A | caixas cinza | HUM | AST-TEX-307 | AP-M | pendente |
| AST-ENV-010 | Terreno costeiro e pântano: dunas, capim, riachos de maré, aterro, corte de mato, estrada de terra | `lvl_bus`, `lvl_railway_marsh` | E | M | M | malha de terreno cinza | HUM | AST-PRP-160/161 | AP-M | pendente |
| AST-ENV-011 | Kit de telhados: ardósia solta, cumeeira, claraboia aberta | `lvl_gilman_exterior_escape`, vistas | E | B | M | planos inclinados | HUM | AST-TEX-302 | AP-I | pendente |
| AST-ENV-012 | Ferrovia: trilhos, dormentes podres, postes de telégrafo sem fios | `dist_bank_station`, `lvl_railway_marsh`, vista `lvl_bus` | E | B | M | cilindros/caixas | HUM | — | AP-M | pendente |

### 3.2 Construções únicas e marcos

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-ENV-020 | Gilman House: fachada com cúpula e tinta amarela [C], entrada, lateral do pátio | `dist_square`, `lvl_gilman_exterior_escape`, `evt_reef_signals` | E | A | M | bloco cinza com cúpula primitiva | HUM | AST-ENV-001 | AP-M | pendente |
| AST-ENV-021 | Ordem Esotérica de Dagon: salão com colunas, letreiro desbotado | `dist_north`, `evt_dagon_hall_pass`, `evt_church_lights` | E | A | B | bloco com 4 cilindros | HUM | AST-TEX-313 | AP-M | pendente |
| AST-ENV-022 | Igreja gótica de pedra, torre atarracada, porão alto com porta escura | `dist_north`, `evt_basement_priest`, `evt_bell_three` | E | A | B | bloco + torre | HUM | AST-TEX-303 | AP-M | pendente |
| AST-ENV-023 | Três campanários georgianos (silhuetas) + casca de uma igreja de Main/Church | `dist_north`, horizonte | E | M | A | cilindros/cones | HUM | — | AP-M | pendente |
| AST-ENV-024 | Refinaria Marsh: moinho com campanário branco junto às quedas inferiores | `dist_gorge`, vista de `dist_square` | E | A | M | bloco + torre clara | HUM | AST-ENV-004 | AP-M | pendente |
| AST-ENV-025 | Desfiladeiro do Manuxet + ponte de ferro da Federal + quedas | `dist_gorge`, `lvl_bus`, `evt_falls_roar` | E | A | M | malha de vale e caixa-ponte | HUM | AST-TEX-305 | AP-M | pendente |
| AST-ENV-026 | Pontes de Main e Water (madeira), ruína da ponte da Fish | `dist_gorge`, `dist_south_waterfront`, `dist_north` | E | M | M | caixas | HUM | AST-ENV-005 | AP-M | pendente |
| AST-ENV-027 | Ponte precária com placa de advertência | `dist_patrician`, `doc_bridge_warning` | E | B | B | caixa + placa | HUM | — | AP-M | pendente |
| AST-ENV-028 | Mansão Marsh: casa georgiana com parterres em terraços | `dist_patrician` | R | M | B | variação de AST-ENV-003 | HUM | AST-ENV-003 | AP-M | pendente |
| AST-ENV-029 | Estação ferroviária em arcada, arruinada | `dist_bank_station`, vista de ch03/ch05 | E | M | B | bloco com arcos | HUM | AST-ENV-004 | AP-M | pendente |
| AST-ENV-030 | Ponte ferroviária coberta, interior percorrível com vão nos dormentes | `lvl_railway_marsh`, `pz11_bridge_gap`, `evt_bats` | E | M | B | túnel cinza com vão | HUM | AST-ENV-012 | AP-I | pendente |
| AST-ENV-031 | Corpo de bombeiros com banco na frente | `dist_square`, `evt_zadok_sighting` | E | B | B | bloco + banco | HUM | AST-ENV-001 | AP-M | pendente |
| AST-ENV-032 | Devil Reef: impostor de linha negra + malha baixa para a cena final | todas as vistas ao mar, `lvl_reef_final` | E | M | A | faixa negra plana | HUM | — | AP-M | pendente |
| AST-ENV-033 | Panorama da crista: horizonte com Kingsport Head e vale do Manuxet (impostor) | `lvl_bus`, `evt_crest_panorama` | E | M | B | foto cinza de blockout renderizado | HUM | AST-ENV-001–007 | AP-M | pendente |
| AST-ENV-034 | Fachada da Hammond's Drug Store e Ideal Lunch | `lvl_newburyport_square` | E | B | B | caixas com texto | HUM | AST-ENV-008 | AP-M | pendente |

### 3.3 Interiores

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-ENV-040 | Bilheteria da estação de Newburyport | `lvl_newburyport_station` | E | B | B | sala cinza + balcão | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-041 | Sala de leitura da biblioteca | `lvl_newburyport_library` | E | M | M (reuso em `lvl_arkham`) | sala + estantes cubo | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-042 | Sala de exposição da Sociedade Histórica (Newburyport) | `lvl_newburyport_society`, `evt_tiara_reveal` | E | M | M (reuso em `lvl_arkham`) | sala + vitrines | HUM | AST-PRP-110 | AP-M | pendente |
| AST-ENV-043 | Quarto da Y.M.C.A. | `lvl_newburyport_society` (transição de noite) | R | B | M | caixa + cama | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-044 | Interior do ônibus | `lvl_bus` | E | M | B | caixa com bancos | HUM | AST-PRP-150 | AP-M | pendente |
| AST-ENV-045 | Mercearia First National | `lvl_grocery` | E | M | B | sala + prateleiras | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-046 | Fundos da loja de variedades (Eliot) | `lvl_variety_store` | E | B | B | sala pequena | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-047 | Restaurante de balcão | `lvl_restaurant` | E | B | B | sala + balcão | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-048 | Gilman: lobby, balcão, escada de três lances | `lvl_gilman_interior` | E | M | B | caixas + rampas | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-049 | Gilman: corredor do 4º andar, `room_428`, `room_n1`, `room_n2`, `room_s1`, `room_s2`, banheiro | `lvl_gilman_interior`, ch05–ch06 | E | A | M (quartos repetidos) | caixas com portas funcionais | HUM | AST-PRP-100–107 | AP-I | pendente |
| AST-ENV-050 | Armazém sob claraboia: caixas, barris, escada | `lvl_gilman_exterior_escape` | E | M | B | sala + escada | HUM | AST-ENV-004 | AP-I | pendente |
| AST-ENV-051 | Prédio do lado da Washington: corredor, porta emperrada, sala de venezianas | `lvl_gilman_exterior_escape`, `pz09_courtyard` | E | B | B | caixas | HUM | AST-ENV-009 | AP-I | pendente |
| AST-ENV-052 | Pátio do Gilman: paralelepípedos com grama, cinco degraus de pedra | `lvl_gilman_exterior_escape`, `evt_courtyard_crowd` | E | M | B | plano + blocos | HUM | AST-ENV-006 | AP-M | pendente |
| AST-ENV-053 | Kit de vestíbulos/esconderijos de porta | `dist_south_residential`, `evt_bates_hide` | E | B | A | recuos cinza | HUM | AST-ENV-002 | AP-I | pendente |
| AST-ENV-054 | Sala de depoimento em Arkham [O] | `lvl_arkham` | E | B | B | sala + mesa | HUM | AST-ENV-009 | AP-M | pendente |
| AST-ENV-055 | Sociedade Histórica de Arkham (reuso de 041/042 com nova decoração) | `lvl_arkham`, `evt_marsh_eyes` | E | B | — | reuso | HUM | AST-ENV-041/042 | AP-M | pendente |
| AST-ENV-056 | Casa Williamson: escritório de Walter, sala | `lvl_cleveland_house`, `evt_photo_shift` | E | M | B | sala + móveis cubo | HUM | AST-PRP-111 | AP-M | pendente |
| AST-ENV-057 | Sala de cofres de banco | `lvl_cleveland_vault`, `evt_vault_tiara` | E | M | B | sala + gavetas | HUM | AST-PRP-132 | AP-M | pendente |
| AST-ENV-058 | Quarto de Toledo: escrivaninha, cama, espelho, janela | `lvl_toledo_room`, ch00, ch08f, `evt_mirror_look` | E | M | M (menu principal) | sala cinza | HUM | AST-PRP-111 | AP-M | pendente |
| AST-ENV-059 | Espaços oníricos: pórticos ciclópicos, labirintos de muralhas com algas | `lvl_dream_sea`, `evt_dream_descent` | E | A | M | colunas e muros cinza | HUM | AST-TEX-303 | AP-M | pendente |
| AST-ENV-060 | Palácio fosforescente em terraços com corais | `lvl_dream_sea`, `evt_grandmother_palace` | E | A | B | terraços cinza | HUM | AST-PRP-163 | AP-M | pendente |
| AST-ENV-061 | Y'ha-nthlei: vista final "many-columned" (impostor + primeiro plano) [O] | `lvl_reef_final`, `evt_final_descent` | E | A | B | cartões de colunas | HUM | AST-ENV-059 | AP-M | pendente |

---

## 4. Modelos 3D — objetos (`AST-PRP`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-PRP-100 | Cama de ferro barata (empurrável) | `lvl_gilman_interior`, `pz07_barricade` | E | B | A | caixa | HUM | — | AP-I | pendente |
| AST-PRP-101 | Cômoda (empurrável) | idem | E | B | A | caixa | HUM | — | AP-I | pendente |
| AST-PRP-102 | Lavatório (empurrável) | idem | E | B | A | caixa | HUM | — | AP-I | pendente |
| AST-PRP-103 | Armário de roupas com ferrolho removível | `room_428`, `pz05_bolt` | E | B | M | caixa + peça | HUM | AST-PRP-124 | AP-I | pendente |
| AST-PRP-104 | Cortinas de veludo, varão, argolas de latão | `room_n2`, `pz08_drapery`, AST-ANM-441 | E | M | B | plano + cilindro | HUM | — | AP-I | pendente |
| AST-PRP-105 | Portas de ligação com ferrolho e dobradiças visíveis (abre para cá / para lá) | `lvl_gilman_interior`, `pz06_hinges` | E | M | A | caixa com eixo marcado | HUM | — | AP-I | pendente |
| AST-PRP-106 | Porta de corredor com fechadura, marcas de ferrolho removido | `room_428`, `evt_missing_bolt`, `evt_key_in_lock` | E | B | A | caixa | HUM | AST-TEX-315 | AP-I | pendente |
| AST-PRP-107 | Lâmpada pendente com interruptor | interiores, `evt_power_cut` | E | B | A | esfera + fio | HUM | — | AP-I | pendente |
| AST-PRP-108 | Balcão de hotel, livro de registro, banca de jornais | `lvl_gilman_interior`, `doc_gilman_register`, `doc_evening_paper` | E | B | B | caixas | HUM | — | AP-M | pendente |
| AST-PRP-109 | Mobília de biblioteca e arquivo (mesas, fichários, livros em bloco) | `lvl_newburyport_library`, `lvl_arkham` | E | B | A | caixas | HUM/AQ | — | AP-M | pendente |
| AST-PRP-110 | Armário-vitrine de canto com almofada de veludo roxo [C] | `lvl_newburyport_society`, `evt_tiara_reveal` | E | B | B | caixa transparente | HUM | AST-PRP-120 | AP-M | pendente |
| AST-PRP-111 | Mobília doméstica 1920 (poltronas, mesas, abajur, escrivaninha) | `lvl_cleveland_house`, `lvl_toledo_room`, `lvl_arkham` | E | M | A | caixas | HUM/AQ | — | AP-M | pendente |
| AST-PRP-112 | Mobília comercial (prateleiras, balcões, caixa registradora, enlatados) | `lvl_grocery`, `lvl_variety_store`, `lvl_restaurant` | E | B | A | caixas | HUM/AQ | — | AP-M | pendente |
| AST-PRP-120 | Tiara de Newburyport (herói, inspeção) | `evt_tiara_reveal` | E | A | M (base das demais tiaras) | toro dourado | HUM | AST-TEX-311 | AP-M + revisão de arte | pendente |
| AST-PRP-121 | Joias Orne: tiara, peitoral, dois braceletes | `lvl_cleveland_vault`, `evt_vault_tiara` | E | A | B | primitivas douradas | HUM | AST-PRP-120 | AP-M | pendente |
| AST-PRP-122 | Mapa desenhado (objeto 3D dobrado) | `item_sketch_map` | E | B | A | plano | HUM | AST-UI-601 | AP-M | pendente |
| AST-PRP-123 | Garrafa de uísque de um quarto | `item_whiskey`, ch04 | E | B | B | cilindro | HUM | — | AP-M | pendente |
| AST-PRP-124 | Chaveiro com ferramenta 3-em-1 | `item_keyring_tool`, `pz05_bolt` | E | B | B | cilindro fino | HUM | — | AP-M | pendente |
| AST-PRP-125 | Lanterna de bolso | `item_flashlight` | E | B | A | cilindro | HUM | — | AP-M | pendente |
| AST-PRP-126 | Relógio de bolso | `item_watch` | E | B | M | disco | HUM | — | AP-M | pendente |
| AST-PRP-127 | Valise | `item_valise` | E | B | B | caixa | HUM | — | AP-M | pendente |
| AST-PRP-128 | Kit de papel: jornal, carta, livro aberto, folheto, cartão, envelope | todos os `doc_*` no mundo | E | B | A | planos brancos | HUM | AST-TEX-312 | AP-M | pendente |
| AST-PRP-129 | Fotografias emolduradas e miniatura | `doc_photo_eliza`, `doc_photo_douglas`, `doc_miniature` | E | B | M | planos | HUM | AST-UI-600 | AP-M | pendente |
| AST-PRP-130 | Bolachas (pacotes) | `item_crackers` | Op | B | B | caixa | HUM | — | AP-M | pendente |
| AST-PRP-131 | Pistola automática (objeto observável, não utilizável — D-015) | `lvl_toledo_room`, ch08f | E | B | B | caixa escura | HUM | — | AP-M + revisão de sensibilidade | pendente |
| AST-PRP-132 | Caixas de cofre, caixa de joias embrulhada | `lvl_cleveland_vault` | E | B | B | caixas | HUM | — | AP-I | pendente |
| AST-PRP-133 | Banco de rua, bancos de igreja, bancos do ônibus | vários | E | B | A | caixas | HUM | — | AP-M | pendente |
| AST-PRP-140 | Dóris amarradas | `dist_south_waterfront`, `dist_north` | E | B | A | casco simples | HUM | — | AP-M | pendente |
| AST-PRP-141 | Bote a remo com carga sob lona | `evt_rowboat` | E | B | B | casco + caixa | HUM | AST-ANM-443 | AP-M | pendente |
| AST-PRP-142 | Armadilhas de lagosta, redes, conchas e peixes mortos [C] | orla | E | B | A | caixas | HUM/AQ | — | AP-M | pendente |
| AST-PRP-143 | Cordas, estacas soltas, barris de peixe | orla, armazéns | E | B | A | cilindros | HUM | — | AP-M | pendente |
| AST-PRP-150 | Ônibus decrépito cinza "Arkham-Innsmouth-Newb'port" [C] | `lvl_bus`, `dist_square`, `evt_bus_breakdown` | E | M | M | caixa com rodas | HUM | AST-ENV-044 | AP-M | pendente |
| AST-PRP-151 | Carro fechado e cortinado (Marsh) | `evt_marsh_car` | R | M | B | caixa | HUM | — | AP-M | pendente |
| AST-PRP-152 | Automóveis e caminhões de época (2 modelos + variação) | `dist_square`, `evt_federal_motor`, `evt_ipswich_party` | E | M | A | caixas | HUM/AQ | — | AP-M | pendente |
| AST-PRP-160 | Juncos e capim de duna (cartões) | `lvl_bus`, `lvl_railway_marsh`, orla | E | B | A | cartões verdes | HUM | AST-TEX-314 | AP-M | pendente |
| AST-PRP-161 | Sarça, espinheiros e arbustos raquíticos | `lvl_railway_marsh`, `dist_bank_station` | E | B | A | cartões | HUM | AST-TEX-314 | AP-M | pendente |
| AST-PRP-162 | Olmos (ruas patrícias) e árvores mortas | `dist_patrician`, `lvl_bus` | R | B | A | cone + cilindro | HUM | AST-TEX-314 | AP-M | pendente |
| AST-PRP-163 | Corais leprosos, eflorescências braquiadas, algas oníricas | `lvl_dream_sea` | E | M | M | cartões | HUM | — | AP-M | pendente |
| AST-PRP-170 | Mantos rituais (sobreposição de personagem) | `npc_tiara_priest`, `pur_*`, `deep_procession` | E | M | A | cone de tecido | HUM | AST-TEX-308 | AP-C | pendente |
| AST-PRP-171 | Tiaras e diademas de procissão (variações de 120) | idem | E | M | A | toro | HUM | AST-PRP-120 | AP-M | pendente |
| AST-PRP-172 | Lanternas de mão dos perseguidores | `pur_courtyard_party`, `evt_courtyard_crowd` | E | B | A | cilindro com luz | HUM | — | AP-M | pendente |

---

## 5. Personagens e criaturas (`AST-CHR`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-CHR-200 | Narrador: corpo para reflexo/foto/espelho + mãos em primeira pessoa | `narrator`, `evt_mirror_look` | E | M | A | cápsula rotulada; mãos ocultas | HUM | AST-ANM-400 | AP-C | pendente |
| AST-CHR-201 | Bilheteiro | `npc_ticket_agent` | E | M | M (corpo-base) | cápsula rotulada | HUM | base humana | AP-C | pendente |
| AST-CHR-202 | Srta. Anna Tilton (senhora idosa) | `npc_anna_tilton` | E | M | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-203 | Bibliotecária e recepcionista da Y.M.C.A. (variações de base) | `npc_librarian`, `npc_ymca_clerk` | E | B | M | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-204 | Joe Sargent (herói, `look_2`) | `npc_joe_sargent` | E | A | B | cápsula + boné | HUM | base humana | AP-C + revisão D-013 | pendente |
| AST-CHR-205 | Passageiros do ônibus ×3 | `npc_bus_passenger` | E | B | M | cápsulas | HUM | AST-CHR-220 | AP-C | pendente |
| AST-CHR-206 | Funcionário idoso do Gilman (`look_0`) | `npc_gilman_day_clerk` | E | B | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-207 | Funcionário noturno do Gilman | `npc_gilman_night_clerk` | E | B | B | cápsula | HUM | AST-CHR-220 | AP-C | pendente |
| AST-CHR-208 | Rapaz da mercearia (~17 anos) | `npc_grocery_clerk` | E | M | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-209 | Bombeiros ×2 (`look_0`) | `npc_fireman` | E | B | M | cápsulas | HUM | base humana | AP-C | pendente |
| AST-CHR-210 | Zadok Allen (herói: barba, trapos, olhos lacrimejantes) | `npc_zadok_allen` | E | A | B | cápsula + barba | HUM | AST-ANM-414 | AP-C + revisão de arte | pendente |
| AST-CHR-211 | Vendedor da loja de variedades (`look_1`) | `npc_variety_clerk` | E | B | B | cápsula | HUM | AST-CHR-220 | AP-C | pendente |
| AST-CHR-212 | Atendentes do restaurante ×2 | `npc_restaurant_staff` | E | B | B | cápsulas | HUM | AST-CHR-220 | AP-C | pendente |
| AST-CHR-213 | Padre de manto e tiara (silhueta e modelo de média distância) | `npc_tiara_priest`, `evt_basement_priest`, `evt_courtyard_crowd`, `evt_ipswich_party` | E | M | M | cápsula + cone | HUM | AST-PRP-170/171 | AP-C | pendente |
| AST-CHR-214 | Homem embriagado | `npc_drunk_adams`, `evt_drunk_adams` | E | B | B | cápsula | HUM | AST-CHR-220 | AP-C | pendente |
| AST-CHR-215 | Funcionário federal [O] | `npc_federal_officer` | E | B | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-216 | E. Lapham Peabody | `npc_lapham_peabody` | E | M | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-217 | Avô Williamson | `npc_grandfather` | E | B | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-218 | Tio Walter | `npc_uncle_walter` | E | M | B | cápsula | HUM | base humana | AP-C | pendente |
| AST-CHR-219 | Pai (presença mínima, pode ser apenas porta e voz) | `npc_father` | Op | B | B | nenhum (som) | HUM | — | AP-C | pendente |
| AST-CHR-220 | População de Innsmouth: 3 corpos-base × cabeças `look_0`–`look_3` × roupas | `res_*`, `npc_*` de Innsmouth | E | A | A | cápsulas com cor por arquétipo | HUM | AST-TEX-309 | AP-C + revisão D-013 | pendente |
| AST-CHR-221 | Variantes noturnas de perseguidores (curvado, simiesco, saltitante) | `pur_courtyard_party`, `pur_ipswich_party` | E | M | A | cápsulas escuras | HUM | AST-CHR-220, AST-ANM-420/421 | AP-C | pendente |
| AST-CHR-222 | Profundo base ×3 (alto, médio, curvado) | `deep_procession`, `deep_swimmer` | E | A | A | cápsula verde com esfera | HUM | AST-TEX-310 | AP-C + revisão de arte | pendente |
| AST-CHR-223 | Profundo líder: casaco preto corcunda, calça listrada, chapéu de feltro [C] | `evt_rowley_procession` | E | M | B | variação de 222 | HUM | AST-CHR-222 | AP-C | pendente |
| AST-CHR-224 | Profundos com manto e tiara (variações) | `evt_rowley_procession` | E | B | M | variação | HUM | AST-PRP-170/171 | AP-C | pendente |
| AST-CHR-225 | Nadadores (cabeças e braços em água, LOD distante) | `evt_swimmers` | E | B | M | esferas em água | HUM | AST-ANM-433 | AP-C | pendente |
| AST-CHR-226 | Avó transformada (sonho) | `npc_grandmother_dream`, `evt_grandmother_palace` | E | A | B | silhueta | HUM | AST-CHR-222 | AP-C + revisão de arte | pendente |
| AST-CHR-227 | Pth'thya-l'yi (presença vasta, nunca inteira) | `npc_pththya_lyi` | E | M | B | sombra grande | HUM | — | AP-C | pendente |
| AST-CHR-228 | Shoggoth (vislumbre abstrato no sonho) | `evt_grandmother_palace` | R | M | B | massa escura animada | HUM | — | AP-C | pendente |
| AST-CHR-229 | Multidão impostora: cartões animados de Profundos e perseguidores | `evt_ipswich_column`, `evt_rowley_procession`, `evt_swimmers` | E | M | A | cartões de silhueta | HUM/CC (integração) | AST-CHR-222 | AP-C | pendente |
| AST-CHR-230 | Narrador transformado (espelho e cena final, gradual) | `evt_mirror_look`, `evt_final_descent` | E | A | B | variação de 200 | HUM | AST-CHR-200 | AP-C + revisão de arte | pendente |

---

## 6. Texturas e materiais (`AST-TEX`, §22.2)

| ID | Família | Resolução | Uso/reuso | Pri | Comp. | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-TEX-300 | Tijolo (vivo, sujo, ruína) | 64/128 | todos os kits de tijolo — A | E | M | cor sólida | HUM/AQ/GRAV | AP-T | pendente |
| AST-TEX-301 | Madeira tábua (pintada, desbotada, podre) | 64/128 | casas, cais — A | E | M | cor sólida | HUM/AQ/GRAV | AP-T | pendente |
| AST-TEX-302 | Telhas de madeira e ardósia | 64 | telhados — A | E | B | cor sólida | HUM/AQ | AP-T | pendente |
| AST-TEX-303 | Pedra e granito, musgo | 64/128 | igreja, quebra-mar, sonho — A | E | M | cor sólida | HUM/AQ/GRAV | AP-T | pendente |
| AST-TEX-304 | Paralelepípedo, calçada, terra, lama | 64/128 | ruas — A | E | B | cor sólida | HUM/AQ/GRAV | AP-T | pendente |
| AST-TEX-305 | Água (mar, rio, quedas, espuma) em camadas rolantes | 64/128 | orla, desfiladeiro — A | E | M | azul sólido | HUM | AP-T | pendente |
| AST-TEX-306 | Domos de céu por perfil `tod_*` (proposto) | 256 | todos os exteriores — A | E | M | gradiente | HUM | AP-T | pendente |
| AST-TEX-307 | Interiores: papel de parede, assoalho, gesso | 64/128 | interiores — A | E | B | cor sólida | HUM/AQ | AP-T | pendente |
| AST-TEX-308 | Tecidos: lã, sarja, veludo, mantos | 64 | roupas, cortinas — A | E | B | cor sólida | HUM/AQ | AP-T | pendente |
| AST-TEX-309 | Pele e rostos por estágio `look_0`–`look_3` | 128 | personagens — A | E | A | cor sólida | HUM | AP-T + D-013 | pendente |
| AST-TEX-310 | Pele de Profundo (cinza-esverdeado, ventre branco, cristas) | 128/256 | criaturas — M | E | A | verde sólido | HUM | AP-T | pendente |
| AST-TEX-311 | Ouro esbranquiçado com relevos marinhos/geométricos | 256 | tiaras, joias — M | E | A | amarelo | HUM | AP-T + revisão de arte | pendente |
| AST-TEX-312 | Papel, tinta, fotografia prata/sépia | 128/256 | documentos no mundo — A | E | M | branco | HUM | AP-T | pendente |
| AST-TEX-313 | Letreiros (Gilman, Ordem de Dagon, First National, Marsh Refining, Hammond's) | 128/256 | marcos — B | E | M | texto plano | HUM | AP-T + 24 (marcas) | pendente |
| AST-TEX-314 | Vegetação (cartões com alfa recortado) | 64 | pântano, orla — A | E | B | verde | HUM/AQ | AP-T | pendente |
| AST-TEX-315 | Decalques de decadência (manchas, marcas de ferrolho, poeira com pegadas) | 64 | todos — A | E | B | cinza | HUM | AP-T | pendente |

---

## 7. Animações (`AST-ANM`, §22.3)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Dep. | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|---|
| AST-ANM-400 | Mãos: pegar, girar chave de fenda, empurrar, segurar lanterna, abrir porta | `narrator` | R | M | A | sem mãos (câmera + som) | HUM | AST-CHR-200 | AP-A | pendente |
| AST-ANM-401 | Câmera procedural: arrombar com ombro, descer pela cortina, queda, desmaio | ch06, ch07, ch08 | E | B | M | — (procedural) | CC + revisão HUM | — | AP-A + conforto 16 | pendente |
| AST-ANM-410 | Ciclo base humano: idle, andar, virar, falar com gesto | todos os NPCs humanos | E | M | A | cápsula deslizando | HUM/AQ | AST-CHR-220 | AP-A | pendente |
| AST-ANM-411 | Andar arrastado ("shambling") | `res_*`, `npc_joe_sargent` | E | M | A | 410 desacelerado | HUM | 410 | AP-A | pendente |
| AST-ANM-412 | Cabeça seguindo o jogador (procedural) | `res_wary`, `evt_window_watchers` | E | B | A | — | CC | rig | AP-A | pendente |
| AST-ANM-413 | Sentar/levantar | Zadok, bombeiros | E | B | M | pose fixa | HUM/AQ | 410 | AP-A | pendente |
| AST-ANM-414 | Zadok: beber, agarrar lapela/ombro, olhar por cima do ombro, chorar, gritar, fugir cambaleando | ch04 | E | A | B | poses-chave | HUM | AST-CHR-210 | AP-A + revisão de atuação | pendente |
| AST-ANM-415 | Sargent: dirigir, entregar troco | ch01–ch02 | E | B | B | pose fixa | HUM | AST-CHR-204 | AP-A | pendente |
| AST-ANM-416 | Gestos de conversa (Tilton, rapaz, Peabody, Walter) | ch01, ch03, ch08 | E | M | M | 410 idle | HUM/AQ | 410 | AP-A | pendente |
| AST-ANM-417 | Entrar/sair por portas, fechar venezianas | `res_*`, `evt_window_watchers` | R | B | A | teleporte com porta | HUM | 410 | AP-A | pendente |
| AST-ANM-420 | Perseguidor curvado/simiesco (braços tocando o chão) [C] | `evt_washington_band` | E | M | M | 411 curvado | HUM | AST-CHR-221 | AP-A | pendente |
| AST-ANM-421 | Figura de manto "quase saltitante" [C] | `evt_ipswich_party`, `evt_washington_band` | E | M | M | 411 com salto | HUM | AST-CHR-213 | AP-A | pendente |
| AST-ANM-422 | Patrulha com lanterna, parar e olhar, apontar | ch06, ch07 | E | M | A | 410 + rotação | HUM | 410 | AP-A | pendente |
| AST-ANM-423 | Busca (olhar em volta, investigar porta) | ch07 | E | M | A | rotação | HUM | 422 | AP-A | pendente |
| AST-ANM-430 | Profundo salto bípede | `deep_procession` | E | A | A | cápsula saltando | HUM | AST-CHR-222 | AP-A + revisão de arte | pendente |
| AST-ANM-431 | Profundo quadrúpede | idem | E | A | A | idem | HUM | 222 | AP-A | pendente |
| AST-ANM-432 | Transição 2↔4 patas | idem | R | M | A | corte seco | HUM | 430/431 | AP-A | pendente |
| AST-ANM-433 | Nado de superfície (cabeça/braços) | `evt_swimmers`, `evt_zadok_shriek` (ondulação apenas) | E | B | M | esfera oscilando | HUM | AST-CHR-225 | AP-A | pendente |
| AST-ANM-434 | Guelras palpitantes e olhos (vértice/forma simples) | Profundos próximos | R | B | A | — | HUM | 222 | AP-A | pendente |
| AST-ANM-435 | Procissão: loop com deslocamento de fase por indivíduo | `evt_rowley_procession` | E | M | A | cápsulas em fila | HUM + CC (variação) | 430/431 | AP-A | pendente |
| AST-ANM-436 | Movimento onírico flutuante | `lvl_dream_sea` | E | M | M | deslizamento | HUM | 226 | AP-A | pendente |
| AST-ANM-440 | Porta de ligação lascando sob aríete (3 estágios) | `evt_ram` | E | M | M | troca de malha | HUM | AST-PRP-105 | AP-A | pendente |
| AST-ANM-441 | Cortina e varão caindo; cortina pendurada como corda | `pz08_drapery` | E | M | B | troca de malha | HUM | AST-PRP-104 | AP-A | pendente |
| AST-ANM-442 | Ônibus em percurso (trilho) e solavancos | `lvl_bus` | E | B | B | — (procedural) | CC | AST-PRP-150 | AP-A + conforto | pendente |
| AST-ANM-443 | Bote a remo | `evt_rowboat` | E | B | B | deslize | HUM | AST-PRP-141 | AP-A | pendente |
| AST-ANM-444 | Nuvem de morcegos | `evt_bats` | E | B | B | partículas cinza | HUM/CC | — | AP-A + fotossensibilidade | pendente |
| AST-ANM-445 | Desembrulhar joias Orne | `evt_vault_tiara` | E | M | B | troca de malha | HUM | AST-PRP-121 | AP-A | pendente |
| AST-ANM-446 | Animação facial mínima (piscar — exceto quem "nunca pisca" —, boca simples) | heróis | R | M | M | sem rosto animado | HUM | rigs | AP-A | pendente |

Princípios para evitar movimento robótico: animar a 15 fps "stepped" opcional (13); variação de fase e velocidade ±10% por indivíduo; olhar procedural; pausas e micro-hesitações nos perseguidores; câmera do jogador sempre suave e independente.

---

## 8. Áudio e interface (§22.4)

### 8.1 Ambientes (`AST-AMB`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-AMB-500 | Costa e vento (3 intensidades) | exteriores | E | M | A | ruído rosa filtrado | GRAV/AQ | AP-S | pendente |
| AST-AMB-501 | Ondas e maré (baixa/subindo) | orla, `evt_tide_turn` | E | M | A | ruído filtrado | GRAV/AQ | AP-S | pendente |
| AST-AMB-502 | Quedas do Manuxet (perto/longe) | `dist_gorge`, `dist_bank_station` | E | M | M | ruído branco | GRAV/AQ | AP-S | pendente |
| AST-AMB-503 | Cidade vazia do sul (maré + quedas distantes) | `dist_south_waterfront` | E | B | M | silêncio rotulado | GRAV/AQ | AP-S | pendente |
| AST-AMB-504 | Orla norte habitada (sons esparsos, casas tapadas) | `dist_north`, `evt_boarded_sounds` | E | M | M | tons | HUM/GRAV | AP-S | pendente |
| AST-AMB-505 | Praça de Innsmouth (dia, crepúsculo) | `dist_square` | E | M | M | tons | GRAV/AQ | AP-S | pendente |
| AST-AMB-506 | Newburyport (cidade viva 1927) | `lvl_newburyport_*` | E | M | B | tons | AQ/GRAV | AP-S | pendente |
| AST-AMB-507 | Interiores: biblioteca, hotel dia, hotel noite, armazém | interiores | E | M | A | silêncio rotulado | GRAV/AQ | AP-S | pendente |
| AST-AMB-508 | Pântano noturno (insetos, vento no capim) | `lvl_railway_marsh` | E | M | B | ruído | GRAV/AQ | AP-S | pendente |
| AST-AMB-509 | Chuva suave diurna | `ch08a_rain` | E | B | B | ruído | AQ | AP-S | pendente |
| AST-AMB-510 | Domésticos 1928–31 (relógio, rua distante) | ch08 | E | B | M | silêncio | GRAV/AQ | AP-S | pendente |
| AST-AMB-511 | Sonho submarino | `lvl_dream_sea`, `lvl_reef_final` | E | A | M | drone sintético | HUM | AP-S | pendente |
| AST-AMB-512 | Ponte coberta (vento encanado, madeira) | `lvl_railway_marsh` | E | B | B | ruído | GRAV/AQ | AP-S | pendente |

### 8.2 Efeitos (`AST-SFX`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-SFX-520 | Passos por superfície ×7 (jogador e NPC; normal, arrastado, cauteloso, corrida) | todos | E | M | A | clique | GRAV/AQ | AP-S | pendente |
| AST-SFX-521 | Portas (leve, hotel, rua pesada, emperrada) | todos | E | B | A | clique | GRAV/AQ | AP-S | pendente |
| AST-SFX-522 | Ferrolho, fechadura, chave, chave-mestra, chave de fenda | ch05–ch06 | E | M | M | clique | GRAV | AP-S | pendente |
| AST-SFX-523 | Batidas, batidas contínuas, aríete, madeira lascando | `evt_knocking`, `evt_ram` | E | M | B | tons graves | GRAV | AP-S | pendente |
| AST-SFX-524 | Móveis arrastados (silencioso/rápido) | `pz07_barricade` | E | B | M | ruído | GRAV | AP-S | pendente |
| AST-SFX-525 | Cortina, varão, argolas, ardósia solta | `pz08_drapery`, `cp06_roof` | E | B | B | clique | GRAV | AP-S | pendente |
| AST-SFX-526 | Sino rachado (11 e 3 badaladas) | `evt_basement_priest`, `evt_bell_three` | E | M | B | tom | AQ/GRAV + HUM (processar) | AP-S | pendente |
| AST-SFX-527 | Ônibus: motor, freio, porta, solavancos | `lvl_bus`, `evt_bus_breakdown` | E | M | B | ruído | AQ | AP-S | pendente |
| AST-SFX-528 | Motor de carro chiando | `evt_federal_motor`, `evt_ipswich_party`, `evt_marsh_car` | E | B | M | ruído | AQ | AP-S | pendente |
| AST-SFX-529 | Lanterna, interruptor sem luz | `evt_power_cut`, `item_flashlight` | E | B | M | clique | GRAV | AP-S | pendente |
| AST-SFX-530 | Garrafa (oferecer, beber, guardar) | ch04 | E | B | B | clique | GRAV | AP-S | pendente |
| AST-SFX-531 | Papel, jornal, fotografia, mapa | documentos | E | B | A | clique | GRAV | AP-S | pendente |
| AST-SFX-532 | Morcegos | `evt_bats` | E | B | B | ruído | AQ | AP-S | pendente |
| AST-SFX-533 | Vocalizações de perseguidores (ofegar, grunhir, latidos abafados, croaks) | ch05–ch07 | E | A | A | tons | HUM (processamento de AQ/GRAV) | AP-S + revisão de direção | pendente |
| AST-SFX-534 | Vocalizações dos Profundos (coaxar, uivar, balir; "fala" articulada) | `evt_rowley_procession`, sonhos | E | A | M | tons | HUM (processamento de AQ/GRAV) | AP-S + revisão de direção | pendente |
| AST-SFX-535 | Movimento coletivo úmido ("flopping or pattering") | `evt_wind_shift`, `evt_rowley_procession` | E | A | B | ruído | HUM/GRAV | AP-S | pendente |
| AST-SFX-536 | Grito de Zadok (versão sem VO) | `evt_zadok_shriek` | E | M | B | tom | GRAV/HUM | AP-S | pendente |
| AST-SFX-537 | Desmaio (zumbido, coração, abafamento) | `evt_rowley_procession`, `evt_vault_tiara` | E | B | B | tom | HUM | AP-S | pendente |
| AST-SFX-538 | Respiração e esforço do narrador | ch06–ch07 | E | B | M | silêncio | GRAV | AP-S | pendente |
| AST-SFX-539 | UI (papel, página, confirmação discreta) | `sys_ui` | E | B | A | clique | GRAV/AQ | AP-S | pendente |
| AST-SFX-540 | Sinais do mar (tons graves ambíguos) | `evt_reef_signals` | R | M | B | tom | HUM | AP-S | pendente |

### 8.3 Música (`AST-MUS`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-MUS-560 | Motivo da tiara ×4 variações (dissonante → acolhedor) | `evt_tiara_reveal`, `evt_rowley_procession`, `evt_vault_tiara`, `evt_final_descent` | E | A | M | silêncio rotulado | HUM | AP-S + revisão de direção | pendente |
| AST-MUS-561 | Drones de estado: unease, testimony, siege, exposure | ch02–ch07 | E | M | A | drone sintético | HUM | AP-S | pendente |
| AST-MUS-562 | Tema doméstico esparso | ch01, ch08 | R | M | M | silêncio | HUM | AP-S | pendente |
| AST-MUS-563 | Sonho e final (coro processado) | ch08f–g, créditos | E | A | B | drone | HUM | AP-S | pendente |

### 8.4 Voz (`AST-VO`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-VO-580 | Zadok Allen, testemunho completo (inglês) | ch04 | R | A | B | texto + vocalizações 581 | HUM (ator, contrato) | AP-V | pendente |
| AST-VO-581 | Vocalizações não verbais do elenco falante | todos os `npc_*` falantes | E | M | A | silêncio | HUM (atores) | AP-V | pendente |
| AST-VO-582 | VO do elenco secundário | ch01, ch03, ch08 | Op | A | B | texto | HUM | AP-V | pendente |

### 8.5 Interface e fontes (`AST-UI`, `AST-FNT`)

| ID | Descrição | Uso | Pri | Comp. | Reuso | PH aceitável | Origem | Aprov. | Lic. |
|---|---|---|---|---|---|---|---|---|---|
| AST-UI-600 | Papéis de diário, documentos, molduras de fotografia (2D) | `sys_journal`, `sys_documents` | E | M | A | retângulos | HUM | AP-U | pendente |
| AST-UI-601 | Ilustração do mapa desenhado (2D, legível, sem posição) | `item_sketch_map`, `sys_map` | E | M | M | esquema vetorial cinza feito por CC | HUM | AP-U + coerência com 06 | pendente |
| AST-UI-602 | Ícones de prompt de interação e de dispositivos | `sys_interaction` | E | B | A | texto | HUM/AQ | AP-U | pendente |
| AST-UI-603 | Cena de menu: escrivaninha (reuso de AST-ENV-058) | menu principal | E | B | — | reuso | HUM | AP-U | pendente |
| AST-UI-604 | Indicador de presença (acessibilidade) | `sys_ui` | E | B | A | arco simples | CC/HUM | AP-U | pendente |
| AST-UI-605 | Fotografias de época para documentos | `doc_photo_*`, `doc_miniature` | E | M | B | silhuetas | HUM (ilustração) ou AQ (domínio público verificado) | AP-U | pendente |
| AST-FNT-620 | Fonte de leitura principal (legível, licença OFL ou equivalente) | UI, documentos, legendas | E | B | A | fonte do sistema | AQ | AP-U | pendente |
| AST-FNT-621 | Fonte tipográfica de época para fac-símile | documentos | R | B | M | 620 | AQ | AP-U | pendente |
| AST-FNT-622 | Fonte manuscrita (diário, mapa, notas) | diário, mapa | R | B | M | 620 itálica | AQ | AP-U | pendente |

---

## 9. Critérios de aprovação

| Código | Critério |
|---|---|
| AP-M | Modelo dentro do orçamento (13 §4); silhueta legível a 427×240; densidade de texel ~64 px/m (ambiente); escala real e pivô padronizado; colisão simplificada; paleta (13 §5); revisão humana. |
| AP-I | AP-M + legível como interativo no escuro sem contorno brilhante; estados (aberto/fechado/empurrado) e colisão de cada estado. |
| AP-C | AP-M + rig compatível com o ciclo base; atlas único; **não comunica maldade por aparência** e segue D-013; revisão de sensibilidade para personagens de Innsmouth. |
| AP-T | Tamanho correto; tile sem costura; paleta; legível com dithering 60%; sem conteúdo protegido de terceiros. |
| AP-A | Loop limpo; fps definido; sem deslizamento de pé visível na distância de uso; sem jitter de raiz; conforto (16) para animações de câmera. |
| AP-S | Formato e taxa (15 §6.1); loop sem clique; nível dentro da meta; legenda de som definida; aprovado em build gráfica. |
| AP-V | Direção aprovada; contrato com direitos de uso comercial e de distribuição; sincronia com legenda. |
| AP-U | Resolução nativa; contraste; fonte 16–32; legível a 1280×720. |

Todos exigem, além do critério técnico, **licença registrada** antes do status `licenciado`.

## 10. Coerência com outros documentos

* Todo `lvl_`/`dist_` do registro (27 §3) possui ao menos um AST-ENV. Todo `npc_` com modelo (27 §4) possui AST-CHR; `npc_father` é Op e pode ser apenas som.
* Todo `evt_` com componente visual ou sonoro principal possui asset listado na coluna "Uso".
* Ao adicionar um evento, nível ou personagem, adicionar aqui o asset correspondente na mesma alteração.

## 11. Assets efetivamente distribuídos na versão 1.1 (27/10/2026)

Por D-020 e D-021, a 1.1 não contém nenhum arquivo de arte, áudio ou fonte de terceiros além dos que a própria engine embute. Todo o conteúdo visual e sonoro é **gerado por código do projeto no momento da execução**. As tabelas das seções 3–8 continuam valendo como plano de produção caso o responsável decida substituir algum item por arte ou áudio de produção; nesse caso, o item volta ao fluxo da §2.

| Grupo | Onde é gerado | Conteúdo | Origem | Autor | Licença / prova | Atribuição | Status |
|---|---|---|---|---|---|---|---|
| Texturas e materiais | `game/systems/tex_factory.gd` | Papel de parede, madeira, tijolo, ardósia, reboco, paralelepípedo, tábuas de fachada, veludo, terra, listras, pântano, lastro de ferrovia; materiais lisos | Código do projeto (procedural) | Projeto VHB, com assistência de IA (Claude Code) | Mesma licença do código do jogo; nenhum insumo externo | Divulgação de produção assistida por IA (créditos, loja) | licenciado (autoria própria) |
| Geometria de cenários | `game/worlds/**` e `world_kit.gd` | Cidades, interiores, pontes, ônibus, móveis, tiara | Código do projeto | idem | idem | idem | licenciado (autoria própria) |
| Personagens e criaturas | `game/worlds/figure_kit.gd`, `figure_animator.gd` | Pessoas de 1927 (estilos homem, mulher, idoso, funcionário, merceeiro, criança, manto), Profundos (comum, tiara, manto, líder), olhos e vincos da "aparência" (D-013), andar procedural | Código do projeto | idem | idem | idem | licenciado (autoria própria) |
| Sons | `game/systems/sound_synth.gd` | Ambientes (vento, mar, quedas, sala, drone, motor, tamborilar) e efeitos (passos, rangidos, batidas, golpes, estrondo, chave, ferrolho, raspar, coaxar, respiração, coração, sino, ardósia, morcegos etc.), normalizados a −3 dBFS | Código do projeto (síntese) | idem | idem | idem | licenciado (autoria própria) |
| Pós-processamento retrô | `game/shaders/retro_post.gdshader` | Pontilhado Bayer, redução de cor, grão, vinheta, gama | Código do projeto | idem | idem | — | licenciado (autoria própria) |
| Fonte da interface | Embutida no Godot | Open Sans | Godot Engine (thirdparty) | The Open Sans Project Authors | SIL OFL 1.1, listada em `GODOT_COPYRIGHT.txt` (acompanha a build) | Arquivo de licença na build | licenciado |
| Engine | `tools/godot/4.7.2/` | Godot Engine 4.7.2 e templates | godotengine.org (cópia verificada por SHA-256) | Godot Engine contributors | MIT, `GODOT_LICENSE.txt` + `GODOT_COPYRIGHT.txt` na build | Créditos no jogo | licenciado |

Não há música, voz gravada nem fotografia. A varredura de placeholders (INN-401) procura o prefixo `ph_` nos IDs de recurso do código; resultado registrado em `28-ESTADO-IMPLEMENTACAO.md`.

**Limite honesto:** "licenciado (autoria própria)" significa procedência limpa, não aprovação artística. A qualidade visual e sonora foi verificada só pelo autoteste (capturas e medições), sem revisão humana de arte ou de mixagem (D-020).
