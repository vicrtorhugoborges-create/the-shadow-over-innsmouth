# 15 — Design de áudio

> **Estado:** proposta. Metas de loudness, número de vozes e formatos são pontos de partida; nada foi produzido ou medido. Todo áudio atual é inexistente; o provisório deverá ser identificado (`ph_`).

## 1. Princípios

1. **O som antecede a imagem.** Em quase toda revelação do conto o narrador **ouve** antes de ver: quedas d'água, sinos, rangidos, chave na fechadura, croaks, o "flopping or pattering" da procissão [C].
2. **Silêncio é material.** Ruas do sul "not a sound ... save the lapping of the harbour tides and the roar of the falls" [C] (ch. II). Áreas vazias recebem quase nada — o que torna cada som significativo.
3. **Coerência causal.** Nenhum som de susto aleatório. Todo evento sonoro tem fonte justificada no mundo ou na mente do narrador (catálogo de eventos em 05).
4. **Acessibilidade.** Toda pista sonora obrigatória possui legenda de som e alternativa visual (16).

## 2. Ambiente (§18.1)

| Camada | Onde | Comportamento | Fidelidade |
|---|---|---|---|
| Vento costeiro | toda a costa; telhados ch06; corte ch07 | intensidade por perfil; muda de direção em `evt_wind_shift` | [C] |
| Ondas e maré | orla, cais de Zadok | ritmo lento; `evt_tide_turn` aumenta força e frequência | [C] |
| Gaivotas | Newburyport, praia na chegada | **ausentes** dentro de Innsmouth (como cães e gatos, [C] ausência de animais) | [I] |
| Quedas do Manuxet | `dist_gorge`, ponte, Bank Street | ruído alto e constante; à noite mascara passos (ch07) | [C] |
| Madeiras e cordas | cais, casas arruinadas | rangidos esparsos com fonte posicional | [O] detalhe |
| Água sob pontes | pontes da Federal, Main, Water | loop espacial | [C] |
| Tubulações | Gilman: banheiro e corredor | gotejos, gemidos de cano | [O] |
| Portas | todas | conjunto por tipo (interior leve, hotel, rua pesada) | — |
| Passos | jogador e NPCs | por superfície: paralelepípedo, tijolo, tábua, cascalho, dormente, lama, capim | — |
| Quartos adjacentes | Gilman | sons atrás de paredes com filtro passa-baixa | [C] |
| Sinos | igreja gótica (11h, 15h) | sino rachado, "cracked bell", "raucous" | [C] |
| Indústria distante | refinaria | quase ausente — "oddly free from the noise of industry" [C] | [C] |
| Silêncio de rua | sul abandonado | só maré e quedas | [C] |
| Newburyport | estação, praça | cidade viva: bonde, conversas, motores | [I] contraste |
| Arkham/Cleveland | interiores | relógio, rua distante, casa | [O] |

**Sons em casas tapadas** (`evt_boarded_sounds`): rangidos, correria, ruídos roucos [C] vindos **mais forte** das fachadas mais fechadas — regra de posicionamento explícita.

## 3. Habitantes e criaturas (§18.2)

| Tipo | Descrição | Produção |
|---|---|---|
| Vozes humanas comuns | Newburyport, Arkham, Cleveland: fala normal (texto + vocalizações curtas) | gravação de atores ou biblioteca licenciada |
| Vozes de Innsmouth | "throaty", gutural, poucas palavras; o narrador evita ouvi-las [C] | atores + leve processamento; **nunca** sotaque real de um grupo humano como marca de monstruosidade |
| Conversas abafadas | grupos na porta do Gilman (`evt_gilman_crowd`), "faint guttural words in a language ... not English" [C] | linguagem inventada sem relação com idiomas reais, filtrada |
| Murmúrios | patrulhas à distância | loops curtos posicionais |
| Passos irregulares | passo arrastado ("shambling") com arrasto de sola | foley |
| Respiração | perseguidores "pantings, gruntings, and subdued barkings" [C] | foley + processamento |
| Vocalizações dos Profundos | "croaking, baying ... bleating" [C]; "held all the dark shades of expression" [C] | **processamento de fontes licenciadas** (vozes humanas, anfíbios, aves marinhas, animais de fazenda) por pitch, granular, filtros; nunca uma única fonte reconhecível |
| Movimento coletivo | "colossal flopping or pattering" [C] | camadas de foley úmido (panos molhados, palmas em água, pés descalços em lama) espacializadas em largura |
| Sinais do mar | ao luar, distantes | tons graves ambíguos, quase infra; sem "melodia" |
| Zadok | voz aguda e chiada, "high, wheezy" [C] | VO nível R (D-008) |

