# 28 — Estado da implementação

> Fonte da verdade sobre o que existe em código. Atualizar a cada entrega. Arquivos existirem não significa fase concluída: os gates estão em `20-ROADMAP.md` e `23-TESTES-E-QUALIDADE.md`.

## Versão 1.1.0 — fechamento com autoteste próprio (27–29/10/2026)

Pedidos do usuário: "termine o jogo sem avaliação de terceiros, caso necessário, teste por si próprio abrindo o jogo e verificando os dados" e "continue o jogo se ainda não finalizou". Decisões registradas em `27-REGISTRO-DE-IDS.md`: D-020 (fechar sem terceiros), D-021 (assets procedurais próprios como assets da versão, resolve Q-011), D-022 (aviso de conteúdo, resolve Q-010), D-023 (só PT-BR, sem dublagem).

### O que mudou

| Área | Mudança |
|---|---|
| Personagens | `FigureKit` + `FigureAnimator` substituem as cápsulas: pessoas de 1927 low-poly com sombreamento por vértice (homem, mulher, idoso, funcionário, merceeiro, criança, manto; chapéus, saias, aventais, barba), Profundos com cabeça de peixe, olhos saltados levemente luminosos, guelras, nadadeiras dorsais, mãos e pés palmados (comum, tiara, manto, líder de casaco e calça listrada); andar procedural pela velocidade real; Zadok sentado no banco e no cais; "aparência" em traços anfíbios (D-013). |
| Interface (docs/16) | Créditos e licenças; aviso de conteúdo completo (02 §6.4) com o CVV 188, também acessível no menu; capítulos liberados por progresso; confirmação antes de sobrescrever o manuscrito; pausa com objetivo e botão do Diário; "Até aqui" ao continuar; descrições do que se vê (gestos, letreiros, luzes) sempre visíveis, mesmo com legendas de som desligadas. |
| Configurações | Brilho (gama) com calibração; intensidade do efeito retrô; tela cheia; V-Sync; volumes geral, de ambiente e de efeitos (canais `Ambience` e `Effects`); fundo das legendas; ponto central; seções agrupadas. |
| Placeholders (INN-401) | Os 23 sons `ph_*` viraram `sfx_*` (129 referências); a varredura do prefixo `ph_` no código está vazia. Inventário da 1.1 em `18-INVENTARIO-DE-ASSETS.md` §11. |
| Desempenho | Esferas de 64×32 segmentos → 8×4 (os 110 nadadores do recife somavam ~450 mil triângulos); geometria estática do Gilman fundida, com exclusão automática de portas, móveis, interativos, luzes e nós marcados como dinâmicos; membros das figuras sem sombra. |
| Texto | Revisão interna (agente independente, só leitura): 0 bloqueantes; 8 maiores e ~25 menores corrigidos, entre eles a fala de Tilton que reintroduzia "degeneração", a nota sobre as ilhas exigida por 02 §6.1, ID interno numa pista, colchetes duplicados, marcas [O]/[C] visíveis ao jogador, parentesco ambíguo no sonho, contagem americana de andares, teclas fixas em pistas e versões divergentes. |
| Distribuição | Versão 1.1.0 em todo lugar; `LEIA-ME.txt` acentuado (UTF-8 com BOM); rascunho de loja em `distribuicao/loja-rascunho.md`, **não publicado**. |
| Testes | `tests/ui_flow.gd` (fluxos de interface), `tests/recorder.gd` (gravação do autoteste gráfico), migração de saves e de configurações 1.0 → 1.1 em `run_tests.gd`; a espera do F1 em `playthrough.gd` passou a ser por evento, com verificação de que não cede antes do prazo. |

### Autoteste (D-020) — o que foi executado

**Bateria headless final** (Godot 4.7.2 portátil, perfil `tools/qa-profile`), logs em [`qa/`](qa/):

| Suíte | Log | Resultado |
|---|---|---|
| Lógica, saves (incl. migração), configurações (incl. migração), cerco, patrulha | `tests-v11.log` | 79 verificações, 0 falhas |
| Níveis de áudio | `audio-v11.log` | 0 sons fora da faixa |
| Jogada moldura → IV | `playthrough-day-v11h.log` | 37, 0 falhas |
| Jogada V–VI | `playthrough-v11h.log` | 43, 0 falhas |
| Jogada VII | `playthrough-night-v11h.log` | 34, 0 falhas |
| Jogada VIII até FIM | `playthrough-heritage-v11h.log` | 30, 0 falhas |
| Andarilho com input real (V–VI, II–IV, VII) | `walkthrough-v11.log` | 30, 0 falhas |
| Fluxos de interface | `ui-flow-v11.log` | 18, 0 falhas (a 1ª execução falhou por contagem errada no próprio teste: 9 controles deslizantes, não 10) |

**Jogadas com o jogo aberto e renderizando** (janela real, RTX 4060 de notebook, velocidade 6×, gravador ligado): moldura → IV 37/0, V–VI 43/0, VII 34/0, VIII 30/0. A primeira execução do V–VI teve 1 falha: com renderização a 6× a física ficou atrás do relógio do teste e o F1 ainda não tinha acontecido no instante fixo verificado. Não é defeito do jogo a 1× (a engine dá até 8 passos de física por quadro); o teste passou a esperar o evento e a verificar que ele não acontece antes do prazo (cedeu aos 133 s de jogo). Folhas de contato e relatórios JSON em [`qa/autoteste-v11/`](qa/autoteste-v11/) (`*-folha-00.png`, `*-relatorio.json`). Essas jogadas gravadas são anteriores às últimas correções (Zadok sentado, fusão do Gilman, esferas), verificadas depois pela bateria headless e pelo export.

