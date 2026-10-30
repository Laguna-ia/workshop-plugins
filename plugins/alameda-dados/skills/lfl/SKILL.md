---
name: lfl
description: Regra de like-for-like (LFL, lojas comparáveis) da Alameda e como calcular crescimento contra o ano anterior. Use quando uma análise comparar lojas, falar em crescimento, LFL, mesmas lojas, ou precisar decidir quais lojas entram numa comparação justa.
---

# LFL (like-for-like) — regra da Alameda

**Dona:** Larissa Campos · **Última revisão:** jul/2026

## Quando usar
- Crescimento de loja, regional ou rede contra o ano anterior.
- Qualquer comparação entre lojas que precise excluir lojas novas ("só lojas LFL", "lojas comparáveis").

## Regra
1. **Loja comparável**: 13 meses ou mais de operação no período analisado (`data_inauguracao` ≤ início do período − 13 meses). Loja nova fica fora até completar 13 meses.
2. **Ano anterior**: os mesmos dias da semana, 364 dias antes (segunda com segunda).
3. **Dia de loja fechada sai dos dois lados**, em qualquer um dos dois anos. Os fechamentos oficiais estão em `al_lojas_eventos` (tipo `fechamento`).
4. **Venda** = venda líquida (ver skill `venda-liquida`).
5. E-commerce fica fora do LFL de lojas.

## Onde está no Data Warehouse
- Query salva `vw_venda_lfl`: uma linha por loja e semana, com `loja_lfl`, `venda_atual`, `venda_ano_anterior`, `lfl_pct` e `dias_excluidos`.
- Para filtrar "só lojas LFL" em outra análise: use `al_lojas.data_inauguracao` com a regra do item 1.

## Como calcular
1. Filtre `loja_lfl = true`.
2. Para mês, trimestre ou regional: **some** `venda_atual` e `venda_ano_anterior` das semanas e recalcule o percentual. Nunca tire média dos `lfl_pct`.
3. Informe quantas lojas entraram e quais ficaram de fora (e por quê).

## Armadilhas
- Um fechamento informado por alguém (e-mail do gerente, por exemplo) que **não** está em `al_lojas_eventos` não é excluído pela query. Se a informação vier de outra fonte, tire esses dias manualmente, diga que fez isso e registre a fonte.
- Loja com vários dias sem venda e sem evento registrado: pergunte antes de concluir que a venda caiu.
- Loja reformada que ficou aberta continua no LFL.

## Como apresentar
LFL em % com uma casa decimal e sinal (+3,2% / −6,1%), período, número de lojas comparáveis e dias excluídos, quando houver.
