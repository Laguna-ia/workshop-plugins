---
name: acompanhar-caso
description: >
  Atualiza o advogado sobre um caso que o escritório já tem no acervo: lê o
  briefing, vê quantos andamentos ele ainda não viu, OFERECE processá-los e
  espera o sim; então classifica a novidade (é material? é marco? cria prazo?),
  levanta o amparo do que for material, grava e marca o que tratou. Retoma as
  hipóteses abertas — o que se estava pensando da última vez. Acione quando o
  usuário perguntar sobre um caso EXISTENTE — "o que aconteceu no caso X?", "me
  atualiza sobre o processo 1008576-79.2025", "novidades do caso da Pimenta
  Verde", "tem prazo correndo?", "o que mudou desde a semana passada?", "qual a
  situação do caso do cliente Y?". Entrega em três blocos: o que mudou / o que
  significa / o que fazer. Grava direto no acervo e diz o que gravou, para o
  usuário corrigir ali mesmo. Exige conta do escritório conectada. Caso que
  ainda não existe no acervo, use abrir-caso; visão de todos os casos,
  revisar-carteira; direito sem caso, levantar-fundamentos.
---

# Acompanhar o caso

Objetivo: o advogado abre a conversa e sai sabendo **o que mudou no caso desde a
última vez que ele olhou, o que isso significa no direito, e o que ele precisa
fazer** — cada afirmação rastreável até o registro do acervo, o link oficial do
precedente ou o número do processo.

Esta skill **não varre e grava**. Ela **oferece, espera, trata e marca**. A
diferença não é de estilo: processar novidade sem o usuário ter pedido gasta o
contexto e o custo dele numa coisa que ele não pediu e — pior — carimba como
tratado o que ele nunca viu.

Leia `references/areas-e-roteamento.md`: define as três
áreas, a ordem 0→1→3 (o eixo do foro está em pausa — ver
`references/foro-em-pausa.md`), a matriz e a mecânica de
novidade.

## Dois relógios: leitura é sua, processamento é do caso

**Leitura** é por advogado: responde *"o que **eu** ainda não vi neste caso?"*.
**Processamento** é por caso: responde *"o que **ninguém** ainda tratou?"*.

Por isso as duas coisas se marcam em separado. Quando você processa um fato e
grava a análise, ele sai da fila de tratamento de **todo o escritório** — mas a
leitura de cada colega continua sendo dele. E quando você marca a leitura, é a
leitura **deste** advogado que anda, não a de mais ninguém. Confundir os dois é o
jeito de apagar novidade da vista de quem não a viu.

(Nada disso é `caso.ultima_leitura_em`: aquilo é o relógio da automação, o que
sustenta "parado há N dias". Não é seu, não mexa.)

## Antes de tudo: as tools estão na sessão?

Esta skill vive do acervo. Se as tools do acervo responderem `NAO_AUTENTICADO`,
**não invente o histórico do caso**: diga em uma linha que a conta do escritório
não está conectada, repasse a `acao_sugerida` que a tool devolveu, e ofereça o
que você **consegue** fazer sem ela — levantar o amparo de uma tese que o usuário
descreva (`levantar-fundamentos`). Nunca apresente isso como erro genérico.

`caso_marcar_lido` é escopo de leitura (`acervo:read`) de propósito: ele só toca
o seu próprio marcador. `caso_marcar_processado` e `caso_regravar_briefing` são
escrita. Em `SOMENTE_LEITURA` você ainda pode reportar e marcar lido, mas **diga
que o tratamento não ficou registrado para os colegas**.

Se as tools de amparo não estiverem na sessão, **pare e diga**: "o
conector do Julgados.ai não está ligado nesta sessão". **Não substitua a base por
busca na web nem por conhecimento geral de direito** — uma resposta jurídica
montada de outra fonte se parece com a certa e não é.

## Roteiro

### 1. Resolva o caso — nunca adivinhe

`caso_resolver` com o que o usuário deu: número CNJ, nome de parte, nome de
cliente, apelido interno do caso.

- `resolved: true` → guarde o `caso_id` e reuse em todas as chamadas seguintes.
- `AMBIGUO` / `candidatos` → **mostre os candidatos e peça para escolher.** Nunca
  escolha por conta própria: caso errado devolve o histórico de outro cliente, e
  o erro só aparece depois que o advogado agiu sobre ele.
- `CASO_NAO_ENCONTRADO` → o acervo não tem esse caso. Diga isso e ofereça abri-lo
  (`abrir-caso`). Não trate a ausência como caso vazio.

