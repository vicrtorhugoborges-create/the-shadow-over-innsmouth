# 23 — Testes, validação e critérios de qualidade

> Este plano separa sempre **resultado esperado** (meta) de **resultado observado** (medido). Nenhum teste deste documento foi executado: não existe implementação. Todo relatório futuro usa o modelo do §6.

## 1. Testes técnicos

Tipos de execução: **HL** headless (lógica, importação, invariantes) · **GX** execução gráfica do export Windows (imagem, som, input, desempenho) · **MAN** verificação manual humana.

| Área | O que testar | Tipo | Critério de aprovação |
|---|---|---|---|
| Movimento (`sys_player`) | Velocidade independente de FPS; degraus; agachar sob obstáculos; estados `locked`, `climbing`, `hidden`, `eyes_closed` | HL + GX | Distância/segundo igual em 30/60/144 FPS (tolerância a definir no spike); nenhum atravessamento |
| Câmera (`sys_camera`) | Pitch/yaw, FOV, inversão, tremor 0, modo `seated` | HL + GX | Tremor 0 = deslocamento nulo; limites respeitados |
| Colisão | Corredores do hotel, telhados, ponte coberta, corte de mato | GX | Nenhum ponto em que o jogador fique preso (varredura de rota) |
| Interação (`sys_interaction`) | Oclusão, alvo central, segurar/tocar, disponibilidade | HL | Nenhum pedido indevido |
| Navegação de NPCs | Patrulhas não bloqueiam rotas obrigatórias | HL + GX | Rota obrigatória livre em 100% das execuções do harness |
| IA (`sys_perception`, `sys_pursuit`) | Harness de jogador simulado (ótimo, lento, errado, assistido) | HL | Sem captura antes do tempo máximo; sem estado sem saída |
| Eventos | Unicidade, ordem, condição, pausa | HL | Evento único nunca repete após save |
| Inventário | Idempotência, limite, consumo | HL | Invariantes de 17 |
| Salvamento | Arquivos válidos, truncados, tipos errados, IDs desconhecidos, esquema futuro, caminho injetado, gravação interrompida | HL | Estado vivo intacto; backup recuperado; `.corrupt` preservado |
| Carregamento | Cada `cp_*` carrega com spawn válido; streaming de distritos | HL + GX | 100% dos checkpoints; travadas dentro da meta de 19 (medidas) |
| Persistência narrativa | Matriz checkpoint × fatos × eventos únicos | HL | Nenhuma concessão duplicada; nenhum item essencial perdido |
| Seleção de capítulo | `entry_state` de cada capítulo | HL | Cada capítulo completável a partir da seleção |
| Performance | Tempo de quadro, memória, carga, tamanho da instalação | GX | Metas de 19 **medidas** no hardware mínimo e recomendado |
| Pausa | Simulação, perigo, sequências, legendas | HL + GX | Nada avança durante pausa ou leitura |
| Acessibilidade | Itens de 16 | GX + MAN | Checklist completo |
| Localização | Chaves faltantes, overflow de texto | HL + GX | Zero faltantes; nenhum corte de texto em 17–32 |

## 2. Testes narrativos

| Área | Pergunta | Método |
|---|---|---|
| Coerência | A ordem dos acontecimentos respeita a cronologia de 14–16 jul 1927 e do epílogo? | Revisão contra 01 e 05 |
| Fidelidade | Cada elemento [O] está marcado e nenhum é apresentado como fato do conto? | Auditoria de textos contra 02 |
| Clareza das pistas | O jogador encontra a loja da Eliot, a rota norte no hotel e a estação sem dicas? | Playtest: % que usa dica por puzzle |
| Progressão | Algum objetivo fica sem pista acessível? | Revisão + playtest |
| Continuidade espacial | A vista da janela corresponde à rota de ch07? As ruas noturnas são as mesmas do dia onde o conto as repete? | Revisão com 06 e capturas |
| Impacto emocional | Quais momentos os jogadores lembram uma semana depois? | Entrevista posterior |
| Compreensão do final | O jogador entende que o narrador descende de Obed Marsh e que a decisão final é ambígua? | Perguntas abertas pós-sessão |

## 3. Testes de terror

