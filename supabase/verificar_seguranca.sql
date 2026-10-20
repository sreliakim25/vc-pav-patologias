-- =====================================================================
-- verificar_seguranca.sql
-- Rode depois de cada migração (local ou no projeto real, pelo SQL Editor).
-- Cada consulta deve voltar VAZIA. Qualquer linha é um problema a corrigir.
-- =====================================================================

-- 1. Tabelas do schema public sem RLS
select 'tabela sem RLS' as problema, schemaname, tablename
from pg_tables
where schemaname = 'public'
  and rowsecurity = false
  and tablename not in ('spatial_ref_sys');   -- tabela de referência do PostGIS

-- 2. Tabelas com RLS ligado mas sem nenhuma política (ninguém acessa: confirme se é intencional)
select 'RLS sem politica' as problema, c.relname as tabela
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r'
  and c.relrowsecurity
  and not exists (select 1 from pg_policy p where p.polrelid = c.oid);

-- 3. Políticas que liberam escrita para anon
select 'escrita liberada para anon' as problema, schemaname, tablename, policyname, cmd
from pg_policies
where 'anon' = any(roles)
  and cmd in ('INSERT', 'UPDATE', 'DELETE', 'ALL');

-- 4. Políticas de delete no schema public (o projeto não apaga pelo painel)
select 'politica de delete' as problema, schemaname, tablename, policyname
from pg_policies
where schemaname = 'public'
  and cmd in ('DELETE', 'ALL');

-- 5. Funções security definer sem search_path fixo
select 'security definer sem search_path' as problema, p.proname
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.prosecdef
  and not exists (
    select 1 from unnest(coalesce(p.proconfig, '{}')) cfg where cfg like 'search_path=%'
  );

-- 6. Views sem security_invoker
select 'view sem security_invoker' as problema, c.relname as view
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'v'
  and c.relname not in ('geography_columns', 'geometry_columns')   -- views do PostGIS
  and not coalesce(c.reloptions::text[] @> array['security_invoker=true'], false);

-- 7. Buckets públicos
select 'bucket publico' as problema, id
from storage.buckets
where public = true;

-- 8. Privilégios diretos do papel anon em tabelas do public
select 'privilegio para anon' as problema, table_name, privilege_type
from information_schema.role_table_grants
where grantee = 'anon'
  and table_schema = 'public'
  and table_name not in ('spatial_ref_sys', 'geography_columns', 'geometry_columns');

-- 9. Privilégios de authenticated além de SELECT e INSERT em objetos do public
-- (incluída após a 0002: o Supabase concede tudo a authenticated por padrão)
select 'privilegio excessivo para authenticated' as problema, table_name, privilege_type
from information_schema.role_table_grants
where grantee = 'authenticated'
  and table_schema = 'public'
  and privilege_type not in ('SELECT', 'INSERT')
  and table_name not in ('spatial_ref_sys', 'geography_columns', 'geometry_columns');
