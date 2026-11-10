---
name: abrir-cliente
description: >
  Faz o onboarding de um cliente NOVO pelo caminho comercial, cadastrando de
  verdade — a porta de entrada pelo CLIENTE: cliente_resolver para não duplicar →
  cliente_criar (razão social, CNPJ, grupo econômico) → cliente_adicionar_pessoa
  (cargo e e-mails) → contrato_criar (modalidades combináveis fixo/hora/êxito,
  gatilho de êxito em TEXTO LIVRE, transcrito literal) → caso_vincular_cliente e
  caso_vincular_contrato quando houver caso. Cruza as coligadas do grupo:
  conflito de interesse. Acione em "cliente novo chegou", "cadastra esse
  cliente", "monta o contrato desse cliente", "esse cliente já está no sistema?".
  CNPJ já cadastrado volta AMBIGUO — segue do existente, nunca duplica. O
  cadastro entra valendo e é dito item a item, para o usuário corrigir na hora.
  Para começar pelo processo, abrir-caso; caso existente, acompanhar-caso.
---

# Abrir o cliente

Objetivo: transformar "chegou um cliente novo" em **cadastro comercial de pé** —
cliente, pessoas de contato, contrato com as modalidades e o gatilho de êxito
transcritos do papel, e o primeiro caso pendurado nisso tudo.

Esta é a porta **comercial**. `abrir-caso` entra pelo processo e resolve o
cliente como pendência de cadastro; aqui é o contrário: o cliente vem primeiro, o
caso vem no fim. As duas convergem para o mesmo estado final. Quando o usuário já
tem o processo na mão e quer as teses, **não é esta skill** — passe para
`abrir-caso`.

Leia `references/areas-e-roteamento.md` antes da primeira
chamada de tool.

## O que você cadastra, e em que estado

Você **cadastra de verdade**: `cliente_criar`, `cliente_adicionar_pessoa` e
`contrato_criar` gravam no CRM do escritório, e `caso_vincular_cliente` /
`caso_vincular_contrato` penduram o caso nisso.

O que nasce daí **está valendo**. Não há Fila de Revisão, não há rascunho, não há
um humano a jusante conferindo antes de o cadastro virar real. O humano é o que
está nesta conversa — e a proteção dele é você **dizer o que gravou, na hora**,
com o valor de cada campo que importa.

Nesta skill isso pesa mais que nas outras, porque aqui se cadastra **dinheiro**:
percentual, base de cálculo, gatilho de êxito. Um contrato com o percentual
trocado não dá erro em lugar nenhum — ele só aparece na hora de faturar. Então:
leia de volta ao usuário o que você gravou do contrato, com o gatilho entre
aspas, antes de seguir.

Se algo saiu errado, **corrija o registro** — não crie um segundo cliente com a
grafia certa, não crie um segundo contrato "atualizado". Toda edição guarda a
versão anterior, então corrigir é barato e não apaga o histórico; duplicar é o
que quebra o CRM.

Se as tools do acervo responderem `NAO_AUTENTICADO`, o trabalho de coleta e
organização continua valendo: entregue a ficha organizada em texto, e diga que o
cadastro ficou de fora até a conta do escritório ser conectada. Em
`SOMENTE_LEITURA`, mostre exatamente o que você **teria** gravado e diga que o
escopo de escrita depende do administrador.

## Roteiro

### 1. Esse cliente já existe? — `cliente_resolver`, sempre

Cliente duplicado é pior que caso duplicado: dois cadastros com o mesmo CNPJ
significam dois contratos divergentes, faturamento partido em dois e ninguém
sabendo qual vale.

`cliente_resolver` com o que o usuário deu — razão social, CNPJ ou o nome do
grupo econômico.

- `resolved: true` → **o cliente já está no CRM.** Diga isso, mostre o que o
  acervo tem dele (`escritorio_listar_casos` com `busca` no nome, contrato via
  `caso_obter_contrato` num dos casos) e **siga a partir do existente**: o
  trabalho útil vira acrescentar a pessoa de contato que faltava, o contrato novo
  ou o caso novo sob o cliente que já há.
- `resolved: false` com `candidatos` → **mostre e pergunte.** Nunca escolha por
  conta própria e nunca crie um segundo cadastro "por segurança".
- Nada encontrado → cliente novo. Siga.