Dados medidos nas jogadas gravadas (6×, logo mais pesado que jogar a 1×):

| Capítulo | Tempo médio de quadro | Quadros > 33 ms | Observação |
|---|---|---|---|
| Moldura e I | 6,47 ms | 0,6% | picos em trocas de cena |
| II–IV | 6,11 ms | 0,1% | |
| V–VI | 6,15 ms | 0,2% | 1.456 chamadas de desenho no pico → corrigido (abaixo) |
| VII | 6,25 ms | 0,2% | ~530 mil primitivas no pico → corrigido |
| VIII | 6,26 ms | 0,3% | ~550 mil primitivas no pico → corrigido |

Legibilidade (luminância média do mundo, 0–1, e fração de pixels quase pretos por captura): dia e interiores claros 0,15–0,69; Sociedade Histórica à noite 0,09; Gilman à noite 0,04–0,14; fuga noturna 0,04–0,11, com até 44% de pixels quase pretos; mar final 0,04. A noite é escura de propósito e as silhuetas se leem nas capturas, mas é o ponto mais arriscado: por isso o brilho calibrável. Não foi conferido num monitor real por uma pessoa.

**Executável exportado 1.1.0** (`Compilar.ps1`): `export.log` sem erros, testes fora do pacote; `The Shadow Over Innsmouth.exe` com 109.488.608 bytes, SHA-256 `0cfffc3007787f45f646296f7b52b8d6db33bf94e63e08e3c72fc3c350fee625` (reexportado depois de padronizar a cartela do VII; as medições abaixo são da exportação anterior, que só diferia nessa cartela). Aberto em 11 pontos da campanha com medição de 6 s, V-Sync desligado ([`bench-v11.log`](qa/bench-v11.log)) e capturas em [`qa/autoteste-v11/export/`](qa/autoteste-v11/export/) ([folha](qa/autoteste-v11/export-folha.png)):

| Ponto | Média | p99 | Pior | Chamadas de desenho |
|---|---|---|---|---|
| cp00_frame | 0,70 ms | 1,50 ms | 6,99 ms | 66 |
| cp01_society | 0,75 ms | 1,31 ms | 31,65 ms | 209 |
| cp02_square | 0,77 ms | 1,22 ms | 3,71 ms | 128 |
| cp03_grocery (praça) | 0,84 ms | 1,24 ms | 5,50 ms | 178 |
| cp04_wharf | 0,82 ms | 1,20 ms | 5,25 ms | 160 |
| cp05_return | 0,77 ms | 1,13 ms | 11,91 ms | 188 |
| cp06_knock | 0,79 ms | 1,14 ms | 4,14 ms | 221 |
| cp07_washington | 0,65 ms | 1,19 ms | 6,69 ms | 54 |
| cp07_cut (procissão) | 1,06 ms | 1,82 ms | 4,96 ms | 566 (930 antes de tirar a sombra dos membros) |
| cp08_dreams | 0,59 ms | 0,85 ms | 5,63 ms | 209 |
| cp08_final | 0,94 ms | 1,69 ms | 4,29 ms | 250 |

O monitor de memória estática do Godot só funciona em builds de depuração; no export ele mostra 0 MB, então a memória não foi medida.

