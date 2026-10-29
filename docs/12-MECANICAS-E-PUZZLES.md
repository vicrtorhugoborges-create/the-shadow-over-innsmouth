# 12 — Mecânicas, investigação e puzzles

> Contratos técnicos dos sistemas (`sys_player`, `sys_camera`, `sys_interaction`, `sys_inventory`, `sys_documents`, `sys_journal`, `sys_map`) em `17`. Controles e acessibilidade em `16`. Percepção em `11`. Texto final dos documentos em `04`.

## 1. Ciclos de jogo

**Exploração:** Explorar → Observar → Investigar → Interpretar → Descobrir → Avançar. Recompensa: informação, não pontos.

**Perigo:** Perceber ameaça → Avaliar ambiente → Escolher rota → Agir → Escapar. Ocorre em ch06 e ch07 apenas, mais o salto da ponte coberta.

## 2. Movimento (`sys_player`)

| Ação | Velocidade relativa | Ruído (11 §4.2) | Disponível | Nota |
|---|---|---|---|---|
| Andar | 1,0 | 6 m | sempre | padrão |
| Andar cauteloso | 0,5 | 2 m | sempre | segurar; evita escorregar nas ardósias (ch06) |
| Correr | 1,7 | 14 m | sempre, exceto sequências | sem barra de fôlego; respiração audível após 20 s contínuos (cosmético) |
| Agachar | 0,4 | 2 m | sempre | reduz altura para mato e vestíbulos; alternar ou segurar |
| **Andar arrastado** | 0,6 | 6 m | ch07 (desbloqueado no primeiro espaço aberto ao luar) [C] | Câmera com balanço lateral sutil (desativável); visibilidade 0,25 ao luar a distância |
| Pular | — | — | **apenas contextual** | vão da ponte coberta, claraboia, cerca baixa |
| Escalar | — | — | **apenas contextual** | descer pela cortina; janela/veneziana |
| Portas e janelas | — | variável | interação | ver §4 |

Excluídos: parkour, deslizar, escalada livre, combate corpo a corpo, empurrar NPCs.

## 3. Câmera (`sys_camera`)

| Item | Definição |
|---|---|
| Perspectiva | Primeira pessoa fixa; corpo do narrador visível só nas mãos durante interações |
| FOV | 60–100°, padrão 75° (16) |
| Head bob | Desligado por padrão; intensidade 0–100 % |
| Tremores | Só em `evt_ram`, `evt_rowley_procession` e queda; intensidade ajustável e desligável |
| Foco | Ao examinar, o objeto vem às mãos, fundo escurece levemente; profundidade de campo **não** usada |
| Documentos | Leitor em tela cheia na resolução nativa (16) |
| Olhar guiado | Giro suave de cabeça em 4 momentos (porão do padre, recife na crista, grito de Zadok, procissão) — **opcional**, desativável; nunca rouba controle por > 1 s |
| No ônibus | Corpo fixo, cabeça livre ±100° horizontal |
| Antienjoo | Vinheta opcional em corrida, ponto central opcional, sem aceleração de mouse, sem roll |

## 4. Interação (`sys_interaction`)

Uma única ação **Interagir** com verbo contextual exibido em texto pequeno junto ao centro da tela (ex.: "Examinar", "Abrir", "Trancar", "Empurrar"). Distância máxima 2 m. Sem contorno brilhante nos objetos; legibilidade vem de forma, posição e luz (13).

| Interação | Forma | Indispensável? |
|---|---|---|
| Examinar/pegar | Pressionar; objeto vai às mãos; girar com o olhar | Sim |
| Ler | Abre o leitor; guarda no Diário | Sim |
| Conversar | Pressionar; menu de temas (ver §6) | Sim |
| Abrir/fechar porta | Pressionar | Sim |
| Trancar/destrancar ferrolho | Pressionar na trava | Sim |
| Ler dobradiças | Examinar a porta: o narrador comenta para que lado abre; o batente e as dobradiças são visíveis no modelo | Sim (ch06) |
| Arrombar com o ombro | Pressionar repetidamente; **alternativa: segurar** (mesmo tempo total) | Sim (ch06) |
| Empurrar móvel | Segurar Interagir e andar; só móveis marcados por forma (cama, cômoda, lavatório); encaixe automático ao chegar ao destino válido | Sim (ch06) |
| Usar ferramenta | Contextual com `item_keyring_tool` selecionado automaticamente | Sim (ch05) |
| Manipular cortina | Derrubar → prender → lançar (três interações) | Sim (ch06) |
| Usar mapa | Ação própria (atalho) ou pelos Bolsos | Sim |
| Lanterna | Ação própria; disponível a partir de ch05 | Sim |
| Fechar os olhos | Segurar ação própria, só em ch07 | Sim |
| Oferecer garrafa | Opção no menu de Zadok | Sim |
| Mecanismos simples | Interruptor da lâmpada, veneziana, claraboia | Sim |

