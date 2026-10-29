# 08 — A grande sequência do Gilman House

> Abrange o fim de `ch05_trap` (chegada ao quarto) e todo `ch06_gilman_escape`. É o **vertical slice** (D-009). Base: capítulo IV do conto, seguido passo a passo. Eventos (`evt_*`) e checkpoints (`cp*`) seguem `27-REGISTRO-DE-IDS.md`; IA dos perseguidores em `11`; puzzles `pz05`–`pz09` em `12`.

## 1. Objetivo de design

Recriar a sensação de que "the unseen fumbler meant a danger not to be met or dealt with, but only to be fled from" (IV). O jogador deve **raciocinar sob pressão** — ler portas, escolher rota, barricar — com interações físicas simples e confiáveis, e nunca ficar preso por um puzzle obscuro.

## 2. Planta do 4º andar (esquemática)

O texto fixa: quarto 428 "on next the top floor", nos fundos, duas janelas para oeste sobre o pátio, sem escada de incêndio, queda de três andares; portas laterais de ligação com ferrolhos; blocos de tijolo com telhado inclinado encostados ao norte e ao sul, alcançáveis apenas a partir do quarto **a duas portas** do 428 [C]. Numeração dos vizinhos não é dada; usamos IDs neutros [O].

```text
                         NORTE (Paine Street)
     telhado inclinado do bloco da Paine (abaixo, ~1 andar)  ← alcançável só pela janela de room_n2
  ┌───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐
  │   room_n2     │   room_n1     │   room_428    │   room_s1     │   room_s2     │
  │ janela S ▣    │ (sem janela   │ janela ▣ ▣    │               │ janela ▣      │  ← OESTE: pátio
  │ janela N ▣    │  útil*)       │ cama, cômoda, │               │ (telhado sul) │
  │ cama, cômoda, │ ferrolho bom  │ armário c/    │               │               │
  │ lavatório,    │               │ ferrolho      │               │               │
  │ cortinas      │               │               │               │               │
  │      ║=======n1|n2==║=======428|n1===║======428|s1===║=======s1|s2===║        │
  └──[H]──────────┴──[H]──────────┴──[H]──────────┴──[H]──────────┴──[H]──────────┘
  ═══════════════════════════ CORREDOR (escada a leste/centro) ════════════════════ banheiro (fim)
                         SUL (bloco de tijolo, Bates/Washington)

  [H] = porta para o corredor (fechadura + ferrolho)    ║=x|y=║ = porta de ligação
  428|n1: abre PARA LONGE do 428 → arrombável com o ombro [C]
  428|s1: abre NA DIREÇÃO do 428 → "not a favourable one for forcing" [C]; cama vai contra ela
  n1|n2: encontrada ENTREABERTA [C]
```

\* O texto não diz que room_n1 não tem janela; diz que, ao ficar preso nele, o narrador sente-se num "chamber with no window egress" — isto é, suas janelas não alcançam telhado [I]. No jogo, room_n1 tem uma janela com queda livre sobre o pátio, examinável, que reforça a lógica.

**Mobília interativa** (destacada só por forma e posição, sem brilho):

| Quarto | Objeto | Interação | Fidelidade |
|---|---|---|---|
| room_428 | Ferrolho do armário (clothes-press) | desaparafusar (`pz05_bolt`) | [C] |
| room_428 | Marcas do ferrolho removido na porta | examinar (`evt_missing_bolt`) | [C] |
| room_428 | Ferrolhos das duas portas laterais | trancar/destrancar | [C] |
| room_428 | Cômoda (bureau) | empurrar contra a porta do corredor | [C] |
| room_428 | Cama de ferro | empurrar contra a porta sul | [C] |
| room_428 | Interruptor da lâmpada única | ligar/desligar; inerte após `evt_power_cut` | [C] |
| room_428 | Valise | pegar a lanterna; deixar a valise | [C] |
| room_n1 | Ferrolho da porta do corredor | trancar a tempo | [C] |
| room_n1 | Pegadas na poeira (lanterna) | examinar | [C] |
| room_n2 | Porta do corredor que se abre para dentro | empurrar e trancar | [C] |
| room_n2 | Cama, cômoda, lavatório | barricadas (`pz07_barricade`) | [C] |
| room_n2 | Cortinas de veludo, varão, argolas de latão | derrubar e fazer corda (`pz08_drapery`) | [C] |
| room_n2 | Gancho saliente da veneziana | prender argolas | [C] |

