---
name: curva-abc
description: Regra da curva ABC da Alameda (classificação A, B e C de produtos por loja). Use quando uma análise falar em curva ABC, SKUs A, produtos mais importantes, sortimento, mix ou priorização de produtos.
---

# Curva ABC — regra da Alameda

**Dona:** Larissa Campos · **Última revisão:** mai/2026

## Quando usar
Para dizer quais produtos importam mais numa loja, priorizar reposição e ruptura, discutir sortimento ou explicar o conceito para a diretoria.

## Regra
1. Base: **receita líquida** do SKU no mês (ver `venda-liquida`). Não use peças nem receita bruta.
2. A curva é **por loja**: o mesmo SKU pode ser A em Recife e B em Curitiba. Para a rede, recalcule somando a receita de todas as lojas.
3. Cortes: **A até 80%** da receita acumulada, **B até 95%**, C o resto. O SKU que cruza o corte fica na classe de cima.
4. SKU sem venda no mês não aparece e, para sortimento, é C.
5. Ruptura e Black Friday usam a curva do **último mês fechado**.

## Onde está no Data Warehouse
Query salva `vw_curva_abc_mensal` (agendada todo dia 1, às 4h): loja × mês × SKU, com `participacao_pct`, `acumulada_pct` e `classe`.

## Como explicar para quem não é de dados
"Na Alameda, cerca de 20% dos produtos de cada loja fazem 80% da venda. Esses são os SKUs A: se faltam, a loja perde venda de verdade. Por isso o alerta de ruptura olha só para eles."

## Armadilhas
- Não compare curvas de meses diferentes sem dizer qual mês foi usado.
- Coleção recém-lançada entra devagar na curva: um SKU de Verão 27 pode virar A só no segundo mês.
- Contagem de SKUs A varia por loja (lojas grandes trabalham mais SKUs).

## Como apresentar
Indique loja, mês de referência, número de SKUs por classe e a participação de cada classe na receita.