Excluídas: combinar itens livremente, girar mecanismos com física, rotação de objetos para achar marcas escondidas, quebra-cabeças de cofre.

## 5. Bolsos, Diário e Documentos (`sys_inventory`, `sys_journal`, `sys_documents`)

### 5.1 Comparação

| Opção | Prós | Contras |
|---|---|---|
| Inventário físico limitado | Tátil | Gestão inútil; foge do tom |
| Coleção simples de itens | Clara | Sem espaço para pensamento |
| Diário de investigação | Narrativo | Itens físicos ficam abstratos |
| **Híbrido (escolhido, D-006)** | Itens-chave tangíveis + memória escrita | Duas telas — resolvido com abas |

### 5.2 Bolsos

Até 8 itens (`item_*` do registro). Nenhum item é descartável, combinável ou consumível, exceto a garrafa (esvazia em ch04) e as bolachas (cosmético). Itens são concedidos por `sys_story_state` via eventos, nunca pela UI.

### 5.3 Diário

Três abas: **Notas** (pensamentos e fatos, na voz do narrador, no passado), **Documentos** (relidos) e **Testemunhos** (paráfrase das conversas). Regras:

1. Só registra o que o narrador viu, ouviu ou leu. Interpretações do narrador são marcadas como suas ("pareceu-me", "talvez").
2. Nunca antecipa: em ch01 a tiara é "um objeto de arte sem tradição reconhecível", não "um artefato dos Profundos".
3. Objetivo atual aparece como a última nota, escrita como intenção ("Pegar o ônibus das oito para Arkham."), nunca como ordem.
4. Dicas graduais (três níveis: pergunta → lugar → passo) sob pedido em `pz02`, `pz03`, `pz06`, `pz09`, `pz10`, `pz12`; pedir dica não concede progresso.
5. Em ch08 o tom muda: notas passam a hesitar, corrigir-se e, perto do fim, a expressar atração (ver 04).

### 5.4 Documentos

