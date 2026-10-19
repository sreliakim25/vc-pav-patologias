# Diário de pesquisa

Registro cronológico de tudo que tem valor para o artigo: decisões de método, números, problemas e soluções. **Mais recente primeiro.** Mantido pelo subagente [`redator-artigo`](../../.claude/agents/redator-artigo.md).

## Modelo de entrada

```markdown
### AAAA-MM-DD · Fase N · <título curto>
- **O que aconteceu:**
- **Números (com fonte):**
- **Decisão e motivo:**
- **Impacto no artigo:** <seção do estrutura-artigo.md>
```

---

### 2026-10-19 · Fase 0 · Esquema do banco testado com RLS

- **O que aconteceu:** a migração `supabase/migrations/0001_esquema_inicial.sql` foi aplicada num PostgreSQL 16 local com PostGIS 3, usando uma simulação mínima do ambiente Supabase (`supabase/tests/simulacao_supabase.sql`).
- **Números (com fonte):** as 8 consultas de `supabase/verificar_seguranca.sql` voltaram vazias; os 12 testes de `supabase/tests/teste_rls.sql` deram o resultado esperado (membro vê só a própria obra, leitor não revisa, ninguém apaga, anon não lê).
- **Decisão e motivo:** o painel nunca recebe permissão de alterar defeitos; a revisão do engenheiro entra numa tabela própria e um gatilho a aplica. Isso preserva o registro de quem revisou o quê, útil como trilha de auditoria.
- **Impacto no artigo:** seção 4.4 (aplicação em obra) e disponibilidade de dados.

### 2026-10-19 · Fase 0 · Início do projeto e decisões de método

- **O que aconteceu:** repositório criado com o roteiro em 8 fases, documentos por fase, orquestrador e subagentes.
- **Decisões e motivos:**
  - **Pavimentos estudados:** intertravado e paralelepípedo, por não haver dataset público nem método de medição para eles, e por concentrarem o passivo das obras de saneamento acompanhadas.
  - **Referência metodológica:** Freitas, Nobre Júnior e Espindola (2024). O projeto repete a comparação de técnicas de coleta e acrescenta medição e severidade.
  - **Máscaras em vez de caixas:** a medida pela caixa delimitadora erra cerca de 26% em comprimento e largura em estudo anterior (Dhanya Kumar et al., 2025).
  - **Divisão por rua:** quadros da mesma rua são quase iguais; a divisão aleatória por imagem, usada no artigo de referência, tende a inflar a métrica.
  - **Grade de peças como régua:** contribuição metodológica central; a NBR 9781 tolera até 3 mm no comprimento e na largura do bloco, pouco mais de 1% num bloco de 220 mm.
  - **Ajuste fino:** todos os modelos partem de pesos pré-treinados; a inicialização será declarada no artigo.
- **Impacto no artigo:** introdução, revisão e seção 3.