**Instalação limpa:** a pasta da build copiada para um diretório novo, com `APPDATA` vazio, abriu e encerrou sem erro nem aviso (`--quit-after 900`), criando só `TheShadowOverInnsmouth\` com log e cache de shaders.

**Duração estimada (cálculo, não medição):** ~52 mil caracteres de texto jogável (~40–50 min de leitura, considerando que pistas e documentos opcionais nem sempre são lidos), mais as sequências cronometradas (viagem ~2,5 min, testemunho ~6–8 min, cerco do Gilman, procissão) e os trajetos a 2,3 m/s. Estimativa: **cerca de 1h45 a 2h30** por partida, abaixo da hipótese de 3–5 h do planejamento, pela condensação do ônibus, do testemunho e dos mapas.

### Achados do autoteste e correções

| Achado | Como apareceu | Correção |
|---|---|---|
| Esferas com 4 mil triângulos cada (nadadores, sonho) | pico de primitivas no relatório do gravador | 8×4 segmentos |
| Gilman sem fusão de geometria (até 1.456 chamadas) | relatório do gravador | `merge_static` com exclusão de dinâmicos → 188–228 |
| Procissão com 930 chamadas | medição do export | sombra só no tronco das figuras → 566 |
| Zadok de pé sobre o banco e achatado no cais | folha de contato | pose sentada real e caixote no cais |
| Veludo da vitrine magenta | folha de contato | bordô escuro |
| Gestos e letreiros sumiam com legendas de som desligadas | revisão textual | legenda de "ação" sempre visível |
| Espera fixa sensível ao passo de física no teste do F1 | jogada gravada | espera por evento + limite inferior |

### O que o autoteste NÃO substitui

- **Nenhuma pessoa jogou.** Medo, ritmo, clareza das pistas, frustração e duração real não se medem por automação.
- **Uma só máquina** (RTX 4060 de notebook, i7-13650HX): requisitos mínimos não estabelecidos; nenhum teste em GPU integrada.
- **Áudio nunca escutado**: só níveis medidos (pico e faixa).
- Revisão de sensibilidade só interna; parecer jurídico (Q-002) e título comercial (Q-001) pendentes; sem versão em inglês (Q-003).
- Arte e som procedurais aprovados apenas pelas capturas e medições do autoteste, sem revisão humana de direção de arte ou de mixagem.

### Próximo passo recomendado (após 1.1.0)

Para lançar comercialmente, faltam etapas que exigem terceiros: uma partida humana completa com tempos anotados, teste num PC modesto com GPU integrada, escuta dos sons, revisão de sensibilidade externa e parecer jurídico. Nada disso exige mudar contratos do código.

---

## Versão 1.0.0 — campanha completa, da moldura ao fim (27/10/2026)

Pedido do usuário: "continue até finalizar o jogo". A 1.0.0 acrescenta a moldura e os capítulos I a IV; a campanha inteira (`cp00_frame` → FIM) é jogável em sequência, sem voltar ao menu. **"Completa" quer dizer conteúdo narrativo completo, não produto comercial pronto**: arte, áudio e parte dos textos seguem provisórios, e nenhum gate humano do roadmap foi cumprido.

### O que passou a ser jogável

1. **Moldura** (`cp00_frame`, `NewburyportChapter`): o quarto em Toledo, inverno de 1930–31; o manuscrito sobre a escrivaninha; a primeira página (`doc_manuscript`).
2. **I — A Viagem** (`cp01_station` → `cp01_bus_stop`): bilheteria de Newburyport com diálogo em ramos (o trem caro, o ônibus de Innsmouth, `doc_bus_timetable`); moradores que se calam (`no_talk`); a biblioteca (`doc_essex_history`, `doc_jewellery_note`, bilhete para a Srta. Tilton); a Sociedade Histórica à noite com a **tiara na vitrine** (`evt_tiara_reveal`, etiqueta, arquivo de ofertas dos Marsh); Y.M.C.A. em elipse; a manhã diante da Hammond's — os ociosos se afastam do ônibus (`avoidance_seen`), Joe Sargent devolve o troco sem falar.
3. **II — A Cidade Esquecida** (`cp02_bus_ride` → `cp02_square`): a viagem num ônibus em movimento, com janelas abertas; a crista sobre a cidade e Devil Reef (`crest_seen`), a New Church Green, o sino das onze e o **padre no porão** (`evt_basement_priest`), a chegada à praça.
4. **III — Os Segredos de Innsmouth** (`cp03_grocery` → `cp03_whiskey`): a valise fica no Gilman; o rapaz da mercearia First National responde a seis temas e desenha o mapa (`item_sketch_map`, bolachas); passeio livre por quatro regiões (refinaria, orla sul, ruas antigas, norte do rio) com a mulher que fecha a veneziana e a ponte precária da Washington; Zadok aparece no quartel depois de três regiões; a garrafa na loja da Eliot (`pz03_whiskey`); Zadok segue a garrafa até a orla sul deserta.
5. **IV — O Testemunho de Zadok Allen** (`cp04_wharf`): sete movimentos no cais em ruínas (`pz04`): a garrafa precisa ser oferecida nas pausas dos movimentos 2–4; oferecer enquanto ele fala só pede calma, e três ofertas seguidas o fazem cochilar e retomar do mesmo ponto (falha suave); temas liberados pelas pistas do dia acrescentam trechos; depois do 4º movimento ele segue sozinho; a maré sobe e a luz fica dourada; o grito, a ondulação no recife, a fuga de Zadok (`evt_zadok_shriek`, `doc_zadok_record`). As duas pistas neutras para o `pz12` (`jrn_obed_daughter`, `jrn_obed_eyes`) ficam no Diário. A volta à praça leva direto ao V (`cp05_return`).

Não há falha com reinício nos capítulos I–IV: nenhum perigo antes do crepúsculo.

### Sistemas novos ou alterados

| Sistema | Arquivo | Observações |
|---|---|---|
| `NewburyportChapter` | `worlds/newburyport/newburyport_chapter.gd` | Moldura e I: quarto, estação, cidade, biblioteca, rua, Sociedade, manhã; ônibus que chega e para. |
| `DayChapter` | `worlds/day/day_chapter.gd` | II–IV: Innsmouth de dia em grade (ruas, praças, desfiladeiro do Manuxet, pontes), interiores (saguão, mercearia, loja de variedades), viagem de ônibus por trajeto, máquina de estados do testemunho. `merge_static` como na noite. |
| `DayText` | `data/day_text.gd` | Cartelas, objetivos, pistas em três níveis, notas, falas, sete movimentos e sete temas. |
| Modo `seated` do jogador | `player/player.gd` | Olhar e interagir sem andar (Zadok no cais). |
| Escolher capítulo | `app/app_root.gd`, `ui/ui_root.gd` | `CHAPTER_STARTS` + `start_from(cp)`: concede valise, chaveiro e relógio; a partir do III, mapa e bolachas; do V, o registro de Zadok; do VII, a lanterna. |
| `StoryState` | `systems/story_state.gd` | Nova partida começa em `cp00_frame`; allowlists com todos os fatos, itens, documentos e checkpoints de ch00–ch04 (lista em `27-REGISTRO-DE-IDS.md` §15). |

### Validação executada (1.0.0)

Bateria completa em modo headless (Godot 4.7.2 portátil, perfil isolado `tools/qa-profile`), logs em [`qa/`](qa/):

| Suíte | Log | Resultado |
|---|---|---|
| Lógica (save, cerco, patrulha, estado, configurações) | `tests-v10.log` | 73 verificações, 0 falhas |
| Jogada moldura → IV, até o início do V sem voltar ao menu, e "Escolher capítulo" | `playthrough-day-v10.log` | 37 verificações, 0 falhas |
| Jogada V–VI até o início do VII | `playthrough-v10.log` | 42 verificações, 0 falhas |
| Jogada VII até o início do VIII | `playthrough-night-v10.log` | 34 verificações, 0 falhas |
| Jogada VIII até a tela FIM | `playthrough-heritage-v10.log` | 30 verificações, 0 falhas |
| Andarilho com input real (rotas de V–VI, II–IV e VII) | `walkthrough-v10.log` | 30 verificações, 0 falhas (após as duas correções de mapa abaixo; a primeira execução teve 4 falhas) |

Os logs terminam com o aviso do Godot "N resources still in use at exit", já presente nas suítes da 0.3.0 e ligado ao encerramento do script de teste (não afeta os resultados); o "Fato não permitido: fato_inventado" em `tests-v10.log` é a verificação negativa da allowlist.

Capturas geradas pelo próprio jogo (modo `--capture`), conferidas visualmente: [escrivaninha](qa/capturas/ch00-escrivaninha.png), [tiara](qa/capturas/ch01-tiara.png), [ônibus na Hammond's](qa/capturas/ch01-onibus.png), [crista](qa/capturas/ch02-crista.png), [New Church Green](qa/capturas/ch02-green.png), [praça](qa/capturas/ch02-praca.png), [norte do rio](qa/capturas/ch03-norte.png), [orla](qa/capturas/ch03-orla.png), [Zadok no cais](qa/capturas/ch04-zadok.png).

**Export Windows 1.0.0** (`Compilar.ps1`, Godot 4.7.2, templates da mesma versão): `docs/qa/export.log` sem erros; `The Shadow Over Innsmouth.exe` com 109.463.840 bytes, SHA-256 `6f4946ae3b62f37099e091ae5fa90ccb55ba413a3f35006f9d6d1fbfb785855e`; acompanha `LEIA-ME.txt` (1.0) e as licenças do Godot. O executável exportado foi aberto em modo de captura e renderizou a moldura, a [Paine alargada](qa/capturas/ch03-paine-export.png) e a [rua da margem do rio](qa/capturas/ch03-margem-export.png) depois das correções de mapa. Isso prova que a build abre e desenha; não substitui jogar com teclado e mouse.

Defeitos encontrados por testes e capturas do I–IV e corrigidos antes da entrega: **a Old Square era um beco sem saída** — a refinaria fechava o largo e a Main do norte só era alcançável por um desvio de ~200 m, contrariando o docs/06 ("junto à refinaria e a uma ponte da Main"); o andarilho ficou preso em x ≈ 80 e a rua da margem do rio foi aberta entre o largo e a ponte da Main; **a praça só se ligava à Paine (quartel, Zadok, ponte da Washington) por uma fresta de 2 m ao norte do Gilman** — a Paine foi alargada até a praça (as capturas do II–IV são anteriores a essas duas mudanças, e a altura sorteada dos prédios mudou ligeiramente); janelas do ônibus opacas (agora molduras abertas); Zadok sentado impedia a interação (modo `seated`); a fase "atrair Zadok" não era restaurada ao sair da loja; verificação negativa da porta da estação testava o objeto errado; capturas com coordenadas relativas e cena do cais iniciada duas vezes.

### Desvios conscientes do planejamento (I–IV)

| Desvio | Motivo |
|---|---|
| O testemunho dura cerca de 6–8 minutos no total, não 2–4 minutos por movimento (docs/04, docs/12) | Texto [O] condensado; o ritmo exige playtest antes de alongar |
| A viagem de ônibus dura cerca de 2,5 minutos, com os marcos do conto disparados pelo trajeto (crista, Green, sino, padre, cachoeiras) | Idem |
| Innsmouth de dia é uma grade simplificada com marcos (não a planta de docs/06 em escala) | Escopo de geometria cinza; as regiões e a ordem do conto são preservadas |
| Newburyport é um conjunto de cenários pequenos ligados por cartelas (estação, rua, biblioteca, Sociedade, manhã) | Escopo |
| Moradores, Sargent, Tilton, Zadok e o padre são cápsulas e figuras placeholder | Arte final pendente (docs/18) |
| "Escolher capítulo" disponível desde a primeira partida | Facilita a revisão humana; reavaliar antes do lançamento (Q de UX) |

### NÃO validado (1.0.0)

- **Jogo humano de ponta a ponta**: duração real (estimativa 3–5 h não medida), compreensão das pistas do passeio diurno, ritmo do testemunho, tédio ou pressa na viagem de ônibus.
- Imagem, som e input numa execução gráfica humana do export (as capturas são do próprio jogo, não de um jogador); escuta dos sons sintetizados; legibilidade em monitores reais.
- Desempenho em hardware representativo (o único banco foi uma RTX 4060 de notebook, não representativo).
- Revisão de sensibilidade (descrição dos moradores de Innsmouth, Zadok e o alcoolismo, suicídio e doença mental mencionados no VIII) e revisão jurídica (Q-002).
- Arte, animação, vozes e mixagem finais; inventário de assets para distribuição.

### Próximo passo recomendado (após 1.0.0)

Uma sessão humana completa da 1.0.0, do menu à tela FIM, anotando tempos por capítulo e onde houve dúvida, tédio ou frustração; depois calibrar ritmo (testemunho, ônibus, passeio), percepção e prazos (VI–VII) e só então iniciar a substituição de placeholders por arte e áudio de produção.

---

## Versão 0.3.0 — autoteste da 0.2 e capítulo VIII, "A Herança de Innsmouth" (27/10/2026)

Pedido do usuário: "teste por conta própria caso possível, mas continue a produção mesmo se não for possível". Feito nesta ordem: autoteste da 0.2 ([relatório](qa/autoteste-v02.md)) e produção de `ch08_inheritance`.

### Autoteste — achados corrigidos

| Achado | Como foi encontrado | Correção |
|---|---|---|
| Portais obrigatórios da fuga noturna intransitáveis (bloco sólido no centro) | Andarilho com input real (`tests/walkthrough.gd`) | Nicho vazio; 24/24 rotas transitáveis |
| 1.657 chamadas de desenho na cidade noturna | Medição no export | `WorldKit.merge_static`: 55 chamadas |
| 6 sons saturando, 1 inaudível | `tests/audio_levels.gd` | Normalização a −3 dBFS na síntese |

### Capítulo VIII jogável

Ao desmaiar no corte, o jogo segue direto para `ch08_inheritance`:

1. **8a Chuva** (`cp08_rain`): despertar no corte, lama fresca **sem pegadas** (`evt_no_prints`), Innsmouth cinzenta a sudeste, placa de Rowley; elipse até Arkham.
2. **8b Arkham** (`cp08_arkham`): depoimento ao funcionário do governo — o jogador escolhe a **ordem** do relato; "não fale com jornalistas". Sociedade Histórica: **Peabody** conta a noiva Marsh de New Hampshire educada na França, o tutor, a governanta, os pais impossíveis de localizar, a morte no parto, e "os verdadeiros olhos Marsh" (`evt_marsh_eyes`); notas nos Bolsos. Placa do museu Miskatonic: "não ousei procurar a peça".
3. **8c Oberlin**: recortes de fevereiro de 1928 — prisões sem julgamento, casas dinamitadas, protestos calados, o submarino do tabloide (D-016: nada comemora); batida de "visita oficial".
4. **8d Cleveland** (`cp08_cleveland`): fotos de Eliza e Douglas (rever muda a expressão, `evt_photo_shift`), cartas, miniatura; **`pz12_genealogy`** num painel: fichas liberadas pelos documentos lidos, posições que só aceitam a ficha certa, e a posição "?" opcional que registra **uma pergunta** ("Seria Obed Marsh meu tataravô?"), nunca um fato.
5. **8e Cofre** (`cp08_vault`): Walter hesita; braceletes, peitoral, a tiara — **desmaio silencioso: o som simplesmente cessa** (`evt_vault_tiara`); nota da governanta.
6. **8f Sonhos** (`cp08_dreams`): três noites em Toledo — pórticos e muralhas submersas; depois caminhar com eles, com **mãos de membranas**, e o pai assustado à porta; por fim o palácio fosforescente, a avó ("eu nunca morri"), Pth'thya-l'yi ao fundo, Y'ha-nthlei ferida mas não destruída, o primeiro shoggoth e o grito. O pano cai do espelho: o **reflexo** de olhos que não piscam e pescoço vincado (`evt_mirror_look`). A gaveta com a automática **só pode ser olhada** (D-015).
7. **8g Final** (`cp08_final`): as últimas páginas — o plano de tirar o primo de Canton; assinar; a tinta vira água; nadar até Devil Reef ao luar; a descida para as colunas de Y'ha-nthlei com as frases em **tempo futuro**; o papel; FIM (`evt_final_descent`, **[O] simbólico**, D-010).

Sem falhas possíveis no capítulo. Lawrence e Canton nunca aparecem em cena.

### Sistemas novos

| Sistema | Arquivo | Observações |
|---|---|---|
| `InheritanceChapter` | `worlds/inheritance/inheritance_chapter.gd`, `data/inheritance_text.gd` | Sete subcenas pequenas no mesmo mundo, ligadas por fade e cartela. |
| `ChartPanel` (`pz12`) | `ui/chart_panel.gd` | Emite intenções; o capítulo valida e concede fatos. |
| `AppRoot.chapter_for(state)` | `app/app_root.gd` | Considera `ch08_done`: "Continuar" após o fim mostra a tela final, sem reiniciar o capítulo. |

### Validação (0.3.0)

Resultados das cinco suítes em [`qa/`](qa/): lógica (`tests-v03`), Gilman (`playthrough-v03`), noite (`playthrough-night-v03`), herança (`playthrough-heritage-v03`, 30 verificações do despertar à tela FIM, incluindo ficha errada recusada e pergunta opcional) e andarilho (`walkthrough-v03`). Capturas: [chuva](qa/capturas/ch08-chuva.png), [quadro](qa/capturas/ch08-quadro.png), [cofre](qa/capturas/ch08-cofre.png), [sonho](qa/capturas/ch08-sonho.png), [palácio](qa/capturas/ch08-palacio.png), [espelho](qa/capturas/ch08-espelho.png), [mar final](qa/capturas/ch08-mar.png).

Defeitos encontrados pelas capturas e testes do VIII e corrigidos antes da entrega: painel do quadro quebrava ao confirmar uma ficha; quadro deslocado e largo demais; joias escondidas dentro da caixa e tiara estourada em branco; moldura sólida tampando o espelho; mar final todo escuro (distância de visão de 140 m); fim do capítulo reiniciava o próprio capítulo.

### Desvios conscientes (ch08)

| Desvio | Motivo |
|---|---|
| Oberlin e o escritório federal são salas genéricas [O]; quarto de Toledo serve de moldura final (ch00 não existe ainda) | Escopo |
| O quadro usa listas de seleção em vez de arrastar fichas | Acessível por teclado/controle e testável |
| Avó, Pth'thya-l'yi e shoggoth são placeholders de cápsulas/esferas | Arte final pendente (docs/18) |
| Nenhuma interação com Lawrence; Canton só no texto do plano | Fidelidade (D-010) e cuidado com saúde mental |

### NÃO validado (0.3.0)

Como antes: jogo humano, escuta, legibilidade em monitores reais, hardware fraco, playtests, revisão de sensibilidade (especialmente 8f–8g: suicídio mencionado, doença mental mencionada) e revisão jurídica.

---

## Versão 0.2.0 — capítulo VII, "A Noite de Innsmouth" (27/10/2026)

Pedido do usuário: "implemente o capítulo VII (fuga noturna pela Washington até a ferrovia e a procissão na estrada de Rowley), continuando da fatia do Gilman". Base: docs/09 e docs/11.

### O que é jogável

Ao sair pela veneziana (fim de ch06), o jogo segue **sem voltar ao menu** para `ch07_night`, na ordem do capítulo IV do conto:

1. Washington Street para o sul, sem luz pública; dupla de figuras cruzando a Bates — esconder-se num vestíbulo (`evt_bates_hide`).
2. Espaço aberto Eliot × Washington × South ao luar; da boca da South, a rua desce até o porto: clarões em Devil Reef, resposta da cúpula do Gilman, o mar cheio de nadadores (`evt_reef_signals`, `evt_swimmers`); clamor à esquerda e motor descendo a Federal (`evt_federal_motor`).
3. Portal escuro: o narrador conclui que todas as estradas estão vigiadas e consulta o mapa à lanterna — o plano da ferrovia (`cp07_babson`).
4. Babson com duas pausas em portais: carro e grupo de Ipswich, com figura de manto e diadema saltitante, atravessam o espaço aberto da Eliot (`evt_ipswich_party`).
5. Lafayette e a **segunda travessia da South**: bote com carga sob lona, brilho fixo no recife, cúpula apagada (`evt_rowboat`); o bando do pátio cruza a praça a uma quadra — com o **andar arrastado** ele segue sem mudar o rumo; andando normal ou correndo, o jogador é visto (`evt_washington_band`).
6. Bates para oeste, Adams (o bêbado, `evt_drunk_adams`), Bank Street com o rugido das quedas, estação em arcadas, trilhos na beira do desfiladeiro.
7. Ponte coberta: lanterna liberada, nuvem de morcegos (`evt_bats`), vão nos dormentes revelado por luar do telhado — saltar (`pz11_bridge_gap`).
8. Pântano: menos cheiro de peixe; olhar para trás mostra as torres claras da cidade e a coluna ondulante na estrada de Ipswich (`evt_ipswich_column`).
9. Corte de mato: o vento vira (`evt_wind_shift`); agachado, segurar "Fechar os olhos" — que falha sozinho — e ver a procissão na estrada de Rowley: líder de casaco preto corcunda, calça listrada e chapéu de feltro, tiaras, mantos, a massa (`evt_rowley_procession`). Desmaio; `cp08_rain` gravado; tela de fim do capítulo VII.

Falhas: captura após detecção (com janela de fuga por quebra de linha de visão) e queda no vão ou no desfiladeiro. Checkpoints `cp07_washington`, `cp07_south_crossing`, `cp07_babson`, `cp07_bank_street`, `cp07_bridge`, `cp07_cut`.

### Sistemas novos ou alterados

| Sistema | Arquivo | Observações |
|---|---|---|
| `ChapterBase` | `worlds/chapter_base.gd` | Base comum: jogador, ambiente, interação, legendas, Diário, dicas. `GilmanChapter` refatorado para herdá-la (regressão 42/42). |
| `PatrolDirector` (`sys_pursuit`) | `systems/patrol_director.gd` | Lógica pura: grupos em trilhas fixas; visibilidade = luz × andar × distância (docs/11 §4.1); cone ampliado por membro; estados espera → patrulha → suspeito → perseguição → retorno; nunca alerta sem 1 s de suspeita; perseguição vai à última posição vista e desiste após 5 s (10 s assistido); ruído alerta só o grupo mais próximo. |
| `NightChapter` | `worlds/night/night_chapter.gd`, `data/night_text.gd` | Cidade por grade de quadras de 4 m, corredor oblíquo da Eliot, portais, encosta da South até o porto, mar, recife, Bank Street, ponte, pântano, corte, estrada de Rowley, procissão. |
| `AppRoot` | `app/app_root.gd` | Escolhe o capítulo pelo checkpoint; ao terminar um capítulo inicia o seguinte; `--event=` nas capturas de QA. |
| `WorldKit.deep_one` | `worlds/world_kit.gd` | Profundo provisório segundo o cap. IV [C]; variantes comum, tiara, manto e líder. |
| Barreiras invisíveis | `WorldKit.blocker` | Camada de colisão 8: bloqueiam o jogador, não a linha de visão dos grupos. |
| Áudio provisório | `systems/sound_synth.gd` | `ph_motor`, `ph_flop` (tamborilar colossal), `ph_patter`, `ph_bats`. |

### Validação executada (0.2.0)

| Teste | Resultado |
|---|---|
| Lógica (`tests/run_tests.gd`) | **73/73** — inclui monotonicidade da percepção, esconderijo, cone, linha de visão, justiça do alerta, janela de fuga, captura, ruído e a travessia diante do bando (arrastado não é visto; andar e correr são) — [log](qa/tests-v02.log) |
| Jogada do Gilman (`tests/playthrough.gd`) | **42/42** — regressão após a refatoração e emenda VI → VII sem menu — [log](qa/playthrough-v02.log) |
| Jogada noturna (`tests/playthrough_night.gd`) | **34/34** — rota canônica completa com o robô **andando** na 2ª travessia com o andar arrastado pressionado; captura pela sentinela; queda no vão — [log](qa/playthrough-night-v02.log) |
| Export Windows 0.2.0 | 0 erros — [log](qa/export.log); SHA-256 `F9CA2EC07F9123AC6BFCED648E11F122E7D937447DFC1F685D7A4B1AF289F47C` |
| Execução gráfica do export | procissão renderizada, 0 erros |
| Revisão visual | [Washington](qa/capturas/ch07-washington.png), [South e recife](qa/capturas/ch07-south-recife.png), [bando na praça](qa/capturas/ch07-bando-praca.png), [procissão de perto](qa/capturas/ch07-procissao-perto.png), [procissão do corte](qa/capturas/ch07-procissao-corte.png), [cidade do pântano](qa/capturas/ch07-pantano-cidade.png) |

Dois defeitos reais foram encontrados e corrigidos pelas capturas e testes, não pela lógica isolada: barreiras invisíveis bloqueavam a visão dos grupos, e a grade de quadras fechava a ponta leste da South (o mar não seria visível da praça).

### NÃO validado (0.2.0)

Os mesmos limites da 0.1.0: nenhum humano jogou com teclado/mouse/controle; sons nunca ouvidos; desempenho não medido (a cena tem ~1.000 caixas e ~40 figuras animadas na procissão — medir em hardware real, docs/19); legibilidade noturna em monitores reais; ajuste fino das taxas de percepção; playtests.

### Desvios conscientes do docs/09

| Desvio | Motivo | Ação futura |
|---|---|---|
| Distâncias comprimidas: recife a ~290 m (conto: 1,5 milha); estrada de Rowley a ~27 m do corte (conto: ~100 jardas; docs/09 previa 40–60 m) | Legibilidade em baixa resolução | Ajustar em playtest |
| Trilhos seguem para o norte, não noroeste; volumetria da grade é [O] | Simplicidade da grade | Arte final |
| Rotas alternativas do §4 (quintais, beco, escada de armazém) não implementadas | Escopo | Fase 4 |
| Estado "investigar" simplificado: ruído só vira a atenção do grupo, sem deslocamento | Escopo/justiça | Avaliar em playtest |
| Uma sentinela (fim da South); demais saídas fechadas por barreiras e quadras | Sentinelas atrás de prédios não seriam vistas | Ao produzir a arte das ruas |
| O grupo de Ipswich parte 2 s após o carro, sem esperar o jogador se esconder | Ritmo; o portal ainda é a solução segura | Playtest |
| Revelações repetem por inteiro após falha (docs/09 §11 previa versão curta) | Escopo | Fase 5 |
| Oferta de Fuga assistida após 3 capturas não implementada | Escopo | Fase 5 |
| Legendas direcionais ("[quedas — à direita]") não implementadas; sons são espacializados | Escopo | Acessibilidade (16) |
| Olhos fechados falham após 18 s segurando ou 34 s de cena (docs/09: 20–30 s) | Ritmo | Playtest |

---

## Versão 0.1.0 — fatia vertical "Uma noite no Gilman House" (27/10/2026)

Autorização: pedido do usuário "faça o jogo a partir do planejamento" (27/10/2026). Seguiu-se o roadmap: Fase 1 (sistemas centrais) e o vertical slice D-009, antes de qualquer outro capítulo.

### O que é jogável

Do fim de `ch05_trap` ao fim de `ch06_gilman_escape` (docs/08), na ordem canônica do capítulo IV do conto:

1. Town Square ao crepúsculo: Sargent anuncia o defeito do ônibus; ociosos olham da porta do Gilman.
2. Saguão: funcionário da noite, quarto 428 por um dólar; jantar e jornal como elipse.
3. Quarto 428: ferrolho ausente → desaparafusar o do armário com a ferramenta do chaveiro → instalar; trancar as duas portas de ligação; lanterna da valise; jornal (`doc_evening_paper`).
4. Deitar vestido: rangidos, chave na fechadura, quartos norte e sul abertos com chave-mestra e portas de ligação testadas (sem falha possível).
5. Luz cortada, sons não humanos embaixo. Preparação: janelas, dobradiças (sul abre para dentro, norte para fora), cama contra a porta sul, cômoda contra a do corredor.
6. Cerco (`SiegeDirector`, fases S0–S8, prazos T1–T4): batidas, arrombar a porta norte com o ombro, trancar n1, empurrar e trancar n2, fechar as portas de ligação, barricadas com cama, cômoda e lavatório, aríete com painel rachando.
7. Cortinas de veludo com argolas no gancho da veneziana → telhado da Paine Street; luzes na Ordem de Dagon e nas igrejas; claraboia → sótão → escada → porta dos fundos (porta da Paine evitada).
8. Pátio: porta da rua emperrada, multidão com lanternas e figura de tiara sai do Gilman, sala vazia com venezianas → Washington Street; fechar a veneziana (opcional).

Falhas implementadas: F1–F6 e queda do telhado, com retorno a `cp06_knock`, `cp06_window`, `cp06_roof` ou `cp06_courtyard`, sem repetir diálogos ou a escuta.

### Sistemas entregues (`game/`)

| Sistema | Arquivo | Observações |
|---|---|---|
| `AppRoot` (composição, modos, pausa, modais) | `app/app_root.gd` | Sem autoloads; único ponto de composição. Modo de captura de tela para QA (`-- --capture=<cp> --out=<png>`). |
| `sys_player` / `sys_camera` | `player/player.gd` | Andar, correr (ruidoso), agachar, andar arrastado (balanço lateral visível), lanterna, raio de interação 2,3 m, controle analógico. |
| `sys_interaction` | `gameplay/interactable.gd`, `door.gd`, `pushable.gd` | Prompts e ações fornecidos pelo capítulo; portas com dobradiças visíveis do lado da abertura; móveis deslizam de forma roteirizada. |
| `sys_story_state` | `systems/story_state.gd` | Fatos, itens, documentos e checkpoints em allowlists; concessões únicas. |
| `sys_save` | `systems/save_service.gd` | JSON primitivo, `schema_version` 1, backup do anterior, escrita via arquivo temporário, recuperação de corrupção. 3 espaços previstos; a UI usa o espaço 1. |
| `sys_settings` | `systems/settings_store.gd`, `app/input_setup.gd` | Volume, sensibilidade, FOV, inversão, tamanho de texto 16–36, resolução do mundo 240/360, pontilhado, balanço de cabeça, agachar alternado, segurar em vez de martelar, fuga assistida, legendas de som, remapeamento de teclado. |
| `sys_pursuit` (`SiegeDirector`) | `systems/siege_director.gd` | Lógica pura, testada; pausa = não avançar. |
| `sys_retro_render` | `shaders/retro_post.gdshader` | Mundo em SubViewport com altura 240/360 e upscale nearest; Bayer 4×4, redução de cor, grão, vinheta. UI em resolução nativa. |
| `sys_ui` / `sys_subtitles` / `sys_journal` / `sys_documents` | `ui/ui_root.gd` | Menus, aviso de conteúdo, pausa, configurações, diálogo, leitor de documentos com A−/A+, Diário com objetivo, notas, documentos e dicas em 3 níveis; legendas de fala, pensamento e som. |
| Capítulo | `worlds/gilman/gilman_chapter.gd`, `data/gilman_text.gd` | Geometria cinza construída por código; textos PT-BR separados para localização. |

### Placeholders (todos identificados)

* Geometria: caixas e rampas geradas por `WorldKit`; personagens são silhuetas de cápsula sem rosto.
* Texturas: 64×64 procedurais (`TexFactory`), triplanares, filtragem nearest.
* Áudio: 100 % sintetizado em tempo de execução (`SoundSynth`, IDs `ph_*` e `amb_*`). Nenhum arquivo externo.
* Nenhum asset de terceiros, nenhum asset gerado por IA, nenhuma fonte externa (fonte padrão do Godot).

### Validação executada

| Teste | Comando | Resultado |
|---|---|---|
| Importação headless | `Godot --headless --path game --import` | sem erros |
| Lógica (53 verificações) | `Godot --headless --path game --script res://tests/run_tests.gd` | **53/53** — [log](qa/tests-v01.log) |
| Jogada automatizada (41 verificações) | `Godot --headless --path game --script res://tests/playthrough.gd` | **41/41** — caminho canônico completo, F1, F6 e retomada — [log](qa/playthrough-v01.log) |
| Export Windows | `Compilar.ps1` | sem erros — [log](qa/export.log); exe 0.1.0.0, SHA-256 `F42FAD2481CCDF3EDED7431D4C66BE19AC9DFBB54C3A9574D5B798B5C34BED6C` |
| Execução gráfica do export | exe com `--capture` | renderiza; 0 erros — [captura](qa/capturas/patio-export.png) |
| Revisão visual | capturas do projeto | [praça](qa/capturas/praca-crepusculo.png), [428](qa/capturas/quarto-428-crepusculo.png), [n2 ao luar](qa/capturas/quarto-n2-luar.png) |

