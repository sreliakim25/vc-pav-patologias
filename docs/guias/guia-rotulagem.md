# Guia de rotulagem

Versão: **v1 (proposta inicial, a calibrar na fase 1)**

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
| `peca_quebrada` | Peça quebrada | Sim | Raro | Contorne cada peça quebrada |
| `junta_aberta` | Junta aberta ou perda de areia/rejunte | Sim | Sim (perda de rejunte) | Contorne a faixa de juntas abertas, não cada junta isolada |
| `desconfinamento` | Desconfinamento de borda | Sim | Sim | Contorne a faixa junto ao meio-fio com peças deslocadas ou giradas |
| `desnivel` | Desnível entre peças | Sim | Sim | Contorne o grupo de peças com degrau visível |
| `remendo` | Remendo com outro material | Sim | Sim | Contorne a área de asfalto ou concreto aplicada sobre o pavimento de peças |
| `vegetacao` | Vegetação na junta | Sim | Sim | Contorne a área com vegetação visível |

## Graus de severidade

Os limites marcados como "a calibrar" serão ajustados com a vistoria de campo da fase 1. A origem de cada limite está indicada.

| Classe | Medida | Baixo | Médio | Alto | Origem |
|---|---|---|---|---|---|
| `afundamento` | Profundidade sob régua de 3 m | até 1,5 cm | 1,5 a 3 cm | acima de 3 cm ou com água parada | 1,5 cm: especificações municipais de recebimento de paralelepípedo; demais: proposta |
| `peca_faltante` | Peças contíguas afetadas | 1 peça | 2 a 5 peças | mais de 5 ou buraco aberto | Proposta, a calibrar |
| `peca_quebrada` | Estado da peça | fissura sem perda de material | peça partida no lugar | fragmentos soltos | Proposta, a calibrar |
| `junta_aberta` | Largura da junta | 0,6 a 1,0 cm | 1,1 a 1,5 cm | acima de 1,5 cm | Publicado para intertravado permeável; confirmar para o comum |
| `desconfinamento` | Junta e rotação junto ao meio-fio | junta aumentada, sem rotação | com rotação | rotação e recalque local | Publicado para intertravado permeável |
| `desnivel` | Degrau em mm | a calibrar | a calibrar | a calibrar | A definir com a vistoria |
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

## Grade de peças (subconjunto)

No projeto `grade-v1`:

- `junta`: polígonos estreitos que seguem as linhas entre as peças.
- `peca`: área de cada peça entre juntas (pode ser rotulada como tudo o que não é junta dentro da área pavimentada).
- Não rotule a grade sobre defeitos grandes; ali ela não existe.

## Mapeamento para a ASTM E2840

Preencher na fase 0 depois da leitura da norma: para cada classe do projeto, o tipo de defeito correspondente na norma e as diferenças.

| Classe do projeto | Defeito na ASTM E2840 | Diferenças |
|---|---|---|
| `afundamento` | a preencher | |
| `peca_faltante` | a preencher | |
| `junta_aberta` | a preencher | |
| `desconfinamento` | a preencher | |

## Histórico de versões

| Versão | Data | Mudança |
|---|---|---|
| v1 | 2026-10-19 | Proposta inicial com 8 classes e graus provisórios |
