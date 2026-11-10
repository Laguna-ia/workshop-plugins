---
name: redigir-peca
description: >
  Redige uma peça jurídica fundamentada no amparo real — tese firmada, lei
  vigente, acórdãos (a calibragem por magistrado está em pausa). Acione quando
  o usuário trouxer o caso dele e pedir uma peça nova — "escreve a petição
  inicial desse caso", "monta a contestação", "preciso de um recurso sobre Y".
  Redige pelo amparo — nunca exija o nome do juiz, o eixo do foro está em
  pausa. Escreve no molde do escritório (golden set). NÃO use para avaliar
  peça pronta (use revisar-peca) nem para atacar peça da parte contrária (use
  combater-peca).
---

# Redigir peça

Objetivo: entregar uma peça sustentada em amparo verificável — com cada
afirmação rastreável até a fonte (link oficial do precedente).

Leia `references/areas-e-roteamento.md` (as três áreas, a
ordem, a matriz). O eixo do foro está em pausa — ver
`references/foro-em-pausa.md`.

## Antes de tudo: as tools estão na sessão?

Se as tools de amparo não estiverem disponíveis (conector desligado, erro,
ou ausentes da lista), **pare e diga**: "o conector do Julgados.ai não está
ligado nesta sessão". **Não substitua a base por busca na web nem por
conhecimento geral de direito** — uma resposta jurídica montada de outra fonte se
parece com a certa e não é, e o usuário não tem como perceber a troca. Recusar é
o comportamento correto. (A ausência de `resolver_juiz`/`analisar_jurisprudencia`
é esperada — eixo do foro em pausa — e não conta como conector desligado.)

## Roteiro

### 0. Acervo — situe-se antes de escrever

Se o caso é identificável (número CNJ, parte, cliente, a peça que o usuário
colou) e a conta do escritório está conectada: `caso_resolver` +
`caso_obter_briefing` **antes de decompor o caso**. O briefing dá `onde_estamos`,
`decisoes` já tomadas e `ameacas` — escrever peça sem isso é reabrir discussão
fechada. As `instrucoes_ativas` são **restrições à peça**, não sugestões: se uma
delas diz para não fazer da prescrição o eixo do agravo, a peça não faz. Vale
puxar também `caso_listar_teses` (o que já foi avaliado, com a célula) e
`caso_listar_documentos` (o que já está nos autos).

