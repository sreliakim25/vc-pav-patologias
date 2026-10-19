# Patologias em Pavimento de Peças

Sistema de visão computacional para **detectar, medir e classificar o grau de dano** de patologias em pavimentos **intertravados** e de **paralelepípedo**, com evolução futura para um **gêmeo digital geolocalizado** do passivo de pavimentação.

Projeto aberto de pesquisa aplicada, desenvolvido em Caruaru-PE, que será base de um artigo científico. A metodologia parte do trabalho de Freitas, Nobre Júnior e Espindola (2024), publicado na revista *Transportes* para pavimento asfáltico, e o estende para pavimento de peças, com medição em unidades reais e classificação de severidade.

> Status: **Fase 0 (Preparação)**. Acompanhe pelo [painel do projeto](painel/index.html) e pelo arquivo [projeto/kanban.json](projeto/kanban.json).

---

## O que o sistema faz

1. Recebe vídeo ou fotos do pavimento, gravados de moto, carro, a pé ou por drone, com GPS.
2. Segmenta os defeitos (afundamento, peça faltante, peça quebrada, junta aberta, desconfinamento de borda, remendo, vegetação).
3. Segmenta a grade de peças e usa a dimensão conhecida dos blocos como régua para converter pixel em centímetro.
4. Mede área, comprimento, peças afetadas e largura de junta, e classifica o grau de dano (baixo, médio, alto).
5. Junta as detecções do mesmo defeito entre quadros, associa a coordenada e publica num painel com mapa.
6. Na fase final, mantém um gêmeo digital: cada defeito com histórico, responsável, prazo e custo.

## Contribuições científicas pretendidas

- Dataset aberto brasileiro de patologias em intertravado e paralelepípedo, com máscara, classe e severidade.
- Método de medição que usa a grade de peças como referência de escala.
- Comparação de técnicas de coleta (como no artigo de referência), com o erro de medição como resultado.
- Classificação automática de severidade validada contra vistoria de campo.

---

## Roteiro em 8 fases

| Fase | Nome | Duração estimada | Documento | Subagente principal |
|---|---|---|---|---|
| 0 | Preparação | 2 semanas | [fase-0-preparacao.md](docs/fases/fase-0-preparacao.md) | `coleta-campo` |
| 1 | Filmagens e vistoria | 2 a 3 semanas | [fase-1-filmagens-vistoria.md](docs/fases/fase-1-filmagens-vistoria.md) | `coleta-campo` |
| 2 | Rotulagem e dataset v1 | 3 a 4 semanas | [fase-2-rotulagem-dataset.md](docs/fases/fase-2-rotulagem-dataset.md) | `rotulagem-dataset` |
| 3 | Treino | 3 a 4 semanas | [fase-3-treino.md](docs/fases/fase-3-treino.md) | `treino-modelos` |
| 4 | Pós-treino | 3 a 4 semanas | [fase-4-pos-treino.md](docs/fases/fase-4-pos-treino.md) | `pos-treino-medicao` |
| 5 | Piloto em obra real | 1 a 2 meses | [fase-5-piloto-obra.md](docs/fases/fase-5-piloto-obra.md) | `piloto-painel` |
| 6 | Evolução e escala | 3 a 6 meses | [fase-6-evolucao-escala.md](docs/fases/fase-6-evolucao-escala.md) | `evolucao-escala` |
| 7 | Gêmeo digital geolocalizado | 6 meses em diante | [fase-7-gemeo-digital.md](docs/fases/fase-7-gemeo-digital.md) | `gemeo-digital` |

Cada fase termina num **critério objetivo para avançar** (o "portão"). Se o critério não for atingido, volta-se à fase anterior.

---

## Como o projeto é conduzido

O projeto é orquestrado com **Claude Code**:

- [CLAUDE.md](CLAUDE.md) é o **orquestrador**: lê o estado do projeto, decide a próxima tarefa, chama o subagente certo e atualiza o kanban.
- [.claude/agents/](.claude/agents/) contém os **subagentes especializados**, cada um ligado ao documento da sua fase.
- [.claude/commands/](.claude/commands/) contém comandos rápidos: `/status`, `/proxima-tarefa`, `/avancar-fase` e `/registrar-resultado`.

