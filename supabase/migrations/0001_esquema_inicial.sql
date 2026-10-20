-- =====================================================================
-- 0001_esquema_inicial.sql
-- Esquema inicial do projeto Patologias em Pavimento de Paver e Paralelepípedo.
--
-- Princípios de segurança (ver docs/guias/seguranca-supabase.md):
--   1. RLS ligado em TODAS as tabelas, na mesma migração que as cria.
--   2. Acesso por obra: só membros da obra leem os dados dela.
--   3. Resultados do pipeline (inspeções e defeitos) são escritos só
--      pela chave secret (papel service_role), que ignora o RLS.
--   4. O painel só lê e registra revisões; nunca altera ou apaga defeitos
--      diretamente. Um gatilho aplica cada revisão ao defeito.
--   5. Buckets privados; leitura por URL assinada, só para membros.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Extensões
-- ---------------------------------------------------------------------
create extension if not exists postgis with schema extensions;

-- ---------------------------------------------------------------------
-- Defesa extra: o papel anon não recebe nenhum privilégio nas tabelas
-- do schema public. Mesmo que alguém esqueça uma política, anon não lê.
-- ---------------------------------------------------------------------
alter default privileges in schema public revoke all on tables from anon;
alter default privileges in schema public revoke all on functions from anon;

-- ---------------------------------------------------------------------
-- Tabelas
-- ---------------------------------------------------------------------

-- Obras acompanhadas pelo sistema
create table public.obras (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  cidade      text not null,
  criado_em   timestamptz not null default now()
);

-- Quem participa de cada obra e com que papel
create table public.membros_obra (
  obra_id     uuid not null references public.obras(id) on delete cascade,
  usuario_id  uuid not null references auth.users(id) on delete cascade,
  papel       text not null check (papel in ('admin', 'engenheiro', 'leitor')),
  criado_em   timestamptz not null default now(),
  primary key (obra_id, usuario_id)
);

-- Ruas do estudo, com a referência de escala medida em campo
create table public.ruas (
  id                      uuid primary key default gen_random_uuid(),
  obra_id                 uuid not null references public.obras(id) on delete cascade,
  nome                    text not null,
  revestimento            text not null check (revestimento in ('intertravado', 'paralelepipedo', 'asfalto')),
  tipo_peca               text,
  comprimento_peca_mm     numeric(6,1),   -- média das 20 peças medidas na fase 1
  largura_peca_mm         numeric(6,1),
  desvio_peca_mm          numeric(6,1),
  criado_em               timestamptz not null default now()
);

-- Cada passada de coleta processada pelo pipeline
create table public.inspecoes (
  id              uuid primary key default gen_random_uuid(),
  obra_id         uuid not null references public.obras(id) on delete cascade,
  rua_id          uuid references public.ruas(id) on delete set null,
  data_coleta     date not null,
  configuracao    text not null check (configuracao in ('C1', 'C2', 'C3', 'C4')),
  condicao        text check (condicao in ('seco', 'molhado')),
  versao_modelo   text not null,          -- ex.: defeitos_rfdetr-seg_v1.1
  pasta_origem    text not null,          -- ex.: 2026-12-02_rua-exemplo_C1_p01
  criado_em       timestamptz not null default now()
);

-- Um registro por defeito (já agregado entre quadros pelo rastreamento)
create table public.defeitos (
  id                  uuid primary key default gen_random_uuid(),
  obra_id             uuid not null references public.obras(id) on delete cascade,
  inspecao_id         uuid not null references public.inspecoes(id) on delete cascade,
  classe              text not null check (classe in (
                        'afundamento', 'peca_faltante', 'peca_quebrada', 'junta_aberta',
                        'desconfinamento', 'desnivel', 'remendo', 'vegetacao')),
  grau                text check (grau in ('baixo', 'medio', 'alto')),
  area_m2             numeric(10,3),
  comprimento_cm      numeric(8,1),
  largura_cm          numeric(8,1),
  pecas_afetadas      integer check (pecas_afetadas >= 0),
  largura_junta_mm    numeric(6,1),
  profundidade_mm     numeric(6,1),       -- só com 3D (fase 6); nulo quando não medida
  confianca           numeric(4,3) check (confianca between 0 and 1),
  escala_confiavel    boolean not null default false,
  pre_existente       boolean not null default false,   -- vistoria cautelar
  status              text not null default 'aberto' check (status in ('aberto', 'confirmado', 'descartado', 'corrigido_reparo')),
  foto_caminho        text,               -- <obra_id>/<inspecao_id>/<defeito_id>.jpg no bucket evidencias-defeitos
  geom                extensions.geometry(Point, 4326),
  revisado_em         timestamptz,
  criado_em           timestamptz not null default now()
);

