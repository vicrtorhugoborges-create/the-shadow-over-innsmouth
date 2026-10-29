# 13 — Direção artística: horror retrô PS1

> **Estado:** proposta de pré-produção. Parâmetros visuais são pontos de partida a calibrar no protótipo (Fase 1) e na vertical slice (Fase 2). Recursos que dependem da engine estão marcados **"verificar em spike"**.

## 1. Princípio

A baixa fidelidade é uma **linguagem**, não uma desculpa. Ela existe para três funções:

1. **Incerteza.** Rostos de poucos pixels e silhuetas sob névoa deixam o jogador completar o que vê — exatamente o mecanismo do conto, em que o narrador sente horror antes de saber por quê (o padre no porão, ch02, [C]).
2. **Tempo esquecido.** Texturas granuladas e paleta limitada evocam fotografia e cartão-postal antigos, coerentes com uma cidade "esquecida" desde 1846.
3. **Viabilidade.** Modelos de baixo polígono e texturas pequenas permitem que uma equipe pequena produza uma cidade inteira com direção consistente.

Regra de ouro: **toda distorção visual deve ser opcional ou suave o suficiente para não prejudicar leitura, navegação ou acessibilidade** (ver 16).

## 2. Referências críticas (o que aprender, o que não copiar)

| Referência | O que aproveitar | O que evitar |
|---|---|---|
| *Silent Hill* (1999) | Névoa como limite de mundo e como emoção; som que antecipa a imagem; ruas reconhecíveis que se tornam hostis. | Monstros simbólicos de culpa pessoal, rádio de alerta, estética industrial-ferrugem; nenhuma interface, mapa ou criatura parecida. |
| *Resident Evil* clássico | Composição deliberada, interiores densos de objetos, portas como tensão, salas "seguras". | Câmera fixa, combate, gestão de munição, puzzles de emblemas arbitrários. |
| Horror indie PS1 contemporâneo | Pipeline barato: texturas pequenas, dithering, resolução baixa, apresentações curtas e fortes. | Excesso de jitter e warping, "filtro VHS" anacrônico, sustos baratos. |
| Fotografia histórica da Nova Inglaterra (c. 1890–1930: portos, Newburyport, Gloucester, Marblehead, Ipswich) | Telhados gambrel, frontões, *widow's walks*, cais de madeira, armazéns de tijolo, ruas de paralelepípedo, postes com dois fios. Paleta de tons de prata e sépia. | Reproduzir fotos protegidas como texturas; usar apenas fotos de domínio público ou próprias, registradas no inventário (18). |
| Horror analógico | Granulação, desbotamento, papel envelhecido nos documentos. | Glitches digitais, VHS, scanlines de TV — anacrônicos para 1927. Exceção possível: sonhos (`lvl_dream_sea`), como deformação orgânica, não eletrônica. |

O jogo não reutiliza personagens, mapas, interfaces, trilhas ou assets de nenhuma dessas obras, nem de adaptações anteriores do conto (ver 24).

## 3. Especificações gráficas (§8.2)

Legenda: **E** = essencial à identidade; **Op** = opcional/ajustável pelo jogador.

