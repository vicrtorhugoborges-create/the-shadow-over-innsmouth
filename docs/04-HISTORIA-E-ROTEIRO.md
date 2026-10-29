# 04 — História e roteiro

Roteiro cena a cena. Fichas técnicas de cada capítulo (20 campos), eventos e ritmo estão em `05-CAPITULOS-E-PROGRESSAO.md`; geografia em `06`; hotel em `08`; fuga em `09`; elenco em `10`; puzzles e textos completos de documentos em `12`; áudio em `15`.

Convenção: cada cena tem rótulo local (`1.3`) usado apenas neste documento. Falas são **redação original em PT-BR [O]** de conteúdo indicado (**[C]** quando o conteúdo é do conto, **[O]** quando também é invenção). Citações do conto ficam em inglês e curtas.

## 1. Guia de estilo de texto

* **Narrador (Diário e notas de exame):** primeira pessoa, pretérito, frases curtas, vocabulário de antiquário educado dos anos 1920, até 25 palavras por nota de exame. Ele **racionaliza** ("deve ser doença", "decerto um tesouro pirata"); o jogador percebe mais do que ele admite.
* **Diálogos:** no máximo 3 linhas por página de fala; nenhuma conversa obrigatória passa de 3 minutos de leitura, exceto Zadok.
* **Zadok:** registro popular arcaico e oral ("vosmecê", "home", "dês que", "o Cap'n"), elisões, repetições, "hein?"; **sem** imitação de sotaque regional brasileiro reconhecível e sem grafia que ridicularize.
* **Termos proibidos em texto jogável:** termos raciais e étnicos depreciativos presentes no original, "degenerado(a)" aplicado a pessoas, "raça" aplicada aos habitantes, "louco/hospício" aplicado a Lawrence. Ver `02` §6.
* **Profundos:** nenhum texto os chama de "Profundos" antes de ch08f; antes disso: "as coisas do mar", "os que nadam", "eles".
* **Hora:** cada mudança de período mostra hora e local discretos no canto ("Innsmouth — 15 de julho, 15h"), nunca durante perigo.

---

## 2. `ch00_frame` — O manuscrito

**Local:** `lvl_toledo_room`, noite, inverno de 1930–31 ou depois [I].

* **0.1 Escrivaninha.** Lâmpada de mesa, chuva na vidraça, papel e caneta. Ao fundo, um espelho coberto por um pano [O]; uma gaveta fechada [O] (contém a automática, só revelada em ch08f). O jogador pode olhar ao redor, mas só interage com o manuscrito.
* **0.2 Primeira página.** O jogador "assina" a primeira linha (interação de escrita). Texto exibido, em redação nova [O] de conteúdo [C] do capítulo I:

> "No inverno de 1927 para 1928, agentes do governo fizeram uma investigação secreta em Innsmouth. Os jornais falaram em contrabando de bebida. Fui eu quem fugiu daquela cidade na madrugada de 16 de julho de 1927. Escrever me ajuda a confiar nos meus próprios sentidos — e a decidir um certo passo que tenho diante de mim."

* **0.3 Transição.** A câmera desce para o papel; a tinta se espalha como água e dissolve-se na bilheteria de Newburyport. `doc_manuscript` entra no Diário.

Justificativa: o conto é uma confissão escrita; a moldura prepara o fecho em `ch08g_final` sem antecipar o conteúdo.

---

## 3. `ch01_journey` — A Viagem

**14 de julho de 1927, fim de tarde → 15 de julho, 10h. Newburyport.**

* **1.1 Bilheteria (`lvl_newburyport_station`).** O jogador pergunta o preço até Arkham; o trem é caro. O bilheteiro sugere o ônibus [C]. Diálogo com três tópicos opcionais (o ônibus; a cidade; o hotel) e um obrigatório (o ônibus). `evt_agent_warning`.
  * Bilheteiro [O de C]: "Tem aquele ônibus velho, se o senhor não for exigente. Passa por Innsmouth — e o povo daqui não gosta dele. Sai da praça, na frente da Hammond's, às dez e às sete."
  * Sobre a cidade [O de C]: "Já foi quase uma cidade grande. Hoje tem mais casa vazia que gente. Contam histórias de um tal capitão Marsh e de um recife lá fora... Eu sou de Vermont, essas coisas não me pegam."
  * Sobre o hotel [O de C]: "Um inspetor de fábricas, Casey, dormiu lá uma vez. Disse que ouviu vozes nos quartos vazios a noite inteira. Não tirou a roupa."
  * O preconceito dele é mantido como opinião (ver 02 §6.1): "O pessoal daqui detesta aquela gente. Medo, mais que tudo." `doc_bus_timetable` entra nos Bolsos/Diário.
* **1.2 Market Square ao entardecer (`lvl_newburyport_square`, variação noturna).** Opcional [C]: lojistas, bombeiros e o lunch room não querem falar. Três falas curtas de recusa [O]. Ensina que perguntar sobre Innsmouth produz silêncio.
* **1.3 Biblioteca (`lvl_newburyport_library`).** O jogador consulta estantes. Puzzle leve `pz01_tilton`: encontrar nas histórias do condado (`doc_essex_history`) a menção à joia (`doc_jewellery_note`); pedir à bibliotecária. Ela escreve `doc_intro_note` para a Srta. Tilton, "que mora aqui perto" [C].
  * Bibliotecária [O]: "Innsmouth é um caso exagerado de decadência, só isso. Mas se faz questão de ver a peça, a Srta. Tilton talvez abra a Sociedade. Não é tão tarde."
