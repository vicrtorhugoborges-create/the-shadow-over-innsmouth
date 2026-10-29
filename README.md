# The Shadow Over Innsmouth (título provisório)

Jogo independente de horror cósmico em primeira pessoa, com estética 3D retrô inspirada no PlayStation 1, baseado no conto *The Shadow over Innsmouth*, de H. P. Lovecraft (1936). Godot 4.7.2, GDScript, renderizador Compatibility, PC Windows, offline.

## Jogar

Dê dois cliques em **Jogar The Shadow Over Innsmouth.cmd**. Ele abre `builds/The Shadow Over Innsmouth/The Shadow Over Innsmouth.exe`, sem instalar nada.

A versão **1.1.0** contém a **campanha completa**, do manuscrito ao fim, jogada em sequência sem voltar ao menu:

| Capítulo | O que acontece |
| --- | --- |
| Moldura | Toledo, 1931: o narrador começa a escrever. |
| I — A Viagem | Newburyport: o bilheteiro, a biblioteca, a tiara na Sociedade Histórica, o ônibus de Joe Sargent. |
| II — A Cidade Esquecida | A viagem pela costa, a crista sobre Innsmouth, a New Church Green, o sino das onze e o padre no porão, a praça. |
| III — Os Segredos de Innsmouth | O rapaz da mercearia e o mapa; refinaria, orla sul, ruas antigas, norte do rio; Zadok Allen e a garrafa. |
| IV — O Testemunho de Zadok Allen | Sete movimentos no cais em ruínas; dosar a garrafa; o grito e a fuga. |
| V — A Armadilha | O ônibus quebrado, o quarto 428, o ferrolho, a chave na fechadura. |
| VI — Fuga do Gilman House | Portas, barricadas, a cortina, o telhado, o pátio. |
| VII — A Noite de Innsmouth | A fuga pela cidade até a ferrovia, imitando o passo dos habitantes; a procissão na estrada de Rowley. |
| VIII — A Herança de Innsmouth | Arkham, Cleveland, as joias, os sonhos, o espelho e as últimas páginas. |

Os capítulos alcançados ficam disponíveis em **Escolher capítulo**. Texturas, pessoas, Profundos e sons são gerados por código no próprio jogo, sem arquivos de terceiros (D-021). A versão foi fechada com autoteste próprio — jogadas automatizadas com renderização real, medições e revisão textual interna (D-020) —, sem playtest com jogadores, revisão de sensibilidade externa nem parecer jurídico; ver [`docs/28-ESTADO-IMPLEMENTACAO.md`](docs/28-ESTADO-IMPLEMENTACAO.md).

| Ação | Teclado / mouse | Controle |
| --- | --- | --- |
| Andar / olhar | W A S D ou setas / mouse | analógicos |
| Correr (faz barulho) | Shift | LB |
| Agachar | Ctrl | B |
| Andar arrastado | Alt | clique do analógico esquerdo |
| Fechar os olhos (quando pedido) | segurar Espaço | segurar LT |
| Interagir / examinar | E | A |
| Lanterna | F | RT |
| Diário (objetivo, notas, documentos, pistas) | J | Y |
| Pausa / voltar | Esc | Start |

Teclas remapeáveis em **Configurações**, onde também estão: **brilho com calibração**, tela cheia, V-Sync, resolução do mundo (240 ou 360 linhas), intensidade do efeito retrô, volumes geral, de ambiente e de efeitos, tamanho do texto, fundo das legendas, legendas de sons, campo de visão, ponto central, inversão do eixo, **segurar em vez de pressionar repetidamente** e **fuga assistida** (prazos maiores). Descrições do que se vê (gestos, letreiros, luzes) aparecem sempre, mesmo com as legendas de som desligadas. Ler, abrir o Diário ou pausar congela todo perigo. O Diário oferece pistas em três níveis.

O jogo grava automaticamente em pontos seguros. Se for alcançado, **Tentar novamente** volta ao último checkpoint sem repetir diálogos. Saves e configurações ficam em `%APPDATA%\TheShadowOverInnsmouth\`.

## Editar, testar e compilar

* **Editar The Shadow Over Innsmouth.cmd** abre `game/` no Godot 4.7.2 portátil de `tools/godot/4.7.2/`.
* **Compilar.ps1** gera a build Windows.
* Testes em `game/tests/`: lógica (`run_tests.gd`), quatro jogadas automatizadas (`playthrough_day.gd` moldura–IV, `playthrough.gd` V–VI, `playthrough_night.gd` VII, `playthrough_heritage.gd` VIII), andarilho de navegação (`walkthrough.gd`) e níveis de áudio (`audio_levels.gd`). As jogadas rodam headless ou com janela; com `-- --record=<pasta>` gravam capturas, luminância e tempo de quadro (`recorder.gd`).

Estado real, evidências e pendências: [`docs/28-ESTADO-IMPLEMENTACAO.md`](docs/28-ESTADO-IMPLEMENTACAO.md).

## Em outro computador

O repositório não traz a engine nem a build (arquivos acima de 100 MB). Depois de clonar:

1. Coloque os quatro arquivos do Godot 4.7.2 em `tools/godot/4.7.2/` e confira os hashes, conforme [`tools/godot/4.7.2/LEIA-ME.md`](tools/godot/4.7.2/LEIA-ME.md).
2. Gere a build. Se o Windows bloquear scripts, rode só este, sem mudar a política do sistema:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Compilar.ps1
   ```

3. Abra **Jogar The Shadow Over Innsmouth.cmd**.

Saves e configurações ficam em `%APPDATA%\TheShadowOverInnsmouth\` e não estão no repositório; para levar uma partida, copie essa pasta.

## Planejamento

1. [`docs/00-VISAO-GERAL.md`](docs/00-VISAO-GERAL.md) — visão, pilares e mapa da documentação.
2. [`docs/27-REGISTRO-DE-IDS.md`](docs/27-REGISTRO-DE-IDS.md) — decisões fixadas e IDs.
3. [`docs/03-GAME-DESIGN-DOCUMENT.md`](docs/03-GAME-DESIGN-DOCUMENT.md) — GDD.
4. [`docs/26-DECISOES-PENDENTES.md`](docs/26-DECISOES-PENDENTES.md) — o que precisa de validação humana.
5. [`docs/21-BACKLOG-CLAUDE-CODE.md`](docs/21-BACKLOG-CLAUDE-CODE.md) — tarefas.

Regras para agentes: [`CLAUDE.md`](CLAUDE.md).

## Fonte e licenças

Texto integral consultado: [H. P. Lovecraft Archive](https://www.hplovecraft.com/writings/texts/fiction/soi.aspx). Situação de domínio público em [`docs/24-COMERCIALIZACAO-E-DIREITOS.md`](docs/24-COMERCIALIZACAO-E-DIREITOS.md) — confirmação jurídica pendente (Q-002). Godot Engine sob licença MIT (`docs/licenses/`).
