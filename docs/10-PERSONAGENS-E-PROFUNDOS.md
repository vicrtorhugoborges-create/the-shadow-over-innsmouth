# 10 — Personagens, habitantes e Profundos

> IDs em `27-REGISTRO-DE-IDS.md` §4. Falas e cenas em `04-HISTORIA-E-ROTEIRO.md`; especificações de modelagem em `13`; vozes e vocalizações em `15`; comportamento em `11`.

## 1. Regras de elenco

1. **Nenhum personagem nomeado inventado no escopo E** (D-012). Papéis sem nome são marcados [O] quando suas falas forem originais.
2. **Aparência não indica maldade.** Personagens com traços de transformação podem ser civis, prestativos ou indiferentes; personagens sem traços podem ser cúmplices.
3. **A "aparência de Innsmouth" é anfíbia, não étnica** (D-013).
4. **Ilhéus do Pacífico não são representados visualmente** (D-014); Walakea e seu povo existem apenas na fala de Zadok e em objetos (contas de vidro, joias).

## 2. Elenco principal

| ID | Papel dramático | Traços de jogo | Fidelidade e cuidados |
|---|---|---|---|
| `narrator` | Jovem de 21 anos de Toledo, estudante de Oberlin, viajante econômico, antiquário, interessado em arquitetura e genealogia | Nunca visto em terceira pessoa até o epílogo; mãos e mangas em primeira pessoa; reflexos turvos; sotaque "Westerner" comentado pelo bilheteiro | [C]. Sem nome. Sua voz interna é breve, curiosa, às vezes arrogante ("youthful egotism", III); seus preconceitos são de época e **não** são confirmados pelo jogo (ver 02) |
| `npc_ticket_agent` | Primeiro informante; cético, "no local man", de Panton (Vermont) | Diálogo de ch01 | [C]. Seu discurso contém preconceito explícito no conto ("race prejudice"); o jogo mantém o ceticismo e o rumor, e reformula o preconceito como **atitude dele**, marcada pelo próprio tom de superioridade [I] |
| `npc_anna_tilton` | Curadora idosa, gentil, desdenhosa de Innsmouth que nunca viu | Abre a sala da Sociedade à noite; teoria do tesouro pirata | [C] |
| `npc_joe_sargent` | Motorista; presença repulsiva e muda | Olhar que não pisca; troco sem palavra; anuncia o defeito | [C] descrição longa no cap. II; arte segue D-013 (ver §4) |
| `npc_grocery_clerk` | Rapaz de ~17 anos de Arkham, aliviado por falar com alguém de fora | Fonte principal de informação e do mapa | [C]. Sem nome |
| `npc_zadok_allen` | Testemunha de 96 anos, bêbado da cidade, aterrorizado | Testemunho de ch04 | [C]. Retratado com dignidade: trauma de infância (o pai desaparecido em 1846), medo real, humor amargo. Nunca como piada |
| `npc_tiara_priest` | Figura de manto e tiara | Silhueta no porão (ch02), no pátio (ch06), no bando (ch07) | [C] três aparições; identidade não revelada |
| `npc_lapham_peabody` | Curador de Arkham, cortês e curioso | Notas genealógicas; "true Marsh eyes" | [C] |
| `npc_uncle_walter` | Tio viúvo, guardião dos arquivos Orne, relutante | Abre o cofre | [C] |
| `npc_grandfather` | Avô Williamson | Registros Williamson | [C] |
| `npc_grandmother_dream` | Eliza Orne transformada, calorosa "talvez sardonicamente" | Sonho do palácio | [C] como sonho |
| `npc_pththya_lyi` | Tataravó, 80 mil anos em Y'ha-nthlei | Presença imensa, nunca de frente inteira | [C] como sonho |

## 3. Elenco secundário

| ID | Função | Notas |
|---|---|---|
| `npc_ymca_clerk`, `npc_librarian` | Desencorajam a viagem; a bibliotecária escreve `doc_intro_note` | [C] |
| `npc_bus_passenger` ×3 | Mesmos homens na ida e na volta [C] | Andar arrastado; falam algo "not English" com um ocioso (ch05) |
| `npc_gilman_day_clerk` | Idoso sem a "aparência"; exceção que intriga o rapaz | [C]. Fala mínima e cansada |
| `npc_gilman_night_clerk` | Taciturno, "evil-visaged" segundo o narrador | [C]. O jogo mostra só cansaço e silêncio; o julgamento fica no Diário do narrador |
| `npc_fireman` ×2 | "unkempt but not abnormal-looking" [C] | Prova de que nem todos têm a aparência |
| `npc_variety_clerk` | Vende o uísque; "quite civil in his way" [C] | Estágio `look_1`; prestativo — contraexemplo deliberado |
| `npc_restaurant_staff` ×2 | Serviço de balcão | [C]; `look_1`–`look_2`; neutros |
| `npc_drunk_adams` | Susto inofensivo na fuga | [C]; humano comum embriagado |
| `npc_federal_officer` | Ouve o depoimento | [O] falas; burocrata cético, depois sério |
| `npc_father` | Voz e passos atrás de portas; olha o filho "almost affrightedly" [C] | Nunca em cena plena |

