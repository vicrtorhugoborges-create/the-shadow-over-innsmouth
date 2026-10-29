# 09 — A fuga noturna

> Documento dedicado a `ch07_night`, da Washington Street (`cp07_washington`) ao desmaio no corte de mato (`evt_rowley_procession`). Base: capítulo IV do conto. Geografia em `06`; distritos em `07`; IA em `11`; mecânicas em `12`; luz em `14`; som em `15`.

## 1. Objetivo de design

A perseguição deve **parecer coordenada** — a cidade inteira fechando as saídas — sem exigir IA sofisticada. O jogador reconhece ruas, a cúpula e o mapa do dia; a familiaridade vira ameaça. O clímax não é uma batalha: é ver.

Princípio central [C]: os perseguidores "had not seen me, but was simply obeying a general plan of cutting off my escape". Portanto a maior parte do perigo é **posicional e roteirizada** (grupos que atravessam pontos conhecidos), não caça livre.

## 2. Objetivos sequenciais

| # | Objetivo (Diário, voz do narrador) | Trecho | Checkpoint | Fidelidade |
|---|---|---|---|---|
| O1 | "Rumo ao sul pela Washington, longe da praça." | Washington → Bates | `cp07_washington` | [C] |
| O2 | "Atravessar o espaço aberto da South sem chamar atenção." | praça Eliot×Washington×South | `cp07_south_crossing` | [C] |
| O3 | "A estrada do sul está bloqueada. Esconder-me e pensar." | portal após a praça | — | [C] |
| O4 | "A velha ferrovia para Rowley. Chegar à estação pelo mapa." | Babson → Lafayette → Eliot → South (2ª travessia) → Bates → Adams | `cp07_babson` | [C] |
| O5 | "Bank Street, junto ao desfiladeiro." | Bank Street → estação | `cp07_bank_street` | [C] |
| O6 | "Atravessar a ponte coberta." | trilhos → ponte | `cp07_bridge` | [C] |
| O7 | "Seguir os trilhos pelo pântano, escondido." | River Street → aterro → corte | `cp07_cut` | [C] |
| O8 | "Não olhar." | procissão | — | [C] |

## 3. Rota principal (canônica) passo a passo

