# Diário de pesquisa

Registro cronológico de tudo que tem valor para o artigo: decisões de método, números, problemas e soluções. **Mais recente primeiro.** Mantido pelo subagente [`redator-artigo`](../../.claude/agents/redator-artigo.md).

## Modelo de entrada

```markdown
### AAAA-MM-DD · Fase N · <título curto>
- **O que aconteceu:**
- **Números (com fonte):**
- **Decisão e motivo:**
- **Impacto no artigo:** <seção do estrutura-artigo.md>
```

---

### 2026-10-20 · Fase 0 · Guia de rotulagem v1 fechado

- **O que aconteceu:** o Eliakim decidiu as propostas P1 a P12 da comparação com a ASTM E2840 (tarefa F0-01). As decisões foram aplicadas em `docs/guias/guia-rotulagem.md`, agora v1 de 2026-10-20, e em `docs/guias/classes.json`. Fonte das decisões: `docs/guias/comparacao-astm-e2840.md`, seção 6. Esta entrada substitui o estado "proposta, não decisão" da subseção "Classes e severidade, versão 1" da entrada "Protocolo de coleta planejado", de mesma data.
- **Decisões e motivos:**
  - **P1 aprovada:** `afundamento` com grau baixo até 13 mm no intertravado e até 15 mm no paralelepípedo.
  - **P2 e P4 rejeitadas:** `junta_aberta` continua classe única, graduada pela largura da junta. Motivo: é mais simples de rotular na imagem. O guia segue com **8 classes**; não existem `junta_larga` nem `perda_rejunte`.
  - **P3 aplicada só na fonte:** as faixas de `junta_aberta` não mudam; a origem do limite aceitável de 10 mm passa a ser a ASTM E2840 via manual ABCP (2022).
  - **P5 a P8 e P12 aprovadas:** grau baixo de `desnivel` e de `desconfinamento` preenchidos; `peca_quebrada` mantém o código e passa a significar peça danificada (fissura, lasca, canto quebrado ou peça partida); `peca_faltante` com origem ASTM no grau baixo; `vegetacao` mantida como classe própria do projeto.
  - **P9 a P11 aprovadas** (registradas na seção 6 da comparação como "aprovadas como propostas"):
    - trilha de roda (ASTM 11) não vira classe: entra a **tag nova `trilha_roda`**, usada em `afundamento` quando o rebaixo é longitudinal, no caminho da roda;
    - elevação (ASTM 6) **fora da rotulagem v1**: quase não se distingue numa imagem 2D; vai para a planilha de vistoria e será reavaliada com profundidade (LiDAR, fase 6);
    - fluência horizontal (ASTM 7) **fora da rotulagem v1**: não vira máscara; será medida como grandeza derivada da grade de peças na fase 4.
- **Números (com fonte):** limites do grau baixo na v1. Fonte: `guia-rotulagem.md`, tabela "Graus de severidade".

| Classe | Medida | Grau baixo | Origem do limite |
|---|---|---|---|
| `afundamento` | Profundidade sob régua de 3 m | intertravado: até 13 mm; paralelepípedo: até 15 mm | 13 mm: ASTM E2840 via manual ABCP (2022); 15 mm: especificações municipais de recebimento de paralelepípedo |
| `peca_faltante` | Peças contíguas afetadas | 1 peça isolada | ASTM E2840 via manual ABCP (2022) |
| `peca_quebrada` | Estado da peça | fissura, lasca ou canto quebrado, sem perda de material | ASTM E2840 via manual ABCP (2022) aceita 1 ou 2 peças danificadas sem separação; graus são proposta, a calibrar |
| `junta_aberta` | Largura da junta | 6 a 10 mm | Limite aceitável de 10 mm: ASTM E2840 via manual ABCP (2022); faixas: publicado para intertravado permeável |
| `desconfinamento` | Junta e rotação junto ao meio-fio | junta de 6 a 13 mm, sem rotação | ASTM E2840 via manual ABCP (2022) |
| `desnivel` | Degrau medido com régua de 30 cm | até 6 mm | ASTM E2840 via manual ABCP (2022) |
| `remendo` | Área em m² | sem grau | |
| `vegetacao` | Percentual da área | sem grau | |

  - Graus médio e alto: em `afundamento`, `peca_faltante`, `peca_quebrada` e `desnivel` seguem como proposta ou "a calibrar" com a vistoria da fase 1. Em `junta_aberta` (11 a 15 mm; acima de 15 mm) e `desconfinamento` (com rotação; rotação e recalque local) a origem declarada no guia é "publicado para intertravado permeável", **sem referência bibliográfica identificada** no guia nem em `referencias.md`.
  - Os limites de origem ASTM vêm de fonte secundária (manual ABCP, p. 8 a 11), que dá um limite por defeito sem dizer a qual grau ele corresponde. Fonte: `comparacao-astm-e2840.md`, seção 1.