| Parâmetro | Valor inicial | E/Op | Observações |
|---|---|---|---|
| Resolução interna do mundo | 427×240 (16:9) | E | D-018. Upscale inteiro quando possível. |
| Resolução interna alternativa | 640×360 | Op | Para legibilidade/conforto. |
| Escalonamento | Vizinho mais próximo (nearest) | E | Escala inteira; barras quando a proporção não for inteira — verificar em spike o comportamento em 1366×768 e ultrawide. |
| UI, legendas, documentos | Resolução nativa | E | Nunca passam pelo pós-processo do mundo (D-018). |
| Proporção | 16:9 padrão; 4:3 com barras laterais | Op | 4:3 é opção estética, não padrão. |
| FOV | 75° padrão; ajustável 60–100° | E (ajuste) | Ver 16. |
| Texturas — ambiente | 64×64 e 128×128 px | E | Telhas, tábuas, tijolo em atlas por bairro. |
| Texturas — heróis | até 256×256 px | E | Tiara, fachadas únicas (Gilman, Ordem de Dagon, igreja gótica), rostos de Zadok e Sargent. |
| Texturas — personagens comuns | 128×128 px atlas por personagem | E | Rosto ocupa ≥ 25% do atlas. |
| Profundidade de cor | Redução para ~15 bits (5-5-5) com dithering | E | Aplicada só ao mundo. |
| Dithering | Bayer 4×4, intensidade 0–100% | E / Op (intensidade) | Padrão 60%; 0% disponível. |
| Filtragem de textura | Nearest, sem mipmaps nos atlas próximos; mipmaps nearest para distância | E | Verificar em spike cintilação ("shimmer") a distância; mitigar com mipmaps e névoa. |
| Instabilidade de vértices (snapping) | Sutil, ajustável 0–3 níveis; padrão 1 | Op | Nível 0 obrigatório disponível (enjoo). |
| Distorção afim de textura | **Desligada** por padrão | Op | Prejudica leitura de placas e documentos no mundo. |
| Distância de renderização | 60–120 m em rua; vistas distantes por *impostors* | E | Névoa encobre o limite. Devil Reef e vistas panorâmicas usam silhuetas planas. |
| Névoa | Linear por distância, cor e alcance por período (14) | E | Névoa como limite de mundo e de emoção. |
| Sombras dinâmicas | 0–1 luz com sombra por cena | E (limite) | Lanterna do jogador ou um lampião roteirizado; demais sombras pintadas. |
| Iluminação | Cor de vértice pintada/assada + poucas luzes dinâmicas | E | Lightmaps no renderizador Compatibility: **verificar em spike**; o plano não depende deles. |
| Água | Textura rolante em camadas + ondulação de vértice simples; reflexo falso por textura | E | Sem reflexão em tempo real. |
| Granulação | Leve, animada a 12–15 fps | Op | Padrão baixo. |
| Grading | Tabela de cor por período (14), sutil | E | Sem saturação extrema. |
| Vinheta | Muito leve | Op | Aumenta só em sonhos. |
| Efeitos de câmera | Tremor e balanço desligados por padrão | Op | Ver 16. |
| Taxa de animação | Personagens a 15 fps ("stepped") opcional; câmera e jogador sempre suaves | Op | Ajuda a esconder animações simples. |

Efeitos são aplicados de forma **consistente**: todo o mundo usa a mesma pipeline; somente sonhos e o desmaio têm parâmetros especiais.

## 4. Orçamentos de polígonos (triângulos, por modelo)

Valores iniciais a validar por medição (19).

| Tipo | Orçamento | Notas |
|---|---|---|
| Módulo arquitetônico (parede, telhado, janela) | 20–300 | Kit por bairro. |
| Casa composta por módulos | 400–1.200 | Telhados com caimento real para silhuetas. |
| Marco único (Gilman, Ordem de Dagon, igreja gótica, refinaria) | 1.500–4.000 | Fachadas com 256 px. |
| Ponte coberta / estação | 1.000–2.500 | Interior percorrível. |
| Interior de cômodo (casca) | 200–800 | Sem mobiliário. |
| Móvel | 40–300 | Interativos com colisão simples. |
| Objeto de investigação (mão/inspeção) | 150–600 | Tiara até 900. |
| Personagem humano | 600–1.200 | 1 atlas 128 px. |
| Zadok, Sargent (heróis) | 1.000–1.600 | Atlas 256 px. |
| Profundo (procissão, distância) | 500–900 | LOD de silhueta. |
| Profundo (próximo, sonho/espelho) | 1.200–1.800 | Uso raro. |
| Veículo (ônibus, carro fechado, caminhão) | 600–1.500 | Ônibus tem interior. |
| Barco (dóri, bote) | 100–400 | |
| Vegetação (tufo, arbusto, junco) | 4–60 por cartão | Cartões cruzados. |
| Impostor de multidão/horizonte | 2–8 por cartão | Ver 09. |

## 5. Paleta geral

| Grupo | Tons | Uso |
|---|---|---|
| Madeira velha | cinza-prata, castanho desbotado, verde-limo | casas, cais |
| Tijolo Federal (~1800) | vermelho-ferrugem apagado, argamassa clara | praça, armazéns |
| Pedra | cinza frio, granito | igreja gótica, quebra-mar |
| Mar | cinza-esverdeado, azul-chumbo, espuma suja | orla, recife |
| Ouro esbranquiçado | ouro pálido com reflexo quase prateado | tiara e joias — **única cor "luxuosa" do jogo** |
| Pele de Innsmouth | cinza-azulado, pálido úmido | NPCs `look_1+` |
| Profundos | cinza-esverdeado, ventre branco | [C] "greyish-green, though they had white bellies" (ch. IV) |
| Arkham/Cleveland/Toledo | tons quentes domésticos, papel, madeira envernizada | contraste "civilização" |