Fluxo típico:

```text
você: /status
orquestrador: lê projeto/kanban.json, mostra a fase atual e os indicadores
você: /proxima-tarefa
orquestrador: escolhe a tarefa, chama o subagente da fase, que executa e reporta
orquestrador: move o cartão no kanban, atualiza os indicadores e o diário de pesquisa
```

---

## Estrutura de pastas

```text
patologias-pavimento-pecas/
├── CLAUDE.md                 # orquestrador principal
├── README.md
├── LICENSE                   # código: Apache-2.0
├── LICENSE-DADOS.md          # dados e documentação: CC BY 4.0
├── CITATION.cff              # como citar o projeto
├── CONTRIBUTING.md
├── SECURITY.md
├── .env.example              # modelo de variáveis de ambiente (sem segredos)
├── .gitignore
├── .claude/
│   ├── agents/               # subagentes por fase e transversais
│   └── commands/             # comandos do orquestrador
├── docs/
│   ├── ARCHITECTURE.md
│   ├── fases/                # um documento detalhado por fase
│   ├── guias/                # rotulagem, segurança do Supabase, padrões
│   └── artigo/               # estrutura do artigo, diário de pesquisa, referências
├── projeto/
│   └── kanban.json           # fonte única do estado do projeto
├── painel/
│   └── index.html            # painel visual: kanban e indicadores
├── supabase/
│   └── migrations/           # esquema do banco com RLS
├── src/                      # código Python (criado a partir da fase 1)
├── dados/                    # imagens e rótulos (fora do Git)
└── modelos/                  # pesos treinados (fora do Git)
```

---

## Começando

### 1. Clonar e abrir

```bash
git clone https://github.com/<seu-usuario>/patologias-pavimento-pecas.git
cd patologias-pavimento-pecas
```

### 2. Ver o painel

O painel lê `projeto/kanban.json`. Navegadores bloqueiam leitura de arquivos locais, então sirva a pasta:

```bash
python3 -m http.server 8000
# abra http://localhost:8000/painel/
```

Ou publique com GitHub Pages (Settings > Pages > Branch `main`, pasta raiz) e acesse `https://<seu-usuario>.github.io/patologias-pavimento-pecas/painel/`.

### 3. Configurar o ambiente (a partir da fase 1)

```bash
cp .env.example .env          # preencha os valores; o .env nunca vai para o Git
python3 -m venv .venv
source .venv/bin/activate
```

As dependências Python entram no `requirements.txt` na fase 1, quando o primeiro script for criado.

### 4. Conduzir com Claude Code

```bash
claude
> /status
```

---

## Banco de dados e segurança

O projeto usa **Supabase** (PostgreSQL com PostGIS, Storage e Auth). As regras de segurança são obrigatórias e estão em [docs/guias/seguranca-supabase.md](docs/guias/seguranca-supabase.md). Em resumo:

- Row Level Security ligado em todas as tabelas, sem exceção.
- Chave **publishable** só no navegador; chave **secret** só em scripts no servidor ou no seu computador, nunca no Git.
- Buckets de imagem **privados**, acessados por URL assinada com validade curta.
- Rostos e placas desfocados **antes** do upload.

## Licenças

- Código: [Apache-2.0](LICENSE).
- Dataset, documentação e figuras: [CC BY 4.0](LICENSE-DADOS.md).
- Atenção: os pacotes da Ultralytics (YOLO) são AGPL-3.0. Eles podem ser usados na pesquisa, mas o caminho padrão para um produto fechado é o RF-DETR (Apache-2.0). Veja [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Como citar

Veja [CITATION.cff](CITATION.cff). Enquanto o artigo não é publicado, cite o repositório.

## Referência principal

FREITAS, G. T. M.; NOBRE JÚNIOR, E. F.; ESPINDOLA, A. C. Avaliação da detecção automatizada de defeitos em pavimentos com YOLOv3: impacto das técnicas de coleta. *Transportes*, v. 32, n. 2, e2796, 2024. DOI: [10.58922/transportes.v32i2.2796](https://doi.org/10.58922/transportes.v32i2.2796).

## Autor

Eliakim Rocha, engenheiro civil, Caruaru-PE. [rochadev.com.br](https://rochadev.com.br)