-- Revisões do engenheiro no painel (confirmar, corrigir, descartar)
create table public.revisoes (
  id              uuid primary key default gen_random_uuid(),
  defeito_id      uuid not null references public.defeitos(id) on delete cascade,
  usuario_id      uuid not null references auth.users(id),
  acao            text not null check (acao in ('confirmar', 'corrigir', 'descartar')),
  classe_nova     text,
  grau_novo       text check (grau_novo in ('baixo', 'medio', 'alto')),
  comentario      text,
  criado_em       timestamptz not null default now(),
  -- uma correção precisa trazer classe ou grau novos
  constraint corrigir_tem_valor check (acao <> 'corrigir' or classe_nova is not null or grau_novo is not null)
);

-- ---------------------------------------------------------------------
-- Índices (inclui as colunas usadas nas políticas de RLS)
-- ---------------------------------------------------------------------
create index membros_obra_usuario_idx on public.membros_obra (usuario_id, obra_id);
create index ruas_obra_idx            on public.ruas (obra_id);
create index inspecoes_obra_idx       on public.inspecoes (obra_id);
create index defeitos_obra_idx        on public.defeitos (obra_id);
create index defeitos_inspecao_idx    on public.defeitos (inspecao_id);
create index defeitos_geom_idx        on public.defeitos using gist (geom);
create index revisoes_defeito_idx     on public.revisoes (defeito_id);

-- ---------------------------------------------------------------------
-- RLS ligado em todas as tabelas
-- ---------------------------------------------------------------------
alter table public.obras         enable row level security;
alter table public.membros_obra  enable row level security;
alter table public.ruas          enable row level security;
alter table public.inspecoes     enable row level security;
alter table public.defeitos      enable row level security;
alter table public.revisoes      enable row level security;

-- ---------------------------------------------------------------------
-- Funções auxiliares das políticas
-- security definer: consultam membros_obra sem depender do RLS dela.
-- search_path vazio e nomes qualificados evitam sequestro de esquema.
-- ---------------------------------------------------------------------

-- O usuário atual é membro da obra?
create or replace function public.eh_membro(p_obra_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.membros_obra m
    where m.obra_id = p_obra_id
      and m.usuario_id = (select auth.uid())
  );
$$;

-- O usuário atual pode revisar defeitos da obra (admin ou engenheiro)?
create or replace function public.pode_revisar(p_obra_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.membros_obra m
    where m.obra_id = p_obra_id
      and m.usuario_id = (select auth.uid())
      and m.papel in ('admin', 'engenheiro')
  );
$$;

-- Para o Storage: a primeira pasta do caminho é o id da obra
create or replace function public.eh_membro_caminho(p_caminho text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.membros_obra m
    where m.obra_id::text = split_part(p_caminho, '/', 1)
      and m.usuario_id = (select auth.uid())
  );
$$;

revoke all on function public.eh_membro(uuid)          from public, anon;
revoke all on function public.pode_revisar(uuid)       from public, anon;
revoke all on function public.eh_membro_caminho(text)  from public, anon;
grant execute on function public.eh_membro(uuid)         to authenticated;
grant execute on function public.pode_revisar(uuid)      to authenticated;
grant execute on function public.eh_membro_caminho(text) to authenticated;

-- ---------------------------------------------------------------------
-- Políticas
-- Só leitura para membros; escrita do pipeline pela chave secret.
-- Nenhuma política de delete: nada se apaga pelo painel.
-- ---------------------------------------------------------------------