| ID | Nome | Onde | Conteúdo resumido | Função narrativa | Progressão | Relação | Classe |
|---|---|---|---|---|---|---|---|
| `doc_manuscript` | Primeira página do manuscrito | `lvl_toledo_room`, ch00 | Abertura retrospectiva: as batidas federais, a decisão de "quebrar o silêncio" | Moldura; promessa do fim | não | retorna em ch08g | [C] conteúdo / [O] forma |
| `doc_bus_timetable` | Anotação dos horários | bilheteria, ch01 | Ônibus de Joe Sargent: 10h e 19h diante da Hammond's; volta de Innsmouth às 20h | Objetivo de ch01–ch05 | sim | `evt_bus_breakdown` | [C] |
| `doc_essex_history` | Histórias do condado de Essex | biblioteca, ch01 | Fundação 1643; construção naval; prosperidade; epidemia e motins de 1846 tratados com escassez; refinaria Marsh após a Guerra Civil; poloneses e portugueses "dispersos" | Contexto histórico; ausência suspeita | sim (leva a `doc_jewellery_note`) | Zadok confirma/contradiz em ch04 | [C] fatos / [O] redação |
| `doc_jewellery_note` | Nota sobre as joias | biblioteca, ch01 | Exemplares no Museu Miskatonic e na Sociedade de Newburyport; uma tiara grande | Gancho da tiara | sim | `pz01_tilton` | [C] |
| `doc_intro_note` | Bilhete de apresentação | bibliotecária, ch01 | Apresenta o narrador à Srta. Tilton | Chave social | sim | `pz01_tilton` | [C] |
| `doc_tiara_label` | Etiqueta da tiara | Sociedade, ch01 | "Provável procedência das Índias Orientais ou Indochina"; penhorada em 1873 na State Street | Contraste entre prosa e objeto | não | Tiara do padre (ch02), tiara Orne (ch08e) | [C] |
| `doc_marsh_offers` | Carta de oferta dos Marsh | gaveta da Sociedade, ch01 | Oferta de compra a preço alto, recusada | Os Marsh querem o objeto de volta | não | ofertas citadas por Tilton | [I] (ofertas [C], carta [O]) |
| `doc_gilman_register` | Livro de registro | lobby, ch02/ch05 | Poucas entradas; páginas quase vazias; o narrador assina | Isolamento do hotel | não | relato de Casey (ch01) | [O] |
| `doc_sketch_map` | Mapa do rapaz | mercearia, ch03 | Ruas principais, avisos (placas caídas), marcas do rapaz; ponte da Fish em ruínas | Ferramenta de dia e de noite | sim | `pz02`, `pz10`, `sys_map` | [C] |
| `doc_bridge_warning` | Placa da ponte | ponte precária, ch03 | Advertência de travessia por conta e risco | Textura; risco consciente | não | — | [C] existência / [O] texto |
| `doc_order_notice` | Aviso na Ordem | pórtico da Ordem, ch03 (de longe, se se aproximar) | Letreiro desbotado; menção às datas das festas | Calendário ritual | não | Zadok: May-Eve e Hallowe'en | [I] datas [C] |
| `doc_church_tract` | Folheto de credo | escadaria de igreja da orla norte, ch03 | "Transformações maravilhosas" e imortalidade corporal "de certo tipo" na terra | Crenças antes de entendê-las | não | Zadok (III), sonhos (V) | [C] conteúdo / [O] objeto |
| `doc_zadok_record` | Testemunho de Zadok | Diário, ch04 | Paráfrase dos sete movimentos (§7, pz04) como "o que Zadok disse" | Memória do relato; ganha novo sentido em ch07–ch08 | sim (ch05) | `pz12_genealogy` | [C] |
| `doc_evening_paper` | Jornal vespertino | balcão do Gilman, ch05 | Notícias banais de 1927, incluindo apreensão de bebidas [O] | Descanso; normalidade distante | não | batidas de 1928 ("guerra ao álcool") | [C] objeto / [O] conteúdo |
| `doc_raid_clippings` | Recortes de 1928 | Toledo, ch08c | Batidas, prisões, incêndio e dinamitação de casas, rumor do submarino | Consequência da denúncia; ambiguidade moral (D-016) | não | cap. I do conto | [C] fatos / [O] redação |
| `doc_federal_letter` | Carta de agentes | Toledo, ch08c | Agradecimento seco, pedido de sigilo | Silenciamento | não | — | [O] |
| `doc_orne_letters` | Cartas Orne | arquivos de Walter, ch08d | Casamento de Benjamin Orne após a Guerra Civil; noiva educada na França; governanta; guardião desaparecido | Peças do quadro | sim | `item_peabody_notes`, Zadok (filha de Obed "eddicated in Europe") | [C] existência / [O] texto |
| `doc_photo_eliza` | Foto da avó | arquivos de Walter | Rosto de olhar fixo | Reconhecimento | sim | `evt_photo_shift` | [C] |
| `doc_photo_douglas` | Foto do tio Douglas | arquivos de Walter | Mesmo olhar | Reconhecimento; suicídio após viagem à Nova Inglaterra (citado, não mostrado) | sim | Peabody: "um tio esteve aqui" | [C] |
| `doc_miniature` | Miniatura da bisavó | arquivos de Walter | Jovem com "true Marsh eyes" | Elo com Marsh | sim | Peabody | [I] |
| `doc_governess_note` | Advertência da governanta | caixa das joias, ch08e | As peças não devem ser usadas na Nova Inglaterra; seguras na Europa | Arrepio antes da tiara | não | `evt_vault_tiara` | [C] conteúdo / [O] objeto |
| `doc_family_chart` | Quadro genealógico | escrivaninha de Walter, ch08d | Montado pelo jogador (pz12) | Dedução final | sim | todos acima | [C] relações / [O] mecânica |
| `doc_dream_notes` | Notas dos sonhos | Toledo, ch08f | Pórticos submersos, muros ciclópicos, "eu era um com eles" | Mudança de terror para atração | não | `evt_dream_descent` | [C] conteúdo / [O] forma |
| `doc_canton_plan` | Plano de Canton | escrivaninha, ch08g | Buscar o primo Lawrence e ir juntos a Innsmouth e ao recife | Decisão final; tempo futuro | sim (final) | `evt_final_descent` | [C] intenção / [O] texto |

