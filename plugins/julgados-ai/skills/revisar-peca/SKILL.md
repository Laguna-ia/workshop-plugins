---
name: revisar-peca
description: >
  Avalia uma peça já escrita pelo usuário contra o amparo real — tese firmada,
  lei vigente, acórdãos (a calibragem por magistrado está em pausa). Acione
  quando o usuário trouxer a peça DELE e pedir avaliação — "revisa minha
  petição", "quais os pontos fracos da minha peça", "meus precedentes ainda
  valem?", "confere se essas citações existem". Confere as citações da peça
  contra a fonte oficial e classifica cada tese na matriz amparo × juízo — hoje
  só a coluna sem cobertura, eixo do foro em pausa. NÃO reescreve a peça sem o
  usuário pedir. Para peça nova use redigir-peca; para peça da parte contrária
  use combater-peca.
---

# Revisar a peça do usuário

Objetivo: dizer ao usuário, com evidência, o que na peça dele se sustenta no
direito, e o que está citado errado — antes de protocolar.

Leia `references/areas-e-roteamento.md`. O eixo do foro
está em pausa — ver `references/foro-em-pausa.md`.

## Antes de tudo: as tools estão na sessão?

Se as tools de amparo não estiverem disponíveis (conector desligado, erro,
ou ausentes da lista), **pare e diga**: "o conector do Julgados.ai não está
ligado nesta sessão". **Não substitua a base por busca na web nem por
conhecimento geral de direito** — uma resposta jurídica montada de outra fonte se
parece com a certa e não é, e o usuário não tem como perceber a troca. Recusar é
o comportamento correto. (A ausência de `resolver_juiz`/`analisar_jurisprudencia`
é esperada — eixo do foro em pausa — e não conta como conector desligado.)

## Roteiro

### 0. Acervo — o caso já está no escritório?

Se a peça permite identificar o caso (número CNJ no cabeçalho, partes, cliente) e
a conta do escritório está conectada: `caso_resolver` + `caso_obter_briefing`
antes de avaliar. Revisar peça sem o briefing é criticar decisão estratégica sem
saber que ela foi tomada — e `decisoes` costuma explicar por que a peça está
assim. As `instrucoes_ativas` são **restrições ao critério da revisão**: não
recomende o que o escritório já decidiu não fazer. `caso_listar_teses` diz quais
teses já têm célula atribuída, e evita que você reavalie do zero o que já foi
avaliado. As **hipóteses abertas** costumam explicar a parte da peça que parece
estranha: alguém estava testando uma linha e não fechou.

Antes de apontar como falta uma tese que a peça não usou, `acervo_buscar` pelo
termo — pode ser que ela já esteja registrada no caso, ou usada em outro caso do
escritório. Ela devolve trecho para localizar; abra o registro antes de concluir.