| Passo | Local | O que acontece | Evento | Ameaça |
|---|---|---|---|---|
| 1 | Washington, saída da veneziana | Luar, nenhuma luz de rua; vozes, passos e "pattering" de várias direções; alguns sons vêm do sul | — | baixa |
| 2 | Bates Street | Duas figuras arrastadas cruzam à frente; esconder-se num vestíbulo | `evt_bates_hide` | média (falha possível) |
| 3 | Praça Eliot×Washington×South | Espaço banhado de luar com jardim gradeado; não há rota alternativa; atravessar **com andar arrastado** | — | média |
| 4 | Boca da South Street | Vista do mar ao fim da rua larga; clarões no recife; resposta da cúpula do Gilman a nordeste; o mar cheio de nadadores | `evt_reef_signals`, `evt_swimmers` | revelação |
| 5 | Alguns metros ao sul | O narrador corre em pânico; "hue and cry" à esquerda; motor descendo a Federal | `evt_federal_motor` | alta (roteirizada) |
| 6 | Portal escuro | Esconder-se; o narrador conclui que todas as estradas estão vigiadas; consulta o mapa à lanterna dentro do vestíbulo; plano da ferrovia | — | nenhuma (seguro) |
| 7 | Babson Street | Rente às casas; casa habitada com cortinas sem luz; duas pausas em portais | — | média |
| 8 | Babson, segunda pausa | Carro cruza o espaço aberto rumo à Eliot; bando agachado segue; duas figuras de manto, uma com diadema que brilha; andar quase saltitante | `evt_ipswich_party` | observação |
| 9 | Lafayette, cruzar a Eliot | Travessia rápida; possíveis retardatários | — | média |
| 10 | South Street, 2ª travessia | Andar arrastado; olhar de lado: bote com carga sob lona rumo aos cais; nadadores; brilho constante de cor indefinida no recife; cúpula agora escura | `evt_rowboat` | média |
| 11 | South Street, ainda na travessia | Bando vindo da Washington a uma quadra: rostos bestiais, um homem simiesco com braços longos tocando o chão [C — ver ressalva em 10 §5], figura de manto e tiara saltitante; algumas cabeças se viram; manter o passo | `evt_washington_band` | **alta** (teste) |
| 12 | Bates (lado sul) | Duas casas habitadas, uma com luz no andar de cima | — | baixa |
| 13 | Adams Street | Um homem bêbado sai de uma porta escura à frente; não é ameaça | `evt_drunk_adams` | susto |
| 14 | Bank Street | Armazéns enormes; quedas abafam os passos; longa corrida | — | nenhuma |
| 15 | Estação em arcadas | Trilhos a partir do fim da estação | — | — |
| 16 | Trilhos à beira do desfiladeiro | Dormentes podres, metade faltando; andar é difícil | — | ambiental |
| 17 | Ponte coberta | Lanterna liberada; nuvem de morcegos; vão nos dormentes no meio; salto | `evt_bats`, `pz11_bridge_gap` | queda |
| 18 | River Street | Trilhos cruzam em nível; mato e espinheiros rasgam a roupa | — | baixa |
| 19 | Aterro no pântano | Linha sobre aterro baixo; parte visível da estrada de Rowley | — | baixa |
| 20 | Antes do corte | Olhar para trás: a cidade "lovely and ethereal" ao luar; ao sul, coluna ondulante na estrada de Ipswich | `evt_ipswich_column` | revelação distante |
| 21 | Corte de mato | Vento vira para leste; odor; sons guturais; "colossal flopping"; a horda vem pela estrada de Rowley, que cruza a linha a ~100 jardas | `evt_wind_shift` | — |
| 22 | Corte, agachado | Manter os olhos fechados; abrir é inevitável; a procissão; desmaio | `evt_rowley_procession` | revelação máxima |

## 4. Rotas alternativas justificadas

O conto define uma rota única; o jogo oferece **variantes curtas** dentro dos mesmos trechos para que o jogador tome decisões, todas convergindo nos mesmos pontos canônicos. Nenhuma variante pula um evento obrigatório.

| Trecho | Variante | Justificativa | Custo/risco |
|---|---|---|---|
| Washington → Bates | Atravessar o pátio do bloco vizinho em vez da calçada | O narrador planeja "dart through the courtyard and the adjacent or opposite buildings to Washington or Bates" [C] | Mais escuro, mais lento, entulho barulhento |
| Babson | Quintais dos fundos em vez da calçada | [O] coerente com "clung as closely as possible to the sagging, uneven buildings" | Cerca baixa a pular (barulho) |
| Lafayette → Bates | Beco entre Lafayette e Bates | [O] o percurso canônico é em "zigzagging line" | Sem luar; tábuas soltas e lixo que rangem sob passo rápido |
| Adams → Bank | Escada externa de um armazém | [O] | Rangido, rota mais curta |

Barreiras que impedem sair da rota: escombros, cercas altas, ruas iluminadas pelo luar com um grupo parado ao fundo (visível, não ativo: "a rua está vigiada"), o desfiladeiro. A Federal e as estradas nunca são acessíveis [C].

## 5. Patrulhas e grupos

| Grupo | Composição | Comportamento | Onde | Fidelidade |
|---|---|---|---|---|
| `pur_courtyard_party` | 6–8, lanternas, figura de tiara (`npc_tiara_priest`) | Sai do pátio, desce a Washington; reaparece no passo 11 vindo do norte | pátio, Washington, South | [C] |
| `pur_ipswich_party` | carro + 8–10 a pé, duas de manto, uma de diadema | Atravessa a praça da Eliot em direção à estrada de Ipswich; não procura, guarda | passo 8 | [C] |
| `pur_federal_motor` | carro + vozes | Desce a Federal; ouvido, entrevisto entre casas | passo 5 | [C] |
| Duplas avulsas | 2 `res_wary` | Cruzam esquinas em horários fixos | Bates (passo 2), retardatários da Eliot | [C] passo 2; [O] retardatários |
| Sentinelas paradas | 2–3 com lanterna, imóveis ao fundo de ruas laterais | Barreira visual de rota | ruas laterais | [O] |