## 6. Diálogo (`sys_dialogue`)

Diálogos por **temas**, não por árvore: o jogador escolhe assuntos disponíveis em qualquer ordem; cada tema tem 1–4 páginas curtas. Temas só aparecem se o narrador tem motivo para perguntar (fato já registrado). A conversa pausa o mundo exceto em ch04, onde a maré e a luz avançam com o relato (não com o tempo real). Sem escolhas morais; sem medidor de relação.

## 7. Mapa (`sys_map`)

* Objeto físico desenhado à mão pelo rapaz (`item_sketch_map`), aberto em tela cheia na resolução nativa.
* **Sem marcador de posição** e sem norte garantido além do que o rapaz desenhou (ele desenhou o rio e o mar, o que basta).
* Carimbos: marcos visitados ganham um traço a lápis do narrador (fato registrado, não posição atual).
* Abrir o mapa pausa o mundo, como todo leitor. À noite, fora de esconderijos, abri-lo exige acender a lanterna, que **continua acesa** ao fechar o mapa até o jogador apagá-la (risco de exposição, 11). Dentro de esconderijos a consulta é segura, como o narrador faz no conto [C].
* **Acessibilidade:** opção "Indicar rua atual" mostra o nome da rua ao entrar em cruzamentos (texto pequeno, sem seta no mapa). Opção "Destacar destino" sublinha no mapa o próximo marco do objetivo.

## 8. Sobrevivência (§12.4 do briefing)

| Elemento | Decisão | Razão |
|---|---|---|
| Furtividade | Sim, só ch07 e pátio de ch06 | [C] |
| Ocultação | Esconderijos com moldura arquitetônica | [C] vestíbulos, mato |
| Gestão de barulho | Sim, por andar e superfícies; quedas abafam | [C] |
| Corrida | Ilimitada, mas ruidosa e visível | Sem barra de fôlego; a limitação é a exposição |
| Recursos escassos | Não | Não há recurso a gastar |
| Lanterna | Sim: ilumina, mas expõe; sem bateria | [C] |
| Obstáculos | Dormentes podres, vão, espinheiros, ardósias | [C] |
| Rotas alternativas | Variantes curtas (09 §4) | — |
| Fome, sede, crafting, XP, armas | **Não** (D-005) | — |

## 9. Puzzles

Cada puzzle segue os 14 campos do briefing. Nenhum usa código numérico sem origem; nenhum bloqueia sem pista (dicas no Diário).

### `pz01_tilton` — Ver a tiara fora de hora

| Campo | Definição |
|---|---|
| 1. Nome | Ver a tiara fora de hora |
| 2. Local | `lvl_newburyport_library` → `lvl_newburyport_society` |
| 3. Contexto | É tarde; a Sociedade está fechada [C] |
| 4. Objetivo | Conseguir que a Srta. Tilton abra a sala |
| 5. Interações | Ler `doc_essex_history`; ler `doc_jewellery_note`; perguntar à bibliotecária; ir à casa de Tilton |
| 6. Pistas | A nota menciona a Sociedade; a bibliotecária oferece o bilhete se o narrador mencionar a tiara |
| 7. Solução | Ler a nota → falar com a bibliotecária sobre a tiara → receber `doc_intro_note` → bater à casa de Tilton (endereço na nota, "nearby") |
| 8. Estados | sem nota → nota lida → bilhete → Tilton convencida |
| 9. Falha | Nenhuma |
| 10. Dicas | Bibliotecária comenta as joias se o jogador demorar; Diário em três níveis |
| 11. Consequência | `evt_tiara_reveal` |
| 12. Técnica | `sys_story_state` com fatos `essex_read`, `jewellery_read`, `intro_note`; diálogo condicionado |
| 13. Tempo | 4–8 min |
| 14. Justificativa | [C] exatamente o percurso do narrador |

