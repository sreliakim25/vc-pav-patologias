# Testes de segurança do banco

Dois arquivos:

- `teste_rls.sql`: 12 testes das políticas (quem vê o quê, quem pode revisar, ninguém apaga, anon não lê). Cada teste imprime o resultado esperado antes de rodar.
- `simulacao_supabase.sql`: simula o mínimo do Supabase (papéis `anon`, `authenticated`, `service_role`, `auth.uid()`, tabelas do Storage) para rodar os testes num Postgres comum com PostGIS. **Não use no Supabase de verdade.**

## Rodar no Supabase local (recomendado)

```bash
supabase start
supabase db reset
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f supabase/verificar_seguranca.sql
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f supabase/tests/teste_rls.sql
```

## Rodar num Postgres comum com PostGIS

```bash
createdb teste
psql -d teste -v ON_ERROR_STOP=1 -f supabase/tests/simulacao_supabase.sql
psql -d teste -v ON_ERROR_STOP=1 -f supabase/migrations/0001_esquema_inicial.sql
psql -d teste -f supabase/verificar_seguranca.sql
psql -d teste -f supabase/tests/teste_rls.sql
```

## Resultado da última execução (2026-10-19, PostgreSQL 16 + PostGIS 3)

- `verificar_seguranca.sql`: as 8 consultas voltaram vazias.
- `teste_rls.sql`: os 12 testes deram o resultado esperado.

Nunca rode `teste_rls.sql` no projeto de produção: ele insere usuários e obras de teste.
