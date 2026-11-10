---
name: abrir-caso
description: >-
  Abre no acervo do escritório um caso que ainda não existe lá — a porta de
  entrada pelo PROCESSO: número CNJ, uma inicial ou contrato colado, ou só a
  narrativa do cliente. Confere se já existe (não duplica), confirma o que
  extraiu, cria o caso e fecha as pendências de peso alto — de quem é e quem
  defendemos; monitorado, o resto a leitura traz sozinha. O cadastro é a
  entrega: fechado ele, avisa que o caso foi cadastrado e que o monitoramento
  do tribunal JÁ ESTÁ LIGADO (a leitura pode levar minutos), cria a rotina
  diária das atualizações e PARA para perguntar o que o advogado quer em
  seguida. Se pedido, entrevista para fechar a posição do caso no briefing:
  decide tese/memória sugeridas pela leitura automática e pergunta decisões,
  pendências, ameaças e lacunas. Conversa de um caso só. Acione em "quero
  cadastrar um caso novo", "cadastra esse processo pra mim", "abre um caso com
  essa inicial", "esse caso já está no sistema?". Caso que já existe,
  acompanhar-caso; pelo cliente e pelo contrato, abrir-cliente.
---

# Abrir o caso no acervo

Objetivo: transformar o que chegou — um número, uma inicial, um contrato, ou só a
história que o cliente contou — em **caso registrado no acervo, com dono
comercial, partes, contexto e documentos**. Fechado o cadastro, o trabalho
jurídico sobre ele (o amparo das teses) e a automação (o monitoramento do
tribunal) são **oferecidos**, e quem escolhe é o advogado.

Quatro regras governam esta skill, e as duas primeiras puxam em direções opostas
de propósito:

1. **Cadastre com o que tiver.** Falta de informação não bloqueia. Um caso só com
   número CNJ é um caso válido; o que ele não é, é um caso **completo**.
2. **Lacuna é declarada, sempre.** O acervo devolve `pendencias_cadastro` em toda
   leitura e toda escrita de caso. Silêncio aqui vira caso órfão que ninguém
   percebe até o faturamento.
3. **O que você grava está valendo — então diga o que gravou.** Não há Fila de
   Revisão nem rascunho: o caso nasce cadastrado. Quem revisa é o advogado que
   está na conversa, e ele só revisa o que você contar que escreveu. Tudo é
   editável depois (`caso_atualizar_fato`, `caso_atualizar_memoria`,
   `caso_atualizar_tese`), e toda edição guarda versão.
4. **O cadastro é a entrega — o resto se oferece.** Esta skill entrega o caso no
   acervo. Levantar amparo, registrar tese, ligar o robô do tribunal, redigir
   peça: cada um é uma fase própria, que custa tempo e contexto do advogado e
   produz registro que ele vai ter de conferir. Terminado o cadastro, você
   **para no passo 9 e pergunta** — e o advogado escolhe a próxima jogada. Ele
   acabou de falar com o cliente; a ordem certa está com ele, não com o roteiro.

Leia `references/areas-e-roteamento.md`: as três áreas, a
ordem 0→1→3 (o eixo do foro está em pausa — ver
`references/foro-em-pausa.md`), a matriz e — sobretudo aqui
— a seção **"Um passo por vez: a próxima jogada é do advogado"**. Cadastro não é
tarefa de amparo: ele não dispara uma busca no amparo por conta própria.

## Antes de tudo: as tools estão na sessão?

Sem conta do escritório conectada, as tools do acervo respondem
`NAO_AUTENTICADO`. **Não simule o cadastro.** Diga em uma linha que a conta não
está conectada, repasse a `acao_sugerida`, e ofereça o que dá para fazer sem ela:
levantar o amparo das teses da narrativa (`levantar-fundamentos`) e devolver o
resultado para o usuário guardar. Nunca apresente isso como erro genérico.

Escopo só de leitura (`SOMENTE_LEITURA`): faça o levantamento completo, mostre ao
usuário **exatamente o que você teria gravado** (caso, cliente, partes, teses,
fontes, motivos) e diga que o escopo de escrita precisa ser liberado pelo
administrador do escritório.

Se as tools de amparo não estiverem na sessão, **pare e diga**: "o
conector do Julgados.ai não está ligado nesta sessão". **Não substitua a base por
busca na web nem por conhecimento geral de direito.** (A ausência de
`resolver_juiz`/`analisar_jurisprudencia` é esperada — eixo do foro em pausa,
ver `references/foro-em-pausa.md` — e não conta como conector desligado.)

## Roteiro

### 1. Primeiro: esse caso já existe?

**`caso_resolver` antes de qualquer coisa.** Passe o número CNJ se houver; não
havendo, passe o nome da parte, o nome do cliente ou um trecho característico da
peça.

- `resolved: true` → **o caso já está no acervo. Não duplique.** Diga isso ao
  usuário, mostre o que o acervo já tem e **mude para `acompanhar-caso`**: o
  trabalho útil aqui é atualizar, não cadastrar de novo.
- `AMBIGUO` com candidatos → **mostre os candidatos e pergunte** se é um deles ou
  se é caso novo mesmo. **Nunca escolha por conta própria e nunca duplique.**
  Caso errado devolve o histórico de outro cliente, e o erro só aparece depois
  que o advogado agiu sobre ele.
- `CASO_NAO_ENCONTRADO` → o acervo não tem esse caso. Siga para o passo 2.

`caso_resolver` casa por número, parte e cliente. Quando o usuário só tem o
assunto — "aquele caso do laudo sem vistoria" — `acervo_buscar` **sem `caso_id`**
varre fatos, teses, memória e documentos do escritório inteiro e diz em que caso
aquilo já foi registrado. Use antes de concluir que o caso é novo: um caso
cadastrado sem CNJ e com título improvisado não aparece em `caso_resolver` e
aparece aqui.

Duplicata em acervo jurídico é cara: dois casos com o mesmo processo significam
duas linhas do tempo parciais, dois briefings divergentes, e ninguém sabendo qual
vale.

