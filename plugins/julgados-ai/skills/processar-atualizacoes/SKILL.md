---
name: processar-atualizacoes
description: >-
  ANALISA as atualizações que o robô de tribunal trouxe depois da primeira
  leitura e que ninguém do escritório tratou: o monitoramento registra as
  movimentações e baixa as peças novas, mas NÃO as interpreta — quem analisa é
  você. Acha os casos com atualização não tratada, lê as peças novas, classifica
  (material? marco? prazo? muda tese?), levanta amparo no que for material,
  popula o caso (fatos, marcos, prazos, teses, memória) e marca como processado
  com a nota que vira o e-mail para a equipe do caso.
  Acione quando uma resposta do acervo trouxer `novidades_do_tribunal`, ou quando
  o usuário disser "processa o que chegou do tribunal", "o que o robô trouxe
  hoje?", "tem atualização nos processos monitorados?", "roda a rotina das
  atualizações" — e é o prompt da TAREFA AGENDADA diária que roda sem ninguém
  abrir a máquina.
  Exige conta do escritório conectada com escrita. Para UM caso que o usuário já
  nomeou, use acompanhar-caso; para a visão da carteira, revisar-carteira.
---

# Processar as atualizações do tribunal

Objetivo: o que o **robô** leu no e-SAJ vira **análise** no acervo — e o advogado
recebe, por e-mail, só o que foi de fato tratado, com a conclusão de quem tratou.

Leia `references/areas-e-roteamento.md` (as três áreas, a
matriz, a mecânica de novidade e o monitoramento). O eixo do foro está em pausa
— ver `references/foro-em-pausa.md`.

## Quem analisa o quê: a primeira leitura é da plataforma, o resto é seu

O monitoramento entra no tribunal com o certificado digital do escritório, lê as
movimentações de cada caso ligado, baixa as peças novas e grava cada movimentação
como **fato de origem automação** (selo "tribunal"). Daí em diante há dois
regimes, e eles não se misturam:

1. **Primeira leitura do caso — a plataforma analisa sozinha.** Quando o caso é
   cadastrado, o robô traz o HISTÓRICO inteiro do processo. Um modelo lê cada
   peça e outro analisa o histórico; o resultado fica como `analise_sugerida`
   nos fatos, prazos detectados entram em `prazos_sugeridos`, e os fatos do
   histórico já saem **marcados como processados** pela análise automática (sem
   e-mail). Enquanto isso corre, o briefing diz "primeira leitura em andamento"
   — não trate esse histórico como novidade.
2. **Toda atualização depois disso — você analisa.** Movimentação nova chega
   **sem análise nenhuma**: peça baixada, texto extraído, e só. Ela entra na fila
   de tratamento de **todo o escritório** (`processado_em` vazio) e aparece em
   `novidades_do_tribunal` na resposta de qualquer tool do acervo. Analisar é o
   seu trabalho; ninguém fez antes.

O que sobra da primeira leitura para você são os **prazos sugeridos** (ainda
sem decisão — decida-os quando tratar o caso, passo 6) e as **teses e itens de
memória sugeridos** (`teses_sugeridas` em `caso_listar_teses`, `itens_sugeridos`
em `caso_obter_memoria` — decida-os no passo 7). Se, por exceção, um fato novo
vier com `analise_sugerida` (backfill manual), **audite-a** em vez de refazer:
confira as âncoras, confirme, corrija ou derrube.

## A regra da auditoria

**Âncora é o que separa conferir de acreditar.** Toda afirmação do robô que
importa vem com um `ancora_trecho`: 6 a 15 palavras copiadas literalmente da
peça. `ancoras_conferidas: "4/4"` quer dizer que a plataforma achou os quatro
trechos no texto — isso prova que ele não inventou a citação, **não** que ele
entendeu certo. Quem confere o sentido é você.

Três erros que a âncora não pega, e que você tem que pegar:

- **prazo da parte contrária vendido como nosso** — a intimação existe, o trecho
  existe, mas o destinatário é o outro lado;
- **dias corridos onde eram úteis** — a data cai errada por causa de feriado
  local; o robô é instruído a avisar quando estimou, e costuma avisar;
