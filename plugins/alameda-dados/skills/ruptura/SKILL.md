---
name: ruptura
description: Regra de ruptura da Alameda para SKUs A (falta de produto na gôndola), incluindo a ruptura fantasma e a venda perdida estimada. Use quando uma análise falar em ruptura, falta de produto, SKU zerado, disponibilidade, estoque fantasma ou preparação para a Black Friday.
---

# Ruptura de SKUs A — regra da Alameda

**Dono:** Thiago Nunes · **Última revisão:** set/2026

## Quando usar
Para saber o que está faltando nas lojas, priorizar reposição e preparar datas de pico, como a Black Friday.

## Regra
1. Só **SKUs A da loja**, pela curva ABC do **último mês fechado** (ver `curva-abc`).
2. Um SKU A está em ruptura no dia quando:
   - **estoque do sistema = 0** → tipo `estoque_zero`;
   - **estoque > 0, mas sem venda há 15 dias ou mais** → tipo `sem_venda_15d`.
3. O tipo `sem_venda_15d` é a **ruptura fantasma**: o sistema diz que tem, mas o produto não está na gôndola (perdido no depósito, avariado ou erro de inventário). **Só a loja consegue confirmar.**
4. `dias_em_alerta` = dias seguidos em ruptura até a data.
5. **Venda perdida estimada** = venda líquida média diária do SKU na loja nos 28 dias antes do início do alerta × dias em alerta. É estimativa para priorizar, não número contábil.
6. **Taxa de ruptura** = alertas / SKUs A da loja na curva de referência.

## Onde está no Data Warehouse
Query salva `vw_ruptura_lojas` (agendada todo dia às 5h): uma linha por alerta e dia, de 01/09/2026 até a data de corte, com `tipo_alerta`, `inicio_alerta`, `dias_em_alerta`, `ultima_venda`, `venda_media_diaria_28d` e `venda_perdida_estimada`. Para a foto do dia, filtre `data` = data de corte.

## Como analisar
1. Conte alertas por regional e por tipo. Compare com a participação da regional no número de lojas.
2. Ordene por `venda_perdida_estimada` para priorizar.
3. Separe o que é **reposição** (`estoque_zero`) do que precisa de **confirmação da loja** (`sem_venda_15d`).

## Armadilhas
- Não mande reposição para alerta `sem_venda_15d` sem a loja confirmar: se o produto estiver lá, é ajuste de inventário, não compra.
- SKU descontinuado pode aparecer como alerta: a loja informa e ele sai da lista.
- Taxa de ruptura de meses diferentes usa curvas ABC diferentes: diga qual curva foi usada.

## Como apresentar
Data da foto, número de alertas, tipo, venda perdida estimada em R$ e a lista priorizada por loja.