### 2. Ofereça abrir — não cadastre de surpresa

`CASO_NAO_ENCONTRADO` **não é autorização para criar**. O usuário pode ter
mencionado o processo de passagem, ou querer só uma consulta.

> "Não encontrei esse processo no acervo. Quer que eu abra com o que você me
> passou?"

Então **espere o sim**. Escrever direto no acervo torna isto mais importante, não
menos: um caso criado sem pedido não fica esperando aprovação em lugar nenhum —
ele entra no acervo, aparece na carteira e alguém vai tratá-lo como real.

Autorizado, siga. Recusado, responda o que ele perguntou e siga sem gravar.

### 3. Extraia o que dá para extrair — e **confirme antes de gravar**

Do que o usuário trouxe, colete: `numero_cnj`, `titulo`, `cliente_nome`, `polo`,
`vara`, `foro`, `valor_causa`, `magistrado_nome`, e as `partes` (com `polo`,
`nome` e `advogados` quando a peça trouxer).

Regras duras:

- **Não invente número CNJ.** Se não veio, o campo fica vazio — a tool aceita
  caso sem número, e caso sem número é honesto (vira pendência de peso alto);
  número CNJ errado é veneno (ele é a chave de conciliação com o tribunal).
- **Não deduza o cliente.** Se não está claro qual das partes é o cliente do
  escritório, pergunte no passo 5 — não chute.
- O campo `contexto` é obrigatório e não é decorativo: escreva **de onde você
  tirou isso** — "extraído da petição inicial colada pelo usuário em 19/08",
  "narrativa do usuário em conversa, sem documento". É o que permite a quem ler
  depois confiar ou desconfiar de cada campo, e não some por não haver mais
  revisor: proveniência responde *de onde veio*, que é outra pergunta que *foi
  aprovado*.
- **`contexto` é UMA LINHA, e `titulo` não leva adjetivo de estado.** Antes de
  gravar, o advogado vê um cartão de permissão com os campos que você montou,
  crus. Um `contexto` de três linhas e um título "(provisório)" empurram para
  fora dali o que ele precisa conferir — número, cliente, tribunal — e o cartão
  vira um muro de texto que ele autoriza sem ler. Proveniência em uma linha; o
  título se corrige depois, não precisa se anunciar.

**Mostre o que você entendeu e peça o de acordo, antes de gravar.** Você leu
número, partes, polo e valor de um texto e pode ter lido errado — e o erro mais
caro é **trocar os polos**. Uma parte no polo errado contamina o briefing, a
matriz e toda a estratégia depois. Isto não é opcional porque a escrita é direta:
é justamente por ela ser direta que a conferência acontece **aqui**, antes.

> "Entendi assim: processo 1008576-79.2025.8.26.0100, 3ª Vara Cível de São Paulo,
> R$ 240 mil. No polo ativo, Pimenta Verde Alimentos; no passivo, Banco X.
> **Nós defendemos a Pimenta Verde**, certo? Confere o resto? Corrijo o que
> estiver errado antes de gravar."

Um minuto aqui evita um caso torto no acervo.

**Duas perguntas que parecem cadastro e não são.** Faça-as agora, na mesma
mensagem, se a resposta não estiver evidente:

1. **"Quem nós defendemos aqui?"** — vai em `partes[].eh_nosso_cliente`, e pode
   ser **mais de uma parte** (dois corréus do mesmo escritório é rotina). Não
   deduza pelo polo do caso: um processo no polo passivo pode ter quatro
   requeridos e só um ser nosso. Esta marcação é o que dá sentido a "favorável" e
   "desfavorável" quando o robô analisar as atualizações — sem ela, toda análise
   sai "direção indeterminada", e o escritório nunca sabe se a novidade é boa.
2. **"Em que tribunal e em que sistema ele tramita?"** — `tribunal` (TJSP, TJRJ,
   TRF3…) e `sistema` (`esaj_tjsp`, `eproc_tjsp`, `eproc_tjrj`, `pje`…). Não são a mesma coisa:
   o TJSP roda **e-SAJ e eproc ao mesmo tempo**, e é o sistema que decide por
   qual porta o robô entra. Não sabe o sistema? Deixe vazio — o monitoramento
   descobre na primeira leitura e grava. Mas o **tribunal** vale sempre gravar,
   inclusive fora dos tribunais cobertos (hoje TJSP, TJRJ, TJMG, TJSC e JFSC): é
   esse campo que vai dizer quais casos ficam elegíveis quando o próximo entrar.

### 4. Crie o caso — com o que você tem

`caso_criar` com o que você coletou, **mesmo que falte muita coisa**. O retorno
traz:

- `caso_id` — reuse em todas as chamadas seguintes;
- `versao` — o caso nasce na versão 1, e toda edição posterior guarda a anterior
  no histórico;
- `pendencias_cadastro[]` — o que falta, cada item com `codigo`, `o_que_falta`,
  `como_resolver` e `peso` (`alto`, `medio`, `baixo`);
- `aviso_cadastro` — uma linha pronta para repassar, ou `null` quando não falta
  nada. Ela só menciona peso **alto e médio**.

O caso **está cadastrado**. Diga isso ao usuário com o `caso_id`, na mesma
mensagem — não guarde para o fechamento se ainda faltam dez passos até lá.

Se vier `AMBIGUO` porque o `numero_cnj` já existe no tenant, o passo 1 falhou em
pegar: pare, mostre o caso existente e mude para `acompanhar-caso`.

### 5. Feche as pendências de peso ALTO na conversa — uma de cada vez

Peso alto é o que faz o caso não funcionar: sem cliente ele não tem dono
comercial nem entra em portfólio; sem partes ninguém sabe contra quem se litiga;
sem CNJ não há conciliação com o tribunal. Isso se resolve **agora**, com o
usuário na frente — não vira tarefa na tela de outra pessoa.

