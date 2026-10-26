# Comparação do guia de rotulagem com a ASTM E2840 e o Manual de Desempenho ABCP

Data: 2026-10-19 · Tarefas: F0-01 e F0-02 · Situação: **P1 a P12 decididas pelo Eliakim em 2026-10-20 (seção 6); P13 a P30, da norma completa, pendentes de validação (seção 7, 2026-10-26)**

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

---

## 7. Norma completa (2026-10-26)

Tarefa F0-02, segunda rodada. Lida a ASTM E2840 completa (22 p.): corpo, Apêndice X1 (tipos e graus), X2 (orientações de vistoria) e X3 (exemplo de cálculo e curvas de dedução). Nesta seção, **"norma"** marca fato tirado do texto, com a seção citada; **"proposta"** marca o que depende da validação do Eliakim. Nada desta seção foi aplicado ao guia nem ao `classes.json`.

### 7.1 Edição e cópia lida

- **Norma, p. 1:** designação E2840, cabeçalho das páginas "E2840 − 11", edição aprovada em 1º set. 2011 e publicada em dez. 2011, DOI 10.1520/E2840-11. A cópia **não traz a marca de reaprovação** (2019) no cabeçalho.
- **Norma, 1.4:** os valores em polegadas são o padrão; os milímetros entre parênteses são conversões informativas. Nas tabelas abaixo uso os milímetros da norma e indico a conversão exata quando ela difere: 1/8 in = 3,2 mm; 3/16 in = 4,8 mm; 1/4 in = 6,4 mm; 3/8 in = 9,5 mm; 1/2 in = 12,7 mm; 3/4 in = 19,1 mm (a norma arredonda para 20); 1 in = 25,4 mm; 1 ft = 0,30 m; 10 ft = 3,05 m; 50 ft = 15,2 m.
- **Observação sobre a cópia:** os metadados do PDF indicam arquivo gerado no Word em 2023, não a distribuição oficial da ASTM. O texto e as figuras são coerentes com a norma, mas ver P30.
- **Apêndices não obrigatórios:** X1 a X3 aparecem como "Nonmandatory Information", embora 2.1.6 e 8.2 exijam que tipo e grau sigam o X1 para o PCI ser válido.

### 7.2 Os 11 defeitos: critérios oficiais

Quantidade é o que entra no cálculo da densidade do PCI (norma, 9.1 e 9.2). "Classe do guia" é a v1 de 2026-10-20.