Todos são **roteirizados**: entram por gatilhos de posição do jogador e percorrem caminhos fixos com variação mínima de velocidade (±10 %). O `PatrolDirector` (11) apenas: (a) dispara grupos quando o jogador chega a gatilhos; (b) segura um grupo se o jogador ainda não estiver escondido num ponto obrigatório; (c) resolve detecção.

## 6. Esconderijos

| Tipo | Exemplos | Efeito |
|---|---|---|
| Vestíbulo/portal | Bates (passo 2), portal do passo 6, duas pausas na Babson | Dentro do volume e agachado/parado: invisível a grupos que passam na rua |
| Sombra de beiral | Lado sul da Bates, Babson | Reduz visibilidade a metade se andar cauteloso ou parado |
| Mato alto | Trilhos, aterro, corte | Agachado: invisível à estrada de Rowley |
| Interior do armazém/ponte | Ponte coberta | Sem patrulhas |

Os esconderijos obrigatórios (passo 2, passo 6, corte) têm moldura arquitetônica evidente (porta funda, arco) e o narrador olha para eles automaticamente com um leve giro de cabeça opcional (desativável) quando o som do grupo começa.

## 7. Condições de detecção e consequências

Regras de percepção em `11`. Resumo para o design:

| Situação | Detecção |
|---|---|
| Em zona de luar, correndo | Imediata por qualquer grupo com linha de visão |
| Em zona de luar, andando normal | Suspeita crescente (≈ 2 s de exposição a um grupo próximo) |
| Em zona de luar, **andar arrastado** | Muito lenta; grupos a mais de uma quadra não reagem [C "my stratagem must have deceived them"] |
| Na sombra, andando cauteloso | Apenas a muito curta distância |
| Lanterna acesa na rua | Detecção a grande distância (exceto na ponte coberta) |
| Ruído (cerca, entulho, correr) | Atrai o grupo mais próximo a investigar o ponto do som |

**Consequência de ser visto:** o grupo emite um chamado gutural, acelera e converge; outros sons se aproximam. O jogador tem uma **janela de fuga curta** (4–6 s padrão, dobro no modo assistido) para quebrar a linha de visão entrando num esconderijo; se conseguir, o grupo "investiga" e volta à rota. Se não, captura: lanternas, corte para preto, retorno ao último checkpoint de ch07. Não há luta nem morte gráfica.

**Teste do passo 11 (`evt_washington_band`).** O bando cruza a uma quadra; algumas cabeças se viram. Se o jogador mantiver o andar arrastado (ou andar e não correr, no modo assistido), o bando segue [C "they passed on across the moonlit space without varying their course"]. Se correr ou acender a lanterna, é detectado. Parar é permitido (o narrador fica "transfixed with fright") e conta como arrastado se já estava no passo.

## 8. Sons de orientação e sinais do recife

| Sinal | Função | Acessibilidade |
|---|---|---|
| Rugido das quedas | Bússola sonora: indica o desfiladeiro ao norte/oeste | Legenda direcional "[quedas — à direita]" |
| Silêncio dos sinos | Nenhum sino toca à noite [O]; o contraste com o dia reforça a estranheza | — |
| Motor na Federal | Indica a estrada do sul bloqueada | Legenda |
| "Pattering" e coaxar | Proximidade de grupos | Legenda + indicador de direção opcional |
| Clarões no recife e resposta da cúpula | Revelação; também lembram onde fica o leste e o Gilman | Visual alto contraste; não é pista obrigatória |
| Brilho constante no recife (cor indefinida) | Escalada | — |

## 9. Transição ao pântano

`dist_bank_station` → `lvl_railway_marsh` troca de cena na saída da estação (gargalo: arcada e trilhos). O odor de peixe diminui [C] (representado por desaparecimento da camada de ambiência "cidade" e névoa mais clara). A cidade passa a ser um impostor de skyline (13/19). No aterro, a estrada de Rowley é visível em trechos; o mato dá cobertura.