Olhe as **hipóteses abertas** do briefing antes de decompor o caso: é o que
alguém pensou e não fechou, e costuma ser exatamente a linha de argumento que
você está prestes a redescobrir do zero. E quando você precisar de um trecho que
sabe existir mas não sabe onde ("a gente já respondeu esse argumento em algum
lugar"), `acervo_buscar` — com `caso_id` para o caso, sem ele para o escritório
inteiro. Ela devolve trecho para você **localizar** e então abrir o registro.

Sem caso identificável, ou com o acervo respondendo `NAO_AUTENTICADO`: **siga
para o passo 1** e avise ao final que o eixo do acervo ficou de fora ("conecte a
conta do escritório para eu lembrar deste caso nas próximas conversas"). A peça
sai do mesmo jeito.

### 1. Decomponha o caso em teses

Liste as controvérsias que **decidem** o resultado. Separe **decisivas** (3 a 6,
vão às duas áreas) de **acessórias** (você redige sem consulta e diz ao usuário
que foram escritas sem apoio das bases). Mostre a lista e confirme antes de
gastar as chamadas.

### 2. Puxe o molde da casa

`ler_golden_set` e, havendo material, `abrir_peca_golden` nas peças do tipo mais
próximo. Extraia estrutura, tom e formatação — o molde, não o conteúdo. Sem
material, avise e siga com estrutura forense padrão.

### 3. Amparo — a espinha da peça

Para cada tese decisiva: `buscar_qualificada` (confira `status_vigencia`), depois
a lei (`obter_dispositivo_legal`, e `obter_alteracoes_norma` se a redação mudou
no período dos fatos), depois acórdãos (`buscar_hibrida`).

**Uma tese sem amparo não vira eixo de peça.** Se a controvérsia central não tem
tese firmada nem lei clara, diga isso ao usuário antes de escrever: ele decide se
quer sustentar assim mesmo.

### 4. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: não chame `resolver_juiz` nem `analisar_jurisprudencia`,
não peça o nome do juiz. **Redija pelo amparo.** Se o usuário pedir a
calibragem por magistrado, uma linha: o eixo está em pausa por cobertura.

### 5. Cruze e decida o que entra

Classifique cada tese na matriz. Com `posicao_juizo: sem_cobertura`, ela cai em:

- **amparo forte** → `amparo_solido_juizo_aberto` — abre a fundamentação; cite
  a tese firmada, e declare que o eixo do foro está em aberto;
- **amparo fraco** → `desconhecido` — entra como argumento de reforço, nunca
  como eixo;
- **amparo contra nós** → `descarte` — fora da peça; diga por quê.

### 6. Redija

Combine as fontes de linguagem: autoridade e citação **do amparo**, estrutura e
tom **da casa**. Confirme o balanço com o usuário se ele não tiver dito.

Cada citação carrega a origem: precedente com órgão, espécie e link oficial.

### 7. Feche com o mapa de apoio

Depois da peça, um bloco curto: eixo do foro em pausa; por tese, a célula da
matriz e as fontes que a sustentam; e o que na peça foi escrito sem apoio das
bases.

**É aqui que os links aparecem, sempre:** cada fonte do amparo usada na peça,
com o link que veio no resultado, clicável — o corpo da peça segue o molde da
casa, e o mapa de apoio é a lista de fontes que o advogado abre para conferir.
Gravar nas `fontes` da tese (passo 8) não substitui mostrar; nunca URL montada
de memória; se `link_aviso` disser que o direto pode não abrir, mostre com o
aviso e o `link_pesquisa_geral`; sem link no resultado, cite sem link.

### 8. Escreva de volta no acervo

Havendo caso identificado e conta conectada: as teses que entraram na peça vão
para `caso_registrar_tese` / `caso_atualizar_tese` (com `fontes` e `motivo`
obrigatório), a estratégia escolhida vai para `caso_gravar_memoria` tipo
`decisao`, e a própria peça vai para `caso_anexar_documento` com
`tipo: "peticao_nossa"`. **O que não é gravado, evapora**: na próxima conversa
ninguém saberá por que a peça foi escrita assim.

O que a redação levantou e não fechou — o argumento que você quase usou, a
suspeita sobre como a outra parte vai responder — vai para `caso_gravar_memoria`
tipo `hipotese`, `desfecho: "aberta"`. É o que faz a próxima peça começar de onde
esta parou.

**Você grava direto, e diz o que gravou.** Feche em **uma linha**, enumerando, e
convide a correção:

> "Gravei: 3 teses da peça (2 com amparo sólido e juízo em aberto, 1 de reforço),
> a decisão de deslocar a controvérsia para o dever de informar, a peça anexada e
> 1 hipótese aberta sobre a linha de defesa deles. Me diga se algo ficou errado
> que eu corrijo."

Errou? **Corrija o registro** (`caso_atualizar_tese`, `caso_atualizar_memoria`,
`caso_atualizar_fato`) em vez de gravar outro contradizendo o primeiro. A versão
anterior fica no histórico.

## Critério de parada

Pare quando toda tese decisiva tiver amparo verificado, célula atribuída (com o
eixo do foro declarado em pausa) e o mapa de apoio entregue.

## Erros a não cometer

- Pedir o nome do magistrado. O eixo do foro está em pausa.
- Chamar `resolver_juiz` ou `analisar_jurisprudencia` — ver `foro-em-pausa.md`.
- Fazer eixo da peça uma tese sem amparo, sem reformular nem avisar.
- Citar precedente sem checar vigência.
- Entregar a peça sem os links das fontes no mapa de apoio — ou com URL que não
  veio do resultado.
- Apresentar direito geral como se fosse achado das bases.
- Redigir sem olhar as hipóteses abertas — e refazer o raciocínio que alguém já
  tinha começado.
- **Gravar em silêncio** ou fechar com "gravei no acervo" sem enumerar o que.
- **Corrigir um registro seu escrevendo outro por cima** em vez de editar aquele.