| Nº | Defeito (X1) | Baixo | Médio | Alto | Quantidade | Como medir (norma) | Classe do guia v1 | Situação |
|---|---|---|---|---|---|---|---|---|
| 1 | Damaged Pavers (X1.1) | uma ou duas fissuras sem separação, lascas ou desgaste de borda | fissuração avançada sem separação, lascamento, peça não desintegrada | peça partida em vários pedaços ou desintegrada | m² | Visual. Peça isolada só fissurada, com pouca ou nenhuma abertura, **não é registrada**. Fissura típica com menos de 3 mm (1/8 in) | `peca_quebrada` | Diverge no médio e no alto (P17) |
| 2 | Depressions (X1.2) | 5 a 13 mm | 13 a 25 mm | acima de 25 mm | m² | Profundidade máxima sob régua de 3 m; acima de 3 m de extensão, linha esticada. Visual não é confiável no grau baixo; água e mancha só indicam, limite e profundidade vêm da régua | `afundamento` | Baixo bate no teto (13 mm); faltam o piso de 5 mm e os graus médio e alto (P13, P14) |
| 3 | Edge Restraint (X1.3) | junta aumentada de 6 a 13 mm, sem rotação da peça ou do meio-fio | junta aumentada com rotação da peça ou do meio-fio (a norma escreve "3/8 to 1/4 in, 10 a 13 mm", faixa invertida e sobreposta ao baixo: erro tipográfico) | junta acima de 13 mm, rotação considerável e recalque local | m linear de borda | Mais notável entre 0,3 e 0,6 m da borda ou na transição de pavimentos. Curva de dedução só em pés (nota X1.1) | `desconfinamento` | Bate; médio e alto passam a ter fonte ASTM (P20) |
| 4 | Excessive Joint Width (X1.4) | 6 a 10 mm | 10 a 13 mm | acima de 13 mm | m² | Largura **média** da junta; medir a junta real, descontando o chanfro. Largura ótima especificada: 1,5 a 4,5 mm | `junta_aberta` | Diverge no médio e no alto (guia: 11 a 15 e acima de 15) (P18) |
| 5 | Faulting (X1.5) | 3 a 6 mm | 6 a 10 mm | acima de 10 mm | m² | Diferença máxima de cota entre peças vizinhas, sob régua de 0,3 m (borda de prancheta) | `desnivel` | Baixo bate no teto (6 mm); médio e alto passam a ter fonte (P21) |
| 6 | Heave (X1.6) | 6 a 13 mm | 13 a 25 mm | acima de 25 mm | m² | Régua de 3 m apoiada na área não elevada, altura máxima até a área vizinha; acima de 3 m, linha esticada. Causa típica: congelamento do solo; também instabilidade do subleito | fora (P10) | Decisão mantida (7.4) |
| 7 | Horizontal Creep (X1.7) | 6 a 13 mm da linha | 13 a 20 mm | acima de 20 mm | m² | Linha de 15 m esticada no sentido longitudinal e transversal; medir do centro da linha até o alinhamento de juntas mais próximo. Área menor que 15 m: linha na largura disponível. Não confundir com mudança de padrão por peças assentadas em outra época | fora, medida derivada (P11) | Decisão mantida; limites passam a ter fonte (7.4) |
| 8 | Joint Sand Loss/Pumping (X1.8) | perda menor que 13 mm | 13 a 25 mm | acima de 25 mm | m² | Profundidade da perda a partir do **fundo do chanfro**, com régua metálica fina inserida na junta até tocar a areia. Areia na superfície ou junto à sarjeta indica bombeamento | parte de `junta_aberta` (P2/P4 rejeitadas) | Decisão mantida na rotulagem; registrar em campo (P19) |
| 9 | Missing Pavers (X1.9) | peças isoladas faltando, aleatórias | 2 ou mais peças faltando na mesma área, conforto não afetado | 10 ou mais peças na mesma área, conforto afetado | m² | Visual; a contagem define o grau, a área é a quantidade | `peca_faltante` | Diverge no médio e no alto (guia: 2 a 5 e acima de 5) (P16) |
| 10 | Patching (X1.10) | remendo em bom estado, conforto não afetado | bom a regular, conforto começando a piorar | mau estado, conforto afetado | m² | Visual. Remendo é reposição com **material diferente** (asfalto, concreto, agregado) | `remendo` | Guia não tem grau (P22, P23) |
| 11 | Rutting (X1.11) | 6 a 13 mm | 13 a 25 mm | acima de 25 mm | m² | Régua atravessada na trilha; medir ao longo da trilha e registrar separadamente os trechos de grau diferente. Rebaixo causado por carga estática de roda conta como trilha | `afundamento` + tag `trilha_roda` (P9) | Decisão mantida; graus e curva próprios (P15) |

**Fronteiras de faixa:** a norma repete o valor de fronteira nos dois graus (ex.: 5 a 13 e 13 a 25 mm). Proposta de convenção para o projeto: o valor de fronteira fica no grau menor (baixo até 13 mm inclusive; médio acima de 13 até 25 mm; alto acima de 25 mm).

**Menor medida:** a norma (X2.1.1.4) fixa 3 mm como a menor diferença de cota mensurável. Abaixo do piso de cada defeito (5 mm no afundamento, 3 mm no desnível, 6 mm nos demais com medida em mm) não há defeito registrável.

### 7.3 Conferência do manual ABCP (2022) contra a norma

Fato: em todos os casos, o limite único que o manual cita como "aceitável" é o **teto do grau baixo** da norma. A norma não define "aceitável": o grau baixo é defeito e desconta PCI (curvas X3).