O narrador nunca fala em voz alta em gravação (texto apenas), exceto respiração e esforço.

## 4. Música (§18.3)

| Opção | Prós | Contras | Uso recomendado |
|---|---|---|---|
| Drones atmosféricos | baratos, sustentam tensão, mesclam com ambiente | monotonia se constantes | **Sim**, em camadas finas, por estado (ver 4.1) |
| Ambiente minimalista | dá identidade e beleza (Innsmouth "lovely" ao entardecer) | pode suavizar o medo | **Sim**, poucos temas: Newburyport, entardecer, epílogo |
| Ruído musical dissonante | eficaz em picos | cansa, vira clichê | **Pontual**: hotel após `evt_power_cut`, procissão |
| Ausência total | maximiza som diegético | exige ambientes excelentes | **Sim**, maior parte de ch03, ch05 até a chave, ch07 nas ruas |
| Temas de revelação | memória emocional | risco de "ponto de exclamação" | **Um motivo** de 3–5 notas ligado à tiara, que retorna no cofre e no final, cada vez mais consonante |

**Recomendação:** música rara e quase sempre não percebida como música. Nenhuma trilha de ação. O motivo da tiara é a assinatura sonora do jogo e realiza a mudança de significado do final: dissonante em ch01, ameaçador em ch07, **acolhedor e grandioso** em `evt_final_descent`.

### 4.1 Estados musicais

| Estado | Onde | Conteúdo |
|---|---|---|
| `silence` | padrão | nada |
| `unease` | ch02–ch03 em pontos-chave | drone grave, muito baixo |
| `testimony` | ch04 | drone que acompanha a maré; pausa nas pausas de Zadok |
| `siege` | ch06 | pulso irregular grave + dissonância; nunca cobre as batidas |
| `exposure` | ch07 espaços abertos | drone alto agudo fino |
| `revelation` | `evt_tiara_reveal`, `evt_rowley_procession`, `evt_vault_tiara` | motivo da tiara |
| `domestic` | ch08 dia | piano/cordas esparsos de época (ou silêncio) |
| `dream` | ch08f–g | coro processado, reverberação submarina |

Os nomes de estado são internos de `sys_audio` e não exigem IDs persistentes.

## 5. Mapa de eventos sonoros críticos

| Evento | Som principal | Legenda de som (exemplo) |
|---|---|---|
| `evt_basement_priest` | sino rachado das 11h | [Sino rachado bate onze vezes] |
| `evt_zadok_shriek` | grito + onda contra o cais | [Zadok grita] [Onda bate no cais] |
| `evt_key_in_lock` | chave testando a fechadura | [Uma chave tenta a fechadura] |
| `evt_connecting_tries` | maçaneta da porta de ligação, norte e depois sul | [Porta de ligação ao norte é testada] |
| `evt_power_cut` | estalo do interruptor sem luz; croaks abaixo | [Interruptor estala. Nada.] [Vozes roucas no andar de baixo] |
| `evt_knocking` | batida firme → contínua | [Batidas firmes à porta] |
| `evt_passkeys` | chaves nas portas vizinhas | [Chaves nas portas dos quartos vizinhos] |
| `evt_ram` | aríete na porta de ligação, madeira lascando | [Algo pesado golpeia a porta norte] |
| `evt_federal_motor` | motor chiando na Federal | [Motor ao longe, rumo ao sul] |
| `evt_rowley_procession` | coro de croaks/balidos, chão tremendo | [Dezenas de vozes coaxam e balem] [Passos pesados, molhados] |

## 6. Produção (§18.4)

### 6.1 Formatos