## 3. Linha do tempo canônica (ordem dos acontecimentos)

| # | Acontecimento | Origem |
|---|---|---|
| 1 | Sargent anuncia defeito; quarto 428 por um dólar; três lances de escada | [C] |
| 2 | Inspeção: duas janelas, pátio, telhados para oeste, pântano; banheiro com tina de lata no fim do corredor | [C] |
| 3 | Jantar no restaurante; jornal e revista no balcão do hotel | [C] |
| 4 | Ferrolho ausente; transferência do ferrolho do armário; trancar as laterais | [C] |
| 5 | Ler sem sono; lanterna no bolso; ouvir rangidos furtivos | [C] |
| 6 | Apagar a luz; deitar vestido; chave tentada na fechadura | [C] |
| 7 | Quarto norte aberto com chave-mestra; porta de ligação testada; o mesmo ao sul; passos descem | [C] |
| 8 | Decisão de fugir sem usar escadas; luz cortada; "croakings" no andar de baixo | [C] |
| 9 | Encher os bolsos, chapéu; janelas: sem escada de incêndio; telhados a duas portas | [C] |
| 10 | Mapa: melhor saída para o sul; porta sul abre para dentro → cama contra ela; porta norte será arrombada | [C] |
| 11 | Cômoda contra a porta do corredor | [C] |
| 12 | Vista da janela: desfiladeiro, estação, trilhos, estrada de Rowley; estrada de Ipswich | [C] |
| 13 | Escada range sob peso; luz pela bandeira; batida firme, depois contínua | [C] |
| 14 | Arrombar a porta norte com o ombro esquerdo; estrondo; batidas viram golpes; chaves nas portas vizinhas | [C] |
| 15 | Em room_n1, trancar a porta do corredor antes da chave; chave-mestra na porta de room_n2 | [C] |
| 16 | Desespero; empurrar a porta n1–n2: entreaberta; joelho e ombro contra a porta de n2 que se abria; trancar | [C] |
| 17 | Golpes cedem; ruído na porta protegida pela cama (sul); depois chave na porta norte seguinte | [I] o texto cita "the next door to the north" |
| 18 | Fechar e trancar portas de ligação; cama contra uma, cômoda contra outra, lavatório diante da porta do corredor | [C] |
| 19 | Nenhum perseguidor emite som vocal inteligível | [C] |
| 20 | Corrida no corredor; concentração contra a porta de ligação; aríete; painel racha | [C] |
| 21 | Janela mais ao sul; cortinas com argolas; gancho da veneziana; descida | [C] |
| 22 | Telhado de ardósia solta; claraboia; luzes na Ordem, igreja batista e congregacional | [C] |
| 23 | Queda curta para o sótão com caixas e barris; relógio: 2h | [C] |
| 24 | Escada até o térreo; porta da Paine em ruína ao fundo; porta dos fundos para o pátio | [C] |
| 25 | Pátio sem luar; janelas do Gilman acesas; portas do lado da Washington; porta da rua emperrada | [C] |
| 26 | Multidão sai do Gilman com lanternas, figura com tiara; não sabem onde ele está | [C] |
| 27 | Sala vazia com venezianas e sem caixilhos; sair à Washington e fechar a veneziana | [C] |

## 4. Estrutura jogável e escalada de tensão

