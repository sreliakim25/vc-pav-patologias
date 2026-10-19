---
description: Cria uma tarefa nova no kanban, na fase certa, com ID sequencial
argument-hint: "<descrição da tarefa>"
---

Crie uma tarefa a partir de: $ARGUMENTS

1. Leia `projeto/kanban.json`.
2. Decida a fase pela natureza da tarefa (veja a tabela de subagentes no `CLAUDE.md`). Se não for óbvio, use a fase atual.
3. Gere o ID sequencial da fase (ex.: se a última for `F2-09`, use `F2-10`).
4. Defina o responsável: o subagente da área ou `Eliakim` para trabalho de campo, rotulagem e revisão.
5. Coloque em `a_fazer` se for da fase atual, ou em `backlog` se for de fase futura.
6. Atualize `projeto.atualizado_em`, acrescente uma linha no `historico`, valide o JSON e rode `python3 painel/embutir_dados.py`.
7. Mostre a tarefa criada.
