# 03 — Game Design Document

Documento de referência que amarra as decisões de design. Os detalhes vivem nos documentos especializados indicados em cada seção; aqui ficam o **porquê** e as **escolhas entre alternativas**.

---

## 1. Fantasia do jogador

> "Sou um rapaz curioso de passagem por uma cidade que todos evitam. Sei menos do que todos à minha volta. Quando finalmente entendo, já é noite, e a cidade inteira sabe onde estou. E, anos depois, descubro que ela sempre soube quem eu era."

O jogador não é herói, detetive profissional ou sobrevivente armado. É um **observador** cuja vantagem é a atenção: ao que vê, ao que ouve, ao que lê e ao mapa que recebeu de um estranho gentil.

## 2. Público e posicionamento

- Jogadores de horror narrativo em primeira pessoa e de jogos independentes com estética PS1.
- Leitores de Lovecraft que querem uma adaptação fiel e completa, **incluindo o epílogo** que adaptações costumam encurtar.
- Jogadores que não conhecem Lovecraft: o jogo precisa ser compreensível sem conhecimento prévio (testado em 23).

**Diferenciais:** a cidade como antagonista coletivo; a geografia diurna reaproveitada como ferramenta de fuga noturna; a revelação genealógica jogável; fidelidade marcada (C/I/O) e responsável.

## 3. Ciclos de jogo

### 3.1 Ciclo de investigação (ch01–ch04, ch08)

```text
Explorar → Observar → Investigar → Interpretar → Descobrir → Avançar
   │           │            │             │             │
 andar,     detalhes    conversar,     o Diário      novo tema,
 mapa       arquitet.   ler, examinar  registra só   novo lugar,
                                       o que o       objetivo
                                       narrador sabe
```

### 3.2 Ciclo de perigo (ch06–ch07)

```text
Perceber ameaça → Avaliar ambiente → Escolher rota → Agir → Escapar
 (som, luz,        (portas, janelas,   (mapa, sombra,  (andar    (checkpoint
  odor em texto)    móveis, ruas)       passo)          arrastado, seguro)
                                                         esconder)
```

O perigo é **raro e concentrado**: cerca de 45–60 minutos do total (ch06, ch07 e parte de ch05) contêm risco real de falha.

## 4. Mecânicas — escolhas e alternativas descartadas

Especificação completa em `12-MECANICAS-E-PUZZLES.md`.

| Tema | Escolha | Alternativa avaliada | Por que a escolha |
|---|---|---|---|
| Sanidade | **Sem sistema numérico.** Efeitos psicológicos são roteirizados (som, enquadramento, texto do Diário, leve dessaturação em momentos marcados). | Medidor de sanidade com alucinações aleatórias. | O conto trata a dúvida sobre a realidade como tema, não como recurso gasto. Um medidor transformaria revelação em punição e incentivaria evitar olhar — o oposto do clímax, em que olhar é inevitável. |
| Combate | Nenhum (D-005). | Defesa corpo a corpo limitada. | O narrador está desarmado [C]; qualquer combate esvazia o terror da multidão. |
| Corrida | Ilimitada, mas **barulhenta** e visível. | Estamina com barra. | Elimina HUD; o custo é diegético (ser ouvido). |
| Disfarce | **Andar arrastado** em espaços abertos ao luar. | Esconder-se sempre. | Canônico e original como mecânica; cria a imagem do narrador fingindo pertencer — que o epílogo inverte. |
| Clímax | **Manter os olhos fechados** (segurar), que falha inevitavelmente. | Cutscene. | O jogador participa da decisão impossível do narrador. |
| Inventário | "Bolsos" com ≤ 8 itens-chave (D-006). | Inventário em grade. | Nada a gerenciar; cada item tem função narrativa. |
| Pistas | Sem marcadores; Diário com objetivo textual e **dicas sob demanda em 3 níveis**. | Destaque de objetos. | Atenção como mecânica; dicas evitam bloqueio. |
| Mapa | Mapa desenhado à mão, sem "você está aqui". Opção de acessibilidade mostra o nome da rua próxima. | Minimapa. | O mapa é objeto canônico; orientar-se é parte do medo. |
| Diálogo | Lista curta de temas; respostas fixas; sem árvore moral. | Árvores ramificadas. | Fidelidade e custo; a escolha está em **o que perguntar**, não em quem ser. |
| Finais | Um final canônico (D-010). | Finais "resistir / aceitar". | O sentido da obra é a inversão do horror em pertencimento; um final "bom" anularia a obra. |

## 5. Protagonista

- **Sem nome** [C]; o jogo usa "o viajante" na interface quando inevitável. Na moldura, o jogador lê e escreve o manuscrito em primeira pessoa.
- **Voz interior discreta:** notas curtas no Diário (≤ 25 palavras) e legendas ocasionais ao examinar; nada de narração contínua. Sem dublagem do narrador no escopo E (o silêncio dele é ferramenta de identificação).
- **Corpo:** mãos visíveis apenas em interações-chave (ferrolho, cortina, garrafa, mapa). Reflexos: janelas e espelhos mostram uma silhueta indistinta durante ch01–ch07; em ch08 o espelho do quarto em Toledo é o único reflexo nítido, e muda entre `cp08_dreams` e `evt_mirror_look`. Fotografias: o narrador nunca aparece em foto antes de ch08.
- **Motivação de gameplay:** o interesse antiquário (arquitetura, genealogia) é recompensado com notas do Diário e detalhes que, no epílogo, ganham novo sentido.

