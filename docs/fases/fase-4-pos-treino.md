# Fase 4: Pós-treino

| | |
|---|---|
| **Objetivo** | Transformar o detector em sistema: máscaras viram medida em unidades reais, grau de dano e um único defeito no mapa |
| **Duração estimada** | 3 a 4 semanas |
| **Subagente principal** | [`pos-treino-medicao`](../../.claude/agents/pos-treino-medicao.md) |
| **Subagentes de apoio** | [`rotulagem-dataset`](../../.claude/agents/rotulagem-dataset.md) (correção de rótulos), [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Pesos da fase 3, planilha de vistoria da fase 1, dataset v1 |
| **Saídas** | Dataset v1.1, limiares por classe, módulos `src/medicao/`, `src/rastreamento/`, `src/pipeline/`, modelos exportados em ONNX, relatório de erro de medição e de severidade |

---

## Passo a passo

### Passo 1. Análise de erros

1. Rode o melhor modelo na validação e liste os **50 piores erros** (falsos positivos com maior confiança e falsos negativos de defeitos grandes).
2. Para cada um, classifique a causa numa planilha:
   - rótulo errado ou incompleto;
   - sombra ou reflexo;
   - junta confundida com trinca;
   - defeito pequeno ou distante;
   - borrão de movimento;
   - classe ambígua.
3. Corrija os rótulos errados e gere o **dataset v1.1** (o teste continua congelado; só treino e validação mudam).
4. Retreine o melhor modelo no v1.1. Esse passo costuma render mais que trocar de arquitetura.

### Passo 2. Escolher o limiar de confiança por classe

1. Para cada classe, trace precisão e recall em função do limiar.
2. Em fiscalização, é melhor **perder pouco defeito**, mesmo com mais alarme falso, porque o engenheiro revisa. Escolha o limiar que dá **recall de 0,85 ou mais** com a melhor precisão possível.
3. Registre os limiares em `src/pipeline/limiares.json`.

### Passo 3. Calcular a homografia pela grade

Esta é a contribuição metodológica central do projeto.

1. O modelo da grade segmenta as juntas.
2. O módulo `src/medicao/grade.py`:
   - esqueletiza a máscara de juntas (afina para linhas de 1 pixel);
   - detecta as linhas dominantes (transformada de Hough ou ajuste de retas por regiões);
   - encontra os cruzamentos, que são os cantos das peças;
   - casa os cantos com uma grade ideal de peças com a **dimensão real medida na rua** (as 20 peças da fase 1).
3. Com 4 ou mais pares de pontos, calcula a **homografia** do quadro (`cv2.findHomography` com RANSAC para descartar cantos ruins).
4. Avalia a qualidade: erro de reprojeção dos cantos. Se o erro passar de um limite, o quadro é marcado como "sem escala confiável" e a medida não é usada.

Para paralelepípedo, a grade é irregular (pedras de 16 a 22 cm). Use a **média de muitas pedras no quadro** e a referência medida na rua, não uma pedra isolada.

### Passo 4. Medir os defeitos

1. Projete a máscara de cada defeito para vista de cima com a homografia.
2. Calcule:
   - **área** em m²;
   - **comprimento e largura** pelo retângulo mínimo da máscara projetada;
   - **peças afetadas**: quantas células da grade a máscara cobre em mais de 50%;
   - **largura de junta**: largura média da máscara de junta dentro da área do defeito, em mm.
     > Alerta do chanfro (guia v2, P18): a norma gradua a junta pela largura **real**, descontado o chanfro da peça (ASTM E2840, X1.4.3). Na imagem, a abertura aparente inclui o chanfro e **superestima a largura**. Estime o viés comparando com o paquímetro da vistoria (Passo 5) e corrija antes de aplicar os graus de 6, 10 e 13 mm.
3. **Profundidade** só quando houver 3D (LiDAR ou drone, fase 6). Sem 3D, registre "não medida" e declare isso no artigo.

### Passo 5. Comparar com a vistoria de campo

1. Encontre cada um dos 50 defeitos medidos nas imagens (pelo número escrito com giz e pela coordenada).
2. Compare medida do sistema contra trena:
   - erro médio absoluto e erro percentual de área, comprimento e largura;
   - acerto exato e erro de uma peça na contagem de peças afetadas;
   - gráfico de Bland-Altman para a área.
3. **Meta de aceitação da medição** (guia v2, P29). O projeto adota como critério a tolerância que a ASTM E2840 dá para o inspetor que remede em campo (seção 8.1):
   - **tipo de defeito** identificado corretamente em **95%** dos defeitos medidos;
   - **medida linear** (comprimento, largura, extensão de borda) dentro de **10%** da remedição em campo;
   - **área** dentro de **20%** da remedição em campo.

   Uma medida conta como aceita quando o erro daquele defeito fica dentro da tolerância; reporte o percentual de defeitos aceitos em cada medida. A norma fixa essas tolerâncias para pessoas; usá-las para o sistema automático é escolha do projeto e deve ser declarada assim no artigo.
4. Faça a comparação separadamente para as configurações C1, C2 e C3, e para intertravado e paralelepípedo.

### Passo 6. Classificar a severidade

1. Aplique as regras de grau do guia de rotulagem sobre as medidas (ex.: junta com largura real acima de 13 mm = alta, guia v2).
2. Compare com a nota do engenheiro:
   - acurácia;
   - **kappa ponderado** sistema contra avaliador 1;
   - kappa entre avaliador 1 e avaliador 2 nos 10 defeitos com dupla nota.
3. Ajuste os limites que mais erram e documente cada ajuste (com o antes e o depois) no diário de pesquisa.

### Passo 7. Um defeito, uma linha

1. Rastreie o mesmo defeito entre quadros seguidos com ByteTrack (ou por sobreposição das máscaras projetadas no plano da rua).
2. Junte as detecções num único registro e escolha a **melhor vista**: a mais próxima, mais nítida e com escala confiável.
3. Associe a coordenada GPS daquele quadro.

### Passo 8. Empacotar o pipeline

1. Exporte os modelos para **ONNX** (e TensorRT, se for rodar em placa embarcada).
2. Crie o comando único:
   ```bash
   python -m src.pipeline.processar \
     --entrada dados/brutos/2026-12-02_rua-exemplo_C1_p01/ \
     --rua rua-exemplo \
     --saida resultados/2026-12-02_rua-exemplo.csv
   ```
3. Saída: uma linha por defeito com `id`, `classe`, `grau`, `area_m2`, `comprimento_cm`, `largura_cm`, `pecas_afetadas`, `largura_junta_mm`, `latitude`, `longitude`, `confianca`, `foto`, `escala_confiavel`.
4. Teste de ponta a ponta numa passada que o modelo nunca viu.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F4-01 | Análise dos 50 piores erros | `pos-treino-medicao` |
| F4-02 | Dataset v1.1 e retreino | `rotulagem-dataset` + `treino-modelos` |
| F4-03 | Limiares por classe | `pos-treino-medicao` |
| F4-04 | Módulo da grade e homografia | `pos-treino-medicao` |
| F4-05 | Módulo de medidas | `pos-treino-medicao` |
| F4-06 | Comparação com a vistoria de campo | `pos-treino-medicao` |
| F4-07 | Regras de severidade e kappa | `pos-treino-medicao` |
| F4-08 | Rastreamento e melhor vista | `pos-treino-medicao` |
| F4-09 | Exportação ONNX e pipeline de ponta a ponta | `pos-treino-medicao` |
| F4-10 | Relatório de medição para o artigo | `redator-artigo` |

---

## Portão para avançar à fase 5 (metas do piloto, ajustáveis)

- [ ] Erro médio de **área abaixo de 20%** na configuração C1.
- [ ] Meta de aceitação da medição na C1 (ASTM E2840, 8.1): **tipo certo em 95%** dos defeitos, **medida linear dentro de 10%** e **área dentro de 20%** da remedição em campo. A norma não diz em que proporção dos defeitos as medidas devem ficar dentro da tolerância: definir esse percentual antes da F4-06.
- [ ] Contagem de peças afetadas **exata na maioria dos casos** (meta: 60% exata e 90% com erro de até uma peça).
- [ ] **Kappa de severidade** do sistema próximo ao kappa entre os dois avaliadores humanos.
- [ ] Pipeline de ponta a ponta roda numa passada nova sem intervenção manual.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Erro médio de área (C1) | abaixo de 20% |
| Tipo de defeito correto (C1) | 95% |
| Defeitos com medida linear dentro de 10% (C1) | percentual mínimo a definir pelo Eliakim (a norma não fixa) |
| Defeitos com área dentro de 20% (C1) | percentual mínimo a definir pelo Eliakim (a norma não fixa) |
| Peças afetadas: acerto exato | 60% |
| Peças afetadas: erro de até 1 | 90% |
| Kappa sistema x avaliador | perto do kappa humano |
| Quadros com escala confiável | 80% |
| Recall no limiar escolhido | 0,85 |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Grade mal detectada em peça sextavada ou em I | Grade ideal específica por tipo de peça; registre o tipo da rua |
| Erro de escala alto no paralelepípedo | Mais pedras por quadro (câmera mais alta ou mais distante); média robusta |
| Afundamento sem medida | Declarar fora do escopo 2D; testar a hipótese da curvatura das juntas como indicador |
| Mesmo defeito contado duas vezes | Juntar por posição no plano da rua além do rastreamento |

## O que registrar para o artigo

- Descrição do método de homografia pela grade, com figura (quadro original, grade detectada, vista de cima).
- Tabela de erro de medição por configuração e por tipo de pavimento.
- Gráfico de Bland-Altman.
- Matriz de confusão de severidade e os kappas.
- Ajustes nos limites de severidade e a justificativa.