## 4. Habitantes de Innsmouth

### 4.1 Arquétipos (`res_*`)

O conto já oferece diversidade interna: famílias "gently bred" reclusas, membros juramentados da Ordem, quem "keep quiet", não nativos, bombeiros comuns, um vendedor civil, Zadok que tomou dois juramentos e recusou o terceiro [C]. O jogo usa essa diversidade em vez de inventar personagens.

| Arquétipo | Quem representa | Estágio visual | Comportamento no dia | Comportamento à noite |
|---|---|---|---|---|
| `res_ordinary` | Moradores que trabalham, compram, pescam; "keep quiet" | `look_0`–`look_1` | Rotina; desviam o olhar; respondem por monossílabos | Dentro de casa; luzes apagam |
| `res_wary` | Moradores que vigiam estranhos | `look_1`–`look_2` | Param e observam; interrompem conversas; avisam outros com um gesto | Integram duplas e grupos |
| `res_order_member` | Juramentados da Ordem de Dagon | `look_1`–`look_3`, manto à noite | Perto do Green, das igrejas e da refinaria; saem para observar quem se aproxima | Lideram grupos; lanternas |
| `res_advanced` | Pessoas muito transformadas, mantidas fora de vista [C] | `look_3` | Apenas entrevistas: vulto atrás de cortina, forma numa porta da orla norte | Nos grupos de perseguição, ao fundo |
| `res_nonnative` | Rapaz da mercearia, funcionário idoso, bombeiros | `look_0` | Falam com o narrador | Ausentes |
| Família Marsh (elite) | Barnabas e parentes | não vistos | Carro fechado e cortinado (R); mansão com persianas fechadas | [I] líder da procissão |

### 4.2 Estágios visuais da transformação (`look_0`–`look_4`)

Escala de **arte e animação**, não estatística de jogo. Nenhum estágio altera a agressividade do personagem.

| Estágio | Traços (anfíbios, D-013) | Andar | Fala | Onde aparece |
|---|---|---|---|---|
| `look_0` | Nenhum | normal | normal | não nativos, bombeiros, Zadok |
| `look_1` | Olhar fixo e lacrimejante que raramente pisca; leves vincos laterais no pescoço; pele levemente acinzentada | normal | voz um pouco rouca | maioria dos moradores visíveis |
| `look_2` | Olhos salientes que não piscam; vincos fundos no pescoço; calvície precoce; pele áspera com descamação; mãos grandes e de tom cinza-azulado com dedos curtos que se fecham | arrastado | gutural, abafada | Sargent, atendentes, grupos |
| `look_3` | Pescoço com guelras visíveis; pele brilhante; membranas entre os dedos; postura curvada; pés imensos | saltitante às vezes | coaxar misturado a palavras | grupos noturnos, vultos |
| `look_4` | Profundo plenamente transformado (ver §6) | dois ou quatro apoios | vocalização articulada não humana | nadadores, procissão, sonhos |

Fontes canônicas dos traços: descrição de Joe Sargent (II), relato do bilheteiro (I), do rapaz da mercearia (II), Profundos na estrada de Rowley (IV).

### 4.3 Diretrizes de representação

1. **Traços a evitar:** formato de nariz, cor de pele humana, textura de cabelo ou formato de crânio associados a grupos étnicos reais. O conto usa "flat noses", "narrow heads" e comparações raciais; o jogo substitui por sinais anfíbios: olhos, pescoço, pele, mãos, pés, postura e voz.
2. **Variação:** cada estágio tem ≥ 3 combinações de cabeça/roupa para evitar "exército de clones" (13).
3. **Roupas:** classe trabalhadora costeira de 1927 — macacões, suéteres grossos, botas de borracha, bonés; elite com casacos eduardianos antiquados (Marsh, [C] "frock-coated finery of the Edwardian age").
4. **Crianças:** o conto menciona crianças; o jogo **não** inclui crianças em cena de perigo nem como figuras monstruosas. No máximo sons distantes de crianças brincando na chegada [O], removível.

## 5. Ressalvas sobre descrições do narrador

| Trecho | Risco | Solução |
|---|---|---|
| "simian-visaged children" (II) | Animalização com eco racial | Não reproduzido; crianças ausentes (§4.3) |
| "One man moved in a positively simian way, with long arms frequently touching the ground" (IV) | Idem | Mantido apenas como **movimento** de um perseguidor `look_3` que apoia as mãos no chão — leitura anfíbia/quadrúpede, sem traços faciais simiescos; no texto do jogo: "um deles avançava apoiando as mãos no chão" |
| "white trash", comparações com "cannibals", "Guinea savages" (I) | Preconceito de classe e racial | Fala do bilheteiro reduzida ao rumor e ao desprezo; termos não reproduzidos (02) |
| "Kanakys" e a história de Walakea (III) | Enquadramento colonial | Narrado só por Zadok, sem imagem; o Diário registra como "a história que Zadok contou", nunca como fato confirmado (D-014) |
| "biological degeneration" (II) | Eugenismo | O jogo trata a transformação como metamorfose de outra espécie, não como "degeneração" |