## 6. Estrutura e progressão

Fichas completas em `05-CAPITULOS-E-PROGRESSAO.md`; roteiro em `04-HISTORIA-E-ROTEIRO.md`.

| Capítulo | Núcleo jogável | Perigo | Termina quando |
|---|---|---|---|
| `ch00_frame` | Ler a primeira página do manuscrito | não | O jogador começa "a contar" |
| `ch01_journey` | Conversas em Newburyport, biblioteca, tiara, embarque | não | O ônibus parte |
| `ch02_forgotten_town` | Viagem no assento; chegada; praça | não | O jogador entra na mercearia |
| `ch03_secrets` | Mapa; passeio pelos distritos; Zadok avistado; uísque | não | Zadok segue o jogador |
| `ch04_zadok` | Testemunho em 7 movimentos | não (falha suave) | Zadok foge |
| `ch05_trap` | Retorno; ônibus quebrado; quarto 428; ferrolho; ruídos | tensão, sem falha | A luz é cortada |
| `ch06_gilman_escape` | Portas, móveis, janela, telhado, pátio | **sim** | Sai pela janela à Washington |
| `ch07_night` | Rota pelo mapa; disfarce; sinais; ferrovia; procissão | **sim** | Desmaio no corte |
| `ch08_inheritance` | Arkham, Cleveland, joias, sonhos, decisão | não | Cena final simbólica |

**Barreiras de progressão** sempre diegéticas: horário do ônibus, portas trancadas, avisos, cansaço do narrador ("preciso voltar à praça antes das oito"), nunca paredes invisíveis sem motivo visual.

## 7. Falha e retomada

Modelo detalhado em `05-CAPITULOS-E-PROGRESSAO.md` §Morte, falha e salvamento.

- **Captura** (alcançado por perseguidores) e **queda** (vão da ponte coberta; telhado se a corda não for presa) são as únicas falhas. Não há representação explícita de morte: corte para negro com som, depois o checkpoint.
- Repetir uma falha nunca exige refazer diálogo nem investigação; o cerco do hotel recomeça em `cp06_knock` com o ferrolho já instalado.
- **Assistência de perseguição** (acessibilidade) amplia janelas de tempo e alcance de esconderijos, sem remover o perigo.

## 8. Horror — princípios

1. **Antecipação antes de exposição**: cada revelação de ch07 é preparada por um eco de ch01–ch05 (tiara → procissão com tiaras; padre no porão → figura saltitante; vozes do inspetor Casey → vozes no hotel).
2. **Lógica narrativa em todo evento**: sem sustos aleatórios. Eventos ambientais repetíveis têm resfriamento e só ocorrem onde a história justifica (casas tapadas ao norte do rio, por exemplo).
3. **Distância como linguagem**: os Profundos são vistos longe, à noite, em movimento, até o único momento de proximidade (~100 jardas, `evt_rowley_procession`).
4. **O cheiro**, onipresente no texto, vira camada sonora (moscas, água parada, peixe), névoa esverdeada sutil e notas do Diário — nunca só um efeito visual.
5. **Horror do epílogo** é de reconhecimento: as mesmas formas (tiara, olhos que não piscam, o recife) retornam como herança.

Catálogo de eventos: `05-CAPITULOS-E-PROGRESSAO.md`. Sistema de IA: `11-INTELIGENCIA-ARTIFICIAL.md`.

## 9. Conteúdo sensível

Avisos de conteúdo no primeiro início (suicídio mencionado, doença mental mencionada, violência implícita, preconceitos históricos), revisáveis no menu. Diretrizes de adaptação responsável em `02-FIDELIDADE-CANONICA.md`. Decisões D-013 a D-016.

## 10. Controles (resumo)

Esquema completo em `16-INTERFACE-E-ACESSIBILIDADE.md`.

| Ação | Teclado/mouse | Controle |
|---|---|---|
| Mover / olhar | WASD / mouse | analógicos |
| Interagir / examinar | E | A |
| Correr | Shift | LB |
| Agachar | Ctrl (ou C) | B (alternar) |
| Andar arrastado | Alt (segurar ou alternar) | clique do analógico esquerdo |
| Lanterna (quando disponível) | F | RT |
| Fechar os olhos (contextual) | segurar Espaço | segurar LT |
| Bolsos / Diário / Mapa | I / J / M | Y / Select / direcional ↑ |
| Pausa | Esc | Start |

## 11. Metas de qualidade

| Área | Meta | Como verificar |
|---|---|---|
| Compreensão | Jogador sem conhecimento de Lovecraft consegue resumir a revelação final | Playtest (23) |
| Bloqueio | Nenhum puzzle sem pista disponível; tempo médio por puzzle dentro da faixa de 12 | Telemetria local de playtest (opt-in, offline) |
| Justiça | Toda captura tem causa audível ou visível antes | Revisão de vídeo de playtest |
| Fidelidade | Toda cena com marca C/I/O | Revisão narrativa (23) |
| Desempenho | Metas de 19 **medidas** | Plano de medição (19) |

## 12. Escopo por nível

Ver `22-RISCOS-E-ESCOPO.md` para a matriz completa. Nunca cortar: o final e o epílogo genealógico, a sequência do Gilman House, a identidade de Innsmouth (praça, desfiladeiro, orla, sinos, janelas), o testemunho de Zadok e a procissão.
