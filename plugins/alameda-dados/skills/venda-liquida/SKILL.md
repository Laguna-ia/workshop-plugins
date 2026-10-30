---
name: venda-liquida
description: Definição oficial de venda da Alameda (venda líquida) e como calcular venda contra meta por loja, regional, semana ou mês. Use sempre que uma análise, relatório ou apresentação falar em venda, faturamento, receita ou atingimento de meta.
---

# Venda líquida — definição oficial da Alameda

**Dono:** Thiago Nunes · **Última revisão:** ago/2026

## Quando usar
Sempre que alguém pedir "venda", "faturamento", "receita" ou "% da meta" de loja, regional, rede ou e-commerce. Se ninguém disser qual venda, é esta.

## Definição
**Venda líquida = receita bruta − devoluções feitas em até 30 dias da venda.**

- Combinado com a Controladoria em mar/2025: devolução depois de 30 dias vira ajuste contábil e não volta para a venda.
- É a única definição aceita em material para a diretoria e o conselho.
- Meta = `al_metas_mensais` (mês) ou `al_metas_semanais` (semana comercial, segunda a domingo), sempre em venda líquida.

## Onde está no Data Warehouse
| Recorte | Query salva |
| --- | --- |
| Mês por loja, com meta | `vw_venda_liquida_mensal` |
| Semana por loja, com meta | `vw_venda_liquida_semanal` |
| Coluna base | `al_vendas.receita_bruta − al_vendas.receita_devolvida_30d` |

Prefira rodar a query salva (`run_saved_query`) e filtrar por `mes`, `semana_ini`, `regional` ou `loja_id`. Para recortes que a query não tem, use `run_sql` com a mesma conta.

## Como calcular
1. Some `venda_liquida` e `meta` do recorte pedido. Para trimestre, some os três meses.
2. % da meta = venda líquida / meta × 100, com uma casa decimal.
3. O e-commerce aparece como loja `ECOM`, regional "E-commerce". Diga se o número inclui ou não o e-commerce.

## Armadilhas
- **Não use `rel_venda_bruta_regional`** para números oficiais: é o relatório legado em venda bruta e dá um número cerca de 5% maior.
- Nas semanas mais recentes as devoluções de 30 dias ainda estão chegando: sinalize que a venda dessas semanas é provisória.
- Nunca tire média de percentuais de atingimento entre lojas: recalcule a partir das somas.
- Loja sem venda em dias seguidos não é "venda baixa" antes de checar se ela estava fechada.

## Como apresentar
- Valores em R$ com milhar (R$ 1,24 mi; R$ 312 mil).
- Sempre: período, se é venda líquida, se inclui e-commerce e a data de corte do snapshot.
- Cite a query de origem de cada número.
