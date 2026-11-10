---
name: revisar-carteira
description: >
  Visão de portfólio sobre os casos do escritório no acervo: lista, tria por
  prazo próximo, caso parado e tese em conflito, e só então abre o briefing dos
  3 a 5 que realmente pedem atenção. Acione quando a pergunta for sobre o
  conjunto, não sobre um caso — "como está minha carteira?", "o que precisa de
  mim essa semana?", "algum caso parado?", "quais prazos estão vencendo?", "me dá
  um panorama dos casos do cliente X", "onde eu devo colocar o tempo hoje?",
  "tem alguma bomba pra estourar?". Entrega uma fila priorizada com o motivo de
  cada prioridade. Exige conta do escritório conectada. Para um caso específico
  use acompanhar-caso; para cadastrar caso novo use abrir-caso; para levantar
  direito sem caso use levantar-fundamentos.
---

# Revisar a carteira

Objetivo: dizer ao advogado **onde ele precisa colocar o tempo**, com motivo — e
não devolver um inventário de tudo que ele já sabe que tem.

Leia `references/areas-e-roteamento.md`: as três áreas, a
ordem 0→1→3 (o eixo do foro está em pausa — ver
`references/foro-em-pausa.md`), a matriz e o significado
das células.

## Antes de tudo: as tools estão na sessão?

Esta skill só existe com o acervo. `NAO_AUTENTICADO` → diga em uma linha que a
conta do escritório não está conectada, repasse a `acao_sugerida` da tool, e
ofereça o que dá para fazer sem ela (levantar amparo de uma tese específica com
`levantar-fundamentos`). **Nunca invente uma carteira**, nem estime números.
Também não apresente isso como erro genérico: o plugin segue funcional para
pesquisa jurídica.

## A regra dura desta skill: triar antes de aprofundar

`caso_obter_briefing` é caro — em tempo, em contexto e em dinheiro. Um escritório
com 40 casos ativos **não** cabe em 40 briefings: você estoura o contexto, perde
o começo da conversa, e entrega um relatório que ninguém lê.

**Trie pela lista. Aprofunde em 3 a 5.**

Se o usuário insistir em cobrir tudo, explique o custo e proponha o corte: por
cliente, por fase, por responsável, por semana. Cobertura total de carteira é
trabalho da UI do produto (o Radar), não de uma conversa.

## Roteiro

### 1. Puxe a lista, já filtrada

`escritorio_listar_casos`. Use os filtros para trazer o que interessa, não tudo:

- `apenas_meus: true` — padrão quando o usuário diz "minha carteira", "o que
  precisa de mim". Só amplie se ele pedir a visão do escritório;
- `com_prazo_ate` — quando a pergunta tem horizonte ("essa semana", "este mês"),
  traduza para data e filtre. É o filtro mais barato e mais útil que existe aqui;
- `status` / `fase` — para recortes do tipo "os que estão em instrução".

Pagine com `cursor` se precisar, mas prefira apertar o filtro a varrer páginas.
Leia a `cobertura` da resposta e repasse: lista vazia com
`"sem registros no período"` é resposta, não silêncio.

Cada item traz `titulo`, `numero_cnj`, `cliente`, `fase`, `status`,
`ultima_atualizacao_efetiva_em` e `proximo_prazo`. **É com isso que você tria** —
sem abrir nada.

### 2. Trie por três sinais

**a) Prazo próximo** — `proximo_prazo` dentro do horizonte. É o sinal
inegociável: prazo perdido não se recupera com boa estratégia. Ordene por data,
o mais próximo primeiro, e destaque o que vence em até 5 dias.

**b) Caso parado** — `ultima_atualizacao_efetiva_em` antiga. Atenção à leitura
correta: "sem atualização efetiva" não é "sem ninguém olhando" — é **o processo
que não andou**. Um caso ativo, em fase de conhecimento, sem movimento material
há 60 dias, é uma pergunta a fazer ao tribunal ou ao cliente, não um caso
saudável. Calibre o limiar pela `fase`: execução se arrasta por natureza,
instrução não.

**c) Tese em conflito** — chame `caso_listar_teses` nos casos que os sinais (a) e
(b) já apontaram, e procure célula `conflito` (amparo forte × juiz refuta). Com
o eixo do foro em pausa (ver `references/foro-em-pausa.md`), toda tese nova sai
`sem_cobertura` — `conflito` só aparece em tese registrada antes da pausa. Vale
olhar `amparo_solido_juizo_aberto` em caso com prazo: é o achado mais valioso
hoje — amparo forte com juízo em aberto — e o que muda de patamar quando o
eixo religar.

Não passe `caso_listar_teses` em toda a carteira. Rode nos candidatos que a
triagem por prazo e por parada já selecionou.

**d) Atualização do tribunal não tratada** — `monitoramento.nao_processados_automacao > 0`
nas linhas com `monitoramento.ativo`. É o que o **robô de tribunal** trouxe e
ninguém do escritório leu: decisão, intimação, peça da contrária esperando. Entra
na triagem com o peso de "novidade material possível" — e o tratamento não é
aqui: ofereça `processar-atualizacoes` (trata a fila toda) ou `acompanhar-caso`
(um caso). Se a linha `cobertura` disser que há casos do TJSP **sem**
monitoramento, anote para o fechamento: ofereça ligar nos casos que o usuário
acompanha (`caso_ativar_monitoramento`), um a um, nunca em lote sem ele pedir.

### 3. Escolha de 3 a 5 e aprofunde

Para os selecionados — e só para eles — `caso_obter_briefing`.