- **direção invertida em caso com mais de um cliente** — confira quem está
  marcado como nosso cliente antes de aceitar "favorável".

Discordou? **A sua leitura vale.** Grave a sua e diga na nota que divergiu do
robô — a divergência é o que faz o modelo melhorar na próxima versão.

**O e-mail para a equipe do caso sai quando você chama `caso_marcar_processado`
sobre fatos do tribunal — e o corpo do e-mail é a sua `nota_lote`, com a nota de
cada andamento na lista.** Nota vaga ("tratado", "ok", "andamento") = e-mail
inútil chegando na caixa de um advogado. A `nota_lote` diz o que veio, o que
significa para o caso e o que fazer; a nota de cada item diz o que AQUELE
andamento é. Uma ou duas linhas densas cada.

## Esta skill pode rodar sozinha — por isso é mais rígida

Como rotina agendada ninguém está olhando. Então:

- **Nunca invente.** Se as tools do acervo responderem `NAO_AUTENTICADO`, PARE e
  diga, em uma linha, que o conector do Julgados.ai não está autorizado neste
  ambiente (a tarefa agendada precisa dele). Não há fallback.
- **`SOMENTE_LEITURA`**: você consegue ler e reportar, mas não consegue gravar
  nem marcar processado — diga isso no relatório; o e-mail não sairá.
- **Erro de aprovação numa chamada de escrita (`No approval received` e
  afins) não é `SOMENTE_LEITURA` nem recusa — é o cartão de permissão
  expirando sem ninguém para responder, porque a rotina roda sem humano na
  frente.** Não trate como se tivesse gravado: registre no relatório final,
  explicitamente, o que **não** ficou gravado por falta de aprovação (o
  `caso_marcar_processado`/`caso_registrar_tese`/etc. que falhou) — o
  e-mail daquele caso não sairá, e o fato continua na fila para a próxima
  execução.
- **Não marque lido** (`caso_marcar_lido`): a rotina não é o advogado. Leitura
  é pessoal; o que você faz aqui é **tratamento**, que é do caso.
- **Não regrave briefing** por movimentação burocrática. Regrave só se entrou
  decisão/sentença/acórdão/saneamento — e diga que regravou.
- **Marque processado só o que você tratou de verdade.** Se não conseguiu abrir
  uma peça (texto vazio, PDF digitalizado), registre isso na nota e marque mesmo
  assim — o escritório precisa saber que chegou algo que exige olho humano — ou
  deixe sem marcar e diga no relatório. Não finja que leu.

## "Chegou hoje?" é `capturado_em`, nunca `ocorrido_em`

Duas perguntas parecem a mesma e não são. **"O que está pendente?"** é a fila —
`apenas_nao_processados: true`, sem olhar data nenhuma. **"O que chegou
hoje?"/"teve atualização hoje?"** é sobre CAPTURA — o robô pode ler o e-SAJ às
09h de hoje e trazer uma movimentação **datada de ontem** (`ocorrido_em`
ontem, `capturado_em` hoje): o processo já continha aquele andamento, o robô só
chegou nele agora. Responder "chegou hoje" olhando `ocorrido_em` erra — e erra
justamente nos casos em que o robô demorou a alcançar o andamento.

Para "o que chegou hoje/desde X", use `caso_listar_linha_tempo` com
`capturado_desde` (não `desde`, que filtra por `ocorrido_em`). E **diga o que
foi capturado mesmo que já esteja processado** — a primeira leitura marca como
processado sozinha (sem e-mail), então um fato pode ter chegado hoje e já estar
tratado; cite o `processado_nota` (`caso_obter_fato` traz o teor) em vez de
tratar "já processado" como "não chegou nada". Fila (não tratado) e captura
(chegou agora) são eixos diferentes; um fato pode estar em só um dos dois, nos
dois, ou em nenhum.

## Roteiro

### 1. Há fila?

Se você chegou aqui por `novidades_do_tribunal` (veio pendurado na resposta de
alguma tool), a lista de casos já está nele — vá ao passo 2 com ela. Senão,
`escritorio_status_monitoramento`. Leia a `cobertura`:

