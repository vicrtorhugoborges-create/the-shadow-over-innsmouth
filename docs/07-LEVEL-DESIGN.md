# 07 — Level design

> Complementa `06-MAPA-DE-INNSMOUTH.md` (geografia) e é detalhado em `08-GILMAN-HOUSE.md` e `09-FUGA-NOTURNA.md`. Eventos e checkpoints são definidos em `05-CAPITULOS-E-PROGRESSAO.md`; paletas e materiais em `13`/`14`; ambiências em `15`.

## 1. Princípios

1. **Caminho claro, bordas ricas.** Cada área tem um caminho principal legível por arquitetura e luz; o detalhe narrativo fica nas bordas (janelas, vitrines, placas caídas).
2. **Barreiras diegéticas.** Nunca paredes invisíveis sem motivo visível: casas tapadas, cercas, entulho, água, desníveis, portas trancadas. Onde um limite precisar existir, o narrador pode comentá-lo uma vez no Diário (ex.: "não há razão para ir além daqui" é evitado; prefere-se uma razão física).
3. **Reuso intencional.** O mesmo kit modular de ruas compõe todos os distritos; a identidade vem de landmarks, materiais, densidade de ruína e som (D-004).
4. **Escala comprimida.** Quarteirões têm 40–60 % do tamanho real; travessias longas do conto (ex.: Bank Street) são resumidas a trechos de 30–90 s de caminhada.
5. **Nenhum distrito sem propósito.** Todo espaço jogável serve a pelo menos um objetivo, documento, evento ou rota (tabela §4).

## 2. Unidades de streaming

`lvl_innsmouth` é uma cena-mãe com distritos-filhos carregados por proximidade (contrato em `17`, `sys_scene_loader`). Pontos de troca ficam em gargalos onde o campo de visão é limitado.

| Distrito | Gargalos de entrada/saída | Vizinhos sempre visíveis como impostor |
|---|---|---|
| `dist_square` | ponte da Federal; bocas da Paine, Eliot, Waite, Marsh | cúpula, campanários, refinaria |
| `dist_gorge` | cabeceiras das pontes | cidade das duas margens |
| `dist_north` | Martin Street; ponte da Water | praça, Green |
| `dist_patrician` | Martin; ponte precária | campanário da igreja gótica |
| `dist_south_waterfront` | Waite; Main sul; Marsh/Fall | recife, quebra-mar |
| `dist_south_residential` | pátio do Gilman; Bates; Babson | cúpula do Gilman |
| `dist_bank_station` | Adams; borda do desfiladeiro | ponte coberta |

No máximo dois distritos completos ficam carregados ao mesmo tempo; os demais existem como impostores de baixa contagem (meta de desempenho em `19`, não medida).

## 3. Fichas de ambiente

Quantidades de NPCs são **visíveis simultâneos**, não população total.

### 3.1 `dist_square` — Town Square

| Campo | Definição |
|---|---|
| Construções | Semicírculo de tijolo c. 1800, telhados inclinados, térreos com lojas; Gilman alto com cúpula e restos de tinta amarela [C] |
| Materiais | Tijolo vermelho escurecido, paralelepípedos, vitrines sujas, letreiros a meio apagados |
| Paleta | Ocre e tijolo sob céu leitoso (dia); âmbar fraco de lâmpadas incandescentes (crepúsculo) |
| Som | Rugido constante das quedas; motor de caminhão ocasional; sino distante |
| Luz | Sol alto; poucas lâmpadas pequenas e fracas [C] |
| NPCs | ~10 de dia [C "perhaps ten people visible"]; 15–20 aglomerados à porta do Gilman às 19h45 (`evt_gilman_crowd`) |
| Elementos | Mercearia First National, restaurante, drogaria, peixaria atacadista, escritório Marsh [C]; 4–5 carros e caminhões [C] |
| Landmarks | Cúpula do Gilman; rio no lado reto |
| Caminhos | Ponte (N), Paine (NO), Eliot (SO), Federal (S), Waite e Marsh (SE) |
| Barreiras | Balaustrada do desfiladeiro; Federal sul bloqueada por caminhão de peixe estacionado até ch07 [O] |
| Transições | Lobby do Gilman, mercearia, restaurante, loja de variedades (interiores separados, carregamento curto em porta) |