-- obras: membro lê a própria obra
create policy "membro le obra"
  on public.obras for select to authenticated
  using ( public.eh_membro(id) );

-- membros_obra: cada usuário vê só as próprias participações
create policy "usuario le proprias participacoes"
  on public.membros_obra for select to authenticated
  using ( usuario_id = (select auth.uid()) );

-- ruas, inspecoes, defeitos: membro da obra lê
create policy "membro le ruas"
  on public.ruas for select to authenticated
  using ( public.eh_membro(obra_id) );

create policy "membro le inspecoes"
  on public.inspecoes for select to authenticated
  using ( public.eh_membro(obra_id) );

create policy "membro le defeitos"
  on public.defeitos for select to authenticated
  using ( public.eh_membro(obra_id) );

-- revisoes: membro lê as revisões da obra; admin e engenheiro inserem em nome próprio
create policy "membro le revisoes"
  on public.revisoes for select to authenticated
  using (
    exists (
      select 1 from public.defeitos d
      where d.id = revisoes.defeito_id
        and public.eh_membro(d.obra_id)
    )
  );

create policy "revisor insere revisao propria"
  on public.revisoes for insert to authenticated
  with check (
    usuario_id = (select auth.uid())
    and exists (
      select 1 from public.defeitos d
      where d.id = revisoes.defeito_id
        and public.pode_revisar(d.obra_id)
    )
  );

-- ---------------------------------------------------------------------
-- Gatilho: aplica a revisão ao defeito
-- O painel nunca recebe permissão de update em defeitos.
-- ---------------------------------------------------------------------
create or replace function public.aplicar_revisao()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.defeitos d
     set status = case new.acao
                    when 'descartar' then 'descartado'
                    else 'confirmado'
                  end,
         classe = coalesce(new.classe_nova, d.classe),
         grau   = coalesce(new.grau_novo, d.grau),
         revisado_em = now()
   where d.id = new.defeito_id;
  return new;
end;
$$;

revoke all on function public.aplicar_revisao() from public, anon, authenticated;

create trigger revisoes_aplicar
  after insert on public.revisoes
  for each row execute function public.aplicar_revisao();

-- ---------------------------------------------------------------------
-- View de resumo (respeita o RLS de quem consulta)
-- ---------------------------------------------------------------------
create view public.resumo_passivo
with (security_invoker = true)
as
select
  d.obra_id,
  r.nome            as rua,
  r.revestimento,
  d.classe,
  d.grau,
  count(*)          as quantidade,
  coalesce(sum(d.area_m2), 0) as area_total_m2
from public.defeitos d
join public.inspecoes i on i.id = d.inspecao_id
left join public.ruas r on r.id = i.rua_id
where d.status in ('aberto', 'confirmado')
  and d.pre_existente = false
group by d.obra_id, r.nome, r.revestimento, d.classe, d.grau;

revoke all on public.resumo_passivo from anon;
grant select on public.resumo_passivo to authenticated;

-- ---------------------------------------------------------------------
-- Privilégios de tabela: authenticated só pode o que as políticas usam
-- (o RLS filtra as linhas; os grants limitam as operações)
-- ---------------------------------------------------------------------
revoke all on public.obras, public.membros_obra, public.ruas,
              public.inspecoes, public.defeitos, public.revisoes
  from anon, authenticated;

grant select on public.obras, public.membros_obra, public.ruas,
                public.inspecoes, public.defeitos, public.revisoes
  to authenticated;
grant insert on public.revisoes to authenticated;

-- ---------------------------------------------------------------------
-- Storage: buckets privados com limite de tamanho e tipos
-- ---------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('imagens-campo',       'imagens-campo',       false, 10485760, array['image/jpeg', 'image/png', 'image/webp']),
  ('evidencias-defeitos', 'evidencias-defeitos', false, 10485760, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- Leitura das evidências só por membros da obra (caminho começa pelo id da obra).
-- imagens-campo não tem política: só a chave secret acessa.
-- Nenhuma política de insert, update ou delete: só o pipeline escreve.
create policy "membro le evidencias da obra"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'evidencias-defeitos'
    and public.eh_membro_caminho(name)
  );
