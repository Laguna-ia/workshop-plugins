---
name: levantar-fundamentos
description: >
  Levanta o amparo jurídico de uma tese ou caso — tese firmada, legislação
  vigente e acórdãos (a calibragem por magistrado está em pausa). Porta de
  entrada de qualquer pergunta jurídica que não seja pedido direto de peça:
  "existe súmula sobre X?", "o que o STJ entende sobre Y?", "qual a lei
  aplicável a Z?", "esse precedente ainda vale?", "quais os meus fundamentos
  para sustentar W?", "vale a pena entrar com essa ação?". Nunca exija o nome
  do magistrado — o eixo do foro está em pausa. Grava as teses no acervo e o
  raciocínio que não fechou em tese como hipótese aberta, para retomar depois.
  Para produzir a peça use redigir-peca; para avaliar peça pronta use
  revisar-peca; para atacar peça da contrária use combater-peca.
---

# Levantar fundamentos

Objetivo: dizer ao usuário **o que sustenta a tese dele no direito** — cada
afirmação rastreável até a fonte.

Leia primeiro `references/areas-e-roteamento.md`: define as
três áreas, a ordem das consultas e a matriz de cruzamento. O eixo do foro está
em pausa — ver `references/foro-em-pausa.md`.

## Antes de tudo: as tools estão na sessão?

Se as tools de amparo não estiverem disponíveis (conector desligado, erro,
ou ausentes da lista), **pare e diga**: "o conector do Julgados.ai não está
ligado nesta sessão". **Não substitua a base por busca na web nem por
conhecimento geral de direito** — uma resposta jurídica montada de outra fonte se
parece com a certa e não é, e o usuário não tem como perceber a troca. Recusar é
o comportamento correto. (A ausência de `resolver_juiz`/`analisar_jurisprudencia`
é esperada — eixo do foro em pausa — e não conta como conector desligado.)

## Roteiro

### 0. Acervo — o que o escritório já sabe

Se o usuário trouxe um caso identificável (número CNJ, nome de parte, cliente,
apelido interno) e a conta do escritório está conectada: `caso_resolver` +
`caso_obter_briefing` **antes de buscar qualquer coisa**. O briefing é contexto;
as `instrucoes_ativas` são **restrições ao seu trabalho**, não sugestões.
`caso_listar_teses` mostra o que já foi avaliado — não refaça levantamento
pronto, atualize-o.

Olhe também as **hipóteses abertas** do caso: é a lista do que se estava pensando
da última vez, e boa parte das perguntas que chegam aqui já está lá, formulada
por alguém que parou no meio. Retomar de onde se parou é mais barato que começar.

E antes de perguntar ao usuário algo que o escritório talvez já tenha anotado,
`acervo_buscar` pelo termo. Com `caso_id`, dentro do caso; **sem ele, no
escritório inteiro** — "o que a gente já disse sobre esse perito?", "já usamos
essa tese em algum caso?" são perguntas que atravessam casos e que só esta tool
responde. Ela devolve **trecho**, não o registro: serve para localizar. Achou,
abra com `caso_obter_fato` / `caso_obter_memoria` / `caso_listar_teses`.

