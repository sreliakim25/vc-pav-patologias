---
description: Confere o portão da fase atual com o auditor independente e, com aprovação, fecha a fase e abre a próxima
---

1. Leia a fase atual em `projeto/kanban.json` e a seção "Portão para avançar" do documento da fase.
2. Chame o subagente `auditor-portao` para a fase atual. Ele não participou do trabalho; repasse apenas o número da fase.
3. Mostre ao Eliakim a tabela da auditoria.
4. Se o veredito for **reprovado**: não avance. Crie as tarefas de correção na fase atual (ou na anterior, se for o caso) com `/nova-tarefa`, registre no `historico` e encerre.
5. Se o veredito for **aprovado**, peça a confirmação explícita do Eliakim. Só com o "sim":
   - marque os itens do `portao` como `ok: true`;
   - mude o `status` da fase para `concluida` e preencha `fim_real`;
   - mude a próxima fase para `em_andamento`, preencha `inicio_real` e atualize `projeto.fase_atual`;
   - mova as tarefas da próxima fase de `backlog` para `a_fazer`;
   - acrescente uma linha no `historico`.
6. Peça ao `redator-artigo` uma entrada de encerramento da fase no diário de pesquisa, com os números finais dos indicadores.
7. Valide o JSON (`python3 -m json.tool projeto/kanban.json`), rode `python3 painel/embutir_dados.py` e sugira o commit: `docs: encerra fase <N> e inicia fase <N+1>`.
