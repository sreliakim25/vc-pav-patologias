-- ATENÇÃO: insere dados de teste. Rode só em banco local, nunca em produção.
\set ON_ERROR_STOP off
-- dados de teste (como service_role / dono)
insert into auth.users values ('11111111-1111-1111-1111-111111111111'),('22222222-2222-2222-2222-222222222222'),('33333333-3333-3333-3333-333333333333');
insert into public.obras (id,nome,cidade) values ('aaaaaaaa-0000-0000-0000-000000000001','Obra A','Caruaru'),('bbbbbbbb-0000-0000-0000-000000000002','Obra B','Caruaru');
insert into public.membros_obra values ('aaaaaaaa-0000-0000-0000-000000000001','11111111-1111-1111-1111-111111111111','engenheiro'),('aaaaaaaa-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','leitor');
insert into public.inspecoes (id,obra_id,data_coleta,configuracao,versao_modelo,pasta_origem) values ('cccccccc-0000-0000-0000-000000000001','aaaaaaaa-0000-0000-0000-000000000001','2026-12-02','C1','v1','p'),('cccccccc-0000-0000-0000-000000000002','bbbbbbbb-0000-0000-0000-000000000002','2026-12-02','C1','v1','p');
insert into public.defeitos (id,obra_id,inspecao_id,classe,grau,area_m2,geom) values
 ('dddddddd-0000-0000-0000-000000000001','aaaaaaaa-0000-0000-0000-000000000001','cccccccc-0000-0000-0000-000000000001','afundamento','medio',0.8, extensions.st_setsrid(extensions.st_makepoint(-35.97,-8.28),4326)),
 ('dddddddd-0000-0000-0000-000000000002','bbbbbbbb-0000-0000-0000-000000000002','cccccccc-0000-0000-0000-000000000002','peca_faltante','alto',0.2, null);
insert into storage.objects (bucket_id,name) values ('evidencias-defeitos','aaaaaaaa-0000-0000-0000-000000000001/x/1.jpg'),('evidencias-defeitos','bbbbbbbb-0000-0000-0000-000000000002/x/2.jpg');

\echo '== T1 engenheiro da obra A ve so defeitos de A (esperado 1)'
set role authenticated; set request.jwt.claim.sub = '11111111-1111-1111-1111-111111111111';
select count(*) from public.defeitos;
\echo '== T2 engenheiro ve so evidencia de A (esperado 1)'
select count(*) from storage.objects;
\echo '== T3 engenheiro corrige grau (esperado INSERT ok)'
insert into public.revisoes (defeito_id,usuario_id,acao,grau_novo) values ('dddddddd-0000-0000-0000-000000000001','11111111-1111-1111-1111-111111111111','corrigir','alto');
\echo '== T4 engenheiro nao pode atualizar defeito direto (esperado erro)'
update public.defeitos set grau='baixo';
\echo '== T5 engenheiro nao pode apagar (esperado erro)'
delete from public.defeitos;
\echo '== T6 engenheiro nao revisa em nome de outro (esperado erro)'
insert into public.revisoes (defeito_id,usuario_id,acao) values ('dddddddd-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','confirmar');
\echo '== T7 engenheiro nao revisa defeito da obra B (esperado erro)'
insert into public.revisoes (defeito_id,usuario_id,acao) values ('dddddddd-0000-0000-0000-000000000002','11111111-1111-1111-1111-111111111111','confirmar');
reset role;
\echo '== T8 gatilho aplicou a correcao (esperado alto, confirmado)'
select grau, status from public.defeitos where id='dddddddd-0000-0000-0000-000000000001';
\echo '== T9 leitor nao insere revisao (esperado erro)'
set role authenticated; set request.jwt.claim.sub = '22222222-2222-2222-2222-222222222222';
insert into public.revisoes (defeito_id,usuario_id,acao) values ('dddddddd-0000-0000-0000-000000000001','22222222-2222-2222-2222-222222222222','confirmar');
\echo '== T10 leitor le resumo (esperado 1 linha)'
select rua, classe, grau, quantidade from public.resumo_passivo;
\echo '== T11 nao membro nao ve nada (esperado 0, 0, 0)'
set request.jwt.claim.sub = '33333333-3333-3333-3333-333333333333';
select (select count(*) from public.defeitos), (select count(*) from storage.objects), (select count(*) from public.obras);
reset role;
\echo '== T12 anon nao le defeitos (esperado erro de permissao)'
set role anon;
select count(*) from public.defeitos;
reset role;