Comece sempre pela mesma pergunta: **"de quem é esse caso?"**

1. `cliente_resolver` com o nome, o CNPJ ou o grupo econômico que o usuário deu.
2. `resolved: true` → `caso_vincular_cliente` com o `cliente_nome` (a
   `razao_social` que `cliente_resolver` devolveu), o `caso_titulo`, o `caso_id`
   e o `cliente_id` — os dois nomes vão para o cartão de permissão, e o servidor
   confere cada um contra o id. Pronto, a pendência morreu.
3. `resolved: false` com `candidatos` → **mostre e pergunte.** Cliente errado é
   pior que cliente faltando: contamina contrato, faturamento e conflito de
   interesse.
4. Nada encontrado → **ofereça** criar: "não achei esse cliente no CRM. Quer que
   eu abra o cadastro dele?" Autorizado, `cliente_criar` com `razao_social`,
   `cnpj` (se houver — **nunca invente e nunca complete**), `grupo_economico` e
   `contexto` dizendo de onde veio a informação. Depois `caso_vincular_cliente`.
   - Se `cliente_criar` devolver `AMBIGUO` porque o CNPJ já existe, **não
     duplique**: siga do cliente que a tool devolveu.
   - Cadastro comercial mais fundo (pessoas de contato, contrato, conflito de
     interesse) é o roteiro de `abrir-cliente` — vá para lá se o usuário quiser
     fazer isso agora, em vez de refazê-lo aqui pela metade.

**Daqui em diante, olhe `monitoramento.ligado` na resposta de `caso_criar` — ele
muda a pergunta seguinte:**

- **`ligado: true` (caso monitorado — TJSP com CNJ).** A ÚNICA outra pergunta
  que ainda cabe é **"quem nós defendemos aqui?"**, e só se o polo não ficou
  claro no passo 3 — e SÓ se já houver parte para marcar (senão espere: sem
  parte cadastrada não tem o que marcar ainda). Respondida, grave com
  `caso_marcar_parte_nossa` (`caso_id` + `parte_id` ou `parte_nome`); se o nome
  casar com mais de uma parte, ela devolve AMBIGUO com os candidatos — peça o
  `parte_id`. **Não pergunte** pelas partes nem por peças: a primeira leitura do
  tribunal traz isso sozinho em minutos, e a pendência `sem_partes` chega
  marcada `aguarda_primeira_leitura: true` — é o sinal de que aquilo não é para
  perguntar, é para esperar. `aviso_cadastro` já vem com a pergunta certa: "de
  quem é o caso" (falta cliente), "quem nós defendemos... `caso_marcar_parte_nossa`"
  (falta a direção) ou as duas juntas — não invente pergunta além da que veio.
- **`ligado: false`** (sem CNJ, outro tribunal, ou monitoramento desligado) — o
  comportamento de sempre: siga com as outras pendências de peso alto, **uma
  pergunta por vez** — quem está do outro lado (partes), o número dos autos. Não
  dispare três perguntas numa mensagem só — o usuário responde a primeira e as
  outras se perdem.

Cada resposta que fecha uma pendência devolve `pendencias_cadastro` atualizado.
**Leia o retorno** — inclusive o `aguarda_primeira_leitura` de cada item — não a
sua memória do que faltava.

### 6. Peso médio e baixo: uma linha no fechamento, e siga

`sem_contrato`, `magistrado_nao_resolvido`, `cliente_sem_cnpj`,
`cliente_sem_contato` **não interrompem a conversa**. Vão para uma linha no
relatório final e acabou. (`sem_equipe` normalmente nem aparece: quem cadastra
entra como responsável — passo 9.)

**Não transforme a conversa em cadastro.** O advogado veio com um problema
jurídico, não para preencher formulário. Um caso aberto com o cliente vinculado e
três teses levantadas é um bom resultado mesmo sem CNPJ e sem contrato.

Uma exceção em que vale resolver na hora, porque é barata e destrava o
trabalho seguinte:

- `sem_contrato` **se o usuário estiver falando de honorário** — aí é o assunto
  dele, e `contrato_criar` + `caso_vincular_contrato` cabem na conversa
  (as regras do contrato estão em `abrir-cliente`: modalidades combináveis,
  gatilho de êxito em texto livre transcrito literal, um contrato cobre N casos).

### 7. Anexe o documento, se houver peça

**Só entra aqui se o usuário TROUXE ou MENCIONOU uma peça** — colou a inicial,
anexou um PDF, falou "tenho a contestação aqui". Não é passo de pedir: em caso
monitorado (`monitoramento.ligado: true`), **não peça a petição nem nenhum
documento** — eles vêm dos autos assim que a primeira leitura terminar, e pedir
o que o robô já está trazendo é o mesmo erro de perguntar pelas partes no passo
5.

Havendo peça, `caso_anexar_documento` com `nome_arquivo`, `tipo`
(`peticao_nossa`, `peticao_adversa`, `decisao`, `prova`, `contrato`,
`correspondencia`, `outro`), o conteúdo, e um `resumo_linha` seu — uma frase que
diga a um colega o que é aquilo sem abrir o arquivo.

Um documento anexado com o tipo certo é o que faz o briefing nascer útil em vez
de nascer vazio.

### 8. Grave o que só existe nesta conversa

`caso_gravar_memoria` para o que o documento não diz e o cliente disse: o
contexto comercial (`contexto`), a decisão estratégica que o usuário tomou agora
(`decisao`), a orientação que deve valer daqui em diante (`instrucao` — e
`escopo: "escritorio"` se ela vale para todos os casos, não só este).

E o que o caso novo sempre produz e quase sempre se perde: **as conjecturas.**
Abrir um caso é a hora em que mais se especula — sobre o que a outra parte quer,
sobre o que o documento sugere e não prova, sobre onde a coisa vai dar. Isso não
é tese (não tem amparo levantado) nem contexto (não é fato do mundo): é
`caso_gravar_memoria` com `tipo: "hipotese"` e `desfecho: "aberta"`. Daqui a dois
meses, quando o primeiro andamento entrar, ela é o que permite retomar o
raciocínio em vez de refazê-lo.