* **1.4 Rua e Sociedade Histórica (`lvl_newburyport_society`).** Caminhada curta de noite até a casa de Tilton (endereço no bilhete) e entrada no prédio fechado. A sala está escura; só a vitrine da tiara iluminada por luz elétrica [C]. **`evt_tiara_reveal`:** o jogador se aproxima livremente; ao examinar a peça (modo de inspeção com rotação), os relevos de "fish-frogs" ficam nítidos; um som grave e um instante de dessaturação [PSI] — a pseudo-memória.
  * Nota de exame do narrador [O de C]: "Nenhuma tradição que conheço. Como se o ourives fosse de outro planeta. E essas criaturas... por que me parecem lembradas?"
  * Tilton [O de C]: conta o penhor de 1873 na State Street, a etiqueta tentativa (`doc_tiara_label`), a teoria do tesouro pirata, as ofertas insistentes dos Marsh (`doc_marsh_offers`, R) e a Ordem Esotérica de Dagon na velha Loja Maçônica da New Church Green.
  * Tilton [O de C]: "Um culto pagão trazido do Oriente quando a pesca minguou. A pesca voltou, e o culto ficou. Engoliu todas as igrejas."
* **1.5 Y.M.C.A.** Corte rápido: o quarto pequeno, o recepcionista desencoraja [C]; o narrador não dorme. Transição por insônia (texto do Diário).
* **1.6 Manhã, diante da Hammond's (`cp01_bus_stop`).** O jogador espera com a valise. `evt_square_avoidance`: os ociosos migram para o Ideal Lunch e rua acima. O ônibus cinzento chega pela State, placa "Arkham-Innsmouth-Newb'port" [C]. Três passageiros descem e se afastam em silêncio. Sargent entra na drogaria, volta.
* **1.7 Embarque.** O jogador entrega um dólar e diz "Innsmouth" (única fala dele em voz). **`evt_sargent_look`:** Sargent o encara um segundo e devolve 40 centavos sem falar [C]. O jogador escolhe assento — o roteiro favorece o assento atrás, do mesmo lado, voltado para a costa [C]; qualquer assento funciona.

**Fim do capítulo:** o ônibus parte; título "II — A Cidade Esquecida".

---

## 4. `ch02_forgotten_town` — A Cidade Esquecida

**15 de julho, 10h–11h30.**

* **2.1 A viagem (`lvl_bus`, `cp02_bus_ride`).** Sequência sentada, câmera livre com limites, 4–6 min. State → High Street (casarões) → Lower Green → Parker River → costa de areia, capim e arbustos; Plum Island; postes com só dois fios; pontes de madeira sobre riachos de maré; tocos e alicerces na areia [C]. O jogador pode observar Sargent: nuca quase calva, mãos cinza-azuladas (exame à distância com nota do narrador). Nota [O de C]: "Por que me causa tanta aversão? Não sei dizer de onde vem."
* **2.2 A crista (`evt_crest_panorama`).** O ônibus sobe; o céu ocupa a janela. Pausa da câmera em plano amplo controlado pelo jogador: vale, Manuxet, falésias até Kingsport Head no horizonte, três campanários sem relógio, telhados afundados, ferrovia abandonada, quebra-mar, cais apodrecidos, **Devil Reef** [C]. Ao mirar o recife, o som do vento cai e um tom quase musical aparece por dois segundos — o "aceno" [C, representação O].
* **2.3 Periferia.** Fazendas abandonadas, casas com trapos, conchas e peixes mortos nos quintais, pessoas cavando mariscos [C]. Moradores em `look_1`–`look_2` olham; nenhum faz gesto hostil.
* **2.4 New Church Green (`evt_dagon_hall_pass`).** O ônibus entra no centro: casas mais conservadas, o "rico remanescente do passado" que distrai o antiquário [C]. Concurso radial, igrejas em dois lados, restos de gramado circular, salão de colunas com letreiro preto e dourado "Esoteric Order of Dagon" [C].
* **2.5 O sino e o porão (`evt_basement_priest`).** Sino rachado bate onze [C]; a câmera é puxada suavemente para o lado do motorista (opção de acessibilidade desliga o puxão). A porta do porão da igreja gótica está aberta; uma figura de manto e tiara cruza o retângulo negro em 1,2 s [C]. Pseudo-memória [PSI]: o mesmo motivo sonoro da tiara. Nota [O de C]: "Era só o pastor, com vestes do culto. Por que senti aquele frio?"
* **2.6 Ponte e praça.** Ponte de ferro sobre o desfiladeiro; ruído das quedas (`evt_falls_roar`); fábricas no barranco [C]. Praça semicircular; o ônibus para diante do Gilman House [C]. `cp02_square`.
* **2.7 Lobby do Gilman.** O jogador entrega a valise ao funcionário idoso, que não tem "a aparência" [C]. Fala curta [O]: "Deixe aqui. O ônibus de Arkham sai às oito, da praça." `doc_gilman_register` (O) pode ser lido: entre nomes antigos, a assinatura de um tal Casey (R) [O].
* **2.8 A praça (livre).** Primeira exploração. Uma dúzia de lojas, a drogaria, o atacadista de peixe, o escritório da Marsh Refining Co. no extremo leste [C], uns dez moradores, carros e caminhões. Vista leste para o porto e os três campanários; o campanário branco da refinaria do outro lado do rio [C]. Objetivo implícito do Diário: "Perguntar a alguém que não seja daqui."

**Fim:** entrar na mercearia First National encerra o capítulo.

---

## 5. `ch03_secrets` — Os Segredos de Innsmouth

**15 de julho, 11h30–16h.**

