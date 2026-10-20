-- =====================================================================
-- 0002_privilegios_authenticated.sql
-- Corrige o excesso de privilégios que o Supabase concede ao papel
-- authenticated por padrão em objetos novos do schema public.
--
-- Achado na aplicação da 0001 no projeto real (2026-10-20): a view
-- resumo_passivo recebeu DELETE, INSERT, UPDATE, TRUNCATE etc. para
-- authenticated. A 0001 só revogava os padrões do anon.
--
-- A partir daqui, toda migração deve conceder a authenticated, de forma
-- explícita, apenas o que o painel precisa (como a 0001 já faz nas tabelas).
-- =====================================================================

-- view: só leitura
revoke all on public.resumo_passivo from authenticated;
grant select on public.resumo_passivo to authenticated;

-- objetos futuros: nada por padrão para authenticated
alter default privileges in schema public revoke all on tables    from authenticated;
alter default privileges in schema public revoke all on functions from authenticated;
alter default privileges in schema public revoke all on sequences from anon, authenticated;