Havendo prazo já visível (contestação, recurso, cumprimento),
`caso_registrar_prazo` com `titulo`, `fundamento` e `vence_em` quando você tiver
a data com segurança.

### 9. Feche o cadastro — diga o que gravou, e pergunte o que ele quer agora

**O cadastro é a entrega desta skill.** Ele não é a primeira metade de um roteiro
maior que você conduz sozinho até o fim: é a coisa que o advogado pediu, e ela
acaba aqui. O que vem depois é escolha dele.

Primeiro, **o que você gravou** — item a item, com o convite à correção:

> "Gravei no acervo: 1 caso (`caso_id` …), 1 cliente, 4 partes, 1 documento, 1
> hipótese aberta e 1 prazo. Me diga se algo ficou errado que eu corrijo —
> sobretudo os polos."

Depois, **o que falta no cadastro**, em uma linha: o `aviso_cadastro` da última
resposta, ou as pendências de peso médio e baixo que sobraram. Não repita a lista
inteira com `como_resolver` — isso é para você agir, não para o usuário ler.
Ignore as pendências marcadas `aguarda_primeira_leitura: true` — não é isso que
falta, é isso que está a caminho. Em caso monitorado, `sem_contrato` (se sobrou)
cabe em no máximo meia linha, sem explicar peso ou o que ele bloqueia.

**A equipe do caso já tem uma pessoa: quem cadastrou.** `caso_criar` devolve
`equipe_inicial` — o advogado da conversa entra como **responsável**, porque
equipe vazia manda o e-mail da atualização do tribunal para os administradores do
escritório em vez de para quem toca o caso. Diga isso em meia linha e siga;
querendo mais gente, é em **Casos › Equipe** na plataforma (daqui você ainda não
aloca ninguém).

> "Entrei você como responsável pelo caso — é quem recebe o e-mail das
> atualizações. Outras pessoas do escritório entram em Casos › Equipe."

**Depois, o monitoramento — AVISO, não pergunta.** Em processo de tribunal
coberto (TJSP (`….8.26.….`), TJRJ (`….8.19.….`), TJMG (`….8.13.….`), TJSC (`….8.24.….`) e JFSC (`….4.04.72xx`)) com número informado, o monitoramento **nasce ligado** (fora do
TJSP, se o escritório já habilitou o eproc daquele tribunal; senão `ligado:
false` com o motivo — diga em uma linha que é o administrador quem habilita):
`caso_criar` devolve `monitoramento.ligado: true` e a primeira leitura já foi
disparada. Diga o que está acontecendo e o que ISSO SIGNIFICA para o resto desta
conversa — não peça nada que a leitura vai trazer:

> "Caso cadastrado e o monitoramento já está ligado. A plataforma está lendo o
> processo no tribunal agora: em alguns minutos as partes, as movimentações e as
> peças aparecem no caso, e em seguida ela analisa o histórico e sugere prazos.
> Não precisa me mandar a petição — ela vem dos autos. Quando quiser, me
> pergunte 'o que aconteceu no caso X' que eu te conto o que chegou."

Com `ligado: false`, diga o motivo em uma linha e resolva o que dá na conversa
(faltou o número → peça o número; gravar o CNJ liga o monitoramento sozinho).
Outro tribunal → ver o fim deste passo.

**Então crie a rotina diária — o card, não a pergunta.** É ela que faz a novidade
do tribunal virar análise sem ninguém abrir a máquina, e é a coisa que mais se
perde quando vira uma pergunta no fim de uma mensagem longa: o advogado pula.
Então **crie a tarefa** com a ferramenta de tarefas agendadas do seu ambiente e
deixe o **card** dela ser o convite — ele mostra horário e prompt, e o advogado
aprova, muda a hora ou apaga num clique. Isso é da mesma família do
monitoramento: o padrão da plataforma é acompanhar, e desligar é o que se pede.

- **Crie** com: dias úteis, de manhã (8h se ele não disse a hora), e este prompt,
  literal:
  > "Use a skill processar-atualizacoes do Julgados.ai: veja quais casos do escritório têm atualização do tribunal que ninguém analisou, analise cada uma (leia as peças novas, classifique, levante amparo no que for material), grave a análise no caso e marque como processado com uma nota clara — a nota vira o e-mail para a equipe do caso. No fim, me mande um resumo por caso."
- **Diga em uma linha o que você criou** — nunca em silêncio, e sempre com a
  saída: "criei uma tarefa diária, dias úteis às 8h, que analisa o que o tribunal
  trouxer e manda o resumo para a equipe do caso. Mudo o horário ou desligo, é só
  falar."
- **Não crie duas.** Se ele já tem a rotina (disse, ou a lista de tarefas do
  ambiente mostra), diga em meia linha que ela já está de pé e siga.
- **Não crie contra o que ele disse.** "Agora não" nesta conversa é não; e se ele
  apagar o card, não recrie.
- **Sem ferramenta de agendamento** no ambiente: diga em duas linhas como criar
  (no ChatGPT, Tarefas agendadas → nova tarefa, diária, com o prompt acima) e
  cole o prompt para ele copiar. **Não finja que agendou.**
- **O e-mail não é você que manda.** Ele sai da plataforma quando a rotina chama
  `caso_marcar_processado`, para a equipe cadastrada no caso — a nota é o corpo.
- A rotina precisa do conector Julgados.ai autorizado no ambiente das tarefas
  agendadas.

**Por fim, pergunte o que ele quer agora.** Duas a quatro opções concretas,
nomeadas pelo que entregam — e as opções mudam com `monitoramento.ligado`:

- **Caso monitorado (`ligado: true`)**: (a) esperar a leitura e eu conto o que
  vier (é `acompanhar-caso`, depois); (b) levantar o amparo das teses com o que
  já sabemos agora; (c) nada agora. **Sem** "anexar peças" — a não ser que ele
  já tenha mencionado ter alguma; nesse caso ofereça, senão não. Havendo
  `sugestoes` (teses e itens de memória que a primeira leitura já propôs) ou o
  briefing saindo com `nossa_posicao`/`decisoes`/`pendencias` vazios, ofereça
  também (d) — ver abaixo.

  > "Daqui eu posso (a) esperar a leitura do tribunal terminar e te contar o que
  > chegou; (b) levantar o amparo das teses com o que já sei agora. O que você
  > quer?"

- **Caso não monitorado (`ligado: false`)**: o de sempre — (a) levantar o
  amparo das teses da inicial — súmula, tema e lei vigente, gravadas no caso com
  fonte; (b) anexar as outras peças que ele tenha (só se ele mencionou ter
  peças); (c) nada agora.

  > "Daqui eu posso (a) levantar o amparo das teses da inicial — súmula, tema e
  > lei vigente, gravadas no caso com fonte; (b) anexar as outras peças que você
  > tenha. O que você quer primeiro?"

- **Sempre que houver `sugestoes` da leitura automática (teses e/ou itens de
  memória em rascunho) para decidir, ou o briefing vier com seções vazias**
  (`nossa_posicao` sem tese confirmada, `decisoes`/`pendencias`/`ameacas` sem
  registro): ofereça **(d) revisar com você a posição do caso** — decidir o que
  a leitura sugeriu e registrar o que só está na sua cabeça. É o passo 14, a
  seguir.

  > "Também reparei que a leitura automática já sugeriu [N] tese(s) e [M]
  > anotação(ões) que ninguém confirmou, e o briefing ainda está sem posição
  > nossa. Quer fechar isso comigo agora?"

Inclua sempre a saída **"nada agora"** — sem ela a pergunta não é uma pergunta.
A linha da rotina criada e esta pergunta podem ir na mesma mensagem; nenhuma das
duas autoriza a outra.

Quatro regras neste passo, e são elas que fazem a skill seguir o advogado:

- **Não emende o passo seguinte na mesma mensagem.** Perguntar "quer que eu levante
  o amparo?" e já sair buscando súmula é não ter perguntado.
- **O que ele já pediu no começo não se pergunta de novo.** "Cadastra esse processo
  e liga o monitoramento" autoriza os dois: faça os dois e reporte.
- **Recusa vale para a conversa.** "Agora não" na rotina agendada não volta na
  mensagem seguinte. A oferta pode esperar a próxima conversa.
- **Novidade de OUTRO caso não entra aqui.** Se alguma resposta trouxer
  `novidades_do_tribunal` — outros casos do escritório com atualização que
  ninguém analisou —, **não mencione nesta conversa**, nem como oferta no
  fechamento. O advogado acabou de falar com o cliente deste caso; a carteira
  inteira é assunto da próxima conversa, e o acervo volta a avisar nela sozinho
  (é `revisar-carteira` ou `processar-atualizacoes` que trata disso). Cadastro é
  conversa de um caso só.

Sobre o monitoramento, o detalhe operacional: ele já vem ligado de `caso_criar`;
`caso_ativar_monitoramento` só entra quando alguém desligou antes e o usuário
pede para religar. Se a resposta disser que o escritório não tem certificado
digital, diga isso em uma linha (é o administrador quem cadastra, em
Configurações → Certificado digital) e siga sem insistir.

**Antes de ligar, o CLIENTE vinculado tem que estar no lugar** — e faltando, é
pergunta, não formulário: "de quem é esse caso?" → `cliente_resolver` →
`caso_vincular_cliente`. Sem isso o processo passa a encher de novidade sem
dono comercial.

**A parte que o escritório defende é outra história, e depende do que o caso já
tem:**

| o caso já tem partes cadastradas? | o que fazer |
|---|---|
| Sim | Pergunte "quem nós defendemos aqui?" e marque com `caso_marcar_parte_nossa` ANTES de ligar — sem isso a análise automática não sabe de que lado estamos e responde "direção indeterminada" em toda atualização, para sempre. |
| Não (o normal: vai ligar antes da primeira leitura trazer o histórico) | Não dá para marcar agora — não invente parte. Ligue mesmo assim; a leitura traz as partes sozinha, e a pergunta + `caso_marcar_parte_nossa` ficam para a próxima vez que você abrir este caso (`aviso_cadastro` avisa). |

Não é burocracia adiável quando já dá para resolver: ligado o monitoramento, o
robô lê e **analisa o histórico em minutos**, e análise feita sem saber de que
lado o escritório está não se conserta sozinha — alguém tem que mandar refazer
o caso inteiro.

**Processo de outro tribunal:** a tool recusa, e está certa — hoje o robô lê
o TJSP (e-SAJ e eproc, e descobre sozinho em qual dos dois o processo está) e o
eproc do TJRJ, TJMG, TJSC e JFSC. Diga isso em uma linha, sem prometer data, e **grave `tribunal` e
`sistema` mesmo assim**: é o que vai tornar o caso elegível automaticamente no
dia em que o estado dele entrar.

### 10. Amparo — só com o sim do advogado: as teses que a narrativa sustenta

Chegou aqui porque o usuário pediu o levantamento no checkpoint do passo 9 (ou
porque ele já havia pedido desde o começo: "abre o caso e me diz o que sustenta").
**Se ele não pediu, você não está neste passo** — volte ao passo 9 e espere.

Este passo custa várias chamadas por tese e grava registros que o advogado vai ter
de conferir: é trabalho de verdade, com custo de verdade. Não se emenda no
cadastro por iniciativa própria.

Recorte as controvérsias que **decidem** o resultado. De 3 a 6; se forem mais,
priorize com o usuário antes de gastar as chamadas.

Formule cada uma como **proposição verificável**, nunca como tema — é assim que
ela entra no acervo e é assim que ela vai ser reavaliada daqui a seis meses. Ruim:
"prescrição". Bom: "a suspensão dos prazos prescricionais da Lei 14.010/2020
alcança apenas o período de 12/06 a 30/10/2020".

