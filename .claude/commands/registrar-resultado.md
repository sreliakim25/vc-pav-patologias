---
description: Registra um resultado de campo relatado pelo Eliakim e atualiza tarefas, indicadores e o diário de pesquisa
argument-hint: "<o que foi feito, com números>"
---

O Eliakim relatou: $ARGUMENTS

1. Identifique a qual tarefa e a quais indicadores o relato se refere (em `projeto/kanban.json`). Se houver ambiguidade, pergunte antes de alterar.
2. Se o relato citar arquivos (fotos, planilha, vídeos), confira que eles existem nas pastas indicadas em `dados/README.md`. Se não existirem, registre o relato como nota da tarefa, mas **não** atualize indicadores.
3. Atualize os indicadores somente com os números relatados ou verificados. Nunca estime.
4. Mova a tarefa para `feito` (ou `revisao`, se faltar conferência) e escreva uma `nota` curta.
5. Atualize `projeto.atualizado_em` e acrescente uma linha no topo de `historico`.
6. Peça ao `redator-artigo` uma entrada no diário de pesquisa com o que tem valor para o artigo (datas, condições, números, problemas).
7. Valide o JSON (`python3 -m json.tool projeto/kanban.json`), rode `python3 painel/embutir_dados.py` e mostre o resumo do que mudou.
