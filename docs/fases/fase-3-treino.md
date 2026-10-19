# Fase 3: Treino dos modelos

| | |
|---|---|
| **Objetivo** | Ter dois modelos funcionando (defeitos e grade) e saber qual configuração de coleta rende melhor |
| **Duração estimada** | 3 a 4 semanas |
| **Subagente principal** | [`treino-modelos`](../../.claude/agents/treino-modelos.md) |
| **Subagentes de apoio** | [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | `dados/datasets/v1/` com teste congelado |
| **Saídas** | Pesos dos dois modelos em `modelos/`, tabela de experimentos em `docs/artigo/experimentos.md`, métricas por classe e por configuração, scripts de `src/treino/` |

---

## Treino do zero ou ajuste fino?

**Ajuste fino (transferência de aprendizado).** Ninguém treina um detector do zero com cerca de mil imagens. Todos os modelos partem de pesos pré-treinados (no COCO para os detectores, no ImageNet ou ADE20K para a segmentação) e são ajustados com as imagens do projeto.

O artigo de referência não informa explicitamente a inicialização, mas seus parâmetros (filters = 21, max_batches = 4000, steps em 80% e 90%) seguem a receita padrão do Darknet para treino customizado, que parte de pesos pré-treinados. No seu artigo, **declare a inicialização explicitamente**.

---

## Passo a passo

### Passo 1. Preparar o ambiente de treino

| Opção | Quando usar |
|---|---|
| Google Colab ou Kaggle | Linha de base e experimentos pequenos; GPU gratuita com limite de tempo |
| GPU alugada por hora | Treinos maiores e comparação completa |
| Computador com GPU dedicada | Se tiver, para iterar rápido |

```bash
python -m venv .venv && source .venv/bin/activate
pip install ultralytics rfdetr transformers sahi wandb
```

Registre as versões exatas instaladas em `requirements.txt` com `pip freeze > requirements.txt`.

### Passo 2. Linha de base rápida

1. Treine um YOLO de segmentação pequeno com os parâmetros padrão, só para saber se o dataset tem problema:
   ```bash
   yolo segment train data=dados/datasets/v1/data.yaml model=yolo11n-seg.pt epochs=50 imgsz=1024 seed=42
   ```
2. Olhe as curvas de perda e as primeiras previsões. Se o modelo não aprende nada numa classe, o problema costuma ser rótulo ou poucas instâncias, não o modelo.
3. Registre como experimento `E000` na tabela.

### Passo 3. Modelo de defeitos

Compare três famílias, sempre com o mesmo conjunto de validação e semente fixa:

| Experimento | Modelo | Por que testar |
|---|---|---|
| E010 | YOLO11 ou YOLO26 com segmentação, tamanho s | Referência atual da família usada no artigo |
| E011 | Mesmo modelo, tamanho m | Ver se modelo maior compensa |
| E020 | RF-DETR com segmentação | Licença Apache-2.0, caminho para produto |
| E030 | YOLO com **caixas** (sem máscara) | Comparação direta com o artigo de referência |

Cuidados:

- **Resolução de entrada alta** (1024 ou 1280) ou **recorte em blocos** com SAHI. O artigo de referência perdeu desempenho ao reduzir 4K para 512 pixels.
- **Aumento de dados**: brilho, contraste, sombra simulada, borrão de movimento leve, espelhamento horizontal. Evite rotações grandes: a perspectiva da câmera é sempre parecida.
- **Semente fixa** (`seed=42`) e registro de todos os parâmetros.

### Passo 4. Modelo da grade

1. Treine uma rede de segmentação semântica (SegFormer-B0 ou U-Net) com as classes `fundo`, `junta`, `peca`.
2. Métrica principal: IoU da classe `junta`. Juntas são finas; use perda que valorize pixels raros (Dice ou focal).
3. Teste visual: as linhas de junta saem contínuas o suficiente para encontrar os cantos das peças?

```bash
python -m src.treino.treinar_grade \
  --dataset dados/datasets/v1/grade/ \
  --modelo segformer-b0 \
  --epocas 80 \
  --saida modelos/grade_segformer-b0_v1.pt
```

### Passo 5. Experimentos por configuração de coleta

Esta é a parte que repete a contribuição do artigo de referência:

1. Treine o melhor modelo de defeitos separadamente com imagens **só C1** e **só C2**.
2. Avalie cada um no teste da mesma configuração e também na configuração cruzada (treina C1, testa C2).
3. Registre tudo numa tabela no mesmo formato da Tabela 2 do artigo de referência (AP por classe, precisão, recall, F1, mAP).

### Passo 6. Avaliar no conjunto de teste fixo

1. Só depois de escolher o melhor modelo na validação, rode **uma vez** no teste.
2. Reporte: mAP50, mAP50-95, AP por classe, precisão e recall; separados por tipo de pavimento (intertravado e paralelepípedo) e por configuração.
3. Salve exemplos de acerto e erro para o artigo (figuras no estilo das figuras 2 a 7 do artigo de referência).

### Passo 7. Registrar os experimentos

Cada experimento ocupa uma linha em `docs/artigo/experimentos.md`:

```markdown
| ID | Data | Dataset | Modelo | Resolução | Épocas | Aumento | mAP50 val | mAP50-95 val | Observação |
```

Se usar Weights & Biases, ponha o link da execução na coluna de observação.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F3-01 | Ambiente de treino e `requirements.txt` | `treino-modelos` |
| F3-02 | Linha de base E000 | `treino-modelos` |
| F3-03 | Experimentos de defeitos E010, E011, E020, E030 | `treino-modelos` |
| F3-04 | Modelo da grade | `treino-modelos` |
| F3-05 | Experimentos por configuração (C1, C2, cruzado) | `treino-modelos` |
| F3-06 | Avaliação única no teste fixo | `treino-modelos` |
| F3-07 | Figuras de acerto e erro | `treino-modelos` + `redator-artigo` |
| F3-08 | Tabela de experimentos atualizada | `redator-artigo` |

---

## Portão para avançar à fase 4 (metas do piloto, ajustáveis)

- [ ] mAP50 de **0,70 ou mais** nas classes principais com a configuração C1, no conjunto de teste.
- [ ] Modelo da grade encontra os cantos das peças na maior parte dos quadros de teste (meta: 80%).
- [ ] Tabela de experimentos completa, com parâmetros e sementes.

Se a meta não for atingida, o orquestrador abre tarefas de volta à fase 2 (mais rótulos ou correção) antes de insistir em ajustes de modelo.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| mAP50 no teste (C1) | 0,70 |
| mAP50-95 no teste (C1) | acompanhar |
| IoU da classe junta | 0,60 |
| Quadros com cantos encontrados | 80% |
| Experimentos registrados | todos |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Junta confundida com trinca | Mais imagens sem defeito; usar a máscara da grade para filtrar detecções finas sobre juntas |
| Defeitos pequenos não detectados | Resolução maior ou SAHI |
| Sobreajuste (treino ótimo, validação ruim) | Mais aumento de dados, modelo menor, parar mais cedo |
| Tempo de GPU esgotado | Treinar o modelo s antes do m; usar GPU alugada só para a comparação final |

## O que registrar para o artigo

- Inicialização (pesos pré-treinados), parâmetros, sementes, hardware, tempo de treino.
- Tabela de resultados por modelo, por classe, por tipo de pavimento e por configuração de coleta.
- Exemplos visuais de acertos e erros comentados.