Para cada tese, na ordem: `buscar_qualificada` (confira `status_vigencia` —
cancelada ou superada **é** a resposta), depois a lei
(`buscar_norma_por_numero`/`buscar_norma_por_nome` → `obter_dispositivo_legal`, e
`obter_alteracoes_norma` se a redação mudou no período dos fatos), depois
acórdãos (`buscar_hibrida`).

Classifique o `amparo` de cada uma: `forte`, `fraco`, `contra_nos`,
`nao_coberto`. **`contra_nos` também se registra** — descobrir cedo que a tese
joga contra é o achado mais barato do caso, e um caso que só registra tese
favorável mente para o escritório.

### 11. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: classifique pelo amparo, `posicao_juizo: sem_cobertura`,
não peça o juiz. As teses caem em `amparo_solido_juizo_aberto`, `desconhecido`
ou `descarte`, conforme o `amparo`. Não chame `resolver_juiz` nem
`analisar_jurisprudencia`, mesmo que o caso já tenha juiz distribuído.

### 12. Registre as teses

`caso_registrar_tese`, uma por tese, com:

- `enunciado` — a proposição verificável do passo 10;
- `polo` — `nossa` ou `adversa`. A tese da contrária que você já enxerga na
  inicial **vale registrar**: é o mapa do que vem;
- `amparo` e `posicao_juizo: "sem_cobertura"` (eixo do foro em pausa);
- `fontes` — cada uma com `eixo` (`amparo` ou `juizo`), `tipo`, `referencia`,
  `link_oficial` e `status_vigencia`. **Tese sem fonte não se registra**: vira
  opinião com aparência de acervo;
- `motivo` — **obrigatório por contrato**. Escreva o raciocínio, não o rótulo:
  "amparo forte: Tema 1.199/STJ vigente e art. 3º da Lei 14.010/2020 com redação
  original aplicável aos fatos", não "achei forte".

A `celula` volta calculada pela plataforma — `ancora`, `conflito`,
`amparo_solido_juizo_aberto`, `ganho_fragil`, `descarte` ou `desconhecido`.
**Não digite célula**, repasse a que veio.

### 13. Feche a rodada de amparo — e devolva a escolha

Terminado o levantamento, reporte:

1. **As teses** — enunciado, célula, fontes com link oficial e vigência; separe as
   `nossa` das `adversa`. O link é o que veio no resultado do amparo, **clicável
   e aqui na conversa**: tê-lo gravado nas `fontes` (passo 12) não dispensa
   mostrá-lo. Nunca URL montada de memória; se `link_aviso` disser que pode não
   abrir, mostre com o aviso e o `link_pesquisa_geral`.
2. **O que ficou em aberto no direito** — o eixo do foro em pausa (vale para todas
   as teses), tese `nao_coberto`, dado que você não conseguiu extrair.
3. **A linha do que gravou nesta rodada** — quantas teses, de que polo, e o convite
   à correção.

E devolva a escolha, outra vez em uma linha: redigir a peça sobre a tese-âncora
(`redigir-peca`), revisar uma peça que ele já tem (`revisar-peca`), ligar o
monitoramento se ficou de fora, ou parar aqui. **Não comece a redigir peça sem o
usuário pedir** — é a mesma regra do passo 9, um passo adiante.

### 14. Entrevista de briefing — só com o sim do advogado: o que preenche a posição do caso

Chegou aqui porque o usuário escolheu a opção (d) no checkpoint do passo 9 (ou
pediu isso desde o começo: "cadastra e já fecha a posição do caso comigo"). **Se
ele não pediu, você não está neste passo** — volte ao passo 9 e espere.

O motivo de existir: um caso recém-lido pelo robô chega com fatos de expediente,
e às vezes teses e memória **em rascunho**, sugeridos pela leitura automática —
mas **nada disso foi dito pelo advogado**. O briefing (`caso_obter_briefing`) é
um retrato honesto do acervo: se `nossa_posicao`, `decisoes`, `pendencias`,
`ameacas` ou `nao_sabemos` vierem vazias ou cheias de "a confirmar", é porque
ninguém do escritório falou ainda — não é defeito do briefing, é a entrevista
que falta. Esta é essa entrevista.

Regras que valem para todo o passo 14, e são as mesmas de sempre:

- **Uma pergunta por vez.** Nunca emende a próxima seção na mesma mensagem —
  espere a resposta (ou o "não sei"/"pula") antes de seguir.
- **Grave direto e diga o que gravou, em uma linha**, para o advogado corrigir
  ali mesmo — não acumule tudo para contar no fim do passo 14.
- **Sem resposta, sem registro.** Se o advogado não souber ou não quiser
  responder alguma pergunta, siga para a próxima sem gravar nada por ela. Seção
  honestamente vazia é melhor que seção preenchida com chute.
- **Não invente pergunta além da que a tabela abaixo pede.** Esta entrevista
  fecha as cinco seções do briefing, não é uma sabatina livre sobre o caso.
- **Fora de escopo, não pergunte**: `polo`, `valor_causa` e `assunto` já
  ficaram fora do cadastro (passo 3) e continuam fora aqui.
- **Nada de amparo aqui.** Registrar tese adversa (14d) é anotar o que a outra
  parte sustenta, não levantar o amparo dela — isso é o passo 10, só se pedido.

#### 14a. Rascunhos primeiro: decida o que a leitura automática já sugeriu

Antes de perguntar qualquer coisa nova, **as sugestões existentes têm que morrer
na conversa** — confirmadas ou descartadas. Enquanto ficam em rascunho, elas
aparecem no briefing rotuladas "a confirmar", que é exatamente o ruído que a
entrevista existe para acabar.