`cliente_resolver` casa por razão social, CNPJ e grupo. Quando o usuário chega
pelo assunto e não pelo nome — "o cliente daquele contrato de teto de horas", "a
empresa do caso do perito X" — `acervo_buscar` **sem `caso_id`** acha onde aquilo
foi registrado e de que caso é. Procure antes de perguntar: o que o escritório já
anotou, o advogado não deveria precisar digitar de novo.

### 2. O cliente — `cliente_criar`

Colete, nesta ordem, e pergunte pelo que faltar em vez de preencher por conta:

| Campo | Cuidado |
|---|---|
| **`razao_social`** | a do contrato social, não o nome fantasia. Se o usuário deu o fantasia, pergunte a razão e registre os dois (o fantasia cabe no `contexto`). |
| **`cnpj`** | **nunca invente e nunca complete.** Sem CNPJ, o campo fica vazio e vira pendência de peso baixo — CNPJ errado contamina nota fiscal e conciliação. |
| **`grupo_economico`** | quem é a matriz, quais as coligadas que podem virar parte. É o que evita descobrir conflito de interesse depois do contrato assinado. |
| **`contexto`** | obrigatório e não decorativo: de onde veio a informação ("contrato social enviado pelo cliente", "o usuário informou em conversa, sem documento"). É o que permite a quem ler depois confiar ou desconfiar de cada campo — proveniência responde *de onde veio*, e continua obrigatória. |

Cliente pessoa física existe: `razao_social` vira o nome civil e `cnpj` vira CPF.
Não force o cadastro de PJ em cima de pessoa física.

**Se a tool devolver `AMBIGUO`**, é porque o CNPJ já está no tenant. Ela devolve o
cliente existente junto. **Não duplique, não tente outra grafia da razão social,
não force**: mostre o cliente que veio, diga que ele já está cadastrado e siga
dele. Este é o caminho mais fácil de sujar um CRM, e a tool está te protegendo.

O responsável no escritório pelo cliente (o sócio dono da relação) não é campo de
`cliente_criar` — registre-o em `caso_gravar_memoria` como `contexto` quando
houver caso, ou declare na linha de fechamento que ficou sem registro.

**Levante o conflito de interesse.** Com o grupo econômico na mão, rode
`escritorio_listar_casos` com `busca` nos nomes das coligadas: se alguma aparece
como parte **adversa** em caso do escritório, isso vai para o topo do relatório,
antes de qualquer conversa de honorário. Você não decide se há impedimento —
**mostra o achado e deixa a decisão com o advogado.**

### 3. As pessoas do cliente — `cliente_adicionar_pessoa`

Uma chamada por contato, com `cliente_id`, `nome`, `cargo` e `emails[]` (o campo
aceita vários).

Os e-mails não são decoração de agenda: é por eles que o produto vai, adiante,
separar a correspondência que importa da caixa inteira. E-mail pessoal do contato
vale tanto quanto o corporativo — e um contato sem e-mail é meio contato.

Pergunte **quem decide** e **quem opera**: são quase sempre pessoas diferentes, e
confundi-los produz relatório mandado para quem não decide e cobrança mandada
para quem não paga. Registre o papel no `cargo` quando o título não disser
("Controladoria — é quem aprova as notas").

### 4. O contrato — `contrato_criar`

Este é o passo em que a maioria dos cadastros erra. Três regras, todas de
produto:

**a) As modalidades são combináveis — `fixo`, `hora`, `exito`.** `modalidades` é
uma lista e aceita as três juntas. **Não peça ao usuário para escolher uma.**
Quase todo contrato real é híbrido: fixo mensal de retainer **mais** êxito sobre
a condenação, ou hora com teto **mais** êxito. Se o usuário descrever duas formas
de cobrança, mande as duas.

Colete o que cada modalidade pede:

- `fixo` → valor mensal, cronograma de parcelas;
- `hora` → valor/hora por senioridade, teto, periodicidade de faturamento;
- `exito` → `percentual`, `base_calculo_texto` e `gatilho_texto`.

**b) `gatilho_texto` é TEXTO LIVRE — transcreva literal.** A cláusula entra como
está escrita no papel: *"se houver sentença de improcedência transitada em
julgado"*, *"na hipótese de acordo homologado antes da sentença, sobre o valor
efetivamente economizado"*. Isso é linguagem de contrato.

**Nunca tente extrair dali percentual, data ou condição estruturada, e nunca
normalize em enum, categoria ou paráfrase** — o enum não tem a exceção, não tem o
"salvo se", não tem a base de cálculo negociada às três da manhã. A mesma regra
vale para `base_calculo_texto`.

Você **lê o texto, compara com os fatos do caso e propõe**. Nunca conclui. Nunca
faz match de palavra-chave ("a sentença saiu, logo o gatilho disparou" é
exatamente o erro). Quando um andamento parecer atingir o gatilho, o caminho é
`caso_registrar_evento_contrato` com `tipo: "gatilho_exito"` e `justificativa`
dizendo em que você se baseou.

**O que você grava ali é uma proposta, e o texto tem que dizer isso.** O registro
entra no acervo como qualquer outro — o que o mantém no lugar certo não é um
portão de aprovação, é a `justificativa` e a sua frase ao usuário: "isto me
parece atingir o gatilho da cláusula X pelo motivo Y — confirma?". **Nunca diga
que houve cobrança, que o êxito foi apurado, ou que o valor é devido.** Dinheiro
é a única coisa em que a IA não fecha a conclusão sozinha, e essa regra não caiu
junto com a Fila de Revisão: ela nunca dependeu dela.

**c) Um contrato pode cobrir N casos.** Retainer é a regra, não a exceção: um
contrato guarda-chuva com o cliente e cinco casos pendurados nele, via
`caso_vincular_contrato` em cada um. **Não presuma 1:1** e não crie um contrato
novo a cada processo — pergunte se o caso novo entra no contrato existente ou
pede contrato próprio. Antes de criar, veja o que o cliente já tem
(`caso_obter_contrato` num caso dele).

Se o usuário colou o contrato, `caso_anexar_documento` com `tipo: "contrato"` no
caso a que ele se refere, com um `resumo_linha` que diga a um colega o que é
aquilo sem abrir o arquivo.

### 5. O primeiro caso — e os vínculos

Com cliente, pessoas e contrato cadastrados, pergunte qual é o caso que abre a
relação. A partir daqui **o roteiro é o de `abrir-caso`**: `caso_resolver` para
não duplicar, oferecer a abertura, confirmar o que você extraiu (sobretudo os
polos), `caso_criar`, documento anexado — e o checkpoint daquela skill, onde o
advogado decide se quer o amparo das teses e o monitoramento do tribunal.

Criado o caso, feche os vínculos você mesmo — é o que evita o caso órfão:

- `caso_vincular_cliente` com o `cliente_nome` (a `razao_social` do passo 2), o
  `caso_titulo` (do caso que você acabou de criar) e o `cliente_id` do passo 2;
- `caso_vincular_contrato` com o `caso_titulo`, o `contrato_descricao` (o
  `codigo` do passo 4, ou a razão social do cliente se o contrato não tem
  código) e o `contrato_id` do passo 4.

Os dois nomes vão para o cartão de permissão que o advogado lê; o servidor
confere cada um contra o id antes de gravar.

Os dois retornos trazem `pendencias_cadastro` e `aviso_cadastro` atualizados.
**Leia o retorno**, não a sua memória do que faltava, e use-o no fechamento.

Não refaça aqui o levantamento de teses: mude para `abrir-caso`. Esta skill
entrega a fronteira comercial; a outra entrega o caso — e é lá que o advogado
escolhe se quer o levantamento jurídico agora, no checkpoint daquela skill. Nem
aqui nem lá o amparo se dispara por conta própria.

Se ainda não há caso — cliente contratado sem demanda distribuída — está ótimo:
feche sem caso, e diga que o cadastro comercial está de pé esperando o primeiro.

### 6. Grave o que só existe nesta conversa

`caso_gravar_memoria`, no caso quando já houver um:

- `contexto` — o que o contrato não diz e o cliente disse: quem é o interlocutor
  real, quem é o responsável pela relação no escritório, a expectativa que ele
  trouxe, o histórico com o escritório anterior;
