# Experimentos

Uma linha por experimento. Mantido pelos subagentes [`treino-modelos`](../../.claude/agents/treino-modelos.md) e [`redator-artigo`](../../.claude/agents/redator-artigo.md).

Regras:

- IDs: `E000` linha de base; `E01x` YOLO de segmentação; `E02x` RF-DETR; `E03x` YOLO com caixas; `E04x` configuração de coleta; `E05x` modelo da grade; `E1xx` ciclos de retreino (fase 6).
- Métricas de **validação** nesta tabela. O teste fixo é rodado uma vez por versão escolhida e vai na tabela de teste.
- Semente, versão do dataset e pesos de partida sempre preenchidos.

## Validação

| ID | Data | Dataset | Modelo | Pesos de partida | Resolução | Épocas | Semente | Aumento de dados | mAP50 | mAP50-95 | Observação |
|---|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | | |

## Teste fixo

Formato inspirado na Tabela 2 de Freitas et al. (2024), separado por pavimento e configuração.

| Modelo | Pavimento | Configuração | AP por classe | Precisão | Recall | F1 | mAP50 | mAP50-95 |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |
