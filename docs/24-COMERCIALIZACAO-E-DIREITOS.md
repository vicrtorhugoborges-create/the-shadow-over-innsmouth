# 24 — Comercialização e direitos

> **Aviso:** esta é uma análise de planejamento, **não um parecer jurídico**. Nada aqui autoriza comercialização. Os pontos do §8 precisam de confirmação por advogado com atuação em propriedade intelectual antes de qualquer venda ou divulgação pública (Q-002).

## 1. Situação da obra original

| Jurisdição | Situação aparente | Base | Grau de confiança |
|---|---|---|---|
| **Estados Unidos** | Domínio público | A página do Wikisource "The Shadow Over Innsmouth (1936)", consultada nesta sessão, afirma que a obra foi publicada legalmente nos EUA antes de 1964 e que o copyright **não foi renovado**. Obras de 1936 só poderiam ter sido renovadas em 1963–1964. | Médio: é a posição de um repositório que exige domínio público nos EUA, mas não substitui busca própria nos registros de renovação (Stanford Copyright Renewal Database e registros do U.S. Copyright Office, indicados pela própria página). |
| **Brasil** | Domínio público | Lei 9.610/98, art. 41: direitos patrimoniais duram 70 anos contados de 1º de janeiro do ano seguinte à morte do autor. Lovecraft morreu em 15/03/1937 → domínio público desde **1º/01/2008**. | Alto para o texto original em inglês; confirmar com advogado. |
| **União Europeia** | Domínio público | Regra geral de vida + 70 anos → desde 1º/01/2008. | Alto para o texto original; verificar regras específicas de países-alvo de venda. |
| Outros mercados | A verificar | Prazos variam (vida + 50, vida + 70, regras especiais). | Baixo até verificação. |

Observação histórica: existe uma alegação antiga de herdeiros/editoras sobre direitos sobre a obra de Lovecraft. Ela não foi pesquisada nesta sessão e deve constar da consulta jurídica.

## 2. Texto, traduções e edições

* **Traduções modernas** para o português (e outras línguas) são obras derivadas protegidas por direitos próprios do tradutor/editora. **Não usar** trechos de traduções publicadas. Todo texto em PT-BR do jogo é **tradução ou redação própria** a partir do inglês.
* **Edição de 1936 (Visionary Publishing)**: base mais segura para citações em inglês, por ser a publicação original. É conhecida por problemas de revisão; preferir citar trechos cuja redação seja estável.
* **Texto corrigido (S. T. Joshi)** e transcrições online: o texto lido nesta sessão (hplovecraft.com) é uma transcrição em site com aviso de copyright do mantenedor sobre o site. Correções editoriais modernas podem ou não gerar proteção própria conforme a jurisdição — **cautela**: não copiar a formatação do site; para citações literais, conferir contra a edição de 1936 (Wikisource) e registrar a fonte.
* **Manuscrito e notas de enredo** (Brown University): as digitalizações podem ter termos de uso próprios. Não usar imagens do manuscrito no jogo sem verificar.
* Ilustrações de edições (inclusive capas e as ilustrações da edição de 1936, atribuídas a Frank Utpatel — atribuição não verificada nesta sessão) **não** devem ser usadas sem verificação específica de direitos.

## 3. Adaptações existentes

* Há adaptações anteriores, inclusive em jogos — por exemplo *Call of Cthulhu: Dark Corners of the Earth* (2005), que também adapta a fuga do hotel. Elementos que **vêm do conto** (Gilman House, quartos interligados, cortina, telhados, ferrovia) são livres; elementos **inventados por adaptações** (nomes de protagonista, personagens, armas, níveis, diálogos, criaturas próprias, design de interface, música) **não** podem ser copiados.
* Regra de produção: toda cena tem justificativa no texto ([C]/[I]) ou é invenção nossa ([O]) documentada em 02. A equipe não usa adaptações como referência visual direta de níveis ou personagens.
* O protagonista permanece sem nome (D-002), evitando nomes associados a adaptações ou a materiais de terceiros.

## 4. Título e marcas

* Títulos de obras geralmente não são protegidos por direito autoral, mas **podem existir marcas registradas** com "Innsmouth", "Shadow Over Innsmouth" ou termos do Mythos em classes de jogos. **Busca de marca obrigatória** (Q-001) nos EUA (USPTO), Brasil (INPI) e UE (EUIPO).
* **"Call of Cthulhu"** é marca associada à Chaosium para jogos de RPG; não usar no título, na página da loja ou em palavras-chave de forma que sugira afiliação.
* Recomendação provisória: manter o título do conto e acrescentar subtítulo distintivo, se a busca indicar risco (opções em Q-001).
* Não usar logotipos, fontes ou identidade visual de editoras ou de outras adaptações.