- **Hipótese (não testada):** a fluência horizontal pode ser medida pelo desvio do alinhamento das juntas na grade de peças (fase 4). A decisão de hoje só define o tratamento; a viabilidade da medida não foi testada.
- **Impacto no artigo:**
  - Seção 3.4 (classes e severidade): 8 classes, tabela de graus com a origem de cada limite, tag `trilha_roda`, mapeamento para a ASTM E2840 (`guia-rotulagem.md`, seção "Mapeamento para a ASTM E2840") e os dois defeitos ASTM fora da v1, com o motivo.
  - Seção 5 (limitações): `junta_aberta` junta dois defeitos ASTM (4, largura de junta excessiva, e 8, perda de rejunte ou bombeamento). Ao comparar com o PCI ou com levantamentos pela ASTM E2840, isso deve ser declarado: a classe do projeto não separa os dois e é graduada só pela largura, sem a profundidade do rejunte. Elevação também não é rotulada, então a cobertura é de 9 dos 11 defeitos ASTM, sendo 2 deles (4 e 8) fundidos numa só classe, e a fluência horizontal depende da fase 4. Continuam valendo as limitações da entrada de 2026-10-19: fonte secundária, sem Apêndice X1, sem limites para paralelepípedo.

### 2026-10-20 · Fase 0 · Protocolo de coleta planejado (método, ainda não executado)

- **O que aconteceu:** registro do protocolo de coleta da Fase 0 como **método planejado** (tarefa F0-10). Nada do que está abaixo foi executado em campo. Não há altura nem ângulo de câmera medidos, foto do suporte, ruas escolhidas nem resultado do teste de 10 minutos. Esses dados serão produzidos por F0-03, F0-04, F0-05 e F0-06 e entrarão numa entrada nova, sem reescrever esta. Fonte de todo o conteúdo: `docs/fases/fase-0-preparacao.md` (Passos 2 a 5) e `docs/fases/fase-1-filmagens-vistoria.md` (tabela "Configurações de coleta").
- **Motivo do cuidado com a coleta (resultado de terceiros, não do projeto):** em Freitas et al. (2024), 1.389 imagens com a câmera apontada para o pavimento renderam mAP de 84,90%, contra 57,12% de 10.000 imagens panorâmicas. Fonte: `fase-0-preparacao.md`, seção "Por que esta fase existe". Conferir os dois valores na Tabela 2 do artigo original antes de citar no texto final.

#### Proposta: configurações de coleta

| Código | Equipamento e posição | Papel no estudo |
|---|---|---|
| C1 | Câmera de ação com GPS no para-choque ou na moto, apontada para o pavimento, modo linear | Configuração principal; equivale ao melhor conjunto do artigo de referência |
| C2 | Celular no suporte de para-brisa, vista panorâmica | Comparação direta com os conjuntos de celular do artigo de referência |
| C3 | Celular de mão, a pé, vista de cima | Medição de alta precisão; referência para as outras configurações |
| C4 | Drone em voo baixo, opcional na Fase 1 | Relevo para afundamento; vista de cima de trechos inteiros. Não faz parte do kit da Fase 0 |

Fonte: `fase-1-filmagens-vistoria.md`, tabela "Configurações de coleta"; `fase-0-preparacao.md`, Passo 3.

#### Proposta: kit de campo (Passo 3)