### 3.2 `dist_gorge` — Desfiladeiro e refinaria

| Campo | Definição |
|---|---|
| Construções | Ponte de ferro com guarda-corpo; fábricas na borda; refinaria num moinho antigo com campanário branco [C] |
| Materiais | Ferro rebitado, pedra úmida, tijolo de fábrica, espuma |
| Paleta | Cinza-azulado, branco da espuma, ferrugem |
| Som | Quedas ensurdecedoras na ponte [C]; refinaria "oddly free from the noise of industry" [C] — silêncio industrial como estranheza |
| NPCs | 0–2; o carro cortinado de Marsh (`evt_marsh_car`, R) |
| Landmarks | Duas quedas a montante, uma a jusante |
| Barreiras | Guarda-corpo; portões da refinaria |
| Nota | O ruído da água mascara passos (reaproveitado como regra de furtividade em Bank Street, ver 09) |

### 3.3 `dist_north` — Green, igrejas e cortiços

| Campo | Definição |
|---|---|
| Construções | Salão maçônico de colunas com placa preta e dourada "Esoteric Order of Dagon"; igreja gótica de pedra com porão alto e janelas fechadas; casas de madeira inclinadas, casas de salga [C] |
| Materiais | Tinta branca descascada, pedra cinza, tábuas pregadas, conchas e peixe morto nos quintais [C] |
| Paleta | A mais dessaturada da cidade; verde-oliva de musgo |
| Som | Rangidos e raspadas **mais fortes dentro das fachadas tapadas** (`evt_boarded_sounds`) [C] |
| NPCs | 3–6 figuras arrastadas, `res_wary` e `res_advanced` entrevistos em portas [C "more hideous and abnormal"] |
| Landmarks | Campanário decapitado; igrejas de Main e Church |
| Caminhos | Water (casas de salga), Main norte, Martin |
| Barreiras | Casas tapadas; Green "não aconselhável": o jogador pode olhar de uma esquina; aproximar-se do pórtico faz um `res_order_member` sair e observar fixamente (dissuasão, sem perigo) |

### 3.4 `dist_patrician` — Mansões

| Campo | Definição |
|---|---|
| Construções | Mansões georgianas, telhados de quatro águas, cúpulas, *widow's walks*; uma fileira de 4–5 bem conservadas na Washington; a de Marsh com parterres em terraço [C] |
| Materiais | Madeira pintada, cercas de ferro, olmos |
| Paleta | Verde dos gramados cuidados contrastando com o resto |
| Som | Silêncio total; nenhum gato ou cão [C]; vento nos olmos |
| NPCs | 0 visíveis; persianas de sótão e terceiro andar fechadas (`evt_window_watchers`) |
| Barreiras | Portões trancados; a ponte precária ao sul com aviso |

### 3.5 `dist_south_waterfront` — Orla abandonada

| Campo | Definição |
|---|---|
| Construções | Telhados *gambrel* desabados, casas tortas por fundações afundadas, armazéns de tijolo e pedra (Fish) em bom estado, lacunas onde havia cais (Water) [C] |
| Materiais | Madeira podre, alvenaria de cais, musgo, areia |
| Paleta | Dourado de fim de tarde em ch04 ("mystic loveliness", IV) sobre ruína cinza |
| Som | Marés e quedas apenas [C]; gaivotas raras [O] |
| NPCs | Pescadores minúsculos no quebra-mar [C] |
| Landmarks | Recife; quebra-mar com base de farol |
| Barreiras | Água, cais quebrados, entulho |
| Local-chave | Cais de Zadok: abertura gramada entre muros de tijolo, cais de terra e alvenaria, pedras com musgo como assentos, armazém arruinado ao norte que esconde a cena [C] |

### 3.6 `dist_south_residential` — Bairro sul (noite)