## 5. Recursos do jogo

| Recurso | Exigência antes de entrar numa build distribuível |
|---|---|
| Modelos, texturas, animações | Origem, autor, licença com uso comercial, prova de permissão, atribuição exigida, alterações feitas, status — no inventário (18). |
| Fotografias históricas de referência | Usadas só como referência; se aparecerem no jogo, prova de domínio público ou licença. |
| Música e efeitos sonoros | Licença comercial que cubra jogos e trailers; atenção a bibliotecas que proíbem redistribuição dos arquivos-fonte. |
| Vozes | Contrato com cessão de direitos de uso em jogo, trailer e divulgação; cláusula explícita sobre uso (ou proibição) de síntese/IA da voz. |
| Fontes tipográficas | Licença de embutimento em software (SIL OFL ou licença comercial equivalente). |
| Engine | Godot é distribuído sob licença MIT: incluir o aviso de copyright/licença do Godot e os avisos dos componentes de terceiros incluídos na engine (tela de créditos + arquivo de licenças, `INN-504`). Confirmar lista de componentes da versão 4.7.2 no momento do export. |
| Plugins/addons | Nenhum sem licença verificada e registrada. |
| Assets gerados por IA | Somente se Q-011 aprovar. Registrar ferramenta, termos de uso da ferramenta, prompt/processo e revisão humana. A Steam exige **declaração de conteúdo gerado por IA** no questionário de conteúdo da página (verificar regra vigente no momento da submissão). Direitos autorais sobre conteúdo gerado sem autoria humana suficiente podem ser limitados em algumas jurisdições. |

## 6. Distribuição inicial — PC Windows

| Canal | Características (verificar condições vigentes) | Papel recomendado |
|---|---|---|
| **Steam** | Taxa por produto do Steam Direct; maior público de horror independente no PC; wishlists; eventos como Steam Next Fest; páginas exigem classificação de conteúdo e declaração de IA. | Canal principal de venda. |
| **itch.io** | Publicação aberta; divisão de receita definida pelo criador; bom para protótipos, demos e game jams. | Playtests abertos, demo inicial, comunidade. |
| GOG / outras | Curadoria; avaliar após lançamento. | Pós-lançamento (Op). |

Claude Code **não cria contas, não publica e não envia builds** (CLAUDE.md §2). Toda submissão é feita por humano.

## 7. Divulgação: demo gratuita vs. alternativas

| Estratégia | Prós | Contras | Recomendação |
|---|---|---|---|
| **Demo gratuita (ch01–ch02 + início ch03)** | Mostra atmosfera e qualidade sem revelar hotel nem Profundos; elegível para festivais de demo; gera wishlists | Começo lento pode não converter jogadores que esperam ação | **Recomendada** como principal, com trailer que sugira a noite sem mostrar a procissão |
| Demo do Gilman House | Muito impactante | Revela o clímax do meio; difícil de "desver" | Apenas playtest fechado |
| Trailer + capturas sem demo | Barato | Menos confiança do público em jogo independente | Complementar |
| Acesso antecipado | Receita cedo | Narrativa linear sofre com spoilers e incompletude | **Não recomendado** |
| Devlog/making-of da adaptação literária | Atrai público de Lovecraft e de horror retrô | Exige constância | Complementar, com cuidado de spoilers |

Preço, regiões e descontos: Q-009.

## 8. Lista para confirmação jurídica antes da comercialização

1. Domínio público da obra nos EUA (busca de renovação), Brasil, UE e demais mercados de venda.
2. Alegações históricas de direitos sobre a obra de Lovecraft.
3. Uso do título "The Shadow Over Innsmouth" e de nomes do conto (Innsmouth, Dagon, Y'ha-nthlei, Cthulhu, shoggoth) em título, marca e marketing.
4. Busca de marcas em classes de videogames.
5. Status do texto corrigido moderno vs. edição de 1936 para citações literais.
6. Termos de uso de fotografias históricas e acervos consultados.
7. Contratos de arte, áudio e voz (cessão, exclusividade, crédito, IA).
8. Conformidade com licenças MIT e de terceiros da engine.
9. Política de conteúdo gerado por IA da plataforma e regime de direitos aplicável.
10. Classificação indicativa (ClassInd no Brasil, IARC/outras nas lojas) para temas de horror, suicídio mencionado e violência implícita.
11. Privacidade: o jogo é offline e não coleta dados; confirmar que métricas de playtest locais não exigem política adicional.
12. Tributação e forma jurídica de recebimento (fora do escopo técnico, mas pré-requisito de venda).
