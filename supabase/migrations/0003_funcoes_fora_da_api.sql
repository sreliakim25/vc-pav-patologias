-- =====================================================================
-- 0003_funcoes_fora_da_api.sql
-- Tira da API as funções security definer apontadas pelo Security
-- Advisor em 2026-10-20 (lints 0028 e 0029, 5 avisos, 0 erros).
--
-- 1. As funções auxiliares do RLS (eh_membro, pode_revisar,
--    eh_membro_caminho) vão para o schema "privado", que o Supabase não
--    expõe em /rest/v1/rpc. As políticas continuam funcionando: elas
--    guardam a referência interna (OID) da função, não o nome.
--    authenticated mantém EXECUTE, porque as políticas rodam com o
--    papel de quem consulta.
-- 2. public.rls_auto_enable() é criada pelo próprio Supabase (gatilho de
--    evento que liga o RLS em tabela nova). Gatilho de evento não depende
--    de EXECUTE para disparar, então a chamada pela API pode ser revogada.
-- =====================================================================

-- 1. schema privado, fora da API
create schema if not exists privado;
revoke all on schema privado from public, anon;
grant usage on schema privado to authenticated, service_role;

alter function public.eh_membro(uuid)          set schema privado;
alter function public.pode_revisar(uuid)       set schema privado;
alter function public.eh_membro_caminho(text)  set schema privado;

-- reforça as permissões depois da mudança de schema
revoke all on function privado.eh_membro(uuid)          from public, anon;
revoke all on function privado.pode_revisar(uuid)       from public, anon;
revoke all on function privado.eh_membro_caminho(text)  from public, anon;
grant execute on function privado.eh_membro(uuid)         to authenticated;
grant execute on function privado.pode_revisar(uuid)      to authenticated;
grant execute on function privado.eh_membro_caminho(text) to authenticated;

-- 2. função do Supabase: só revoga se existir (não existe no teste local)
do $$
begin
  if to_regprocedure('public.rls_auto_enable()') is not null then
    revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
  end if;
end;
$$;