- `certificado.estado` ≠ ativo/expirando → o robô não está lendo nada. Diga ao
  usuário em uma linha que o **administrador** precisa resolver em Configurações
  → Certificado digital, e pare. Não há o que processar.
- `casos_com_atualizacao_nao_processada = 0` → "nada novo do tribunal desde a
  última rodada". Diga isso, cite a `ultima_rodada`, e pare. Não varra casos
  "para conferir".
- Havendo fila, siga.

### 2. Quais casos

`escritorio_listar_casos` (sem `apenas_meus` — a fila é do escritório; se o
usuário pediu "os meus", com `apenas_meus:true`). Filtre as linhas com
`monitoramento.nao_processados_automacao > 0`. Ordene pelos que têm mais.
**Limite:** trate até 5 casos por execução; mais que isso, liste os que ficaram
e diga que ficam para a próxima.

### 3. Por caso: situe-se antes de ler

`caso_obter_briefing`. Leia `instrucoes_ativas` (são restrições ao seu
trabalho), `decisoes`, as hipóteses abertas e `nao_sabemos`. É contra isso que
você vai ler a novidade.

### 4. Leia o que chegou

`caso_listar_linha_tempo` com `apenas_nao_processados: true` (o filtro de
relevância já vem em `"materiais"`; o expediente que ficou de fora volta
resumido por período em `expediente_resumo`, e costuma bastar assim — se
precisar de um dele, abra pelo `id` com `caso_obter_fato`).

**Gatilho de prazo é o dies a quo — confira o prazo a partir dele.** Os fatos
com `relevancia: "gatilho"` (certidão de publicação, publicação no diário,
intimação ou citação certificada, AR juntado, ciência, "decorrido prazo") não
têm peça a ler: o que vale neles é a DATA. É neles que o prazo começa, não na
decisão que eles comunicam — ancore o prazo no gatilho e diga qual decisão ele
comunica. Decisão sem gatilho correspondente ainda não começou a correr.
Separe os fatos de **origem automação** — são os do tribunal. Depois da primeira
leitura eles chegam **sem** `analise_sugerida`: a análise é sua, do zero. Se
algum trouxer `analise_sugerida`, use como ponto de partida e audite.

Para cada fato material com documento anexado (`tipo: documento`,
`origem_detalhe.documento_ids` / `pecas`), abra com `caso_obter_documento`:
primeiro `secao: "resumo"`; se vier "sem resumo" (o robô grava o título da
movimentação, não o conteúdo — **a plataforma não resume peça**), o **texto
integral**, paginado (`pagina_de`/`pagina_ate`, ≤10 páginas por chamada), para
decisão, sentença, acórdão, despacho que decide algo, laudo, ou petição da
contrária. Certidão de cartório, ato ordinatório, juntada: o título e a
descrição da movimentação costumam bastar.

O que volta daí é texto extraído, para você ler — não é o arquivo dos autos. Se
o advogado pedir a peça em si, é `caso_baixar_documento`, que devolve a
`url_download` do original para você baixar e entregar. Não monte um PDF com a
transcrição e o chame de documento do processo.

#### A peça que NÃO veio — diga, e diga por quê

Cada fato traz `peca`. Quando `peca.esperada` é `true` e `peca.status` não é
`baixada`, **existe peça naquele andamento e o acervo não a tem**. Não conclua o
sentido do andamento pelo título nesse caso ("Petição Juntada" pode ser a
contestação): diga ao advogado que a peça não veio e o motivo (`peca.rotulo` já
vem em português).

O que decide a SUA frase é `peca.na_fila`:

- **`na_fila: true`** — o robô vai tentar de novo sozinho, com intervalo
  crescente. Avise e siga; não peça nada ao advogado. ("A contestação de 19/08
  ainda não desceu — a pasta digital do e-SAJ estava fora do ar; o robô tenta de
  novo nos próximos dias.")
- **`na_fila: false`** com status não-baixada — acabou a tentativa automática, e
  só o humano resolve. Diga o que resolve, que depende do motivo:
  `gate_intimacao` (alguém do escritório precisa **receber a intimação** — o robô
  nunca abre, porque abrir conta como receber e dispara o prazo),
  `allowlist` (ato judicial: abra pelo e-SAJ),
  `restrito` (segredo de justiça),
  `autos_digitalizados` (está dentro de um volume dos autos físicos digitalizados).
- **`status: 'desconhecido'`** — fato antigo, anterior ao registro do motivo.
  Diga **"não sei se havia peça"**, nunca "não havia".

**Nunca prometa a peça.** Se ela não está no acervo, você não pode entregá-la
nem resumi-la — e afirmar que o andamento "não tinha documento" quando `peca`
diz o contrário é o erro que esta informação existe para evitar.

`peca.status: 'ilegivel'` é outra coisa: a peça ESTÁ no acervo, mas o PDF não tem
camada de texto. `caso_obter_documento` devolve vazio e o arquivo existe —
ofereça `caso_baixar_documento` para o advogado abrir.

**Grave a sua leitura da peça.** Peça de atualização chega "sem resumo": depois
de ler, chame `caso_atualizar_documento` com `resumo_linha` (uma linha que diz o
que a peça decide ou pede), `tipo` e o `dispositivo` literal quando houver — é
o que todo mundo do escritório vai ler depois, e sem isso a próxima pessoa relê
a peça inteira. (Peça do histórico já vem com leitura do modelo: só reescreva se
discordar.)

### 5. Analise e popule o caso

Para cada fato do tribunal, decida — e GRAVE o que decidiu; análise que fica só
na conversa não existe para o escritório:

| Pergunta | Se sim |
|---|---|
| É **material** (decide, intima para ato, abre prazo, junta prova/peça da contrária)? | levante o amparo do que for preciso (`buscar_qualificada`, `obter_dispositivo_legal`…); eixo do foro em pausa, não chame `resolver_juiz`/`analisar_jurisprudencia` |
| É **marco** (sentença, acórdão, decisão de mérito, saneamento, acordo, trânsito)? | `caso_atualizar_fato` com `eh_marco: true` e um `resumo` que diga o que foi decidido — o marco só existe depois desta chamada |
| **Abre prazo** (intimação para ato, recurso, manifestação)? | `caso_registrar_prazo` com `fundamento` (a peça e o dispositivo) e `vence_em` — `fatal` se a data é certa; `monitoramento` se depende de publicação ou contagem que você não fechou. Diga a contagem que usou |
| Há **prazo sugerido** pendente da primeira leitura? | vá ao passo 6, um a um |
| Muda uma **tese** (acolhida, refutada)? | `caso_atualizar_tese` com motivo |
| Confirma ou derruba uma **hipótese** aberta? | `caso_fechar_hipotese` |
| Só muda o contexto do caso (perícia designada, novo advogado da contrária)? | `caso_gravar_memoria` tipo contexto |
| Traz fato que o título da movimentação não conta (valor bloqueado, data de audiência, parte nova)? | `caso_atualizar_fato` no próprio fato do tribunal, com `resumo` — não crie fato duplicado |

O que é **burocrático** (juntada de AR, certidão de publicação, vista) não
precisa de amparo, não é marco, não regrava briefing — só a nota.

### 6. Decida os prazos sugeridos (da primeira leitura) — um a um, nunca em lote

`caso_listar_prazos` com o `caso_id`. A resposta tem **duas listas**:
`prazos` é a agenda de verdade; `prazos_sugeridos` é o que o robô detectou e
ninguém confirmou.

Para cada sugestão, na ordem:

1. leia o `fundamento` — a **âncora** está lá, entre aspas;
2. abra a peça (`caso_obter_documento`) e ache o trecho. Não achou? **descarte**;
3. achado, pergunte três coisas: o prazo é **nosso** (veja `de_quem`)? a
   contagem bate (úteis × corridos, termo inicial na publicação)? a data cai em
   dia útil?
4. `caso_decidir_prazo_sugerido`:
   - **confirmar** — vira agenda do escritório e entra no radar. Se só a data
     estiver errada, passe `vence_em` corrigido **junto**: não descarte para
     recriar;
   - **descartar** — some da fila, com o motivo no histórico.

`motivo` é obrigatório e não é formalidade: é o que responde "por que este prazo
está na agenda?" daqui a seis meses. Escreva o que você conferiu —
*"âncora bate com o dispositivo de 07/08; 15 dias úteis da publicação levam a
22/09, não 10/09"* —, não *"ok"*.

**Nunca confirme uma leva de prazos sem abrir as peças.** Prazo é o campo em que
o falso positivo custa uma tarde e o falso negativo custa o caso.

### 7. Decida as teses e itens de memória sugeridos (da primeira leitura)

`caso_listar_teses` devolve `teses_sugeridas`; `caso_obter_memoria` devolve
`itens_sugeridos` (decisão, contexto ou hipótese) — o que a leitura automática
da primeira leitura propôs e ninguém do escritório confirmou nem descartou.
Cada sugestão vem com `ancora_trecho` (o trecho literal do dossiê que a
sustenta) e, nas teses, `por_que` (o raciocínio).

Para cada sugestão, na ordem:

1. leia `por_que`/`ancora_trecho` e ache o trecho na peça
   (`caso_listar_linha_tempo`/`caso_obter_documento`). Não achou, ou o trecho
   sustenta outra coisa? **descarte**;
2. achado, confira o enunciado (tese) ou o título/corpo (memória) contra o que
   a peça diz de verdade;
3. decida:
   - **tese** — `caso_decidir_tese_sugerida`: `confirmar` (aceita `mudancas`
     com `enunciado`/`amparo`/`polo` corrigidos **na mesma chamada**, se a
     leitura entendeu torto) ou `descartar`;
   - **memória** — `caso_decidir_memoria_sugerida`: `confirmar` (aceita
     `mudancas` com `titulo`/`corpo` corrigidos) ou `descartar`. Confirmar uma
     hipótese sugerida **não** a fecha nem cria tese — ela entra como hipótese
     aberta comum, a fechar depois com `caso_fechar_hipotese` quando a
     resposta chegar, e a promover a tese só com o amparo levantado, via
     `caso_registrar_tese`.

`motivo` é obrigatório nos dois caminhos e fica no histórico: escreva o que
você conferiu — *"a âncora bate com a contestação de fls. 40; ajustei o
enunciado para citar o artigo certo"* —, não *"ok"*.

**Nunca recadastre uma sugestão com `caso_registrar_tese`/`caso_gravar_memoria`
em vez de decidi-la** — isso duplica a linha e perde a âncora e o raciocínio
original.

### 8. Marque processado — uma nota POR ANDAMENTO, e a do lote no e-mail

Uma chamada por caso, com o `caso_titulo` (o `titulo` de
`novidades_do_tribunal`, ou de `caso_resolver`/`caso_obter_briefing` se você
abriu o caso — o servidor confere contra o `caso_id`) e **`itens`: um por fato
do tribunal que você tratou, cada um com a SUA nota**.

```
caso_marcar_processado({
  caso_titulo: "…", caso_id: "…",
  itens: [
    { fato_id: "…", nota: "Decisão de 06/04 (fls. 256) indeferiu a impugnação ao cumprimento e fixou honorários em 10% — é daqui que sai o prazo de agravo." },
    { fato_id: "…", nota: "Publicação de 08/04 da decisão acima: é ela que conta o prazo. Corrigi a sugestão do robô para 29/04 (15 dias úteis)." },
    { fato_id: "…", nota: "Ato ordinatório de 14/04 expediu MLE — cumprimento do que a decisão já mandara, nada a fazer." },
    { fato_id: "…", nota: "Certidão de 19/08: decurso de prazo da parte contrária, sem efeito para nós." }
  ],
  nota_lote: "Impugnação indeferida com honorários de 10%; agravo até 29/04. Descartei a segunda sugestão de prazo (a intimação era da parte contrária). Tese da prescrição intercorrente segue em conflito — o juízo refutou; amparo forte no STJ."
})
```

**Por que uma nota por andamento.** A nota fica NAQUELE fato e é o que o
advogado lê ao chegar naquele ponto da linha do tempo. A mesma frase carimbada
em dez andamentos diferentes é lida como defeito do sistema: ele rola a tela e
vê "tratado: a sentença julgou extinto…" embaixo de uma certidão de decurso que
não tem nada com isso. Escreva o que **aquele** ato significa.

**`nota_lote` é a leitura do conjunto** — o que mudou no caso e o que fazer. É
ela que abre o e-mail da equipe, e ela **não** é repetida cartão a cartão. Um
e-mail por chamada, como sempre.

Trate o **expediente** também: certidão, juntada e ato ordinatório entram nos
mesmos `itens`. Expediente repetitivo pode dividir uma frase quase igual — mas
diga em cada um o que aquele ato era ("certidão de decurso do prazo da ré",
"juntada da guia de custas"), nunca o mesmo texto genérico em todos. Fato do
tribunal esquecido fica na fila e volta em `novidades_do_tribunal` em toda
conversa.

Se a resposta vier com `notas_distintas: 1` e vários `processados`, o lote
inteiro ficou com uma nota só — é o sinal de que você mandou `fato_ids` (o
formato antigo, ainda aceito) em vez de `itens`.

É isso que a equipe do caso vai ler na caixa de entrada. Escreva para ela.

### 9. Briefing

Se entrou decisão/sentença/acórdão/saneamento e o briefing veio `desatualizado`,
`caso_regravar_briefing` com o `caso_titulo` (o `titulo` de
`novidades_do_tribunal`, ou de `caso_resolver`/`caso_obter_briefing`) e
`motivo`. Caso contrário, não.

### 10. Relatório

No fim, um bloco por caso — **o que veio / o que significa / o que fazer** — e
uma linha com o que você gravou (prazos confirmados e descartados, teses,
memória, marcos) e o que **não** conseguiu (peça sem texto, `SOMENTE_LEITURA`,
escrita que falhou por erro de aprovação — nomeie qual chamada e qual caso).
Diga também **onde você discordou do robô**: é a informação que ninguém mais
tem, e é dela que sai a próxima versão do modelo. Casos que ficaram para a
próxima execução, listados.

Precedente, súmula ou norma do amparo citado no relatório vai **com o link que
veio no resultado**, clicável — mesmo que o mesmo link já esteja nas `fontes` da
tese gravada. Nunca URL montada de memória; resultado sem link, cite sem link.

## Critério de parada

Parou quando: cada caso com atualização do tribunal foi tratado ou explicitamente
adiado; **nenhum prazo, tese ou item de memória sugerido ficou sem decisão** nos
casos que você tratou; tudo que você gravou está no relatório; nenhum
`caso_marcar_lido` foi chamado; nenhuma afirmação jurídica saiu sem fonte do
amparo.

## Erros a não cometer

- **Deixar a análise só no relatório.** Se não virou marco, prazo, tese,
  memória ou resumo de documento no acervo, o escritório não sabe dela.
- **Repetir a análise do robô como se fosse sua** (quando houver uma). Copiá-la
  sem abrir a peça é assinar embaixo do palpite de outro.
- **Confirmar prazo, tese ou item de memória sem achar a âncora na peça.** É o
  erro mais caro do repertório: registra como conferido algo que ninguém
  verificou.
- **Recadastrar sugestão da leitura automática com `caso_registrar_tese`/
  `caso_gravar_memoria`** em vez de decidi-la com
  `caso_decidir_tese_sugerida`/`caso_decidir_memoria_sugerida` — duplica a
  linha e perde a âncora.
- Processar sem ter lido a peça quando a peça é o que importa (decisão sem abrir
  o texto integral = nota inventada).
- **Tratar `peca.esperada` sem peça como "andamento sem documento".** É o
  contrário: o acervo está devendo, e quem lê a sua nota depois vai achar que
  aquele andamento não tinha nada. Diga que falta, e por quê.
- Nota de uma palavra. É o e-mail.
- Marcar lido. Não é seu.
- Regravar briefing por certidão.
- Inventar o histórico quando o conector não responde.
- **Seguir como se tivesse gravado quando a escrita falhou por erro de
  aprovação.** Diga no relatório o que não ficou registrado, e por quê.
- Abrir 40 casos. Cinco por vez, e diga o que ficou.
