# Fase 7: Gêmeo digital geolocalizado

| | |
|---|---|
| **Objetivo** | Transformar o mapa de defeitos num modelo vivo da rede de ruas: cada defeito com lugar fixo, histórico, responsável, prazo, custo e previsão |
| **Duração estimada** | 6 meses em diante |
| **Subagente principal** | [`gemeo-digital`](../../.claude/agents/gemeo-digital.md) |
| **Subagentes de apoio** | [`seguranca-supabase`](../../.claude/agents/seguranca-supabase.md), [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Histórico de passadas, defeitos revisados, cadastro de trechos reparados (qualquer causa: vala, dano, outra) e ordens de serviço |
| **Saídas** | Base geográfica de trechos, identidade persistente dos defeitos, ligação com os trechos reparados, indicadores de passivo, previsão de falha, ciclo fechado com ordem de serviço |

---

## Níveis de maturidade

| Nível | O que é | Onde o projeto está |
|---|---|---|
| Modelo digital | Cadastro atualizado à mão | Antes do projeto: planilha de passivo |
| Sombra digital | Atualizado automaticamente pela realidade | Fases 5 e 6 |
| Gêmeo digital | Atualização automática, previsão e decisão que volta para a obra | Esta fase |

---

## Passo a passo

### Passo 1. Base geográfica

1. Carregue o eixo das ruas do **OpenStreetMap** ou do cadastro da prefeitura na tabela `trechos` (geometria `LINESTRING`, SRID 4326).
2. Divida cada rua em trechos de comprimento fixo (por exemplo, 20 m) ou por quadra.
3. Registre o tipo de revestimento e o tipo de peça de cada trecho.

```sql
-- exemplo: trechos de 20 m a partir do eixo da rua
insert into trechos (logradouro, revestimento, geom)
select nome, 'intertravado', st_linesubstring(geom, f, least(f + 20.0 / st_length(geom::geography), 1))
from eixos, generate_series(0, 1, 20.0 / st_length(geom::geography)) as f;
```

### Passo 2. Posição precisa

1. **Casamento de trajeto**: projete cada ponto GPS da passada no eixo da rua mais próximo (`st_closestpoint`), corrigindo o desvio lateral do GPS.
2. Considere um GPS de melhor precisão na câmera ou na moto para reduzir o erro de alguns metros.
3. Guarde a posição ao longo do eixo (`st_linelocatepoint`), que é estável entre passadas.

### Passo 3. Identidade do defeito

1. Cada defeito ganha um código permanente.
2. Na passada seguinte, um defeito novo é casado com um existente se: mesmo trecho, distância ao longo do eixo menor que uma tolerância (por exemplo, 3 m), mesma classe ou classe compatível.
3. O banco guarda a série histórica: data, medidas, grau e foto de cada observação.

### Passo 4. Ligação com a obra

1. A empresa repara todo dano de pavimento nas ruas da obra, qualquer que seja a causa. A maioria dos reparos não vem de vala, e sim de pavimento danificado por algum outro motivo. Por isso a unidade de cadastro é o **trecho reparado**, não só a vala recomposta.
2. Cada trecho reparado entra na tabela futura `trechos_reparados` (geometria do reparo, SRID 4326), com a coluna `causa` (`vala`, `dano`, `outra`, `desconhecida`), a ordem de serviço, a data de abertura ou de constatação do dano, o reparo provisório e o definitivo, e o prazo legal do município. O nome não se confunde com a tabela `trechos` do Passo 1, que é a divisão da rede de ruas.
3. Cada defeito é associado ao trecho reparado mais próximo dentro de uma tolerância (`st_dwithin`), ou marcado como pré-existente pela vistoria cautelar.
4. Casos ambíguos (dois trechos reparados dentro da tolerância, ou defeito na borda de um reparo) vão para revisão manual no painel.
5. Como a causa fica registrada, toda análise pode ser separada por causa, por exemplo reparos de vala contra os demais reparos.

### Passo 5. Indicadores do gêmeo

| Indicador | Cálculo |
|---|---|
| Área de passivo aberto | Soma de `area_m2` dos defeitos abertos, por revestimento e por responsável |
| Custo estimado | Área vezes o preço unitário de reparo do contrato |
| Idade do passivo | Dias desde a abertura da vala ou a constatação do dano, contra o prazo legal |
| Reparos no prazo | Percentual de trechos reparados concluídos dentro do prazo, por causa |
| Reincidência | Trechos reparados que voltaram a ter defeito em 3, 6 e 12 meses, por causa |
| Índice de condição por trecho | Antes e depois da obra: dano atribuível aos reparos, por causa |

### Passo 6. Previsão

1. Com 6 meses ou mais de histórico, treine um modelo simples (regressão logística ou árvore de decisão) para prever quais trechos reparados vão piorar de grau nos próximos 3 meses.
2. Variáveis: tipo de pavimento, causa do reparo, idade, grau atual, tráfego (classe da via), chuva acumulada, tempo até o reparo.
3. Avalie com validação temporal (treina no passado, testa no futuro).

### Passo 7. Fechar o ciclo

1. O sistema gera a ordem de serviço para defeitos de grau alto ou com prazo vencendo.
2. A passada seguinte confere se o reparo foi feito e dá baixa no passivo.

### Passo 8. 3D nos pontos críticos

1. Modelos de drone (fotogrametria ou Gaussian Splatting) para trechos com afundamento.
2. Ligados ao mesmo mapa pelo código do trecho, para abrir o 3D a partir do defeito.

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F7-01 | Tabela de trechos a partir do OpenStreetMap | `gemeo-digital` |
| F7-02 | Casamento de trajeto | `gemeo-digital` |
| F7-03 | Identidade persistente dos defeitos | `gemeo-digital` |
| F7-04 | Tabela de trechos reparados, com causa | `gemeo-digital` + `seguranca-supabase` |
| F7-05 | Associação defeito e trecho reparado | `gemeo-digital` |
| F7-06 | Indicadores do gêmeo no painel | `gemeo-digital` |
| F7-07 | Modelo de previsão | `gemeo-digital` |
| F7-08 | Ordem de serviço automática e baixa | `gemeo-digital` |
| F7-09 | 3D dos trechos críticos | Eliakim + `gemeo-digital` |
| F7-10 | Artigo internacional com o gêmeo | `redator-artigo` |

---

## Critério para considerar a fase pronta

- [ ] O relatório semestral de passivo sai do banco, sem planilha manual.
- [ ] Um defeito pode ser acompanhado do dia da abertura da vala ou da constatação do dano até a baixa.
- [ ] A previsão de falha tem desempenho melhor que uma regra simples de idade.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Trechos cadastrados | toda a área da obra |
| Defeitos com identidade estável | 95% |
| Defeitos associados a um trecho reparado ou pré-existentes | 100% |
| Relatório semestral sem planilha | sim |

## O que registrar para o artigo

- Arquitetura do gêmeo e modelo de dados.
- Erro de posição antes e depois do casamento de trajeto.
- Desempenho da previsão em validação temporal.
- Dano atribuível aos reparos, por causa e por tipo de pavimento.
- Pergunta de pesquisa (hipótese, a testar com a reincidência por causa): os reparos de vala falham mais que os reparos de outros danos?
