# Estrutura do artigo

Este arquivo é o mapa do artigo. Cada seção diz **o que vai conter**, **de onde vêm os dados** (fase e arquivo) e **em que estado está**. O subagente [`redator-artigo`](../../.claude/agents/redator-artigo.md) mantém o mapa atualizado e escreve os rascunhos em `docs/artigo/rascunho/`.

## Título de trabalho

Detecção, dimensionamento e classificação de severidade de patologias em pavimentos intertravados e de paralelepípedo com visão computacional: a grade de peças como referência métrica.

## Revista-alvo e plano de publicação

| Ordem | Venue | Formato | Conteúdo | Quando |
|---|---|---|---|---|
| 1 | Congresso da ANPET | Artigo de congresso, português | Piloto: fases 1 a 4 em 4 ruas | Depois da fase 4 |
| 2 | Congresso da ABES | Trabalho técnico | Passivo de vala em obras de saneamento (fase 5) | Depois da fase 5 |
| 3 | **Transportes (ANPET)** | Artigo de periódico, português | Artigo principal: coleta, detecção, medição e severidade | Depois da fase 6 (com dataset publicado) |
| 4 | Engineering Failure Analysis, International Journal of Pavement Engineering ou Automation in Construction | Artigo internacional, inglês | Gêmeo digital e previsão (fase 7) | Depois de 6 a 12 meses de histórico |

A revista *Transportes* é a escolha natural para o artigo principal: é a mesma revista do artigo de referência, publica em português, é de acesso aberto e já tem revisores familiarizados com o método.

## Perguntas de pesquisa

1. Uma captura de baixo custo detecta defeitos em pavimento intertravado e de paralelepípedo com desempenho comparável ao obtido em asfalto?
2. A técnica de coleta (câmera apontada para o pavimento, celular no para-brisa, celular de mão) muda o desempenho da detecção **e o erro de medição**?
3. A grade de peças, usada como referência métrica, mede área, comprimento e peças afetadas com erro aceitável em relação à trena?
4. A severidade calculada pelas medidas concorda com a avaliação do engenheiro tanto quanto dois engenheiros concordam entre si?

## Seções

| Seção | Conteúdo | Fonte dos dados | Estado |
|---|---|---|---|
| Resumo e abstract | Objetivo, método, 3 números principais, conclusão | Todas | Esperando resultados |
| 1. Introdução | Pavimento de peças nas cidades brasileiras; passivo de obras de saneamento; lacuna na literatura (sem dataset de intertravado e paralelepípedo, sem medição pela grade) | Revisão | Pode começar |
| 2. Revisão | Detecção em asfalto (Freitas et al., 2024; RDD2022; PaveSync); pavimento de pedra (Guerrieri e Parla, 2022); medição por homografia e por LiDAR; ASTM E2840 e NBR 9781 | `referencias.md` | Pode começar |
| 3.1 Área de estudo | Ruas, tipos de peça, referência de escala | Fase 0 e 1; `kanban.json` campo `ruas` | Esperando fase 1 |
| 3.2 Coleta | Configurações C1 a C4, equipamentos, velocidades, filtros | Fase 1; relatórios de coleta | Esperando fase 1 |
| 3.3 Verdade de campo | Vistoria de 50 defeitos, dupla avaliação | Fase 1; `vistoria.csv` | Esperando fase 1 |
| 3.4 Classes e severidade | Guia de rotulagem, origem dos limites | `guia-rotulagem.md`, `comparacao-astm-e2840.md` | Pronto para rascunho (guia v1 fechado em 2026-10-20) |
| 3.5 Dataset | Rotulagem, pré-rótulos, concordância, divisão por rua | Fase 2; `dataset-v1.md` | Esperando fase 2 |
| 3.6 Modelos | Ajuste fino, arquiteturas, parâmetros, hardware | Fase 3; `experimentos.md` | Esperando fase 3 |
| 3.7 Medição pela grade | Juntas, cantos, homografia, projeção, medidas | Fase 4 | Esperando fase 4 |
| 4.1 Resultados de detecção | Tabela no formato da Tabela 2 de Freitas et al.; por pavimento e configuração | Fase 3 | Esperando fase 3 |
| 4.2 Resultados de medição | Erro de área, comprimento e peças; Bland-Altman | Fase 4 | Esperando fase 4 |
| 4.3 Resultados de severidade | Matriz de confusão; kappas | Fase 4 | Esperando fase 4 |
| 4.4 Aplicação em obra | Piloto: tempo, taxa de descarte, casos | Fase 5 | Esperando fase 5 |
| 5. Discussão | Comparação com o artigo de referência (o que é comparável e o que não é); limitações (profundidade em 2D, GPS, tipos de peça) | Todas | Esperando resultados |
| 6. Conclusões | Respostas às 4 perguntas | Todas | Esperando resultados |
| Disponibilidade de dados | DOI do dataset, repositório, pesos | Fase 6 | Esperando fase 6 |

## Figuras e tabelas previstas

| Nº | Conteúdo | Fase | Arquivo |
|---|---|---|---|
| Fig. 1 | Kit de coleta e posição da câmera nas configurações | 0 e 1 | `figuras/kit-c1.jpg` |
| Fig. 2 | Exemplo de cada classe nos dois tipos de pavimento | 2 | `figuras/classes.png` |
| Fig. 3 | Pipeline de medição: quadro, grade, vista de cima, medida | 4 | `figuras/pipeline-medicao.png` |
| Fig. 4 | Acertos e erros (rótulo x previsão) | 3 | `figuras/acertos-erros.png` |
| Fig. 5 | Bland-Altman da área | 4 | `figuras/bland-altman-area.png` |
| Tab. 1 | Dataset: imagens e instâncias por classe e divisão | 2 | `dataset-v1.md` |
| Tab. 2 | Detecção por modelo, pavimento e configuração | 3 | `experimentos.md` |
| Tab. 3 | Erro de medição | 4 | relatório da fase 4 |
| Tab. 4 | Severidade: matriz de confusão e kappas | 4 | relatório da fase 4 |

## Cuidados que os revisores vão cobrar

- Declarar a inicialização dos modelos (pesos pré-treinados) e todos os parâmetros.
- Explicar por que a divisão é por rua e mostrar o efeito (comparar com divisão aleatória num experimento extra).
- Separar resultados de intertravado e de paralelepípedo.
- Não comparar números com o artigo de referência como se fossem o mesmo problema: as classes, o pavimento e a divisão diferem.
- Limitações explícitas: profundidade sem 3D, erro de GPS, tipos de peça não testados.
