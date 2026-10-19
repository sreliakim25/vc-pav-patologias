# Como contribuir

Obrigado pelo interesse. Este é um projeto de pesquisa aberto; contribuições com imagens, rótulos, código e revisão são bem-vindas.

## Antes de começar

1. Leia o [README.md](README.md) e o documento da fase atual em [docs/fases/](docs/fases/).
2. Confira no [painel](painel/index.html) quais tarefas estão em "A fazer".
3. Abra uma issue descrevendo o que pretende fazer antes de um pull request grande.

## Padrões

- **Comentários no código em português.** Variáveis e funções em inglês, em `camelCase` no JavaScript e em `snake_case` no Python (padrão da linguagem). Constantes em `SCREAMING_SNAKE_CASE`.
- **Commits** no formato:
  - `feat: descrição curta do que foi adicionado`
  - `fix: descrição do bug corrigido`
  - `refactor: melhoria sem mudança de comportamento`
  - `docs: atualização de documentação`
  - `chore: configuração, dependências, CI`
  - `data: nova versão de dataset ou de rótulos`
  - `exp: resultado de experimento registrado`
- **Nada de segredos no Git.** Antes de cada commit, rode `git status` e confirme que nenhum `.env`, chave ou arquivo de dados entrou.
- **Nada de dado pessoal identificável.** Rostos e placas devem estar desfocados antes de qualquer upload ou publicação.

## Contribuindo com imagens ou rótulos

1. Siga o [guia de rotulagem](docs/guias/guia-rotulagem.md).
2. Informe local aproximado (bairro e cidade), data, equipamento e configuração de coleta.
3. Ao enviar, você concorda em licenciar o material sob CC BY 4.0 e declara ter o direito de fazê-lo.

## Contribuindo com código

1. Crie um branch a partir de `main`: `git checkout -b feat/nome-curto`.
2. Mantenha cada pull request focado em uma coisa.
3. Descreva como testou. Se for um modelo, inclua as métricas no conjunto de teste fixo.

## Conduta

Seja respeitoso. Críticas são sobre o trabalho, nunca sobre a pessoa.
