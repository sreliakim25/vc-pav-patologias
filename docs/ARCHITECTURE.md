# Arquitetura

Este documento descreve como as peças do sistema se encaixam. Ele é atualizado pelo orquestrador sempre que uma decisão de arquitetura é tomada (veja "Registro de decisões" no fim).

## Visão geral

```text
 CAPTURA            PROCESSAMENTO LOCAL                         NUVEM (Supabase)            VISUALIZAÇÃO
┌──────────┐   ┌──────────────────────────────────────┐   ┌────────────────────────┐   ┌──────────────────┐
│ câmera   │──▶│ extração de quadros + trilha GPS      │   │ Postgres + PostGIS     │   │ painel do projeto│
│ celular  │   │ filtro de nitidez e duplicatas        │   │  (RLS em tudo)         │   │ (kanban.json)    │
│ drone    │   │ anonimização (rosto e placa)          │──▶│ Storage privado        │──▶│ painel da obra   │
└──────────┘   │ modelo de defeitos (segmentação)      │   │  (URL assinada)        │   │ (mapa, fase 5)   │
               │ modelo da grade (juntas e peças)      │   │ Auth (convite apenas)  │   │ gêmeo digital    │
               │ homografia, medida, severidade        │   └────────────────────────┘   │ (fase 7)         │
               │ rastreamento entre quadros            │                                └──────────────────┘
               └──────────────────────────────────────┘
```

O processamento pesado roda **no seu computador ou numa GPU alugada**. A nuvem recebe só o resultado: uma linha por defeito, a foto anonimizada da melhor vista e a coordenada. Isso reduz custo, tempo de upload e risco de dado pessoal.

## Componentes

| Componente | Responsabilidade | Tecnologia | Fase |
|---|---|---|---|
| `src/coleta/` | Extrair quadros, ler GPS, filtrar nitidez, remover duplicatas | Python, FFmpeg, OpenCV | 1 |
| `src/anonimizacao/` | Desfocar rostos e placas | Detector pronto + OpenCV | 1 |
| `src/dataset/` | Conversão de formatos, divisão por rua, contagem por classe | Python | 2 |
| `src/treino/` | Treino e avaliação dos dois modelos | Ultralytics ou RF-DETR; SegFormer ou U-Net | 3 |
| `src/medicao/` | Cantos da grade, homografia, medidas, severidade | OpenCV, NumPy | 4 |
| `src/rastreamento/` | Juntar o mesmo defeito entre quadros | ByteTrack | 4 |
| `src/pipeline/` | Comando único: vídeo entra, planilha e upload saem | Python | 4 |
| `supabase/` | Esquema, RLS, Storage, funções | SQL | 5 |
| `painel/` | Acompanhamento do projeto (kanban e indicadores) | HTML, CSS, JS em arquivo único | 0 |
| painel da obra | Mapa de defeitos e revisão do engenheiro | HTML e JS no Vercel + Supabase | 5 |

A pasta `src/` é criada aos poucos: cada módulo nasce na fase indicada, por meio do subagente da fase.

## Fluxo de dados de uma passada

1. A câmera grava `video.mp4` e a telemetria GPS.
2. `src/coleta` extrai um quadro a cada 2 a 3 m de deslocamento (calculado pelo GPS), descarta quadros borrados e repetidos.
3. `src/anonimizacao` desfoca rostos e placas e salva em `dados/anonimizados/`.
4. `src/pipeline` roda os dois modelos, calcula a homografia de cada quadro pela grade, mede e classifica.
5. `src/rastreamento` junta detecções do mesmo defeito e escolhe a melhor vista.
6. O resultado vai para o Supabase: tabela `defeitos`, foto no bucket `evidencias-defeitos`.
7. O painel da obra mostra o mapa; o engenheiro confirma, corrige ou descarta. A correção vira rótulo para o próximo treino.

## Decisões de licença

- Código do repositório: Apache-2.0.
- Ultralytics (YOLO) é AGPL-3.0. Uso em pesquisa: permitido. Se o sistema virar produto fechado, trocar para RF-DETR (Apache-2.0) ou contratar a licença comercial da Ultralytics.
- SAM 3 tem licença própria da Meta, voltada a pesquisa: usado só para pré-rotular, não entra no produto.

## Registro de decisões (ADR)

Cada decisão de arquitetura entra aqui, mais recente primeiro.

| Data | Decisão | Motivo | Alternativas descartadas |
|---|---|---|---|
| 2026-10-19 | Banco: Supabase (Postgres + PostGIS, Storage, Auth) | Junta banco geográfico, arquivos e login num lugar; RLS nativo | Firebase (consulta espacial fraca no Firestore); Neon (só banco, exigiria Storage e Auth à parte) |
| 2026-10-19 | Estado do projeto em `projeto/kanban.json` versionado no Git | Os subagentes editam um arquivo simples; o histórico do Git vira trilha de auditoria para o artigo | Planilha externa; quadro em ferramenta paga |
| 2026-10-19 | Medida pela máscara corrigida por homografia, não pela caixa | Caixas erram cerca de 26% em comprimento e largura em estudos anteriores | Medida pela caixa delimitadora |
| 2026-10-19 | Divisão treino, validação e teste por rua | Quadros da mesma rua são quase iguais e inflariam a métrica | Divisão aleatória por imagem (usada no artigo de referência) |
