# Fase 5: Piloto numa obra real

| | |
|---|---|
| **Objetivo** | Provar que o sistema é útil para quem fiscaliza, não só que tem boa métrica, mantendo a escala pequena: uma obra, um bairro, uma passada por semana |
| **Duração estimada** | 1 a 2 meses |
| **Subagente principal** | [`piloto-painel`](../../.claude/agents/piloto-painel.md) |
| **Subagentes de apoio** | [`seguranca-supabase`](../../.claude/agents/seguranca-supabase.md) (obrigatório antes de qualquer dado real subir), [`redator-artigo`](../../.claude/agents/redator-artigo.md) |
| **Entradas** | Pipeline da fase 4, projeto Supabase criado na fase 0 |
| **Saídas** | Painel da obra no ar, relatórios semanais, registro de correções do engenheiro, comparação de tempo de fiscalização, módulo `src/supabase_sync/` |

---

## Passo a passo

### Passo 1. Escolher a obra

1. Uma obra com **valas recentes** em intertravado ou paralelepípedo.
2. Combine com o engenheiro responsável o dia fixo da passada semanal e quem vai revisar os defeitos no painel.

### Passo 2. Revisar a segurança antes de subir dados reais

O subagente `seguranca-supabase` executa o checklist completo de [seguranca-supabase.md](../guias/seguranca-supabase.md):

- RLS ligado em todas as tabelas, com políticas testadas;
- buckets privados, URL assinada com validade curta;
- cadastro público desligado, usuários só por convite;
- chave secret só no computador que roda o pipeline;
- Security Advisor sem alertas críticos.

**Nenhum dado real sobe antes deste passo concluído.**

### Passo 3. Vistoria cautelar antes de cada vala

1. Antes de abrir cada nova vala, faça uma passada C1 no trecho.
2. O pipeline registra os defeitos existentes como `pre_existente = true`, com data e coordenada.
3. Esse registro protege contra cobrança por dano que já existia.

### Passo 4. Passada semanal

1. No dia fixo, passe com a câmera C1 por todas as ruas da obra.
2. Processe no mesmo dia:
   ```bash
   python -m src.pipeline.processar --entrada dados/brutos/<pasta>/ --rua <rua> --saida resultados/<pasta>.csv
   python -m src.supabase_sync.enviar --resultados resultados/<pasta>.csv --inspecao <pasta>
   ```
3. O envio usa a chave secret **apenas no seu computador**, sobe as fotos anonimizadas para o bucket privado e grava os defeitos na tabela.

### Passo 5. Painel da obra

O subagente `piloto-painel` cria uma página única (HTML, CSS e JavaScript, sem framework), publicada no Vercel:

1. **Login** por link mágico do Supabase Auth, só para usuários convidados.
2. **Mapa** (MapLibre ou Leaflet) com os defeitos coloridos por grau.
3. **Ficha do defeito**: foto (por URL assinada), classe, grau, medidas, vala mais próxima, data da primeira detecção.
4. **Botões de revisão**: confirmar, corrigir classe ou grau, descartar. Toda ação grava em `revisoes` com o usuário e a data.
5. **Filtros**: rua, grau, classe, status de revisão, pré-existente ou não.

A página usa só a chave **publishable**; quem protege os dados é o RLS.

### Passo 6. Relatório semanal

1. Gerado a partir do banco: área de passivo por rua, quantidade por grau, defeitos novos, defeitos corrigidos, evolução desde a semana anterior.
2. Opcional: um modelo de linguagem escreve o texto em português a partir dos números, e o engenheiro revisa antes de enviar.

### Passo 7. Fechar o ciclo de aprendizado

1. Toda correção do engenheiro é exportada como rótulo:
   ```bash
   python -m src.supabase_sync.exportar_correcoes --desde 2026-12-01 --saida dados/correcoes/
   ```
2. As correções entram no próximo dataset (v1.2) e no retreino mensal.

### Passo 8. Medir a utilidade

1. Antes do piloto, cronometre uma vistoria manual de uma rua.
2. Durante o piloto, cronometre a passada, o processamento e a revisão no painel.
3. Registre casos concretos em que o sistema apontou um problema antes da vistoria manual.
4. Acompanhe semana a semana a **taxa de descarte** (alarmes falsos descartados sobre total de detecções).

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F5-01 | Escolher a obra e combinar a rotina | Eliakim |
| F5-02 | Checklist de segurança completo | `seguranca-supabase` |
| F5-03 | Vistoria cautelar das valas novas | Eliakim |
| F5-04 | Módulo de envio ao Supabase | `piloto-painel` |
| F5-05 | Painel da obra (login, mapa, ficha, revisão) | `piloto-painel` |
| F5-06 | Relatório semanal | `piloto-painel` |
| F5-07 | Exportação de correções como rótulo | `piloto-painel` |
| F5-08 | Medição de tempo antes e depois | Eliakim |
| F5-09 | Trabalho técnico para congresso com os resultados do piloto | `redator-artigo` |

---

## Portão para avançar à fase 6

- [ ] O engenheiro usa o painel na rotina sem ser lembrado.
- [ ] A taxa de descarte de alarmes falsos cai semana a semana.
- [ ] Pelo menos um caso concreto em que o sistema encontrou um problema antes da vistoria manual.
- [ ] Nenhum incidente de segurança e Security Advisor limpo.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Passadas semanais feitas | 1 por semana |
| Taxa de descarte | caindo |
| Correções exportadas | acompanhar |
| Tempo de fiscalização por rua | menor que o manual |
| Casos encontrados antes da vistoria manual | 1 ou mais |
| Alertas críticos no Security Advisor | 0 |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Engenheiro não usa o painel | Painel simples, no celular, com poucos cliques; relatório no WhatsApp com link |
| Alarmes falsos demais | Limiar mais alto nas classes mais ruidosas; retreino com correções |
| Vazamento de dados | Checklist de segurança; chave secret fora do Git e do navegador |

## O que registrar para o artigo

- Descrição do piloto (sem identificar a obra), duração e frequência.
- Taxa de descarte ao longo das semanas.
- Comparação de tempo.
- Casos de uso relatados pelo engenheiro.
