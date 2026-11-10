---
name: combater-peca
description: >
  Monta a resposta contra a peça da parte contrária, atacando pelo que o direito
  não sustenta (a calibragem por magistrado está em pausa). Acione quando o
  usuário trouxer a peça da OUTRA parte — "como eu ataco essa contestação?",
  "responde essa inicial", "quais os pontos fracos da peça deles", "monta a
  impugnação", "confere se os precedentes que eles citaram existem". Confere as
  citações da adversa contra a fonte oficial e inverte a polaridade da matriz: o
  que o amparo não sustenta é munição, o que tem amparo forte é o muro a
  contornar. Para peça nova use redigir-peca; para avaliar a peça do usuário use
  revisar-peca.
---

# Combater a peça da parte contrária

Objetivo: transformar o amparo em plano de ataque — saber, com evidência, o que
na peça adversa não se sustenta no direito (e como neutralizar).

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

## A inversão de polaridade

Nos fluxos REDIGIR e REVISAR você procura o que sustenta. Aqui é o contrário — e
é o erro mais comum. As teses que você manda às bases são **as da contrária**.

| No retorno | Fluxo redigir/revisar | Fluxo combater |
|---|---|---|
| **amparo forte** para a tese | é a sua espinha dorsal | é o **muro** que você precisa contornar |
| **amparo fraco / superado** | evite usar | é **munição** — o que o AMPARO não sustenta é munição |

Eixo do foro em pausa: classifique pelo amparo, `posicao_juizo: sem_cobertura`,
não peça o juiz. Quando o eixo religar (ver `foro-em-pausa.md`), a tabela
ganha de volta a coluna do juízo: juiz **acolheu** vira **risco real**, juiz
**refutou** vira **munição de foro**.

## Roteiro

### 0. Acervo — o que já sabemos deste embate

Se a peça adversa permite identificar o caso (número CNJ, partes, cliente) e a
conta do escritório está conectada: `caso_resolver` + `caso_obter_briefing` antes
de montar o ataque. O briefing traz `ameacas` e `decisoes` — o escritório pode já
ter escolhido a linha de defesa, e ataque que contradiz a estratégia da casa é
munição desperdiçada. As `instrucoes_ativas` são **restrições ao plano de
ataque**, não sugestões. `caso_listar_teses` com `polo: "adversa"` mostra o que
já foi mapeado da contrária: comece de onde o escritório parou. As **hipóteses
abertas** são a outra metade disso — o que alguém suspeitou sobre a estratégia da
contrária e não confirmou; a peça que chegou agora costuma ser exatamente a
prova que faltava.

E `acervo_buscar` **sem `caso_id`** responde a pergunta que só o acervo responde:
*"já enfrentamos esse escritório / esse argumento / esse perito antes?"*. Se a
mesma tese adversa já foi combatida em outro caso, o mapa está pronto e custou
caro. Ela devolve trecho para localizar; abra o registro para usar.