* **3.1 A mercearia (`lvl_grocery`).** O rapaz (~17 anos, de Arkham) fala com alívio [C]. Diálogo por tópicos (todos [O de C]): as ruas (Federal; residenciais a oeste; cortiços e igrejas georgianas a leste, Main Street); lugares a evitar (refinaria, igrejas em uso, Ordem de Dagon); as igrejas e as festas de 30 de abril e 31 de outubro; os moradores (olhos que nunca se fecham, natação até o recife, velhos que somem); os Marsh (Old Man Marsh no carro fechado, a filha com joias); as quatro famílias; Zadok Allen; o uísque ("tem muito por aí, nos fundos de uma loja na Eliot").
  * Rapaz [O de C]: "A gente quase nunca vê os velhos. Os mais velhos que aparecem são os que estão mais... diferentes. Eu fico pensando se não é uma doença que piora com a idade."
  * Rapaz [O de C]: "As placas das ruas caíram quase todas. Espere — vou desenhar para o senhor."
  * Entrega `item_sketch_map` / `doc_sketch_map` (`cp03_grocery`). O jogador compra bolachas (`item_crackers`) [C].
  * Rapaz sobre Zadok [O de C]: "Ninguém acredita nele. Mas o povo daqui não gosta que ele beba e converse com estranhos. Não é seguro ser visto perguntando."
* **3.2 O passeio (`pz02_orientation`, `cp03_tour`).** Exploração livre na ordem sugerida pelo texto, mas não imposta. O Diário lista "Lugares do mapa" e marca os visitados. Cada distrito tem um **momento de assinatura**:
  * **Desfiladeiro e refinaria (`dist_gorge`):** atravessar a ponte rumo às quedas inferiores; a refinaria estranhamente silenciosa; a Old Square, antigo centro [C]. R: `evt_marsh_car` — o carro fechado e cortinado chega à refinaria [C rumor, O cena].
  * **Orla sul (`dist_south_waterfront`):** pela ponte da Main, região de deserção total; campanário decapitado; casas inclinadas; Fish Street com armazéns sólidos; Water Street com vãos onde havia cais; só se ouve a maré e as quedas [C]. Nota [O de C]: "O terror de uma casa vazia cresce em progressão geométrica quando as casas formam uma cidade."
  * **Norte do rio (`dist_north`):** volta pela ponte precária da Water Street (a da Fish está em ruínas, segundo o mapa) [C]; casas de salga ativas, chaminés, vultos arrastados; `evt_boarded_sounds` — rangidos, correrias e ruídos roucos mais fortes atrás das fachadas tapadas [C]; as duas igrejas arruinadas de Main e Church [C]. O narrador evita a New Church Green [C]; o jogador também pode evitá-la (o mapa e o Diário sugerem), mas se insistir, um grupo de três `res_order_member` para de conversar e o observa até ele recuar [O]. Gesto humano obrigatório (02 §6.3): uma mulher em `look_2` puxa uma criança para dentro e fecha a veneziana [O].
  * **Ruas patrícias (`dist_patrician`):** Martin → Broad, Washington, Lafayette, Adams; casarões sob olmos; fileira de quatro ou cinco bem cuidados; a mansão Marsh com parterres até a Lafayette; janelas de terceiro andar e sótãos fechadas; nenhum gato ou cachorro [C]. `evt_window_watchers`. `evt_bell_three`: o sino das 15h vem da igreja do porão [C].
  * **Rumo ao sul:** ruínas de fábrica, vista da velha estação e da ponte ferroviária coberta subindo o desfiladeiro à direita [C] — a primeira apresentação da rota de ch07. Ponte com placa de advertência (`doc_bridge_warning`); travessia rangente [C]. Rostos frios e curiosos na margem sul.
* **3.3 Corpo de bombeiros (`evt_zadok_sighting`).** Na Paine, à esquerda: o velho de barba, olhos lacrimejantes e trapos sentado com dois bombeiros [C]. O narrador muda de plano (texto do Diário [O de C]): "Os mitos mais loucos costumam ser alegorias de uma verdade. E ele viu tudo." Aproximar-se diretamente faz os bombeiros encararem e Zadok calar-se — o jogo sugere preparar-se antes [O].
* **3.4 O uísque (`pz03_whiskey`, `lvl_variety_store`).** Nos fundos da loja de variedades na Eliot, o vendedor com um toque da "aparência", "civil a seu modo", vende a garrafa de um quarto de galão (caro) [C]. Fala [O]: "Os compradores de ouro também gostam. Leve embrulhado." `cp03_whiskey`.
* **3.5 Atrair Zadok.** Ao voltar à praça, Zadok sai da Paine pela esquina do Gilman [C]. O jogador mostra a garrafa (interação "mostrar item") e segue pela Waite rumo ao sul; Zadok segue arrastando os pés; "Hey, Mister!" chiado atrás [C]. Fim do capítulo ao alcançar a Main Street.

---

## 6. `ch04_zadok` — O Testemunho de Zadok Allen

**15 de julho, ~16h–19h15. Caminhada pela Water Street sul até o cais de terra e alvenaria protegido por um armazém em ruínas ao norte [C].**

### 6.1 Estrutura e mecânica

