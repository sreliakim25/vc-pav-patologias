# Segurança do Supabase

Este guia é obrigatório. Ele vale para qualquer pessoa ou subagente que mexa no banco, no Storage, nas chaves ou na autenticação. A regra de fundo é **negar por omissão**: nada é acessível até que uma política diga que é.

O subagente [`seguranca-supabase`](../../.claude/agents/seguranca-supabase.md) aplica este guia em cada revisão.

---

## Modelo de ameaça (o que estamos protegendo)

| O que | Por que importa | Proteção principal |
|---|---|---|
| Imagens de rua | Podem conter rostos e placas (LGPD) | Anonimizar antes do upload; buckets privados |
| Localização de defeitos e valas | Informação operacional de obra e de contrato | RLS por obra; acesso só por convite |
| Revisões do engenheiro | Valor de registro técnico | Usuário e data gravados; sem apagar |
| Chave secret | Ignora todo o RLS | Só no computador que roda o pipeline; nunca no Git nem no navegador |

---

## 1. Conta e organização

1. Ative a **autenticação em dois fatores** na sua conta do Supabase (Account > Security).
2. Use uma organização só para o projeto e convide outras pessoas com o menor papel necessário.
3. Escolha a região mais próxima (São Paulo, `sa-east-1`) para latência e para manter os dados no Brasil.

## 2. Chaves de API

O Supabase está substituindo as chaves legadas `anon` e `service_role` pelas chaves **publishable** (`sb_publishable_...`) e **secret** (`sb_secret_...`); as legadas serão descontinuadas até o fim de 2026. Projetos novos devem usar só as novas.

| Chave | Onde pode ficar | O que acessa |
|---|---|---|
| `sb_publishable_...` | Navegador, painel, app | Só o que as políticas de RLS liberam para `anon` ou `authenticated` |
| `sb_secret_...` | Scripts no seu computador, servidor, Edge Functions | Tudo: o papel `service_role` ignora o RLS |

Regras:

- A chave secret fica **só** no `.env` local (que está no `.gitignore`).
- Uma chave secret usada no navegador é recusada pelo Supabase com erro 401; mesmo assim, nunca tente.
- Crie **uma chave secret por uso** (ex.: `pipeline`), para poder revogar só aquela se vazar. Apagar uma chave secret a revoga na hora.
- Desative as chaves legadas quando nada mais as usar.

## 3. Autenticação

1. **Desligue o cadastro público**: em Authentication > Sign In / Providers, desative a opção de permitir novos usuários. Pessoas entram **só por convite** (Authentication > Users > Invite).
2. Use **link mágico por e-mail** (sem senha para gerenciar).
3. Configure as **URLs de redirecionamento** permitidas só para o domínio do painel (ex.: o domínio do Vercel).
4. Cada usuário convidado ganha uma linha em `membros_obra` com o papel: `admin`, `engenheiro` (revisa) ou `leitor` (só vê).

## 4. Row Level Security (RLS)

1. **Toda tabela** do schema `public` tem RLS ligado na mesma migração que a cria. A migração [0001_esquema_inicial.sql](../../supabase/migrations/0001_esquema_inicial.sql) segue esse padrão.
2. Sem política, ninguém acessa (exceto a chave secret). Políticas são escritas para cada operação necessária, e só para `authenticated`.
3. O acesso é **por obra**: um usuário só vê o que pertence às obras em que é membro. A checagem fica na função `privado.eh_membro(obra_id)` (schema fora da API, migração 0003).
4. **Escrita de resultados** (inspeções e defeitos) só pela chave secret, no pipeline. O painel não insere defeitos.
5. **Revisão do engenheiro** entra na tabela `revisoes` (o engenheiro só pode inserir em seu próprio nome, em obras onde tem papel de edição). Um gatilho aplica a revisão ao defeito. Assim o painel nunca precisa de permissão de `update` em `defeitos`.
6. **Ninguém apaga** pelo painel. Descartar é um status, não um `delete`.
7. Funções `security definer` só quando necessário, sempre com `set search_path = ''` e nomes qualificados.
8. Views com `security_invoker = true`, para respeitarem o RLS de quem consulta.
9. Colunas usadas nas políticas têm índice (desempenho).

## 5. Storage

| Bucket | Público? | Quem lê | Quem escreve |
|---|---|---|---|
| `imagens-campo` | Não | Ninguém pelo painel | Só o pipeline (chave secret) |
| `evidencias-defeitos` | Não | Membros da obra, por URL assinada | Só o pipeline (chave secret) |

Regras:

- Caminho dos arquivos: `<obra_id>/<inspecao_id>/<defeito_id>.jpg`. A política de leitura usa a primeira pasta para checar se o usuário é membro da obra.
- Limite de tamanho (10 MB) e tipos permitidos (`image/jpeg`, `image/png`, `image/webp`) configurados no bucket.
- O painel mostra fotos por **URL assinada com validade curta** (`createSignedUrl(caminho, 600)`, 10 minutos). Bucket privado não aceita URL pública.
- Só sobem imagens de `dados/anonimizados/`.

## 6. Realtime (se usado)

Se o painel usar atualização em tempo real, as políticas de RLS também valem para o Realtime. Use canais privados e não publique tabelas inteiras sem necessidade.

## 7. Segredos no repositório

Antes de cada commit:

```bash
git status                                  # .env, dados/ e modelos/ não podem aparecer
git diff --cached | grep -nE 'sb_secret_[A-Za-z0-9]|eyJhbGciOi' && echo "PARE: chave no commit"
```

Se uma chave entrar num commit, siga o [SECURITY.md](../../SECURITY.md): **rotacione a chave**, mesmo que apague o commit depois.

## 8. Backups e monitoramento

1. Confirme que os backups diários estão ativos (Database > Backups).
2. Rode o **Security Advisor** (Advisors > Security Advisor) depois de cada migração. Meta: zero alertas críticos.
3. Rode também o **Performance Advisor** para índices faltando nas políticas.
4. Exporte periodicamente um dump do esquema para o repositório: `supabase db dump --schema public -f supabase/esquema_atual.sql` (só esquema, sem dados).

## 9. Desenvolvimento local

Para testar migrações sem tocar no projeto real:

```bash
npm install -g supabase       # ou: npx supabase
supabase init                 # só na primeira vez
supabase start                # sobe Postgres, Auth e Storage locais
supabase db reset             # aplica todas as migrações do zero
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f supabase/verificar_seguranca.sql
```

O `supabase start` mostra uma chave publishable e uma secret **locais**, que só valem na sua máquina.

Para aplicar no projeto real:

```bash
supabase link --project-ref <ref-do-projeto>
supabase db push
```

## 10. Checklist antes de subir dado real (fase 5)

- [ ] Dois fatores ativo na conta.
- [ ] Cadastro público desligado; usuários só por convite.
- [ ] Chaves publishable e secret em uso; legadas desativadas.
- [ ] `verificar_seguranca.sql` sem nenhuma tabela com RLS desligado.
- [ ] Buckets privados, com limite de tamanho e tipos.
- [ ] Teste manual: um usuário que não é membro da obra não vê nenhum defeito nem foto.
- [ ] Teste manual: um usuário `leitor` não consegue inserir revisão.
- [ ] Security Advisor sem alertas críticos.
- [ ] Nenhum segredo no Git (comandos da seção 7).
- [ ] Backups ativos.

## Referências

- Supabase, [Understanding API keys](https://supabase.com/docs/guides/getting-started/api-keys)
- Supabase, [Migrating to publishable and secret API keys](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)
- Supabase, [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- Supabase, [Storage access control](https://supabase.com/docs/guides/storage/security/access-control)