Sem caso identificável, ou com o acervo respondendo `NAO_AUTENTICADO`: **siga
para o passo 1** e avise ao final que o eixo do acervo ficou de fora ("conecte a
conta do escritório para eu lembrar deste caso nas próximas conversas"). O ataque
se monta igual.

### 1. Extraia as teses DA CONTRÁRIA

Liste o que a peça adversa sustenta e as **citações** que ela faz. Selecione as 3
a 6 decisivas — as que, se caírem, derrubam o pedido dela. Confirme com o usuário.

### 2. Confira as citações dela — o ataque mais barato

Antes do mérito, verifique se o que a adversa cita existe e vale:
`buscar_qualificada`, `buscar_por_cnj`, `buscar_fts`, `obter_dispositivo_legal`.

- **precedente superado ou cancelado** (`status_vigencia`) → ataque direto, com a
  tese vigente na mão. É a munição mais forte e mais fácil de sustentar;
- **redação de lei alterada** (`obter_alteracoes_norma`) → mostre a redação
  aplicável aos fatos;
- **citação que não localiza** → aponte, com a ressalva honesta de que a busca
  não localizou na base consultada.

### 3. Amparo das teses dela

Para cada tese decisiva da contrária, avalie o quanto ela se sustenta:
`buscar_qualificada` → lei → `buscar_hibrida`. Procure ativamente o
**contraponto**: tese firmada em sentido oposto, distinção reconhecida pelos
tribunais, corrente divergente.

### 4. Foro — em pausa (ver `references/foro-em-pausa.md`)

Eixo do foro em pausa: não chame `resolver_juiz` nem `analisar_jurisprudencia`,
não peça o nome do juiz. Ataque pelo amparo. Se o usuário perguntar se este juiz
compra o argumento da contrária, uma linha: o eixo está em pausa por cobertura,
e o ataque segue pelo amparo.

### 5. Classifique pelo amparo

- **munição** (amparo fraco ou superado) → abre o ataque; cite a tese vigente
  que derruba a citação dela;
- **muro** (amparo forte) → não ignore e não esconda do usuário. Escolha e
  declare a saída: **distinguishing** (mostre por que os fatos do caso não são
  os dos precedentes) ou **deslocamento** (mova a controvérsia para onde você é
  forte).

(Quando o eixo do foro religar, a classificação volta a cruzar com
`posicao_juizo`: munição dupla, munição de direito, munição de foro e risco
real — ver `foro-em-pausa.md`.)

### 6. Monte a peça de resposta

Ordene pela força da munição: comece pelas citações quebradas (superado /
inexistente), depois as teses sem amparo. Só então trate os muros, com a
estratégia declarada. Por fim, as teses **próprias** do usuário — para essas,
siga o roteiro de `redigir-peca`.

`ler_golden_set` + `abrir_peca_golden` nas peças de resposta/impugnação para o
molde da casa.

### 7. Entregue o mapa de combate

Eixo do foro em pausa; veredito das citações da adversa; por tese, a célula e as
fontes; para cada muro (amparo forte), a estratégia escolhida e por quê; e o que
ficou sem cobertura.

Cada fonte do amparo no mapa — inclusive a que desmente a citação da adversa —
vai **com o link que veio no resultado**, clicável. Gravar nas `fontes` da tese
(passo 8) não substitui mostrar aqui; nunca URL montada de memória; se
`link_aviso` disser que o direto pode não abrir, mostre com o aviso e o
`link_pesquisa_geral`; sem link no resultado, cite sem link.

### 8. Escreva de volta no acervo

Havendo caso identificado e conta conectada: as teses da contrária vão para
`caso_registrar_tese` com `polo: "adversa"`, `fontes` e `motivo` obrigatório — é
o mapa do adversário, e ele vale por todo o processo. A estratégia declarada em
cada muro (distinguishing ou deslocamento) vira `caso_gravar_memoria` tipo
`decisao`. A peça adversa vira `caso_anexar_documento` com
`tipo: "peticao_adversa"`. Citação da adversa que não confirmou vale registro:
`caso_registrar_fato` ou memória tipo `contexto`. **O que não é gravado,
evapora** — e nesse fluxo o desperdício é maior, porque o mapa da contrária custa
caro para refazer.

A leitura da estratégia adversa que você não consegue provar — *"eles estão
construindo para pedir perícia e ganhar tempo"*, *"a preliminar parece de
fachada, o eixo real é a decadência"* — é `caso_gravar_memoria` tipo `hipotese`,
`desfecho: "aberta"`. Não a registre como tese da adversa: tese adversa é o que a
peça **sustenta**, com fontes; isto é o que você **deduziu**. Confundir os dois
polui o mapa do adversário justamente onde ele precisa ser confiável. Quando a
próxima peça deles chegar, `caso_fechar_hipotese` fecha a hipótese como
`confirmada` ou `descartada` — e aí você sabe ler o adversário, não só reagir.

**Você grava direto, e diz o que gravou.** Feche em **uma linha**, enumerando, e
convide a correção:

> "Gravei: 4 teses da adversa com as fontes (2 com precedente superado), a
> decisão de distinguir os fatos no muro de amparo forte, a peça deles anexada e
> 2 hipóteses abertas sobre a estratégia. Me diga se algo ficou errado que eu
> corrijo."

Errou? **Corrija o registro** (`caso_atualizar_tese`, `caso_atualizar_memoria`,
`caso_atualizar_fato`) em vez de escrever outro por cima — a versão anterior fica
no histórico com o motivo.

## Critério de parada

Pare quando as citações da adversa estiverem conferidas, cada tese decisiva
classificada, cada risco com estratégia declarada e a peça montada.

## Erros a não cometer

- Ler o retorno com a polaridade do fluxo REDIGIR — o erro clássico é usar como
  munição uma tese da contrária que **tem amparo forte**: isso é muro, não
  munição.
- Mandar às bases as teses do usuário quando o pedido era atacar as da contrária.
- Esconder do usuário um argumento da contrária com amparo forte, tratando-o
  como se fosse munição.
- Chamar `resolver_juiz` ou `analisar_jurisprudencia` — o eixo do foro está em
  pausa (ver `foro-em-pausa.md`).
- Atacar com fundamento genérico quando as bases devolveram o fundamento exato
  que derruba a tese.
- Afirmar que um precedente citado pela adversa "não existe" quando o correto é
  "a busca não localizou".
- Registrar como **tese da adversa** o que você deduziu da estratégia dela — isso
  é `hipotese`, com `desfecho: "aberta"`. Tese adversa é o que a peça sustenta,
  com fonte.
- Montar o ataque sem `acervo_buscar` no escritório: o mesmo argumento pode já
  ter sido derrubado em outro caso, e refazer isso é o desperdício mais caro do
  produto.
- **Gravar em silêncio** ou fechar sem enumerar o que foi mapeado.
- **Corrigir um registro seu escrevendo outro por cima** em vez de editar aquele.
