# Fase 1: Filmagens piloto e vistoria de campo

| | |
|---|---|
| **Objetivo** | Ter imagens boas das 4 ruas em várias configurações de coleta e, para 50 defeitos, a medida real feita com trena e régua |
| **Duração estimada** | 2 a 3 semanas |
| **Subagente principal** | [`coleta-campo`](../../.claude/agents/coleta-campo.md) |
| **Subagentes de apoio** | [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Kit testado, guia de rotulagem v1, ruas definidas, planilha de vistoria vazia |
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
3. Registre o plano como tarefas no kanban (o orquestrador faz isso com `/proxima-tarefa`).

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

### Passo 5. Fazer a vistoria de campo

Para cada rua:

1. **Medir 20 peças** com a trena (comprimento e largura). Registre a média e o desvio. Essa é a referência de escala da rua.
2. Escolher defeitos variados até completar **50 no total**, cobrindo todas as classes e os três graus. Para cada um:
   - numerar com giz ou etiqueta temporária (o número aparece na foto);
   - medir comprimento e largura com a trena;
   - medir a **profundidade** com a régua de 3 m e a cunha graduada (afundamentos);
   - contar as **peças afetadas**;
   - medir a **largura da junta** com o paquímetro (juntas abertas);
   - fotografar com a régua graduada no chão;
   - anotar a coordenada (o GPS do celular serve);
   - dar o **grau de severidade** conforme o guia.
3. Em **10 desses defeitos**, um segundo avaliador repete a nota de grau **sem ver a primeira**. Essa concordância entre pessoas é o teto realista para o modelo.
4. Preencha a planilha `dados/vistoria/vistoria.csv` no mesmo dia.

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