| Fase | Capítulo | Duração-alvo | Perigo real | Intensidade (0–5) |
|---|---|---|---|---|
| G0 Quarto e inspeção (1–5) | ch05 | 4–6 min | não | 2 |
| G1 Escuro e escuta (6–7) | ch05 | 2–3 min | não (roteirizado) | 3 |
| G2 Preparação (8–12) | ch06 | 2–4 min, sem limite rígido | não até G3 | 3–4 |
| G3 Cerco (13–20) | ch06 | 2–4 min | **sim** | 5 |
| G4 Descida (21–22) | ch06 | 0,5–1 min | sim (tempo) | 4 |
| G5 Armazém e pátio (23–27) | ch06 | 2–4 min | sim | 4 |

G0–G1 não permitem falha: o perigo é anunciado, não executado. A transição para G3 só ocorre quando o jogador conclui a preparação mínima **ou** após um tempo máximo (ver §5), para que o jogador cuidadoso não seja punido e o hesitante não fique parado sem tensão.

### 4.1 G0 — O quarto (`cp05_room`)

O jogador recebe o quarto com a valise. Pode examinar as janelas (vista oeste [C]), o armário, a cama, as portas laterais e o banheiro. A primeira visita à porta do corredor dispara `evt_missing_bolt`; o Diário anota as marcas recentes. `pz05_bolt` é a única ação obrigatória. Ler o jornal (`doc_evening_paper`) é opcional e serve de descanso.

### 4.2 G1 — O escuro

Após trancar tudo e apagar a luz (o jogo pede apenas que o jogador "deite" na cama — interação; deitar com a luz acesa também é permitido e o narrador a apaga sozinho, [C] "turned off the light"), começa `evt_corridor_creaks` (passos furtivos, sem vozes). Segue `evt_key_in_lock`: som de chave tentando a fechadura, a maçaneta mexe, o ferrolho segura. Depois `evt_connecting_tries`: porta norte, depois sul, a partir dos quartos vizinhos; passos descem a escada. O jogador pode levantar e andar durante G1; se encostar na porta do corredor, ouve respiração do outro lado (legenda de som). Nada pode acontecer de errado aqui.

### 4.3 G2 — Preparação

Ao levantar após `evt_connecting_tries`, `evt_power_cut`: o interruptor não funciona [C]. Diário: "Fugir. Não pelas escadas." Objetivos implícitos, revelados só no Diário e por comentário curto do narrador:

1. Pegar a lanterna na valise (obrigatório para examinar no escuro; o luar das janelas permite andar sem ela).
2. Examinar as janelas → descobre que só um quarto a duas portas alcança os telhados (`pz06_hinges`, parte A).
3. Consultar o mapa → a saída é para o sul... mas
4. Examinar as dobradiças das portas laterais → sul abre para dentro (não arrombável), norte abre para fora (arrombável) (`pz06_hinges`, parte B). Escolher o norte.
5. Cama contra a porta sul; cômoda contra a porta do corredor (`pz07_barricade`, parte A).

Se o jogador fizer 4–5 rapidamente, o cerco começa logo; se demorar, começa no tempo máximo (§5). Tentar arrombar a porta sul produz o feedback físico de uma porta que bate contra o batente: o narrador diz que ela abre "na minha direção" e desiste [C].

### 4.4 G3 — Cerco (`cp06_knock`)

`evt_knocking`: primeiro uma batida firme, depois contínua. **Arrombar** a porta norte: interação de golpes de ombro (padrão: pressionar repetidamente; acessibilidade: segurar). Cada golpe faz barulho e o `SiegeDirector` avança. Ao ceder: `evt_passkeys` — chaves nas portas do corredor dos quartos vizinhos. Em room_n1 o jogador deve **trancar o ferrolho da porta do corredor** antes que a chave gire (janela de tempo generosa; ver §5). Então ouve a chave na porta de room_n2 ("the hall door of the third room"). Ao empurrar a porta n1–n2, ela está entreaberta; em room_n2 a porta do corredor **já está abrindo para dentro**: o jogador empurra (interação de contato, segurar) e tranca. Em seguida barricadas: fechar/trancar as portas de ligação; cama contra uma, cômoda contra outra, lavatório diante da porta do corredor. `evt_ram`: aríete contra a porta de ligação; o painel racha progressivamente. Nenhum perseguidor fala; apenas ofegos, grunhidos e latidos abafados (ver 15).

