---
name: sell-through
description: Regra de sell-through da Alameda (quanto da coleção recebida já foi vendida). Use quando uma análise falar em sell-through, desempenho de coleção, giro de coleção, sobra de coleção ou candidatos a remarcação.
---

# Sell-through — regra da Alameda

**Dono:** Felipe Araújo · **Última revisão:** set/2026

## Quando usar
Para avaliar como uma coleção está vendendo numa loja, regional ou formato de loja, e para decidir remarcação (markdown).

## Regra
1. **Sell-through = peças vendidas líquidas / peças recebidas**, desde a data de lançamento da coleção até a data de corte.
2. Vendidas líquidas = `qtd − qtd_devolvida` em `al_vendas`.
3. Recebidas = `al_recebimentos` (notas de transferência do CD para a loja) a partir do lançamento.
4. Só para coleções com lançamento: **Inverno 26** (06/04/2026) e **Verão 27** (14/09/2026). A linha Permanente é reposição contínua: use cobertura.
5. Referência interna: Inverno 26 deveria fechar o 6º mês acima de 65%.

## Onde está no Data Warehouse
- Query salva `vw_sell_through_colecao`: loja × coleção, com `recebidas`, `vendidas` e `sell_through_pct`.
- `vw_excesso_markdown` combina sell-through baixo com cobertura alta.

## Como calcular agregados
Para regional, formato ou faixa de tamanho de loja, **some** vendidas e recebidas e recalcule. Nunca tire média dos percentuais das lojas.

## Armadilhas
- Coleção nova tem sell-through naturalmente baixo nas primeiras semanas: compare com o mesmo número de semanas de outra coleção, não com o fechamento.
- Sell-through baixo com cobertura alta = estoque parado ocupando área de venda.
- Sell-through muito alto cedo pode indicar ruptura, não sucesso: cheque o estoque.

## Como apresentar
Percentual com uma casa decimal, coleção, semanas desde o lançamento e a referência interna.
