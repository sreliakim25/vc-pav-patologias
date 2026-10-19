---
description: Mostra o estado do projeto, a fase atual, indicadores contra meta, tarefas em andamento e bloqueios
---

Leia `projeto/kanban.json` e o documento da fase atual em `docs/fases/`. Depois apresente, em português e de forma curta:

1. **Fase atual**: número, nome, status, datas previstas e quantos dias faltam (ou de atraso).
2. **Progresso**: tarefas da fase por coluna (backlog, a fazer, fazendo, revisão, feito) e o percentual concluído; progresso geral do projeto.
3. **Indicadores da fase**: tabela com nome, atual, meta e situação (atingido, em andamento, abaixo).
4. **Portão**: itens marcados e pendentes.
5. **Em andamento e bloqueios**: tarefas em `fazendo`, `revisao` e as marcadas como `bloqueada`, com a nota.
6. **Próximo passo sugerido**: a tarefa que `/proxima-tarefa` escolheria e quem faz.

Não altere nenhum arquivo neste comando. Termine lembrando que o painel visual está em `painel/index.html` (servir com `python3 -m http.server 8000` e abrir `http://localhost:8000/painel/`).