### `pz02_orientation` — Ruas sem placas

| Campo | Definição |
|---|---|
| 1 | Orientar-se com ruas sem placas |
| 2 | `lvl_innsmouth` (dia) |
| 3 | "many of the street signs were down" [C] |
| 4 | Visitar os pontos do passeio canônico: refinaria, orla sul, orla norte, igrejas, mansões, corpo de bombeiros |
| 5 | Abrir o mapa; observar landmarks (cúpula, campanários, quedas); placas caídas legíveis no chão |
| 6 | Desenhos do rapaz; landmarks; som das quedas |
| 7 | Não há ordem única; o marco final (`evt_zadok_sighting`) é liberado após ≥ 4 de 6 pontos ou após `evt_bell_three` |
| 8 | Lista de pontos visitados (carimbos no mapa) |
| 9 | Nenhuma |
| 10 | Diário: "Onde ficam as velhas igrejas?" → "Na Main, ao norte do rio" → "Cruzar a ponte da Water" |
| 11 | Desbloqueia o encontro com Zadok; carimbos usados em ch07 |
| 12 | Volumes de visita por ponto; fatos `visit_*` |
| 13 | 25–40 min (inclui exploração) |
| 14 | [C] passeio do cap. II |

### `pz03_whiskey` — Bebida para Zadok

| Campo | Definição |
|---|---|
| 1 | Obter bebida para Zadok |
| 2 | Praça → `lvl_variety_store` |
| 3 | Zadok só fala bêbado; os bombeiros desaprovariam abordagem direta [C] |
| 4 | Comprar uísque e atrair Zadok |
| 5 | Perguntar ao rapaz (tema "bebida") ou observar a loja; comprar; mostrar a garrafa a Zadok |
| 6 | Rapaz: "a place where it was plentiful" [C] → loja da Eliot |
| 7 | Loja de variedades, fundos, comprar → voltar à praça → Zadok sai da Paine → erguer a garrafa |
| 8 | sem garrafa → garrafa → Zadok segue |
| 9 | Abordar Zadok junto aos bombeiros sem garrafa: ele resmunga e se cala (sem bloqueio) |
| 10 | Diário em três níveis |
| 11 | ch04 |
| 12 | Fato `whiskey`; gatilho de rota de Zadok |
| 13 | 3–6 min |
| 14 | [C] |

### `pz04_zadok_pacing` — Dosar a garrafa e escolher temas

| Campo | Definição |
|---|---|
| 1 | Dosar a garrafa e escolher temas |
| 2 | Cais de Zadok |
| 3 | "careful not to overshoot the mark" [C]; Zadok desvia das perguntas nas duas primeiras horas |
| 4 | Ouvir o relato completo antes das 19h15 |
| 5 | Menu com temas desbloqueados (tiara, recife, Marsh, ouro, 1846, igrejas, Ordem) + "Oferecer a garrafa" + "Esperar" |
| 6 | Linguagem corporal de Zadok: fala de jornais (precisa de estímulo), olha o recife (pronto), cochila (excesso) |
| 7 | Espinha fixa de sete movimentos: 1) Obed e o comércio; 2) a ilha e Walakea; 3) o pacto e a mistura; 4) a noite na cúpula; 5) 1846; 6) Juramentos e família Marsh; 7) "o que eles vão fazer" e o shoggoth. A garrafa avança quando ele trava; temas abrem apartes opcionais |
| 8 | Silêncio → falante → exaltado → aterrorizado |
| 9 | Oferecer cedo demais: Zadok cochila 20–40 s e retoma (falha suave, sem perda) |
| 10 | Linguagem corporal é a dica; opção de acessibilidade mostra "Zadok parece esperar" |
| 11 | `doc_zadok_record`; `evt_zadok_shriek` |
| 12 | Diálogo por temas com fases; maré e luz ligados ao movimento atual (`sys_time_of_day`) |
| 13 | 20–30 min |
| 14 | [C] estrutura do cap. III |

### `pz05_bolt` — Transferir o ferrolho

