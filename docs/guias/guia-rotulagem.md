# Guia de rotulagem

Versão: **v1 (2026-10-20, alinhada à ASTM E2840; limites "a calibrar" serão ajustados com a vistoria da fase 1)**

Este guia define o que cada classe significa, como desenhar o rótulo e como dar o grau de severidade. Toda pessoa que rotula segue este guia; toda dúvida recorrente vira uma regra nova aqui, com a versão atualizada.

---

## Regras gerais

1. Rotule **máscaras** (polígonos que seguem o contorno real), nunca só caixas.
2. Rotule todo defeito **visível e inteiro o suficiente para ser reconhecido**. Defeitos muito distantes ou cortados na borda do quadro recebem a tag `parcial`.
3. Não rotule sombras, manchas de óleo, tampas de poço de visita e sinalização pintada como defeito.
4. Em caso de dúvida entre duas classes, siga a **ordem de prioridade** abaixo e marque a imagem com a tag `duvida`.
5. Imagens sem nenhum defeito também entram no dataset: não apague, apenas não rotule.

## Ordem de prioridade (quando dois defeitos se sobrepõem)

1. Peça faltante ou solta
2. Afundamento ou recalque
3. Remendo com outro material
4. Peça quebrada
5. Desconfinamento de borda
6. Junta aberta ou perda de areia/rejunte
7. Desnível entre peças
8. Vegetação na junta

Exemplo: um afundamento com duas peças faltantes no meio recebe **duas máscaras**: uma de afundamento (área rebaixada) e uma de peça faltante (o buraco das peças).

---

## Classes

| Código | Classe | Intertravado | Paralelepípedo | Como desenhar |
|---|---|---|---|---|
| `afundamento` | Afundamento ou recalque | Sim | Sim | Contorne a área visivelmente rebaixada, com peças inclinadas ou água parada |
| `peca_faltante` | Peça faltante ou solta | Sim | Sim | Contorne o buraco deixado pela peça ou a peça claramente solta |
| `peca_quebrada` | Peça danificada: fissura, lasca, canto quebrado ou peça partida | Sim | Raro | Contorne cada peça danificada |
| `junta_aberta` | Junta aberta ou perda de areia/rejunte | Sim | Sim (perda de rejunte) | Contorne a faixa de juntas abertas, não cada junta isolada |
| `desconfinamento` | Desconfinamento de borda | Sim | Sim | Contorne a faixa junto ao meio-fio com peças deslocadas ou giradas; o problema costuma ficar entre 0,3 e 0,6 m da borda |
| `desnivel` | Desnível entre peças | Sim | Sim | Contorne o grupo de peças com degrau visível |
| `remendo` | Remendo com outro material | Sim | Sim | Contorne a área de asfalto ou concreto aplicada sobre o pavimento de peças |
| `vegetacao` | Vegetação na junta | Sim | Sim | Contorne a área com vegetação visível |

## Graus de severidade

Os limites marcados como "a calibrar" serão ajustados com a vistoria de campo da fase 1. A origem de cada limite está indicada.

| Classe | Medida | Baixo | Médio | Alto | Origem |
|---|---|---|---|---|---|
| `afundamento` | Profundidade sob régua de 3 m | intertravado: até 13 mm; paralelepípedo: até 15 mm | a calibrar (proposta: até 3 cm) | a calibrar (proposta: acima de 3 cm ou com água parada) | 13 mm: ASTM E2840 via manual ABCP (2022); 15 mm: especificações municipais de recebimento de paralelepípedo (fonte a identificar, F0-11) |
| `peca_faltante` | Peças contíguas afetadas | 1 peça isolada | 2 a 5 peças | mais de 5 ou buraco aberto | Baixo: ASTM E2840 via manual ABCP (2022); médio e alto: proposta, a calibrar |
| `peca_quebrada` | Estado da peça | fissura, lasca ou canto quebrado, sem perda de material | peça partida no lugar | fragmentos soltos | ASTM E2840 via manual ABCP (2022): 1 ou 2 peças danificadas sem separação são aceitáveis; graus: proposta, a calibrar |
| `junta_aberta` | Largura da junta | 6 a 10 mm | 11 a 15 mm | acima de 15 mm | Limite aceitável de 10 mm: ASTM E2840 via manual ABCP (2022); faixas: publicado para intertravado permeável (fonte a identificar, F0-11) |
| `desconfinamento` | Junta e rotação junto ao meio-fio | junta de 6 a 13 mm, sem rotação | com rotação | rotação e recalque local | Baixo: ASTM E2840 via manual ABCP (2022); médio e alto: publicado para intertravado permeável (fonte a identificar, F0-11) |
| `desnivel` | Degrau medido com régua de 30 cm | até 6 mm | a calibrar | a calibrar | Baixo: ASTM E2840 via manual ABCP (2022); médio e alto: a definir com a vistoria |
| `remendo` | Área em m² | sem grau, só área | | | |
| `vegetacao` | Percentual da área | sem grau, só extensão | | | |