## 6. Os Profundos (`deep_*`)

### 6.1 Descrição canônica (IV)

Predominantemente **cinza-esverdeados** com **ventre branco**; lisos e escorregadios, com **cristas escamosas** no dorso; forma vagamente antropoide; **cabeça de peixe** com olhos enormes e salientes que **nunca fecham**; **guelras pulsantes** nas laterais do pescoço; **patas longas e palmadas**; saltam irregularmente **ora em duas, ora em quatro patas**; quatro membros apenas; vozes que coaxam e ladram, "clearly used for articulate speech", com toda a expressão que os rostos não têm. Alguns usam **tiaras** de ouro esbranquiçado e mantos; o líder veste **casaco preto corcunda, calças listradas e chapéu de feltro** sobre "the shapeless thing that answered for a head" — interpretado como Barnabas Marsh [I, apoiado em III: "he still wears clothes, but he'll take to the water soon"].

Complementos: os relevos da tiara mostram "fish-frogs" "half ichthyic and half batrachian" (I); Zadok fala de criaturas que vivem dentro e fora da água e não morrem senão por violência (III).

### 6.2 Direção de arte

| Aspecto | Definição |
|---|---|
| Silhueta | Corpo de rã alongado em postura semiereta; cabeça larga sem pescoço; olhos laterais altos; dorso arqueado com crista; mãos e pés grandes e palmados |
| Variações | `deep_swimmer` (só cabeça e braços acima da água, malha mínima), `deep_procession` (3 malhas: magro, robusto, curvado; acessórios: tiara, manto, nada; líder com roupas humanas), `deep_dream` (mais elegante, ornamentado, luminescência suave) |
| Textura | Atlas 128 px; gradiente cinza-esverdeado → ventre branco; escamas no dorso por textura; brilho especular falso por vertex color |
| Luz | Sempre de lado ou de trás (luar, lanternas); ventre branco capta luz e define a forma; rosto nunca em luz frontal plena antes do sonho |
| Visibilidade parcial | Antes da procissão: cabeças na água, silhuetas recortadas, ondulações |
| Movimento | Salto irregular bípede ↔ apoio quádruplo; pausas; cabeça que não gira com o corpo; guelras pulsando em loop |
| Grupo | Nunca marcham em sincronia; fluxo como cardume que se alarga e estreita |

### 6.3 Animações essenciais (lista para 18)

`deep_hop_biped`, `deep_hop_quad`, `deep_transition_biped_quad`, `deep_idle_gills`, `deep_swim_surface`, `deep_dive`, `deep_turn_head`, `deep_leader_walk` (roupas). Procedurais simples: pulso das guelras, oscilação de cabeça. Ver 13 e 18.

### 6.4 Calendário de presença (presença antes da aparição)

| Capítulo | Forma de presença | Evento |
|---|---|---|
| ch01 | Relevos da tiara | `evt_tiara_reveal` |
| ch02 | Padre de tiara no porão escuro | `evt_basement_priest` |
| ch03 | Sons nas casas tapadas; rumores; vultos `res_advanced` | `evt_boarded_sounds` |
| ch04 | "one set of ripples more local" | `evt_zadok_shriek` |
| ch05–ch06 | Vozes que não são vozes; ofegos; latidos abafados | `evt_power_cut`, `evt_ram` |
| ch06 | Multidão de formas indistintas com lanternas | `evt_courtyard_crowd` |
| ch07 | Nadadores ao longe; bote; grupos com rostos bestiais a uma quadra | `evt_swimmers`, `evt_rowboat`, `evt_washington_band` |
| ch07 | Coluna distante | `evt_ipswich_column` |
| ch07 | **Revelação completa** | `evt_rowley_procession` |
| ch08 | Sonhos: "I was one with them" | `evt_dream_descent`, `evt_grandmother_palace` |
| ch08 | O próprio rosto no espelho | `evt_mirror_look` |

### 6.5 Shoggoth

Mencionado por Zadok (III) e visto no sonho (V). **Nunca mostrado com forma definida**: no sonho, um único plano de massa escura iridescente que preenche o enquadramento e acorda o narrador. Escopo R; no E basta corte para o despertar com grito (texto + som).

## 7. Vozes e comportamento sonoro (resumo; detalhes em 15)

| Grupo | Voz |
|---|---|
| Humanos de Newburyport e Arkham | Inglês da Nova Inglaterra (VO opcional), texto em PT-BR |
| Zadok | Dialeto forte (VO no nível R, D-008); legendas em PT-BR que preservam ritmo sem caricatura |
| Moradores `look_1`–`look_2` | Poucas palavras, roucas |
| Grupos noturnos | Grunhidos, ofegos, "croaking", "guttural patois" — **sem palavras inteligíveis** [C] |
| Profundos | Coaxar, ladrar, balir em padrões articulados; camadas de multidão |