Sem caso identificável, ou com o acervo respondendo `NAO_AUTENTICADO`: **siga
para o passo 1** e diga ao final que o eixo do acervo ficou de fora ("conecte a
conta do escritório para eu lembrar deste caso nas próximas conversas"). A
revisão vale igual.

### 1. Extraia o que a peça JÁ sustenta

Liste as teses que ela efetivamente defende e as **citações** que ela faz
(súmulas, temas, acórdãos, artigos de lei). **Nesta etapa não invente teses
novas** — o usuário pediu avaliação do que escreveu. Mostre a lista e confirme
que você leu certo. Mais de 6 teses: priorize com ele.

### 2. Confira as citações contra a fonte

Antes de discutir mérito, verifique o que a peça afirma existir. Para cada
citação: `buscar_qualificada` (súmula/tema/SV), `buscar_por_cnj` (acórdão com
número), `buscar_fts` (citação literal), `obter_dispositivo_legal` (artigo).

Três vereditos, sempre explícitos:

- **CONFIRMADA** — existe, o teor bate e está vigente;
- **DESATUALIZADA** — existe, mas foi cancelada, superada ou teve a redação
  alterada. **Diga qual é a redação/tese vigente hoje.** É o achado mais urgente:
  peça com precedente superado perde por vício próprio;
- **NÃO LOCALIZADA** — não foi encontrada na fonte. Diga isso sem rodeio e sem
  presumir que existe fora da base.

### 3. Avalie o amparo de cada tese

`buscar_qualificada` → lei → `buscar_hibrida`. Uma tese pode estar bem citada e
ainda assim mal amparada; e pode estar mal citada e bem amparada (aí você corrige
a citação em vez de derrubar a tese).

### 4. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: não chame `resolver_juiz` nem `analisar_jurisprudencia`,
não peça o nome do juiz. Se o usuário perguntar se um juiz específico rejeita a
tese, uma linha: o eixo está em pausa por cobertura, e a avaliação segue pelo
amparo.

### 5. Classifique e entregue o veredito

Cada tese na matriz, com `posicao_juizo: sem_cobertura`:

- **ALINHADA / amparo sólido, juízo aberto** — amparo forte. Cite a tese
  firmada e diga que o eixo do foro está em pausa.
- **FRÁGIL** — amparo fraco. Avise que não sobrevive ao recurso e sugira
  ancorar em outra tese.
- **INSUSTENTÁVEL** — sem amparo, contra a jurisprudência dominante. Recomende
  retirar.
- **SEM COBERTURA** — a base não tem material sobre o tema. Diga explicitamente.

Formato da entrega:

1. **Resumo** — eixo do foro em pausa, nº de teses, quantas em cada
   classificação, e **quantas citações não confirmaram**.
2. **Citações** — tabela com veredito por citação e a correção quando houver.
3. **Tese a tese** — classificação, fundamento, fontes citáveis, sugestão de
   redação quando couber.
4. **O que falta** — teses com amparo forte no tema que a peça não usou.
   Separado da avaliação, como sugestão.
5. **Riscos não cobertos** — o que você não conseguiu avaliar e por quê.

Na tabela de citações e no tese a tese, cada fonte do amparo vai **com o link que
veio no resultado**, clicável — é por ele que o advogado confere o veredito.
Gravar no acervo não substitui mostrar; nunca URL montada de memória; se
`link_aviso` disser que o direto pode não abrir, mostre com o aviso e o
`link_pesquisa_geral`; sem link no resultado, cite sem link.

### 6. Escreva de volta no acervo

Havendo caso identificado e conta conectada, o veredito não pode ficar só na
conversa. `caso_registrar_tese` para a tese que a peça sustenta e ainda não
estava no acervo; `caso_atualizar_tese` quando a revisão mudou o patamar de uma
tese existente (precedente superado derruba o `amparo` de `forte` para `fraco`) —
sempre com `motivo` obrigatório, e o retorno traz `celula_anterior` e
`celula_nova`. Citação que não confirmou vira `caso_gravar_memoria` tipo
`contexto`: é achado que o escritório não pode redescobrir na próxima peça. A
peça revisada vale como `caso_anexar_documento`. **O que não é gravado, evapora.**

A dúvida que a revisão levantou e não resolveu — "essa citação não localizei, mas
pode ser erro de numeração da peça", "desconfio que o autor vai emendar" — é
`caso_gravar_memoria` tipo `hipotese`, `desfecho: "aberta"`. Não force como
`contexto` o que ainda é conjectura: contexto é fato do mundo, hipótese é *ainda
não sei e preciso voltar aqui*.

**Você grava direto, e diz o que gravou.** Feche em **uma linha**, enumerando, e
convide a correção:

> "Gravei: rebaixei a tese da prescrição de `forte` para `fraco` (Tema 1.199
> superado — célula passou de `amparo_solido_juizo_aberto` para `desconhecido`),
> 1 memória com as duas citações que não confirmaram, a peça anexada e 1
> hipótese aberta. Me diga se algo ficou errado que eu corrijo."

Errou? **Corrija o registro** (`caso_atualizar_tese`, `caso_atualizar_memoria`,
`caso_atualizar_fato`), não escreva outro por cima. A versão anterior fica no
histórico com o motivo.

## Limite de escopo

Não reescreva a peça. Ofereça trechos alternativos **dentro** da avaliação e
pergunte se o usuário quer que você aplique. Se ele pedir a reescrita, mude para
`redigir-peca`.

## Erros a não cometer

- Discutir mérito sem antes conferir se as citações existem e estão vigentes.
- Pedir o nome do magistrado, ou chamar `resolver_juiz`/`analisar_jurisprudencia`
  — o eixo do foro está em pausa (ver `foro-em-pausa.md`).
- Dizer "está bom" sem fonte citável por trás.
- Trocar a avaliação por uma peça nova sua.
- Registrar como `contexto` a conjectura que ainda não se verificou — isso é
  `hipotese`, com `desfecho: "aberta"`.
- **Gravar em silêncio** ou fechar sem enumerar o que mudou de patamar.
- **Corrigir um registro seu escrevendo outro por cima** em vez de editar aquele.