O ouro esbranquiçado aparece em Newburyport, no padre, no pátio, na procissão e no cofre de Cleveland: a repetição de cor é um fio narrativo.

## 6. Modelagem e texturização por categoria (§8.3)

### 6.1 Casas

* **Gambrel e frontões** [C] ("sagging gambrel roofs and peaked gables", ch. II): duas silhuetas básicas, 3 alturas, 4 variações de fachada por bairro. Telhados afundados, buracos, chaminés tortas são **variações de módulo**, não modelos novos.
* **Georgianas quadradas** [C] com telhado de quatro águas, cúpula e *widow's walk*: nos bairros patrícios (`dist_patrician`). 2 modelos-base + variações de cerca, jardim cuidado/abandonado.
* **Estados de conservação:** habitado (cortinas, janela inteira), tapado (tábuas — o tipo que emite sons, `evt_boarded_sounds`), arruinado (inclinado, desabado). Inclinação de fundação é obtida rotacionando o módulo inteiro, nunca deformando a malha.
* **Sótãos e terceiros andares com venezianas fechadas** [C] em `dist_patrician`: textura de veneziana dedicada, reconhecível.

### 6.2 Prédios comerciais

Blocos de tijolo de ~1800, dois a três andares, telhado inclinado, vitrines com letreiros pintados à mão (texto legível em 128/256 px apenas nos letreiros relevantes: First National, restaurante, drogaria, peixaria atacadista, escritório da Marsh Refining Company). Letreiros desbotados usam texto genérico em inglês de época, revisado para não sugerir marcas reais além da rede First National mencionada no conto (verificar em 24).

### 6.3 Igrejas

* Três campanários georgianos decadentes [C], um com o topo desmoronado, dois sem mostradores de relógio — **silhuetas de horizonte** visíveis de vários pontos (marcos de orientação).
* Igreja gótica de pedra, torre atarracada, porão desproporcional com janelas fechadas [C]: marco único com textura de pedra 256 px; a porta do porão é um retângulo de escuridão total (ponto de `evt_basement_priest`).
* Igrejas de Main/Church Streets: duas cascas arruinadas.

### 6.4 Gilman House

Edifício alto coroado por cúpula, restos de tinta amarela, letreiro meio apagado [C]. Fachada 256 px; cúpula visível de toda a parte sul da cidade (é a fonte do sinal-resposta em `evt_reef_signals`). Interior: lobby, escada de três lances, corredor do 4º andar, quartos com portas de ligação. Mobiliário barato e repetido (cama de ferro, cômoda, lavatório, armário) — consistente com a planta em 08.

### 6.5 Refinaria Marsh

Antigo moinho na borda do desfiladeiro, junto às quedas inferiores, com **campanário branco** [C] relativamente bem conservado: a única estrutura clara no meio da decadência da orla. Visto da praça "na margem oposta" [C]. Telhado de ardósia, janelas altas, chaminé que solta pouca fumaça.

### 6.6 Ordem Esotérica de Dagon

Antigo Salão Maçônico com colunas, tinta branca descascando a cinza, letreiro preto e dourado quase ilegível [C]. O letreiro é textura 256 px desenhada para ficar **difícil, mas possível** de ler (o narrador "com dificuldade" o decifra, ch. II).

### 6.7 Docas e orla

Cais de terra e alvenaria, estacas podres, quebra-mar de pedra com fundação de antigo farol [C], cabanas, dóris, armadilhas de lagosta. Cais mais ao sul mais deteriorados [C]. Kit: 12–15 módulos (estaca, tábua, laje, muro de contenção, pedras com musgo).

### 6.8 Barcos

Dóris amarradas, bote a remo de `evt_rowboat` com carga sob lona (forma volumosa ambígua — nunca revelada). Sem navios grandes (não há "navio de bom tamanho" desde a Guerra Civil, [C]).

### 6.9 Objetos históricos e móveis

Objetos de 1920 (lâmpada incandescente com fio, telefone de parede, cofres de banco, máquina registradora, lampiões) em atlas compartilhados. Móveis interativos de ch06 têm silhueta distinta e textura levemente mais clara para leitura no escuro (sem contorno brilhante).

### 6.10 Documentos

