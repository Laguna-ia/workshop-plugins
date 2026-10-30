---
name: cobertura-estoque
description: Regra de cobertura de estoque da Alameda (quantos dias de venda o estoque cobre). Use quando uma análise falar em cobertura, dias de estoque, excesso de estoque, estoque parado ou risco de faltar produto.
---

# Cobertura de estoque — regra da Alameda

**Dona:** Marina Sato · **Última revisão:** jul/2026

## Quando usar
Para medir excesso ou falta de estoque por SKU, loja, regional ou formato, e para priorizar transferência, reposição ou remarcação.

## Regra
1. **Cobertura (dias) = estoque na data de corte / venda média diária em peças líquidas dos últimos 28 dias.**
2. 28 dias = 4 semanas cheias, para tirar o efeito do dia da semana.
3. Sem venda nos 28 dias e com estoque: cobertura nula e `sem_giro = true`. É produto parado, não "cobertura infinita".
4. **Cobertura de um grupo** (loja, regional, formato) = soma do estoque / soma da venda média diária. Nunca tire média das coberturas.
5. Referência da rede: ~55 dias. Acima de 90 dias é excesso.

## Onde está no Data Warehouse
- Query salva `vw_cobertura_estoque`: loja × SKU na data de corte, com `qtd_estoque`, `venda_media_diaria`, `cobertura_dias` e `sem_giro`.
- O estoque é o do **sistema** (`al_estoque`). Ele pode divergir do físico até o próximo inventário.

## Armadilhas
- Cobertura alta numa loja grande pode ser só área sobrando cheia de produto: olhe junto com sell-through e venda por m².
- Cobertura baixa com venda alta pode ser ruptura chegando: confira com a skill `ruptura`.
- Não compare cobertura de coleção nova com a de Permanente.

## Como apresentar
Dias com zero casas decimais, a data de corte, e a referência de 55 dias ao lado.