| Defeito | Manual ABCP | Norma | Bate? |
|---|---|---|---|
| 1 Peças danificadas | 1 ou 2 **peças** com fissura, lasca ou canto quebrado | uma ou duas **fissuras** sem separação, lascas ou desgaste | **Não**: o manual trocou fissuras por peças. Corrigir a origem no guia (P17) |
| 2 Depressões | 13 mm sob régua de 3 m | baixo de 5 a 13 mm | Sim, mas o manual omite o piso de 5 mm |
| 3 Contenção | 6 a 13 mm sem rotação, 0,3 a 0,6 m | igual | Sim |
| 4 Largura de junta | até 10 mm | baixo de 6 a 10 mm | Sim, mas o manual omite o piso de 6 mm |
| 5 Escalonamento | até 6 mm, régua de 30 cm | baixo de 3 a 6 mm | Sim |
| 6 Elevação | 13 mm sob régua de 3 m | baixo de 6 a 13 mm | Sim |
| 7 Fluência | 13 mm no centro de linha de 15 m | baixo de 6 a 13 mm | Sim |
| 8 Perda de rejunte | até 13 mm a partir do fundo do chanfro | baixo menor que 13 mm | Sim |
| 9 Falta de peças | só 1 peça, aleatória | baixo: peças isoladas, aleatórias | Sim |
| 10 Remendo | reparo com peças novas iguais às originais | graus por estado e conforto; nada sobre usar peças iguais | **Não vem da norma**: é recomendação do manual |
| 11 Trilha de roda | 13 mm, régua transversal | baixo de 6 a 13 mm | Sim |

Consequência: a expressão "limite aceitável de 10 mm" no guia v1 (`junta_aberta`) é interpretação do manual, não da norma. Proposta: no guia, citar como "teto do grau baixo, ASTM E2840 X1.4".

### 7.4 Decisões anteriores reavaliadas

| Decisão | Fato novo da norma completa | Resultado |
|---|---|---|
| P2/P4 rejeitadas (`junta_aberta` única) | A perda de rejunte tem graus por profundidade (13 e 25 mm) e curva de dedução própria (X3.8), bem mais branda que a de largura (X3.4). Somar os dois na curva de largura superestima o desconto | **Mantida para a rotulagem** (profundidade não aparece na imagem). Para não perder o defeito 8 no PCI, registrar a profundidade em campo (P19) |
| P9 trilha como tag | Trilha tem piso de 6 mm (afundamento: 5 mm), curva própria (X3.11) com descontos maiores que a de depressão (X3.2), e rebaixo por carga estática de roda conta como trilha | **Mantida.** A tag passa a ser necessária para escolher a curva no PCI (P15) |
| P10 elevação fora | Causa típica é congelamento do solo, inexistente em Caruaru; a norma diz que nem em campo o visual é confiável; a curva só começa em 1% de densidade | **Mantida e reforçada.** Hipótese a verificar na vistoria: em Caruaru, elevações locais vêm de raízes, não de congelamento |
| P11 fluência como medida derivada | Quantidade em m²; linha de 15 m nos dois sentidos; graus 6, 13 e 20 mm; não confundir com mudança de padrão por assentamento posterior | **Mantida.** Os limites passam a ter fonte. Alerta para a fase 4: recomposição de vala com padrão diferente não é fluência. Medir 15 m contínuos exige mosaico ou rastreamento da grade |
| P12 vegetação | A norma não tem defeito equivalente (confirmado nos 11 tipos e na Tabela X2.1) | **Mantida.** Vegetação não entra no PCI |
| P1 (15 mm no paralelepípedo) | A norma vale para peças de concreto conforme ASTM C936 (2.1.2); nada sobre paralelepípedo | Fato novo só para o intertravado; o paralelepípedo segue sem fonte (P14) |

### 7.5 Propostas da norma completa

Todas são **propostas**. Nada foi aplicado.

