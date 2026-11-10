# O eixo do foro está em pausa

O **eixo do foro** é a pergunta "o que ESTE juiz faz com isso?" — sentenças de
primeira instância cruzadas por magistrado, via `resolver_juiz` e
`analisar_jurisprudencia`, e as colunas "juiz acolhe" / "juiz refuta" da matriz
amparo × juízo.

**Está temporariamente em pausa**: a base cobre poucos magistrados hoje, e uma
calibragem sobre cobertura rala erra mais do que ajuda — parece achado e é
ruído. O servidor MCP **não anuncia** `resolver_juiz` nem `analisar_jurisprudencia`
enquanto durar a pausa; se chamadas mesmo assim, devolvem `FORO_EM_PAUSA`.

## O que você faz enquanto isso

- Classifique **só pelo amparo** (tese firmada, lei vigente, acórdãos) — o eixo 0
  → 1 → 3 do roteamento continua de pé, só o passo 2 (foro) some.
- Ao registrar tese no acervo, grave `posicao_juizo: "sem_cobertura"`. A célula
  que volta é `amparo_solido_juizo_aberto` (amparo forte), `desconhecido`
  (amparo fraco ou não coberto) ou `descarte` (amparo contra nós) — nunca
  `ancora` nem `conflito`, que dependem do juízo.
- **Não peça o nome do juiz.** Não é mais um dado que falta e se resolve
  perguntando — é um eixo que não está disponível para ninguém.
- **Não chame** `resolver_juiz` nem `analisar_jurisprudencia`. Ausência delas na
  lista de tools é esperada, não sinal de conector desligado.
- Se o usuário perguntar diretamente "como esse juiz decide isso?" — responda em
  **uma linha** que o eixo do foro está em pausa por cobertura, e siga a resposta
  pelo amparo.
- `ler_golden_set` e `abrir_peca_golden` continuam disponíveis: são peças-padrão
  do escritório, não dependem de magistrado.

## Como religa

Quando a cobertura crescer, o servidor volta a anunciar `resolver_juiz` e
`analisar_jurisprudencia`. Nesse momento: este arquivo sai, as notas "em pausa"
saem de `areas-e-roteamento.md`, das skills e do README, e `protocolo-oraculo.md`
perde o bloco de aviso no topo — o desenho dele já estava pronto para isso.