| Tipo | Formato de entrega | Taxa | Observações |
|---|---|---|---|
| Masters | WAV 24-bit | 48 kHz | fora da build; arquivados |
| SFX curtos | WAV 16-bit mono | 44,1 ou 48 kHz (uma só taxa no projeto, decidir no protótipo) | baixa latência |
| Ambientes/loops | OGG Vorbis estéreo ou mono | idem | loop sem clique, ponto de loop marcado |
| Música | OGG Vorbis estéreo | idem | |
| Voz | OGG Vorbis mono | idem | um arquivo por fala, ID estável |

Verificar em spike: compressão e suporte de loop dos formatos importados na versão da engine.

### 6.2 Loops

Ambientes com 30–90 s, cruzamento interno sem padrão perceptível; camadas de detalhe ("one-shots") disparadas por ponto emissor com intervalo aleatório **limitado** (min/máx) e sem repetição imediata.

### 6.3 Espacialização

* SFX do mundo em 3D com atenuação calibrada por tipo; perseguidores audíveis a distância maior que a de visão.
* Sons atrás de paredes: filtro passa-baixa + atenuação, por zona (não por raycast contínuo), no Gilman.
* Ambientes por **zonas** com crossfade; volume das quedas por distância ao desfiladeiro.
* Reverb por zona: rua aberta, beco, interior pequeno, armazém, ponte coberta, sonho.
* Mono para fontes pontuais; estéreo só para camadas de ambiente.

### 6.4 Buses

`Master` → `Music`, `Ambience`, `SFX`, `Voice`, `UI`. Duck leve de `Ambience`/`Music` quando `Voice` fala; `SFX` de perigo nunca é abafado por `Music`. Pausa congela todos os buses de mundo; `UI` continua.

### 6.5 Loudness (meta, não medida)

* Integrado de jogo: ~−18 LUFS em sessões típicas de 10 min; picos ≤ −1 dBTP.
* Voz como referência de nível; picos de susto limitados para não ultrapassar a voz em mais que ~10 LU de curto prazo.
* Modo de "faixa dinâmica reduzida" (16) comprime picos.

### 6.6 Prioridades e vozes simultâneas

Orçamento inicial: 32 vozes simultâneas (verificar em spike). Prioridade: **perigo > voz > evento narrativo > passos do jogador > ambiente de detalhe > ambiente base**. Sons de perigo e de pista obrigatória nunca são descartados por falta de vozes.

### 6.7 Legendas

* Falas com nome do falante (ou "Voz" quando desconhecido).
* Legendas de som entre colchetes, com **direção** opcional (◄ ►) para pistas espaciais.
* Tempo mínimo de leitura configurável; legenda pausa com o jogo.
* Indicador visual para pistas de perigo, independente das legendas (16).

## 7. Voz

| Nível | Conteúdo |
|---|---|
| E | Texto + vocalizações não verbais (respirações, grunhidos, interjeições) para personagens falantes |
| R | VO completa de Zadok Allen (inglês, legendado em PT-BR; PT-BR em Q-003) |
| Op | VO de bilheteiro, Tilton, rapaz da mercearia, Peabody, Walter |

Zadok: dialeto do conto (escrita fonética "Thar's whar it all begun") preservado no texto inglês; a legenda PT-BR transmite a oralidade **sem caricatura regional**. Direção de atuação: sinceridade aterrorizada, humor amargo, pânico final; nada de "velho louco cômico".

## 8. Provisório vs. licenciado

| Status | Regra |
|---|---|
| `ph_` provisório | Pode ser síntese, gravação própria, biblioteca com licença de teste; **nunca** entra numa build distribuível |
| licenciado | Origem, autor, licença, prova de uso comercial, atribuição e alterações registradas em 18 |
| final aprovado | Licenciado + revisão de mix humana + aprovação em execução gráfica do export Windows |

Bibliotecas CC0/CC-BY podem ser usadas com atribuição; CC-NC e "uso pessoal" são proibidas. Vozes sintéticas de IA só com decisão Q-011 e divulgação exigida pela plataforma.

## 9. Critérios de aceitação

* Testadores identificam a direção da ameaça no Gilman com olhos na tela e com legendas apenas (23).
* Nenhum susto sonoro sem fonte catalogada.
* Mix revisado por pessoa em fones e alto-falantes.
* Headless não valida áudio: aprovação apenas na build gráfica.