| # | Alvo | Proposta |
|---|---|---|
| P13 | `afundamento`, intertravado | Adotar os três graus da norma: baixo de 5 a 13 mm, médio acima de 13 até 25 mm, alto acima de 25 mm; abaixo de 5 mm não rotular. Retirar "água parada" do critério do alto: a norma usa água só como indício visual, não como grau. Substitui "a calibrar (proposta: 3 cm)" |
| P14 | `afundamento`, paralelepípedo | A norma não cobre. Opção A: manter 15 mm no baixo (P1) e médio e alto "a calibrar", aguardando a fonte da F0-11. Opção B: usar a escala da norma (5, 13, 25 mm) como provisória também no paralelepípedo, marcada "extrapolação da ASTM, a calibrar na fase 1". A opção B dá uma escala única e permite o PCI nas duas superfícies |
| P15 | tag `trilha_roda` | Graus próprios: baixo de 6 a 13 mm, médio até 25 mm, alto acima de 25 mm, régua atravessada na trilha. Incluir na definição: rebaixo por carga estática de roda (estacionamento) conta como trilha. No PCI, máscara com a tag usa a curva X3.11; sem a tag, a X3.2 |
| P16 | `peca_faltante` | Médio: 2 a 9 peças na mesma área; alto: 10 ou mais peças na mesma área ou conforto afetado. Hoje: 2 a 5 e acima de 5. A contagem continua definindo o grau; a quantidade para o PCI passa a ser a área em m² da máscara |
| P17 | `peca_quebrada` | Baixo: uma ou duas fissuras sem separação, ou lasca; médio: fissuração avançada ou lascamento, peça inteira no lugar; alto: peça partida em vários pedaços ou desintegrada (inclui fragmentos soltos). Hoje "peça partida no lugar" é médio, e a norma põe peça em pedaços no alto. Regra nova: peça isolada só com fissura fina, sem abertura, não é rotulada. Corrigir a origem: "uma ou duas fissuras", não "1 ou 2 peças" |
| P18 | `junta_aberta` | Adotar as faixas da norma: baixo de 6 a 10 mm, médio acima de 10 até 13 mm, alto acima de 13 mm; abaixo de 6 mm não rotular. Medida: largura média real, descontado o chanfro. Troca a origem "intertravado permeável (F0-11)" por "ASTM E2840 X1.4". Alerta para a fase 4: na imagem, a abertura aparente inclui o chanfro e superestima a largura |
| P19 | planilha, perda de rejunte | Manter a classe única na rotulagem e acrescentar à planilha a profundidade da perda de rejunte (régua metálica fina, a partir do fundo do chanfro), para calcular o defeito 8 no PCI com a curva X3.8 |
| P20 | `desconfinamento` | Manter os graus do guia, que já batem com a norma, e trocar a origem de médio e alto para "ASTM E2840 X1.3". Quantidade em metros lineares de borda. Registrar no guia o erro tipográfico do médio na norma e adotar: médio = junta aumentada até 13 mm com rotação |
| P21 | `desnivel` | Adotar: baixo de 3 a 6 mm, médio acima de 6 até 10 mm, alto acima de 10 mm, régua de 0,3 m. Substitui "a calibrar" |
| P22 | `remendo` | Passar de "sem grau" para três graus da norma: baixo em bom estado sem efeito no conforto; médio de bom a regular, conforto começando a piorar; alto em mau estado, conforto afetado. A norma reconhece (8.1) que grau por conforto é subjetivo: conferir a concordância desta classe com atenção |
| P23 | regra geral, remendo e vala | Defeito dentro de remendo não é rotulado nem registrado: ele só eleva o grau do remendo (X2.1.1.2). Recomposição de vala feita com peças iguais às originais **não é remendo** (X1.10: material diferente) e seus defeitos são rotulados normalmente, com a tag `vala` |
| P24 | `classes.json` | Acrescentar a cada classe o código do defeito ASTM e a unidade de quantidade do PCI (`m2` em todas, exceto `desconfinamento` em `m`), para a fase 4 converter máscaras em quantidades |
| P25 | `modelo-vistoria.csv` | Novas colunas: `codigo_astm`, `unidade_amostra`, `area_m2`, `extensao_borda_m`, `desnivel_mm` (régua de 0,3 m, separado de `profundidade_mm`), `profundidade_rejunte_mm`, `altura_elevacao_mm`, `desvio_linha_mm`, `conforto_afetado` (sim/não), `superficie` (seco/molhado). Aceitar na coluna `classe` os defeitos fora da rotulagem (elevação, fluência) e um registro por grau quando o mesmo defeito tiver trechos de graus diferentes (X2.13) |
| P26 | protocolo da fase 1, Passo 5, e kit | Régua de 3 m de tubo de alumínio (a norma sugere 40 mm de diâmetro interno); prancheta ou régua de 0,3 m para desnível; régua metálica fina para rejunte; roda odométrica de 30 mm ou trena; linha de 15 m se a fluência for medida em campo. Marcar com giz onde a régua toca o pavimento e o contorno de cada grau; não estimar comprimento nem profundidade pela sombra ou pela umidade: medir; defeito na divisa entre unidades de amostra vai para a borda esquerda e frontal; em pavimento muito degradado, estimar com cuidado e limitar a cerca de 20 min por unidade |
| P27 | tag nova `marca_campo` | Fazer as passadas C1 e C2 antes de marcar o pavimento com giz; nas imagens em que marca de giz ou tinta aparecer (C3), usar a tag `marca_campo` para que o modelo não aprenda a marca como pista do defeito |
| P28 | regra geral de grau | O grau por profundidade (afundamento, desnível, junta) vem da medida de campo quando existir. Sem medida, o rotulador dá o grau visual sem usar sombra, chanfro ou mancha de umidade como evidência de profundidade (X1.2.2, X2.7, X2.8) |
| P29 | metas da fase 4 e artigo | Usar a tolerância da norma (8.1) como critério de aceitação da medição automática: identificar o tipo certo em 95% dos casos; medida linear dentro de 10% e área dentro de 20% da remedição em campo |
| P30 | referência | Citar a edição vigente E2840-11 (reaprovada em 2019), declarando que o texto lido é o de 2011 (a reaprovação não altera o texto). Antes da redação final, conferir os números citados no artigo contra a cópia oficial comprada da ASTM, porque os metadados desta cópia indicam um arquivo regerado |

