# Guia de rotulagem

Versão: **v2 (2026-10-26, graus do Apêndice X1 da ASTM E2840-11; no paralelepípedo, a mesma escala por extrapolação, a calibrar na fase 1)**

Este guia define o que cada classe significa, como desenhar o rótulo e como dar o grau de severidade. Toda pessoa que rotula segue este guia; toda dúvida recorrente vira uma regra nova aqui, com a versão atualizada.

Neste guia, **"norma"** indica o que está escrito na ASTM E2840-11, com a seção citada; **"extrapolação"** indica a norma aplicada fora do seu escopo (paralelepípedo); **"projeto"** indica regra própria deste projeto. Detalhes em [comparacao-astm-e2840.md](comparacao-astm-e2840.md), seção 7.

---

## Regras gerais

1. Rotule **máscaras** (polígonos que seguem o contorno real), nunca só caixas.
2. Rotule todo defeito **visível e inteiro o suficiente para ser reconhecido**. Defeitos muito distantes ou cortados na borda do quadro recebem a tag `parcial`.
3. Não rotule sombras, manchas de óleo, tampas de poço de visita e sinalização pintada como defeito.
4. Em caso de dúvida entre duas classes, siga a **ordem de prioridade** abaixo e marque a imagem com a tag `duvida`.
5. Imagens sem nenhum defeito também entram no dataset: não apague, apenas não rotule.
6. **Defeito dentro de remendo** não é rotulado: ele só eleva o grau do `remendo` (norma, X2.1.1.2). (v2)
7. **Recomposição de vala com peças iguais às originais não é remendo**, porque remendo é reposição com material diferente, como asfalto, concreto ou agregado (norma, X1.10.1). Os defeitos dessa recomposição são rotulados normalmente, cada um na sua classe, com a tag `vala`. (v2)
8. **Grau por profundidade** (`afundamento`, `desnivel`, `junta_aberta`, `desconfinamento`): use a medida de campo da planilha de vistoria quando existir. Sem medida, dê o grau visual **sem usar sombra, chanfro da peça ou mancha de umidade como evidência de profundidade**, porque eles exageram o desnível aparente (norma, X1.2.2, X2.7 e X2.8). (v2)
9. **Valor de fronteira fica no grau menor.** A norma repete a fronteira nos dois graus (ex.: 5 a 13 e 13 a 25 mm); o projeto adota: baixo até 13 mm inclusive, médio acima de 13 até 25 mm, alto acima de 25 mm. (v2, projeto)
10. **Abaixo do piso do grau baixo não há defeito:** não rotule. A menor diferença de cota mensurável é 3 mm (norma, X2.1.1.4). (v2)
11. **Marca de campo** (giz, tinta, etiqueta) não é pista de defeito: rotule o defeito normalmente e marque a imagem com a tag `marca_campo`. (v2)

## Ordem de prioridade (quando dois defeitos se sobrepõem)

1. Peça faltante ou solta
2. Afundamento ou recalque
3. Remendo com outro material
4. Peça quebrada
5. Desconfinamento de borda
6. Junta aberta ou perda de areia/rejunte
7. Desnível entre peças
8. Vegetação na junta

Exemplo: um afundamento com duas peças faltantes no meio recebe **duas máscaras**: uma de afundamento (área rebaixada) e uma de peça faltante (o buraco das peças). A norma também registra cada defeito sobreposto no seu grau (X2.1.1.1). Exceção: dentro de um remendo, só o remendo é rotulado (regra geral 6).

---

## Classes