1. `caso_listar_teses` — leia `teses_sugeridas`. Para cada uma, mostre o
   `enunciado`, o `por_que` e o `ancora_trecho` (o trecho literal do dossiê que
   sustentou a leitura) e pergunte, **uma tese de cada vez**:

   > "A leitura automática sugeriu esta tese: '[enunciado]', com base em
   > '[ancora_trecho]'. Confirma como nossa (ou como da parte contrária), ou
   > descarta?"

   Confirmando, `caso_decidir_tese_sugerida` — aproveite a mesma chamada para
   corrigir `enunciado`/`amparo`/`polo` se o advogado ajustar algo (`mudancas`),
   em vez de confirmar torto e editar depois. Descartando, `caso_decidir_tese_sugerida`
   também, com o `motivo` que o advogado deu. **Nunca registre de novo com
   `caso_registrar_tese`** — duplica a linha e perde a âncora.

2. `caso_obter_memoria` — leia `itens_sugeridos`. Para cada um, mostre o
   `tipo`, o texto e o `ancora_trecho`, e pergunte da mesma forma:

   > "A leitura também anotou isto como [tipo]: '[texto]', a partir de
   > '[ancora_trecho]'. Confirma ou descarta?"

   `caso_decidir_memoria_sugerida` nos dois caminhos, com `mudancas` se o
   advogado corrigir o texto ao confirmar. **Nunca registre de novo com
   `caso_gravar_memoria`.** Hipótese sugerida confirmada nasce **aberta** — não
   feche sozinho; ela some da seção 14c abaixo só se o próprio advogado disser
   que já tem resposta.

Sem sugestões pendentes, diga isso em meia linha e siga direto para 14b.

#### 14b. `decisoes` — o que já foi decidido

Pergunte, uma vez: **"o que vocês já decidiram nesse caso?"** (acordo recusado,
estratégia escolhida, valor que não se aceita abrir mão, etc.)

Havendo resposta, `caso_gravar_memoria` com `tipo: "decisao"` — o texto do
advogado, sem parafrasear a estratégia. Diga em uma linha o que gravou.

#### 14c. `pendencias` — o que está em aberto

Pergunte: **"e o que está em aberto — o que vocês ainda estão decidindo ou
esperando?"**

Havendo resposta, `caso_gravar_memoria` com `tipo: "hipotese"` e
`desfecho: "aberta"` — é conjectura ou questão pendente, não fato nem tese.

#### 14d. `ameacas` — o que a outra parte sustenta, e o que corre

Duas perguntas, **uma de cada vez**:

1. **"O que o outro lado sustenta, pelo que vocês já viram?"** Havendo
   resposta com conteúdo jurídico reconhecível, `caso_registrar_tese` com
   `polo: "adversa"`, `posicao_juizo: "sem_cobertura"` e `motivo` dizendo que
   veio da entrevista de cadastro (não de peça lida) — **sem amparo levantado
   aqui**; se o advogado quiser o amparo da tese adversa, isso é o passo 10.
2. **"Tem algum prazo correndo que eu deva registrar?"** Havendo data,
   `caso_registrar_prazo` com `titulo`, `fundamento` (o que o advogado disse
   ser a origem) e `vence_em` só se a data vier com segurança — sem data
   segura, não registre, deixe para quando a leitura do tribunal trouxer ou o
   advogado confirmar.

#### 14e. `nao_sabemos` — o que se assume não saber

Pergunte: **"e o que vocês assumem que não sabem ainda sobre esse caso?"**

Havendo resposta, `caso_gravar_memoria` — `tipo: "hipotese"` quando for algo a
verificar depois (ex.: "não sabemos se há outros contratos com o mesmo grupo"),
`tipo: "contexto"` quando for uma lacuna de fato já assumida e sem previsão de
resposta. Na dúvida entre os dois, prefira `hipotese`: ela aparece em
`hipoteses_abertas` na próxima conversa e não se perde.

Sem resposta em nenhuma das cinco letras: tudo bem, a seção correspondente
continua honestamente vazia no briefing — não é falha desta entrevista, é o
que o advogado sabe hoje.

### 15. Regrave o briefing — e feche a entrevista

Terminadas as cinco letras (mesmo que algumas tenham ficado sem resposta),
`caso_regravar_briefing` com um `motivo` que diga o que mudou: "entrevista de
cadastro confirmou N tese(s) sugerida(s), descartou M, e registrou decisão/
pendência/ameaça/lacuna". A regravação é uma **compilação determinística** do
acervo — não chama modelo nenhum, o custo não é motivo para hesitar.

Depois, reporte em uma linha o que a entrevista gravou — teses confirmadas e
descartadas, itens de memória decididos, o que foi registrado em cada seção —
e diga que o briefing foi atualizado. O convite à correção de sempre:

> "Fechei a posição do caso: confirmei 1 tese nossa e descartei 1 sugerida,
> gravei 1 decisão, 2 pendências e 1 ameaça, e registrei o que vocês assumem
> não saber. Regravei o briefing com isso. Me diga se algo ficou errado."

Se nenhuma das cinco letras teve resposta (o advogado só queria decidir os
rascunhos em 14a, por exemplo), ainda vale regravar — decidir uma tese
sugerida já muda `nossa_posicao`.

## Nas conversas seguintes: o aviso é **uma vez**, no fechamento

Toda leitura e toda escrita de caso devolvem `pendencias_cadastro` e
`aviso_cadastro`. Quando `aviso_cadastro` vier preenchido numa conversa posterior
sobre o mesmo caso, mencione-o **uma única vez, no fechamento** — e volte ao que
o usuário estava fazendo.

Não abra a resposta com ele, não o repita a cada mensagem, não o repita depois de
o usuário já ter dito "depois". **Aviso repetido é aviso que o usuário aprende a
pular** — e aí ele pula também o que importava.

## Você cadastra de verdade — e responde por isso na conversa

Tudo o que esta skill grava **está valendo**: o caso, o cliente, o contrato, as
teses. Não existe um humano a jusante conferindo antes de virar real. O humano é
o que está aqui, agora — e a proteção dele é você **contar o que escreveu, na
hora, item a item**, e corrigir o que ele apontar.