| Item | Uso | Observação |
|---|---|---|
| Câmera de ação com GPS (ex.: GoPro) | Configuração C1 | Modo linear evita distorção de lente |
| Suporte rígido de para-choque ou de moto | Fixar a câmera apontada para o pavimento | Quanto mais rígido, menos vibração |
| Celular com suporte de para-brisa | Configuração C2 | |
| Celular para fotos de mão | Configuração C3 | Se for iPhone Pro, o LiDAR serve para profundidade |
| Trena de 5 m | Comprimento e largura dos defeitos e das peças | |
| Régua de alumínio de 3 m | Profundidade de afundamento | Referência das especificações de recebimento |
| Cunha graduada | Ler a profundidade sob a régua | Pode ser de madeira, com marcação em mm |
| Paquímetro | Largura de junta | |
| Régua graduada de 30 cm ou 50 cm, cor contrastante | Escala de conferência nas fotos | |
| Cones e colete | Segurança durante a medição | |
| Cartões de memória e bateria extra | Autonomia em campo | |

Estado: kit **não montado**. Marca e modelo da câmera e do celular ainda não definidos (F0-04).

#### Proposta: parâmetros da câmera C1 (Passo 4)

- Modo linear, sem olho de peixe.
- GPS ligado.
- Estabilização ligada.
- Vídeo em 4K a 30 quadros por segundo **ou** foto em intervalo de 0,5 s.
- Exposição automática, sem filtros.
- Altura da lente até o chão e ângulo em relação à horizontal: **a medir** com trena após a montagem (F0-05). Sem valor planejado no documento.
- Foto do suporte montado: **a produzir**, destino `docs/artigo/figuras/kit-c1.jpg` (F0-05).

#### Proposta: critérios de escolha das ruas (Passo 2)

- Listar de 6 a 10 ruas candidatas; escolher 4: 2 de intertravado e 2 de paralelepípedo.
- Somadas, as 4 ruas devem ter: pelo menos uma recomposição de vala em cada tipo de pavimento; defeitos de todas as classes principais (afundamento, peça faltante, junta aberta); trechos em bom estado; tráfego que permita filmar devagar e medir com segurança.
- Dados por rua a registrar em `projeto/kanban.json` (campo `ruas`): nome curto, tipo de pavimento, extensão aproximada, tipo de peça (retangular, sextavado, I, paralelepípedo granítico), observações e classes cobertas.
- Estado: **nenhuma rua escolhida** (F0-03).

#### Proposta: critérios de aceite do teste de 10 minutos (Passo 5)

- Trecho de 100 a 200 m de uma das ruas, configuração C1, cerca de 10 a 15 km/h.
- Aprovado quando passar nos quatro itens: (1) juntas entre as peças nítidas no quadro; (2) pavimento ocupa a maior parte da imagem, com céu e veículo mínimos; (3) trilha GPS gravada e coerente com o trajeto; (4) sem borrão de movimento no paralelepípedo. Se houver borrão, reduzir a velocidade ou aumentar o intervalo de fotos e repetir.
- Estado: **não realizado** (F0-06). Os critérios são qualitativos; não há limiar numérico de nitidez definido nesta fase.

#### Classes e severidade, versão 1

- Estado: **proposta, não decisão**. O guia segue com 8 classes; as 12 propostas de ajuste (P1 a P12, incluindo a divisão de `junta_aberta`, que levaria a 9 classes) aguardam validação do Eliakim. Ver a entrada de 2026-10-19 "Guia de rotulagem comparado com a ASTM E2840" e `docs/guias/comparacao-astm-e2840.md`, seção 3. A origem de cada limite só será registrada como definitiva quando o guia for publicado como v1 (F0-01).

#### Inconsistências a resolver antes do campo

- **Intervalo de fotos:** a Fase 0 (Passo 4) prevê foto a cada 0,5 s; a Fase 1 (Passo 2) prevê uma foto a cada 2 a 3 m, o que dá cerca de 1 s a 10 km/h. A 10 km/h, 0,5 s equivale a cerca de 1,4 m; a 15 km/h, a cerca de 2,1 m (cálculo a partir das velocidades dos documentos). Definir um só critério (por tempo ou por distância) em F0-05 e registrar o motivo.
- **C4 no artigo:** `estrutura-artigo.md` (seção 3.2) cita configurações C1 a C4, mas o kit da Fase 0 não inclui drone e a C4 é opcional na Fase 1. Se a C4 não for coletada, a seção 3.2 deve dizer C1 a C3 e a ausência entra nas limitações.

#### O que falta registrar na Fase 0