| Código | Classe | Intertravado | Paralelepípedo | Como desenhar |
|---|---|---|---|---|
| `afundamento` | Afundamento ou recalque | Sim | Sim | Contorne a área rebaixada, com peças inclinadas ou água parada. Água e mancha só indicam onde está; o limite e a profundidade vêm da régua (norma, X1.2.2). Rebaixo longitudinal no caminho da roda recebe a tag `trilha_roda` |
| `peca_faltante` | Peça faltante ou solta | Sim | Sim | Contorne o buraco deixado pelas peças ou as peças claramente soltas. A contagem de peças define o grau; a área da máscara é a quantidade do PCI |
| `peca_quebrada` | Peça danificada: fissura, lasca, canto quebrado ou peça partida | Sim | Raro | Contorne cada peça danificada. **Não rotule** peça isolada só com fissura fina, sem abertura (norma, X1.1.3). Fissura típica tem menos de 3 mm de largura (norma, X1.1.1) |
| `junta_aberta` | Junta aberta ou perda de areia/rejunte | Sim | Sim (perda de rejunte) | Contorne a faixa de juntas abertas, não cada junta isolada. O grau vem da **largura média real**, descontado o chanfro (norma, X1.4.3). A profundidade da perda de rejunte (defeito ASTM 8) é medida só em campo e vai para a planilha |
| `desconfinamento` | Desconfinamento de borda | Sim | Sim | Contorne a faixa junto ao meio-fio ou à transição de pavimentos com peças deslocadas ou giradas; o problema costuma ficar entre 0,3 e 0,6 m da borda (norma, X1.3.2) |
| `desnivel` | Desnível entre peças | Sim | Sim | Contorne o grupo de peças com degrau visível |
| `remendo` | Remendo com outro material | Sim | Sim | Contorne a área de asfalto, concreto ou agregado aplicada sobre o pavimento de peças. Recomposição com peças iguais às originais não é remendo (regra geral 7) |
| `vegetacao` | Vegetação na junta | Sim | Sim | Contorne a área com vegetação visível |

## Graus de severidade

**Escopo da norma:** a ASTM E2840 vale para peças de concreto conforme a ASTM C936 (norma, 2.1.2). No **intertravado**, os graus abaixo são da norma. No **paralelepípedo**, a mesma escala é aplicada como **extrapolação da ASTM, a calibrar na fase 1** (decisão P14, opção B, 2026-10-26).

Os milímetros são os da norma, que traz polegadas como padrão e milímetros como conversão (norma, 1.4).

| Classe | Medida | Baixo | Médio | Alto | Não rotular | Origem |
|---|---|---|---|---|---|---|
| `afundamento` | Profundidade máxima sob régua de 3 m; acima de 3 m de extensão, linha esticada | 5 a 13 mm | acima de 13 até 25 mm | acima de 25 mm | abaixo de 5 mm | Intertravado: norma, X1.2.3 e X1.2.4. Paralelepípedo: extrapolação da ASTM, a calibrar na fase 1 (ver nota 1) |
| `afundamento` com tag `trilha_roda` | Profundidade máxima com a régua atravessada na trilha | 6 a 13 mm | acima de 13 até 25 mm | acima de 25 mm | abaixo de 6 mm | Intertravado: norma, X1.11.3 e X1.11.4. Paralelepípedo: extrapolação da ASTM, a calibrar na fase 1 |
| `peca_faltante` | Peças contíguas faltando na mesma área | peças isoladas, aleatórias | 2 a 9 peças na mesma área, conforto não afetado | 10 ou mais peças na mesma área, ou conforto afetado | | Norma, X1.9.4. A norma escreve o alto como "10 ou mais peças **e** conforto afetado"; o projeto usa "ou" (P16). Paralelepípedo: extrapolação |
| `peca_quebrada` | Estado da peça | uma ou duas fissuras sem separação, ou lasca, ou desgaste de borda | fissuração avançada sem separação, ou lascamento; peça inteira no lugar, não desintegrada | peça partida em vários pedaços ou desintegrada (inclui fragmentos soltos) | peça isolada só com fissura fina, sem abertura (X1.1.3) | Norma, X1.1.4. A norma fala em "uma ou duas **fissuras**", não "1 ou 2 peças" como cita o manual ABCP (2022). Paralelepípedo: extrapolação |
| `junta_aberta` | Largura média real da junta, descontado o chanfro | 6 a 10 mm | acima de 10 até 13 mm | acima de 13 mm | abaixo de 6 mm (ver nota 3) | Norma, X1.4.3 e X1.4.4. Largura ótima especificada: 1,5 a 4,5 mm (X1.4.2). Paralelepípedo: extrapolação |
| `desconfinamento` | Junta aumentada e rotação junto ao meio-fio | junta aumentada de 6 a 13 mm, sem rotação da peça ou do meio-fio | junta aumentada até 13 mm, com rotação da peça ou do meio-fio | junta aumentada acima de 13 mm, rotação considerável e recalque local | | Norma, X1.3.4. Médio: ver nota 2 (erro tipográfico). Paralelepípedo: extrapolação |
| `desnivel` | Diferença máxima de cota entre peças vizinhas, sob régua de 0,3 m (borda de prancheta) | 3 a 6 mm | acima de 6 até 10 mm | acima de 10 mm | abaixo de 3 mm | Norma, X1.5.3, X1.5.4 e X2.1.1.3. Paralelepípedo: extrapolação |
| `remendo` | Estado do remendo e efeito no conforto ao rodar | bom estado, conforto não afetado | de bom a regular, conforto começando a piorar | mau estado, conforto afetado | | Norma, X1.10.4. Grau por conforto é subjetivo (norma, 8.1): conferir a concordância desta classe com atenção |
| `vegetacao` | Percentual da área | sem grau, só extensão | | | | Projeto: sem equivalente na norma; fora do PCI |

