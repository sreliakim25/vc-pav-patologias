# Comparação do guia de rotulagem com a ASTM E2840 e o Manual de Desempenho ABCP

Data: 2026-10-19 · Tarefas: F0-01 e F0-02 · Situação: **decidido pelo Eliakim em 2026-10-20** (ver seção 6)

Este documento compara as classes e os graus de [guia-rotulagem.md](guia-rotulagem.md) (v1) com duas fontes. Ele separa o que **está escrito na fonte** do que é **proposta** deste projeto. As decisões estão na seção 6 e já foram aplicadas ao guia.

---

## 1. Fontes consultadas

| Fonte | O que tem | Limitação |
|---|---|---|
| ASTM E2840-11 (reaprovada em 2019), *Standard Practice for Pavement Condition Index Surveys for Interlocking Concrete Roads and Parking Lots* | Prévia de 3 páginas: escopo, terminologia, equipamentos, amostragem e ficha de campo (Fig. 2) com os 11 tipos de defeito | **Não traz o Apêndice X1**, onde estão as definições e os graus baixo, médio e alto de cada defeito, nem as curvas de dedução do PCI |
| SILVA, C. O. *Sistema de piso com peças de concreto: pavimento intertravado. Manual de desempenho.* 1. ed. São Paulo: ABCP, BlocoBrasil, 2022. ISBN 978-85-87024-86-2 | Seção 2 (p. 8 a 11): um limite por defeito, citando a ASTM E2840 (edição 2015), e limites de recebimento da NBR 15953 | Fonte secundária. Dá **um limite por defeito**, não os três graus, e não diz a qual grau esse limite corresponde |

Os PDFs ficam em `docs/normas/`, que não vai para o Git (direitos autorais).

**Conferência de edição:** a capa da ASTM informa que a edição de 2019 é reaprovação do texto de 2011, e que a edição anterior foi a E2840-11 (2015). O manual cita a edição de 2015, então as duas fontes tratam do mesmo texto.

---

## 2. Mapeamento das classes

Tipos de defeito da ASTM E2840, conforme a ficha da Fig. 2 (p. 3), e os limites citados pelo manual (p. 8 a 11). As conversões de polegada para milímetro são do manual.

| Nº ASTM | Defeito ASTM | Seção do manual | Limite citado pelo manual (fonte: ASTM) | Classe do guia v1 | Situação |
|---|---|---|---|---|---|
| 1 | Damaged Pavers | 2.3 Peças danificadas | 1 ou 2 peças com fissura, lasca ou canto quebrado, sem separação entre peças | `peca_quebrada` | Equivale; definição do guia é mais estreita |
| 2 | Depressions | 2.4 Depressões | 13 mm sob régua de 3 m | `afundamento` | Equivale; limite diferente do guia |
| 3 | Edge Restraint | 2.5 Contenções laterais danificadas | Junta de 6 a 13 mm junto à contenção, sem rotação da peça ou do meio-fio; problema concentrado entre 0,3 e 0,6 m da borda | `desconfinamento` | Equivale e confirma o grau baixo do guia |
| 4 | Excessive Joint Width | 2.6 Excesso de largura da junta | Até 10 mm em toda a área | `junta_aberta` (parte) | Guia junta dois defeitos ASTM numa classe |
| 5 | Faulting | 2.7 Escalonamento | Degrau máximo de 6 mm, medido com régua de 30 cm; quantidade em m² | `desnivel` | Equivale; preenche o limite "a calibrar" |
| 6 | Heave | 2.8 Elevações | 13 mm sob régua de 3 m; quantidade em m² | nenhuma | **Falta no guia** |
| 7 | Horizontal Creep | 2.9 Fluência horizontal | Desvio de 13 mm no centro de uma linha de 15 m | nenhuma | **Falta no guia** |
| 8 | Joint Sand Loss/Pumping | 2.10 Perda de rejunte ou bombeamento | Perda de até 13 mm de altura, medida a partir do fundo do chanfro | `junta_aberta` (parte) | Guia junta dois defeitos ASTM numa classe |
| 9 | Missing Pavers | 2.11 Falta de peças | Aceitável só 1 peça ausente, de forma aleatória | `peca_faltante` | Equivale e confirma o grau baixo do guia |
| 10 | Patching | 2.12 Remendo | Reparo deve usar peças novas iguais às originais | `remendo` | Equivale |
| 11 | Rutting | 2.13 Trilha de roda | 13 mm sob régua de 3 m colocada transversalmente; quantidade em m² | nenhuma | **Falta no guia** |
| | sem equivalente | | | `vegetacao` | Classe própria do projeto |

