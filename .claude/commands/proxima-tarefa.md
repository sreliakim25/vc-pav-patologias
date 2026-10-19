---
description: Escolhe a próxima tarefa da fase atual, delega ao subagente certo e atualiza o kanban
argument-hint: "[ID da tarefa, opcional]"
---

Execute o ciclo de trabalho da seção 3 do `CLAUDE.md`.

1. Leia `projeto/kanban.json`, o documento da fase atual e as últimas entradas de `docs/artigo/diario-de-pesquisa.md`.
2. Se `$ARGUMENTS` trouxer um ID de tarefa, use essa tarefa. Senão, escolha a primeira de `a_fazer` da fase atual que não esteja bloqueada (ou puxe do `backlog` da mesma fase).
3. Mova a tarefa para `fazendo`, atualize `projeto.atualizado_em` e acrescente uma linha no `historico`.
4. Se o responsável for um subagente, delegue com: ID e título, documento e passo da fase, entradas, critério de pronto e lembrete do formato de retorno.
5. Se o responsável for o Eliakim, explique em passos curtos o que ele precisa fazer (citando o documento da fase) e peça que ele relate com `/registrar-resultado` quando terminar. Deixe a tarefa em `fazendo`.
6. Ao receber o retorno do subagente, confira os arquivos e números. Mova para `revisao` (se precisa de olhar humano) ou `feito` (se verificado).
7. Atualize os indicadores com os números verificados e peça ao `redator-artigo` o registro no diário.
8. Valide o JSON e atualize o painel: `python3 -m json.tool projeto/kanban.json > /dev/null && python3 painel/embutir_dados.py`.
9. Sugira a mensagem de commit no padrão do projeto e mostre `git status` antes de commitar.