**Nota 1. Afundamento no paralelepípedo e o limite de 15 mm.** A decisão P1 (2026-10-20) usava 15 mm como teto do grau baixo no paralelepípedo, com base em especificações municipais de recebimento (fonte pendente na F0-11). A partir da v2, **15 mm deixa de ser limite de grau**: passa a ser **referência de comparação**, usada na fase 1 e no artigo para confrontar a escala extrapolada da ASTM com a prática municipal. O grau do paralelepípedo segue 5, 13 e 25 mm até a calibração da fase 1.

**Nota 2. Erro tipográfico no médio do desconfinamento.** A norma escreve o médio como "3/8 to 1/4 in. (10-13 mm)" (X1.3.4). A faixa está invertida (3/8 in = 9,5 mm é maior que 1/4 in = 6,4 mm) e se sobrepõe ao baixo (6 a 13 mm). O projeto adota: **médio = junta aumentada até 13 mm, com rotação**. O que separa baixo de médio é a rotação; o que separa médio de alto é a junta acima de 13 mm com rotação considerável e recalque local.

**Nota 3. Perda de rejunte com junta estreita.** Como `junta_aberta` é graduada pela largura, perda de rejunte em junta com menos de 6 mm de largura não é rotulada na imagem. Ela entra só na planilha de vistoria (`profundidade_rejunte_mm`), de onde sai o defeito ASTM 8 para o PCI: baixo abaixo de 13 mm, médio de 13 a 25 mm, alto acima de 25 mm, medido a partir do fundo do chanfro (norma, X1.8.3 e X1.8.4).

**Quantidade para o PCI:** todas as classes usam área em m², exceto `desconfinamento`, em metros lineares de borda (norma, X1.3.3). A curva de dedução do desconfinamento vale só com medida em pés (norma, nota X1.1). A unidade de cada classe está em [classes.json](classes.json).

## Tags auxiliares

| Tag | Quando usar |
|---|---|
| `parcial` | Defeito cortado na borda ou muito distante |
| `duvida` | Rotulador não teve certeza da classe |
| `molhado` | Pavimento molhado na imagem |
| `sombra_forte` | Sombra cobre parte relevante do defeito |
| `vala` | Defeito está sobre recomposição de vala feita com peças iguais às originais (se for com outro material, é `remendo`) |
| `trilha_roda` | Use em `afundamento` quando o rebaixo for longitudinal, no caminho da roda (norma, X1.11: *rutting*). Rebaixo causado por carga estática de roda, como em vaga de estacionamento, também conta como trilha (norma, X1.11.2). Tem graus próprios (tabela acima). No PCI, máscara com a tag usa a curva de dedução X3.11; sem a tag, a X3.2 |
| `marca_campo` | Marca de giz, tinta, número ou etiqueta da vistoria aparece na imagem (em geral nas fotos C3). O defeito é rotulado normalmente; a tag existe para que o modelo não aprenda a marca como pista do defeito. (v2) |

## Grade de peças (subconjunto)

No projeto `grade-v1`:

- `junta`: polígonos estreitos que seguem as linhas entre as peças.
- `peca`: área de cada peça entre juntas (pode ser rotulada como tudo o que não é junta dentro da área pavimentada).
- Não rotule a grade sobre defeitos grandes; ali ela não existe.

## Mapeamento para a ASTM E2840

Referência: ASTM E2840-11 (reaprovada em 2019). O texto lido é o da edição de 2011; a reaprovação não altera o texto. Feito em 2026-10-20 com a prévia e o Manual de Desempenho ABCP (2022) e revisto em 2026-10-26 com a norma completa (Apêndices X1 a X3). Detalhes e fontes em [comparacao-astm-e2840.md](comparacao-astm-e2840.md).

| Classe do projeto | Defeito na ASTM E2840 | Unidade no PCI | Diferenças |
|---|---|---|---|
| `afundamento` | 2. Depressions; 11. Rutting (tag `trilha_roda`) | m² | Paralelepípedo usa a escala da norma por extrapolação; 15 mm municipal só como referência de comparação |
| `peca_faltante` | 9. Missing Pavers | m² | Alto com "ou conforto afetado" (norma: "e") |
| `peca_quebrada` | 1. Damaged Pavers | m² | Código mantido; definição ampliada para peça danificada |
| `junta_aberta` | 4. Excessive Joint Width (rotulagem); 8. Joint Sand Loss/Pumping (só planilha de campo) | m² | Uma classe na rotulagem, graduada pela largura (decisão de 2026-10-20). O defeito 8 é calculado pela profundidade medida em campo, com a curva X3.8 |
| `desconfinamento` | 3. Edge Restraint | m linear de borda | Médio interpretado por causa do erro tipográfico da norma (nota 2) |
| `desnivel` | 5. Faulting | m² | Nenhuma |
| `remendo` | 10. Patching | m² | Nenhuma a partir da v2 (antes: sem grau) |
| `vegetacao` | sem equivalente | fora do PCI | Classe própria do projeto, relevante no paralelepípedo |

### Defeitos da ASTM fora da rotulagem

| Defeito ASTM | Tratamento |
|---|---|
| 6. Heave (elevação) | Não rotular: quase não se distingue numa imagem 2D, e a norma diz que nem em campo o visual é confiável (X1.6.2). Registrar na planilha de vistoria (`altura_elevacao_mm`; graus 6, 13 e 25 mm, X1.6.4); reavaliar com profundidade (LiDAR, fase 6) |
| 7. Horizontal Creep (fluência horizontal) | Não rotular como máscara: medir como grandeza derivada da grade de peças na fase 4 (desvio do alinhamento das juntas). Graus 6, 13 e 20 mm da linha de 15 m (X1.7.3 e X1.7.4). Recomposição com padrão de assentamento diferente não é fluência (X1.7.1) |

## Histórico de versões

| Versão | Data | Mudança |
|---|---|---|
| v2 | 2026-10-26 | Graus do Apêndice X1 da ASTM E2840-11 (propostas P13 a P30): três graus com fonte em `afundamento` (5, 13, 25 mm), `peca_faltante` (médio 2 a 9, alto 10 ou mais), `peca_quebrada`, `junta_aberta` (6, 10, 13 mm), `desconfinamento`, `desnivel` (3, 6, 10 mm) e `remendo` (antes sem grau); graus próprios da tag `trilha_roda` (6, 13, 25 mm); paralelepípedo com a escala da norma por extrapolação e 15 mm como referência de comparação (P14, opção B); regras gerais 6 a 11 (defeito dentro de remendo, vala com peças iguais, grau sem sombra nem chanfro, fronteira no grau menor, piso de cada grau, marca de campo); tag nova `marca_campo`; nota do erro tipográfico do médio de desconfinamento; unidade do PCI por classe; citação "E2840-11 (reaprovada em 2019)" no lugar de "R2019" |
| v1 | 2026-10-20 | Alinhada à ASTM E2840: limites de grau baixo com fonte em afundamento, peça faltante, peça danificada, desconfinamento e desnível; tag `trilha_roda`; mapeamento completo; `junta_aberta` mantida como classe única |
| v1 (rascunho) | 2026-10-19 | Proposta inicial com 8 classes e graus provisórios |
