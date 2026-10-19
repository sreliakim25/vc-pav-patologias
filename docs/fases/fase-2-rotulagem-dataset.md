# Fase 2: Rotulagem e dataset v1

| | |
|---|---|
| **Objetivo** | Um dataset pequeno, mas limpo e consistente, dividido por rua, com máscaras de defeitos e um subconjunto com a grade de peças rotulada |
| **Duração estimada** | 3 a 4 semanas |
| **Subagente principal** | [`rotulagem-dataset`](../../.claude/agents/rotulagem-dataset.md) |
| **Subagentes de apoio** | [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Quadros anonimizados da fase 1, guia de rotulagem v1 |
| **Saídas** | `dados/datasets/v1/` com treino, validação e teste; `LEIAME.md` do dataset; guia de rotulagem revisado; scripts de `src/dataset/` |

---

## Por que esta fase existe

Rótulo inconsistente estraga mais o modelo do que falta de imagem. No artigo de referência, várias falhas de detecção foram atribuídas a rótulos incompletos ou incorretos. Aqui, a consistência é medida, não presumida.

---

## Passo a passo

### Passo 1. Escolher a ferramenta de rotulagem

| Ferramenta | Onde roda | Quando escolher |
|---|---|---|
| **CVAT** | No seu computador (Docker) ou em nuvem | Recomendada: máscaras, revisão e exportação para vários formatos, sem enviar dados a terceiros |
| **Label Studio** | No seu computador | Alternativa simples, também local |
| **Roboflow** | Nuvem | Mais rápido de começar; os dados ficam na plataforma, então use só imagens anonimizadas |

Para instalar o CVAT localmente:

```bash
git clone https://github.com/cvat-ai/cvat
cd cvat
docker compose up -d
# acesse http://localhost:8080 e crie o usuário administrador
```

### Passo 2. Criar o projeto de rotulagem

1. Crie um projeto chamado `defeitos-v1` com as classes do [guia de rotulagem](../guias/guia-rotulagem.md), tipo **polígono** (máscara).
2. Crie outro projeto chamado `grade-v1` com duas classes: `junta` e `peca`, tipo **máscara** ou **polígono**.
3. Suba as imagens **por rua**, uma tarefa por rua. Isso já prepara a divisão por rua.

### Passo 3. Gerar pré-rótulos com SAM 3

O subagente `rotulagem-dataset` prepara o script em `src/dataset/prerotular_sam3.py`:

1. Para cada imagem, o SAM 3 recebe textos como `"sunken paving blocks"`, `"missing paver"`, `"broken concrete block"`, `"open joint"`, `"asphalt patch on pavers"`, `"weeds between stones"`.
2. As máscaras propostas são exportadas no formato do CVAT e importadas como rótulos iniciais.
3. **Ninguém confia no pré-rótulo**: ele só economiza tempo de desenho. Toda imagem é revisada.

```bash
python -m src.dataset.prerotular_sam3 \
  --imagens dados/anonimizados/2026-11-05_rua-exemplo_C1_p01/ \
  --classes docs/guias/classes.json \
  --saida dados/prerotulos/rua-exemplo/
```

### Passo 4. Rotular os defeitos

1. Corrija ou desenhe a **máscara** de cada defeito, seguindo o contorno real (não uma caixa).
2. Para afundamento, contorne a área visivelmente rebaixada ou com água parada.
3. Para peça faltante, contorne o buraco deixado pela peça.
4. Para junta aberta, contorne a faixa de juntas abertas, não cada junta isolada.
5. Em caso de dúvida entre duas classes, siga a regra de prioridade do guia e anote a imagem com a tag `duvida`.

### Passo 5. Rotular a grade em um subconjunto

1. Separe **150 a 200 imagens** variadas (diferentes ruas, peças, iluminação).
2. Rotule `junta` como linhas finas (polígonos estreitos) e `peca` como as áreas entre juntas.
3. Este subconjunto treina o modelo da grade, que é a régua do sistema.

### Passo 6. Incluir imagens sem defeito

1. Garanta que **20% a 30%** das imagens não tenham defeito, principalmente pavimento bom com juntas bem marcadas.
2. Elas ensinam ao modelo que junta não é trinca, a maior fonte de falso positivo em pavimento de peças.

### Passo 7. Revisão cruzada

1. Outra pessoa revisa **10% das imagens**, sorteadas por rua, sem ver as notas da primeira.
2. O subagente calcula a concordância: IoU médio das máscaras e acerto de classe.
3. Cada divergência recorrente vira uma regra nova no guia (`v1.1` do guia).
4. Se o IoU médio entre rotuladores ficar abaixo de 0,60 em alguma classe, revise a definição da classe antes de seguir.

### Passo 8. Dividir por rua e exportar

1. Divisão **por rua**, nunca por imagem. Com 4 ruas, uma proposta:
   - treino: 1 rua de intertravado + 1 de paralelepípedo, mais metade das outras duas;
   - validação: um quarto das outras duas;
   - teste: um quarto das outras duas, em trechos contínuos que não aparecem no treino.
   Quando houver mais ruas, separe **ruas inteiras** para o teste.
2. Exporte em formato YOLO de segmentação e em COCO (para o RF-DETR e para o artigo).
3. O conjunto de **teste é fixo**: nunca mais muda. Toda versão futura do modelo é comparada nele.

```bash
python -m src.dataset.dividir_por_rua \
  --rotulos dados/exportados/defeitos-v1/ \
  --plano docs/guias/divisao-v1.json \
  --saida dados/datasets/v1/
```

### Passo 9. Versionar o dataset

1. O script gera `dados/datasets/v1/LEIAME.md` com: data, número de imagens por divisão, instâncias por classe e por grau, ruas em cada divisão, versão do guia usada.
2. Copie esse resumo para o diário de pesquisa.
3. Commit: `data: dataset v1 (contagens no diário de pesquisa)`. Os arquivos de imagem não vão para o Git; só o `LEIAME.md` é copiado para `docs/artigo/dataset-v1.md`.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F2-01 | Instalar CVAT e criar os projetos `defeitos-v1` e `grade-v1` | `rotulagem-dataset` |
| F2-02 | Script de pré-rótulo com SAM 3 | `rotulagem-dataset` |
| F2-03 | Rotular defeitos das 4 ruas | Eliakim |
| F2-04 | Rotular grade em 150 a 200 imagens | Eliakim |
| F2-05 | Garantir 20% a 30% de imagens sem defeito | `rotulagem-dataset` |
| F2-06 | Revisão cruzada de 10% e cálculo de concordância | Revisor + `rotulagem-dataset` |
| F2-07 | Guia de rotulagem v1.1 | `rotulagem-dataset` |
| F2-08 | Divisão por rua e exportação YOLO e COCO | `rotulagem-dataset` |
| F2-09 | LEIAME do dataset v1 e registro no diário | `redator-artigo` |

---

## Portão para avançar à fase 3

- [ ] Algumas centenas de instâncias (meta: 200 ou mais) em cada classe principal.
- [ ] Grade rotulada em pelo menos 150 imagens.
- [ ] IoU médio entre rotuladores de 0,60 ou mais nas classes principais.
- [ ] Divisão por rua concluída e conjunto de teste congelado.
- [ ] Classes com poucos exemplos marcadas no kanban para coleta dirigida.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Imagens rotuladas | 800 |
| Instâncias por classe principal | 200 ou mais |
| Imagens com grade rotulada | 150 |
| IoU entre rotuladores | 0,60 ou mais |
| Imagens sem defeito | 20% a 30% |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Rotulagem lenta | Pré-rótulo com SAM 3; atalhos do CVAT; sessões curtas e frequentes |
| Classes desbalanceadas | Coleta dirigida e aumento de dados; reportar no artigo |
| Discordância entre rotuladores | Regra nova no guia; exemplos visuais de casos limite |

## O que registrar para o artigo

- Ferramenta, versão do guia, regras de prioridade entre classes.
- Contagem por classe, grau e divisão.
- Concordância entre rotuladores por classe.
- Tempo médio de rotulagem por imagem, com e sem pré-rótulo (bom dado para a discussão).