**Resultado:** 7 das 8 classes do guia têm equivalente na ASTM E2840. Três defeitos da ASTM não estão no guia: elevação, fluência horizontal e trilha de roda.

### Limites de recebimento (pavimento novo, antes do uso), citados pelo manual

| Item | Limite | Norma |
|---|---|---|
| Depressão | até 10 mm | NBR 15953 (manual, p. 9) |
| Largura de junta | média de 3 mm, entre 2 e 5 mm | NBR 15953 (manual, p. 9 e 16) |
| Fresta entre componentes | até 4 mm | NBR 15575-3 (manual, p. 16) |
| Desnível abrupto em área de pedestre | sinalizar acima de 5 mm | NBR 9050 (manual, p. 16) |
| Planicidade | até 3 mm sob régua de 2 m | NBR 15575-3 (manual, p. 26) |

Esses limites servem para a **fiscalização da recomposição** nas obras de saneamento (pavimento refeito), não para o grau de um defeito em uso.

---

## 3. Divergências e propostas

Cada item abaixo é **proposta** e só entra no guia depois da sua validação.

| # | Classe | O que o guia v1 diz | O que as fontes dizem | Proposta |
|---|---|---|---|---|
| P1 | `afundamento` | Baixo até 15 mm (especificações municipais de paralelepípedo) | ASTM, via manual: 13 mm sob régua de 3 m | Intertravado: usar 13 mm como limite do grau baixo, com fonte ASTM. Paralelepípedo: manter 15 mm. Médio e alto continuam "a calibrar" |
| P2 | `junta_aberta` | Uma classe para junta larga e perda de rejunte, graduada pela largura | A ASTM separa em dois defeitos (4 e 8) com medidas diferentes: largura e profundidade | Dividir em `junta_larga` (medida: largura, mensurável pela grade na imagem) e `perda_rejunte` (medida: profundidade do rejunte, só em campo). O guia passa de 8 para 9 classes |
| P3 | `junta_larga` | Baixo de 6 a 10 mm, médio de 11 a 15 mm, alto acima de 15 mm | ASTM, via manual: aceitável até 10 mm | Manter os valores do guia; o grau baixo coincide com o limite aceitável da ASTM. Trocar a origem para "ASTM E2840 via manual ABCP (2022)" |
| P4 | `perda_rejunte` | Não existe | ASTM, via manual: perda de até 13 mm de altura | Grau baixo até 13 mm; médio e alto "a calibrar" |
| P5 | `desnivel` | Todos os graus "a calibrar" | ASTM, via manual: degrau máximo de 6 mm, régua de 30 cm | Grau baixo até 6 mm; médio e alto "a calibrar". Acrescentar a régua de 30 cm ao método de campo |
| P6 | `desconfinamento` | Baixo: junta aumentada sem rotação | ASTM, via manual: 6 a 13 mm sem rotação, entre 0,3 e 0,6 m da borda | Acrescentar os números ao grau baixo e a faixa de 0,3 a 0,6 m à regra de desenho |
| P7 | `peca_quebrada` | "Peça quebrada", raro em paralelepípedo | ASTM: *damaged pavers*, que inclui fissura, lasca e canto quebrado | Manter o código e ampliar a definição para "peça danificada: fissura, lasca, canto quebrado ou peça partida" |
| P8 | `peca_faltante` | Baixo: 1 peça | ASTM, via manual: aceitável 1 peça isolada | Sem mudança; só trocar a origem do grau baixo para a ASTM |
| P9 | Trilha de roda (ASTM 11) | Não existe | 13 mm, régua de 3 m transversal | Não criar classe: rotular como `afundamento` com a nova tag `trilha_roda`. Na imagem os dois são quase iguais; a diferença é a forma longitudinal no caminho da roda |
| P10 | Elevação (ASTM 6) | Não existe | 13 mm sob régua de 3 m | Não rotular na v1: numa imagem 2D a elevação quase não se distingue. Registrar na planilha de vistoria e reavaliar com profundidade (LiDAR, fase 6) |
| P11 | Fluência horizontal (ASTM 7) | Não existe | Desvio de 13 mm numa linha de 15 m | Não rotular como máscara. Medir como **grandeza derivada da grade** na fase 4 (desvio do alinhamento das juntas). É candidata a contribuição do artigo |
| P12 | `vegetacao` | Classe do projeto | Sem equivalente | Manter e declarar no artigo como classe própria, relevante no paralelepípedo |