Leia `onde_estamos`, `ameacas`, `pendencias` e `nao_sabemos`, e respeite
`instrucoes_ativas`: se o caso tem instrução ativa, ela condiciona a
recomendação que você vai dar sobre ele. Não recomende o que o escritório já
decidiu não fazer.

Se algum caso pedir análise de verdade (novidade material, tese a reavaliar),
**não faça aqui**: aponte e ofereça mudar para `acompanhar-caso`. Esta skill
prioriza; aquela investiga.

### 4. Amparo — com parcimônia (foro em pausa)

Nesta skill, o amparo entra **pontualmente**, quando a triagem levanta uma
dúvida concreta que muda a prioridade: um precedente que pode ter sido superado
e derruba a tese-âncora de um caso com prazo, por exemplo. Aí sim,
`buscar_qualificada` com `status_vigencia` conferido — e, citando o precedente
na fila, com o link que veio no resultado, clicável (nunca montado de memória).

Não rode levantamento completo de amparo para a carteira inteira. Se três casos
pedem levantamento, a resposta é "esses três precisam de uma sessão cada", não
uma sessão que tenta ser três.

### 5. Grave o que a revisão produziu

Prioridade não é achado — não grave "esse caso é urgente" como memória. Mas
grave o que **é** achado:

- decisão que o usuário tomou revisando a carteira ("vamos priorizar o agravo do
  caso X e pedir dilação no Y") → `caso_gravar_memoria` tipo `decisao`, no caso
  certo;
- orientação que passa a valer → `caso_gravar_memoria` tipo `instrucao`, com
  `escopo: "escritorio"` se vale para todos;
- a dúvida que a triagem levantou e a conversa não resolveu ("esse caso parado há
  90 dias pode estar suspenso por prejudicial externa e ninguém conferiu") →
  `caso_gravar_memoria` tipo `hipotese`, `desfecho: "aberta"`, **no caso certo**.
  É o achado mais típico desta skill e o que mais se perde: a triagem vê o
  sintoma, e quem abrir o caso depois merece encontrar a suspeita já escrita;
- prazo que apareceu na conversa e não está no acervo →
  `caso_registrar_prazo`.

Grave **no caso a que a coisa pertence**, não num caso qualquer da lista — numa
revisão de carteira é fácil errar o destino, e memória no caso errado é pior que
memória nenhuma. Errou? `caso_atualizar_memoria` corrige o registro; não escreva
outro no lugar certo deixando o errado de pé.

O que você gravar **está valendo** assim que a tool retorna. Diga o que gravou e
em que caso, item a item.

### 6. Entregue uma fila, não um inventário

(E, se o escritório tem casos monitorados e o usuário ainda não tem a rotina:
**crie** a tarefa agendada — dias úteis, de manhã — que roda
`processar-atualizacoes`, com a ferramenta de tarefas agendadas do ambiente, e
deixe o **card** dela ser o convite: horário e prompt à vista, e o advogado
aprova, muda a hora ou apaga num clique. É o que transforma a leitura do tribunal
em análise sem ninguém abrir a máquina, e é de onde sai o e-mail da equipe. Diga
em uma linha o que criou e como desligar; não crie a segunda nem crie contra um
"agora não".)

1. **A linha de cima** — quantos casos na carteira, quantos com prazo no
   horizonte, quantos parados, quantos com tese em conflito. Quatro números.
2. **Precisa de você agora** — de 3 a 5 casos, em ordem de urgência. Para cada
   um: caso e cliente, **por que está aqui** (prazo em X dias / parado há Y dias
   / tese em conflito), o que o briefing diz que está em jogo, e **a ação
   concreta** sugerida.
3. **De olho** — em uma linha por caso, os que não entraram no top mas têm sinal
   (prazo no mês seguinte, parada começando).
4. **O resto** — um número e uma frase. Não liste 32 casos sem sinal.
5. **O que não deu para ver** — o que a `cobertura` disse que faltou, casos com
   cadastro incompleto, prazos sem data.

E a **linha de fechamento** quando houver gravação: o que você gravou, em que
caso, e o convite à correção.

> "Gravei: a decisão de priorizar o agravo no caso Pimenta Verde, e 1 hipótese
> aberta no caso Aurora (parada pode ser suspensão por prejudicial). Me diga se
> algo ficou errado que eu corrijo."

## Critério de parada

Pare quando a fila priorizada estiver entregue com motivo por item. Não abra mais
briefings para "conferir" — se a triagem não apontou o caso, ele não está na
fila desta semana, e dizer isso é parte da resposta.

## Erros a não cometer

- **Abrir o briefing de todos os casos.** É o erro que quebra esta skill: estoura
  contexto, custa caro e produz relatório ilegível.
- Devolver a lista crua do `escritorio_listar_casos` como se fosse análise.
- Tratar `ultima_atualizacao_efetiva_em` antiga como negligência do advogado sem
  olhar a `fase`.
- Ignorar `instrucoes_ativas` e recomendar o que o escritório já descartou.
- Priorizar por "valor da causa" ou por vibe em vez de prazo, parada e conflito.
- Contar caso com cadastro incompleto junto com o resto sem dizer que está
  incompleto (`pendencias_cadastro_alto` diz quais).
- Fazer a análise profunda aqui em vez de apontar e mudar para
  `acompanhar-caso`.
- **Gravar memória no caso errado** — e, percebendo o erro, escrever no caso
  certo deixando a errada de pé em vez de corrigir com
  `caso_atualizar_memoria`.
- Deixar morrer a suspeita que a triagem levantou em vez de gravá-la como
  hipótese no caso a que ela pertence.
