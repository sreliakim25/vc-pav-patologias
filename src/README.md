# src/

Código Python do sistema. Os módulos nascem na fase indicada, criados pelo subagente da fase e revisados pelo orquestrador.

| Módulo | Fase | O que faz |
|---|---|---|
| `coleta/` | 1 | Extrai quadros por distância percorrida, lê GPS, filtra nitidez e duplicatas |
| `anonimizacao/` | 1 | Desfoca rostos e placas |
| `dataset/` | 2 | Converte formatos, divide por rua, conta instâncias |
| `treino/` | 3 | Scripts de treino e avaliação |
| `medicao/` | 4 | Grade, homografia, medidas, severidade |
| `rastreamento/` | 4 | Junta o mesmo defeito entre quadros |
| `pipeline/` | 4 | Comando único de ponta a ponta |
| `supabase_sync/` | 5 | Envia resultados ao Supabase com a chave secret, só no seu computador |

## Padrões

- Python 3.11 ou superior.
- Comentários e docstrings em português.
- Cada módulo com um `README.md` curto e um exemplo de uso.
- Nenhum caminho fixo no código: use as variáveis de `.env` (`DADOS_DIR`, `MODELOS_DIR`).
- Nenhuma chave no código: leia de variável de ambiente.