## 10. A revelação dos Profundos (`evt_rowley_procession`)

### 10.1 Construção em camadas

1. **Ausência (passo 20):** a coluna ondulante distante na estrada de Ipswich — um único cartão animado/linha de partículas cintilantes no horizonte, sem formas.
2. **Cheiro e vento (passo 21):** a ambiência muda de direção; névoa se adensa vindo do leste.
3. **Som (passo 21–22):** murmúrios guturais, depois babel de coaxar, latir e balir "without the least suggestion of human speech" [C], e o "flopping or pattering" maciço; vibração leve opcional.
4. **Olhos fechados (passo 22):** o jogador é convidado (prompt único, depois só a ação) a **segurar** "Fechar os olhos". Tela escura com vinheta; o som vem para a frente, espacializado da esquerda para o centro. Soltar abre os olhos. Mesmo segurando, após 20–30 s o fechamento falha sozinho, em fade involuntário: "Of course my resolution to keep my eyes shut had failed" [C]. Quem não segurar vê antes; o evento é o mesmo.
5. **Visão:** a procissão cruza a linha onde as paredes do corte se aplainam, sob a lua amarela que "leering" [C]. O líder de casaco preto corcunda, calças listradas e chapéu de feltro passa primeiro; depois tiaras, mantos, a massa. O jogador pode olhar livremente por ~15–25 s (ou até reter o olhar sobre o líder por 3 s).
6. **Desmaio:** apagamento suave da imagem e do som; tela preta; fim de ch07.

### 10.2 Multidão de baixo custo

| Técnica | Uso |
|---|---|
| Grupos de 6–12 modelos `deep_procession` com instancing e 3 variações de malha/tiara/manto | Primeiro plano e plano médio (~100 jardas, compressas para ~40–60 m em jogo) |
| Loops de animação defasados (salto bípede, apoio quádruplo, transição) com velocidade ±15 % | Evita sincronia robótica |
| Caminho em spline com deslocamentos laterais aleatórios fixos por instância (seed estável) | Determinismo para teste |
| Cartões/billboards de silhuetas animadas em 2–3 camadas atrás | "limitless stream" |
| Névoa e luar recortando silhuetas; ventres brancos captam a luz | Leitura de forma sem detalhe |
| Som maciço em camadas (perto, médio, distante) | A multidão é percebida mais pelo som que pela contagem |
| Enquadramento: borda do corte limita o campo de visão a uma faixa | O jogador nunca vê o início nem o fim |

Meta de orçamento (não medida): ≤ 40 personagens animados reais simultâneos + cartões; ver 19.

### 10.3 O que não fazer

Não há perseguição, ataque, câmera tremendo sem opção, close-up de rosto, grito de susto, nem combate. O jogador **não pode** ser detectado durante a procissão (estado seguro roteirizado: "they could not, except by a malign miracle, see me" [C]); levantar-se e correr está desabilitado após o início dos sons — o narrador está paralisado (o movimento volta a ser só olhar).

## 11. Falhas e checkpoints

| Falha | Onde | Retorno |
|---|---|---|
| Capturado após detecção | passos 1–3 | `cp07_washington` / `cp07_south_crossing` |
| Detectado na 2ª travessia ou pelo bando | passos 7–11 | `cp07_babson` |
| Queda no vão da ponte | passo 17 | `cp07_bridge` |
| Qualquer outra | trilhos | `cp07_bank_street` |

Repetir um checkpoint não repete revelações já vistas como "primeira vez": `evt_reef_signals` e `evt_swimmers` repetem com duração reduzida (versão curta) se o jogador falhar depois deles; `evt_rowley_procession` é sem falha.

## 12. Duração e produção

Duração-alvo 30–45 min (inclui erros). Placeholder: ruas do kit cinza, grupos como cápsulas com lanterna, procissão como cápsulas instanciadas + cartões pretos, áudio `ph_`. Todos os gatilhos e esconderijos são testáveis sem arte final.