- `instrucao` — a regra que deve valer daqui em diante ("cliente não aceita
  acordo abaixo de 60%", "toda comunicação passa pela controladoria"). Se ela
  vale para **todos** os casos deste cliente e não só para um, use
  `escopo: "escritorio"`. Instrução entra no briefing e condiciona toda
  recomendação futura — é a alavanca mais forte que o advogado tem sobre o
  sistema;
- `hipotese` — a leitura comercial que ninguém verificou e que ninguém quer
  refazer: *"acho que eles vão querer testar o escritório num caso pequeno antes
  de trazer a carteira"*, *"desconfio que a controladoria é quem manda, não o
  jurídico"*. Com `desfecho: "aberta"`. Não é contexto (não é fato) nem
  instrução (não é ordem) — é o que se aprende sobre um cliente nos primeiros
  meses e evapora se ninguém escrever.

Não havendo caso ainda, isso fica na linha de fechamento, para você gravar quando
o primeiro caso nascer. **Não invente um caso só para ter onde gravar.**

### 7. Feche — o que foi cadastrado, e o que ficou faltando

O relatório final:

1. **CONFLITO DE INTERESSE**, se houver achado — primeiro de tudo, antes de
   honorário.
2. **CLIENTE** — `cliente_id`, razão social, CNPJ, grupo econômico. Marque
   `— falta` no que ficou vazio, em vez de omitir a linha.
3. **PESSOAS** — uma linha por contato: nome · cargo · e-mails.
4. **CONTRATO** — `contrato_id`, modalidades cadastradas (as que forem), valores
   de cada uma, percentual de êxito e o **gatilho transcrito entre aspas**,
   literal, como ele foi gravado.
5. **CASO** — o que foi criado no acervo (se foi), com `caso_id`, os vínculos
   feitos, e o `aviso_cadastro` do último retorno **em uma linha**.

E a **linha de fechamento**, obrigatória: o que você gravou, e o convite à
correção — com o cuidado explícito nos números.

> "Cadastrei: 1 cliente, 2 pessoas, 1 contrato (fixo de R$ 12 mil/mês + 20% de
> êxito) e 1 caso vinculado aos dois. Confira sobretudo o percentual e o gatilho
> que transcrevi — me diga se algo ficou errado que eu corrijo. Ainda falta no
> cadastro: CNPJ da coligada, teto de horas e a equipe do caso."

Apontado o erro, **corrija o registro** com a tool de edição e diga o que mudou
(`versao_anterior` → `versao_nova`). Nunca resolva um campo errado criando um
cadastro novo ao lado.

## Não vire formulário

O cadastro comercial é meio, não fim. Feche o que é de peso alto — quem é o
cliente, quem está do outro lado no caso — e deixe o resto declarado em uma
linha. Se o usuário disser "depois", é depois: `aviso_cadastro` vai lembrá-lo na
próxima conversa sobre o caso, **uma vez, no fechamento**. Aviso repetido a cada
mensagem é aviso que o usuário aprende a pular.

## Critério de parada

Pare quando cliente, pessoas e contrato estiverem cadastrados com o que se sabe,
o conflito de interesse conferido, os vínculos feitos, e o primeiro caso ou
aberto (via `abrir-caso`) ou declaradamente inexistente. Feito isso, **pergunte o
que ele quer agora** em vez de escolher por ele — levantar o amparo das teses do
caso, ligar o monitoramento do processo, ou parar aqui. Não fique perguntando
dado que o usuário já disse que não tem — vira pendência declarada, não
interrogatório.

## Erros a não cometer

- **Duplicar cliente.** `cliente_resolver` antes de tudo; e `AMBIGUO` de
  `cliente_criar` significa seguir do existente, nunca insistir.
- Escolher sozinho entre os `candidatos` de um `resolved: false`.
- Inventar ou completar CNPJ.
- **Travar o cadastro por falta de dado.** Cadastre com o que tem; o que falta é
  declarado, não impeditivo.
- Forçar **uma** modalidade quando o contrato é híbrido.
- **Normalizar o gatilho de êxito** em enum, categoria, percentual, data ou
  paráfrase. Transcreva literal.
- Concluir que um gatilho disparou, ou falar em cobrança/êxito apurado. Você
  **propõe**, com justificativa, e diz que é proposta.
- Presumir um contrato por caso quando o cliente é de retainer.
- Criar o caso e **esquecer `caso_vincular_cliente` / `caso_vincular_contrato`** —
  é exatamente assim que nasce caso órfão.
- Deduzir quem é o cliente do escritório entre as partes do processo — pergunte.
- Passar por cima do conflito de interesse porque a conversa era comercial.
- Refazer aqui o levantamento de teses em vez de mudar para `abrir-caso`.
- **Fechar com "cadastrei tudo"** sem ler de volta o que foi gravado — sobretudo
  percentual, base de cálculo e gatilho.
- **Corrigir um cadastro seu criando outro ao lado.** Edite o registro; a versão
  anterior fica guardada.
- Terminar sem dizer o que ficou faltando no cadastro.