**Limites "a calibrar" que passam a ter fonte oficial (intertravado), se as propostas forem aceitas:** médio e alto de `afundamento` (P13), médio e alto de `peca_faltante` (P16), os três graus de `peca_quebrada` (P17), as faixas de `junta_aberta` (P18), médio e alto de `desconfinamento` (P20), médio e alto de `desnivel` (P21) e os graus de `remendo` (P22). **Continuam sem fonte:** todos os limites do paralelepípedo (P14) e a `vegetacao`, que segue sem grau.

### 7.6 Orientações do X2 para a vistoria da fase 1

| Orientação (norma) | O que muda no projeto |
|---|---|
| Vários defeitos na mesma área: cada um registrado no seu grau (X2.1.1.1) | Coerente com o guia (duas máscaras no exemplo). Na planilha, uma linha por defeito sobreposto |
| Defeito dentro de remendo não é registrado; ele entra no grau do remendo (X2.1.1.2) | P23 |
| Cota em defeitos de área: régua de 3 m; nas juntas: régua de 0,3 m (X2.1.1.3) | Já no kit; P26 explicita a régua de 0,3 m |
| 3 mm é a menor diferença de cota mensurável (X2.1.1.4) | Piso do desnível; nada abaixo de 3 mm entra na planilha |
| Roda odométrica calibrada a 30 mm; não andar mais rápido que o passo (X2.2) | P26; GPS do celular não substitui a medida do defeito |
| Defeito na divisa: registrar na borda esquerda e frontal da unidade (X2.3) | P26; evita contagem dupla quando as ruas forem divididas em unidades de 225 m² (fase 7) |
| Não estimar comprimento; percorrer cada defeito (X2.4) | Já no protocolo (trena); reforçar |
| Tubo de alumínio de 3 m, leve e rígido (X2.5) | P26 |
| Dimensão vertical com dispositivo calibrado; lápis ou prancheta servem depois de aferidos (X2.6) | A cunha graduada do kit atende; aferir antes da campanha |
| Sombra e pavimento molhado exageram o desnível aparente; medir, não estimar (X2.7, X2.8) | P28; reforça as tags `sombra_forte` e `molhado` e justifica a passada molhada como teste de robustez |
| Marcar com faca e giz onde a régua toca o pavimento e medir a área afetada (X2.9) | P26 e P27; o contorno marcado em campo serve de verdade para conferir a máscara |
| Se perder a conta, recomeçar; subdividir a unidade com giz (X2.10, X2.11) | P26 |
| Vários graus num mesmo defeito: contornar e medir cada grau (X2.12, X2.13) | P25 (uma linha por grau) |
| Pavimento muito ruim: estimativa cuidadosa, cerca de 20 min por unidade (X2.14) | P26 |
| Tabela X2.1: origem provável de cada defeito (carga, clima, drenagem, outros) | Útil na discussão do artigo e no gêmeo digital (fase 7), para ligar defeito a causa |