Documentos legíveis **nunca** são lidos na textura 3D: o objeto 3D usa textura evocativa; o conteúdo abre no leitor nativo (16). Papel com tipos de época, carimbos, manchas; fotografias em prata/sépia com grão.

### 6.11 Vegetação costeira

Juncos, capim de duna (*sedge-grass*), arbustos raquíticos, sarça e espinheiro no aterro e no corte [C]. Cartões cruzados com alfa recortado (sem transparência suave), balanço por ondulação de vértice.

### 6.12 Personagens e roupas de 1920

Ternos surrados, bonés de golfe (Sargent: boné cinza puído, roupas azuis [C]), macacões de pescador, aventais, vestidos simples; em Arkham e Cleveland, roupas de classe média. O narrador aparece apenas em reflexos, fotografias e no espelho final: terno de viagem, chapéu (perdido na fuga — [C] "hatless", ch. IV).

### 6.13 "Aparência de Innsmouth" (D-013)

A transformação é desenhada como **metamorfose anfíbia**, não como traço étnico humano:

| Estágio | Traços visuais permitidos | Não usar |
|---|---|---|
| `look_0` | nenhum | — |
| `look_1` | olhos úmidos que não piscam, vincos laterais no pescoço, pele levemente acinzentada | formatos de nariz, lábios ou crânio associados a grupos humanos |
| `look_2` | calvície precoce, pele áspera e descamando, mãos grandes de tom cinza-azulado, dedos curtos que se curvam, pés grandes, andar arrastado | expressão "malvada"; o estágio não indica caráter |
| `look_3` | (raro, entrevisto) olhos salientes, guelras visíveis, membranas entre dedos, postura curvada | — |
| `look_4` | Profundo | — |

Comportamento e aparência são **independentes**: há `look_2` civis e `look_0` hostis (ver 10).

### 6.14 Profundos

Silhueta antropoide com cabeça de peixe, olhos enormes que nunca fecham, guelras palpitantes, patas longas com membranas, dorso com cristas escamosas, brilho úmido, ventre branco, deslocamento saltitante em duas ou quatro patas [C] (ch. IV). Três modelos-base (alto, médio, curvado) + variações de manto, tiara e cor. O líder da procissão usa casaco preto corcunda, calça listrada e chapéu de feltro [C]. Materiais: especular falso pintado (faixas claras na textura) em vez de shader caro.

### 6.15 Tiara e joias

Ouro com lustro mais claro, "liga" não identificável [C]; perímetro alto na frente e irregular, para cabeça "elíptica" [C]; relevos parte geométricos, parte marinhos, com criaturas meio peixe meio rã [C]. Modelo herói de até 900 triângulos com textura 256 px; a tiara de Newburyport, a do padre, as da procissão e a tiara Orne usam a **mesma linguagem de desenho**, com variações. A peitoral e os braceletes Orne seguem o mesmo atlas.

### 6.16 Artefatos do culto

Mantos, diademas, aviso da Ordem, folheto. Nenhum símbolo real de religião existente é usado como símbolo do culto; o simbolismo é original e documentado em 18.

## 7. Coerência com poucos assets

1. **Kit modular por bairro** (praça Federal de tijolo; orla de madeira; patrício georgiano; industrial do desfiladeiro), com 30–60 módulos cada e atlas comum.
2. **Gramática de decadência** de 4 níveis aplicada por troca de material e de módulos (inteiro → tapado → inclinado → desabado).
3. **Marcos únicos** limitados a ~10 (Gilman, Ordem de Dagon, igreja gótica, refinaria, ponte da Federal, ponte coberta, estação, mansão Marsh, quebra-mar, três campanários como silhueta).
4. **Mesma cidade dia/noite** (D-004): só iluminação, névoa, janelas acesas e props móveis mudam.
5. **Personagens por partes**: 3 corpos-base × cabeças × roupas × estágio `look`.
6. **Revisão de arte**: cada asset passa pela checagem de paleta, densidade de texel (~64 px/m no ambiente) e silhueta a 240 px.

## 8. Critérios de aprovação visual

* Legível a 427×240 com dithering a 60%: placas relevantes, portas interativas, saídas de rota.
* Silhueta reconhecível do marco a 50 m na névoa diurna.
* Nenhum NPC comunica maldade apenas por aparência.
* Captura comparativa dia/noite do mesmo ponto aprovada em ch03 vs ch07.
* Aprovação humana registrada no inventário (18) antes de status "final".
