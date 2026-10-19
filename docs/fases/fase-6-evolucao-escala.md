# Fase 6: Evolução e escala

| | |
|---|---|
| **Objetivo** | Crescer em três direções, uma de cada vez: mais dados com pouco esforço, mais ruas e condições, e mais capacidade de medição |
| **Duração estimada** | 3 a 6 meses, contínua |
| **Subagente principal** | [`evolucao-escala`](../../.claude/agents/evolucao-escala.md) |
| **Subagentes de apoio** | [`treino-modelos`](../../.claude/agents/treino-modelos.md), [`rotulagem-dataset`](../../.claude/agents/rotulagem-dataset.md), [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Sistema em uso no piloto, correções acumuladas |
| **Saídas** | Ciclo mensal de retreino, datasets v1.x e v2, avaliação fora de Caruaru, medição de profundidade, dataset aberto publicado |

---

## Passo a passo

### Passo 1. Ciclo mensal de retreino

1. Todo mês, junte as correções exportadas do painel.
2. **Aprendizado ativo**: além das correções, selecione automaticamente os quadros em que o modelo ficou em dúvida (confiança entre 0,3 e 0,6, ou classes discordantes entre quadros vizinhos) e rotule só esses.
3. Gere a nova versão do dataset (v1.2, v1.3...).
4. Retreine e avalie **no mesmo conjunto de teste fixo**.
5. A versão nova só substitui a antiga se for **melhor no teste fixo** e não piorar nenhuma classe principal em mais de 2 pontos de AP.
6. Registre no diário: versão, ganho, classes que melhoraram ou pioraram.

### Passo 2. Mais ruas e mais condições

1. Inclua novas obras e bairros, sempre **separando ruas novas para teste antes de treinar**.
2. Cubra outros tipos de peça: sextavado, bloco em I, paralelepípedo de outras pedreiras.
3. Trate como condições testadas, não ignoradas: pavimento molhado, fim de tarde, sombra de árvore.
4. Teste em **outra cidade** (por exemplo, Garanhuns ou Recife) para medir quanto o modelo perde fora de Caruaru e quantas imagens novas recuperam o desempenho. Esse resultado é forte para o artigo.

### Passo 3. Medição de profundidade

1. **Drone com fotogrametria** nos trechos com suspeita de afundamento:
   - voo baixo, sobreposição de 75% a 80%, pontos de controle com GPS de precisão se possível;
   - processamento no WebODM (aberto), DJI Terra ou Pix4D;
   - modelo digital de superfície, plano de referência ajustado nas bordas do afundamento, profundidade máxima e volume.
2. **LiDAR do iPhone Pro** para medição pontual de buracos e recalques.
3. Compare as duas com a régua de 3 m e registre o erro.
4. Teste a hipótese: a **curvatura das juntas** na imagem 2D estima o afundamento? Se sim, é um resultado novo para o artigo.

### Passo 4. Ampliar o escopo

1. **Asfalto no mesmo sistema**: comece por um modelo treinado no RDD2022 e ajuste com imagens locais.
2. **Aceleração do celular** gravada junto do vídeo, para confirmar afundamentos pela vibração.
3. **Modelo leve no celular** (TFLite ou CoreML) para mostrar o defeito na tela durante a vistoria.

### Passo 5. Publicar o dataset aberto

1. Revisão final de anonimização em todas as imagens.
2. Publicar no **Zenodo** com DOI, sob CC BY 4.0, com o guia de rotulagem e o `LEIAME.md`.
3. Publicar os pesos do melhor modelo no Hugging Face com um **card do modelo**: onde funciona, onde erra, dados de treino, licença.
4. Uma página de demonstração (Hugging Face Spaces) onde qualquer pessoa sobe uma foto e vê a detecção.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F6-01 | Script de aprendizado ativo | `evolucao-escala` |
| F6-02 | Primeiro ciclo mensal de retreino | `evolucao-escala` + `treino-modelos` |
| F6-03 | Novas ruas e tipos de peça | Eliakim + `rotulagem-dataset` |
| F6-04 | Avaliação em outra cidade | `evolucao-escala` |
| F6-05 | Profundidade por drone | Eliakim + `evolucao-escala` |
| F6-06 | Profundidade por LiDAR do celular | Eliakim |
| F6-07 | Teste da curvatura das juntas | `pos-treino-medicao` |
| F6-08 | Dataset no Zenodo com DOI | `evolucao-escala` + `redator-artigo` |
| F6-09 | Pesos e card do modelo no Hugging Face | `evolucao-escala` |
| F6-10 | Demonstração pública | `evolucao-escala` |

---

## Portão para avançar à fase 7

- [ ] Desempenho mantido (queda de até 5 pontos de mAP50) em ruas e cidades que o modelo nunca viu.
- [ ] Processamento de uma passada leva menos tempo que a própria passada.
- [ ] Pelo menos 3 ciclos mensais de retreino concluídos.
- [ ] Dataset publicado com DOI.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Ciclos de retreino | 3 |
| Queda de mAP50 em cidade nova | até 5 pontos |
| Erro de profundidade (drone) | acompanhar |
| Ruas no dataset | crescente |
| Dataset publicado | sim |

## O que registrar para o artigo

- Curva de desempenho por ciclo de retreino.
- Generalização para outra cidade e o custo em imagens para recuperar.
- Erro de profundidade por método.
- Link e DOI do dataset.