| Campo | Definição |
|---|---|
| Construções | Mesmo kit de `dist_patrician`, mais decadente; vestíbulos abertos ("yawning vestibule", IV); praça com jardim gradeado em ferro [C] |
| Paleta | Luar amarelado intenso nas áreas abertas; sombras azul-escuras sob beirais |
| Som | Vozes roucas, passos e "a curious kind of pattering" em várias direções [C] |
| NPCs | Grupos `pur_*` de 2–8; ver 09 |
| Barreiras | Becos fechados por cercas e escombros; ruas iluminadas pelo luar funcionam como "zonas expostas" |

### 3.7 `dist_bank_station` — Bank Street e estação

| Campo | Definição |
|---|---|
| Construções | Grandes muros de armazéns de tijolo; estação em arcadas arruinada [C] |
| Som | Quedas que "quite drowned my footsteps" [C] — zona sem penalidade de ruído |
| NPCs | 0 |
| Saída | Trilhos a partir do fim da estação → `lvl_railway_marsh` |

### 3.8 Cenas fora do núcleo

| Cena | Identidade | Tamanho jogável |
|---|---|---|
| `lvl_newburyport_station` | Bilheteria de madeira envernizada, quadro de horários | 1 sala + plataforma curta |
| `lvl_newburyport_library` | Estantes das histórias do condado de Essex, lâmpadas verdes | 1 sala de leitura |
| `lvl_newburyport_society` | Rua curta à noite até a casa de Tilton e o prédio; vitrine de canto com a tiara sob luz elétrica, almofada de veludo roxo [C] | 1 rua + 1 sala |
| `lvl_newburyport_square` | Market Square, Hammond's Drug Store, Ideal Lunch [C] | praça pequena |
| `lvl_bus` | Interior do ônibus; paisagem como trilho de cenário (dunas, juncos, pontes de madeira, postes com dois fios) [C] | assento; câmera livre |
| `lvl_railway_marsh` | Trilhos, ponte coberta escura, aterro, corte de areia e espinheiros | trilha linear de ~6–8 min |
| `lvl_arkham` | Sala de depoimento [O], sala da sociedade histórica | 2 salas |
| `lvl_cleveland_house` / `lvl_cleveland_vault` | Casa vitoriana opressiva; sala de cofres de banco | 2 salas + 1 |
| `lvl_toledo_room` | Quarto e escrivaninha, espelho | 1 sala |
| `lvl_dream_sea` / `lvl_reef_final` | Ver 13 e 04 | espaços oníricos lineares |

## 4. Propósito por espaço jogável (verificação de "nenhum ambiente sem propósito")

| Espaço | Objetivo / evento / documento |
|---|---|
| Praça | chegada, `cp02_square`, mercearia, encontro com Zadok |
| Mercearia | `item_sketch_map`, informações sobre Marsh, igrejas, Zadok |
| Desfiladeiro/refinaria | `evt_falls_roar`, `evt_marsh_car` (R), primeira impressão do ouro |
| Zona norte | `evt_boarded_sounds`, `doc_church_tract`, `doc_order_notice` |
| Mansões | `evt_window_watchers`, `evt_bell_three`, `doc_bridge_warning` |
| Orla sul | atmosfera de deserção, cais de Zadok (ch04) |
| Loja de variedades | `pz03_whiskey` |
| Gilman | ch05–ch06 inteiros (ver 08) |
| Bairro sul / Bank / ferrovia | ch07 inteiro (ver 09) |

## 5. Barreiras de progressão

| Barreira | Capítulo | Forma diegética | Liberação |
|---|---|---|---|
| Não há ônibus antes das 20h | ch03 | Horário (`doc_bus_timetable`) e conversa | ch05 |
| Green e Ordem de Dagon | ch03 | Observadores e advertência [C] | nunca entrar |
| Retorno ao hotel | ch04 | Fuga de Zadok e relógio às 19h15 [C] | início de ch05 |
| Federal sul e estradas | ch07 | Patrulhas e motor [C] | nunca: rota obrigatória pela ferrovia [C] |
| Pântano fora do aterro | ch07 | Água e lama profunda | — |

## 6. Ritmo espacial

Alternância deliberada entre **espaços comprimidos** (interiores, vestíbulos, ponte coberta, corte) e **espaços abertos expostos** (crista, praça da South, South Street, aterro). Toda abertura ampla na noite é precedida de um espaço fechado onde o jogador pode parar e olhar, para que a exposição seja uma escolha consciente.