* **Caminhada (2–3 min):** o jogador conduz; Zadok bebe e fala de assuntos do dia, jornais, filosofia de aldeia [C]. Ao chegar à abertura gramada entre muros de tijolo, o jogador escolhe onde sentar entre as pedras musgosas (`cp04_wharf`). O roteiro favorece a posição canônica (narrador de costas para o mar, Zadok de frente), mas o jogador pode virar a cabeça a qualquer momento.
* **Dosagem (`pz04_zadok_pacing`):** quando Zadok trava (fica em silêncio, olha por cima do ombro, resmunga), o jogador pode **oferecer a garrafa**. Oferecer quando ele não travou provoca uma recusa leve ou um gole sem avanço; oferecer demais em sequência (3 vezes sem travamento) o deixa sonolento por 20–30 s de jogo — ele cochila e retoma sozinho, sem perda (falha suave). A garrafa tem cargas suficientes para todo o testemunho; o texto canônico — ele esvazia a garrafa ao fim de M4 — é respeitado pelo roteiro, que torna os últimos movimentos independentes da garrafa (Zadok passa a falar sozinho).
* **Temas:** em cada pausa entre movimentos, o jogador pode **perguntar** sobre um tema desbloqueado por pistas de ch01–ch03. Temas são apartes curtos (30–60 s) que enriquecem o relato e se encaixam antes do movimento seguinte; não alteram a ordem dos movimentos nem o final. IDs propostos:

| Tema (ID proposto) | Pista que desbloqueia | Aparte (conteúdo) |
|---|---|---|
| `topic_tiara` | `evt_tiara_reveal` ou ver o padre | As joias que os marinheiros vendiam escondido; "mais parecidas com gente" as que Obed deixava as mulheres usarem [C] |
| `topic_reef` | `evt_crest_panorama` | Corridas de natação até o recife; o fundo que desce "como um penhasco" [C] |
| `topic_refinery_gold` | Visitar `dist_gorge` | O moinho de pisoar de Waite; o ouro que não podia ser vendido inteiro [C] |
| `topic_churches` | `evt_basement_priest` ou `doc_church_tract` | Os parsons expulsos; os novos padres ex-marinheiros com vestes e ouro [C] |
| `topic_marsh_house` | Ver a mansão em `dist_patrician` | A mãe de Barnabas "nunca vista ao ar livre"; a esposa de Ipswich [C] |
| `topic_1846` | `doc_essex_history` | "Peste" foi o nome que deram de fora [C] |
| `topic_look` | Conversa sobre moradores com o rapaz | "Vão pra água quando estão prontos; às vezes descem antes, de experiência" [C] |

Cada tema escutado gera uma entrada no Diário com fonte "Zadok Allen" e marca de dúvida do narrador.

### 6.2 Os sete movimentos

Falas abaixo são **redação nova [O]** de conteúdo **[C]**, já no registro definido em §1. Cada movimento tem 2–4 min.

**M1 — Conversa do dia e travamento.** Zadok fala de jornais, do tempo, de política; desvia de qualquer pergunta sobre o passado [C]. O jogador come as bolachas (opcional). Ao fim da segunda "hora" (elipse por mudança de luz), Zadok olha o recife e muda (`evt_zadok_reef_gaze`).
> "Foi ali que tudo começou — naquele lugar maldito onde a água funda começa. Porta do inferno. Desce até um fundo que nenhum prumo alcança. Foi o Cap'n Obed que fez a coisa."

**M2 — Obed e as ilhas.** Crise do comércio depois de 1812; os navios *Columby*, *Hetty* e *Sumatry Queen*; o desprezo de Obed pela fé resignada; Matt Eliot, o imediato, contrário a tudo; uma ilha a leste do Taiti com ruínas e uma ilhota vulcânica com entalhes de monstros [C]. A câmera não sai do cais; Zadok gesticula para o horizonte. Nota do Diário: "Zadok repete o que Obed e Matt contaram. Ele mesmo nunca esteve lá." (D-014)
> "O Cap'n dizia que a gente era um bando de ovelha rezando pra um céu que não ajudava. Que tinha povo lá pras Índias com deuses que davam o que se precisava de verdade."

**M3 — Walakea e o pacto.** O chefe Walakea; peixe em abundância; os jovens que somem; as coisas do mar que vieram de cidades no fundo; sacrifícios na véspera de maio e no Dia das Bruxas; filhos que nascem parecendo gente e depois "voltam pra água"; quem vai pra água não morre [C]. **Sem imagens das ilhas**; apenas a maré, o som e o rosto de Zadok. A frase-chave fica como legenda e também no Diário:
> "E essa é a parte que importa, moço: os que viram bicho do mar e vão pra água nunca morrem."

**M4 — O talismã, a refinaria e o extermínio.** O objeto de chumbo que "chama as coisas" de qualquer ninho; o ouro barato; a refinaria no velho moinho de Waite; por volta de 1838 o povo da ilha é exterminado por vizinhos que tinham os sinais dos "Antigos"; Obed arruinado incita a cidade [C]. Zadok esvazia a garrafa, lambe o gargalo, guarda-a no bolso [C]; murmura nomes bíblicos. A partir daqui a garrafa não é mais necessária.

**M5 — O recife e a cúpula.** "Por que o Obed e uns vinte remavam pro recife de noite?" Os objetos pesados atirados além do recife; Zadok menino na cúpula da casa com o óculo do pai vendo formas que mergulham; desaparecidos — Hiram Gilman, Nick Pierce, Luelly Waite, Adoniram Southwick, Henry Garrison; a prosperidade, o ramal ferroviário, a fundação da Ordem comprando a Loja Maçônica; Matt Eliot "some" [C]. **Evento ambiental [O]:** ao nomear os desaparecidos, a maré vira (`evt_tide_turn`) e a luz fica dourada. Ao olhar para o recife nesse momento, o jogador vê (sempre) apenas o mar.