Por isso, nesta skill acima de todas: confirme os campos extraídos antes de
gravar (passo 3), ofereça antes de criar o que o usuário não pediu (passo 2), e
nunca diga "cadastrei tudo" sem enumerar o que é "tudo".

**Erro seu se corrige no registro, não se compensa com outro registro.** Percebeu
depois que o valor da causa estava errado, que o fato foi datado errado, que a
memória entrou como `contexto` quando era `hipotese`? `caso_atualizar_fato`,
`caso_atualizar_memoria`, `caso_atualizar_tese`. A versão anterior fica guardada
com o motivo, então não se perde nada — e o acervo continua com **uma** verdade
por registro. Dois registros se contradizendo é o que faz um advogado parar de
ler a tela.

## Critério de parada

**A parada normal desta skill é o checkpoint do passo 9**: o caso existe no
acervo, as pendências de peso alto estão fechadas ou perguntadas, o documento
está anexado (se havia), o que só existia na conversa está gravado, o usuário
sabe o que você gravou — e a bola está com ele. Cadastro sem tese levantada não é
trabalho pela metade: é o trabalho que ele pediu, terminado.

Passou do checkpoint porque ele pediu o amparo? Então pare quando as teses
decisivas estiverem registradas com amparo verificado e motivo, e a escolha
estiver devolvida a ele. Não continue buscando amparo para "reforçar" tese já
sustentada, e não fique perguntando dado que o usuário já disse que não tem —
vira pendência declarada, não interrogatório.

Passou do checkpoint porque ele pediu a entrevista de briefing (passo 14)?
Então pare quando as sugestões da leitura automática tiverem sido todas
decididas (confirmadas ou descartadas), as cinco letras tiverem sido
perguntadas uma vez cada — respondidas ou não — e `caso_regravar_briefing`
tiver sido chamado. Não insista numa letra que o advogado já pulou, e não
transforme 14d em levantamento de amparo da tese adversa.

## Erros a não cometer

- Criar o caso sem chamar `caso_resolver` antes — duplicata é o pior defeito de
  um acervo.
- **Tratar `CASO_NAO_ENCONTRADO` como autorização para cadastrar.** Ofereça e
  espere.
- **Emendar o levantamento de amparo no cadastro sem o advogado pedir** — sair
  buscando súmula, lei e acórdão porque o roteiro tem um passo 10. Cadastro
  pedido é cadastro entregue; o resto se oferece no passo 9.
- **Não perguntar o que ele quer em seguida**, e decidir você a próxima fase.
- **Deixar o monitoramento invisível** num caso do TJSP com número informado: é a
  opção que o advogado mais provavelmente quer e a que ele menos sabe existir.
- Reoferecer, na mensagem seguinte, o que ele acabou de recusar — ou perguntar de
  novo o que ele já pediu no começo da conversa.
- **Gravar sem confirmar o que você extraiu** — sobretudo os polos.
- Escolher sozinho entre os candidatos de um `AMBIGUO`, seja de caso ou de
  cliente.
- **Travar o cadastro por falta de dado.** Cadastre com o que tem; o que falta é
  declarado, não impeditivo.
- Duplicar cliente quando `cliente_criar` devolveu `AMBIGUO` por CNPJ já
  existente.
- Inventar número CNJ ou CNPJ, ou deduzir qual parte é o cliente.
- **Virar formulário**: perseguir pendência de peso médio e baixo na conversa,
  ou disparar várias perguntas de cadastro numa mensagem só.
- Repetir `aviso_cadastro` a cada mensagem.
- Deixar o `contexto` vago: quem ler daqui a seis meses precisa saber de onde
  veio cada campo.
- Registrar tese sem fonte, ou sem `motivo`.
- Registrar só as teses favoráveis — `contra_nos` é informação, não derrota.
- Digitar a célula da matriz em vez de usar a que a plataforma calculou.
- Exigir o magistrado para abrir o caso.
- **Gravar em silêncio** e só contar no fim, ou fechar com "cadastrei tudo" sem
  enumerar.
- **Corrigir um registro seu escrevendo outro por cima** em vez de editar aquele.
- Deixar morrer, sem gravar como hipótese, a conjectura que a inicial sugeriu e
  ninguém verificou.
- **Trazer para a conversa do cadastro a novidade dos outros casos** do
  escritório (`novidades_do_tribunal`). Cadastro é conversa de um caso só.
- Reduzir a rotina diária a uma pergunta no fim de uma mensagem longa quando o
  ambiente tem tarefas agendadas: crie a tarefa e deixe o card falar.
- **Interrogar sobre o que a leitura do tribunal traz** (partes, número, peças)
  num caso que acabou de nascer monitorado — é a mesma pendência anunciando
  `aguarda_primeira_leitura: true` para avisar que já está a caminho.
- **Pedir a petição, ou qualquer documento, num caso monitorado.** Ela vem dos
  autos; peça só se o usuário já trouxe algo e ainda faltar outra peça que ele
  mesmo mencionou.
- **Deixar tese ou item de memória sugerido pela leitura automática em
  rascunho** depois que o advogado entrou na entrevista de briefing (passo 14)
  — decida com `caso_decidir_tese_sugerida`/`caso_decidir_memoria_sugerida`,
  nunca registre de novo por cima.
- **Perguntar `polo`, `valor_causa` ou `assunto` na entrevista de briefing** —
  ficaram fora do cadastro por decisão do usuário e continuam fora aqui.
- **Emendar a entrevista de briefing no cadastro sem o advogado pedir**, ou
  disparar as cinco perguntas (14a–14e) numa mensagem só.
- **Levantar amparo da tese adversa ao registrar `ameacas` (14d)** — é só
  anotar o que a outra parte sustenta; amparo é o passo 10, só se pedido.
- **Regravar o briefing sem ter mudado nada** — ou deixar de regravar depois de
  decidir sugestão ou gravar seção da entrevista.