| Item ("O que registrar para o artigo") | Tarefa que produz | Estado | Seção do artigo |
|---|---|---|---|
| Descrição do kit (itens e uso) | F0-04 | Planejado registrado nesta entrada; kit real (marcas e modelos) pendente | 3.2 Coleta |
| Altura e ângulo da câmera C1 | F0-05 | Pendente | 3.2 Coleta |
| Configurações da câmera | F0-05 | Planejado registrado nesta entrada; configuração efetiva pendente | 3.2 Coleta |
| Foto do suporte montado (`figuras/kit-c1.jpg`) | F0-05 | Pendente | 3.2 Coleta; Fig. 1 |
| Critérios de escolha das ruas | F0-03 | Registrado nesta entrada | 3.1 Área de estudo |
| Características de cada rua | F0-03 | Pendente | 3.1 Área de estudo |
| Resultado do teste de 10 minutos e ajustes feitos | F0-06 | Critérios registrados; resultado pendente | 3.2 Coleta |
| Versão 1 das classes e limites, com a origem de cada limite | F0-01 e F0-02 | Comparação registrada (2026-10-19); validação das propostas P1 a P12 e publicação da v1 pendentes | 3.4 Classes e severidade |
| Autorização obtida e data (sem o documento) | F0-07 | Pendente | Disponibilidade de dados; ética |

- **Impacto no artigo:** seção 3.1 (critérios de escolha das ruas); seção 3.2 (configurações, kit, parâmetros da câmera, teste de aceite); seção 3.4 (estado da v1 das classes); Fig. 1; seção 5 (limitações, se a C4 não for coletada e se o teste de aceite seguir só qualitativo).

### 2026-10-19 · Fase 0 · Guia de rotulagem comparado com a ASTM E2840

- **O que aconteceu:** as 8 classes e os graus do guia de rotulagem v1 foram comparados com a ASTM E2840 e com o Manual de Desempenho ABCP/BlocoBrasil 2022 (tarefas F0-01 e F0-02). O guia não foi alterado. Documento completo: `docs/guias/comparacao-astm-e2840.md`.
- **Fontes consultadas:**
  - ASTM E2840-11, reaprovada em 2019: só a prévia de 3 páginas (escopo, terminologia, equipamentos, amostragem e ficha de campo da Fig. 2). **Sem o Apêndice X1**, onde ficam as definições, os graus baixo, médio e alto e as curvas de dedução do PCI.
  - Silva, C. O. Manual de desempenho, ABCP e BlocoBrasil, 2022, ISBN 978-85-87024-86-2, seção 2 (p. 8 a 11). Fonte secundária: cita a ASTM E2840 edição 2015, que é o mesmo texto de 2011 (conferido na capa da ASTM). Dá um limite por defeito, sem dizer a qual grau ele corresponde.
- **Números (com fonte):**
  - 7 das 8 classes do guia têm equivalente entre os 11 defeitos da ASTM E2840 (Fig. 2, p. 3). A classe sem equivalente é `vegetacao`. Fonte: `comparacao-astm-e2840.md`, seção 2.
  - 3 defeitos da ASTM não estão no guia: elevação (6), fluência horizontal (7) e trilha de roda (11). Mesma fonte.
  - A classe `junta_aberta` do guia junta dois defeitos ASTM: largura de junta excessiva (4) e perda de rejunte ou bombeamento (8). Mesma fonte.
  - Limites citados pelo manual (p. 8 a 11), com origem na ASTM: depressão 13 mm sob régua de 3 m; largura de junta até 10 mm; escalonamento até 6 mm com régua de 30 cm; contenção lateral com junta de 6 a 13 mm, sem rotação, entre 0,3 e 0,6 m da borda; perda de rejunte até 13 mm de altura a partir do fundo do chanfro; 1 peça faltante isolada; elevação e trilha de roda 13 mm sob régua de 3 m; fluência horizontal 13 mm no centro de uma linha de 15 m.
  - A ASTM E2840 declara, na seção 4.2, que a exatidão e a repetibilidade do PCI para intertravado ainda não foram verificadas.