**Ponto em aberto:** as duas fontes tratam de **intertravado de concreto** (a ASTM se aplica a peças conforme ASTM C936). Para o **paralelepípedo**, nenhuma delas dá limites; os graus continuam como proposta a calibrar com a vistoria da fase 1.

---

## 4. Outras informações úteis da ASTM E2840

| Item | Conteúdo | Uso no projeto |
|---|---|---|
| Unidade de amostra (2.1.7) | 225 m² ± 90 m² | Tamanho de referência para os trechos de rua (fases 1 e 7) |
| PCI (2.1.4) | Índice de 0 (pior) a 100 (melhor) | Indicador da obra no painel (fase 5) e no gêmeo digital (fase 7) |
| Faixas de PCI (manual, p. 8) | Mínimo satisfatório em uso: 70 a 85. Superior: 86 a 100 | Critério de aceitação no painel da obra |
| Equipamentos (seção 5) | Roda odométrica com resolução de 30 mm, régua de 3 m, escala de 300 mm com resolução de 1 mm e mais uma régua de 300 mm para escalonamento | O kit da fase 0 já cobre a régua de 3 m e a de 30 cm. Faltam a roda odométrica (pode ser substituída por GPS e trena) e a linha de 15 m, caso a fluência horizontal seja medida em campo |
| Precisão (4.2) | A norma declara que a exatidão e a repetibilidade do PCI para intertravado **ainda não foram verificadas** | Argumento para o artigo: motiva a medição automática e a dupla avaliação da fase 1 |

---

## 5. O que falta para fechar

1. **Apêndice X1 da ASTM E2840 completa.** Sem ele não há os graus baixo, médio e alto oficiais nem as curvas de dedução do PCI. A prévia não basta para calcular o PCI.
2. **Sua validação das propostas P1 a P12.** Depois disso, o guia vira `v1` final, o `classes.json` é atualizado e a F0-01 pode ir para `feito`.

---

## 6. Decisões (Eliakim, 2026-10-20)

| Proposta | Decisão |
|---|---|
| P1 | Aprovada: 13 mm no intertravado, 15 mm no paralelepípedo |
| P2, P3, P4 | P2 e P4 rejeitadas: `junta_aberta` continua como classe única, graduada pela largura. P3 aplicada só na fonte (limite aceitável de 10 mm da ASTM) |
| P5, P6, P7, P8, P12 | Aprovadas |
| P9, P10, P11 | Aprovadas conforme proposto |

Aplicado em [guia-rotulagem.md](guia-rotulagem.md) v1 e em [classes.json](classes.json).