### 4.5 G4 — Descida (`cp06_window`)

Janela mais ao sul de room_n2 (examinar mostra o telhado íngreme e a altura perigosa do salto). `pz08_drapery`: derrubar cortinas com varão → prender duas argolas no gancho da veneziana → lançar para fora → descer. Saltar sem corda é possível e tem 100 % de falha por queda no escorregadio telhado (o jogo avisa pelo comentário do narrador antes: "o salto seria desesperadamente arriscado"; a falha leva a `cp06_window`, sem morte gráfica).

### 4.6 G5 — Armazém e pátio (`cp06_roof`, `cp06_courtyard`)

Telhado: ardósias soltas (andar cauteloso evita escorregar; correr provoca um escorregão roteirizado que se recupera — susto, não falha). `evt_church_lights` ao norte. Claraboia sem escada: pular para dentro. Relógio marca 2h quando o jogador o consulta (`item_watch`). Escada rangente até o térreo; ao fundo a porta da Paine (luminosa, evitar: fogo/bombeiros [C]); porta dos fundos → pátio (`cp06_courtyard`). Do lado da Washington há vários portões; o mais próximo leva a um corredor cuja porta da rua está **emperrada** (`pz09_courtyard`). Voltando ao pátio, `evt_courtyard_crowd`: multidão com lanternas sai do Gilman; o jogador deve ficar fora do alcance das lanternas, entrar por outra porta, achar a sala com venezianas, abrir, sair e **fechar a veneziana** (ação opcional que reduz a chance de a patrulha seguir o rastro no começo de ch07 [C "carefully closing the aperture"]). Chegar à Washington encerra ch06.

## 5. SiegeDirector — sincronização justa

O `SiegeDirector` (parte de `sys_pursuit`, contrato em 17 e estados em 11) controla a ameaça por **fases**, cada uma avançada pelo progresso do jogador com limites de tempo mínimo e máximo. O perigo nunca é mais rápido que um jogador razoável, e nunca para indefinidamente.

| Fase | Entra quando | Tempo mínimo antes de avançar | Tempo máximo (avanço forçado) | Falha possível |
|---|---|---|---|---|
| S0 Silêncio | `evt_power_cut` | — | — | não |
| S1 Batida | preparação mínima feita (porta sul bloqueada **ou** porta norte escolhida) | 20 s após S0 | 180 s após S0 | não |
| S2 Batida contínua | 8 s em S1 | — | — | não |
| S3 Golpes no corredor | primeiro golpe do jogador na porta norte | — | 60 s em S2 sem golpe → golpes começam | **sim**, ver T1 |
| S4 Chaves vizinhas | porta norte cede | — | — | sim, T2 |
| S5 Chave em n2 | ferrolho de n1 trancado | 3 s | — | sim, T3 |
| S6 Ataque lateral | porta de n2 trancada | 6 s | — | não |
| S7 Aríete | primeira barricada em n2 | — | 25 s em S6 | sim, T4 |
| S8 Ruptura | — | — | 40–70 s em S7, ajustado pelo número de barricadas | sim |

Janelas de reação (padrão / modo **Fuga assistida**, ver 16):

| Teste | Situação | Prazo padrão | Prazo assistido |
|---|---|---|---|
| T1 | Porta do 428 cede sob golpes se o jogador nunca arrombar a norte | 45 s em S3 (porta reforçada pela cômoda: +20 s) | +50 % |
| T2 | Trancar o ferrolho de room_n1 antes da chave girar | 6 s | 12 s |
| T3 | Empurrar e trancar a porta de room_n2 | 5 s | 10 s |
| T4 | Descer pela cortina antes da ruptura | depende de S8 (cada barricada +15 s) | +50 % |