## Tags auxiliares

| Tag | Quando usar |
|---|---|
| `parcial` | Defeito cortado na borda ou muito distante |
| `duvida` | Rotulador não teve certeza da classe |
| `molhado` | Pavimento molhado na imagem |
| `sombra_forte` | Sombra cobre parte relevante do defeito |
| `vala` | Defeito está sobre recomposição de vala |
| `trilha_roda` | Use em `afundamento` quando o rebaixo for longitudinal, no caminho da roda (ASTM E2840: *rutting*) |

## Grade de peças (subconjunto)

No projeto `grade-v1`:

- `junta`: polígonos estreitos que seguem as linhas entre as peças.
- `peca`: área de cada peça entre juntas (pode ser rotulada como tudo o que não é junta dentro da área pavimentada).
- Não rotule a grade sobre defeitos grandes; ali ela não existe.

## Mapeamento para a ASTM E2840

Feito em 2026-10-20 com a prévia da ASTM E2840-11 (R2019) e o Manual de Desempenho ABCP (2022). Detalhes e fontes em [comparacao-astm-e2840.md](comparacao-astm-e2840.md).

| Classe do projeto | Defeito na ASTM E2840 | Diferenças |
|---|---|---|
| `afundamento` | 2. Depressions; 11. Rutting (tag `trilha_roda`) | Paralelepípedo usa limite municipal (15 mm), não coberto pela ASTM |
| `peca_faltante` | 9. Missing Pavers | Nenhuma |
| `peca_quebrada` | 1. Damaged Pavers | Código mantido; definição ampliada para peça danificada |
| `junta_aberta` | 4. Excessive Joint Width e 8. Joint Sand Loss/Pumping | Uma classe para os dois defeitos ASTM, graduada pela largura (decisão de 2026-10-20: mais simples de rotular na imagem) |
| `desconfinamento` | 3. Edge Restraint | Nenhuma |
| `desnivel` | 5. Faulting | Nenhuma |
| `remendo` | 10. Patching | Sem grau, só área |
| `vegetacao` | sem equivalente | Classe própria do projeto, relevante no paralelepípedo |

### Defeitos da ASTM fora da rotulagem v1

| Defeito ASTM | Tratamento |
|---|---|
| 6. Heave (elevação) | Não rotular: quase não se distingue numa imagem 2D. Registrar na planilha de vistoria; reavaliar com profundidade (LiDAR, fase 6) |
| 7. Horizontal Creep (fluência horizontal) | Não rotular como máscara: medir como grandeza derivada da grade de peças na fase 4 (desvio do alinhamento das juntas) |

As duas fontes tratam só de intertravado de concreto. Para o paralelepípedo, os limites seguem como proposta a calibrar com a vistoria da fase 1.

## Histórico de versões

| Versão | Data | Mudança |
|---|---|---|
| v1 | 2026-10-20 | Alinhada à ASTM E2840: limites de grau baixo com fonte em afundamento, peça faltante, peça danificada, desconfinamento e desnível; tag `trilha_roda`; mapeamento completo; `junta_aberta` mantida como classe única |
| v1 (rascunho) | 2026-10-19 | Proposta inicial com 8 classes e graus provisórios |
