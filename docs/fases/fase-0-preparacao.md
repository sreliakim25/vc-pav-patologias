# Fase 0: Preparação

| | |
|---|---|
| **Objetivo** | Decidir o que vai ser filmado, como, com que equipamento e com que permissão, antes de gastar uma hora de campo |
| **Duração estimada** | 2 semanas |
| **Subagente principal** | [`coleta-campo`](../../.claude/agents/coleta-campo.md) |
| **Subagentes de apoio** | [`seguranca-supabase`](../../.claude/agents/seguranca-supabase.md) (projeto criado com segurança desde o início), [`redator-artigo`](../../.claude/agents/redator-artigo.md) (registro do método) |
| **Entradas** | Proposta de pesquisa, normas de referência, acesso às ruas |
| **Saídas** | Guia de rotulagem v1, lista de ruas, kit montado e testado, autorização assinada, projeto Supabase criado com RLS |

---

## Por que esta fase existe

O artigo de referência (Freitas et al., 2024) mostrou que a **forma de coletar pesa mais que o volume de dados**: 1.389 imagens com a câmera apontada para o pavimento renderam mAP de 84,90%, contra 57,12% de 10.000 imagens panorâmicas. Tudo o que for decidido aqui define a qualidade do dataset inteiro.

---

## Passo a passo

### Passo 1. Fechar as classes e os graus de severidade

1. Abra o [guia de rotulagem](../guias/guia-rotulagem.md). Ele já traz a proposta inicial de 8 classes.
2. Compre e leia a **ASTM E2840** (PCI para pavimento intertravado). Compare os tipos de defeito da norma com as classes do guia e ajuste nomes e definições para ficarem alinhados. Isso facilita a aceitação pelos revisores do artigo.
3. Para cada classe, confirme a **medida que define o grau** (profundidade, número de peças, largura de junta) e os limites baixo, médio e alto.
4. Marque como "a calibrar" os limites que ainda não têm referência publicada. Eles serão ajustados com a vistoria da fase 1.
5. Registre a versão final no guia como `v1` e faça o commit: `docs: guia de rotulagem v1`.

**Pronto quando:** cada classe tem definição de uma frase, medida de severidade e limites (mesmo que provisórios).

### Passo 2. Escolher as ruas do piloto

1. Liste de 6 a 10 ruas candidatas que você conhece bem.
2. Escolha **4 ruas**: 2 de intertravado e 2 de paralelepípedo.
3. Garanta que, somadas, as ruas tenham:
   - pelo menos uma recomposição de vala em cada tipo de pavimento;
   - defeitos de todas as classes principais (afundamento, peça faltante, junta aberta);
   - trechos em bom estado (o modelo precisa aprender o que é normal);
   - tráfego que permita filmar devagar e medir com segurança.
4. Para cada rua, registre em `projeto/kanban.json` (campo `ruas`): nome curto, tipo de pavimento, extensão aproximada, tipo de peça (retangular, sextavado, I, paralelepípedo granítico) e observações.

**Pronto quando:** 4 ruas registradas, com a lista de classes que cada uma cobre.

### Passo 3. Montar o kit

| Item | Uso | Observação |
|---|---|---|
| Câmera de ação com GPS (ex.: GoPro) | Configuração principal C1 | Modo linear evita distorção de lente |
| Suporte rígido de para-choque ou de moto | Fixar a câmera apontada para o pavimento | Quanto mais rígido, menos vibração |
| Celular com suporte de para-brisa | Configuração C2 (comparação com o artigo) | |
| Celular para fotos de mão | Configuração C3 (medição de referência) | Se for iPhone Pro, o LiDAR serve para profundidade |
| Trena de 5 m | Comprimento e largura dos defeitos e das peças | |
| Régua de alumínio de 3 m | Profundidade de afundamento | Referência das especificações de recebimento |
| Cunha graduada | Ler a profundidade sob a régua | Pode ser feita de madeira com marcação em mm |
| Paquímetro | Largura de junta | |
| Régua graduada de 30 cm ou 50 cm, bem visível | Aparecer nas fotos como escala de conferência | Cor contrastante |
| Cones e colete | Segurança durante a medição | |
| Cartões de memória e bateria extra | | |

### Passo 4. Fixar a configuração da câmera

1. Monte a câmera no suporte e meça com a trena a **altura da lente até o chão** e o **ângulo** em relação à horizontal. Anote.
2. Configure:
   - modo **linear** (sem olho de peixe);
   - **GPS ligado**;
   - **estabilização ligada**;
   - vídeo em 4K a 30 quadros por segundo **ou** foto em intervalo de 0,5 s;
   - exposição automática, sem filtros.
3. Fotografe o suporte montado e guarde em `docs/artigo/figuras/kit-c1.jpg`. Essa foto entra no artigo.