### 7.7 Curvas de dedução e cálculo do PCI

Fatos da norma:

- **Estão completas.** As 11 curvas de dedução estão no Apêndice X3: Fig. X3.1 (peças danificadas, p. 19), X3.2 a X3.7 (p. 20), X3.8 a X3.11 (p. 21). A curva de correção do valor total de dedução, para q de 1 a 7, é a Fig. X3.12 (p. 22). Cada curva tem três linhas (baixo, médio, alto), eixo horizontal com a densidade em % em escala logarítmica e eixo vertical com o valor de dedução de 0 a 100.
- **O procedimento também está completo:** densidade = quantidade / área da unidade × 100 (9.2); dedução por curva (9.3); número permitido de deduções m = 1 + (9/98)(100 − maior dedução), no máximo 10 (9.4.2); iteração da dedução corrigida (9.4.4); PCI = 100 − maior dedução corrigida (9.5); PCI da seção pela média ou pela média ponderada com unidades adicionais (10.1). Há exemplo resolvido (X3.1).
- **Faixas cobertas pelas curvas são limitadas:** várias terminam antes de 100% de densidade (peças faltantes por volta de 10%, desconfinamento por volta de 20%, fluência por volta de 15%, largura de junta e elevação por volta de 30%; elevação só começa em 1%). Fora disso é preciso extrapolar ou limitar.
- **Desconfinamento:** a curva vale só com medida em pés (nota X1.1). Como a quantidade é linear e a área é quadrada, a densidade muda com a unidade (fator 3,28): converter extensão e área para pés antes de entrar na curva.
- **Erros encontrados no texto:** o exemplo X3.1 cita "Figure X4.1", que não existe (é a X3.12); o exemplo registra a depressão como 15 ft² mas calcula a densidade com 5 ft²; usa ft² para o desconfinamento, que é linear; o médio do desconfinamento tem a faixa invertida (7.2); o rótulo interno das curvas 9 e 11 diz "PAVERS 109" e "PAVERS 111"; a unidade de amostra é 225 m² em 2.1.7 e 232 m² no exemplo (2.500 ft²).

Avaliação (proposta): **dá para calcular o PCI** nas fases 5 e 7 digitalizando as curvas para uso interno. As tabelas digitalizadas são obra derivada da norma: ficam fora do repositório versionado (por exemplo, em `docs/normas/`, já ignorada), e o painel publica só o PCI calculado. Para o paralelepípedo, aplicar as curvas é extrapolação; no artigo, declarar como hipótese e comparar com a avaliação de campo.

### 7.8 Lacunas da F0-11

| Lacuna | A norma resolve? |
|---|---|
| 15 mm do afundamento em paralelepípedo (especificação municipal) | **Não.** A norma só cobre peças de concreto (C936). Fica pendente, salvo se a opção B da P14 for escolhida, que torna o 15 mm desnecessário |
| Faixas de "intertravado permeável" em `junta_aberta` | **Sim, por substituição.** A norma tem os três graus oficiais (6, 10, 13 mm), diferentes das faixas do guia (P18) |
| Faixas de "intertravado permeável" em médio e alto de `desconfinamento` | **Sim.** A norma dá médio com rotação e alto com rotação considerável e recalque local, igual ao guia (P20) |

Se P18 e P20 forem aceitas, a fonte de intertravado permeável deixa de ser necessária e a F0-11 fica reduzida ao limite de 15 mm do paralelepípedo.