**M6 — 1846.** O selectman Mowry; o grupo que segue Obed; tiros entre botes; Obed e 32 presos; duas semanas sem oferenda; a noite das hordas subindo o Manuxet; mortos na Old Square, Town Square e New Church Green; o pai de Zadok sai pela janela da cozinha com o mosquete e nunca volta; "chamaram de peste"; os três Juramentos — Zadok fez o primeiro e o segundo, recusou o terceiro [C]. Zadok chora [C]. A interface não oferece perguntas durante M6.
> "Eles sacudiram a nossa porta, mas o pai não abriu... depois saiu pela janela da cozinha com o mosquete. Nunca mais soube dele."

**M7 — Os Marsh, o shoggoth e o grito.** A segunda esposa de Obed, nunca vista; três filhos, dois somem, uma menina "como qualquer um", educada na Europa, casada "por um truque" com um homem de Arkham; Barnabas, neto de Obed, quase mudado, "vai pra água logo"; o horror não é o que fizeram, mas o que vão fazer; as casas ao norte do rio entre a Water e a Main "cheias deles e do que trouxeram"; "já ouviu falar de um shoggoth?" [C]. A maré insiste; Zadok olha por cima do ombro, grita para fortalecer a coragem e acusa o narrador: "não fique me olhando com esses olhos" [C].
> No início de M7, quando Zadok olha o narrador de perto [C — a fala está em M2 no conto e é **deslocada para M7** para aproximar as duas pistas genealógicas; deslocamento registrado como O]: "E vosmecê... tem uns olhos de quem lê os outros, igual o Obed tinha."

**Grito (`evt_zadok_shriek`).** Zadok fixa algo além do ombro do narrador e grita [C]. A mão dele prende o ombro (câmera travada 0,8 s, tremor só se ativado). O jogador vira: **apenas a maré e um conjunto de ondulações mais localizado que a linha de arrebentação** [C]. A ondulação é um efeito de água simples, sem silhueta, e some em 3 s. Zadok sussurra:
> "Sai daqui! Eles viram a gente — corre, sai da cidade, não espera nada — eles sabem agora!"

Outra onda bate; segundo grito; Zadok corre para o interior, contorna o armazém para o norte [C]. O jogador pode segui-lo até a Water Street: **não há sinal dele** [C]. Relógio: 19h15 [C]. Fim do capítulo.

### 6.3 Pistas do M7 para ch08 (registro neutro)

Duas entradas do Diário, criadas sem destaque nem música, no meio de outras notas de M7, com IDs propostos:

* `jrn_obed_daughter` — "Segundo Zadok, uma filha de Obed, educada na Europa, casou-se 'por um truque' com um homem de Arkham."
* `jrn_obed_eyes` — "Zadok disse que eu tenho 'olhos de quem lê os outros', como os de Obed. Bobagem de bêbado."

Elas reaparecem como fichas arrastáveis no quadro de `pz12_genealogy`.

---

## 7. `ch05_trap` — A Armadilha

**15 de julho, 19h15 → 16 de julho, ~1h30. Detalhe espacial em `08-GILMAN-HOUSE.md`.**

* **5.1 Retorno (`cp05_return`).** Luz dourada do fim da tarde dá às ruínas uma beleza "mística" [C]. O jogador escolhe rota pelo mapa; o roteiro favorece a Marsh Street em vez da State [C]. Perto da Fall Street, grupos de cochichadores [C].
* **5.2 Porta do Gilman (`evt_gilman_crowd`).** Quase todos os ociosos estão reunidos à porta; olhos sem piscar acompanham o jogador; ninguém fala com ele [C]. Ele retira a valise.
* **5.3 O ônibus (`evt_bus_breakdown`).** Chega cedo, com os mesmos três passageiros da manhã; um morador murmura algo a Sargent; troca de palavras guturais numa língua que "não é inglês" [C]. O jogador embarca e se senta; Sargent volta:
> Sargent [O de C]: "Motor deu problema. Não vai até Arkham. Não tem conserto hoje. Nem outro carro. Vai ter que dormir no Gilman."
* **5.4 Registro.** O funcionário noturno oferece o 428, "no penúltimo andar, grande, sem água corrente, um dólar" [C]. O jogador assina `doc_gilman_register`. Sobe três lances rangentes por corredores sem vida [C].
* **5.5 Quarto 428 (`cp05_room`).** Duas janelas sobre o pátio e telhados a oeste, pântano ao fundo; móveis pobres; banheiro no fim do corredor com pia de mármore e banheira de lata [C]. Ainda é dia.
* **5.6 Jantar (`lvl_restaurant`).** A mercearia está fechada; o restaurante de balcão, com os dois atendentes [C]. Sopa de legumes com bolachas; alívio por ser comida enlatada [C]. Compra do jornal e de uma revista na banca do funcionário (`doc_evening_paper`) [C].
* **5.7 Crepúsculo no quarto.** Uma lâmpada fraca sobre a cama de ferro [C]. O jogador pode ler o jornal (notícias banais [O]) enquanto a luz cai. **`evt_missing_bolt`:** ao examinar a porta, marcas de um ferrolho recém-removido [C]. Puzzle `pz05_bolt` (12): o ferrolho do armário tem o mesmo tamanho; a chave de fenda do chaveiro resolve [C]. As duas portas laterais de ligação já têm ferrolhos: o jogador os corre [C].
* **5.8 Espera.** O narrador não se despe: tira casaco, colarinho e sapatos [C]; põe a lanterna no bolso da calça (`item_flashlight` entra nos Bolsos) [C]. Tentativa de ler: o texto do jornal se desfaz em frases repetidas [PSI, O]. `evt_corridor_creaks` — rangidos furtivos, sem vozes [C]. Nota [O de C]: "Seria uma dessas estalagens onde matam viajantes? Não pareço rico. Ou meus mapas despertaram atenção?" O jogador apaga a luz e deita (ação explícita, avança o tempo).
* **5.9 A chave (`evt_key_in_lock`).** No escuro, depois de novo rangido: a fechadura da porta do corredor é testada com uma chave — cautelosa, furtiva [C]. A tela escurece a quase preto; legendas e ícone de direção do som (acessibilidade) funcionam. `evt_connecting_tries`: o quarto ao norte é aberto com chave-mestra, a porta de ligação é testada, o ferrolho segura; o mesmo ao sul; os passos descem a escada [C]. Fim do capítulo: o narrador decide fugir — "não um perigo a enfrentar, só a fugir" [C].