Os testes rodaram com `%APPDATA%` apontado para `tools/qa-profile/`, sem tocar saves pessoais.

### NÃO validado (pendente de humano/hardware)

* Jogar com teclado, mouse e controle físicos; conforto da câmera; legibilidade real da noite em monitores diferentes.
* Escuta do áudio (sons provisórios nunca foram ouvidos por uma pessoa; podem estar altos, baixos ou desagradáveis).
* Ajuste fino dos prazos T1–T4 — valores do docs/08, verificados só por lógica.
* Desempenho medido (FPS, memória, carregamento) em hardware representativo (docs/19).
* Playtests com quem conhece e quem não conhece o conto (docs/23).
* Revisão de sensibilidade e jurídica (Q-002, Q-013).

### Desvios conscientes do planejamento

| Desvio | Motivo | Ação futura |
|---|---|---|
| Durante a escuta (G1) o jogador não pode se levantar (docs/08 §4.2 permitia) | Sequência roteirizada mais simples e sem estados inválidos | Reavaliar após playtest |
| Quarto `room_n3` (proposto) para a "next door to the north" [I] | Necessário para a porta de ligação "wide open" do texto | Registrado no 27 |
| Escada do saguão até o 4º andar é uma elipse com fade | Evita modelar três lances agora | Modelar na Fase 4 se o ritmo pedir |
| Jantar no restaurante é uma elipse de texto | Escopo da fatia | `lvl_restaurant` na campanha |
| Sargent e o funcionário falam por caixa de texto, sem voz | D-008 | VO de Zadok (R) apenas |
| Telas de Bolsos (I) e Mapa (M) do GDD ainda não existem; o mapa é lido pelo Diário | Nenhum item da fatia precisa de gestão | Implementar com ch03/ch07, quando o mapa vira ferramenta |
| Remapeamento cobre só o teclado; o controle usa o mapeamento padrão | Escopo da Fase 1 | Q-014 |

### Próximo passo (0.1.0)

Concluído na 0.2.0: `ch07_night`.

## Próximo passo recomendado (após 0.3.0) — concluído na 1.0.0

Os capítulos V a VIII formam um arco completo, do hotel ao fim do manuscrito. Restam os capítulos I a IV (Newburyport e a tiara, a chegada de ônibus, o passeio diurno com o mapa e o testemunho de Zadok Allen) e a moldura `ch00_frame`, o que exige a cidade de dia: o maior volume de conteúdo do jogo. Recomenda-se, antes disso, uma sessão humana de jogo da 0.3.0 para calibrar percepção, prazos, legibilidade noturna e o tom do epílogo.