Se o usuário deu um termo que não é caso — o nome de um perito, uma expressão da
peça, o assunto de uma conversa antiga — `acervo_buscar` **sem `caso_id`** acha
em que caso aquilo foi registrado. É o caminho para "aquele caso em que a gente
discutiu X" quando ninguém lembra o número.

### 2. Situe-se: o briefing — e é ele que conta se há trabalho

`caso_obter_briefing`. Leia as seis seções e, especialmente:

- **`instrucoes_ativas`** — são **restrições ao seu trabalho**, não contexto de
  cor. "Não fazer da prescrição o eixo do agravo" significa que você não fará. Se
  a instrução conflita com o que você acabou de encontrar no amparo, **traga o
  conflito ao usuário** — não desobedeça em silêncio e não obedeça em silêncio a
  uma instrução que virou errada.
- **`nao_sabemos`** — o que o escritório já sabe que não sabe. É a sua lista de
  buracos a fechar, e o lugar onde aparece se o magistrado ainda está sem
  cobertura.
- **`decisoes`** — o que já foi decidido. Não reabra decisão fechada sem
  motivo novo.
- **as hipóteses abertas** — é a lista do que se estava pensando da última vez, e
  o primeiro lugar onde a novidade do caso pode ter resposta. Uma hipótese de
  três meses atrás ("acho que vão pedir perícia antes de contestar") lida contra
  o andamento que acabou de entrar **resolve sozinha** metade do trabalho: ou ela
  se confirmou, ou caiu. Feche o que der (`caso_fechar_hipotese` com
  `caso_titulo` — o título do caso, de `caso_resolver`/`caso_obter_briefing` —
  e `desfecho`) e diga ao usuário qual fechou.
- **`sugestoes`** — bloco À PARTE das seis seções: tese e hipótese que a
  **leitura automática** da primeira leitura propôs e ninguém do escritório
  confirmou nem descartou ainda. Não é posição do escritório — mostre como
  sugestão da plataforma. Havendo algo aqui, decida no passo 6 (teses, via
  `caso_listar_teses`/`caso_decidir_tese_sugerida`) e no passo 8 (itens de
  memória, via `caso_obter_memoria`/`caso_decidir_memoria_sugerida`).

E os quatro campos que dizem se há novidade — **é por eles que você descobre que
há trabalho, sem varrer a linha do tempo antes**:

| Campo | O que significa |
|---|---|
| `nao_processados_no_caso` | **a pendência real**: fatos que **ninguém** do escritório tratou ainda |
| `nao_lidos_por_voce` | fatos que **este** advogado ainda não viu — é sobre VOCÊ, não sobre o caso |
| `leitura_pessoal_marcada` | `false` = você **nunca** marcou leitura neste caso; nesse caso `nao_lidos_por_voce` vem `null` |
| `desatualizado` | o briefing é anterior a fato confirmado — está velho |
| `fatos_novos_desde_a_versao` | quantos fatos entraram depois da versão do briefing |
| `nao_processados_automacao` | dos não tratados, quantos vieram do **robô de tribunal** (e-SAJ) |
| `monitoramento` | `{estado, ativo, ultima_leitura_em, primeira_leitura_concluida, ativado_em, houve_atualizacao}` — o robô lê este caso? |

**`nao_processados_no_caso` é a pendência de verdade — é ele que responde "tem
trabalho parado aqui?". `nao_lidos_por_voce` é informativo, nunca "acumulado" ou
"pendente":** ele só existe enquanto conceito quando você já marcou leitura pelo
menos uma vez neste caso (`leitura_pessoal_marcada: true`). Sem marca nenhuma
(`leitura_pessoal_marcada: false`, `nao_lidos_por_voce: null`), NÃO existe
contagem de não lidos para anunciar — não diga "você tem N não lidos
acumulados" nem invente um número a partir de outro campo; o caso pode estar
com `nao_processados_no_caso: 0` (tudo tratado) mesmo sem ninguém tê-lo
marcado como lido. Diga, se for o caso, algo como "você ainda não marcou
leitura neste caso; não há pendência de tratamento" e siga pelo que
`nao_processados_no_caso` disser.

Zerado `nao_processados_no_caso` (e, com leitura marcada, `nao_lidos_por_voce`
também zerado), o caso está em dia: diga isso e não invente serviço.
Se `monitoramento.estado` for `desligado` e o caso é de tribunal coberto (TJSP, TJRJ, TJMG, TJSC, JFSC), guarde para o
fechamento: você vai **oferecer ligar** (ver passo 12). Se for `sem_certificado`
ou `certificado_expirado`, uma linha no fechamento dizendo que o administrador
resolve em Configurações → Certificado digital — e siga. Se for `erro`, uma
linha com `monitoramento.ultimo_erro` e siga sem tentar consertar.