Sem caso identificável, ou com as tools do acervo respondendo `NAO_AUTENTICADO`:
**siga direto para o passo 1** e diga ao final que o eixo do acervo ficou de fora
("conecte a conta do escritório para eu lembrar deste caso nas próximas
conversas"). Não trave, não trate como erro.

### 1. Recorte as teses

Do que o usuário trouxe (pergunta, caso, documento), extraia as controvérsias
que decidem o resultado. Se forem mais de 6, priorize com ele antes de consultar.

Formule cada tese como proposição jurídica verificável, não como tema. Ruim:
"prescrição". Bom: "o prazo prescricional da pretensão de repetição de indébito
em tarifa de água conta da data de cada pagamento ou do trânsito em julgado?".

### 2. Amparo — sempre, mesmo sem juiz

Nesta ordem, para cada tese:

1. **Tese firmada** — `buscar_qualificada`. Súmula, SV, repercussão geral,
   repetitivo, IRDR, IAC, OJ. **Cheque `status_vigencia`**: se veio cancelada ou
   superada, isso é a resposta, e você diz isso — não procure outra que
   confirme o que o usuário quer ouvir.
2. **Lei** — havendo dispositivo em jogo: `buscar_norma_por_numero` ou
   `buscar_norma_por_nome`, depois `obter_dispositivo_legal` para o texto
   vigente. Se a redação mudou no período dos fatos, `obter_alteracoes_norma`.
3. **Acórdãos** — `buscar_hibrida` por padrão; `buscar_semantica` se a pergunta
   for conceitual; `buscar_fts` para citação literal ou numérica;
   `buscar_por_cnj` se o usuário deu número de processo.

Pare de buscar quando tiver tese firmada vigente + base legal + 2 ou 3 acórdãos
convergentes. Buscar mais depois disso não muda a resposta.

### 3. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: não chame `resolver_juiz` nem `analisar_jurisprudencia`,
não peça o nome do juiz. Se o usuário perguntar como um juiz costuma decidir
isso, uma linha: o eixo está em pausa por cobertura, e a resposta segue pelo
amparo.

### 4. Cruze e classifique

Cada tese cai numa célula da matriz. Com `posicao_juizo: sem_cobertura`, ela
sai `amparo_solido_juizo_aberto` (amparo forte), `desconhecido` (amparo fraco
ou não coberto) ou `descarte` (amparo contra nós) — marque a célula
explicitamente e diga que o eixo do foro está em pausa.

### 5. Entregue

1. **Resposta direta** — em 2 ou 3 frases, o que sustenta e o que não sustenta.
2. **Tese a tese** — amparo (com vigência e link oficial) e a célula da matriz.
3. **Riscos** — precedente superado, redação de lei alterada, ausência de
   cobertura.
4. **Próximo passo** — ofereça a peça (`redigir-peca`), se o usuário quiser
   avançar.

**O link vai na conversa, junto de cada citação** — o que veio no resultado
(`link_completo`), clicável, nunca montado de memória. Gravar as fontes no acervo
(passo 6) **não substitui** mostrá-las aqui. `link_status`/`link_aviso` avisando
que o direto pode não abrir: mostre mesmo assim, com o aviso e o
`link_pesquisa_geral`. Sem link no resultado, cite sem link — ver "O link da fonte aparece na conversa" em
`references/areas-e-roteamento.md`.

### 6. Escreva de volta no acervo

Havendo caso identificado e conta conectada, o levantamento não pode morrer na
conversa — **o que não é gravado, evapora**. `caso_registrar_tese` (ou
`caso_atualizar_tese`, se a tese já existia e mudou de patamar) para cada tese
decisiva, com `amparo`, `fontes` com link oficial e `motivo` obrigatório;
`caso_gravar_memoria` para decisão estratégica ou instrução que o usuário deu
aqui.

**E o raciocínio que não fechou em tese vira hipótese, não vira nada.** Este é o
fluxo em que isso mais acontece: você levanta o amparo, a busca não fecha, e
sobra uma linha de pensamento com forma mas sem fonte — *"a distinção entre
tarifa e preço público talvez sirva aqui, mas não achei nada firmado"*, *"parece
que o tribunal está migrando de entendimento; três acórdãos recentes vão contra a
súmula"*. Isso não é tese (sem amparo, cairia na célula `desconhecido` e pareceria
pesquisa que falhou) e não é contexto (não é fato do mundo). É
`caso_gravar_memoria` com `tipo: "hipotese"` e `desfecho: "aberta"`, dizendo em
que você se baseou e o que faltou para fechar.

Fechando uma hipótese que já existia — porque agora o amparo apareceu, ou porque
a busca a derrubou — `caso_fechar_hipotese` com `caso_titulo` (o título do caso,
de `caso_resolver`/`caso_obter_briefing` — o servidor confere contra o caso da
hipótese) e `desfecho: "confirmada"` ou `"descartada"`. **Confirmar não promove a tese:** promover exige o amparo
levantado e `caso_registrar_tese` com fontes e motivo. Conjectura que virou tese
sem passar por aqui é o pior registro do acervo — parece verificada e não é.

**Você grava direto, e diz o que gravou.** Não há rascunho nem fila de revisão: o
registro está valendo quando a tool retorna. Feche em **uma linha** dizendo o que
gravou e convidando a correção:

> "Gravei: 2 teses (uma âncora, uma em conflito) e 1 hipótese aberta sobre a
> virada do TJ. Me diga se algo ficou errado que eu corrijo."

Errou? **Corrija o registro** — `caso_atualizar_tese`, `caso_atualizar_memoria`,
`caso_atualizar_fato` — em vez de gravar outro contradizendo o primeiro. A versão
anterior fica no histórico com o motivo, então corrigir não apaga nada; o que
estraga o acervo é acumular ruído até o advogado deixar de confiar na tela.

## Critério de parada

Pare quando cada tese decisiva tiver amparo verificado (ou ausência declarada),
a célula da matriz atribuída, e o que não fechou em tese estiver gravado como
hipótese. Não continue buscando para "reforçar" tese já sustentada.

## Erros a não cometer

- Pedir o nome do magistrado. O eixo do foro está em pausa; a área do amparo
  nunca dependeu dele.
- Chamar `resolver_juiz` ou `analisar_jurisprudencia` — ver `foro-em-pausa.md`.
- Citar precedente sem checar `status_vigencia`.
- **Citar na conversa sem o link que veio no resultado** — inclusive quando o
  mesmo link foi gravado nas fontes da tese. E o inverso: inventar a URL.
- Apresentar conhecimento geral de direito como se tivesse vindo das bases.
- Perguntar ao usuário o que `acervo_buscar` responderia — o que o escritório já
  anotou, ele não deveria ter de digitar de novo.
- **Deixar o raciocínio que não fechou morrer na conversa** em vez de gravá-lo
  como hipótese.
- Registrar conjectura como tese só porque ela tem forma de tese.
- Promover hipótese confirmada a tese sem levantar o amparo.
- **Gravar em silêncio.** O usuário está aqui; é agora que ele corrige de graça.
