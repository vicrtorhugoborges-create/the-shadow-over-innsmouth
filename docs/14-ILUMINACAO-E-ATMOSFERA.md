# 14 — Iluminação, clima e atmosfera

> **Estado:** proposta. Valores numéricos são pontos de partida para calibração na Fase 1; nenhum foi testado. Dependências da engine estão marcadas **"verificar em spike"**.

## 1. Função dramática da luz

A luz conta o tempo do conto. O dia de 15 de julho de 1927 é **quente e ensolarado** [C] ("The day was warm and sunny", ch. II); a tarde termina numa "golden light" que dá aos telhados "mystic loveliness" [C] (ch. IV); a noite é de lua "not much past full" [C] com as luzes da rua **desligadas** [C] ("all the street-lights were turned off", ch. IV); o despertar é sob "gentle daylight rain" [C] (ch. V).

A beleza é parte do horror: Innsmouth deve ser às vezes **bonita** — sobretudo ao entardecer e ao luar visto da ferrovia [C] — para que a repulsa e a atração do final façam sentido.

## 2. Sistema proposto (economicamente viável)

`sys_time_of_day` não simula um ciclo contínuo. Ele aplica **perfis discretos** por capítulo/trecho, com transições curtas roteirizadas:

1. **Luz base assada** em cor de vértice (ambiente + oclusão pintada) por distrito, em **duas variantes**: dia e noite. A variante dia serve manhã/tarde/entardecer modulada pelo perfil; a noite tem janelas acesas e sombras de luar pintadas.
2. **Uma luz direcional** (sol ou lua), sem sombra ou com sombra única barata — verificar em spike custo de sombra direcional no Compatibility.
3. **Poucas luzes pontuais** dinâmicas por área (lâmpadas de interior, lanternas dos perseguidores, a lanterna do jogador). Limite inicial: 8 visíveis simultâneas, 1 com sombra — verificar em spike o limite de luzes por objeto no Compatibility.
4. **Névoa linear** com cor e distâncias por perfil.
5. **Céu** por domo de baixa resolução com gradiente e textura (nuvens, lua), sem céu físico.
6. **Grading** por tabela/curvas simples aplicado só ao mundo.
7. **Emissivos falsos** (janelas, sinais do recife, cúpula do Gilman) por material sem luz real, com halo em cartão.

Lightmaps assados: **verificar em spike** suporte e custo no renderizador Compatibility; se indisponíveis, a cor de vértice assada no DCC é o caminho principal, não um fallback.

## 3. Perfis de iluminação

| Perfil (ID proposto) | Uso | Sol/Lua | Ambiente | Névoa (início–fim) | Cor dominante | Contraste | Visibilidade longa |
|---|---|---|---|---|---|---|---|
| `tod_newburyport_dusk` (proposto) | ch01 estação/rua | sol baixo quente | médio | 40–160 m, cinza-quente | âmbar desbotado | médio | boa |
| `tod_interior_lamp` (proposto) | biblioteca, Sociedade, Y.M.C.A., mercearia, restaurante | — | baixo + lâmpadas incandescentes | sem névoa | amarelo-tungstênio fraco | médio-alto | n/a |
| `tod_morning` (proposto) | ch01 manhã, ch02 chegada | sol alto, branco-quente | alto | 80–300 m, névoa marítima leve sobre a orla | azul do mar, telhados prata | baixo-médio | ótima (crista panorâmica) |
| `tod_afternoon` (proposto) | ch03 | sol inclinado | médio | 60–220 m | cinza-dourado; sombras longas nas ruas estreitas | médio | boa |
| `tod_golden` (proposto) | ch04 cais, ch05 retorno 19h15 | sol baixo dourado | médio-baixo | 50–200 m, aumenta com a maré | ouro e laranja sobre telhados, mar chumbo | médio-alto | boa ao recife |
| `tod_dusk` (proposto) | ch05 praça e restaurante | sem sol, céu rosado/azulado | baixo | 35–140 m | azul-acinzentado, primeiras janelas | médio | média |
| `tod_moon_night` (proposto) | ch05 fim, ch06, ch07 | lua quase cheia alta, branco-amarelada | baixo, azulado | 30–120 m nas ruas; abre em espaços com vista ao mar | azul-prata com luar "amarelo" em espaços abertos | alto em espaços abertos, médio nas ruas | média; recife legível por emissivos |
| `tod_interior_dark` (proposto) | ch06 após `evt_power_cut` | luar pela janela | muito baixo | sem | azul frio | alto | n/a |
| `tod_rain_day` (proposto) | ch08a | difusa, sem sol | médio | 20–90 m, chuva | cinza-verde lavado | baixo | baixa |
| `tod_domestic` (proposto) | ch08b Arkham, ch08d Cleveland, ch08e cofre | janelas diurnas | médio-alto | sem | quente, madeira, papel | médio | n/a |
| `tod_toledo_night` (proposto) | ch00, ch08f, ch08g quarto | abajur | baixo | sem | âmbar fechado | alto | n/a |
| `tod_dream` (proposto) | `lvl_dream_sea`, `lvl_reef_final` | luz fosforescente sem fonte | baixo, verde-azul | 10–60 m, densa | verde-azulado, corais pálidos | baixo → alto na revelação | baixa (deliberada) |

Os IDs `tod_*` são **propostos** e devem ser adicionados ao registro (27) pela fonte responsável.

## 4. Luz por elemento

### 4.1 Sol

Direcional única; ângulo segue a hora do capítulo (11h alto; 15h inclinado; 19h baixo). Sombras do sol são majoritariamente **pintadas** na cor de vértice; a sombra dinâmica, se o spike permitir, fica restrita a um raio próximo ao jogador.

### 4.2 Lua

Direcional azul-prata intensa o bastante para navegar. Em espaços abertos (praça Eliot/Washington/South, South Street, corte da ferrovia), a lua "plays free" [C]: aumentar ambiente e contraste ali para reforçar a **sensação de exposição** que motiva o andar arrastado. A "mocking yellow moon" [C] da procissão justifica um tom mais amarelo no trecho final de ch07.

### 4.3 Iluminação artificial histórica

* Rua: lâmpadas incandescentes poucas e fracas [C] ("Lamps were depressingly few and small—all low-powered incandescents", ch. II). De dia, apagadas; à noite, **apagadas** [C]. Apenas janelas habitadas e lanternas de perseguidores iluminam.
* Interiores: lâmpada única pendente de baixa potência (Gilman: "one feeble electric bulb", [C]); cone pequeno, falloff curto, tom tungstênio.
* Lanternas/lampiões dos perseguidores [C] ("lanterns bobbing", ch. IV): luz pontual quente oscilante, **sempre visível antes do portador** — é o principal aviso visual de perigo.
* Lanterna do jogador [C]: cone estreito branco-amarelado, sombra única; à noite na rua torna o jogador visível a distância (ver 11/12).

### 4.4 Sinais do recife

Clarões intermitentes em Devil Reef e resposta "differently spaced" da cúpula do Gilman [C] (`evt_reef_signals`); depois "faint, steady glow ... of a curious colour" [C] (`evt_rowboat`). Implementação por emissivos e cartões, sem luz real. A cor "curiosa" é um verde-violeta dessaturado que não aparece em nenhum outro lugar do jogo, exceto nos sonhos.

### 4.5 Janelas e igrejas

À noite, luzes acesas na Ordem de Dagon, igreja batista e congregacional [C] (`evt_church_lights`), visíveis do telhado ao norte: emissivo quente pulsante lento.

## 5. Neblina marítima e umidade

* Névoa sobre a orla mais densa que no interior (gradiente por altura simples ou volumes de névoa por cartão — verificar em spike névoa por altura no Compatibility).
* Umidade: superfícies de pedra e paralelepípedo com faixa especular pintada; à noite, poças com reflexo falso (textura espelhada estática da cena + ondulação).
* O cheiro de peixe [C], central no conto, é representado por: **vento e névoa** que se adensam (o odor "waxed" e "abated", ch. IV), som (15) e a linha de pensamento do narrador. Nunca por efeito de distorção de tela.

## 6. Chuva

Apenas em ch08a. Cartões de chuva presos à câmera + respingos em poças; volume de som próprio (15). Lama sem pegadas é material com decalques de chuva — o detalhe `evt_no_prints` precisa ser **examinável** sem depender da textura (texto do narrador ao examinar).

## 7. Reflexos simplificados

Água: textura de reflexo do céu do perfil + faixa da lua/sol pintada; sem reflexão em tempo real. Espelho de ch08f: renderização secundária de baixa resolução **ou** cena encenada atrás de vidro — verificar em spike o custo de viewport secundário; a solução encenada é aceitável.

## 8. Sombras — direção artística

Sombras desenham **composição**: becos escuros, vãos de porta como esconderijos (`evt_bates_hide`), retângulo negro do porão da igreja. Regra: um esconderijo é **legivelmente mais escuro** que a rua ao redor e tem o mesmo desenho de batente em toda a cidade (gramática visual, ver 12).

## 9. Navegação noturna legível

Requisitos obrigatórios para ch06–ch07:

1. Luminância mínima do chão caminhável ao luar acima do limiar de leitura definido no protótipo; calibrada com o controle de brilho (16).
2. Silhuetas de marcos (cúpula do Gilman, campanários, estação) contra o céu mais claro.
3. Saídas da rota principal com um elemento claro consistente (luar entrando, poste de telégrafo, muro caiado).
4. Perseguidores anunciados por luz (lanterna) e som antes de serem visíveis.
5. Ajuste de **brilho/gama** com tela de calibração e opção "noite legível" que sobe ambiente noturno sem alterar a detecção.
6. Nenhum puzzle noturno exige ver algo que só é distinguível por cor.

## 10. Transições

| Transição | Técnica |
|---|---|
| ch03 → ch04 (tarde → dourado) | Interpolação de perfil de 3–5 min durante o testemunho de Zadok, sincronizada com `evt_tide_turn`. |
| ch05 (crepúsculo → noite) | Por corte: o jogador lê no quarto; ao apagar a luz, entra `tod_moon_night`. |
| `evt_power_cut` | Instantâneo para `tod_interior_dark`. |
| Desmaio (`evt_rowley_procession`, `evt_vault_tiara`) | Escurecimento pela borda + perda de cor, sem flash branco. |
| Sonho | Dissolução lenta para `tod_dream`. |

## 11. Critérios de aceitação

* Captura do mesmo ponto em `tod_afternoon` e `tod_moon_night` aprovada por revisão humana (reconhecível e transformado).
* Rota de ch07 percorrida por testadores sem lanterna com brilho padrão, sem perda de orientação além do tempo-alvo (23).
* Nenhum perfil excede o orçamento de luzes de 19 nas medições.