---

## 8. `ch06_gilman_escape` — Fuga do Gilman House

Cronologia completa, plantas, cronômetros e falhas em `08-GILMAN-HOUSE.md`. Resumo de roteiro:

* **6.1 Luz cortada (`evt_power_cut`).** O interruptor não funciona [C]. Com a lanterna, o jogador enche os bolsos (ação única "preparar-se", sem a valise) e põe o chapéu [C]. Rangidos abafados no andar de baixo; "vozes" que se revelam latidos roucos e coaxos de sílabas soltas [C].
* **6.2 Plano (`pz06_hinges`).** Pela janela: queda de três andares para o pátio, sem escada de incêndio; blocos de tijolo encostados ao hotel à direita e à esquerda, com telhados inclinados alcançáveis a partir de um quarto **dois** depois do seu [C]. O jogador examina as portas: a do sul abre para dentro do 428 → não serve; a do norte abre para longe → rota [C]. Empurra a cômoda contra a porta do corredor e a cama contra a porta sul (`pz07_barricade`, preparação).
* **6.3 Batidas (`evt_knocking`, `cp06_knock`).** Luz trêmula pelo bandeirote, corredor gemendo sob peso, batida firme, depois contínua [C]. Começa o cerco.
* **6.4 Arrombar.** O jogador soca com o ombro a porta norte; o estrondo final é ouvido; as batidas viram golpes e chaves soam nos quartos vizinhos (`evt_passkeys`) [C].
* **6.5 `room_n1`.** Correr o ferrolho da porta do corredor antes que a chave gire [C]. Ouve-se a chave no `room_n2` — desespero. Pegadas no pó deixadas pelo intruso [C]. A porta de ligação seguinte está **entreaberta** [C].
* **6.6 `room_n2`.** O jogador empurra com joelho e ombro a porta do corredor que se abre, fecha-a e corre o ferrolho [C]. Fecha e tranca as duas portas de ligação e as barrica (cama, cômoda), põe o lavatório diante da porta do corredor [C] (`cp06_window`). Horror auditivo: nenhum perseguidor emite som humano inteligível, só arquejos, grunhidos, latidos abafados [C]. `evt_ram`: aríete contra a porta de ligação.
* **6.7 Cortina (`pz08_drapery`).** Janela mais ao sul; cortinas de veludo com argolas; o jogador as arranca, engancha duas argolas no gancho da veneziana e lança o tecido até o telhado [C]. Desce. Atrás dele, a porta cede.
* **6.8 Telhado (`cp06_roof`).** Ardósias soltas, claraboia negra [C]; luzes acesas ao norte na Ordem de Dagon, na igreja batista e na congregacional (`evt_church_lights`) [C]. A janela do 428 continua escura.
* **6.9 Armazém.** Queda curta pela claraboia, caixas e barris, relógio: 2h [C]; escada, térreo; porta para a Paine adiante e porta dos fundos aberta para o pátio [C].
* **6.10 Pátio (`cp06_courtyard`, `evt_courtyard_crowd`, `pz09_courtyard`).** O jogador cruza até o lado da Washington; o primeiro prédio tem a porta da rua emperrada [C]. Ao voltar: de uma porta do Gilman sai uma multidão de formas com lanternas, vozes coaxantes, andar agachado; uma figura de manto e tiara [C]. Eles não sabem onde ele está [C]. O jogador entra numa sala vazia, abre venezianas de janelas sem caixilho, sai e as fecha como estavam [C]. Washington Street, ao luar, sem luzes. Fim do capítulo.

---

## 9. `ch07_night` — A Noite de Innsmouth

Plano detalhado em `09-FUGA-NOTURNA.md`. Batidas de roteiro:

1. **Washington sul (`cp07_washington`).** Vozes roucas, passos e um "tamborilar que não parece passos" vindo de várias direções [C]. As luzes da rua estão apagadas [C].
2. **Bates (`evt_bates_hide`).** Duas figuras cruzam; o jogador entra num vestíbulo aberto [C].
3. **Praça Eliot/Washington/South (`cp07_south_crossing`).** O mapa a mostrava perigosa; não há desvio razoável; atravessar **imitando o passo arrastado** [C]. Gramado gradeado no centro; zumbido crescente vindo da Town Square [C].
4. **Vista da South Street (`evt_reef_signals`, `evt_swimmers`).** O mar "glorioso" ao luar; clarões no recife; resposta da cúpula do Gilman, a nordeste, com intervalos diferentes; depois, no mar entre recife e costa, uma horda nadando para a cidade [C]. O narrador deixa o passo arrastado e **corre** — o jogo permite, pois a rua está vazia.
5. **Mudança de plano (`evt_federal_motor`).** Perseguição organizada pela Federal, motor chiando para o sul [C]. Raciocínio do narrador como nota [O de C]: "Não me seguem: cercam. Todas as estradas estão vigiadas. Resta a velha ferrovia de Rowley." O jogador consulta o mapa com a lanterna num vestíbulo (`pz10_night_route`).
6. **Babson (`cp07_babson`).** Casa habitada sem luz [C]. `evt_ipswich_party`: um carro cruza a praça rumo à Eliot; um bando agachado segue; duas figuras de manto, uma de diadema que quase **saltita** [C].
7. **Lafayette, Eliot, South de novo.** Bote rumo aos cais abandonados com carga sob lona; brilho constante no recife de cor indefinível; cúpula do Gilman escura (`evt_rowboat`) [C].
8. **Bando da Washington (`evt_washington_band`).** A uma quadra, o grupo do pátio: rostos bestiais, um homem que anda com os braços tocando o chão, uma figura de tiara saltitando [C]. Teste canônico: manter o passo arrastado. Eles passam [C]. "Até hoje não sei se me viram" (texto do Diário).
9. **Bates, Adams (`evt_drunk_adams`).** Um homem cambaleia de uma porta, bêbado demais para ser ameaça [C].
10. **Bank Street (`cp07_bank_street`).** Armazéns enormes; as quedas cobrem os passos [C]. Estação em arcadas.
11. **Trilhos e ponte coberta (`cp07_bridge`, `evt_bats`, `pz11_bridge_gap`).** Nuvem de morcegos; vão nos dormentes a meio caminho; salto [C].
12. **River Street, aterro, corte (`cp07_cut`).** Mato que rasga a roupa; ilha de terreno alto; o corte raso [C]. Olhando para trás: espigões "adoráveis e etéreos" ao luar [C]. `evt_ipswich_column`: ao sul, movimento ondulante que brilha demais [C].
13. **Vento (`evt_wind_shift`).** O odor de peixe volta do mar; murmúrios guturais; um "flopping or pattering" colossal [C].
14. **A procissão (`evt_rowley_procession`).** O jogador agacha no corte; o jogo pede para **manter os olhos fechados**. A tela fica preta; só o som — coaxos, balidos, latidos, o chão quase tremendo. A resolução está condenada [C]: depois de um tempo, os olhos se abrem (ou o jogador solta antes). Na estrada, a cem jardas, ao luar amarelo: um fluxo "sem limite" de Profundos saltando em duas e quatro patas; alguns com tiaras de ouro esbranquiçado, alguns com mantos; à frente, um de casaco preto corcunda, calças listradas e chapéu de feltro sobre a forma que serve de cabeça [C]. Pseudo-memória fechada: o motivo da tiara e do padre toca inteiro. Texto final da tela [O de C]: "Eram os peixes-sapos do desenho sem nome — vivos." Desmaio.

---

## 10. `ch08_inheritance` — A Herança de Innsmouth

* **8a `ch08a_rain` (`cp08_rain`).** Chuva leve de dia; o jogador se levanta no corte e caminha até a estrada: **lama fresca sem nenhuma pegada** (`evt_no_prints`) [C]. O cheiro sumiu (sons do mar ausentes). Innsmouth cinzenta a sudeste. Relógio: passa do meio-dia [C]. Caminhada lenta até a placa de Rowley; elipse; texto: Rowley, refeição, roupas, trem noturno para Arkham [C].
* **8b `ch08b_arkham` (`cp08_arkham`).** Sala de depoimento [O]: o funcionário federal ouve; o jogador escolhe a **ordem** em que relata (Zadok, o hotel, os sinais, a procissão) — cada item que conta escurece uma página do Diário marcada "contei" [O]. O funcionário não diz se acredita [O]:
> Funcionário [O]: "O senhor fará o mesmo relato em Boston. Não fale com jornalistas."
  Depois, Sociedade Histórica com **Peabody** [C]: o jogador apresenta-se como neto de Eliza Orne; Peabody lembra o tio; conta a história da noiva Marsh de New Hampshire, educada na França, tutor desconhecido, governanta, pais impossíveis de localizar, morte no parto [C]; `evt_marsh_eyes`:
> Peabody [O de C]: "Tinha os verdadeiros olhos Marsh, diziam. E — me perdoe — o senhor também os tem."
  `item_peabody_notes` entra nos Bolsos. Opcional: a placa do Museu Miskatonic na saída; interagir mostra a nota [C]: "Não ousei procurar a peça do museu."