| Campo | Definição |
|---|---|
| 1 | Transferir o ferrolho do armário |
| 2 | `room_428` |
| 3 | A porta do corredor não tem ferrolho; marcas de remoção recente [C] |
| 4 | Instalar o ferrolho do armário na porta |
| 5 | Examinar porta; examinar armário; desaparafusar (2 parafusos); fixar na porta (2 parafusos) |
| 6 | Marcas do mesmo tamanho; o narrador lembra da ferramenta do chaveiro |
| 7 | Sequência acima com `item_keyring_tool` |
| 8 | ferrolho no armário → solto → instalado |
| 9 | Nenhuma |
| 10 | Diário: "Algum outro ferrolho do mesmo tamanho?" |
| 11 | Habilita deitar; ferrolho segura em `evt_key_in_lock` |
| 12 | Fatos `bolt_removed`, `bolt_fitted` |
| 13 | 1–3 min |
| 14 | [C] |

### `pz06_hinges` — Escolher a rota pelas portas

| Campo | Definição |
|---|---|
| 1 | Ler o sentido das portas e escolher a rota norte |
| 2 | `room_428` |
| 3 | Sem escada de incêndio; telhados só a duas portas, ao norte ou ao sul [C] |
| 4 | Decidir qual porta lateral forçar |
| 5 | Examinar janelas; abrir mapa; examinar dobradiças das portas laterais; tentar forçar |
| 6 | A porta sul abre na direção do quarto (batente e dobradiças visíveis); a norte abre para fora |
| 7 | Bloquear a sul com a cama; preparar-se para arrombar a norte |
| 8 | não decidido → sul descartada → norte escolhida |
| 9 | Perder tempo tentando a sul (o cerco avança pelo tempo máximo de S1) |
| 10 | Diário: "Para que lado abre cada porta?" → "Uma porta que abre para mim não cede ao ombro" → "A do norte abre para longe" |
| 11 | Início de S1/S3 |
| 12 | Estado de porta `opens_toward_player`; interação de força retorna feedback distinto |
| 13 | 1–3 min |
| 14 | [C] raciocínio do narrador |

### `pz07_barricade` — Barricadas

| Campo | Definição |
|---|---|
| 1 | Barricadas com cama, cômoda e lavatório |
| 2 | `room_428`, `room_n2` |
| 3 | Portas fracas contra um grupo organizado [C] |
| 4 | Ganhar tempo até a janela |
| 5 | Empurrar móveis marcados até as portas |
| 6 | Encaixe visível; som do móvel contra a porta |
| 7 | 428: cama → porta sul, cômoda → corredor; n2: cama e cômoda nas portas de ligação, lavatório no corredor |
| 8 | Cada barricada aumenta o prazo de ruptura (08 §5) |
| 9 | Sem barricadas em n2, a ruptura chega antes da descida (captura, `cp06_window`) |
| 10 | Narrador: "Preciso de tempo" ao entrar em n2 |
| 11 | Prazo T4 |
| 12 | Móveis com pontos de encaixe; `SiegeDirector` lê o número de barricadas |
| 13 | 0,5–2 min |
| 14 | [C] |

### `pz08_drapery` — Escada de cortina

| Campo | Definição |
|---|---|
| 1 | Escada improvisada com cortina e argolas |
| 2 | Janela sul de `room_n2` |
| 3 | O salto ao telhado íngreme é "desperately hazardous" [C] |
| 4 | Descer em segurança |
| 5 | Examinar janela; derrubar cortinas; prender argolas no gancho da veneziana; lançar; descer |
| 6 | Cortinas pesadas com argolas de latão visíveis; gancho saliente da veneziana |
| 7 | Sequência acima |
| 8 | cortina pendurada → no chão → presa → lançada |
| 9 | Saltar sem corda → queda (`cp06_window`) |
| 10 | Narrador antes do salto; Diário |
| 11 | `cp06_roof` |
| 12 | Três interações em sequência com estado salvo apenas no checkpoint |
| 13 | 0,5–1 min |
| 14 | [C] |

### `pz09_courtyard` — Sair do pátio