| Dimensão | Indicadores observáveis | Pergunta ao jogador |
|---|---|---|
| Antecipação | Hesitação antes de portas, viradas de câmera para trás | "Em que momento você começou a esperar algo ruim?" |
| Vulnerabilidade | Busca por esconderijo em vez de correr | "Você se sentiu capaz de se defender?" |
| Eficiência do áudio | Reação a sons sem estímulo visual (cerco, casas tapadas) | "O que você ouviu que não viu?" |
| Legibilidade do perigo | Capturas compreendidas vs. "injustas" | "Você sabia por que foi pego?" |
| Frequência de sustos | Contagem de sobressaltos por capítulo | "Algum susto pareceu gratuito?" |
| Qualidade das revelações | Reação ao porão da igreja, ao grito de Zadok, à procissão, à tiara no cofre | "Qual revelação mais marcou?" |
| Exploração noturna | Reconhecimento de lugares vistos de dia | "Você reconheceu ruas por onde passou de tarde?" |

## 4. Playtests

### 4.1. Perfis

| Grupo | Composição mínima | Objetivo |
|---|---|---|
| A — conhecem o conto | 3–5 pessoas que leram *The Shadow over Innsmouth* | Fidelidade, expectativa, surpresa apesar do conhecimento |
| B — não conhecem Lovecraft | 3–5 pessoas sem leitura prévia | Compreensão sem conhecimento externo; clareza da genealogia |
| C — jogadores de horror | 2–3 pessoas | Comparação com o gênero, ritmo |
| D — acessibilidade | ≥ 1 pessoa com necessidade de legendas, remapeamento ou redução de efeitos | Opções de 16 |

### 4.2. Protocolo

1. Sessão gravada (tela e, com consentimento, áudio comentado), sem ajuda do observador, exceto bloqueio total após 5 min.
2. Questionário imediato + entrevista curta.
3. Para os grupos A e B, pergunta de compreensão do final uma semana depois (opcional).
4. Dados pessoais minimizados; consentimento por escrito; gravações guardadas localmente e apagadas ao fim do ciclo.

### 4.3. Métricas

**Quantitativas** (medidas pelo jogo em build de teste, sem envio online — registro local exportado manualmente pelo testador):
* tempo por capítulo e por puzzle;
* número de capturas/quedas por checkpoint;
* níveis de dica solicitados por puzzle;
* uso de opções de acessibilidade;
* abandono (ponto em que a sessão parou).

**Qualitativas:** escala 1–5 para tensão, clareza, conforto, interesse no epílogo; respostas abertas.

### 4.4. Metas iniciais (esperado, não observado)

| Métrica | Meta |
|---|---|
| Duração total (primeira jogada) | 3h10–4h50 |
| Puzzles resolvidos sem dica | ≥ 70% dos jogadores em `pz05`–`pz09` |
| Capturas percebidas como injustas | ≤ 1 em 5 relatos |
| Grupo B entende a ligação com os Marsh | ≥ 4 de 5 |
| Jogadores que reconhecem ruas noturnas | ≥ 3 de 5 |
| Relatos de enjoo com opções padrão | 0 |

## 5. Matriz de qualidade por gate

| Gate | Técnicos | Narrativos | Terror | Playtest |
|---|---|---|---|---|
| Fase 1 | Movimento, câmera, interação, save, pausa, render, áudio | — | — | interno |
| Fase 2 | + cerco, checkpoints, captura | Gilman fiel a 08 | Antecipação, legibilidade | ≥ 5 pessoas (A+B) |
| Fase 3 | + streaming, NPCs, documentos | ch01–ch03 parcial | Estranhamento | ≥ 8 pessoas (A–D) |
| Fase 4 | Todos os capítulos | Campanha completa | Todas as dimensões | ≥ 3 campanhas completas |
| Fase 5 | Desempenho medido | Revisão integral | Ajuste | ≥ 8 pessoas |
| Fase 6 | Regressão completa | Final compreendido | — | amostra ampliada |

## 6. Modelo de relatório

```text
Teste: <ID da tarefa ou área>
Build/versão: <identificação>
Ambiente: <SO, CPU, GPU, RAM, resolução> — ou "headless"
Comando/procedimento: <exato>
Esperado: <meta>
Observado: <resultado medido>
Evidências: <arquivo de log, captura>
Limitações: <o que não foi possível validar>
Conclusão: aprovado / reprovado / pendente
```
