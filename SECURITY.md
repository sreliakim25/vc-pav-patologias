# Política de segurança

## Como relatar uma vulnerabilidade

Se encontrar uma chave exposta, uma imagem com pessoa identificável ou uma falha de acesso ao banco, **não abra uma issue pública**. Use o recurso "Report a vulnerability" (Security > Advisories) do GitHub ou escreva diretamente ao autor. A resposta inicial é dada em até 7 dias.

## O que fazer se uma chave vazar

1. Entre no painel do Supabase em **Settings > API Keys**.
2. Crie uma nova chave secret e **apague a chave vazada**. Apagar uma chave secret a revoga na hora.
3. Atualize o `.env` local e qualquer servidor que use a chave.
4. Se a chave chegou a entrar num commit, considere o histórico comprometido: a rotação acima é obrigatória, mesmo que o commit seja apagado depois.
5. Revise os logs do projeto no Supabase para ver acessos no período.

## Regras permanentes

As regras de segurança do banco, do Storage e da autenticação estão em [docs/guias/seguranca-supabase.md](docs/guias/seguranca-supabase.md) e valem para qualquer contribuição.
