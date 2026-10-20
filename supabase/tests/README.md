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
psql -d teste -v ON_ERROR_STOP=1 -f supabase/migrations/0002_privilegios_authenticated.sql
psql -d teste -v ON_ERROR_STOP=1 -f supabase/migrations/0003_funcoes_fora_da_api.sql
psql -d teste -f supabase/verificar_seguranca.sql
psql -d teste -f supabase/tests/teste_rls.sql
```

## Projeto real (Supabase, 2026-10-20, PostgreSQL 17.11 + PostGIS 3.3.7)

- Migrações 0001, 0002 e 0003 aplicadas pelo SQL, em transação.
- `verificar_seguranca.sql`: as 10 consultas voltaram vazias (a 9ª veio com a 0002, a 10ª com a 0003).
- 0003: auxiliares do RLS no schema `privado`; RPC delas responde 404 (PGRST202); gatilho `ensure_rls` segue ligando o RLS em tabela nova (teste com ROLLBACK).
- Chave publishable via REST: as 6 tabelas e a view respondem 401 (42501); buckets e objetos não aparecem.
- `teste_rls.sql` não roda no projeto real (insere dados de teste).

## Resultado local (2026-10-19, PostgreSQL 16 + PostGIS 3)

- `verificar_seguranca.sql`: as 8 consultas voltaram vazias.
- `teste_rls.sql`: os 12 testes deram o resultado esperado.

Nunca rode `teste_rls.sql` no projeto de produção: ele insere usuários e obras de teste.