| Campo | Definição |
|---|---|
| 1 | Sair do pátio pelo prédio da Washington |
| 2 | Pátio e prédio do lado da Washington |
| 3 | A primeira porta da rua está emperrada; a multidão sai do Gilman [C] |
| 4 | Chegar à Washington sem ser visto |
| 5 | Entrar por portas do lado da Washington; abrir venezianas; fechar atrás de si |
| 6 | Janelas sem caixilho com venezianas visíveis; luar na fresta |
| 7 | Porta emperrada → voltar → outra porta → sala vazia → veneziana → rua |
| 8 | pátio → corredor → emperrado → sala → rua |
| 9 | Ficar na luz das lanternas por tempo suficiente → captura (`cp06_courtyard`) |
| 10 | Diário: "Outra saída para a rua?" |
| 11 | ch07 |
| 12 | Volumes de luz das lanternas como cones de percepção (11) |
| 13 | 1–3 min |
| 14 | [C] |

### `pz10_night_route` — Rota até a estação

| Campo | Definição |
|---|---|
| 1 | Rota pelo mapa até a estação |
| 2 | `dist_south_residential`, `dist_bank_station` |
| 3 | Estradas vigiadas; resta a ferrovia [C] |
| 4 | Chegar à estação pela sequência Babson → Lafayette → Bates → Adams → Bank |
| 5 | Consultar mapa em esconderijo; escolher variantes (09 §4); andar arrastado nas travessias |
| 6 | Mapa; vista da janela do 428 (estação e trilhos); som das quedas ao norte |
| 7 | Seguir os pontos canônicos; variantes são opcionais |
| 8 | Cinco segmentos com checkpoints |
| 9 | Detecção e captura (09 §7) |
| 10 | Diário em três níveis por segmento; opção "Destacar destino" |
| 11 | Ponte coberta |
| 12 | `PatrolDirector`, gatilhos, volumes de luar |
| 13 | 15–25 min |
| 14 | [C] |

### `pz11_bridge_gap` — Vão na ponte coberta

| Campo | Definição |
|---|---|
| 1 | Vão na ponte coberta |
| 2 | Meio da ponte coberta |
| 3 | "a perilous gap in the ties" [C] |
| 4 | Atravessar |
| 5 | Lanterna; correr; pular contextual na borda marcada pelo último dormente íntegro |
| 6 | Lanterna mostra o vão e o outro lado; morcegos antes, como aviso |
| 7 | Pular a partir da zona válida (generosa, 1,5 m) |
| 8 | antes → no ar → do outro lado |
| 9 | Pular fora da zona ou cair no vão → `cp07_bridge` |
| 10 | Prompt de pulo aparece só na zona; modo assistido amplia a zona |
| 11 | Trilhos além da ponte |
| 12 | Volume de pulo contextual; arco fixo |
| 13 | 0,5–1 min |
| 14 | [C] |

### `pz12_genealogy` — Reconstruir a ascendência

| Campo | Definição |
|---|---|
| 1 | Reconstruir a ascendência |
| 2 | `lvl_cleveland_house` (escritório de Walter) |
| 3 | Notas de Arkham, cartas, fotos e miniaturas [C] |
| 4 | Montar o quadro: narrador → mãe → Eliza Orne (1867) → Benjamin Orne + noiva "Marsh de New Hampshire" (pais Enoch e Lydia Meserve Marsh, não localizáveis) → ? |
| 5 | Arrastar cartões de fatos e retratos para posições do quadro; ligar fato a fato |
| 6 | `item_peabody_notes`, `doc_orne_letters`, fotos, miniatura, `doc_zadok_record` (filha de Obed casada "by a trick" com um homem de Arkham; "educated in Europe"; "Marsh eyes") |
| 7 | O quadro aceita qualquer ordem; completa-se ao preencher as posições conhecidas. A última posição ("?") não é preenchida pelo jogo: o jogador pode ligar o cartão "filha de Obed (Zadok)" a ela; o jogo registra como **pergunta do narrador**, não como fato — "Seria Obed Marsh meu tataravô?" [C] |
| 8 | Parcial → completo → ligação sugerida (opcional) |
| 9 | Nenhuma; posições erradas simplesmente não encaixam, com comentário do narrador |
| 10 | Diário em três níveis por posição |
| 11 | Walter mostra as joias (ch08e) |
| 12 | `doc_family_chart` com slots e cartões; fatos `chart_*` |
| 13 | 6–12 min |
| 14 | [C] relações e dúvida do cap. V; [O] mecânica |
