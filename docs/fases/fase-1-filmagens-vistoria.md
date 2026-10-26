# Fase 1: Filmagens piloto e vistoria de campo

| | |
|---|---|
| **Objetivo** | Ter imagens boas das 4 ruas em várias configurações de coleta e, para 50 defeitos, a medida real feita com trena e régua |
| **Duração estimada** | 2 a 3 semanas |
| **Subagente principal** | [`coleta-campo`](../../.claude/agents/coleta-campo.md) |
| **Subagentes de apoio** | [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Kit testado, guia de rotulagem v2.1, ruas definidas, planilha de vistoria vazia |
| **Saídas** | Quadros filtrados e anonimizados por rua e configuração, trilhas GPS, planilha de vistoria com 50 defeitos medidos e fotografados, scripts de `src/coleta/` e `src/anonimizacao/` |

---

## Por que esta fase existe

Sem a medida de campo não há como saber se o sistema mede certo. E sem várias configurações de coleta não há como repetir a contribuição central do artigo de referência: mostrar como a técnica de coleta muda o resultado.

---

## Configurações de coleta

| Código | Equipamento e posição | Papel no estudo |
|---|---|---|
| **C1** | Câmera de ação no para-choque ou na moto, apontada para o pavimento, modo linear | Configuração principal; equivale ao melhor conjunto do artigo de referência |
| **C2** | Celular no para-brisa, vista panorâmica | Comparação direta com os conjuntos de celular do artigo |
| **C3** | Celular de mão, a pé, vista de cima | Medição de alta precisão; referência para as outras |
| **C4** | Drone em voo baixo (opcional nesta fase) | Relevo para afundamento; vista de cima de trechos inteiros |

---

## Passo a passo

### Passo 1. Planejar as passadas

1. Para cada rua, defina o sentido de ida e a hora (de preferência entre 9h e 15h, para evitar sombra longa).
2. Planeje no mínimo:
   - 2 passadas C1 por rua (ida e volta);
   - 1 passada C2 por rua;
   - 1 caminhada C3 nos trechos com defeitos;
   - 1 passada C1 extra com pavimento molhado em pelo menos uma rua de cada tipo (teste de robustez).
3. **Ordem do dia (guia v2, P27):** faça todas as passadas C1 e C2 da rua (Passos 2 e 3) **antes** de marcar o pavimento com giz, tinta ou etiqueta. Depois vêm a vistoria com marcação (Passo 5) e as fotos C3 (Passo 4), que podem mostrar as marcas. Se uma passada C1 ou C2 tiver de ser refeita depois da marcação, espere as marcas saírem ou avise na anotação da passada, para que as imagens recebam a tag `marca_campo`.
4. Registre o plano como tarefas no kanban (o orquestrador faz isso com `/proxima-tarefa`).

### Passo 2. Filmar com a configuração C1

1. Confira bateria, cartão, GPS com sinal e lente limpa.
2. Grave **10 segundos parado** no início, mostrando a régua graduada no chão. Isso ajuda a conferir a escala.
3. Ande a **10 a 15 km/h** em intertravado e **mais devagar** em paralelepípedo, mantendo trajetória reta no meio da faixa.
4. Se usar foto em intervalo, ajuste para **uma foto a cada 2 a 3 m** de deslocamento. A 10 km/h (2,8 m/s), isso é uma foto a cada 1 segundo.
5. Ao terminar, anote em papel ou no celular: rua, hora, condição (seco ou molhado, sol ou nublado), velocidade aproximada.

### Passo 3. Filmar com a configuração C2

1. Celular no para-brisa, aplicativo de câmera nativo, vídeo em Full HD a 30 quadros por segundo (no artigo de referência, o Full HD foi melhor que o 4K com poucas imagens).
2. Mesmo trajeto e velocidade da C1.

### Passo 4. Fotografar com a configuração C3

1. A pé, com o celular apontado para baixo, a cerca de 1,2 a 1,5 m do chão.
2. Uma foto por defeito, com a **régua graduada visível ao lado** e o defeito inteiro no quadro.
3. Uma foto de um trecho em bom estado a cada 20 m, para servir de imagem sem defeito.
4. As fotos C3 tiradas depois da marcação do Passo 5 mostram giz, números ou tinta. Isso é esperado (o número ajuda a achar o defeito na fase 4), mas essas imagens recebem a tag `marca_campo` na rotulagem.

### Passo 5. Fazer a vistoria de campo

Os graus e as medidas seguem o [guia de rotulagem v2.1](../guias/guia-rotulagem.md), que usa o Apêndice X1 da ASTM E2840-11. As seções da norma citadas abaixo são as do apêndice X2 (orientações de vistoria), salvo indicação.

**Kit de medida (norma, P26):**

| Item | Para quê | Fonte |
|---|---|---|
| Régua de 3 m de tubo de alumínio (a norma sugere 40 mm de diâmetro interno, Schedule 40; é leve e não verga) | Afundamento, trilha de roda e elevação | X2.5, X1.2.3 |
| Prancheta ou régua rígida de 0,3 m | Desnível entre peças | X1.5.3, X2.1.1.3 |
| Cunha graduada ou outro dispositivo calibrado, **aferido antes da campanha** | Dimensão vertical sob as réguas | X2.6 |
| Régua metálica fina, com o zero na ponta | Profundidade da perda de rejunte | X1.8.3 |
| Paquímetro | Largura real da junta | X1.4.3 |
| Roda odométrica com resolução de 30 mm, ou trena | Comprimento, largura e extensão de borda | X2.2.1 |
| Linha de 15 m | Só se a fluência horizontal for medida em campo | X1.7.3 |
| Giz, giz de cera ou tinta spray, e uma faca | Marcar onde a régua toca o pavimento e o contorno de cada grau | X2.9, X2.11 |

**Ordem:** a vistoria só começa depois das passadas C1 e C2 da rua (Passo 1, item 3).

Para cada rua:

1. **Medir 20 peças** com a trena (comprimento e largura). Registre a média e o desvio. Essa é a referência de escala da rua.
2. **Dividir a rua em unidades de amostra** de cerca de 225 m² ± 90 m² (norma, 2.1.7), numeradas a partir do início da rua, com marcas de giz no meio-fio (X2.11). O número da unidade vai na coluna `unidade_amostra`. Defeito na divisa entre duas unidades é registrado na **borda esquerda e frontal** da unidade (X2.3), para não ser contado duas vezes.
3. Escolher defeitos variados até completar **50 no total**, cobrindo todas as classes e os três graus. Para cada um:
   - numerar com giz ou etiqueta temporária (o número aparece na foto);
   - **marcar com giz** os pontos onde a régua toca o pavimento (deslize a faca sob a régua para achar o ponto) e o contorno do defeito (X2.9); se houver trechos de graus diferentes, marcar o contorno de cada grau (X2.13);
   - medir comprimento e largura com a trena ou a roda, percorrendo o defeito: **nunca estimar comprimento** (X2.4); a roda não pode andar mais rápido que o passo (X2.2.2);
   - medir a **profundidade** com a régua de 3 m e a cunha (afundamentos, `profundidade_mm`); acima de 3 m de extensão, usar linha esticada (X1.2.3); na trilha de roda, a régua vai **atravessada** na trilha (X1.11.3);
   - medir o **desnível** entre peças vizinhas com a régua de 0,3 m (`desnivel_mm`, separado de `profundidade_mm`);
   - medir a **largura real da junta** com o paquímetro, descontando o chanfro da peça (X1.4.3) (`largura_junta_mm`);
   - medir a **profundidade da perda de rejunte** com a régua metálica fina, a partir do **fundo do chanfro** até tocar a areia (X1.8.3) (`profundidade_rejunte_mm`), mesmo quando a junta não estiver larga;
   - no desconfinamento, medir a **extensão de borda** afetada em metros (`extensao_borda_m`; a quantidade da norma é linear, X1.3.3);
   - contar as **peças afetadas**;
   - anotar a **área afetada** em m² (`area_m2`), a partir do contorno marcado;
   - em remendo e peça faltante, anotar se o **conforto ao rodar** é afetado (`conforto_afetado`: sim ou não);
   - anotar se o defeito está sobre um **trecho reparado** com peças iguais às originais (`trecho_reparado`) e, se estiver, a **causa do reparo** (`causa_reparo`); a causa só vai para a planilha, não para o rótulo (guia v2.1, regra 7);
   - anotar se a superfície está seca ou molhada (`superficie`);
   - fotografar com a régua graduada no chão;
   - anotar a coordenada (o GPS do celular serve para localizar, mas **não substitui a trena** na medida do defeito);
   - dar o **grau de severidade** conforme o guia v2.1, **a partir da medida**, não da aparência.
4. **Não estimar profundidade pela sombra nem pela umidade:** sombra sob a régua de manhã cedo e no fim da tarde, pavimento molhado e mancha exageram o desnível aparente. Medir sempre (X2.7, X2.8). A menor diferença de cota mensurável é 3 mm (X2.1.1.4): abaixo disso, não registrar.
5. **Uma linha da planilha por defeito e por grau:** defeitos sobrepostos na mesma área têm uma linha cada, no seu grau (X2.1.1.1); um mesmo defeito com trechos de graus diferentes tem uma linha por grau (X2.13). Defeito dentro de remendo não tem linha própria: ele só eleva o grau do remendo (X2.1.1.2).
6. **Defeitos fora da rotulagem também entram na planilha**, na coluna `classe`: `elevacao` (altura sob a régua de 3 m apoiada na área não elevada, em `altura_elevacao_mm`, X1.6.3) e `fluencia` (desvio do centro da linha de 15 m até o alinhamento de juntas mais próximo, em `desvio_linha_mm`, X1.7.3), se forem medidos.
7. **Pavimento muito degradado:** faça estimativa cuidadosa, sem deixar de registrar cada tipo e grau, conferindo o relevo com a régua por amostragem; limite a cerca de 20 minutos por unidade de amostra (X2.14). Se perder a conta numa unidade, recomece a unidade (X2.10).
8. Em **10 desses defeitos**, um segundo avaliador repete a nota de grau **sem ver a primeira**. Essa concordância entre pessoas é o teto realista para o modelo.
9. Preencha a planilha `dados/vistoria/vistoria.csv` no mesmo dia, a partir do modelo [modelo-vistoria.csv](../guias/modelo-vistoria.csv).

**Colunas da planilha (guia v2):**

| Coluna | Conteúdo |
|---|---|
| `unidade_amostra` | Número da unidade de amostra da rua (item 2) |
| `classe` | Código do guia (`afundamento`, `peca_faltante`...) ou `elevacao` e `fluencia`, que não são rotulados |
| `codigo_astm` | Número do defeito na norma (1 a 11), conforme [classes.json](../guias/classes.json); afundamento com trilha de roda é 11 |
| `superficie` | `seco` ou `molhado` |
| `area_m2` | Área afetada, pelo contorno marcado |
| `extensao_borda_m` | Só desconfinamento: metros lineares de borda |
| `profundidade_mm` | Afundamento e trilha de roda, régua de 3 m |
| `desnivel_mm` | Desnível entre peças, régua de 0,3 m |
| `profundidade_rejunte_mm` | Perda de rejunte, a partir do fundo do chanfro |
| `altura_elevacao_mm` | Só elevação |
| `desvio_linha_mm` | Só fluência, linha de 15 m |
| `largura_junta_mm` | Largura real da junta, descontado o chanfro |
| `conforto_afetado` | `sim` ou `nao` (remendo e peça faltante) |
| `trecho_reparado` | `sim` ou `nao`: o defeito está sobre trecho já reparado com peças iguais às originais, qualquer que seja a causa (guia v2.1, tag `trecho_reparado`) |
| `causa_reparo` | Só quando `trecho_reparado` é `sim`: `vala`, `dano`, `outra` ou `desconhecida` |

> Segurança: use cones e colete, e nunca meça em faixa com tráfego sem sinalização.

### Passo 6. Processar logo depois da coleta

O subagente `coleta-campo` cria e roda os scripts de `src/coleta/` e `src/anonimizacao/`:

1. **Extrair quadros** por distância percorrida (não por tempo), usando a trilha GPS:
   ```bash
   python -m src.coleta.extrair_quadros \
     --video dados/brutos/2026-11-05_rua-exemplo_C1_p01/video.mp4 \
     --gps dados/brutos/2026-11-05_rua-exemplo_C1_p01/telemetria.gpx \
     --distancia-m 2.5 \
     --saida dados/quadros/2026-11-05_rua-exemplo_C1_p01/
   ```
2. **Filtrar nitidez**: descartar quadros com variância do Laplaciano abaixo de um limite calibrado com 20 quadros bons e 20 ruins.
3. **Remover duplicatas**: descartar quadros quase iguais (veículo parado), por comparação de histograma ou de hash perceptual.
4. **Anonimizar**: desfocar rostos e placas, salvar em `dados/anonimizados/`.
5. **Gerar um relatório da coleta** em `dados/quadros/<pasta>/relatorio.md`: quadros extraídos, descartados por nitidez, descartados por duplicata, anonimizados, distância coberta.

### Passo 7. Conferir a amostra

1. Abra 30 quadros aleatórios de cada pasta e confirme: nitidez, junta visível, nenhum rosto ou placa legível.
2. Atualize os indicadores do kanban: imagens úteis, defeitos medidos, ruas cobertas por configuração.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F1-01 | Planejar passadas por rua e configuração | `coleta-campo` |
| F1-02 | Passadas C1 nas 4 ruas (ida e volta) | Eliakim |
| F1-03 | Passadas C2 nas 4 ruas | Eliakim |
| F1-04 | Fotos C3 dos trechos com defeito | Eliakim |
| F1-05 | Passada C1 com pavimento molhado | Eliakim |
| F1-06 | Medir 20 peças por rua | Eliakim |
| F1-07 | Vistoria de 50 defeitos com fotos | Eliakim |
| F1-08 | Segunda avaliação de grau em 10 defeitos | Segundo avaliador |
| F1-09 | Scripts de extração, nitidez, duplicatas | `coleta-campo` |
| F1-10 | Script de anonimização | `coleta-campo` |
| F1-11 | Relatórios de coleta e conferência da amostra | `coleta-campo` |
| F1-12 | Registrar a coleta no diário de pesquisa | `redator-artigo` |

---

## Portão para avançar à fase 2

- [ ] Pelo menos **800 imagens úteis** (filtradas e anonimizadas), com defeitos de todas as classes principais.
- [ ] **50 defeitos medidos** em campo, com foto e coordenada.
- [ ] **10 defeitos com dupla avaliação** de grau.
- [ ] Referência de escala (20 peças) registrada para cada rua.
- [ ] Nenhum rosto ou placa legível na amostra conferida.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Imagens úteis | 800 |
| Defeitos medidos em campo | 50 |
| Defeitos com dupla avaliação | 10 |
| Ruas cobertas em C1 | 4 |
| Ruas cobertas em C2 | 4 |
| Taxa de descarte por nitidez | abaixo de 30% |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Muitas imagens borradas no paralelepípedo | Reduza a velocidade; use foto em intervalo; reforce o suporte |
| GPS da câmera falha em rua estreita | Grave também a trilha no celular (aplicativo de GPX) e sincronize pelo horário |
| Classe rara (ex.: desconfinamento de borda) com poucos exemplos | Marque no kanban para coleta dirigida em outra rua |
| Chuva no dia da coleta | Use para a passada de robustez; refaça a seco depois |

## O que registrar para o artigo

- Datas, horários, condições e velocidades de cada passada.
- Total de quadros por etapa do filtro (extraídos, descartados, úteis).
- Estatísticas da referência de escala por rua (média e desvio das 20 peças).
- Distribuição dos 50 defeitos medidos por classe e por grau.
- Concordância entre os dois avaliadores (calculada na fase 4).