### Passo 5. Fazer o teste de 10 minutos

1. Escolha um trecho de 100 a 200 m de uma das ruas.
2. Passe com a configuração C1 a cerca de 10 a 15 km/h.
3. No computador, confira:
   - as **juntas entre as peças** estão nítidas no quadro?
   - o pavimento ocupa **a maior parte da imagem** (céu e veículo devem ser mínimos)?
   - a **trilha GPS** foi gravada e bate com o trajeto?
   - há **borrão de movimento** no paralelepípedo? Se houver, reduza a velocidade ou aumente o intervalo de fotos.
4. Ajuste e repita até passar nos quatro itens.

### Passo 6. Pedir autorização

1. Se as ruas forem de obras da empresa, peça autorização **por escrito** para usar imagens e dados de vistoria em pesquisa e em divulgação anonimizada.
2. Deixe claro no pedido: não haverá identificação de pessoas, placas, nem dados contratuais; o dataset publicado será anonimizado.
3. Guarde o documento fora do repositório (ele não é público). Registre no diário de pesquisa apenas que a autorização foi obtida e a data.

### Passo 7. Criar o projeto Supabase com segurança

Mesmo que o banco só seja usado de verdade na fase 5, crie o projeto agora, para que ele nasça seguro:

1. Siga [docs/guias/seguranca-supabase.md](../guias/seguranca-supabase.md), seções 1 a 4.
2. Aplique a migração `supabase/migrations/0001_esquema_inicial.sql`.
3. Rode o **Security Advisor** do Supabase e confirme zero alertas críticos.
4. Preencha seu `.env` local a partir do `.env.example`. Rode `git status` e confirme que o `.env` **não aparece** para commit.

### Passo 8. Organizar as pastas e o padrão de nomes

1. Siga a estrutura de [dados/README.md](../../dados/README.md).
2. Padrão de pasta por coleta: `AAAA-MM-DD_<rua>_<configuracao>_<passada>`.
3. Copie o modelo `docs/guias/modelo-vistoria.csv` para `dados/vistoria/vistoria.csv`. As colunas são:

```csv
id_defeito,data,rua,classe,latitude,longitude,comprimento_cm,largura_cm,profundidade_mm,pecas_afetadas,largura_junta_mm,grau_avaliador_1,grau_avaliador_2,foto,observacoes
```

---

## Tarefas da fase (espelhadas no kanban)

| ID | Tarefa | Responsável |
|---|---|---|
| F0-01 | Fechar classes e graus no guia de rotulagem v1 | Eliakim + `coleta-campo` |
| F0-02 | Comprar e comparar com a ASTM E2840 | Eliakim |
| F0-03 | Escolher e registrar as 4 ruas do piloto | Eliakim |
| F0-04 | Montar o kit de campo | Eliakim |
| F0-05 | Fixar e documentar a configuração da câmera C1 | `coleta-campo` |
| F0-06 | Teste de 10 minutos aprovado | Eliakim |
| F0-07 | Autorização escrita para uso das imagens | Eliakim |
| F0-08 | Criar projeto Supabase com RLS e rodar o Security Advisor | `seguranca-supabase` |
| F0-09 | Estrutura de pastas e planilha de vistoria | `coleta-campo` |
| F0-10 | Registrar o método no diário de pesquisa | `redator-artigo` |

---

## Portão para avançar à fase 1

- [ ] Um teste de 10 minutos gera imagens nítidas, com a junta das peças visível e o GPS gravado.
- [ ] Guia de rotulagem v1 publicado no repositório.
- [ ] 4 ruas registradas no kanban.
- [ ] Autorização obtida.
- [ ] Supabase criado com RLS e sem alertas críticos no Security Advisor.

O orquestrador só move a fase para "concluída" com todos os itens marcados. Use `/avancar-fase` para a checagem.

## Indicadores acompanhados no painel

| Indicador | Meta |
|---|---|
| Ruas definidas | 4 |
| Itens do kit prontos | 100% |
| Teste de câmera aprovado | sim |
| Alertas críticos no Security Advisor | 0 |

## Riscos e como lidar

| Risco | Como lidar |
|---|---|
| Vibração no paralelepípedo borra a imagem | Suporte mais rígido, velocidade menor, foto em intervalo em vez de vídeo |
| Autorização demora | Comece com ruas públicas fora de obras, com fotos sem identificação de pessoas |
| Classes não batem com a ASTM E2840 | Mantenha um mapeamento classe do projeto para classe da norma no guia |

## O que registrar para o artigo

- Descrição do kit, altura e ângulo da câmera, configurações.
- Foto do suporte montado.
- Critérios de escolha das ruas e características de cada uma.
- Versão 1 das classes e dos limites de severidade, com a origem de cada limite.