- **Propostas (PENDENTES de validação do Eliakim, não são decisão tomada):** P1 a P12, descritas na seção 3 de `comparacao-astm-e2840.md`. Em resumo:
  - P1: `afundamento` com grau baixo de 13 mm no intertravado (ASTM) e 15 mm no paralelepípedo (especificações municipais).
  - P2 a P4: dividir `junta_aberta` em `junta_larga` (largura, mensurável na imagem) e `perda_rejunte` (profundidade, só em campo). O guia passaria de 8 para 9 classes.
  - P5 e P6: preencher o grau baixo de `desnivel` (6 mm) e de `desconfinamento` (6 a 13 mm, faixa de 0,3 a 0,6 m).
  - P7 e P8: ampliar a definição de `peca_quebrada` para peça danificada; manter `peca_faltante` com origem ASTM.
  - P9 a P11: trilha de roda como tag de `afundamento`; elevação fora da v1 (não se distingue em 2D, reavaliar com LiDAR na fase 6); fluência horizontal como grandeza derivada da grade na fase 4.
  - P12: manter `vegetacao` como classe própria do projeto.
  - Motivo geral: alinhar nomes e limites à norma facilita a aceitação pelos revisores (Passo 1 de `docs/fases/fase-0-preparacao.md`).
- **Hipótese (não testada):** a fluência horizontal pode ser medida pelo desvio do alinhamento das juntas na grade de peças. Candidata a contribuição do artigo; depende da fase 4.
- **Lacunas:** sem o Apêndice X1 não há graus oficiais nem curvas de dedução, portanto o PCI não pode ser calculado. As duas fontes tratam só de intertravado de concreto (ASTM C936); para o paralelepípedo nenhuma dá limites, e os graus seguem a calibrar com a vistoria da fase 1.
- **Impacto no artigo:** seção 2 (revisão: ASTM E2840 e manual ABCP); seção 3.4 (classes e severidade, com a origem de cada limite); seção 5 (limitações: limites de fonte secundária, ausência de referência para paralelepípedo, PCI sem verificação de precisão para intertravado, o que também motiva a medição automática e a dupla avaliação da fase 1).
- Atualização 2026-10-20: propostas decididas, ver entrada de 2026-10-20.

### 2026-10-19 · Fase 0 · Esquema do banco testado com RLS

- **O que aconteceu:** a migração `supabase/migrations/0001_esquema_inicial.sql` foi aplicada num PostgreSQL 16 local com PostGIS 3, usando uma simulação mínima do ambiente Supabase (`supabase/tests/simulacao_supabase.sql`).
- **Números (com fonte):** as 8 consultas de `supabase/verificar_seguranca.sql` voltaram vazias; os 12 testes de `supabase/tests/teste_rls.sql` deram o resultado esperado (membro vê só a própria obra, leitor não revisa, ninguém apaga, anon não lê).
- **Decisão e motivo:** o painel nunca recebe permissão de alterar defeitos; a revisão do engenheiro entra numa tabela própria e um gatilho a aplica. Isso preserva o registro de quem revisou o quê, útil como trilha de auditoria.
- **Impacto no artigo:** seção 4.4 (aplicação em obra) e disponibilidade de dados.

### 2026-10-19 · Fase 0 · Início do projeto e decisões de método

- **O que aconteceu:** repositório criado com o roteiro em 8 fases, documentos por fase, orquestrador e subagentes.
- **Decisões e motivos:**
  - **Pavimentos estudados:** intertravado e paralelepípedo, por não haver dataset público nem método de medição para eles, e por concentrarem o passivo das obras de saneamento acompanhadas.
  - **Referência metodológica:** Freitas, Nobre Júnior e Espindola (2024). O projeto repete a comparação de técnicas de coleta e acrescenta medição e severidade.
  - **Máscaras em vez de caixas:** a medida pela caixa delimitadora erra cerca de 26% em comprimento e largura em estudo anterior (Dhanya Kumar et al., 2025).
  - **Divisão por rua:** quadros da mesma rua são quase iguais; a divisão aleatória por imagem, usada no artigo de referência, tende a inflar a métrica.
  - **Grade de peças como régua:** contribuição metodológica central; a NBR 9781 tolera até 3 mm no comprimento e na largura do bloco, pouco mais de 1% num bloco de 220 mm.
  - **Ajuste fino:** todos os modelos partem de pesos pré-treinados; a inicialização será declarada no artigo.
- **Impacto no artigo:** introdução, revisão e seção 3.