Regras de justiça:

1. Todo prazo é anunciado por som claro (chave no metal, maçaneta girando) e por legenda de som, nunca só por música.
2. O diretor **não** avança enquanto o jogo está pausado ou um documento está aberto (D: pausa interrompe perigo).
3. Se o jogador falhar duas vezes no mesmo teste, o diretor aplica +25 % ao prazo daquele teste nas tentativas seguintes (memória de falhas transitória, não salva).
4. Abrir o mapa ou o Diário também pausa o diretor (regra 2); nenhum prazo depende de o jogador consultá-los, e a consulta útil acontece em G2.
5. Nenhum perseguidor é visto dentro do hotel. A captura é representada por porta arrombada, luz de lanterna entrando, corte para preto e som (sem violência gráfica).

## 6. Situações de falha

| Falha | Gatilho | Representação | Retorno |
|---|---|---|---|
| F1 Porta do corredor arrombada | T1 | porta cede, lanternas, corte | `cp06_knock` |
| F2 Chave gira em n1 | T2 | porta abre, figura na luz, corte | `cp06_knock` |
| F3 Porta de n2 aberta | T3 | idem | `cp06_knock` |
| F4 Ruptura antes da descida | T4 | painel cede, corte | `cp06_window` |
| F5 Salto sem corda | — | escorrega no telhado, queda, corte | `cp06_window` |
| F6 Visto no pátio | perto demais das lanternas (ver 11) | lanternas convergem, corte | `cp06_courtyard` |

## 7. Checkpoints e repetição

| Checkpoint | Estado restaurado | O que **não** se repete |
|---|---|---|
| `cp06_knock` | quarto com ferrolho instalado, laterais trancadas, cama contra a porta sul, cômoda contra a porta do corredor, lanterna no bolso, luz cortada; jogador de pé junto à porta norte | inspeção, jantar, jornal, `evt_key_in_lock`, `evt_connecting_tries`, `evt_power_cut`; a batida recomeça em 3 s |
| `cp06_window` | room_n2 com barricadas mínimas já feitas, aríete em curso a ritmo inicial | arrombamento e trancas |
| `cp06_roof` | no telhado junto à claraboia | descida |
| `cp06_courtyard` | porta dos fundos do armazém | telhado, sótão |

Se o jogador chegar a `cp06_knock` sem ter feito a preparação opcional (cômoda), o checkpoint a registra como feita, para que a repetição comece sempre do estado justo mínimo. Nenhum diálogo precisa ser repetido em nenhuma tentativa.

## 8. Transição para a rua

Sair pela veneziana para a Washington: luar, nenhuma luz de rua [C "all the street-lights were turned off"]. Sons distantes de vozes e "pattering". O Diário registra "Rumo ao sul pela Washington" e começa `ch07_night` em `cp07_washington` sem tela de carregamento (o pátio e a Washington pertencem a `lvl_gilman_exterior_escape` e `dist_south_residential`, carregados juntos, ver 07).

## 9. Produção com placeholders

Geometria cinza dos cinco quartos com portas funcionais (dobradiças visíveis em modelo simples), móveis como caixas com volume correto, cortina como plano com argolas, telhado como rampa, claraboia como abertura; perseguidores representados apenas por áudio provisório identificado (`ph_`) e luz de lanterna. A sequência inteira é testável sem nenhum modelo de personagem.

## 10. Critérios de aceitação do slice (complementa 20/23)

1. Um jogador que leu o conto e um que não leu conseguem concluir sem dicas externas em ≤ 3 tentativas (meta de playtest, não medida).
2. Todas as falhas retornam a um checkpoint em ≤ 5 s de carregamento (meta a medir).
3. A ordem dos 27 acontecimentos de §3 é preservada em toda execução bem-sucedida.
4. Nenhuma pista obrigatória depende só de áudio: dobradiças visíveis, legendas de som, comentários no Diário.