* **8c `ch08c_aftermath`.** Quarto de estudante em Oberlin [O layout]: recortes de fevereiro de 1928 (`doc_raid_clippings`), a carta federal (`doc_federal_letter`) [O de C]. Os recortes trazem a versão oficial (contrabando), as prisões sem julgamento, as casas dinamitadas, os protestos que se calam e, num tablóide, o submarino que torpedeia o abismo além do recife [C]. Nenhum texto comemora (D-016). Uma batida na porta: "visita oficial" anunciada pelo texto e não mostrada.
* **8d `ch08d_cleveland` (`cp08_cleveland`).** Julho de 1928, casa Williamson: o avô entrega registros Williamson; Walter abre arquivos Orne — cartas, recortes, fotos, miniaturas [C]. O jogador examina as fotos de Eliza e de Douglas: `evt_photo_shift` — ao voltar a olhar uma foto já examinada, a expressão "sugere algo" (troca sutil de textura, olhos mais abertos, sem animação) [C, representação O]. **`pz12_genealogy`:** quadro genealógico (12). O jogador liga fichas: Peabody (noiva Marsh de NH, educada na França, morte em 1867), Zadok (`jrn_obed_daughter`, `jrn_obed_eyes`), cartas, fotos, miniatura. Quando a correspondência fica completa, o narrador recusa a conclusão no texto [O de C]: "Coincidências. Uma moça de New Hampshire e uma história de bêbado." Walter: "Há uma caixa no banco que sua avó gostava de olhar."
* **8e `ch08e_vault` (`cp08_vault`).** Sala de cofres; Walter desembrulha devagar e hesita, estudando o rosto do sobrinho [C]; o jogador pode pedir que continue (única opção que avança). Braceletes, peitoral, e então a tiara (`evt_vault_tiara`): desmaio silencioso, sem efeito sonoro alto — o som simplesmente cessa [C]. Nota da governanta (`doc_governess_note`): não usar na Nova Inglaterra, seguro na Europa [C].
* **8f `ch08f_dreams` (`cp08_dreams`).** Elipse: dois anos no escritório de seguros (texto) [C]. Inverno de 1930–31: série de três noites no `lvl_toledo_room` [O estrutura]:
  1. **Noite 1:** o jogador deita; sonho curto em `lvl_dream_sea` — pórticos submersos, muralhas ciclópicas, peixes como companhia [C]. Ao acordar, horror; o espelho está coberto.
  2. **Noite 2:** sonho mais longo; outras formas aparecem; o jogador caminha com elas sem medo, usando adornos (mãos do jogador ganham membranas no sonho) [C]. Acordar: a mão real normal; o pai na porta, olhar assustado [C]. `doc_dream_notes`.
  3. **Noite 3 (`evt_grandmother_palace`):** palácio fosforescente de terraços, corais leprosos; a avó transformada, calorosa talvez com sarcasmo: não morreu; Douglas recusou "com uma pistola fumegante"; este será também o reino do narrador; Pth'thya-l'yi (presença ao fundo, sem rosto pleno), 80 mil anos em Y'ha-nthlei; a cidade ferida, não destruída; "um dia, se lembrarem, voltarão a subir"; penitência leve; um shoggoth entrevisto acorda o jogador gritando [C].
  > Avó [O de C]: "Eu nunca morri. Fui para onde seu tio poderia ter ido. Este reino é seu também. Você não vai morrer."
  * **`evt_mirror_look`:** ao acordar, o espelho está descoberto [O]. O jogador se aproxima; o reflexo (ver 13) mostra olhos que não piscam e vincos no pescoço [C]. Nenhuma narração.
  * **A gaveta:** dentro, a automática [C]. Interação única: "Olhar" — nota [O de C]: "Comprei-a. Quase. Os sonhos me impediram." A gaveta se fecha sozinha ao sair do exame (o jogador não pode empunhar a arma) (D-015).
* **8g `ch08g_final` (`cp08_final`).** Volta à escrivaninha de `ch00_frame`. O jogador escreve as últimas páginas: `doc_canton_plan` [C intenção, O texto]. O texto passa de horror a exaltação [C]:
  > "Não, não vou me matar. Vou tirar meu primo daquele sanatório de Canton, e juntos iremos a Innsmouth."
  Lawrence nunca aparece; a cena não mostra Canton. O jogador assina. **`evt_final_descent` [O simbólico]:** a tinta escorre como água; corte para Devil Reef ao luar; o jogador nada (controle mínimo: avançar) até o recife e mergulha; a descida pelo abismo; luzes de Y'ha-nthlei, "ciclópica e de muitas colunas" [C]; antes do contato, a imagem se dissolve no papel. Na tela, em tempo futuro [O de C]: "Nadaremos até aquele recife. Desceremos pelos abismos negros. E lá habitaremos, entre maravilha e glória, para sempre." Créditos sobre o som do mar.

Por que a descida é simbólica: o conto termina antes da ação (D-010). A legenda em futuro e o retorno ao papel mantêm a cena como **antecipação** do narrador, não como fato.

---

## 11. Cenas memoráveis — prioridade artística

Ordem de investimento artístico (arte, luz, som, animação) — as primeiras recebem acabamento máximo mesmo que outras fiquem mais simples.

| Prioridade | Cena | Evento/local | Por que importa |
|---|---|---|---|
| 1 | Procissão na estrada de Rowley | `evt_rowley_procession` | Clímax visual do jogo |
| 2 | Cerco e fuga pelos quartos | ch06 / `08` | Experiência mais intensa e jogável |
| 3 | Tiara na Sociedade e tiara no cofre | `evt_tiara_reveal`, `evt_vault_tiara` | Abertura e fechamento do arco |
| 4 | Testemunho de Zadok e grito | `evt_zadok_shriek` | Coração narrativo |
| 5 | Sinais entre recife e cúpula; nadadores | `evt_reef_signals`, `evt_swimmers` | Primeira prova de escala |
| 6 | Panorama da crista | `evt_crest_panorama` | Apresentação de Innsmouth como personagem |
| 7 | Padre no porão | `evt_basement_priest` | Primeiro choque de pseudo-memória |
| 8 | Sonho do palácio da avó e espelho | `evt_grandmother_palace`, `evt_mirror_look` | Inversão do sentido |
| 9 | Ponte coberta com morcegos | `evt_bats`, `pz11_bridge_gap` | Ação física memorável |
| 10 | Cortina-corda e telhado sob a lua, luzes das igrejas | `pz08_drapery`, `evt_church_lights` | Imagem icônica |
| 11 | Lama sem pegadas | `evt_no_prints` | Silêncio após o clímax |
| 12 | Descida final | `evt_final_descent` | Último plano do jogo |