**`lendo` ou `na_fila` — a primeira leitura ainda está correndo.** É o estado
normal logo depois de `abrir-caso`: o robô ainda não trouxe o histórico, e a
linha do tempo deste caso está incompleta DE VERDADE, não porque não há nada.
Diga que a plataforma ainda está lendo o processo no tribunal, há quanto tempo
(`monitoramento.ativado_em`) e para voltar em alguns minutos — **não trate como
caso sem histórico** nem ofereça registrar fato manualmente para preencher o
vazio. É o que sustenta a promessa que `abrir-caso` faz no fechamento ("me
pergunte 'o que aconteceu no caso X'"): se você tratar `lendo`/`na_fila` como
"nada aconteceu", essa promessa quebra na primeira vez que alguém volta.

Não chame `caso_listar_linha_tempo` "para conferir" — os contadores já são a
conferência, e a varredura custa contexto do usuário.

Leia a `cobertura` da resposta e repasse o que ela disser — ela é o que separa
"não há nada" de "não olhamos".

### 3. Ofereça — e **pare de verdade**

Havendo `nao_processados_no_caso > 0`, `nao_lidos_por_voce > 0` (só faz sentido
com `leitura_pessoal_marcada: true`) ou `desatualizado: true`, **avise e
pergunte**, em uma ou duas linhas:

> "Há 3 andamentos neste caso que você ainda não viu, 1 deles ainda não tratado
> por ninguém do escritório. Quer que eu leia e te diga o que mudou?"

Sem leitura marcada (`leitura_pessoal_marcada: false`), fale só pelo que é
pendência de verdade:

> "Este caso tem 1 andamento ainda não tratado por ninguém do escritório. Quer
> que eu leia e te diga o que é?"

Então **pare e espere a resposta**. Não emende a leitura na mesma mensagem, não
"adiante enquanto isso", não processe "só os dois primeiros para ganhar tempo".

**Recusa não marca nada.** Se o usuário disser "agora não", "depois", "só me
avisa que existe", você **não chama `caso_marcar_lido`, não chama
`caso_marcar_processado`, não chama `caso_regravar_briefing`**. A novidade tem
que continuar exatamente lá na próxima conversa. Este é o erro mais fácil de
cometer e o mais difícil de perceber depois: uma marcação indevida não dá erro,
só faz o andamento sumir para sempre da vista do advogado.

Se o usuário perguntou por outra coisa neste mesmo caso (uma tese, um prazo),
responda o que ele perguntou, mencione a novidade em uma linha e **ofereça** —
não sequestre a conversa.

### 4. Autorizado: leia o que entrou — o material primeiro

Antes de listar, olhe `nao_processados_materiais` no briefing: é quantos dos
não tratados são **decisão, peça, gatilho de prazo ou marco**. Um processo que
acabou de entrar pelo robô do tribunal traz 180 linhas e 15 importam — o resto
é expediente (remessa, conclusão, termo, guia). **Não leia os 180.**

`caso_listar_linha_tempo` com `desde_ultima_leitura: true` — que agora é a **sua**
leitura, a pessoal. É a pergunta do usuário, traduzida: *o que eu ainda não vi?*
O filtro de relevância já vem em `"materiais"`, então a lista chega só com o
que importa; o expediente que ficou de fora volta em `expediente_resumo` (um
período contíguo por linha: "6 entre 20/02 e 06/03"), para você saber que
existe sem carregá-lo. Cada fato volta com `relevancia`
(decisão/peça/**gatilho**/expediente), `documento_ids` e `pecas` — nome, tipo,
páginas e o **resumo de uma linha** de cada peça, quando alguém já a leu. O
expediente você trata em lote no passo 9, com uma nota curta.

**Gatilho de prazo é o dies a quo — confira o prazo a partir dele.** Certidão
de publicação, intimação ou citação certificada/confirmada, AR juntado,
ciência, "decorrido prazo": não há peça a ler ali, mas é NESSE fato que o
relógio começa, não na decisão que ele comunica. Decisão sem gatilho
correspondente ainda não começou a correr — diga isso em vez de chutar a data.

**O robô já leu a peça e já opinou sobre a rodada — como HIPÓTESE.** Fatos de
origem automação podem vir com `analise_sugerida`: classificação, marco
sugerido, direção, e quantas âncoras (trechos literais que o modelo copiou da
peça) a plataforma conseguiu casar com o texto. `ancoras_conferidas: "4/4"`
prova que ele não inventou a citação — **não** que ele entendeu certo. Leia a
sugestão para saber ONDE olhar, confira contra a peça, e siga: onde você
discordar, a sua leitura vale e sobrescreve a dele.

Se a peça já veio com `resumo` gravado pelo pipeline e ele está certo, **não o
reescreva** — siga para o que importa. Para cada fato material cuja peça veio
sem `resumo`, ou cujo resumo você considerou errado, abra-a com
`caso_obter_documento` (`secao: "texto_integral"`,
paginado, ≤10 páginas por chamada — a sentença, o acórdão, a decisão de
tutela, a petição da contrária; expediente de uma página não precisa) e grave o
que leu com **`caso_atualizar_documento`**: `resumo_linha` (UMA frase, voz
ativa, o que a peça é e o que decide/pede), `tipo` correto e, se houver, o
`dispositivo` literal. A linha é propagada ao fato da linha do tempo; a partir
daí `caso_listar_documentos` e `caso_listar_linha_tempo` passam a dizer QUAL
decisão, para você na próxima conversa e para os colegas. Prazo que a peça abre
vai em `caso_registrar_prazo`; marco, em `caso_atualizar_fato` (passo 5). Uma
peça lida e não gravada é leitura que evapora — e o advogado paga de novo na
próxima conversa.

**Quando a peça não está no acervo, diga isso — e diga por quê.** Cada fato traz
`peca`. `peca.esperada: true` com `peca.status` diferente de `baixada` quer
dizer que **havia peça naquele andamento e nós não a temos**: não conclua pelo
título (a "Petição Juntada" de 19/08 pode ser a contestação). `peca.rotulo` já
vem em português, e `peca.na_fila` decide a sua frase: `true` = o robô tenta de
novo sozinho nos próximos dias (avise e siga); `false` = a tentativa automática
acabou e só o humano resolve — e o que ele faz depende do motivo (receber a
intimação no `gate_intimacao`, abrir pelo e-SAJ na `allowlist`, nada a fazer em
`restrito`). `status: 'desconhecido'` é fato antigo: diga "não sei se havia
peça", nunca "não havia". `status: 'ilegivel'` é o inverso — a peça ESTÁ aqui,
sem camada de texto: ofereça `caso_baixar_documento`.

Nunca prometa ao advogado uma peça que o acervo não tem. E, no briefing,
`monitoramento.pecas_devendo` é o aviso agregado da mesma coisa: havendo peça
devendo, diga antes de afirmar que leu o caso inteiro.

Se o advogado pedir **o documento** — "me manda o arquivo", "quero o PDF da
decisão" —, isso não é `caso_obter_documento`: é **`caso_baixar_documento`**,
que devolve uma `url_download` do arquivo original. Baixe os bytes e entregue o
arquivo na conversa. Nunca monte um PDF com o texto extraído e o apresente como
a peça dos autos — é transcrição com ruído de OCR com cara de documento oficial,
e ele pode protocolar isso. Sem arquivo guardado (`tem_arquivo: false`), diga o
motivo e ofereça o link oficial do tribunal.

Se o seu ambiente permitir **subagentes**, a mesma regra
vale do seu lado: para ler uma sentença de 20 páginas ou cruzar três decisões,
despache um agente com modelo menor e peça de volta só o estruturado (fatos,
dispositivo, teses, dispositivos legais citados, lacunas) — e faça você a
síntese e as decisões. O contexto do advogado é o recurso caro; o volume roda
fora dele.

Se o interesse for o que está pendente de tratamento pelo escritório (o número que
veio em `nao_processados_no_caso`), use `apenas_nao_processados: true`. Cada fato
volta com `processado_em` e `processado_por`: fato já processado por um colega
você **lê e reporta**, mas não reprocessa — a análise dele já está no acervo.

**"O que chegou/atualizou hoje (ou desde X)?" é uma pergunta sobre CAPTURA, não
sobre quando o fato aconteceu — e é o erro mais fácil de cometer aqui.** Use
`capturado_desde` (não `desde`, que filtra `ocorrido_em`): o robô pode ler o
e-SAJ hoje de manhã e trazer uma movimentação **datada de ontem** — para quem
pergunta "o que chegou hoje", isso conta, mesmo que `ocorrido_em` seja de
véspera. Reporte o que foi capturado **mesmo que já esteja processado** (a
primeira leitura marca sozinha, sem e-mail): cite a `processado_nota` em vez de
dizer que não chegou nada. `monitoramento.houve_atualizacao: true` combinado
com fato já processado **não é** "o robô não trouxe nada" — é "trouxe, e já foi
tratado"; a resposta errada aqui foi exatamente confundir isso com "sem
novidade".

Se vier vazia, a resposta é "nada novo desde <data>" — e isso **é** uma resposta
útil, não um fracasso. Repasse a `cobertura`. Se o usuário quiser o quadro
completo e não só o delta, chame de novo sem o filtro, ou com `desde`.

Para os fatos que importam, `caso_obter_fato` traz o conteúdo integral. Não puxe
o integral de tudo: o resumo da lista resolve a maioria, e o integral custa
contexto.

### 5. Classifique cada novidade — três perguntas

Para cada fato novo, responda:

1. **É material?** Muda o que o escritório pode sustentar, o prognóstico, o valor
   em jogo ou a estratégia? Despacho de mero expediente não é material.
   Saneamento, decisão, juntada de laudo, contestação, sentença são.
2. **É marco?** Se sim, o usuário precisa saber disso primeiro, no topo do
   relatório, antes de qualquer análise.
3. **Cria prazo?** Comece por `caso_listar_prazos`, que devolve **duas listas**:
   `prazos` é a agenda de verdade; `prazos_sugeridos` é o que o robô detectou e
   ninguém confirmou — não conta em "o que vence essa semana" até você decidir.
   - Para cada sugestão: ache a **âncora** citada no `fundamento` dentro da peça,
     confira se o prazo é **nosso** (campo `de_quem`) e se a contagem bate (dias
     úteis × corridos, termo inicial), e chame `caso_decidir_prazo_sugerido` —
     `confirmar` (com `vence_em` corrigido junto, se só a data estiver torta) ou
     `descartar`, sempre com o motivo do que você conferiu. **Nunca confirme sem
     abrir a peça.**
   - Prazo que o robô **não** viu e existe: `caso_registrar_prazo`, com
     `fundamento` (de onde sai o prazo) e `vence_em` quando você tiver a data com
     segurança. **Não estime data de vencimento por inferência de contagem sem
     dizer que é estimativa.**

Novidade não material entra no relatório em uma linha, sem consumir consulta às
bases. **Não gaste chamada de amparo em andamento burocrático.**

### 6. Amparo — só para o que é material

Para cada novidade material, o passo 1 do roteamento: `buscar_qualificada` (com
`status_vigencia` conferido), depois a lei (`obter_dispositivo_legal`,
`obter_alteracoes_norma` se a redação mudou no período dos fatos), depois
acórdãos (`buscar_hibrida`).

A pergunta aqui não é "o que existe sobre o tema" — é **"o que essa novidade faz
com as teses que já estão no acervo?"**. Chame `caso_listar_teses` antes de
buscar: uma decisão que acolhe o pedido de perícia não muda a tese de
prescrição, e uma que fixa o ponto controvertido pode derrubar três.

`caso_listar_teses` também devolve `teses_sugeridas` — o que a leitura
automática da primeira leitura propôs (com `por_que`, o raciocínio, e
`ancora_trecho`, o trecho literal do dossiê que sustentou a leitura) e ninguém
decidiu ainda. Havendo alguma, decida-as agora, uma a uma: confira o
`ancora_trecho` contra o processo (`caso_listar_linha_tempo`/
`caso_obter_documento`) e chame `caso_decidir_tese_sugerida` — `confirmar`
(aceita `mudancas` com `enunciado`/`amparo`/`polo` corrigidos na mesma
chamada, se a leitura entendeu torto) ou `descartar`, sempre com `motivo` do
que você conferiu. **Nunca registre de novo com `caso_registrar_tese`** — isso
duplicaria a linha e perderia a âncora e o raciocínio original.

### 7. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: classifique as teses que a novidade tocou só pelo
amparo, `posicao_juizo: sem_cobertura`, não peça o juiz. Não chame
`resolver_juiz` nem `analisar_jurisprudencia`, mesmo com `magistrado_nome`
resolvido no briefing.

### 8. Escreva de volta — o passo que quase todo mundo pula

O que você descobriu nesta conversa e não gravou, evapora. Antes de reportar:

- `caso_registrar_fato` — o teor da novidade, com `ocorrido_em`, `tipo`,
  `link_fonte` quando houver, e `eh_marco` quando for. Se o fato já está na linha
  do tempo (veio da automação), **não duplique**: a sua contribuição é a análise,
  não a cópia.
- `caso_registrar_tese` — tese nova que a novidade abriu, com `enunciado` como
  proposição verificável (nunca "tema"), `amparo`, `fontes` com `link_oficial`, e
  `motivo` **obrigatório**. A célula volta calculada; repasse-a ao usuário.
- `caso_atualizar_tese` — tese existente que a novidade mudou de patamar
  (`amparo`, `posicao_juizo`, `status`). Também com `motivo` obrigatório: sem
  motivo a mudança não acontece, por contrato. O retorno traz `celula_anterior` e
  `celula_nova` — a virada de célula é a notícia.
- `caso_gravar_memoria` — decisão estratégica tomada nesta conversa (`decisao`),
  contexto que só existe aqui (`contexto`), orientação que o usuário deu e que
  deve valer daqui em diante (`instrucao`), ou a **hipótese** do parágrafo
  abaixo.
- `caso_registrar_prazo` — o que o passo 5 identificou.

Se `sugestoes` (passo 2) ou `caso_obter_memoria` trouxe `itens_sugeridos` —
decisão, contexto ou hipótese que a leitura automática anotou e ninguém
confirmou —, decida-os agora, um a um: confira o `ancora_trecho` (o trecho
literal do dossiê) contra o processo e chame `caso_decidir_memoria_sugerida` —
`confirmar` (aceita `mudancas` com `titulo`/`corpo` corrigidos na mesma
chamada) ou `descartar`, sempre com `motivo`. **Confirmar uma hipótese
sugerida não a fecha nem cria tese** — ela entra como hipótese aberta comum, a
fechar depois com `caso_fechar_hipotese` quando a resposta chegar. **Nunca
registre de novo com `caso_gravar_memoria`** — isso duplicaria a linha e
perderia a âncora.

**O raciocínio que não fechou em tese vira hipótese, não vira nada.** Você leu o
saneamento e ficou com a impressão de que o juiz está encaminhando para prova
pericial; não tem amparo levantado, não tem fonte, não é tese — é conjectura de
trabalho. `caso_gravar_memoria` com `tipo: "hipotese"` e `desfecho: "aberta"`,
dizendo em que você se baseou. Na próxima conversa sobre este caso, ela vai
estar lá esperando o andamento que a confirma ou derruba. Perder isso é o
desperdício mais silencioso do produto: ninguém percebe que perdeu.

Confirmar a hipótese **não** a transforma em tese. Se a conjectura se confirmou e
o escritório vai sustentá-la, aí é levantar o amparo (passo 6) e chamar
`caso_registrar_tese` com fontes e motivo.

**Você grava direto, e diz o que gravou.** Não há rascunho nem fila: o registro
está valendo assim que a tool retorna. Por isso a linha de fechamento não é
formalidade — é o momento em que o advogado, que está aqui, vê o que você
escreveu e corrige de graça.

**Errou? Corrija o registro, não escreva outro.** Data errada, polo trocado,
`eh_marco` que não era marco, memória com o tipo errado: `caso_atualizar_fato`,
`caso_atualizar_memoria`, `caso_atualizar_tese`. A versão anterior fica no
histórico com o motivo, então corrigir não apaga nada — e o retorno traz
`versao_anterior` e `versao_nova` para você dizer o que mudou. Um segundo
registro contradizendo o primeiro é ruído: divergência entre pessoas o acervo
guarda de propósito, mas erro seu ele só acumula até o advogado parar de confiar
na tela.

### 9. Marque o que foi tratado — uma nota por andamento, não um checkbox

`caso_marcar_processado` com o `caso_titulo` (o título do caso, de
`caso_resolver`/`caso_obter_briefing` — o servidor confere contra o `caso_id`),
o `caso_id` e **`itens`: um por fato que você efetivamente tratou, cada um com
a SUA `nota`**. A nota não é burocracia: ela é o registro de que aquilo foi
olhado por alguém e **o que se decidiu ali**. Daqui a três meses ela é a única
coisa que separa "ninguém viu" de "vimos e não era nada".

**A nota é daquele andamento, não do lote.** Ela aparece naquele ponto da linha
do tempo, e é assim que o advogado a lê. A mesma frase repetida em dez cartões
seguidos ele lê como defeito do sistema — e não é: é a nota do lote no lugar
errado. Para a leitura do conjunto existe `nota_lote`, que abre o e-mail da
equipe e não se repete cartão a cartão.

Escreva a conclusão, não o rótulo. Ruim: "processado". Bom: "saneamento fixou os
pontos controvertidos e afastou a preliminar de ilegitimidade — a tese de
ilegitimidade da matriz vai para `abandonada`; prazo de 15 dias para especificar
provas".

O expediente também se marca, na mesma chamada: é o que zera a fila sem fingir
que alguém leu 165 certidões. Mas dê a cada um a sua linha — "certidão de
decurso do prazo da ré", "juntada da guia de custas", "publicação da decisão de
06/04, que é a que conta o prazo" —, não o mesmo "expediente do cartório, nada a
fazer" 165 vezes. Quando o expediente for de fato indistinguível, uma frase
igual para todos é aceitável: a tela agrupa e mostra uma vez.

Regras:

- Só marque o que você tratou de fato. Fato que você leu de raspão e não
  analisou **fica sem marca** — é honesto, e alguém vai tratar depois.
- Fato já processado por um colega volta em `ja_estavam`; a tool é idempotente,
  então não há mal em incluí-lo, mas a nota que vale é a de quem tratou primeiro.
- Marcar processado **não** move a leitura de ninguém — nem a sua, nem a dos
  colegas. Os dois relógios são separados.

Se o trabalho foi material e o briefing veio `desatualizado`, chame
`caso_regravar_briefing` com o `caso_titulo` (título do caso, de
`caso_resolver`/`caso_obter_briefing` — o servidor confere contra o `caso_id`)
e um `motivo` curto ("sentença de improcedência parcial e queda da tese de
ilegitimidade"). O retorno traz `versao` e `versao_anterior` — cite as duas ao
usuário. Se nada material mudou, **não
regrave**: briefing regravado sem motivo material só gera versão nova sem
notícia nova.

### 10. Reporte em três blocos

Nesta ordem, e com estes nomes:

**O QUE MUDOU** — os fatos novos, marco primeiro, cada um com data, origem
(automação/IA/humano) e link da fonte quando houver. Fato não material em uma
linha. Se nada mudou, diga isso na primeira linha e não encha o relatório.

**O QUE SIGNIFICA** — a leitura jurídica: quais teses foram afetadas, a célula
antes e depois, o amparo com vigência conferida e link oficial (o eixo do foro
está em pausa — toda tese sai `sem_cobertura` no juízo). O que ficou **sem
cobertura** entra aqui, declarado — não vira conclusão. O link é o que veio no
resultado do amparo, **clicável e aqui na conversa** — tê-lo gravado nas `fontes`
da tese não dispensa mostrá-lo; nunca URL montada de memória; se `link_aviso`
disser que pode não abrir, mostre com o aviso e o `link_pesquisa_geral`.

**O QUE FAZER** — ações concretas com prazo: peça a redigir, prazo a cumprir,
decisão que o usuário precisa tomar, documento que falta. Priorize por data. Se
não há ação, diga que não há. As **hipóteses que continuam abertas** entram aqui,
como perguntas em aberto — não como conclusões.

E a **linha de fechamento**, obrigatória: o que você gravou no acervo, quantos
fatos marcou como processados, se o briefing foi regravado — e o convite à
correção.

> "Gravei: 1 fato (saneamento, marco), atualizei a tese de ilegitimidade para
> `abandonada`, 1 prazo (15 dias, especificar provas) e fechei a hipótese da
> perícia como confirmada. Marquei 3 fatos como processados e regravei o briefing
> (v4 → v5). Me diga se algo ficou errado que eu corrijo."

### 11. Só agora: marque a leitura

`caso_marcar_lido` com o `caso_titulo` (título do caso, de `caso_resolver`/
`caso_obter_briefing`) e o `caso_id` — **depois** de o relatório ter saído,
nunca antes. Marcar leitura sem ter reportado é mentira que apaga a novidade do
advogado: o contador zera, o andamento nunca mais aparece como novo, e ninguém
descobre o que se perdeu.

Se você reportou só parte (o usuário mandou parar no meio, ou você tratou só os
marcos), use `ate` com o instante do último fato que você **efetivamente
reportou** — não o de agora. Cobrir com a marca o que não foi lido é o mesmo erro
em versão mais discreta.

Reportou nada porque não havia nada? Marque assim mesmo: o usuário abriu o caso e
o quadro dele está em dia.

### 12. Monitoramento — ofereça uma vez, no fechamento

Caso de tribunal coberto nasce monitorado; `desligado` é exceção (alguém desligou, ou o caso
é anterior ao padrão). Se o briefing veio com `monitoramento.estado = "desligado"` e o caso é de
tribunal coberto (TJSP (`….8.26.….`), TJRJ (`….8.19.….`), TJMG (`….8.13.….`), TJSC (`….8.24.….`) e JFSC (`….4.04.72xx`)), **uma linha**, depois do relatório:

> "Este caso não está sendo monitorado no tribunal. Quer que eu ligue? O robô do
> escritório passa a ler o processo todo dia às 06h e o que chegar aparece aqui
> como novidade — eu leio e te conto, ou a rotina agendada trata de manhã."

Sim → `caso_ativar_monitoramento`. "Agora não" → não insista nesta conversa.
Nunca ligue sem o usuário pedir. Se a resposta da tool disser que o escritório
não tem certificado, diga isso em uma linha (é o administrador quem cadastra) e
siga.

Se o escritório já tem casos monitorados e o usuário ainda não tem a rotina,
**uma vez** — não a cada conversa —: **crie** a tarefa agendada (dias úteis, de
manhã) que roda `processar-atualizacoes`, com a ferramenta de tarefas agendadas
do ambiente, para que o que o tribunal trouxer seja tratado sem ninguém abrir a
máquina. O **card** da tarefa é o convite — o advogado aprova, muda a hora ou
apaga num clique —, e uma linha sua diz o que foi criado e como desligar. O
e-mail da equipe sai daí.

## Critério de parada

Pare quando o usuário tiver o quadro do que mudou — ou quando ele tiver recusado
o processamento. Não varra a linha do tempo inteira para "contextualizar": o
briefing já é o contexto e os contadores já dizem se há trabalho. Não busque
amparo para "reforçar" tese já sustentada.

## Erros a não cometer

- **Processar sem autorização.** Ver `nao_processados_no_caso > 0` (ou
  `nao_lidos_por_voce > 0`) não é ordem de serviço: ofereça e espere.
- **Anunciar `nao_lidos_por_voce` como "acumulado" ou "pendente do caso".** É
  informativo e é sobre você; a pendência é `nao_processados_no_caso`.
- **Inventar um número de não lidos quando `nao_lidos_por_voce` vier `null`.**
  `leitura_pessoal_marcada: false` significa "sem contagem para mostrar", não
  "zero" nem "use `nao_processados` no lugar".
- **Responder "o que chegou hoje?" olhando `ocorrido_em`.** Use
  `capturado_desde`: o robô pode capturar hoje um fato datado de ontem, e um
  fato já `processado_em` não é "o robô não trouxe nada" — é "trouxe, e já foi
  tratado" (cite a `processado_nota`).
- **Marcar qualquer coisa depois de uma recusa.** "Agora não" significa que a
  novidade continua lá, intacta, na próxima conversa.
- **Tratar erro de aprovação como se fosse recusa do usuário.** `caso_marcar_lido`
  (ou qualquer escrita) voltando com `No approval received` é o cartão de
  permissão expirando sem resposta — timeout do cliente, não decisão do
  advogado. Diga isso e ofereça tentar de novo; nunca narre como "sem
  problema, não marquei" (ver `references/areas-e-roteamento.md`).
- **Marcar lido antes de reportar** — ou marcar lido cobrindo fato que você não
  reportou.
- **Marcar processado sem nota**, ou com nota que não diz o que se concluiu.
- **Marcar processado o que você não tratou** só porque leu o resumo na lista.
- Varrer a linha do tempo para descobrir se há novidade — os contadores do
  briefing já respondem isso.
- Regravar o briefing por movimentação burocrática.
- Prosseguir com caso não confirmado quando `caso_resolver` devolveu candidatos.
- Analisar sem ler o briefing — você opina sobre um caso que não conhece para
  quem conhece.
- Tratar `instrucoes_ativas` como sugestão.
- Gastar chamada de amparo em andamento burocrático.
- Duplicar na linha do tempo um fato que a automação já registrou.
- Registrar tese ou atualização sem `motivo`, ou tese sem fonte.
- **Recadastrar sugestão da leitura automática com `caso_registrar_tese`/
  `caso_gravar_memoria`** em vez de decidi-la com
  `caso_decidir_tese_sugerida`/`caso_decidir_memoria_sugerida` — duplica a
  linha e perde a âncora.
- **Gravar em silêncio.** O advogado está na conversa; se ele não souber o que
  você escreveu, perdeu o único momento em que corrigiria de graça.
- **Escrever um registro novo para corrigir um seu que saiu errado.** Edite
  aquele — `caso_atualizar_fato`, `caso_atualizar_memoria`,
  `caso_atualizar_tese`. A versão anterior fica guardada.
- Perder o raciocínio que não fechou em tese em vez de gravá-lo como hipótese.
- Reabrir um caso sem olhar as hipóteses abertas — e refazer a dúvida do mês
  passado do zero.
- Promover hipótese confirmada a tese sem levantar o amparo.
- Terminar sem a linha de fechamento — o usuário fica sem saber o que o
  escritório passou a saber.
- Converter "sem registros no período" em "não aconteceu nada".
